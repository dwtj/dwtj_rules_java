# This file was generated from a template with the following substitutions:
#
# - REPOSITORY_NAME: {REPOSITORY_NAME}

'''Defines a helper macro to register the GraalVM toolchains provided by this
repository, "@{REPOSITORY_NAME}".
'''

def register_graalvm_toolchains():
    fail("TODO(dwtj): GraalVM native-image toolchains are not yet implemented for the `remote_graalvm_repository` repository rule. For now, use `local_graalvm_repository` instead.")
    #native.register_toolchains(
    #    "@{REPOSITORY_NAME}//graalvm:graalvm_native_image_toolchain",
    #)
