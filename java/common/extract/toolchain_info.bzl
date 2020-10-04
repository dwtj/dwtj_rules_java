'''Defines some helper functions to extract info from a target's toolchains.
'''

_JAVA_RUNTIME_TOOLCHAIN_TYPE = "@dwtj_rules_java//java/toolchains/java_runtime_toolchain:toolchain_type"
_CHECKSTYLE_TOOLCHAIN_TYPE = '@dwtj_rules_java//java/toolchains/checkstyle_toolchain:toolchain_type'
_GRAALVM_NATIVE_IMAGE_TOOLCHAIN_TYPE = '@dwtj_rules_java//java/toolchains/graalvm_native_image_toolchain:toolchain_type'

def extract_java_executable(ctx):
    '''Returns a `File` pointing to the `java` exec in the runtime toolchain.
    '''
    return extract_java_runtime_toolchain_info(ctx).java_executable

def extract_java_runtime_toolchain_class_path_separator(ctx):
    '''Returns the class path separator according to the current Java runtime.
    '''
    return extract_java_runtime_toolchain_info(ctx).class_path_separator

def extract_java_runtime_toolchain_info(ctx):
    '''Returns this target's `JavaRuntimeToolchainInfo`.
    '''
    return ctx.toolchains[_JAVA_RUNTIME_TOOLCHAIN_TYPE].java_runtime_toolchain_info

def extract_graalvm_native_image_toolchain_info(ctx):
    return ctx.toolchains[_GRAALVM_NATIVE_IMAGE_TOOLCHAIN_TYPE].graalvm_native_image_toolchain_info

def extract_checkstyle_toolchain_info(ctx):
    return ctx.toolchains[_CHECKSTYLE_TOOLCHAIN_TYPE].checkstyle_toolchain_info
