'''This file defines the `remote_openjdk_repository` repository rule. This rule
downloads a remote distribution of OpenJDK and wraps some files of its files in
appropriate Bazel targets. In particular, executables are wrapped in Bazel
toolchains.
'''

def _template_label(template_path):
    return Label("@dwtj_rules_java//java:repository_rules/remote_openjdk_repository/" + template_path)

def download_openjdk_dist_archive(repository_ctx):
    repository_ctx.download_and_extract(
        output = "jdk",
        url = repository_ctx.attr.url,
        sha256 = repository_ctx.attr.sha256,
        stripPrefix = repository_ctx.attr.strip_prefix,
        allow_fail = False,
    )

def _expand_jdk_package_templates(repository_ctx):
    repository_ctx.template(
        "jdk/BUILD",
        _template_label("jdk/TEMPLATE.BUILD"),
        substitutions = {},  # NOTE(dwtj): No substitutions needed yet.
        executable = False,
    )

def _expand_java_package_templates(repository_ctx):
    _expand_java_build_file_template(repository_ctx)
    _expand_java_defs_bzl_file_template(repository_ctx)

def _expand_java_build_file_template(repository_ctx):
    repository_ctx.template(
        "java/BUILD",
        _template_label("java/TEMPLATE.BUILD"),
        substitutions = {
            "{REPOSITORY_NAME}": repository_ctx.name,
            "{EXEC_COMPATIBLE_WITH}": "[]"
        },
        executable = False,
    )

def _expand_java_defs_bzl_file_template(repository_ctx):
    repository_ctx.template(
        "java/defs.bzl",
        _template_label("java/TEMPLATE.defs.bzl"),
        substitutions = {
            "{REPOSITORY_NAME}": repository_ctx.name,
        },
        executable = False,
    )

def _expand_cc_jni_build_file_template(repository_ctx):
    repository_ctx.template(
        "cc/jni/BUILD",
        _template_label("cc/jni/TEMPLATE.BUILD"),
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
        _template_label("cc/jvm/TEMPLATE.BUILD"),
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
        _template_label("cc/jvmti/TEMPLATE.BUILD"),
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
        _template_label("rust/jni/TEMPLATE.BUILD"),
        substitutions = {
            "{REPOSITORY_NAME}": repository_ctx.name,
            # TODO(dwtj): Generalize this once more OSes are supported.
            "{JNI_HEADER_LABEL}":    "//jdk:include/jni.h",
            "{JNI_MD_HEADER_LABEL}": "//jdk:include/linux/jni_md.h",
        },
        executable = False,
    )

def _expand_rust_jvmti_build_file_template(repository_ctx):
    repository_ctx.template(
        "rust/jvmti/BUILD",
        _template_label("rust/jvmti/TEMPLATE.BUILD"),
        substitutions = {
            "{REPOSITORY_NAME}": repository_ctx.name,
            "{JVMTI_HEADER_LABEL}":  "//jdk:include/jvmti.h",
            "{JNI_HEADER_LABEL}":    "//jdk:include/jni.h",
            # TODO(dwtj): Generalize this once more OSes are supported.
            "{JNI_MD_HEADER_LABEL}": "//jdk:include/linux/jni_md.h",
        },
        executable = False,
    )

def _expand_rust_package_templates(repository_ctx):
    _expand_rust_jni_build_file_template(repository_ctx)
    _expand_rust_jvmti_build_file_template(repository_ctx)

def expand_all_standard_openjdk_templates(repository_ctx):
    _expand_jdk_package_templates(repository_ctx)
    _expand_java_package_templates(repository_ctx)
    _expand_cc_package_templates(repository_ctx)
    _expand_rust_package_templates(repository_ctx)

def _remote_openjdk_repository_impl(repository_ctx):
    '''Downloads the archive & wraps files within it by instantiating templates.

    Args:
      repository_ctx: A Bazel [repository_ctx](https://docs.bazel.build/versions/master/skylark/lib/repository_ctx.html).

    Returns:
      None
    '''
    # TODO(dwtj): Add support for `exec_compatible_with` attribute.
    if len(repository_ctx.attr.exec_compatible_with) > 0:
       fail("The `remote_openjdk_repository.exec_compatible_with` attribute is not yet supported.")

    download_openjdk_dist_archive(repository_ctx)
    expand_all_standard_openjdk_templates(repository_ctx)

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
    }
)
