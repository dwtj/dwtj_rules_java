'''Exports all GraalVM repository rules.

These help users setup their Bazel workspace and its external workspaces.
'''

load("//graalvm:repository_rules/local_graalvm_repository/defs.bzl", _local_graalvm_repository = "local_graalvm_repository")

load("//graalvm:repository_rules/remote_graalvm_repository/defs.bzl", _remote_graalvm_repository = "remote_graalvm_repository")

local_graalvm_repository = _local_graalvm_repository

remote_graalvm_repository = _remote_graalvm_repository
