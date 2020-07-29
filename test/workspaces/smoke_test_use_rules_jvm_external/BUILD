load(
    "@dwtj_rules_java//java:defs.bzl",
    "dwtj_java_test",
    "dwtj_legacy_java_import",
)

dwtj_legacy_java_import(
    name = "asm_wrapper",
    imports = ["@maven//:org_ow2_asm_asm"],
)

dwtj_java_test(
    name = "MyTest",
    srcs = ["MyTest.java"],
    main_class = "MyTest",
    deps = [":asm_wrapper"],
)