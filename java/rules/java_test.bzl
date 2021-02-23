'''Defines the `java_test` rule.
'''

load("//java:providers/JavaAgentInfo.bzl", "JavaAgentInfo")
load("//java:providers/JavaCompilationInfo.bzl", "JavaCompilationInfo")
load("//java:providers/JavaDependencyInfo.bzl", "JavaDependencyInfo")

load("//java:toolchain_rules/java_compiler_toolchain.bzl", "JavaCompilerToolchainInfo")
load("//java:toolchain_rules/java_runtime_toolchain.bzl", "JavaRuntimeToolchainInfo")

load("//java:common/actions/compile_java_jar.bzl", "compile_java_jar_for_target")
load("//java:common/actions/write_java_run_script.bzl", "write_java_run_script_from_ctx")
load("//java:common/extract/toolchain_info.bzl", "extract_java_executable")
load(
    "//java:common/providers.bzl",
    "make_standard_java_target_java_dependency_info",
    "make_legacy_java_info",
)

# NOTE(dwtj): This is very similar to `_java_binary_impl()`.
def _java_test_impl(ctx):
    java_compilation_info = compile_java_jar_for_target(ctx)
    java_dependency_info = make_standard_java_target_java_dependency_info(
        ctx,
        java_compilation_info.class_files_output_jar,
    )
    java_execution_info, run_script, class_path_args_file, jvm_flags_args_file, run_time_jars = write_java_run_script_from_ctx(
        ctx,
        java_dependency_info,
    )

    runfiles = [
        extract_java_executable(ctx),
        run_script,
        class_path_args_file,
        jvm_flags_args_file,
    ]
    runfiles.extend(ctx.files.data)

    return [
        DefaultInfo(
            files = depset([java_compilation_info.class_files_output_jar]),
            executable = run_script,
            runfiles = ctx.runfiles(
                files = runfiles,
                transitive_files = run_time_jars
            ),
        ),
        java_compilation_info,
        java_execution_info,
        make_legacy_java_info(java_compilation_info, ctx.attr.deps),
    ]

java_test = rule(
    implementation = _java_test_impl,
    test = True,
    attrs = {
        "srcs": attr.label_list(
            # TODO(dwtj): Consider supporting empty `srcs` list once `exports`
            #  is supported.
            allow_empty = False,
            doc = "A list of Java source files whose derived class files should be included in this test (and any of its dependents).",
            allow_files = [".java"],
            default = list(),
        ),
        "main_class": attr.string(
            mandatory = True,
        ),
        "deps": attr.label_list(
            providers = [
                JavaDependencyInfo,
                JavaInfo,
            ],
            default = list()
        ),
        "data": attr.label_list(
            default = list(),
            allow_files = True,
        ),
        "jvm_flags": attr.string_list(
            default = list(),
        ),
        "additional_jar_manifest_attributes": attr.string_list(
            doc = "A list of strings; each will be added as a line of the output JAR's manifest file. The JAR's `Main-Class` header is automatically set according to the target's `main_class` attribute.",
            default = list(),
        ),
        # TODO(dwtj): A dict is used here in order to support Java agent
        #  options, but this causes two problems. First, it means that a single
        #  Java agent cannot be listed multiple times. Second, the order of
        #  agents is lost. These are problems because according to the
        #  [`java.lang.instrument` Javadoc][1], agents can be listed multiple
        #  times and their order dictates the sequence by which `premain()`
        #  functions are called. Thus, this design doesn't support all use cases
        #  provided by the `java` command line interface.
        #
        #  Unfortunately, I don't immediately see an alternative to this use of
        #  dict. At least these use cases are probably rare.
        #
        #  ---
        #
        #  1: https://docs.oracle.com/en/java/javase/14/docs/api/java.instrument/java/lang/instrument/package-summary.html
        "java_agents": attr.label_keyed_string_dict(
            doc = "A dict from `java_agent` targets to strings. Each key is a `java_agent` target with which this target should be run; each value is an option string to be passed to that Java agent.",
            providers = [
                JavaAgentInfo,
                JavaDependencyInfo,
            ],
            default = dict(),
        ),
        "resources": attr.label_keyed_string_dict(
            allow_files = True,
            default = dict(),
        ),
        "javac_flags": attr.string_list(
            doc = """A list of strings. Each will be added as a flag to the `javac` command invocation used to compile and process this rule's Java source files. These flags will be ordered just as they appear in this list. These flags will be in addition to the options automatically added to the `javac` invocation (e.g. `--class-path`). Example: By setting this attibute to the list `['-Asome_name_option="J. Smith"']` will add one annotation processing option to the `javac` invocation whose option name is `some_name_option` and whose value is "J. Smith".)""",
            default = list(),
        ),
        "output_jar": attr.output(
            doc = "The name of the JAR file generated by this target. This JAR contains the class files generated by this target's Java compiler invocation.",
        ),
        "java_compiler_toolchain": attr.label(
            doc = "This optional attribute can override the global Java compiler toolchain. This expects a label for a `java_compiler_toolchain` target (or more precisely, a target providing `JavaCompilerToolchainInfo`).",
            providers = [JavaCompilerToolchainInfo],
        ),
        "java_runtime_toolchain": attr.label(
            doc = "This optional attribute can override the global Java runtime toolchain. This expects a label for a `java_runtime_toolchain` target (or more precisely, a target providing `JavaRuntimeToolchainInfo`).",
            providers = [JavaRuntimeToolchainInfo],
        ),
    },
    provides = [
        JavaCompilationInfo,
        JavaInfo,
    ],
    toolchains = [
        "@dwtj_rules_java//java/toolchains/java_compiler_toolchain:toolchain_type",
        "@dwtj_rules_java//java/toolchains/java_runtime_toolchain:toolchain_type",
    ],
)
