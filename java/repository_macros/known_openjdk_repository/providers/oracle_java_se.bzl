load("//java:common/structs/KnownOpenJdkRepository.bzl", _KnownOpenJdkRepository = "KnownOpenJdkRepository")

def oracle_java_se_repositories():
    return _KNOWN_OPENJDK_REPOSITORIES

def _Repo(**kwargs):
    kwargs['provider'] = "oracle_java_se"
    return _KnownOpenJdkRepository(**kwargs)

_KNOWN_OPENJDK_REPOSITORIES = [
    # JDK 15.0.1
    # https://www.oracle.com/java/technologies/javase-jdk15-downloads.html
    _Repo(
        version = "jdk-15.0.1",
        url = "https://download.oracle.com/otn-pub/java/jdk/15.0.1%2B9/51f4f36ad4ef43e39d0dfdbaf6549e32/jdk-15.0.1_linux-x64_bin.tar.gz",
        sha256 = "445a1c5c335b53b030f68aca58493ddedd49f4b53085618bc1ae7aba68156606",
        strip_prefix = "jdk-15.0.1",
    ),
    _Repo(
        version = "jdk-15.0.1",
        cpu_arch = "aarch64",
        url = "https://download.oracle.com/otn-pub/java/jdk/15.0.1%2B9/51f4f36ad4ef43e39d0dfdbaf6549e32/jdk-15.0.1_linux-aarch64_bin.tar.gz",
        sha256 = "1dfcb5726d9551bbb0f35789389753505a943ae73545d43a796283a68c0d8feb",
        strip_prefix = "jdk-15.0.1",
    ),
    _Repo(
        version = "jdk-15.0.1",
        os = "windows",
        url = "https://download.oracle.com/otn-pub/java/jdk/15.0.1%2B9/51f4f36ad4ef43e39d0dfdbaf6549e32/jdk-15.0.1_windows-x64_bin.zip",
        sha256 = "deaee48321aa160a2ff9e71296a777faadf3495afd93f77c89c9319db27d6f5f",
        strip_prefix = "jdk-15.0.1",
    ),
    _Repo(
        version = "jdk-15.0.1",
        os = "macos",
        url = "https://download.oracle.com/otn-pub/java/jdk/15.0.1%2B9/51f4f36ad4ef43e39d0dfdbaf6549e32/jdk-15.0.1_osx-x64_bin.tar.gz",
        sha256 = "d19842756ae0e7c27d640004ce7cdc9d3845d5f0088b60332fac64ddfbcb14c7",
        strip_prefix = "jdk-15.0.1.jdk/Contents/Home",
    ),
]
