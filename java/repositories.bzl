'''Exports all Java repository rules.

These help users setup their Bazel workspace and its external workspaces.
'''

load("//java:repository_rules/local_openjdk_repository/defs.bzl", "local_openjdk_repository")

load("//java:repository_rules/remote_openjdk_repository/defs.bzl", "remote_openjdk_repository")

load("//java:repository_rules/remote_google_java_format_repository/defs.bzl", _remote_google_java_format_repository = "remote_google_java_format_repository")

load("//java:repository_rules/maven_error_prone_repository/defs.bzl", _maven_error_prone_repository = "maven_error_prone_repository")

load("//java:repository_rules/maven_checkstyle_repository/defs.bzl", _maven_checkstyle_repository = "maven_checkstyle_repository")

load("//java:repository_macros/known_openjdk_repository/defs.bzl", _known_openjdk_repository = "known_openjdk_repository")

dwtj_local_openjdk_repository = local_openjdk_repository

dwtj_remote_openjdk_repository = remote_openjdk_repository

remote_google_java_format_repository = _remote_google_java_format_repository

maven_error_prone_repository = _maven_error_prone_repository

maven_checkstyle_repository = _maven_checkstyle_repository

known_openjdk_repository = _known_openjdk_repository
