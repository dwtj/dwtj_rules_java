load("@rules_cc//cc:defs.bzl", "cc_binary")
load("@dwtj_rules_java//java:defs.bzl", "dwtj_java_binary")

# TODO(dwtj): This target outputs class files to `/tmp`, because without
#  specifying a class output directory, I get errors about the sandbox's
#  read-only filesystem.
#
#  I don't like that we put class files in `/tmp`, but I'm not sure where to put
#  them. I would rather not output them anywhere, but if we have to output
#  them somewhere, I would prefer that they are placed within the sandbox (where
#  they will be immediately deleted.) Unfortunately, it isn't clear to me how I
#  can do either of these things.
#
#  Another even better approach: extend `dwtj_java_library` to properly support
#  header generation.
genrule(
    name = "javah",
    srcs = ["MyLib.java"],
    outs = ["cc_jni_MyLib.h"],
    cmd_bash = 'javac -d /tmp -h `dirname "$(location cc_jni_MyLib.h)"` "$(location MyLib.java)"'
)

cc_binary(
    name = "myjni",
    srcs = [
        "cc_jni_MyLib.h",
        "cc_jni_MyLib.cc",
    ],
    linkshared = True,
    deps = [
        "//third_party/openjdk:jni_headers",
    ],
)

dwtj_java_binary(
    name = "MyLib",
    main_class = "cc.jni.MyLib",
    srcs = ["MyLib.java"],
    output_jar = "MyLib.jar",
)

sh_test(
    name = "test",
    srcs = ["test.sh"],
    data = [
        ":myjni",
        ":MyLib.jar",
    ],
    args = [
        "cc/jni",
        "$(location :MyLib.jar)",
    ],
)
