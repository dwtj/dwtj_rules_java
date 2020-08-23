# This file was generated from a template with the following substitutions:
#
# - REPOSITORY_NAME: {REPOSITORY_NAME}

'''Defines a helper macros to help fetch and register the Checkstyle toolchain
synthesized within this repository, `@{REPOSITORY_NAME}`.
'''

load("@rules_jvm_external//:defs.bzl", "maven_install")

# This is the latest Checkstyle release as of 2020-08-22.
_DEFAULT_CHECKSTYLE_VERSION = "8.35"

_DEFAULT_MAVEN_REPOSITORIES = [
    "https://jcenter.bintray.com",
    "https://maven.google.com",
    "https://repo1.maven.org/maven2",
]

def fetch_checkstyle_toolchain(
    version = _DEFAULT_CHECKSTYLE_VERSION,
    maven_repositories = _DEFAULT_MAVEN_REPOSITORIES,
    ):
    '''Creates a `maven_install` external repository which includes Checkstyle.

    This `@maven_checkstyle` repository only includes Checkstyle. This library
    is fetched using Maven. The Checkstyle version to be fetched is selected by
    the `version` argument. This copy of Checkstyle is used by the
    the toolchain synthesized within *this* repository, `@{REPOSITORY_NAME}`.

    Args:
      version: A string encoding the Checkstyle version to be fetched. This
        defaults to `_DEFAULT_CHECKSTYLE_VERSION`.
      maven_repositories: A list of strings encoding Maven repository URLs from
        which Checkstyle may be fetched. This defaults to
        `_DEFAULT_MAVEN_REPOSITORIES`.
    '''
    maven_install(
        name = "maven_checkstyle",
        artifacts = [
            "com.puppycrawl.tools:checkstyle:{}".format(version)
        ],
        repositories = maven_repositories,
    )

def register_checkstyle_toolchain():
    native.register_toolchains(
        "@{REPOSITORY_NAME}//:checkstyle_toolchain",
    )
