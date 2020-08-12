'''Defines the `java_library` rule.
'''

load("@dwtj_rules_java//java:providers/JavaCompilationInfo.bzl", "JavaCompilationInfo")
load("@dwtj_rules_java//java:providers/JavaDependencyInfo.bzl", "JavaDependencyInfo")
load("@dwtj_rules_java//java:rules/common/actions/compile_and_jar_java_sources.bzl", "compile_and_jar_java_target")
load(
    "@dwtj_rules_java//java:rules/common/providers.bzl",
    "singleton_java_dependency_info",
    "make_legacy_java_info",
)

def _java_library_impl(ctx):
    java_compilation_info = compile_and_jar_java_target(ctx)
    output_jar = java_compilation_info.class_files_output_jar

    return [
        DefaultInfo(files = depset(direct = [output_jar])),
        java_compilation_info,
        singleton_java_dependency_info(output_jar),
        make_legacy_java_info(java_compilation_info, ctx.attr.deps),
    ]

java_library = rule(
    implementation = _java_library_impl,
    attrs = {
        "srcs": attr.label_list(
            # TODO(dwtj): Consider supporting empty `srcs` list once `exports`
            #  is supported.
            allow_empty = False,
            doc = "A list of Java source files whose derived class files should be included in this library (and any of its dependents).",
            allow_files = [".java"],
            default = list(),
        ),
        "deps": attr.label_list(
            providers = [
                JavaDependencyInfo,
                JavaInfo,
            ],
            default = list(),
        ),
        "additional_jar_manifest_attributes": attr.string_list(
            doc = "A list of strings; each will be added as a line of the output JAR's manifest file.",
            default = list(),
        ),
    },
    provides = [
        JavaCompilationInfo,
        JavaDependencyInfo,
        JavaInfo,
    ],
    toolchains = [
        "@dwtj_rules_java//java/toolchains/java_compiler_toolchain:toolchain_type",
    ],
)