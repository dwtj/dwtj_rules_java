'''This is part of the public API for this project.
'''

load("//java:repository_rules/local_openjdk_repository/defs.bzl", "local_openjdk_repository")

load(
    "//java:repository_rules/remote_google_java_format_repository/defs.bzl",
    _remote_google_java_format_repository = "remote_google_java_format_repository",
)

dwtj_local_openjdk_repository = local_openjdk_repository

remote_google_java_format_repository = _remote_google_java_format_repository
