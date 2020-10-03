load("@rules_cc//cc:defs.bzl", "cc_binary")
load("@dwtj_rules_java//java:defs.bzl", "dwtj_java_binary")

cc_binary(
    name = "myjni",
    srcs = [
        "jni_MyLib.cc",
        "jni_MyLib.h",
    ],
    linkshared = True,
    deps = [
        "//third_party/openjdk:jni_headers",
    ],
)

dwtj_java_binary(
    name = "MyLib",
    main_class = "jni.MyLib",
    srcs = ["MyLib.java"],
    output_jar = "MyLib.jar",
)

sh_test(
    name = "jni_test",
    srcs = ["jni_test.sh"],
    data = [
        ":myjni",
        ":MyLib.jar",
    ],
    args = [
        "jni",
        "$(location :MyLib.jar)",
    ],
)
