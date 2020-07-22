'''Defines the `java_test` rule.
'''

load("@dwtj_rules_java//java:rules/common/CustomJavaInfo.bzl", "CustomJavaInfo")
load("@dwtj_rules_java//java:rules/common/build/build_jar_from_java_sources.bzl", "build_jar_from_java_sources")
load("@dwtj_rules_java//java:rules/common/build/build_java_run_script.bzl", "build_java_run_script")

_JAVA_RUNTIME_TOOLCHAIN_TYPE = "@dwtj_rules_java//java/toolchains/java_runtime_toolchain:toolchain_type"

def _extract_java_executable(ctx):
    '''Returns a `file` pointing to the `java` exec in the runtime toolchain.
    '''
    toolchain_info = ctx.toolchains[_JAVA_RUNTIME_TOOLCHAIN_TYPE].java_runtime_toolchain_info
    return toolchain_info.java_executable

# NOTE(dwtj): See also and compare this to `_java_binary_impl()`.
def _java_test_impl(ctx):
    output_jar = build_jar_from_java_sources(ctx)
    deps_jars = depset(direct = [dep[CustomJavaInfo].jar for dep in ctx.attr.deps])
    runtime_jars = depset(direct = [output_jar], transitive = [deps_jars])
    run_script, class_path_args_file = build_java_run_script(ctx, runtime_jars)

    return [
        DefaultInfo(
            files = depset([output_jar]),
            executable = run_script,
            runfiles = ctx.runfiles(
                files = [
                    _extract_java_executable(ctx),
                    run_script,
                    class_path_args_file
                ],
                transitive_files = runtime_jars
            ),
        ),
        CustomJavaInfo(
            jar = output_jar,
            srcs = depset(ctx.files.srcs),
            deps = depset(ctx.files.deps),
        ),
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
            providers = [CustomJavaInfo],
        ),
    },
    toolchains = [
        "@dwtj_rules_java//java/toolchains/java_compiler_toolchain:toolchain_type",
        "@dwtj_rules_java//java/toolchains/java_runtime_toolchain:toolchain_type",
    ],
)