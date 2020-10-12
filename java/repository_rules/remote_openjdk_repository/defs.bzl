'''This file defines the `remote_openjdk_repository` repository rule. This rule
downloads a remote distribution of OpenJDK and wraps some files of its files in
appropriate Bazel targets. In particular, executables are wrapped in Bazel
toolchains.
'''

def _download_archive(repository_ctx):
    repository_ctx.download_and_extract(
        url = repository_ctx.attr.url,
        sha256 = repository_ctx.attr.sha256,
        stripPrefix = repository_ctx.attr.strip_prefix,
        allow_fail = False,
    )

def _expand_root_build_file_template(repository_ctx):
    repository_ctx.template(
        "BUILD",
        repository_ctx.attr._root_build_file_template,
        substitutions = {
            "{REPOSITORY_NAME}": repository_ctx.name,
            "{EXEC_COMPATIBLE_WITH}": "[]"
        },
        executable = False,
    )

def _expand_root_defs_bzl_file_template(repository_ctx):
    repository_ctx.template(
        "defs.bzl",
        repository_ctx.attr._root_defs_bzl_file_template,
        substitutions = {
            "{REPOSITORY_NAME}": repository_ctx.name,
        },
        executable = False,
    )

def _expand_cc_jni_build_file_template(repository_ctx):
    repository_ctx.template(
        "cc/jni/BUILD",
        repository_ctx.attr._cc_jni_build_file_template,
        substitutions = {
            "{REPOSITORY_NAME}": repository_ctx.name,
            # TODO(dwtj): Generalize this once more OSes are supported.
            "{JNI_MD_HEADER_DIR}": "include/linux",
        },
        executable = False,
    )

def _expand_cc_jvm_build_file_template(repository_ctx):
    repository_ctx.template(
        "cc/jvm/BUILD",
        repository_ctx.attr._cc_jvm_build_file_template,
        substitutions = {
            "{REPOSITORY_NAME}": repository_ctx.name,
            # TODO(dwtj): Generalize this once more OSes are supported.
            "{SHARED_LIBRARY_PATH}": "lib/server/libjvm.so",
        },
        executable = False,
    )

def _expand_cc_jvmti_build_file_template(repository_ctx):
    repository_ctx.template(
        "cc/jvmti/BUILD",
        repository_ctx.attr._cc_jvmti_build_file_template,
        substitutions = {
            "{REPOSITORY_NAME}": repository_ctx.name,
        },
        executable = False,
    )

def _expand_cc_package_templates(repository_ctx):
    _expand_cc_jni_build_file_template(repository_ctx)
    _expand_cc_jvm_build_file_template(repository_ctx)
    _expand_cc_jvmti_build_file_template(repository_ctx)

def _expand_rust_jni_build_file_template(repository_ctx):
    repository_ctx.template(
        "rust/jni/BUILD",
        repository_ctx.attr._rust_jni_build_file_template,
        substitutions = {
            "{REPOSITORY_NAME}": repository_ctx.name,
            # TODO(dwtj): Generalize this once more OSes are supported.
            "{JNI_MD_HEADER_LABEL}": "//:include/linux/jni_md.h",
            "{JNI_HEADER_LABEL}": "//:include/jni.h",
        },
        executable = False,
    )

def _expand_rust_package_templates(repository_ctx):
    _expand_rust_jni_build_file_template(repository_ctx)

def _remote_openjdk_repository_impl(repository_ctx):
    # TODO(dwtj): Add support for `exec_compatible_with` attribute.
    if len(repository_ctx.attr.exec_compatible_with) > 0:
       fail("The `remote_openjdk_repository.exec_compatible_with` attribute is not yet supported.")

    _download_archive(repository_ctx)
    _expand_root_build_file_template(repository_ctx)
    _expand_root_defs_bzl_file_template(repository_ctx)
    _expand_cc_package_templates(repository_ctx)
    _expand_rust_package_templates(repository_ctx)

    # TODO(dwtj): Consider what should be returned here to help reproducibility.
    return None

remote_openjdk_repository = repository_rule(
    implementation = _remote_openjdk_repository_impl,
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
        "_root_build_file_template": attr.label(
            default = Label("@dwtj_rules_java//java:repository_rules/remote_openjdk_repository/TEMPLATE.BUILD"),
            allow_single_file = True,
        ),
        "_root_defs_bzl_file_template": attr.label(
            default = Label("@dwtj_rules_java//java:repository_rules/remote_openjdk_repository/TEMPLATE.defs.bzl"),
            allow_single_file = True,
        ),
        "_cc_jni_build_file_template": attr.label(
            default = Label("@dwtj_rules_java//java:repository_rules/remote_openjdk_repository/cc/jni/TEMPLATE.BUILD"),
            allow_single_file = True,
        ),
        "_cc_jvm_build_file_template": attr.label(
            default = Label("@dwtj_rules_java//java:repository_rules/remote_openjdk_repository/cc/jvm/TEMPLATE.BUILD"),
            allow_single_file = True,
        ),
        "_cc_jvmti_build_file_template": attr.label(
            default = Label("@dwtj_rules_java//java:repository_rules/remote_openjdk_repository/cc/jvmti/TEMPLATE.BUILD"),
            allow_single_file = True,
        ),
        "_rust_jni_build_file_template": attr.label(
            default = "//java:repository_rules/remote_openjdk_repository/rust/jni/TEMPLATE.BUILD",
            allow_single_file = True,
        )
    }
)
