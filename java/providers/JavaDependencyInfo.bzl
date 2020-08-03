'''Defines the `JavaRunTimeDependencyInfo` provider.
'''

JavaDependencyInfo = provider(
    doc = "Encodes information about how this Java target should be integrated into some Java target which uses this Java target as a dependency.",
    fields = {
        "compile_time_class_path_jars": "A `depset` of `File`s encoding the set of JARs needed to compile some Java target which includes *this* Java target as a dependency.",
        "run_time_class_path_jars": "A `depset` of `File`s encoding the set of JARs needed to execute some Java target which includes *this* Java target as a dependency.",
        # TODO(dwtj): Consider supporting Java agents and native (i.e. JVMTI) agents.
        # TODO(dwtj): Consider encoding `javac --target <release_version>` and eagerly checking that a version is compatible with a particular `java` toolchain.
        # TODO(dwtj): Consdier supporting annotation processors.
    },
)
