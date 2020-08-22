'''Defines the `maven_error_prone_repository` repository rule.

This rule is used to create an Error Prone toolchain using dependencies obtained
from Maven. The `@rules_jvm_external` rules must be available for this
repository rule to work.
'''

def _maven_error_prone_repository_impl(repository_ctx):
    repository_ctx.template(
        "BUILD",
        repository_ctx.attr._build_file_template,
        substitutions = {
            "{REPOSITORY_NAME}": repository_ctx.name,
        },
        executable = False,
    )

    repository_ctx.template(
        "defs.bzl",
        repository_ctx.attr._defs_bzl_file_template,
        substitutions = {
            "{REPOSITORY_NAME}": repository_ctx.name,
        },
        executable = False,
    )

    # TODO(dwtj): Figure out how the return value should be set.
    return None

maven_error_prone_repository = repository_rule(
    implementation = _maven_error_prone_repository_impl,
    attrs = {
        "_build_file_template": attr.label(
            default = Label("@dwtj_rules_java//java:repository_rules/maven_error_prone_repository/TEMPLATE.BUILD"),
            allow_single_file = True,
        ),
        "_defs_bzl_file_template": attr.label(
            default = Label("@dwtj_rules_java//java:repository_rules/maven_error_prone_repository/TEMPLATE.defs.bzl"),
            allow_single_file = True,
        ),
    },
    local = False,
)
