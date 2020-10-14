# This file was generated from a template with the following substitutions:
#
# - REPOSITORY_NAME: {REPOSITORY_NAME}

'''Defines a helper macro to register the GraalVM toolchains provided by this
repository, "@{REPOSITORY_NAME}".
'''

def register_graalvm_toolchains():
    native.register_toolchains(
        "@{REPOSITORY_NAME}//graalvm:graalvm_native_image_toolchain",
    )
