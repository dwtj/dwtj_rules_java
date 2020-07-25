'''Defines the `build_jar_from_java_sources` utility function.

This function is meant to be used by a few different rules which build Java
sources: `java_library`, `java_binary`, and `java_test`.
'''

load("@dwtj_rules_java//java:rules/common/CustomJavaInfo.bzl", "CustomJavaInfo")
load("@dwtj_rules_java//java:rules/common/build/build_class_path_arguments_file.bzl", "build_compile_time_class_path_arguments_file")

_JAVAC_TOOLCHAIN_TYPE = "@dwtj_rules_java//java/toolchains/java_compiler_toolchain:toolchain_type"

# TODO(dwtj): The classpath separator is ';' on Windows. Support that someday.
_UNIX_LIKE_CLASSPATH_SEPARATOR = ":"

def _to_path(classpath_item):
    '''Used as a map function to convert a file to its path.
    '''
    return classpath_item.path

def _to_short_path(classpath_item):
    '''Used as a map function to convert a file to its short path.
    '''
    return classpath_item.short_path

def build_jar_from_java_sources(ctx):
    '''Emits a sequence of actions to build this Java target's output JAR.

    NOTE(dwtj): There are quite a few unstated assumptions which this function
     makes about the given `ctx` object. For example, it needs to have an
     appropriate `ctx.files.srcs`, it needs to provide a
     `java_compiler_toolchain`, etc. All of the rule-kinds which use this
     function satisfy these assumptions by following some unstated
     conventions, but this is ugly and brittle. This could be fixed by stating
     all of these assumptions or by passing in a number of arguments (with
     explicit preconditions), rather than passing in a `ctx`. There are just a
     few fixed kinds of rules and these conventions aren't too likely to
     change. It's ugly, but I'll leave the implementation like this for now.
    
    # TODO(dwtj): Fix this ugliness.

    Args:
      ctx: The rule [`ctx`][1] object of a Java target whose sources will be
      compiled and archived.

    Returns:
      The output JAR [`File`][2] which to be built.

    [1]: https://docs.bazel.build/versions/3.4.0/skylark/lib/ctx.html
    [2]: https://docs.bazel.build/versions/3.4.0/skylark/lib/File.html
    '''

    # Declare the output JAR file.
    output_jar = ctx.actions.declare_file(ctx.attr.name + ".jar")

    # Extract information from the Java compiler toolchain.
    toolchain_info = ctx.toolchains[_JAVAC_TOOLCHAIN_TYPE].java_compiler_toolchain_info

    class_path_args_file = build_compile_time_class_path_arguments_file(
        name = ctx.attr.name + ".compile_time_class_path.args",
        jars = [dep[CustomJavaInfo].jar for dep in ctx.attr.deps],
        actions = ctx.actions,
        class_path_separator = toolchain_info.class_path_separator
    )

    # Declare, build, and write a file to hold all `javac` command arguments.
    # (The `javac` command, like the `java` command, accepts a "Command Line
    # Arguments File" using the `@filename` notation.)
    javac_args_file = ctx.actions.declare_file(ctx.attr.name + ".javac.args")
    javac_args = ctx.actions.args()
    javac_args.add_all(
        ctx.files.srcs,
        omit_if_empty = False,
        map_each = _to_short_path,
    )
    ctx.actions.write(
        output = javac_args_file,
        content = javac_args,
        is_executable = False,
    )

    # Declare and instantiate the script which calls `javac` & `jar`.
    build_java_jar_script = ctx.actions.declare_file(ctx.attr.name + ".compile_java_binary_to_jar.sh")
    ctx.actions.expand_template(
        output = build_java_jar_script,
        template = toolchain_info.build_jar_from_java_sources_script_template,
        substitutions = {
            "{TARGET_NAME}": ctx.attr.name,
            "{JAVAC_EXECUTABLE}": toolchain_info.javac_executable.path,
            "{CLASS_OUTPUT_DIRECTORY}": ctx.attr.name + ".classes.temp",
            "{JAR_EXECUTABLE}": toolchain_info.jar_executable.path,
            "{CLASS_PATH_ARGS_FILE}": class_path_args_file.path,
            "{JAVAC_ARGUMENTS_FILE}": javac_args_file.path,
            "{OUTPUT_JAR}": output_jar.path,
        },
        is_executable = True,
    )

    # Run the just-created script.
    inputs = []
    inputs.append(class_path_args_file)
    inputs.append(javac_args_file)
    inputs.extend(ctx.files.srcs)
    inputs.extend([dep[CustomJavaInfo].jar for dep in ctx.attr.deps])
    ctx.actions.run(
        executable = build_java_jar_script,
        outputs = [output_jar],
        inputs = inputs,
        tools = [
            toolchain_info.jar_executable,
            toolchain_info.javac_executable
        ],
        mnemonic = "BuildJar",
        progress_message = "Compiling Java sources and archiving them into `" + output_jar.basename + "`.",
        use_default_shell_env = False,
    )

    return output_jar
