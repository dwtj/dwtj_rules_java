'''Defines the `javadoc_toolchain` for use by the `javadoc_aspect`.
'''

JavadocToolchainInfo = provider(
    fields = {
        "javadoc_executable": "A `javadoc` executable file (in the host configuration).",
        "class_path_separator": "The class path separator to use when invoking this `javadoc` executable."
    },
)

def _javadoc_toolchain_impl(ctx):
    toolchain_info = platform_common.ToolchainInfo(
        javadoc_toolchain_info = JavadocToolchainInfo(
            javadoc_executable = ctx.file.javadoc_executable,
            class_path_separator = ctx.attr.class_path_separator,
        ),
    )
    return [toolchain_info]

javadoc_toolchain = rule(
    implementation = _javadoc_toolchain_impl,
    attrs = {
        "javadoc_executable": attr.label(
            allow_single_file = True,
            mandatory = True,
            executable = True,
            cfg = "host",
        ),
        "class_path_separator": attr.string(
            default = ":",
        )
    }
)
