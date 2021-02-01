'''Defines some helper macros to be called in a `WORKSPACE` file to add some
external repositories.
'''

load(
    "@bazel_tools//tools/build_defs/repo:http.bzl",
    "http_archive",
)

load(
    "@dwtj_rules_java//java:repositories.bzl",
    "dwtj_remote_openjdk_repository",
)

load(
    "@dwtj_rules_java//graalvm:repositories.bzl",
    "remote_graalvm_repository",
)

_BAZELBUILD_PLATFORMS_RELEASE_VERSION = "0.0.1"
_BAZELBUILD_PLATFORMS_RELEASE_SHA256 = "0fc19efca1dfc5c1448c98f050639e3a48beb0031701d55bea5eb546507970f2"

def platforms(name = "platforms"):
    http_archive(
        name = name,
        url = "https://github.com/bazelbuild/platforms/archive/{}.tar.gz".format(_BAZELBUILD_PLATFORMS_RELEASE_VERSION),
        sha256 = _BAZELBUILD_PLATFORMS_RELEASE_SHA256,
        strip_prefix = "platforms-{}".format(_BAZELBUILD_PLATFORMS_RELEASE_VERSION),
    )

_REMOTE_GRAALVM_VERSION = "20.2.0"
_REMOTE_GRAALVM_LINUX_X64_ARCHIVE_SHA256 = "5db74b5b8888712d2ac3cd7ae2a8361c2aa801bc94c801f5839351aba5064e29"
_REMOTE_GRAALVM_LINUX_X64_NATIVE_IMAGE_INSTALLABLE_JAR_SHA256 = "92b429939f12434575e4d586f79c5b686d322f29211d1608ed6055a97a35925c"

def remote_graalvm_linux_x64(name = "remote_graalvm_linux_x64"):
    remote_graalvm_repository(
        name = name,
        url = "https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-{0}/graalvm-ce-java11-linux-amd64-{0}.tar.gz".format(_REMOTE_GRAALVM_VERSION),
        sha256 = _REMOTE_GRAALVM_LINUX_X64_ARCHIVE_SHA256,
        strip_prefix = "graalvm-ce-java11-{}".format(_REMOTE_GRAALVM_VERSION),
        native_image_installable_jar_url = "https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-{0}/native-image-installable-svm-java11-linux-amd64-{0}.jar".format(_REMOTE_GRAALVM_VERSION),
        native_image_installable_jar_sha256 = _REMOTE_GRAALVM_LINUX_X64_NATIVE_IMAGE_INSTALLABLE_JAR_SHA256,
        os = "linux",
        cpu = "x64",
    )

_REMOTE_GRAALVM_DARWIN_X64_ARCHIVE_SHA256 = "e9df2caace6f90fcfbc623c184ef1bbb053de20eb4cf5b002d708c609340ba7a"
_REMOTE_GRAALVM_DARWIN_X64_NATIVE_IMAGE_INSTALLABLE_JAR_SHA256 = "d60c321d6e680028f37954121eeebff0839a0a49a4436e5b41c636c3dd951de3"

def remote_graalvm_macos_x64(name = "remote_graalvm_macos_x64"):
    remote_graalvm_repository(
        name = name,
        url = "https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-{0}/graalvm-ce-java11-darwin-amd64-{0}.tar.gz".format(_REMOTE_GRAALVM_VERSION),
        sha256 = _REMOTE_GRAALVM_DARWIN_X64_ARCHIVE_SHA256,
        strip_prefix = "graalvm-ce-java11-{}/Contents/Home".format(_REMOTE_GRAALVM_VERSION),
        native_image_installable_jar_url = "https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-{0}/native-image-installable-svm-java11-darwin-amd64-{0}.jar".format(_REMOTE_GRAALVM_VERSION),
        native_image_installable_jar_sha256 = _REMOTE_GRAALVM_DARWIN_X64_NATIVE_IMAGE_INSTALLABLE_JAR_SHA256,
        os = "macos",
        cpu = "x64",
    )

def remote_openjdk_linux_x64(name = "remote_openjdk_linux_x64"):
    dwtj_remote_openjdk_repository(
        name = name,
        url = "https://github.com/AdoptOpenJDK/openjdk11-binaries/releases/download/jdk-11.0.9%2B11.1/OpenJDK11U-jdk_x64_linux_hotspot_11.0.9_11.tar.gz",
        sha256 = "a3c52b73a76bed0f113604165eb4f2020b767e188704d8cc0bfc8bc4eb596712",
        strip_prefix = "jdk-11.0.9+11",
        os = "linux",
        cpu = "x64",
    )

def remote_openjdk_macos_x64(name = "remote_openjdk_macos_x64"):
    dwtj_remote_openjdk_repository(
        name = name,
        url = "https://github.com/AdoptOpenJDK/openjdk11-binaries/releases/download/jdk-11.0.9%2B11.1/OpenJDK11U-jdk_x64_mac_hotspot_11.0.9_11.tar.gz",
        sha256 = "7b21961ffb2649e572721a0dfad64169b490e987937b661cb4e13a594c21e764",
        strip_prefix = "jdk-11.0.9+11/Contents/Home/",
        os = "macos",
        cpu = "x64",
    )

_RULES_CC_COMMIT = "b1c40e1de81913a3c40e5948f78719c28152486d"
_RULES_CC_SHA256 = "71d037168733f26d2a9648ad066ee8da4a34a13f51d24843a42efa6b65c2420f"

def rules_cc():
    http_archive(
        name = "rules_cc",
        urls = ["https://github.com/bazelbuild/rules_cc/archive/{}.tar.gz".format(_RULES_CC_COMMIT)],
        strip_prefix = "rules_cc-{}".format(_RULES_CC_COMMIT),
        sha256 = _RULES_CC_SHA256,
    )

# Latest commit to master branch as of 2021-02-01.
_RULES_RUST_COMMIT = "4fbf3cf1d7b2c4626abfe7f38c857895dda44cd0"
_RULES_RUST_SHA256 = "79ad97b2b60ab580c01b7403c37c09e41a0ce5251d4126fccb862eb9e78e2501"

def rules_rust():
    http_archive(
        name = "rules_rust",
        url = "https://github.com/bazelbuild/rules_rust/archive/{}.tar.gz".format(_RULES_RUST_COMMIT),
        sha256 = _RULES_RUST_SHA256,
        strip_prefix = "rules_rust-{}".format(_RULES_RUST_COMMIT),
    )

RULES_JVM_EXTERNAL_ARCHIVE_INFO = {
    "tag": "3.3",
    "sha256": "d85951a92c0908c80bd8551002d66cb23c3434409c814179c0ff026b53544dab",
}

def rules_jvm_external(name = "rules_jvm_external"):
    http_archive(
        name = name,
        strip_prefix = "rules_jvm_external-%s" % RULES_JVM_EXTERNAL_ARCHIVE_INFO["tag"],
        sha256 = RULES_JVM_EXTERNAL_ARCHIVE_INFO["sha256"],
        url = "https://github.com/bazelbuild/rules_jvm_external/archive/%s.zip" % RULES_JVM_EXTERNAL_ARCHIVE_INFO["tag"],
    )
