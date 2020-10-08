load("@rules_cc//cc:defs.bzl", "cc_binary")
load("@dwtj_rules_java//java:defs.bzl", "dwtj_java_binary")

dwtj_java_binary(
    name = "Hello",
    main_class = "jvm.Hello",
    srcs = ["Hello.java"],
    output_jar = "Hello.jar",
)

cc_binary(
    name = "jni_invocation_api_test_exec",
    srcs = ["jni_invocation_api_test.cc"],
    deps = ["//third_party/openjdk:jvm"],
)

sh_test(
    name = "jni_invocation_api_test",
    srcs = ["jni_invocation_api_test.sh"],
    args = [
        "$(location :jni_invocation_api_test_exec)",
        "$(location :Hello.jar)",
        "jvm/Hello", # NOTE(dwtj): We use slash-separated not dot-separated
                     #  class. This is what the JNI Invocation API expects.
    ],
    data = [
        ":jni_invocation_api_test_exec",
        ":Hello.jar",
    ],
)
