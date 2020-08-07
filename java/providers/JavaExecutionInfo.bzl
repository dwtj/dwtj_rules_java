'''Defines the `JavaExecutionInfo` provider.
'''

JavaExecutionInfo = provider(
    doc = "Encodes information about how this Java target should be run (i.e. how `java` should be invoked).",
    fields = {
        "java_dependency_info": "This Java target's `JavaDependencyInfo`. (In the common case, this just wraps the JAR with this target's compiled Java sources.)",
        "deps": "A list of this target's dependencies (i.e. `deps`). Each should provide a `JavaDependencyInfo`. This list may be empty, but it should not be `None`.",
        "main_class": "A string encoding the class whose `main()` method should be used to start the Java application. (E.g., `mypkg.MyMainClass`.). This should neither be the empty string nor `None`.",
        "java_agents": "A list of `java_agent` targets with which this target should be run. Each should provide both a `JavaAgentInfo` and a `JavaDependencyInfo`. This list may be empty, but it should not be `None`.",
        "java_runtime_toolchain_info": "The `JavaRuntimeToolchainInfo` to use.",
        # TODO(dwtj): Consider supporting native agents (i.e. JVMTI agents).
        # TODO(dwtj): "jvm_flags": "Encodes a sequence of custom flags (a.k.a. arguments) which should be added to an invocation of the `java` command when this Java target is run.",
    },
)