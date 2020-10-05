'''Defines some helper functions to extract info from a target's toolchains.
'''

_GRAALVM_NATIVE_IMAGE_TOOLCHAIN_TYPE = '@dwtj_rules_java//graalvm/toolchains/graalvm_native_image_toolchain:toolchain_type'

def extract_graalvm_native_image_toolchain_info(ctx):
    return ctx.toolchains[_GRAALVM_NATIVE_IMAGE_TOOLCHAIN_TYPE].graalvm_native_image_toolchain_info
