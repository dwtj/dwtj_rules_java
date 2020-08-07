'''Defines the `java_test` rule.
'''

load("@dwtj_rules_java//java:providers/JavaCompilationInfo.bzl", "JavaCompilationInfo")
load("@dwtj_rules_java//java:providers/JavaDependencyInfo.bzl", "JavaDependencyInfo")
load("@dwtj_rules_java//java:rules/common/actions/compile_and_jar_java_sources.bzl", "compile_and_jar_java_target")
load("@dwtj_rules_java//java:rules/common/actions/write_java_run_script.bzl", "write_java_run_script")
load("@dwtj_rules_java//java:rules/common/extract/toolchain_info.bzl", "extract_java_executable")

# NOTE(dwtj): See also and compare this to `_java_binary_impl()`.
def _java_test_impl(ctx):
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

java_test = rule(
    implementation = _java_test_impl,
    test = True,
    attrs = {
        "srcs": attr.label_list(
            allow_empty = False,
            doc = "A list of Java source files whose derived class files should be included in this test (and any of its dependents).",
            allow_files = [".java"],
        ),
        "main_class": attr.string(
            mandatory = True,
        ),
        "deps": attr.label_list(
            providers = [JavaDependencyInfo],
        ),
        "additional_jar_manifest_attributes": attr.string_list(
            doc = "A list of strings; each will be added as a line of the output JAR's manifest file. The JAR's `Main-Class` header is automatically set according to the target's `main_class` attribute.",
            default = [],
        ),
    },
    provides = [
        JavaCompilationInfo,
    ],
    toolchains = [
        "@dwtj_rules_java//java/toolchains/java_compiler_toolchain:toolchain_type",
        "@dwtj_rules_java//java/toolchains/java_runtime_toolchain:toolchain_type",
    ],
)