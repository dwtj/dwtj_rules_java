'''Defines the `CustomJavaInfo` provider.
'''

CustomJavaInfo = provider(
    fields = {
        "jar": "The JAR file built by this target.",
        "srcs": "A depset of the Java source files directly included in a Java target (i.e., this does not include transitive sources).",
        "deps": "A depset of targets. These targets are the Java dependencies directly included in this Java target (i.e., this does not include transitive dependencies). All targets in this `depset` should provide `CustomJavaInfo`.",
    }
)