'''Implements the `java_compiler_toolchain` rule.

Java compiler toolchain instances are created with `java_compiler_toolchain`
rule instances. A separate `toolchain` rule instance is used to declare a
`java_compiler_toolchain` instance has the type
`@dwtj_rules_java//java/toolchains/java_compiler_toolchain:toolchain_type`.
See [the Bazel Toolchain documentation][1] for more information.

An example might look something like this:

```build
java_compiler_toolchain(
    name = "my_javac",
    javac_executable = ":my_javac_executable",
)

toolchain(
    name = "my_javac_toolchain",
    exec_compatible_with = [
        ...
    ],
    target_compatible_with = [
        ...
    ],
    toolchain = ":my_javac",
    toolchain_type = "@dwtj_rules_java//java/toolchains/java_compiler_toolchain:toolchain_type",
)
```

[1]: https://docs.bazel.build/versions/3.4.0/toolchains.html
'''

JavaCompilerToolchainInfo = provider(
    fields = {
        "javac_executable": "A `javac` executable file (in the host configuration).",
        "jar_executable": "A `jar` executable file (in the host configuration).",
        "build_jar_from_java_sources_script_template": "A template for a script which is used to compile Java sources to a JAR file.",
    },
)

def _java_compiler_toolchain_impl(ctx):
    toolchain_info = platform_common.ToolchainInfo(
        java_compiler_toolchain_info = JavaCompilerToolchainInfo(
            javac_executable = ctx.file.javac_executable,
            jar_executable = ctx.file.jar_executable,
            build_jar_from_java_sources_script_template = ctx.file._build_jar_from_java_sources_script_template,
        ),
    )
    return [toolchain_info]

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
        # TODO(dwtj): This seems like a somewhat roundabout way to make this
        #  template available for instantiation in the
        #  `build_jar_from_java_sources` helper function, but I haven't yet
        #  figured out another way to do it which resolves the label to a file.
        "_build_jar_from_java_sources_script_template": attr.label(
            default = ":rules/common/build/TEMPLATE.build_jar_from_java_sources.sh",
            allow_single_file = True,
        ),
    }
)