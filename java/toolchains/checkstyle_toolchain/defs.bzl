'''Defines the `checkstyle_toolchain` rule.
'''

CheckstyleToolchainInfo = provider(
    fields = {
        "checkstyle_java_info": "A `JavaInfo` describing the Checkstyle library and all of its run-time dependencies.",
    },
)

def _checkstyle_toolchain_impl(ctx):
    toolchain_info = platform_common.ToolchainInfo(
        checkstyle_toolchain_info = CheckstyleToolchainInfo(
            checkstyle_java_info = ctx.attr.checkstyle[JavaInfo],
        ),
    )
    return [toolchain_info]

checkstyle_toolchain = rule(
    implementation = _checkstyle_toolchain_impl,
    attrs = {
        "checkstyle": attr.label(
            allow_single_file = True,
            mandatory = True,
            cfg = "host",
            providers = [JavaInfo],
        ),
    }
)
