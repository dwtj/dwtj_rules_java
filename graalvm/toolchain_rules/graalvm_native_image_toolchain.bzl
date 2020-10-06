'''Defines the `graalvm_native_image_toolchain` rule and associated provider.
'''

GraalVmNativeImageToolchainInfo = provider(
    fields = {
        "native_image_exec": "A `File` pointing to a GraalVM `native-image` executable.",
        "class_path_separator": "",  # TODO(dwtj): Write doc string.
        "shared_library_file_extension": "", # TODO(dwtj): Write doc string.
        "build_native_image_library_script_template": "", # TODO(dwtj): Write doc string.
    },
)

def _graalvm_native_image_toolchain(ctx):
    toolchain_info = platform_common.ToolchainInfo(
        graalvm_native_image_toolchain_info = GraalVmNativeImageToolchainInfo(
            native_image_exec = ctx.file.native_image_exec,
            class_path_separator = ctx.attr.class_path_separator,
            shared_library_file_extension = ctx.attr.shared_library_file_extension,
            build_native_image_library_script_template = ctx.file._build_native_image_library_script_template,
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
            mandatory = True,
        ),
        "shared_library_file_extension": attr.string(
            mandatory = True,
        ),
        "_build_native_image_library_script_template": attr.label(
            allow_single_file = True,
            default = Label("@dwtj_rules_java//graalvm:rules/graalvm_native_image_library/TEMPLATE.build_native_image_library.sh"),
        ),
    },
)
