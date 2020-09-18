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
        "java_run_script_template": "A template from which Java run scripts are instantiated.",
        "class_path_separator": "The class path separator to use when invoking this `java` executable."
    },
)

def _java_compiler_toolchain_impl(ctx):
    toolchain_info = platform_common.ToolchainInfo(
        java_runtime_toolchain_info = JavaRuntimeToolchainInfo(
            java_executable = ctx.file.java_executable,
            java_run_script_template = ctx.file._java_run_script_template,
            class_path_separator = ctx.attr.class_path_separator,
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
        # NOTE(dwtj): This seems like a somewhat roundabout way to make this
        #  template available for instantiation in the `write_java_run_script`
        #  helper function, but I haven't yet figured out another way to do it
        #  which resolves the label to a file.
        # TODO(dwtj): Try the `Label()` constructor.
        "_java_run_script_template": attr.label(
            default = "@dwtj_rules_java//java:common/actions/TEMPLATE.java_run_script.sh",
            allow_single_file = True,
        ),
        "class_path_separator": attr.string(
            default = ":",
        )
    }
)