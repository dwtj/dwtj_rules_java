'''Exports all aspect definitions for public use.

These aspects can be used to perform additional processing over Java rules.
Some users may find these aspects useful.
'''

load("//java:aspects/google_java_format_aspect/defs.bzl", _google_java_format_aspect = "google_java_format_aspect")

load("//java:aspects/javadoc_aspect/defs.bzl", _javadoc_aspect = "javadoc_aspect")

load("//java:aspects/error_prone_aspect/defs.bzl", _error_prone_aspect = "error_prone_aspect")

google_java_format_aspect = _google_java_format_aspect

javadoc_aspect = _javadoc_aspect

error_prone_aspect = _error_prone_aspect
