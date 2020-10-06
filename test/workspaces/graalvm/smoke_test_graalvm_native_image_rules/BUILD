#load("@rules_cc//cc:defs.bzl", "cc_library")
#
#genrule(
#    name = "copy_graal_isolate_dynamic_header_into_root_package",
#    cmd_bash = 'cp "$(location //pkg:graal_isolate_dynamic.h)" "$(location :graal_isolate_dynamic.h)"',
#    srcs = ["//pkg:graal_isolate_dynamic.h"],
#    outs = [":graal_isolate_dynamic.h"],
#)
#
#cc_library(
#    name = "graal_isolate_dynamic_header",
#    hdrs = [":graal_isolate_dynamic.h"],
#    visibility = ["//visibility:public"],
#)
