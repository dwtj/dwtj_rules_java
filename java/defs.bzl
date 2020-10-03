'''This is the main part of the public API for this project.

This file re-exports all rules for public use.
'''

load("//java:rules/java_binary.bzl", "java_binary")

load("//java:rules/java_library.bzl", "java_library")

load("//java:rules/java_import.bzl", "java_import")

load("//java:rules/java_test.bzl", "java_test")

load("//java:rules/legacy_java_import.bzl", "legacy_java_import")

load("//java:rules/java_agent.bzl", "java_agent")

load("//java:rules/graalvm_native_image/defs.bzl", _graalvm_native_image = "graalvm_native_image")

dwtj_java_binary = java_binary

dwtj_java_library = java_library

dwtj_java_import = java_import

dwtj_java_test = java_test

dwtj_legacy_java_import = legacy_java_import

dwtj_java_agent = java_agent

graalvm_native_image  = _graalvm_native_image
