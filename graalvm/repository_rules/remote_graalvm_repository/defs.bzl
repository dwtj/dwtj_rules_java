load("//java:repository_rules/remote_openjdk_repository/defs.bzl", "remote_openjdk_repository_impl")

def _expand_graal_package_templates(repository_ctx):
    repository_ctx.template(
        "graalvm/BUILD",
        Label("@dwtj_rules_java//graalvm:repository_rules/remote_graalvm_repository/graalvm/TEMPLATE.BUILD"),
        substitutions = {
            "{REPOSITORY_NAME}": repository_ctx.name,
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

def _download_and_install_graalvm_native_image_installable_jar(repository_ctx):
    JAR_PATH = "native_image_installable.jar"
    repository_ctx.download(
        output = JAR_PATH,
        url = repository_ctx.attr.native_image_installable_jar_url,
        sha256 = repository_ctx.attr.native_image_installable_jar_sha256,
    )
    repository_ctx.execute(
        ["bin/gu", "install", "--file", JAR_PATH],
    )

def _remote_graalvm_repository_impl(repository_ctx):
    remote_openjdk_repository_impl(repository_ctx)
    _expand_graal_package_templates(repository_ctx)
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
            default = "",
        ),
        "native_image_installable_jar_url": attr.string(
            mandatory = True,
        ),
        "native_image_installable_jar_sha256": attr.string(
            mandatory = True,
        ),
        "exec_compatible_with": attr.label_list(
            default = list(),
        ),
        # TODO(dwtj): Maybe figure out how to infer this attribute from context.
        # TODO(dwtj): Add support more OS values (e.g., macOS).
        # NOTE(dwtj): Currently, this is only used for the `cc` packages,
        #  specifically, for wrapping the `jni_md.h` file. So, this value only
        #  really needs to be correct if the user uses `//cc/jni:headers`.
        "os": attr.string(
            values = ["linux"],
        ),
    }
)
