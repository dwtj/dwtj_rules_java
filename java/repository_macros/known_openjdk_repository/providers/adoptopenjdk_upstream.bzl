'''https://adoptopenjdk.net/upstream.html
'''

load("//java:common/structs/KnownOpenJdkRepository.bzl", _KnownOpenJdkRepository = "KnownOpenJdkRepository")

def adoptopenjdk_upstream_repositories():
    return _KNOWN_OPENJDK_REPOSITORIES

def _Repo(**kwargs):
    kwargs['provider'] = "adoptopenjdk_upstream"
    return _KnownOpenJdkRepository(**kwargs)

_KNOWN_OPENJDK_REPOSITORIES = [
    # JDK-11.0.9+11 ###########################################################
    _Repo(
        version = "11.0.9+11",
        url = "https://github.com/AdoptOpenJDK/openjdk11-upstream-binaries/releases/download/jdk-11.0.9%2B11/OpenJDK11U-jdk_x64_linux_11.0.9_11.tar.gz",
        sha256 = "4fe78ca6a3afbff9c3dd7c93cc84064dcaa15578663362ded2c0d47552201e70",
        strip_prefix = "openjdk-11.0.9_11",
    ),
    _Repo(
        version = "11.0.9+11",
        os = "windows",
        url = "https://github.com/AdoptOpenJDK/openjdk11-upstream-binaries/releases/download/jdk-11.0.9%2B11/OpenJDK11U-jdk_x64_windows_11.0.9_11.zip",
        sha256 = "a440f37531b44ee3475c9e5466e5d0545681419784fbe98ad371938e034d9d37",
        strip_prefix = "openjdk-11.0.9_11",
    ),

    # JDK8u272-b10 ############################################################
    _Repo(
        version = "8u272-b10",
        url = "https://github.com/AdoptOpenJDK/openjdk8-upstream-binaries/releases/download/jdk8u272-b10/OpenJDK8U-jdk_x64_linux_8u272b10.tar.gz",
        sha256 = "654a0b082be0c6830821f22a9e1de5f9e2feb9705db79e3bb0d8c203d1b12c6a",
        strip_prefix = "openjdk-8u272-b10",
    ),
    _Repo(
        version = "8u272-b10",
        os = "windows",
        url = "https://github.com/AdoptOpenJDK/openjdk8-upstream-binaries/releases/download/jdk8u272-b10/OpenJDK8U-jdk_x64_windows_8u272b10.zip",
        sha256 = "63fe8a555ae6553bd6f6f0937135c31e9adbb3b2ac85232e495596d39f396b1d",
        strip_prefix = "openjdk-8u272-b10",
    ),
]
