# This file was generated from a template with the following substitutions:
#
# - REPOSITORY_NAME: {REPOSITORY_NAME}

'''Defines a helper macro to register the Java toolchains provided by this
repository, "@{REPOSITORY_NAME}".
'''

def register_java_toolchains():
    native.register_toolchains(
        "@{REPOSITORY_NAME}//:java_runtime_toolchain",
        "@{REPOSITORY_NAME}//:java_compiler_toolchain",
    )