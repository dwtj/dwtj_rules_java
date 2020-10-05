'''Defines the `graalvm_native_image_toolchain` rule and associated provider.
'''

GraalVmNativeImageToolchainInfo = provider(
    fields = {
        "native_image_exec": "A `File` pointing to a GraalVM `native-image` executable.",
        "class_path_separator": "",
    },
)

def _graalvm_native_image_toolchain(ctx):
    toolchain_info = platform_common.ToolchainInfo(
        graalvm_native_image_toolchain_info = GraalVmNativeImageToolchainInfo(
            native_image_exec = ctx.file.native_image_exec,
            class_path_separator = ctx.attr.class_path_separator,
        ),
    )
    return [toolchain_info]

graalvm_native_image_toolchain = rule(
    implementation = _graalvm_native_image_toolchain,
    attrs = {
        "native_image_exec": attr.label(
            allow_single_file = True,
            executable = True,
            mandatory = True,
            cfg = "host",
        ),
        "class_path_separator": attr.string(
            default = ":",
        ),
    },
)
