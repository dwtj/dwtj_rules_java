'''Defines the `java_agent` rule.
'''

load("//java:providers/JavaAgentInfo.bzl", "JavaAgentInfo")
load("//java:providers/JavaCompilationInfo.bzl", "JavaCompilationInfo")
load("//java:providers/JavaDependencyInfo.bzl", "JavaDependencyInfo")

load("//java:toolchain_rules/java_compiler_toolchain.bzl", "JavaCompilerToolchainInfo")

load(
    "//java:common/providers.bzl",
    "make_standard_java_target_java_dependency_info",
    "make_legacy_java_info",
)
load("//java:common/actions/write_java_sources_args_file.bzl", "write_java_sources_args_file")
load("//java:common/actions/compile_java_jar.bzl", "compile_java_jar")
load("//java:common/extract/toolchain_info.bzl", "extract_java_compiler_toolchain_info")

def _bool_to_str(b):
    if b == True:
        return "true"
    if b == False:
        return "false"
    fail("The argument `b` is not a boolean: " + repr(b))

def _java_agent_impl(ctx):
    # NOTE(dwtj): This code is very similar to `compile_java_jar_for_target()`,
    #  but we can't directly use that function, since we need to append to
    #  `Premain-Class` and similar attributes to
    #  `ctx.attr.additional_jar_manifest_attributes`.
    # TODO(dwtj): Maybe figure out a way to prevent this code duplication.

    output_jar = ctx.outputs.output_jar
    if output_jar == None:
        output_jar = ctx.actions.declare_file(ctx.attr.name + ".jar")

    # NOTE(dwtj): Rule `attr` are frozen; we can't modify it directly.
    manifest_attr = [
        "Premain-Class: " + ctx.attr.premain_class,
        "Can-Redefine-Classes: " + _bool_to_str(ctx.attr.can_redefine_classes),
        "Can-Retransform-Classes: " + _bool_to_str(ctx.attr.can_retransform_classes),
        "Can-Set-Native-Method-Prefix: " + _bool_to_str(ctx.attr.can_set_native_method_prefix),
    ]
    manifest_attr.extend(ctx.attr.additional_jar_manifest_attributes)

    srcs_args_file = write_java_sources_args_file(
        name = ctx.attr.name + ".java_srcs.args",
        srcs = ctx.files.srcs,
        actions = ctx.actions,
    )

    compilation_info = JavaCompilationInfo(
        srcs = depset(ctx.files.srcs),
        srcs_args_file = srcs_args_file,
        class_path_jars = depset(
            transitive = [dep[JavaDependencyInfo].compile_time_class_path_jars for dep in ctx.attr.deps],
        ),
        class_files_output_jar = output_jar,
        main_class = None,
        additional_jar_manifest_attributes = manifest_attr,
        java_compiler_toolchain_info = extract_java_compiler_toolchain_info(ctx),
        resources = ctx.attr.resources,
        javac_flags = ctx.attr.javac_flags,
    )

    compile_java_jar(
        label = ctx.label,
        compilation_info = compilation_info,
        actions = ctx.actions,
        temp_file_prefix = ctx.attr.name,
    )

    return [
        DefaultInfo(files = depset(direct = [output_jar])),
        compilation_info,
        make_standard_java_target_java_dependency_info(ctx, output_jar),
        JavaAgentInfo(
            java_agent_jar = output_jar,
            premain_class = ctx.attr.premain_class,
            can_redefine_classes = ctx.attr.can_redefine_classes,
            can_retransform_classes = ctx.attr.can_retransform_classes,
            can_set_native_method_prefix = ctx.attr.can_set_native_method_prefix,
        ),
        make_legacy_java_info(compilation_info, ctx.attr.deps)
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
        "resources": attr.label_keyed_string_dict(
            allow_files = True,
            default = dict(),
        ),
        "javac_flags": attr.string_list(
            doc = """A list of strings. Each will be added as a flag to the `javac` command invocation used to compile and process this rule's Java source files. These flags will be ordered just as they appear in this list. These flags will be in addition to the options automatically added to the `javac` invocation (e.g. `--class-path`). Example: By setting this attibute to the list `['-Asome_name_option="J. Smith"']` will add one annotation processing option to the `javac` invocation whose option name is `some_name_option` and whose value is "J. Smith".)""",
            default = list(),
        ),
        "output_jar": attr.output(
            doc = "The name of the JAR file generated by this target. This JAR contains the class files generated by this target's Java compiler invocation.",
        ),
        "java_compiler_toolchain": attr.label(
            doc = "This optional attribute can override the global Java compiler toolchain. This expects a label for a `java_compiler_toolchain` target (or more precisely, a target providing `JavaCompilerToolchainInfo`).",
            providers = [JavaCompilerToolchainInfo],
        ),
    },
    provides = [
        JavaAgentInfo,
        JavaCompilationInfo,
        JavaDependencyInfo,
        JavaInfo,
    ],
    toolchains = [
        "@dwtj_rules_java//java/toolchains/java_compiler_toolchain:toolchain_type",
    ],
)
