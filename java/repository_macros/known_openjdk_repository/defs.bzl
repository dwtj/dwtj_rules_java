load("//java:repository_rules/remote_openjdk_repository/defs.bzl", "remote_openjdk_repository")
load("//java:repository_macros/known_openjdk_repository/providers/default.bzl", "default_repositories")
load("//java:repository_macros/known_openjdk_repository/providers/adoptopenjdk.bzl", "adoptopenjdk_repositories")
load("//java:repository_macros/known_openjdk_repository/providers/adoptopenjdk_upstream.bzl", "adoptopenjdk_upstream_repositories")
load("//java:repository_macros/known_openjdk_repository/providers/jdk_java_net.bzl", "jdk_java_net_repositories")
load("//java:repository_macros/known_openjdk_repository/providers/amazon_corretto.bzl", "amazon_corretto_repositories")
load("//java:common/structs/KnownOpenJdkRepository.bzl", "KnownOpenJdkRepository")

def _known_repositories():
    repos = list()
    repos.extend(default_repositories())
    repos.extend(adoptopenjdk_repositories())
    repos.extend(adoptopenjdk_upstream_repositories())
    repos.extend(jdk_java_net_repositories())
    repos.extend(amazon_corretto_repositories())
    return repos

_KNOWN_REPOSITORIES = _known_repositories()

def _repo_matches_request(repo, requested_repo):
    return repo.provider == requested_repo.provider \
        and repo.os == requested_repo.os \
        and repo.cpu_arch == requested_repo.cpu_arch \
        and repo.jvm == requested_repo.jvm \
        and repo.version == requested_repo.version

def _find_matching_known_repository(**kwargs):
    requested_repo = KnownOpenJdkRepository(**kwargs)
    matched_repos = list()
    for repo in _KNOWN_REPOSITORIES:
        if _repo_matches_request(repo, requested_repo):
            matched_repos.append(repo)
    if len(matched_repos) == 0:
        fail("No known repositories were found which matched the given attribute values.")
    elif len(matched_repos) == 1:
        return matched_repos[0]
    else:
        fail("More than one repository was found which matched the given attribute values.")

def known_openjdk_repository(name = None, **kwargs):
    if not type(name) == "string":
        fail("A `known_openjdk_respository` macro instance must have a `name` attribute of type string.")

    repo = _find_matching_known_repository(**kwargs)
    remote_openjdk_repository(
        name = name,
        url = repo.url,
        sha256 = repo.sha256,
        strip_prefix = repo.strip_prefix,
        os = repo.os,
    )
