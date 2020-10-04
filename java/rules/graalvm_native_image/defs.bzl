'''Defines the `graalvm_native_image` rule.
'''

load("//java:providers/JavaDependencyInfo.bzl", "JavaDependencyInfo")
load("//java:common/extract/toolchain_info.bzl", "extract_graalvm_native_image_toolchain_info")

def _build_script_name(ctx):
    return ctx.attr.name  + ".build_native_image.sh"

# TODO(dwtj): Consider revising control flow so that this is called just once,
#  not twice.
def _make_class_path_depset(ctx):
    depsets = []
    for dep in ctx.attr.deps:
        dep_info = dep[JavaDependencyInfo]
        depsets.append(dep_info.compile_time_class_path_jars)
    return depset([], transitive = depsets)

def _make_class_path_string(ctx):
    toolchain_info = extract_graalvm_native_image_toolchain_info(ctx)
    jar_depset = _make_class_path_depset(ctx)
    jar_list = [jar.path for jar in jar_depset.to_list()]
    return toolchain_info.class_path_separator.join(jar_list)

def _make_native_image_build_script(ctx):
    toolchain_info = extract_graalvm_native_image_toolchain_info(ctx)
    build_script = ctx.actions.declare_file(_build_script_name(ctx))
    ctx.actions.expand_template(
        template = toolchain_info.graalvm_native_image_script_template,
        output = build_script,
        substitutions = {
            "{NATIVE_IMAGE_EXEC}": toolchain_info.native_image_exec.path,
            "{CLASS_PATH}": _make_class_path_string(ctx),
            "{MAIN_CLASS}": ctx.attr.main_class,
            "{OUTPUT_IMAGE}": ctx.outputs.output_image.path,
        },
        is_executable = True,
    )
    return build_script

def _build_native_image(ctx):
    toolchain_info = extract_graalvm_native_image_toolchain_info(ctx)
    build_script = _make_native_image_build_script(ctx)
    ctx.actions.run(
        outputs = [ctx.outputs.output_image],
        inputs = _make_class_path_depset(ctx),
        executable = build_script,
        tools = [toolchain_info.native_image_exec],
        mnemonic = "GraalVmNativeImage",
        progress_message = "Building native image for `{}`".format(ctx.label),
        # NOTE(dwtj): Currently, we `use_default_shell_env` so that the
        #  `native-image` executable can find the system C compiler and
        #  libraries.
        # TODO(dwtj): Set this to `False` to make builds more hermetic. How can
        #  we help `native-image` find the C compiler and libraries.
        use_default_shell_env = True,
    )

def _graalvm_native_image_impl(ctx):
    _build_native_image(ctx)
    return [
        DefaultInfo(
            files = depset([ctx.outputs.output_image]),
        )
    ]

graalvm_native_image = rule(
    implementation = _graalvm_native_image_impl,
    attrs = {
        "main_class": attr.string(
            mandatory = True,
        ),
        "deps": attr.label_list(
            allow_empty = False,
            providers = [JavaDependencyInfo],
            mandatory = True,
        ),
        "output_image": attr.output(
            # TODO(dwtj): Make this optional.
            mandatory = True,
        ),
    },
    toolchains = [
        "@dwtj_rules_java//java/toolchains/graalvm_native_image_toolchain:toolchain_type",
    ],
)
