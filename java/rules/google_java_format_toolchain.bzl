'''Defines the `google_java_format_toolchain` rule.
'''

GoogleJavaFormatToolchainInfo = provider(
    fields = [
        "google_java_format_deploy_jar",
    ],
)

def _google_java_format_toolchain_impl(ctx):
    toolchain_info = platform_common.ToolchainInfo(
        google_java_format_toolchain_info = GoogleJavaFormatToolchainInfo(
            google_java_format_deploy_jar = ctx.file.google_java_format_deploy_jar,
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
    }
)
