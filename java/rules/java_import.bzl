'''Defines the `java_import` rule.
'''

load("@dwtj_rules_java//java:rules/common/CustomJavaInfo.bzl", "CustomJavaInfo")

def _java_import_impl(ctx):
    return [
        CustomJavaInfo(jar = ctx.file.jar)
    ]

java_import = rule(
    implementation = _java_import_impl,
    # TODO(dwtj): Change this so that it takes a list of JARs, like the standard
    #  `java_import` rule. This currently takes just a single JAR to make this
    #  quick hack work.
    attrs = {
        "jar": attr.label(
            allow_single_file = [".jar"]
        ),
    }
)
