'''Implements the `java_compiler_toolchain` rule.

Java compiler toolchain instances are created with `java_compiler_toolchain`
rule instances. A separate `toolchain` rule instance is used to declare a
`java_compiler_toolchain` instance has the type
`@dwtj_rules_java//java/toolchains/java_compiler_toolchain:toolchain_type`.
See [the Bazel Toolchain documentation][1] for more information.

An example might look something like this:

```build
java_compiler_toolchain(
    name = "_my_javac",
    javac_executable = ":my_javac_executable",
)

toolchain(
    name = "my_javac",
    exec_compatible_with = [
        ...
    ],
    target_compatible_with = [
        ...
    ],
    toolchain = ":_my_javac",
    toolchain_type = "@dwtj_rules_java//java/toolchains/java_compiler_toolchain:toolchain_type",
)
```

[1]: https://docs.bazel.build/versions/3.4.0/toolchains.html
'''

JavaCompilerToolchainInfo = provider(
    doc = "Specifies the tools, scripts, and configuration needed to compile and JAR Java targets.",
    fields = {
        "javac_executable": "A `javac` executable file (in the host configuration).",
        "jar_executable": "A `jar` executable file (in the host configuration).",
        "compile_java_jar_script_template": "A template for a script which is used to compile Java sources to a JAR file.",
        "class_path_separator": "The class path separator to use when invoking this `javac` executable."
    },
)

def _java_compiler_toolchain_impl(ctx):
    java_compiler_toolchain_info = JavaCompilerToolchainInfo(
        javac_executable = ctx.file.javac_executable,
        jar_executable = ctx.file.jar_executable,
        compile_java_jar_script_template = ctx.file._compile_java_jar_script_template,
        class_path_separator = ctx.attr.class_path_separator,
    )

    toolchain_info = platform_common.ToolchainInfo(
        java_compiler_toolchain_info = java_compiler_toolchain_info,
    )

    return [
        toolchain_info,
        java_compiler_toolchain_info,
    ]

java_compiler_toolchain = rule(
    implementation = _java_compiler_toolchain_impl,
    attrs = {
        "javac_executable": attr.label(
            allow_single_file = True,
            mandatory = True,
            executable = True,
            cfg = "host",
        ),
        "jar_executable": attr.label(
            allow_single_file = True,
            mandatory = True,
            executable = True,
            cfg = "host",
        ),
        # NOTE(dwtj): This seems like a somewhat roundabout way to make this
        #  template available for instantiation in the `compile_java_jar()`
        #  helper function, but I haven't yet figured out another way to do it
        #  which resolves the label to a `File`.
        # TODO(dwtj): Try the `Label()` constructor.
        "_compile_java_jar_script_template": attr.label(
            default = "//java:common/actions/TEMPLATE.compile_java_jar.sh",
            allow_single_file = True,
        ),
        "class_path_separator": attr.string(
            default = ":",  # Defaults to the Unix-like class-path separator.
        )
    },
    provides = [JavaCompilerToolchainInfo]
)
