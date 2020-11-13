'''https://aws.amazon.com/corretto/
'''

load("//java:common/structs/KnownOpenJdkRepository.bzl", _KnownOpenJdkRepository = "KnownOpenJdkRepository")

def amazon_corretto_repositories():
    return _KNOWN_OPENJDK_REPOSITORIES

def _Repo(**kwargs):
    kwargs['provider'] = "amazon_corretto"
    return _KnownOpenJdkRepository(**kwargs)

_KNOWN_OPENJDK_REPOSITORIES = [
    # https://github.com/corretto/corretto-jdk ################################
    _Repo(
        version = "15.0.1.9.1",
        url = "https://corretto.aws/downloads/resources/15.0.1.9.1/amazon-corretto-15.0.1.9.1-linux-x64.tar.gz",
        sha256 = "6bd07d74e11deeba9f8927f8353aa689ffaa2ada263b09a4c297c0c58887af0f",
        strip_prefix = "amazon-corretto-15.0.1.9.1-linux-x64",
    ),
    _Repo(
        version = "15.0.0.36.1",
        url = "https://corretto.aws/downloads/resources/15.0.0.36.1/amazon-corretto-15.0.0.36.1-macosx-x64.tar.gz",
        sha256 = "aea3c3adac0f44e8277220196272614bb60da62ed2fa7fb1de2e2d1daf2edb0b",
        strip_prefix = "amazon-corretto-15.0.0.36.1-macos-x64/Contents/Home",
        os = "macos",
    ),

    # https://github.com/corretto/corretto-11 #################################
    _Repo(
        version = "11.0.9.12.1",
        url = "https://corretto.aws/downloads/resources/11.0.9.12.1/amazon-corretto-11.0.9.12.1-linux-x86.tar.gz",
        sha256 = "27f951f6011c32b4940a4b2af63bfa112d9917487cb89ee3212dedcffa0c203a",
        strip_prefix = "amazon-corretto-11.0.9.12.1-linux-x64",
    ),
    _Repo(
        version = "11.0.9.12.1",
        url = "https://corretto.aws/downloads/resources/11.0.9.12.1/amazon-corretto-11.0.9.12.1-macosx-x64.tar.gz",
        sha256 = "d7236532259050e07f52b79523ebbb701738637b22f145aeaf3e00bbd7656e39",
        strip_prefix = "amazon-corretto-11.jdk/Contents/Home",
        os = "macos",
    ),

    # https://github.com/corretto/corretto-8 ##################################
    _Repo(
        version = "8.272.10.3",
        url = "https://corretto.aws/downloads/resources/8.272.10.3/amazon-corretto-8.272.10.3-linux-x64.tar.gz",
        sha256 = "5e06514bc20e2967c3cad0fddc61451370e150a91d6f67b1bf2083b6bbc230d2",
        strip_prefix = "amazon-corretto-8.272.10.3-linux-x64",
    ),
    _Repo(
        version = "8.275.01.1",
        url = "https://corretto.aws/downloads/resources/8.275.01.1/amazon-corretto-8.275.01.1-macosx-x64.tar.gz",
        sha256 = "b5dd0b0e0a080bfdbb030f25b86200ca01763976d226bc8b8963906f9438a50b",
        strip_prefix = "amazon-corretto-8.275.01.1-linux-x64/Contents/Home",
        os = "macos",
    ),
]
