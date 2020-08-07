'''Some common helper functions for creating & manipulating providers.
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
