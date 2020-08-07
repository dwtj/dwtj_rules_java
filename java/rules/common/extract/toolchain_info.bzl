'''Defines some helper functions to extract info from a target's toolchains.
'''

_JAVA_RUNTIME_TOOLCHAIN_TYPE = "@dwtj_rules_java//java/toolchains/java_runtime_toolchain:toolchain_type"

def extract_java_executable(ctx):
    '''Returns a `file` pointing to the `java` exec in the runtime toolchain.
    '''
    return extract_java_runtime_toolchain_info(ctx).java_executable

def extract_java_runtime_toolchain_info(ctx):
    '''Returns this target's `JavaRuntimeToolchainInfo`.
    '''
    return ctx.toolchains[_JAVA_RUNTIME_TOOLCHAIN_TYPE].java_runtime_toolchain_info
