# This file was generated from a template with the following substitutions:
#
# - REPOSITORY_NAME: {REPOSITORY_NAME}

'''Defines a helper macros to help fetch and register the Error Prone toolchain
synthesized within this repository, `@{REPOSITORY_NAME}`.
'''

load("@rules_jvm_external//:defs.bzl", "maven_install")

# This is the latest Error Prone release as of 2020-08-18.
_DEFAULT_ERROR_PRONE_VERSION = "2.4.0"

_DEFAULT_MAVEN_REPOSITORIES = [
    "https://jcenter.bintray.com",
    "https://maven.google.com",
    "https://repo1.maven.org/maven2",
]

def fetch_error_prone_toolchain(
    version = _DEFAULT_ERROR_PRONE_VERSION,
    maven_repositories = _DEFAULT_MAVEN_REPOSITORIES,
    ):
    '''Creates a `maven_install` external repository which includes Error Prone.

    This `@maven_error_prone` repository only includes Error Prone. This library
    is fetched using Maven. The Error Prone version to be fetched is selected by
    the `version` argument. This copy of Error Prone is used by the the
    toolchain synthesized within *this* repository, `@{REPOSITORY_NAME}`.

    Args:
      version: A string encoding the Error Prone version to be fetched. This
        defaults to `_DEFAULT_ERROR_PRONE_VERSION`.
      maven_repositories: A list of strings encoding Maven repository URLs from
        which Error Prone may be fetched. This defaults to
        `_DEFAULT_MAVEN_REPOSITORIES`.
    '''
    maven_install(
        name = "maven_error_prone",
        artifacts = [
            "com.google.errorprone:error_prone_core:{}".format(version)
        ],
        repositories = maven_repositories,
    )

def register_error_prone_toolchain():
    native.register_toolchains(
        "@{REPOSITORY_NAME}//:error_prone_toolchain",
    )
