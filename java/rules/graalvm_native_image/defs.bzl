'''Defines the `graalvm_native_image` rule.
'''

load("//java:providers/JavaDependencyInfo.bzl", "JavaDependencyInfo")
load("//java:common/extract/toolchain_info.bzl", "extract_graalvm_native_image_toolchain_info")

def file_to_path(file):
    return file.path

def _build_script_name(ctx):
    return ctx.attr.name  + ".build_native_image.sh"

# TODO(dwtj): Consider revising control flow so that this is called just once,
#  not twice. Maybe just cache the result. But where? I probably can't just use
#  a script global variable. Does Bazel provide some target-local storage?
def _make_class_path_depset(ctx):
    depsets = []
    for dep in ctx.attr.deps:
        dep_info = dep[JavaDependencyInfo]
        depsets.append(dep_info.compile_time_class_path_jars)
    return depset([], transitive = depsets)

def _add_image_name_arg(ctx, args):
    args.add(ctx.outputs.output_image)

def _build_args(ctx):
    args = ctx.actions.args()
    _add_all_class_path_args(ctx, args)
    _add_all_options_args(ctx, args)
    _add_main_class_arg(ctx, args)
    _add_image_name_arg(ctx, args)
    return args

def _add_all_class_path_args(ctx, args):
    toolchain_info = extract_graalvm_native_image_toolchain_info(ctx)
    jar_depset = _make_class_path_depset(ctx)
    args.add_joined(
        "--class-path",
        jar_depset,
        join_with = toolchain_info.class_path_separator,
        map_each = file_to_path,
    )
    return args

def _add_all_options_args(ctx, args):
    args.add_all(ctx.attr.native_image_options)

def _add_main_class_arg(ctx, args):
    args.add(ctx.attr.main_class)

def _build_native_image(ctx):
    toolchain_info = extract_graalvm_native_image_toolchain_info(ctx)
    ctx.actions.run(
        executable = toolchain_info.native_image_exec,
        inputs = _make_class_path_depset(ctx),
        outputs = [ctx.outputs.output_image],
        arguments = [_build_args(ctx)],
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
        "native_image_options": attr.string_list(
            doc = "A list representing options to add to the `native-image` command invocation. These will be added directly to a Bourne shell script (These options are placed after the `--class-path` argument generated from the `deps` attribute.)",
        ),
    },
    toolchains = [
        "@dwtj_rules_java//java/toolchains/graalvm_native_image_toolchain:toolchain_type",
    ],
)
