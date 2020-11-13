'''This file defines the `remote_openjdk_repository` repository rule. This rule
downloads a remote distribution of OpenJDK and wraps some files of its files in
appropriate Bazel targets. In particular, executables are wrapped in Bazel
toolchains.
'''

def make_exec_compatible_with_str(repository_ctx):
    os_constraints_map = {
        "linux": "@platforms//os:linux",
        "macos": "@platforms//os:macos",
        "windows": "@platforms//os:windows",
    }
    os_constraint = os_constraints_map[repository_ctx.attr.os]
    if os_constraint == None:
        fail("Unexpected `os` attribute value: " + repository_ctx.attr.os)

    cpu_constraints_map = {
        "x64": "@platforms//cpu:x86_64",
        "aarch64": "@platforms//cpu:aarch64",
    }
    cpu_constraint = cpu_constraints_map[repository_ctx.attr.cpu]
    if cpu_constraint == None:
        fail("Unexpected `cpu` attribute value: " + repository_ctx.attr.cpu)

    return """["{}", "{}"]""".format(os_constraint, cpu_constraint)

def _template_label(template_path):
    return Label("@dwtj_rules_java//java:repository_rules/remote_openjdk_repository/" + template_path)

def _guess_jni_md_header_label(repository_ctx):
    return "//jdk:{}/jni_md.h".format(_guess_jni_md_header_dir(repository_ctx))

def _guess_jni_md_header_dir(repository_ctx):
    map = {
        "linux": "include/linux",
        "macos": "include/darwin",
    }
    dir = map[repository_ctx.attr.os]
    if dir == None:
        fail('Unexpected repository rule attribute value: `os` is "{}".'.format(repository_ctx.attr.os))
    return dir

def _guess_jvm_shared_library_file(repository_ctx):
    map = {
        "linux": "lib/server/libjvm.so",
        "macos": "lib/server/libjvm.dylib",
    }
    file = map[repository_ctx.attr.os]
    if file == None:
        fail('Unexpected repository rule attribute value: `os` is "{}".'.format(repository_ctx.attr.os))
    return file

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
            "{EXEC_COMPATIBLE_WITH}": make_exec_compatible_with_str(repository_ctx),
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
            "{JNI_MD_HEADER_DIR}": _guess_jni_md_header_dir(repository_ctx),
        },
        executable = False,
    )

def _expand_cc_jvm_build_file_template(repository_ctx):
    repository_ctx.template(
        "cc/jvm/BUILD",
        _template_label("cc/jvm/TEMPLATE.BUILD"),
        substitutions = {
            "{REPOSITORY_NAME}": repository_ctx.name,
            "{JVM_SHARED_LIBRARY_FILE}": _guess_jvm_shared_library_file(repository_ctx),
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
            "{REPOSITORY_NAME}":     repository_ctx.name,
            "{JNI_HEADER_LABEL}":    "//jdk:include/jni.h",
            "{JNI_MD_HEADER_LABEL}": _guess_jni_md_header_label(repository_ctx),
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
            "{JNI_MD_HEADER_LABEL}": _guess_jni_md_header_label(repository_ctx),
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
    expand_all_standard_openjdk_templates(repository_ctx)
    download_openjdk_dist_archive(repository_ctx)

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
            mandatory = True,
        ),
        # TODO(dwtj): Consider ways to infer this attribute from context.
        "os": attr.string(
            mandatory = True,
            values = [
                "linux",
                "macos",
            ],
        ),
        "cpu": attr.string(
            mandatory = True,
            values = [
                "x64",
                "aarch64",
            ],
        ),
    }
)
