load("//java:common/structs/KnownOpenJdkRepository.bzl", _KnownOpenJdkRepository = "KnownOpenJdkRepository")

def jdk_java_net_repositories():
    return _KNOWN_OPENJDK_REPOSITORIES

def _Repo(**kwargs):
    kwargs['provider'] = "jdk_java_net"
    return _KnownOpenJdkRepository(**kwargs)

_KNOWN_OPENJDK_REPOSITORIES = [

    # JDK 15.0.1 ##############################################################
    # https://jdk.java.net/15/
    _Repo(
        version = "15.0.1",
        url = "https://download.java.net/java/GA/jdk15.0.1/51f4f36ad4ef43e39d0dfdbaf6549e32/9/GPL/openjdk-15.0.1_linux-x64_bin.tar.gz",
        sha256 = "83ec3a7b1649a6b31e021cde1e58ab447b07fb8173489f27f427e731c89ed84a",
        strip_prefix = "jdk-15.0.1",
    ),
    _Repo(
        version = "15.0.1",
        cpu_arch = "aarch64",
        url = "https://download.java.net/java/GA/jdk15.0.1/51f4f36ad4ef43e39d0dfdbaf6549e32/9/GPL/openjdk-15.0.1_linux-aarch64_bin.tar.gz",
        sha256 = "6a62b7ec065280bad978a3322733a089153dec5ebf5ba81fd2fa361382dbc7b0",
        strip_prefix = "jdk-15.0.1",
    ),
    _Repo(
        os = "macos",
        version = "15.0.1",
        url = "https://download.java.net/java/GA/jdk15.0.1/51f4f36ad4ef43e39d0dfdbaf6549e32/9/GPL/openjdk-15.0.1_osx-x64_bin.tar.gz",
        sha256 = "e1d4868fb082d9202261c5a05251eded56fb805da2d641a65f604988b00b1979",
        strip_prefix = "jdk-15.0.1.jdk/Contents/Home",
    ),
    _Repo(
        os = "windows",
        version = "15.0.1",
        url = "https://download.java.net/java/GA/jdk15.0.1/51f4f36ad4ef43e39d0dfdbaf6549e32/9/GPL/openjdk-15.0.1_windows-x64_bin.zip",
        sha256 = "0a27c733fc7ceaaae3856a9c03f5e2304af30a32de6b454b8762ec02447c5464",
        strip_prefix = "jdk-15.0.1",
    ),

    # JDK 14.0.2 ##############################################################
    # http://jdk.java.net/archive/
    _Repo(
        version = "14.0.2",
        url = "https://download.java.net/java/GA/jdk14.0.2/205943a0976c4ed48cb16f1043c5c647/12/GPL/openjdk-14.0.2_linux-x64_bin.tar.gz",
        sha256 = "91310200f072045dc6cef2c8c23e7e6387b37c46e9de49623ce0fa461a24623d",
        strip_prefix = "jdk-14.0.2",
    ),
    _Repo(
        os = "windows",
        version = "14.0.2",
        url = "https://download.java.net/java/GA/jdk14.0.2/205943a0976c4ed48cb16f1043c5c647/12/GPL/openjdk-14.0.2_windows-x64_bin.zip",
        sha256 = "20600c0bda9d1db9d20dbe1ab656a5f9175ffb990ef3df6af5d994673e4d8ff9",
        strip_prefix = "jdk-14.0.2",
    ),
    _Repo(
        os = "macos",
        version = "14.0.2",
        url = "https://download.java.net/java/GA/jdk14.0.2/205943a0976c4ed48cb16f1043c5c647/12/GPL/openjdk-14.0.2_osx-x64_bin.tar.gz",
        sha256 = "386a96eeef63bf94b450809d69ceaa1c9e32a97230e0a120c1b41786b743ae84",
        strip_prefix = "jdk-14.0.2.jdk/Contents/Home",
    ),

    # TODO(dwtj): Consider adding JDK 13.0.2.
    # TODO(dwtj): Consider adding JDK 12.0.2.
    # TODO(dwtj): Consider adding JDK 11.0.2.
    # TODO(dwtj): Consider adding JDK 10.0.2.
    # TODO(dwtj): Consider adding JDK 9.0.4.
]
