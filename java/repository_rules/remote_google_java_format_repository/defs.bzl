"""Defines a repository rule. When this rule is invoked it synthesizes an
external repository. This external repository includes a copy of
`google-java-format` (fetched from the given `url`) and some boilerplate to wrap
this tool in a `google_java_format_toolchain`.
"""

_DEFAULT_GOOGLE_JAVA_FORMAT_JAR_INFO = {
    "url": "https://github.com/google/google-java-format/releases/download/google-java-format-1.8/google-java-format-1.8-all-deps.jar",
    "sha256": "29c864e58db8784028f4871fa4ef1e9cfcc0e5b9939ead09c7f1fc59e64737be",
}

# Maps from a logical name to a path within the synthesized repository.
_REPOSITORY_PATHS = {
    "deploy_jar": "google-java-format_all_deps.jar",
    "defs_bzl_file": "defs.bzl",
    "build_file": "BUILD",
    "colordiff_executable": "colordiff",
}

def _remote_google_java_format_repository_impl(repository_ctx):
    # Try to find a local `colordiff` executable. Otherwise try to find `diff`.
    # Otherwise fail. Symlink the first found into the repository.
    colordiff_path = repository_ctx.which("colordiff")
    if colordiff_path == None:
        fail("Could not find `colordiff` on the PATH.")
    repository_ctx.symlink(colordiff_path, _REPOSITORY_PATHS['colordiff_executable'])

    # Download the JAR file:
    repository_ctx.download(
        url = repository_ctx.attr.url,
        output = _REPOSITORY_PATHS["deploy_jar"],
        sha256 = repository_ctx.attr.sha256,
    )

    # Create the `BUILD` file:
    repository_ctx.template(
        _REPOSITORY_PATHS["build_file"],
        repository_ctx.attr._build_file_template,
        substitutions = {
            "{GOOGLE_JAVA_FORMAT_DEPLOY_JAR}": _REPOSITORY_PATHS["deploy_jar"],
            "{COLORDIFF_EXECUTABLE}": _REPOSITORY_PATHS['colordiff_executable'],
        },
        executable = False,
    )

    # Create the `defs.bzl` file:
    repository_ctx.template(
        _REPOSITORY_PATHS["defs_bzl_file"],
        repository_ctx.attr._defs_bzl_file_template,
        substitutions = {
            "{REPOSITORY_NAME}": repository_ctx.attr.name,
        },
        executable = False,
    )

    # TODO(dwtj): Figure out how the return value should be set.
    return None

remote_google_java_format_repository = repository_rule(
    implementation = _remote_google_java_format_repository_impl,
    attrs = {
        "url": attr.string(
            default = _DEFAULT_GOOGLE_JAVA_FORMAT_JAR_INFO['url'],
        ),
        "sha256": attr.string(
            default = _DEFAULT_GOOGLE_JAVA_FORMAT_JAR_INFO['sha256'],
        ),
        "_build_file_template": attr.label(
            default = Label("@dwtj_rules_java//java:repository_rules/remote_google_java_format_repository/TEMPLATE.BUILD"),
            allow_single_file = True,
        ),
        "_defs_bzl_file_template": attr.label(
            default = Label("@dwtj_rules_java//java:repository_rules/remote_google_java_format_repository/TEMPLATE.defs.bzl"),
            allow_single_file = True,
        ),
    },
    local = True,
    environ = [
        # NOTE(dwtj): This rule uses `which` to search `PATH` for `colordiff`.
        "PATH",
    ],
)
