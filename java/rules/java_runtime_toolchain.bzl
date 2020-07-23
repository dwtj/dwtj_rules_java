'''Implements the `java_runtime_toolchain` rule.

Java runtime toolchain instances are created with `java_runtime_toolchain`
rule instances. A separate `toolchain` rule instance is used to declare a
`java_runtime_toolchain` instance has the type
`@dwtj_rules_java//java/toolchains/java_runtime_toolchain:toolchain_type`.
See [the Bazel Toolchain documentation][1] for more information.

An example might look something like this:

```build
java_runtime_toolchain(
    name = "my_java",
    java_executable = ":my_java_executable",
)

toolchain(
    name = "my_java_toolchain",
    exec_compatible_with = [
        ...
    ],
    target_compatible_with = [
        ...
    ],
    toolchain = ":my_java",
    toolchain_type = "@dwtj_rules_java//java/toolchains/java_runtime_toolchain:toolchain_type",
)
```

---

[1]: https://docs.bazel.build/versions/3.4.0/toolchains.html
'''

JavaRuntimeToolchainInfo = provider(
    fields = {
        "java_executable": "A `java` executable file (in the host configuration).",
    },
)

def _java_compiler_toolchain_impl(ctx):
    toolchain_info = platform_common.ToolchainInfo(
        java_runtime_toolchain_info = JavaRuntimeToolchainInfo(
            javac_executable = ctx.file.java_executable,
        ),
    )
    return [toolchain_info]

java_runtime_toolchain = rule(
    implementation = _java_compiler_toolchain_impl,
    attrs = {
        "java_executable": attr.label(
            allow_single_file = True,
            mandatory = True,
            executable = True,
            cfg = "host",
        ),
    }
)