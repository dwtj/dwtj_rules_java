load(
    "//java:repository_rules/remote_openjdk_repository/defs.bzl",
    "download_openjdk_dist_archive",
    "expand_all_standard_openjdk_templates",
    "make_exec_compatible_with_str",
)

def _guess_shared_library_file_extension(repository_ctx):
    extensions_map = {
        "linux": "so",
        "macos": "dylib"
    }
    extension = extensions_map[repository_ctx.attr.os]
    if extension == None:
        fail("Unexpected `os` attribute value: " + repository_ctx.attr.os)
    return extension

def _expand_graal_package_templates(repository_ctx):
    repository_ctx.template(
        "graalvm/BUILD",
        Label("@dwtj_rules_java//graalvm:repository_rules/remote_graalvm_repository/graalvm/TEMPLATE.BUILD"),
        substitutions = {
            "{REPOSITORY_NAME}": repository_ctx.name,
            "{SHARED_LIBRARY_FILE_EXTENSION}": _guess_shared_library_file_extension(repository_ctx),
            "{EXEC_COMPATIBLE_WITH}": make_exec_compatible_with_str(repository_ctx),
        },
        executable = False,
    )
    repository_ctx.template(
        "graalvm/defs.bzl",
        Label("@dwtj_rules_java//graalvm:repository_rules/remote_graalvm_repository/graalvm/TEMPLATE.defs.bzl"),
        substitutions = {
            "{REPOSITORY_NAME}": repository_ctx.name,
        },
        executable = False,
    )

def _graalvm_distribution_is_executable_on_host(repository_ctx):
    host_os = repository_ctx.os.name
    if repository_ctx.attr.os == "linux" and host_os == "linux":
        return True
    if repository_ctx.attr.os == "macos" and host_os == "mac os x":
        return True
    return False

def _download_and_install_graalvm_native_image_installable_jar(repository_ctx):
    JAR_PATH = "native_image_installable.jar"
    repository_ctx.download(
        output = JAR_PATH,
        url = repository_ctx.attr.native_image_installable_jar_url,
        sha256 = repository_ctx.attr.native_image_installable_jar_sha256,
    )
    if _graalvm_distribution_is_executable_on_host(repository_ctx):
        exec_result = repository_ctx.execute(
            ["jdk/bin/gu", "install", "--file", JAR_PATH],
        )
        if exec_result.return_code != 0:
            fail("Failed to fetch the `native-image` binary.")
    else:
        # TODO(dwtj): Consider alternatives to this somewhat ugly hack.
        # NOTE(dwtj): If we can't execute `gu`, we just create an empty
        #  `native-image` file to prevent errors if the toolchain is
        #  instantiated. This toolchain shouldn't be used anyway because it
        #  shouldn't be exec-compatible. (E.g., it shouldn't be chosen by
        #  toolchain resolution.)
        exec_result = repository_ctx.execute(
            ["touch", "jdk/bin/native-image"]
        )
        if exec_result.return_code != 0:
            fail("Failed to create the `native-image` dummy executable.")

def _remote_graalvm_repository_impl(repository_ctx):
    expand_all_standard_openjdk_templates(repository_ctx)
    _expand_graal_package_templates(repository_ctx)
    download_openjdk_dist_archive(repository_ctx)
    _download_and_install_graalvm_native_image_installable_jar(repository_ctx)
    return None

remote_graalvm_repository = repository_rule(
    implementation = _remote_graalvm_repository_impl,
    attrs = {
        "url": attr.string(
            mandatory = True,
        ),
        "sha256": attr.string(
            mandatory = True,
        ),
        "strip_prefix": attr.string(
            mandatory = True,
        ),
        "native_image_installable_jar_url": attr.string(
            mandatory = True,
        ),
        "native_image_installable_jar_sha256": attr.string(
            mandatory = True,
        ),
        # TODO(dwtj): Maybe figure out how to infer this attribute from context.
        "os": attr.string(
            mandatory = True,
            values = [
                "linux",
                "macos",
            ],
        ),
        "cpu": attr.string(
            mandatory = True,
            values = ["x64"],
        ),
    }
)
