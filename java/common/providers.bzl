'''Some common helper functions for creating/manipulating/adpating providers.
'''

load("//java:providers/JavaDependencyInfo.bzl", "JavaDependencyInfo")

def jar_list_java_dependency_info(jars):
    '''A `JavaDependencyInfo` with just the JAR `File` list as the CT & RT deps.
    '''
    jar_list_depset = depset(direct = jars)
    return JavaDependencyInfo(
        compile_time_class_path_jars = jar_list_depset,
        run_time_class_path_jars = jar_list_depset,
    )

def make_standard_java_target_java_dependency_info(ctx, output_jar):
    '''A `JavaDependencyInfo` with `output_jar` at CT & transitive deps at RT.

    Args:
      ctx: The `ctx` object of this Java target.
      output_jar: The JAR `File` created by this Java target.
    Return:
      `JavaDependencyInfo`
    '''
    deps = []
    for dep in ctx.attr.deps:
        dep_info = dep[JavaDependencyInfo]
        deps.append(dep_info.run_time_class_path_jars)

    return JavaDependencyInfo(
        compile_time_class_path_jars = depset(direct = [output_jar]),
        run_time_class_path_jars = depset(
            direct = [output_jar],
            transitive = deps,
        ),
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
