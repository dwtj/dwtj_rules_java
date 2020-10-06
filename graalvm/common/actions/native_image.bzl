'''Some helper functions to support `native-image` invocation within rules.
'''

load("//java:providers/JavaDependencyInfo.bzl", "JavaDependencyInfo")
load("//graalvm:common/extract/toolchain_info.bzl", "extract_graalvm_native_image_toolchain_info")

def _file_to_path(file):
    return file.path

# TODO(dwtj): Consider revising control flow so that this is called just once,
#  not twice. Maybe just cache the result. But where? I probably can't just use
#  a script global variable. Does Bazel provide some target-local storage?
def make_class_path_depset(ctx):
    depsets = []
    for dep in ctx.attr.deps:
        dep_info = dep[JavaDependencyInfo]
        depsets.append(dep_info.compile_time_class_path_jars)
    return depset([], transitive = depsets)

def make_class_path_args(ctx):
    args = ctx.actions.args()
    toolchain_info = extract_graalvm_native_image_toolchain_info(ctx)
    jar_depset = make_class_path_depset(ctx)
    args.add_joined(
        "--class-path",
        jar_depset,
        join_with = toolchain_info.class_path_separator,
        map_each = _file_to_path,
    )
    return args

def make_class_path_str(ctx):
    separator = extract_graalvm_native_image_toolchain_info(ctx).class_path_separator
    jar_paths = [jar.path for jar in make_class_path_depset(ctx).to_list()]
    return separator.join(jar_paths)

def make_native_image_options_args(ctx):
    args = ctx.actions.args()
    args.add_all(ctx.attr.native_image_options)
    return args
