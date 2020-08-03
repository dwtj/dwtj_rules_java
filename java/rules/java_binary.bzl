'''Defines the `java_binary` rule.
'''

load("@dwtj_rules_java//java:providers/JavaCompilationInfo.bzl", "JavaCompilationInfo")
load("@dwtj_rules_java//java:providers/JavaDependencyInfo.bzl", "JavaDependencyInfo")
load("@dwtj_rules_java//java:rules/common/actions/compile_and_jar_java_sources.bzl", "compile_and_jar_java_target")
load("@dwtj_rules_java//java:rules/common/actions/write_java_run_script.bzl", "write_java_run_script")
load("@dwtj_rules_java//java:rules/common/extract/toolchain_info.bzl", "extract_java_executable")

# NOTE(dwtj): This is nearly identical to `_java_test_impl()`, and the
#  repetition is a bit fishy. It isn't very long and there aren't likely to be
#  other rules which also use this, so I'm leaving it like this for now.
# TODO(dwtj): Consider refactoring these two `implementation` functions into a
#  common definition somewhere.
def _java_binary_impl(ctx):
    java_compilation_info = compile_and_jar_java_target(ctx)
    output_jar = java_compilation_info.class_files_output_jar

    run_time_jars = depset(
        direct = [output_jar],
        transitive = [dep[JavaDependencyInfo].run_time_class_path_jars \
                          for dep \
                          in ctx.attr.deps],
    )

    run_script, class_path_args_file = write_java_run_script(ctx, run_time_jars)

    return [
        DefaultInfo(
            files = depset([output_jar]),
            executable = run_script,
            runfiles = ctx.runfiles(
                files = [
                    extract_java_executable(ctx),
                    run_script,
                    class_path_args_file
                ],
                transitive_files = run_time_jars
            ),
        ),
        java_compilation_info,
    ]

java_binary = rule(
    implementation = _java_binary_impl,
    attrs = {
        "srcs": attr.label_list(
            allow_empty = False,
            doc = "A list of Java source files whose derived class files should be included in this binary (and any of its dependents).",
            allow_files = [".java"],
        ),
        "main_class": attr.string(
            mandatory = True,
        ),
        "deps": attr.label_list(
            providers = [JavaDependencyInfo],
        ),
    },
    provides = [
        JavaCompilationInfo,
    ],
    executable = True,
    toolchains = [
        "@dwtj_rules_java//java/toolchains/java_compiler_toolchain:toolchain_type",
        "@dwtj_rules_java//java/toolchains/java_runtime_toolchain:toolchain_type",
    ],
)
