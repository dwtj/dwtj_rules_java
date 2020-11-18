load("//experimental/graalvm:macros/graalvm_native_image_cc_library.bzl", _graalvm_native_image_cc_library = "graalvm_native_image_cc_library")

load("//experimental/graalvm:rules/graalvm_native_image_library/defs.bzl", _graalvm_native_image_library = "graalvm_native_image_library")

graalvm_native_image_cc_library  = _graalvm_native_image_cc_library

graalvm_native_image_library  = _graalvm_native_image_library
