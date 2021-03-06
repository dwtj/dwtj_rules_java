'''Defines the `google_java_format_aspect` and some helper definitions for it.
'''

load("//java:providers/JavaCompilationInfo.bzl", "JavaCompilationInfo")

def _extract_google_java_format_deploy_jar(aspect_ctx):
    return aspect_ctx.toolchains['@dwtj_rules_java//java/toolchains/google_java_format_toolchain:toolchain_type'] \
            .google_java_format_toolchain_info \
            .google_java_format_deploy_jar

def _extract_colordiff_executable(aspect_ctx):
    return aspect_ctx.toolchains['@dwtj_rules_java//java/toolchains/google_java_format_toolchain:toolchain_type'] \
            .google_java_format_toolchain_info \
            .colordiff_executable

def _extract_java_executable(aspect_ctx):
    return aspect_ctx.toolchains['@dwtj_rules_java//java/toolchains/java_runtime_toolchain:toolchain_type'] \
            .java_runtime_toolchain_info \
            .java_executable


def _to_path(file):
    '''Used as a map function.'''
    return file.path

GoogleJavaFormatAspectInfo = provider(
    fields = {
        'output_file': "The output file generated by `google-java-format`. This will be `None` if the target doesn't include any Java sources to be formatted.",
    }
)

def _target_name_with_suffix(target, suffix):
    return target.label.name + suffix

def _google_java_format_aspect_impl(target, aspect_ctx):
    # Skip a target if it doesn't provide a `JavaCompilationInfo`.
    if JavaCompilationInfo not in target:
        return [GoogleJavaFormatAspectInfo()]
    
    # Extract some information from the target and the toolchains for brevity:
    srcs = target[JavaCompilationInfo].srcs
    srcs_args_file = target[JavaCompilationInfo].srcs_args_file
    google_java_format_deploy_jar = _extract_google_java_format_deploy_jar(aspect_ctx)
    colordiff_executable = _extract_colordiff_executable(aspect_ctx)
    java_executable = _extract_java_executable(aspect_ctx)

    # Declare an output file for `google-java-format` to write to.
    output_file = aspect_ctx.actions.declare_file(_target_name_with_suffix(target, ".google_java_format.out"))

    # Instantiate a script which will run `google-java-format` from a template.
    run_google_java_format = aspect_ctx.actions.declare_file(_target_name_with_suffix(target, ".run_google_java_format.sh"))
    aspect_ctx.actions.expand_template(
        template = aspect_ctx.file._run_google_java_format_template,
        output = run_google_java_format,
        substitutions = {
            "{JAVA_EXECUTABLE}": java_executable.path,
            "{GOOGLE_JAVA_FORMAT_DEPLOY_JAR}": google_java_format_deploy_jar.path,
            "{JAVA_SOURCES_ARGS_FILE}": srcs_args_file.path,
            "{OUTPUT_FILE}": output_file.path,
            "{COLORDIFF_EXECUTABLE}": colordiff_executable.path,
        },
        is_executable = True,
    )

    # Lastly, run our `google-java-format` script on the target's srcs:
    inputs = depset(
        direct = [
            java_executable,
            google_java_format_deploy_jar,
            colordiff_executable,
            srcs_args_file,
        ],
        transitive = [srcs]
    )
    aspect_ctx.actions.run(
        executable = run_google_java_format,
        inputs = inputs,
        outputs = [output_file],
        mnemonic = "GoogleJavaFormat",
        progress_message = "Using `google-java-format` to format Java sources of Java target `{}`".format(target.label),
        use_default_shell_env = False,
    )

    return [
        OutputGroupInfo(default = [output_file]),
        GoogleJavaFormatAspectInfo(output_file = output_file),
    ]

google_java_format_aspect = aspect(
    implementation = _google_java_format_aspect_impl,
    provides = [GoogleJavaFormatAspectInfo],
    attrs = {
        "_run_google_java_format_template": attr.label(
            default = "@dwtj_rules_java//java:aspects/google_java_format_aspect/TEMPLATE.run_google_java_format.sh",
            allow_single_file = True,
        ),
    },
    toolchains = [
        '@dwtj_rules_java//java/toolchains/google_java_format_toolchain:toolchain_type',
        '@dwtj_rules_java//java/toolchains/java_runtime_toolchain:toolchain_type',
    ],
)