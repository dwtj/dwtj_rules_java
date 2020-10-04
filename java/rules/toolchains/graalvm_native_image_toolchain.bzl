'''Defines the `graalvm_native_image_toolchain` rule and associated provider.
'''

GraalVmNativeImageToolchainInfo = provider(
    fields = {
        "native_image_exec": "A `File` pointing to a GraalVM `native-image` executable.",
        "graalvm_native_image_script_template": "",
        "class_path_separator": "",
    },
)

def _graalvm_native_image_toolchain(ctx):
    toolchain_info = platform_common.ToolchainInfo(
        graalvm_native_image_toolchain_info = GraalVmNativeImageToolchainInfo(
            native_image_exec = ctx.file.native_image_exec,
            class_path_separator = ctx.attr.class_path_separator,
            graalvm_native_image_script_template = ctx.file._graalvm_native_image_script_template,
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
        "_graalvm_native_image_script_template": attr.label(
            allow_single_file = True,
            default = Label("@dwtj_rules_java//java:rules/graalvm_native_image/TEMPLATE.build_graalvm_native_image.sh")
        ),
    },
)
