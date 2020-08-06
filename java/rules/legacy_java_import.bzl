'''Defines the `legacy_java_import` rule.
'''

load("@dwtj_rules_java//java:providers/JavaDependencyInfo.bzl", "JavaDependencyInfo")

def _legacy_java_import_impl(ctx):
    java_infos = [i[JavaInfo] for i in ctx.attr.imports]
    ct = depset(transitive = [info.transitive_compile_time_jars for info in java_infos])
    rt = depset(transitive = [info.transitive_runtime_jars for info in java_infos])
    return [
        JavaDependencyInfo(
            compile_time_class_path_jars = ct,
            run_time_class_path_jars = rt,
        )
    ]

legacy_java_import = rule(
    doc = "Wraps legacy Java targets (i.e. those providing `JavaInfo`) so that they can be used as a dependency of these new Java rules.",
    implementation = _legacy_java_import_impl,
    attrs = {
        "imports": attr.label_list(
            providers = [JavaInfo],
            mandatory = True,
        )
    },
    provides = [JavaDependencyInfo],
)