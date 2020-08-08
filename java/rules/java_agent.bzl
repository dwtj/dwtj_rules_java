'''Defines the `java_agent` rule.
'''

load("@dwtj_rules_java//java:providers/JavaAgentInfo.bzl", "JavaAgentInfo")
load("@dwtj_rules_java//java:providers/JavaCompilationInfo.bzl", "JavaCompilationInfo")
load("@dwtj_rules_java//java:providers/JavaDependencyInfo.bzl", "JavaDependencyInfo")

load("@dwtj_rules_java//java:rules/common/providers.bzl", "singleton_java_dependency_info")
load("@dwtj_rules_java//java:rules/common/actions/compile_and_jar_java_sources.bzl", "compile_and_jar_java_sources")

def _bool_to_str(b):
    if b == True:
        return "true"
    if b == False:
        return "false"
    fail("The argument `b` is not a boolean: " + repr(b))

def _java_agent_impl(ctx):
    # NOTE(dwtj): This code is very similar to `compile_and_jar_java_target()`,
    #  but we can't directly use that function, since we need to append a to
    #  `Premain-Class` to `ctx.attr.additional_jar_manifest_attributes`.
    # TODO(dwtj): Maybe figure out a way to prevent this code duplication.

    output_jar = ctx.actions.declare_file(ctx.attr.name + ".jar")

    # NOTE(dwtj): Rule `attr` are frozen; we can't modify it directly.
    manifest_attr = [
        "Premain-Class: " + ctx.attr.premain_class,
        "Can-Redefine-Classes: " + _bool_to_str(ctx.attr.can_redefine_classes),
        "Can-Retransform-Classes: " + _bool_to_str(ctx.attr.can_retransform_classes),
        "Can-Set-Native-Method-Prefix: " + _bool_to_str(ctx.attr.can_set_native_method_prefix),
    ]
    manifest_attr.extend(ctx.attr.additional_jar_manifest_attributes)

    compilation_info = JavaCompilationInfo(
        srcs = depset(ctx.files.srcs),
        class_path_jars = depset(
            transitive = [dep[JavaDependencyInfo].compile_time_class_path_jars for dep in ctx.attr.deps],
        ),
        class_files_output_jar = output_jar,
        main_class = None,
        additional_jar_manifest_attributes = manifest_attr
    )

    compile_and_jar_java_sources(
        compilation_info = compilation_info,
        compiler_toolchain_info = ctx.toolchains["@dwtj_rules_java//java/toolchains/java_compiler_toolchain:toolchain_type"].java_compiler_toolchain_info,
        actions = ctx.actions,
        temp_file_prefix = ctx.attr.name,
    )

    return [
        DefaultInfo(files = depset(direct = [output_jar])),
        compilation_info,
        singleton_java_dependency_info(output_jar),
        JavaAgentInfo(
            java_agent_jar = output_jar,
            premain_class = ctx.attr.premain_class,
            can_redefine_classes = ctx.attr.can_redefine_classes,
            can_retransform_classes = ctx.attr.can_retransform_classes,
            can_set_native_method_prefix = ctx.attr.can_set_native_method_prefix,
        ),
    ]

java_agent = rule(
    implementation = _java_agent_impl,
    attrs = {
        "srcs": attr.label_list(
            # TODO(dwtj): Consider supporting empty `srcs` list once `exports`
            #  is supported.
            allow_empty = False,
            doc = "A list of Java source files whose derived class files should be included in this Java agent (and any of its dependents).",
            allow_files = [".java"],
            default = list(),
        ),
        "deps": attr.label_list(
            providers = [JavaDependencyInfo],
            default = list(),
        ),
        "additional_jar_manifest_attributes": attr.string_list(
            doc = "A list of strings; each will be added as a line of the output JAR's manifest file.",
            default = list(),
        ),
        "premain_class": attr.string(
            mandatory = True,
        ),
        "can_redefine_classes": attr.bool(
            default = False,
        ),
        "can_retransform_classes": attr.bool(
            default = False,
        ),
        "can_set_native_method_prefix": attr.bool(
            default = False,
        ),
    },
    provides = [
        JavaAgentInfo,
        JavaCompilationInfo,
        JavaDependencyInfo,
    ],
    toolchains = [
        "@dwtj_rules_java//java/toolchains/java_compiler_toolchain:toolchain_type",
    ],
)