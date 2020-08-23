workspace(name = "dwtj_rules_java")

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

_STARDOC_TAG = "0.4.0"
_STARDOC_SHA256 = "6d07d18c15abb0f6d393adbd6075cd661a2219faab56a9517741f0fc755f6f3c"

http_archive(
    name = "io_bazel_stardoc",
    url = "https://github.com/bazelbuild/stardoc/archive/{}.tar.gz".format(_STARDOC_TAG),
    sha256 = _STARDOC_SHA256,
    strip_prefix = "stardoc-{}".format(_STARDOC_TAG),
)

load("@io_bazel_stardoc//:setup.bzl", "stardoc_repositories")
stardoc_repositories()
