'''Defines some helper functions to extract info from a target's toolchains.
'''

load("//java:toolchain_rules/java_compiler_toolchain.bzl", "JavaCompilerToolchainInfo")
load("//java:toolchain_rules/java_runtime_toolchain.bzl", "JavaRuntimeToolchainInfo")

_JAVA_COMPILER_TOOLCHAIN_TYPE = "@dwtj_rules_java//java/toolchains/java_compiler_toolchain:toolchain_type"
_JAVA_RUNTIME_TOOLCHAIN_TYPE = "@dwtj_rules_java//java/toolchains/java_runtime_toolchain:toolchain_type"
_CHECKSTYLE_TOOLCHAIN_TYPE = '@dwtj_rules_java//java/toolchains/checkstyle_toolchain:toolchain_type'

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

    This info comes from either the resolved toolchain of type
    `java_runtime_toolchain:toolchain_type` or from the targets
    `java_compiler_toolchain` override attribute.

    Args:
      ctx: The Bazel `ctx` object of a particular Bazel target.
    Returns:
      `JavaRuntimeToolchainInfo`
    '''
    attr = ctx.attr.java_runtime_toolchain
    if attr != None:
        return attr[JavaRuntimeToolchainInfo]
    else:
        return ctx.toolchains[_JAVA_RUNTIME_TOOLCHAIN_TYPE].java_runtime_toolchain_info

def extract_java_compiler_toolchain_info(ctx):
    '''Returns this target's `JavaCompilerToolchainInfo`.

    This info comes from either from the resolved toolchain of type
    `java_compiler_toolchain:toolchain_type` or from the target's
    `java_compiler_toolchain` override attribute.

    Args:
      ctx: The Bazel `ctx` object of a particular Bazel target.
    Returns:
      `JavaCompilerToolchainInfo`
    '''
    attr = ctx.attr.java_compiler_toolchain
    if attr != None:
        return attr[JavaCompilerToolchainInfo]
    else:
        return ctx.toolchains[_JAVA_COMPILER_TOOLCHAIN_TYPE].java_compiler_toolchain_info

def extract_checkstyle_toolchain_info(ctx):
    return ctx.toolchains[_CHECKSTYLE_TOOLCHAIN_TYPE].checkstyle_toolchain_info
