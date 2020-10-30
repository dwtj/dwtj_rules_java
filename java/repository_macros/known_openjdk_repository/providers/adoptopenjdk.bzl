'''https://adoptopenjdk.net
'''

load("//java:common/structs/KnownOpenJdkRepository.bzl", _KnownOpenJdkRepository = "KnownOpenJdkRepository")

def adoptopenjdk_repositories():
    return _KNOWN_OPENJDK_REPOSITORIES

def _Repo(**kwargs):
    kwargs['provider'] = "adoptopenjdk"
    return _KnownOpenJdkRepository(**kwargs)

_KNOWN_OPENJDK_REPOSITORIES = [
    # jdk-15.0.1+9 ############################################################
    _Repo(
        version = "15.0.1+9",
        url = "https://github.com/AdoptOpenJDK/openjdk15-binaries/releases/download/jdk-15.0.1%2B9/OpenJDK15U-jdk_x64_linux_hotspot_15.0.1_9.tar.gz",
        sha256 = "61045ecb9434e3320dbc2c597715f9884586b7a18a56d29851b4d4a4d48a2a5e",
        strip_prefix = "jdk-15.0.1+9",
    ),
    # TODO(dwtj): Re-enable this once I've checked that it works.
    # _Repo(
    #     version = "15.0.1+9_openj9-0.23.0",
    #     jvm = "openj9",
    #     url = "https://github.com/AdoptOpenJDK/openjdk15-binaries/releases/download/jdk-15.0.1%2B9/OpenJDK15U-jdk_x64_linux_hotspot_15.0.1_9.tar.gz",
    #     sha256 = "b1561f7a69c977bfc9991e61e96dcb200c39300dd9ad423254af117c189e4a8d",
    #     strip_prefix = "jdk-15.0.1+9",
    # ),

    # jdk-11.0.9+11 ###########################################################
    _Repo(
        version = "11.0.9+11.1",
        url = "https://github.com/AdoptOpenJDK/openjdk11-binaries/releases/download/jdk-11.0.9%2B11.1/OpenJDK11U-jdk_x64_linux_hotspot_11.0.9_11.tar.gz",
        sha256 = "a3c52b73a76bed0f113604165eb4f2020b767e188704d8cc0bfc8bc4eb596712",
        strip_prefix = "jdk-11.0.9+11",
    ),
    # TODO(dwtj): Re-enable this once I've checked that it works.
    # _Repo(
    #     version = "11.0.9+11_openj9-0.23.0",
    #     jvm = "openj9",
    #     url = "https://github.com/AdoptOpenJDK/openjdk11-binaries/releases/download/jdk-11.0.9%2B11_openj9-0.23.0/OpenJDK11U-jdk_x64_linux_openj9_11.0.9_11_openj9-0.23.0.tar.gz",
    #     sha256 = "812d58fac39465802039291a1bc530b4feaaa61b58664d9c458a075921ae8091",
    #     strip_prefix = "jdk-11.0.9+11",
    # ),

    # jdk8u272-b10 ############################################################
    _Repo(
        version = "8u272-b10",
        url = "https://github.com/AdoptOpenJDK/openjdk8-binaries/releases/download/jdk8u272-b10/OpenJDK8U-jdk_x64_linux_hotspot_8u272b10.tar.gz",
        sha256 = "6f124b69d07d8d3edf39b9aa5c58473f63a380b686ddb73a5495e01d25c2939a",
        strip_prefix = "jdk8u272-b10",
    ),
    # TODO(dwtj): Re-enable this once I've checked that it works.
    # _Repo(
    #     version = "8u272-b10_openj9-0.23.0",
    #     jvm = "openj9",
    #     url = "https://github.com/AdoptOpenJDK/openjdk8-binaries/releases/download/jdk8u272-b10_openj9-0.23.0/OpenJDK8U-jdk_x64_linux_openj9_8u272b10_openj9-0.23.0.tar.gz",
    #     sha256 = "ca852f976e5b27ccd9b73a527a517496bda865b2ae2a85517ca74486fb8de7da",
    #     strip_prefix = "jdk8u272-b10",
    # ),
]
