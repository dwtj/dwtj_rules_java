load("//java:common/structs/KnownOpenJdkRepository.bzl", _KnownOpenJdkRepository = "KnownOpenJdkRepository")

def default_repositories():
    return _KNOWN_OPENJDK_REPOSITORIES

def _Repo(**kwargs):
    kwargs['provider'] = "__default__"
    return _KnownOpenJdkRepository(**kwargs)

_KNOWN_OPENJDK_REPOSITORIES = [
    # NOTE(dwtj): Currently, the default repositories are JDK-15.0.1 from `java.net`.
    _Repo(
        version = "__default__",
        url = "https://download.java.net/java/GA/jdk15.0.1/51f4f36ad4ef43e39d0dfdbaf6549e32/9/GPL/openjdk-15.0.1_linux-x64_bin.tar.gz",
        sha256 = "83ec3a7b1649a6b31e021cde1e58ab447b07fb8173489f27f427e731c89ed84a",
        strip_prefix = "jdk-15.0.1",
    ),
    _Repo(
        version = "__default__",
        cpu_arch = "aarch64",
        url = "https://download.java.net/java/GA/jdk15.0.1/51f4f36ad4ef43e39d0dfdbaf6549e32/9/GPL/openjdk-15.0.1_linux-aarch64_bin.tar.gz",
        sha256 = "6a62b7ec065280bad978a3322733a089153dec5ebf5ba81fd2fa361382dbc7b0",
        strip_prefix = "jdk-15.0.1",
    ),
    _Repo(
        version = "__default__",
        url = "https://download.java.net/java/GA/jdk15.0.1/51f4f36ad4ef43e39d0dfdbaf6549e32/9/GPL/openjdk-15.0.1_osx-x64_bin.tar.gz",
        sha256 = "e1d4868fb082d9202261c5a05251eded56fb805da2d641a65f604988b00b1979",
        strip_prefix = "jdk-15.0.1.jdk/Contents/Home",
        os = "macos",
    ),
    _Repo(
        version = "__default__",
        url = "https://download.java.net/java/GA/jdk15.0.1/51f4f36ad4ef43e39d0dfdbaf6549e32/9/GPL/openjdk-15.0.1_windows-x64_bin.zip",
        sha256 = "0a27c733fc7ceaaae3856a9c03f5e2304af30a32de6b454b8762ec02447c5464",
        strip_prefix = "jdk-15.0.1",
        os = "windows",
    ),
]
