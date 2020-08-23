'''Defines the `compile_and_jar_java_sources` function.

This function is meant to be used by a few different rules which build Java
sources. For example, `java_library`, `java_binary`, and `java_test`.
'''

load("//java:providers/JavaCompilationInfo.bzl", "JavaCompilationInfo")
load("//java:providers/JavaDependencyInfo.bzl", "JavaDependencyInfo")
load("//java:common/actions/write_java_sources_args_file.bzl", "write_java_sources_args_file")
load("//java:common/actions/write_class_path_args_file.bzl", "write_compile_time_class_path_args_file")

_JAVA_COMPILER_TOOLCHAIN_TYPE = "@dwtj_rules_java//java/toolchains/java_compiler_toolchain:toolchain_type"

def compile_and_jar_java_target(ctx):
    '''Interprets a Java target's `ctx` & calls `compile_and_jar_java_sources`.

    This helper function extracts information from a Java rule's `ctx` object
    (according to some conventions shared across various Java rules), creates
    a `JavaCompilationInfo` instance, and calls `compile_and_jar_java_sources`.

    Args:
      ctx: A rule `ctx` instance following various Java rule conventions needed
        to compile Java sources. These conventions include well-defined:

        - a `srcs` attribute (where all elements are `File`s)
        - a `deps` attribute (where all elements provide `JavaDependencyInfo`)
        - a Java compiler toolchain

    Returns:
      A `JavaCompilationInfo` describing the compilation of Java sources for
      this target. This object's `class_files_output_jar` field will be assigned
      a `File` named `<target_name>.jar`.
    '''
    maybe_main_class = None if not hasattr(ctx.attr, "main_class") else ctx.attr.main_class

    srcs_args_file = write_java_sources_args_file(
        name = ctx.attr.name + ".java_srcs.args",
        srcs = ctx.files.srcs,
        actions = ctx.actions,
    )

    java_compilation_info = JavaCompilationInfo(
        srcs = depset(ctx.files.srcs),
        srcs_args_file = srcs_args_file,
        class_path_jars = depset(
            direct = [],
            transitive = [dep[JavaDependencyInfo].compile_time_class_path_jars for dep in ctx.attr.deps],
        ),
        class_files_output_jar = ctx.actions.declare_file(ctx.attr.name + ".jar"),
        additional_jar_manifest_attributes = ctx.attr.additional_jar_manifest_attributes,
        main_class = maybe_main_class,
    )

    compile_and_jar_java_sources(
        label = ctx.label,
        compilation_info = java_compilation_info,
        compiler_toolchain_info = ctx.toolchains[_JAVA_COMPILER_TOOLCHAIN_TYPE].java_compiler_toolchain_info,
        actions = ctx.actions,
        temp_file_prefix = ctx.attr.name
    )
    return java_compilation_info

def compile_and_jar_java_sources(label, compilation_info, compiler_toolchain_info, actions, temp_file_prefix):
    '''Invokes `javac` on Java sources and then `jar`s the results.

    To create the output JAR, some temporary temporary files are created (e.g.
    the generated `.class` files and the build script which calls the `javac`
    and `jar` commands.) The `temp_file_prefix` argument is used as a prefix for
    file paths to help prevent these files from conflicting.

    Args:
      label: The label of the Java target to be built.
      compilation_info: A `JavaCompilationInfo` provider instance.
      compiler_toolchain_info: A `JavaCompilerToolchainInfo` provider instance.
      actions: The `actions` instance from which actions are emitted.
      temp_file_prefix: A string to prefix to the name of temporary files. This
        is conventionally the name of the target calling this function.

    Returns:
      `None`
    '''

    # Use a helper function to declare, build and write an @args file for the
    #  `javac` class path:
    class_path_args_file = write_compile_time_class_path_args_file(
        name = temp_file_prefix + ".compile_time_class_path.args",
        jars = compilation_info.class_path_jars,
        actions = actions,
        class_path_separator = compiler_toolchain_info.class_path_separator
    )

    # Declare, build and write a JAR manifest file:
    jar_manifest_file = actions.declare_file(temp_file_prefix + ".additional_jar_manifest_attributes")
    jar_manifest_args = actions.args()
    if compilation_info.main_class != None:
        jar_manifest_args.add(
            compilation_info.main_class,
            format = "Main-Class: %s",
        )
    jar_manifest_args.add_all(
        compilation_info.additional_jar_manifest_attributes,
        omit_if_empty = False,
    )
    jar_manifest_args.set_param_file_format("multiline")
    actions.write(
        output = jar_manifest_file,
        content = jar_manifest_args,
        is_executable = False,
    )

    # Declare and instantiate the script which calls `javac` & `jar`.
    output_jar = compilation_info.class_files_output_jar
    compile_and_jar_script = actions.declare_file(temp_file_prefix + ".compile_java_binary_to_jar.sh")
    actions.expand_template(
        output = compile_and_jar_script,
        template = compiler_toolchain_info.compile_and_jar_java_sources_script_template,
        substitutions = {
            "{JAVAC_EXECUTABLE}": compiler_toolchain_info.javac_executable.path,
            "{CLASS_OUTPUT_DIRECTORY}": temp_file_prefix + ".classes.temp",
            "{JAR_EXECUTABLE}": compiler_toolchain_info.jar_executable.path,
            "{CLASS_PATH_ARGS_FILE}": class_path_args_file.path,
            "{JAVA_SRCS_ARGS_FILE}": compilation_info.srcs_args_file.path,
            "{JAR_MANIFEST_FILE}": jar_manifest_file.path,
            "{OUTPUT_JAR}": output_jar.path,
        },
        is_executable = True,
    )

    # Run the just-created script.
    actions.run(
        executable = compile_and_jar_script,
        outputs = [
            output_jar
        ],
        inputs = depset(
            direct = [
                class_path_args_file,
                compilation_info.srcs_args_file,
                jar_manifest_file,
            ],
            transitive = [
                compilation_info.srcs,
                compilation_info.class_path_jars,
            ],
        ),
        tools = [
            compiler_toolchain_info.jar_executable,
            compiler_toolchain_info.javac_executable
        ],
        mnemonic = "CompileJavaJar",
        progress_message = "Compiling and archiving Java target `{}`".format(label),
        use_default_shell_env = False,
    )
