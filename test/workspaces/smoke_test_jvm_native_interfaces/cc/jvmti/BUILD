load("@rules_cc//cc:defs.bzl", "cc_binary")
load("@dwtj_rules_java//java:defs.bzl", "dwtj_java_binary")

cc_binary(
    name = "myagent",
    srcs = ["myagent.cc"],
    linkshared = True,
    deps = [
        "//third_party/openjdk:jni_headers",
        "//third_party/openjdk:jvmti_headers",
    ],
)

# TODO(dwtj): Make this test actually check to make sure that the Agent is
#  actually run.
dwtj_java_binary(
    name = "MyBin",
    main_class = "cc.jvmti.MyBin",
    srcs = ["MyBin.java"],
    output_jar = "MyBin.jar",
)

sh_test(
    name = "agent_test",
    srcs = ["agent_test.sh"],
    data = [
        ":myagent",
        ":MyBin.jar",
    ],
    args = [
        "cc/jvmti/libmyagent.so",
        "$(location :MyBin.jar)",
    ]
)
