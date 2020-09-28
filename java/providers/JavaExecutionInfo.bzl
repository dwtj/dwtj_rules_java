'''Defines the `JavaExecutionInfo` provider.
'''

JavaExecutionInfo = provider(
    doc = "Encodes information about how this Java target should be run (i.e. how `java` should be invoked).",
    fields = {
        "java_dependency_info": "This Java target's `JavaDependencyInfo`. (In the common case, this just wraps the JAR with this target's compiled Java sources.)",
        "deps": "A list of this target's dependencies (i.e. `deps`). Each should provide a `JavaDependencyInfo`. This list may be empty, but it should not be `None`.",
        "main_class": "A string encoding the class whose `main()` method should be used to start the Java application. (E.g., `mypkg.MyMainClass`.). This should neither be the empty string nor `None`.",
        "java_agents": "A list of 2-tuples describing the `java_agent`s to include and the options with which they should be run. Each 2-tuple's first should be a target which provides both a `JavaAgentInfo` and a `JavaDependencyInfo`, and its second should be a string. This list may be empty, but it should not be `None`.",
        "java_runtime_toolchain_info": "The `JavaRuntimeToolchainInfo` to use.",
        # TODO(dwtj): Consider supporting native agents (i.e. JVMTI agents).
        "jvm_flags": "Encodes a sequence of custom flags (a.k.a. arguments) which should be added to an invocation of the `java` command when this Java target is run via `bazel run`.",
    },
)
