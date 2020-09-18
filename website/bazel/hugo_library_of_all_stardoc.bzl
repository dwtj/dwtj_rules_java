# TODO(dwtj): This file is largely similar to the file
#  `@dwtj_rules_hugo_website//bazel:hugo_library_of_all_stardoc.bzl`. Consider
#  implementing this functionality in a common way to avoid this duplication.
load("@dwtj_rules_hugo//hugo:defs.bzl", "hugo_library")
load("@dwtj_rules_hugo_website//bazel:hugo_import_stardoc.bzl", "hugo_import_stardoc")

_ALL_STARDOC_IMPORTS = {
    "@dwtj_rules_java//java:rules/java_agent.bzl": "java_agent",
    "@dwtj_rules_java//java:rules/java_binary.bzl": "java_binary",
    "@dwtj_rules_java//java:rules/java_import.bzl": "java_import",
    "@dwtj_rules_java//java:rules/java_library.bzl": "java_library",
    "@dwtj_rules_java//java:rules/java_test.bzl": "java_test",
    "@dwtj_rules_java//java:rules/legacy_java_import.bzl": "legacy_java_import",
}

def _front_matter(title):
    return \
"""+++
title = "{}"
+++
""".format(title)

def hugo_library_of_all_stardoc(name, all_bzl):
    '''Create a `hugo_library` which wraps all of the indicated stardoc content.

    Args:
      name: The name of the created `hugo_library`.
      all_bzl: The label of a `bzl_library` target which includes all bzl deps.
    Returns:
      `None`
    '''

    for (in_file_label, content_name) in _ALL_STARDOC_IMPORTS.items():
        hugo_import_stardoc(
            name = content_name,
            hugo_path = "content/" + content_name + ".md",
            stardoc_input = in_file_label,
            bzl_deps = [all_bzl],
            add_front_matter = _front_matter(content_name),
        )

    all_hugo_imports = _ALL_STARDOC_IMPORTS.values()
    hugo_library(
        name = name,
        deps = all_hugo_imports,
    )
