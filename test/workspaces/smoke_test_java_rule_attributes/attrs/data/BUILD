load(
    "@dwtj_rules_java//java:defs.bzl",
    "dwtj_java_binary",
    "dwtj_java_test",
)

dwtj_java_binary(
    name = "read_each_line",
    main_class = "attrs.data.ReadEachLine",
    srcs = ["ReadEachLine.java"],
    args = ["$(location :my_data_file.txt)"],
    data = [":my_data_file.txt"],
)

dwtj_java_test(
    name = "read_each_line_test",
    main_class = "attrs.data.ReadEachLine",
    srcs = ["ReadEachLine.java"],
    args = ["$(location :my_data_file.txt)"],
    data = [":my_data_file.txt"],
)
