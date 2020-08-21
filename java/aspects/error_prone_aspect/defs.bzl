'''Defines the `error_prone_aspect`. It runs Error Prone on Java `srcs`.
'''

load("@dwtj_rules_java//java:providers/JavaCompilationInfo.bzl", "JavaCompilationInfo")
load("@dwtj_rules_java//java:rules/common/actions/write_class_path_arguments_file.bzl", "write_compile_time_class_path_arguments_file")

ErrorProneAspectInfo = provider(
    fields = {
        'error_prone_log': "A `File` handle to the log output by `javac` when processing a Java target with Error Prone.",
    }
)

def _file_name(target, suffix):
    return "{}.error_prone.{}".format(target.label.name, suffix)

def _to_path(file):
    '''Used as a map function.'''
    return file.path

def _extract_class_path_separator(aspect_ctx):
    return aspect_ctx.toolchains['@dwtj_rules_java//java/toolchains/java_compiler_toolchain:toolchain_type'] \
        .java_compiler_toolchain_info \
        .class_path_separator

def _extract_javac_executable(aspect_ctx):
    return aspect_ctx.toolchains['@dwtj_rules_java//java/toolchains/java_compiler_toolchain:toolchain_type'] \
        .java_compiler_toolchain_info \
        .javac_executable

def _extract_error_prone_java_info(aspect_ctx):
    return aspect_ctx.toolchains['@dwtj_rules_java//java/toolchains/error_prone_toolchain:toolchain_type'] \
        .error_prone_toolchain_info \
        .error_prone_java_info

def _error_prone_aspect_impl(target, aspect_ctx):
    # Skip a target if it doesn't provide a `JavaCompilationInfo`.
    if JavaCompilationInfo not in target:
        return ErrorProneAspectInfo(
            error_prone_log = None,
        )

    # Extract some information from the environment for brevity.
    actions = aspect_ctx.actions
    jars = target[JavaCompilationInfo].class_path_jars
    srcs = target[JavaCompilationInfo].srcs
    javac_executable = _extract_javac_executable(aspect_ctx)
    error_prone_info = _extract_error_prone_java_info(aspect_ctx)
    path_separator = _extract_class_path_separator(aspect_ctx)

    # Create both temporary args files, i.e., `@`-files.
    # TODO(dwtj): Similar args files should be made by the target rule. Consider
    #  re-using those args files instead of re-creating them here.
    class_path_args_file = write_compile_time_class_path_arguments_file(
        name = _file_name(target, "class_path.args"),
        jars = jars,
        actions = actions,
        class_path_separator = path_separator,
    )
    java_sources_args_file = actions.declare_file(_file_name(target, "java_sources.args"))
    java_sources_args = actions.args()
    java_sources_args.add_all(
        srcs,
        omit_if_empty = False,
        map_each = _to_path,
    )
    actions.write(
        output = java_sources_args_file,
        content = java_sources_args,
        is_executable = False,
    )

    # Create a processor path string from Error Prone's `JavaInfo`.
    # TODO(dwtj): This processor path args file should be the same for every
    #  target. So, consider storing a handle to it in the toolchain and re-using
    #  it.
    processor_path_args_file = actions.declare_file(_file_name(target, "processor_path.args"))
    processor_path_args = actions.args()
    processor_path_args.add_joined(
        error_prone_info.transitive_compile_time_jars,
        join_with = path_separator,
        map_each = _to_path,
    )
    actions.write(
        output = processor_path_args_file,
        content = processor_path_args,
        is_executable = False,
    )

    # Declare the output file.
    error_prone_log = actions.declare_file(_file_name(target, "log"))

    # Declare the class file output directory.
    # NOTE(dwtj): I do not yet know of a way to analyze Java sources with Error
    #  Prone without also compiling those sources. Using `javac -proc:only`
    #  doesn't work. `javac` notices that there are no annotation processors and
    #  exits with an error. For now, I'm just putting the class files into this
    #  directory and ignoring them.
    # TODO(dwtj): Try using `javac -proc:only` with a do-nothing annotation
    #  processor.
    output_class_dir = actions.declare_directory(_file_name(target, "classes"))

    # Declare and write the run script from the template.
    run_script = actions.declare_file(_file_name(target, "run_javac_with_error_prone.sh"))
    actions.expand_template(
        template = aspect_ctx.file._run_javac_with_error_prone_script_template,
        output = run_script,
        substitutions = {
            "{JAVAC_EXECUTABLE}": javac_executable.path,
            "{OUTPUT_CLASS_DIR}": output_class_dir.path,
            "{CLASS_PATH_ARGS_FILE}": class_path_args_file.path,
            "{PROCESSOR_PATH_ARGS_FILE}": processor_path_args_file.path,
            "{JAVA_SOURCES_ARGS_FILE}": java_sources_args_file.path,
            "{ERROR_PRONE_LOG_FILE}": error_prone_log.path,
        }
    )

    # Run this script.
    actions.run(
        executable = run_script,
        outputs = [
            error_prone_log,
            output_class_dir,
        ],
        tools = [
            javac_executable,
        ],
        inputs = depset(
            direct = [
                processor_path_args_file,
                class_path_args_file,
                java_sources_args_file,
            ],
            transitive = [
                srcs,
                jars,
                error_prone_info.transitive_compile_time_jars,
            ],
        ),
        mnemonic = "ErrorProne",
        progress_message = "Using Error Prone to check Java sources of Java target `{}`".format(target.label),
        use_default_shell_env = False,
    )

    return [
        OutputGroupInfo(default = [error_prone_log]),
        ErrorProneAspectInfo(error_prone_log = error_prone_log),
    ]

error_prone_aspect = aspect(
    implementation = _error_prone_aspect_impl,
    provides = [
        ErrorProneAspectInfo,
    ],
    attrs = {
        "_run_javac_with_error_prone_script_template": attr.label(
            default = Label("@dwtj_rules_java//java:aspects/error_prone_aspect/TEMPLATE.run_javac_with_error_prone.sh"),
            allow_single_file = True,
        )
    },
    toolchains = [
        "@dwtj_rules_java//java/toolchains/java_compiler_toolchain:toolchain_type",
        "@dwtj_rules_java//java/toolchains/error_prone_toolchain:toolchain_type",
    ],
)
