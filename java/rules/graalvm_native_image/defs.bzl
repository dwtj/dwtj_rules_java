'''Defines the `graalvm_native_image` rule.
'''

def _graalvm_native_image_impl(ctx):
    # TODO(dwtj): Everything!
    print("Hello, from `_graalvm_native_image_impl().")
    pass

graalvm_native_image = rule(
    implementation = _graalvm_native_image_impl,
    attrs = {
        # TODO(dwtj): Everything!
    },
    toolchains = [
        "@dwtj_rules_java//java/toolchains/graalvm_native_image_toolchain:toolchain_type",
    ],
)
