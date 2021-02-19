'''Defines the `compile_java_jar` function.

This function is meant to be used by a few different rules which build Java
sources. For example, `java_library`, `java_binary`, and `java_test`.
'''

load("//java:providers/JavaCompilationInfo.bzl", "JavaCompilationInfo")
load("//java:providers/JavaDependencyInfo.bzl", "JavaDependencyInfo")
load("//java:common/actions/write_java_sources_args_file.bzl", "write_java_sources_args_file")
load("//java:common/actions/write_class_path_args_file.bzl", "write_compile_time_class_path_args_file")
load("//java:common/extract/toolchain_info.bzl", "extract_java_compiler_toolchain_info")
load("//java:common/actions/symlink_resources_into_dir.bzl", "symlink_resources_into_dir")
load("//java:common/actions/files.bzl", "make_empty_file")

def compile_java_jar_for_target(ctx):
    '''Interprets a Java target's `ctx` & calls `compile_java_jar`.

    This helper function extracts information from a Java rule's `ctx` object
    (according to some conventions shared across various Java rules), creates
    a `JavaCompilationInfo` instance, and calls `compile_java_jar`.

    Args:
      ctx: A rule `ctx` instance following various Java rule conventions needed
        to compile Java sources. These conventions include well-defined:

        - A `srcs` attribute (a list where all elements are `File`s).
        - A `deps` attribute (a list where all elements provide
          `JavaDependencyInfo`)
        - An `output_jar` attribute (an `attr.output()` with either a string
          or `None` value).
        - A Java compiler toolchain.
        - A `resources` attribute (a possibly empty map from labels to in-JAR
          paths).

    Returns:
      A `JavaCompilationInfo` describing the compilation of Java sources for
      this target. This object's `class_files_output_jar` field will be assigned
      a `File` named `<target_name>.jar`.
    '''
    maybe_main_class = None if not hasattr(ctx.attr, "main_class") else ctx.attr.main_class

    output_jar = ctx.outputs.output_jar
    if output_jar == None:
        output_jar = ctx.actions.declare_file(ctx.attr.name + ".jar")

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
        class_files_output_jar = output_jar,
        additional_jar_manifest_attributes = ctx.attr.additional_jar_manifest_attributes,
        main_class = maybe_main_class,
        java_compiler_toolchain_info = extract_java_compiler_toolchain_info(ctx),
        resources = ctx.attr.resources,
    )

    compile_java_jar(
        label = ctx.label,
        compilation_info = java_compilation_info,
        actions = ctx.actions,
        temp_file_prefix = ctx.attr.name
    )
    return java_compilation_info

def compile_java_jar(label, compilation_info, actions, temp_file_prefix):
    '''Invokes `javac` on Java sources and then `jar`s the results.

    To create the output JAR, some temporary temporary files are created (e.g.
    the generated `.class` files and the build script which calls the `javac`
    and `jar` commands.) The `temp_file_prefix` argument is used as a prefix for
    file paths to help prevent these files from conflicting.

    Args:
      label: The label of the Java target to be built.
      compilation_info: A `JavaCompilationInfo` provider instance.
      actions: The `actions` instance from which actions are emitted.
      temp_file_prefix: A string to prefix to the name of temporary files. This
      is conventionally based on the name of the target calling this function.

    Returns:
      `None`
    '''

    compiler_toolchain_info = compilation_info.java_compiler_toolchain_info

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

    # We create an empty "marker" within the resources directory to help us
    # create a path to the resources directory. This file isn't meant to be
    # used or even created. It is just here to help create an appropriate path
    # to the root of our tree of symlinks to the resource files.
    resources_dir = temp_file_prefix + ".resources"
    resources_dir_marker = make_empty_file(actions, resources_dir + "/.marker")

    resource_files = symlink_resources_into_dir(
        actions,
        compilation_info.resources,
        resources_dir,
    )
    resource_files = depset(direct = resource_files)

    javac_build_dir = actions.declare_directory(temp_file_prefix + ".javac_build/")

    # Declare and instantiate the script which calls `javac` & `jar`.
    output_jar = compilation_info.class_files_output_jar
    compile_java_jar_script = actions.declare_file(temp_file_prefix + ".compile_java_jar.sh")
    actions.expand_template(
        output = compile_java_jar_script,
        template = compiler_toolchain_info.compile_java_jar_script_template,
        substitutions = {
            "{JAVAC_EXECUTABLE}": compiler_toolchain_info.javac_executable.path,
            "{JAVAC_BUILD_DIR}": javac_build_dir.path,
            "{RESOURCES_DIR}": resources_dir_marker.dirname,
            "{CLASS_PATH_ARGS_FILE}": class_path_args_file.path,
            "{JAVA_SRCS_ARGS_FILE}": compilation_info.srcs_args_file.path,
            "{JAR_EXECUTABLE}": compiler_toolchain_info.jar_executable.path,
            "{JAR_MANIFEST_FILE}": jar_manifest_file.path,
            "{OUTPUT_JAR}": output_jar.path,
        },
        is_executable = True,
    )

    # Run the just-created script.
    actions.run(
        executable = compile_java_jar_script,
        outputs = [
            javac_build_dir,
            output_jar,
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
                resource_files,
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
