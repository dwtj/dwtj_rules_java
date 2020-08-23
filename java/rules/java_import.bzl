'''Defines the `java_import` rule.
'''

load("//java:providers/JavaDependencyInfo.bzl", "JavaDependencyInfo")

def _java_import_impl(ctx):
    jars_depset = depset(direct = ctx.files.jars)
    return [
        JavaDependencyInfo(
            compile_time_class_path_jars = jars_depset,
            run_time_class_path_jars = jars_depset,
        ),
        JavaInfo(
            # The 0-th JAR is wrapped in this `JavaInfo`. This `JavaInfo`
            #  includes a list of exported `JavaInfo`s, one for each of the rest
            #  of the JARs.
            output_jar = ctx.files.jars[0],
            compile_jar = ctx.files.jars[0],
            exports = [JavaInfo(output_jar = jar, compile_jar = jar) for jar in ctx.files.jars[1:]],
        )
    ]

java_import = rule(
    implementation = _java_import_impl,
    attrs = {
        "jars": attr.label_list(
            mandatory = True,
            allow_files = [".jar"],
            allow_empty = False,
        ),
    },
    provides = [
        JavaDependencyInfo,
        JavaInfo,
    ],
)
