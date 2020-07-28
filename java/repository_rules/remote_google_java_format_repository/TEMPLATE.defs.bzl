# This file was generated from a template with the following substitutions:
#
# - REPOSITORY_NAME: {REPOSITORY_NAME}

'''Defines `@{REPOSITORY_NAME}//:defs.bzl%register_google_java_format_toolchain`
which users of the `remote_google_java_format_repository` can call in their
`WORKSPACE` file.
'''

def register_google_java_format_toolchain():
    native.register_toolchains("@{REPOSITORY_NAME}//:toolchain")
