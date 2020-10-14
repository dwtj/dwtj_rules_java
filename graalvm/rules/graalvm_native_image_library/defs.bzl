'''Defines the `graalvm_native_image_library` rule.
'''

load("//java:providers/JavaDependencyInfo.bzl", "JavaDependencyInfo")
load("//graalvm:common/extract/toolchain_info.bzl", "extract_graalvm_native_image_toolchain_info")
load(
    "//graalvm:common/actions/native_image.bzl",
    "make_class_path_depset",
    "make_native_image_options_args",
    "make_class_path_str",
)

def _image_name(ctx):
    name = ctx.attr.image_name
    if name != "":
        return name
    else:
        return ctx.attr.name

def _make_build_script_name(ctx):
    return ctx.attr.name + ".build_native_image_library.sh"

def _make_outputs_list(ctx):
    return [
        ctx.outputs.library_output,
        ctx.outputs.header_output,
        ctx.outputs.dynamic_header_output,
        ctx.outputs.graal_isolate_header_output,
        ctx.outputs.graal_isolate_dynamic_header_output,
    ]

def _expand_build_script_template(ctx, build_script):
    toolchain_info = extract_graalvm_native_image_toolchain_info(ctx)
    ctx.actions.expand_template(
        template = toolchain_info.build_native_image_library_script_template,
        output = build_script,
        substitutions = {
            "{TARGET_NAME}": ctx.attr.name,
            "{TARGET_PACKAGE_PATH}": ctx.label.package,
            "{IMAGE_NAME}": _image_name(ctx),
            "{MAIN_CLASS}": ctx.attr.main_class,
            "{NATIVE_IMAGE_EXECUTABLE}": toolchain_info.native_image_exec.path,
            "{CLASS_PATH}": make_class_path_str(ctx),
            "{LIBRARY_OUTPUT}": ctx.outputs.library_output.path,
            "{LIBRARY_FILE_EXTENSION}": toolchain_info.shared_library_file_extension,
            "{HEADER_OUTPUT}": ctx.outputs.header_output.path,
            "{DYNAMIC_HEADER_OUTPUT}": ctx.outputs.dynamic_header_output.path,
            "{GRAAL_ISOLATE_HEADER_OUTPUT}": ctx.outputs.graal_isolate_header_output.path,
            "{GRAAL_ISOLATE_DYNAMIC_HEADER_OUTPUT}": ctx.outputs.graal_isolate_dynamic_header_output.path,
        },
        is_executable = True,
    )

def _build_native_image_library_and_headers(ctx):
    toolchain_info = extract_graalvm_native_image_toolchain_info(ctx)
    build_script = ctx.actions.declare_file(_make_build_script_name(ctx))
    _expand_build_script_template(ctx, build_script)
    ctx.actions.run(
        executable = build_script,
        inputs = make_class_path_depset(ctx),
        outputs = _make_outputs_list(ctx),
        # NOTE(dwtj): We pass the extra `native-image` options to the script as
        #  arguments rather than adding them as another substitution when the
        #  template is instantated. This is intended to avoid complications
        #  related to Bourne shell tokenization/interpretation.
        tools = [toolchain_info.native_image_exec],
        arguments = [make_native_image_options_args(ctx)],
        mnemonic = "GraalVmNativeImageLibrary",
        progress_message = "Building `native-image` library for `{}`".format(ctx.label),
        # NOTE(dwtj): Currently, we `use_default_shell_env` so that the
        #  `native-image` executable can find the system C compiler and
        #  libraries.
        # TODO(dwtj): Set this to `False` to make builds more hermetic. But
        # then how can we help `native-image` find the C compiler and libraries.
        use_default_shell_env = True,
    )

def _graalvm_native_image_library_impl(ctx):
    _build_native_image_library_and_headers(ctx)
    return [DefaultInfo(files = depset(_make_outputs_list(ctx)))]

graalvm_native_image_library = rule(
    implementation = _graalvm_native_image_library_impl,
    attrs = {
        "main_class": attr.string(
            doc = "If this is set, then the created image will use this Java class's main method as the main entry point. (Methods with appropriate parameters and annotated with `@CEntryPoint` will be used as entry points regardless of whether this is or isn't set.)",
            mandatory = False,
        ),
        "image_name": attr.string(
            doc = "If this is not set, then this target's name attribute will be used as the image name.",
            mandatory = False,
        ),
        "deps": attr.label_list(
            allow_empty = False,
            providers = [JavaDependencyInfo],
            mandatory = True,
        ),
        "native_image_options": attr.string_list(
            doc = "A list representing options to add to the `native-image` command invocation. These options are placed after any automatically-generated options (e.g., the `--class-path` option generated from the `deps` attribute).",
        ),
        "library_output": attr.output(
            # TODO(dwtj): Consider making this attribute optional.
            mandatory = True,
        ),
        "header_output": attr.output(
            # TODO(dwtj): Consider making this attribute optional.
            mandatory = True,
        ),
        "dynamic_header_output": attr.output(
            # TODO(dwtj): Consider making this attribute optional.
            mandatory = True,
        ),
        "graal_isolate_header_output": attr.output(
            # TODO(dwtj): Consider making this attribute optional.
            mandatory = True,
        ),
        "graal_isolate_dynamic_header_output": attr.output(
            # TODO(dwtj): Consider making this attribute optional.
            mandatory = True,
        ),
    },
    toolchains = [
        "@dwtj_rules_java//graalvm/toolchains/graalvm_native_image_toolchain:toolchain_type",
    ],
)
