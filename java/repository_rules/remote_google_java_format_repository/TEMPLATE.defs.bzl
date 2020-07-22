# This file was generated from a template with the following substitutions:
#
# - REPOSITORY_NAME: {REPOSITORY_NAME}

def register_google_java_format_toolchain():
    native.register_toolchains("@{REPOSITORY_NAME}//:toolchain")