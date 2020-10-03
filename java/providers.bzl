'''Re-exports the provider definitions for public use.

Most uses won't need to use these definitions directly. They may be useful for
users who are building their own Bazel rules and want to integrate their
rules with these rules.
'''

# TODO(dwtj): Consider putting toolchain instance providers here too.

load("//java:providers/JavaAgentInfo.bzl", _JavaAgentInfo = "JavaAgentInfo")

load("//java:providers/JavaCompilationInfo.bzl", _JavaCompilationInfo = "JavaCompilationInfo")

load("//java:providers/JavaDependencyInfo.bzl", _JavaDependencyInfo = "JavaDependencyInfo")

load("//java:providers/JavaExecutionInfo.bzl", _JavaExecutionInfo = "JavaExecutionInfo")

JavaAgentInfo = _JavaAgentInfo

JavaCompilationInfo = _JavaCompilationInfo

JavaDependencyInfo = _JavaDependencyInfo

JavaExecutionInfo = _JavaExecutionInfo
