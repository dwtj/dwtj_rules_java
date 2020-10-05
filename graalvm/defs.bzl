'''This is the main part of the public API for this project.

This file re-exports all rules for public use.
'''

load("//graalvm:rules/graalvm_native_image/defs.bzl", _graalvm_native_image = "graalvm_native_image")

graalvm_native_image  = _graalvm_native_image
