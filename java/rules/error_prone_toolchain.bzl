'''Defines the `error_prone_toolchain` rule.
'''

ErrorProneToolchainInfo = provider(
    fields = [
        "error_prone_java_info",
    ],
)

def _error_prone_toolchain_impl(ctx):
    toolchain_info = platform_common.ToolchainInfo(
        error_prone_toolchain_info = ErrorProneToolchainInfo(
            error_prone_java_info = ctx.attr.error_prone[JavaInfo],
        ),
    )
    return [toolchain_info]

error_prone_toolchain = rule(
    implementation = _error_prone_toolchain_impl,
    attrs = {
        "error_prone": attr.label(
            allow_single_file = True,
            mandatory = True,
            cfg = "host",
            providers = [JavaInfo],
        )
    }
)
