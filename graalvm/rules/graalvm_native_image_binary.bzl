'''Defines the `graalvm_native_image_binary` rule.
'''

load("//java:providers/JavaDependencyInfo.bzl", "JavaDependencyInfo")
load("//graalvm:common/extract/toolchain_info.bzl", "extract_graalvm_native_image_toolchain_info")
load(
    "//graalvm:common/actions/native_image.bzl",
    "make_class_path_depset",
    "make_native_image_options_args",
    "make_class_path_args",
)

def _make_maybe_static_args(ctx):
    args = ctx.actions.args()
    if ctx.attr.linkage == "static":
        args.add("--libc=musl")
        args.add("--static")
    elif ctx.attr.linkage == "shared":
        # NOTE(dwtj): By "shared" we don't mean pass that we pass the
        #  `--shared` option to `native-image`. That would create a shared
        #  library (i.e. an `.so` file). Rather, we just mean that we are making
        #  a binary (a.k.a. executable) whose dependencies (e.g. `libc`, `zlib`,
        #  `pthread`) are linked dynamically.
        # NOTE(dwtj): We just return an empty `Args` object.
        pass
    else:
        fail("Unexpected value in `graalvm_native_image_binary.linkage` attribute: " + ctx.attr.linkage)
    return args

def _build_native_image(ctx):
    toolchain_info = extract_graalvm_native_image_toolchain_info(ctx)
    ctx.actions.run(
        executable = toolchain_info.native_image_exec,
        inputs = make_class_path_depset(ctx),
        outputs = [ctx.outputs.output],
        arguments = [
            make_class_path_args(ctx),
            make_native_image_options_args(ctx),
            ctx.attr.main_class,
            ctx.outputs.output.path,
        ],
        mnemonic = "GraalVmNativeImageBinary",
        progress_message = "Building `native-image` binary executable for `{}`".format(ctx.label),
        # NOTE(dwtj): Currently, we `use_default_shell_env` so that the
        #  `native-image` executable can find the system C compiler and
        #  libraries.
        # TODO(dwtj): Set this to `False` to make builds more hermetic. How can
        #  we help `native-image` find the C compiler and libraries.
        use_default_shell_env = True,
    )

def _graalvm_native_image_binary_impl(ctx):
    _build_native_image(ctx)
    return [DefaultInfo(files = depset([ctx.outputs.output]))]

graalvm_native_image_binary = rule(
    implementation = _graalvm_native_image_binary_impl,
    attrs = {
        "main_class": attr.string(
            mandatory = True,
        ),
        "deps": attr.label_list(
            allow_empty = False,
            providers = [JavaDependencyInfo],
            mandatory = True,
        ),
        "output": attr.output(
            # TODO(dwtj): Consider making this optional.
            # TODO(dwtj): Write doc string.
            mandatory = True,
        ),
        "native_image_options": attr.string_list(
            doc = "A list representing options to add to the `native-image` command invocation. These options are placed after any automatically-generated options (e.g., the `--class-path` option generated from the `deps` attribute).",
        ),
        "linkage": attr.string(
            values = ["static", "shared"],
            default = "shared",
        ),
    },
    toolchains = [
        "@dwtj_rules_java//graalvm/toolchains/graalvm_native_image_toolchain:toolchain_type",
    ],
)
