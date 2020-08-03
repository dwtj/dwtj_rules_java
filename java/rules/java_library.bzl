'''Defines the `java_library` rule.
'''

load("@dwtj_rules_java//java:providers/JavaCompilationInfo.bzl", "JavaCompilationInfo")
load("@dwtj_rules_java//java:providers/JavaDependencyInfo.bzl", "JavaDependencyInfo")
load("@dwtj_rules_java//java:rules/common/actions/compile_and_jar_java_sources.bzl", "compile_and_jar_java_target")

def singleton_java_dependency_info(jar):
    '''Returns a `JavaDependencyInfo` with just the given `jar` as a CT/RT dep.
    '''
    singleton_depset = depset(direct = [jar])
    return JavaDependencyInfo(
        run_time_class_path_jars = singleton_depset,
        compile_time_class_path_jars = singleton_depset,
    )

def _java_library_impl(ctx):
    java_compilation_info = compile_and_jar_java_target(ctx)
    output_jar = java_compilation_info.class_files_output_jar

    return [
        DefaultInfo(files = depset(direct = [output_jar])),
        java_compilation_info,
        singleton_java_dependency_info(output_jar),
    ]

java_library = rule(
    implementation = _java_library_impl,
    attrs = {
        "srcs": attr.label_list(
            allow_empty = False,
            doc = "A list of Java source files whose derived class files should be included in this library (and any of its dependents).",
            allow_files = [".java"],
        ),
        "deps": attr.label_list(
            providers = [JavaDependencyInfo],
        ),
    },
    provides = [
        JavaCompilationInfo,
        JavaDependencyInfo,
    ],
    toolchains = [
        "@dwtj_rules_java//java/toolchains/java_compiler_toolchain:toolchain_type",
    ],
)