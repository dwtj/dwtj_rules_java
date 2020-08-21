'''Defines the `google_java_format_toolchain` rule.
'''

GoogleJavaFormatToolchainInfo = provider(
    fields = {
        "google_java_format_deploy_jar": "A JAR `File` containing Google Java Format and all of its run-time dependencies.",
        "colordiff_executable": "A `File` pointing to `colordiff` executable (in the host configuration)."
    },
)

def _google_java_format_toolchain_impl(ctx):
    toolchain_info = platform_common.ToolchainInfo(
        google_java_format_toolchain_info = GoogleJavaFormatToolchainInfo(
            google_java_format_deploy_jar = ctx.file.google_java_format_deploy_jar,
            colordiff_executable = ctx.file.colordiff_executable,
        ),
    )
    return [toolchain_info]

google_java_format_toolchain = rule(
    implementation = _google_java_format_toolchain_impl,
    attrs = {
        "google_java_format_deploy_jar": attr.label(
            allow_single_file = True,
            mandatory = True,
            executable = True,
            cfg = "host",
        ),
        "colordiff_executable": attr.label(
            allow_single_file = True,
            mandatory = True,
            executable = True,
            cfg = "host",
        ),
    },
)
