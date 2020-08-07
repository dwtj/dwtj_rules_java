'''Defines the `java_binary` rule.
'''

load("@dwtj_rules_java//java:providers/JavaAgentInfo.bzl", "JavaAgentInfo")
load("@dwtj_rules_java//java:providers/JavaCompilationInfo.bzl", "JavaCompilationInfo")
load("@dwtj_rules_java//java:providers/JavaDependencyInfo.bzl", "JavaDependencyInfo")
load("@dwtj_rules_java//java:providers/JavaExecutionInfo.bzl", "JavaExecutionInfo")

load("@dwtj_rules_java//java:rules/common/actions/compile_and_jar_java_sources.bzl", "compile_and_jar_java_target")
load("@dwtj_rules_java//java:rules/common/actions/write_java_run_script.bzl", "write_java_run_script_from_ctx")
load("@dwtj_rules_java//java:rules/common/extract/toolchain_info.bzl", "extract_java_runtime_toolchain_info", "extract_java_executable")
load("@dwtj_rules_java//java:rules/common/providers.bzl", "singleton_java_dependency_info")

# NOTE(dwtj): This is very similar to `_java_test_impl()`.
def _java_binary_impl(ctx):
    java_compilation_info = compile_and_jar_java_target(ctx)
    java_dependency_info = singleton_java_dependency_info(
        java_compilation_info.class_files_output_jar,
    )
    java_execution_info, run_script, class_path_args_file, jvm_flags_args_file, run_time_jars = write_java_run_script_from_ctx(
        ctx,
        java_dependency_info,
        extract_java_runtime_toolchain_info(ctx),
    )

    return [
        DefaultInfo(
            files = depset([java_compilation_info.class_files_output_jar]),
            executable = run_script,
            runfiles = ctx.runfiles(
                files = [
                    extract_java_executable(ctx),
                    run_script,
                    class_path_args_file,
                    jvm_flags_args_file,
                ],
                transitive_files = run_time_jars,
            ),
        ),
        java_compilation_info,
        java_dependency_info,
        java_execution_info,
    ]

java_binary = rule(
    implementation = _java_binary_impl,
    attrs = {
        "srcs": attr.label_list(
            allow_empty = False,
            doc = "A list of Java source files whose derived class files should be included in this binary (and any of its dependents).",
            allow_files = [".java"],
            default = [],
        ),
        "main_class": attr.string(
            mandatory = True,
        ),
        "deps": attr.label_list(
            providers = [JavaDependencyInfo],
            default = [],
        ),
        "additional_jar_manifest_attributes": attr.string_list(
            doc = "A list of strings; each will be added as a line of the output JAR's manifest file. The JAR's `Main-Class` header is automatically set according to the target's `main_class` attribute.",
            default = [],
        ),
        "java_agents": attr.label_list(
            doc = "A list of `java_agent` targets with which this target should be run.",
            providers = [
                JavaAgentInfo,
                JavaDependencyInfo,
            ],
            default = [],
        ),
    },
    provides = [
        JavaCompilationInfo,
        JavaDependencyInfo,
        JavaExecutionInfo,
    ],
    executable = True,
    toolchains = [
        "@dwtj_rules_java//java/toolchains/java_compiler_toolchain:toolchain_type",
        "@dwtj_rules_java//java/toolchains/java_runtime_toolchain:toolchain_type",
    ],
)
