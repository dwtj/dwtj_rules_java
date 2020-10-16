'''Defines the `java_import` rule.
'''

load("//java:providers/JavaDependencyInfo.bzl", "JavaDependencyInfo")
load("//java:common/providers.bzl", "jar_list_java_dependency_info")

def _java_import_impl(ctx):
    return [
        jar_list_java_dependency_info(ctx.files.jars),
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
