'''Defines the `JavaAgentInfo` provider.
'''

JavaAgentInfo = provider(
    doc = "Describes a `java_agent`.",
    fields = {
        "java_agent_jar": "The `java_agent` packaged as a JAR with a `Premain-Class` JAR manifest attribute. This is the JAR which is meant to be passed to the `java` command with the `-javaagent` flag. This JAR should be included in this target's `JavaDependencyInfo`.",
        "premain_class": "The class which includes this `java_agent`'s `premain()` method.",
        "can_redefine_classes": "Either `True` or `False`.",
        "can_retransform_classes": "Either `True` or `False`.",
        "can_set_native_method_prefix": "Either `True` or `False`.",
    }
)
