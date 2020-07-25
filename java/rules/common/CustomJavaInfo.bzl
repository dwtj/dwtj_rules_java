'''Defines the `CustomJavaInfo` provider.
'''

CustomJavaInfo = provider(
    # TODO(dwtj): This design feels wrong. Fix it once the basic Java rules are
    #  prototyped. (E.g., `jar` should probably be plural.)
    fields = {
        "jar": "The JAR file built by this target.",
        "srcs": "A depset of the Java source files directly included in a Java target (i.e., this does not include transitive sources).",
        "deps": "A depset of targets. These targets are the Java dependencies directly included in this Java target (i.e., this does not include transitive dependencies). All targets in this `depset` should provide `CustomJavaInfo`.",
    }
)