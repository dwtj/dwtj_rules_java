'''Some common helper functions for creating/manipulating/adpating providers.
'''

load("@dwtj_rules_java//java:providers/JavaDependencyInfo.bzl", "JavaDependencyInfo")

def singleton_java_dependency_info(jar):
    '''Returns a `JavaDependencyInfo` with just the given `jar` as a CT/RT dep.
    '''
    singleton_depset = depset(direct = [jar])
    return JavaDependencyInfo(
        run_time_class_path_jars = singleton_depset,
        compile_time_class_path_jars = singleton_depset,
    )

def make_legacy_java_info(java_compilation_info, deps):
    '''Makes a `JavaInfo` like the given args.

    Args:
      java_compilation_info: a `JavaCompilationInfo`.
      deps: a list of targets (each providing a `JavaInfo`s) to use as deps.
    '''
    return JavaInfo(
        output_jar = java_compilation_info.class_files_output_jar,
        compile_jar = java_compilation_info.class_files_output_jar,
        deps = [dep[JavaInfo] for dep in deps],
    )