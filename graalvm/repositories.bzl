'''Exports all GraalVM repository rules.

These help users setup their Bazel workspace and its external workspaces.
'''

load("//graalvm:repository_rules/local_graalvm_repository/defs.bzl", _local_graalvm_repository = "local_graalvm_repository")

local_graalvm_repository = _local_graalvm_repository
