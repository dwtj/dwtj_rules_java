# Helper Definitions Which Emit Common Action Sequences

Various Java rules need to perform similar actions. This directory holds a few
functions which emit the action sequences needed for common functionality.
For example, `java_library` and `java_binary` rules both need to compile Java
sources, and the `compile_and_jar_java_sources()` function is used by both; the
`java_binary` and `java_test` both need to create executable scripts, so
`build_java_run_script()` is used by both.
