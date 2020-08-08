'''Defines the `java_import` rule.
'''

load("@dwtj_rules_java//java:providers/JavaDependencyInfo.bzl", "JavaDependencyInfo")

def _java_import_impl(ctx):
    jars_depset = depset(direct = ctx.files.jars)
    return [
        JavaDependencyInfo(
            compile_time_class_path_jars = jars_depset,
            run_time_class_path_jars = jars_depset,
        ),
    ]

java_import = rule(
    implementation = _java_import_impl,
    attrs = {
        "jars": attr.label_list(
            mandatory = True,
            allow_files = [".jar"]
        ),
    },
    provides = [
        JavaDependencyInfo,
    ],
)
