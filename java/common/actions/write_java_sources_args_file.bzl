'''Defines the `write_java_sources_args_file()` helper function.
'''

def _to_path(file):
    '''Used as a map function to convert a file to its path.
    '''
    return file.path

def write_java_sources_args_file(name, srcs, actions):
    '''Declares/writes a list of Java source file paths to a file.

    Args:
      name: The name of the file to be created.
      srcs: A sequence of `File`s, whose `File.path` will be written.
      actions: The `Actions` object to use to create the `File`.
    Returns:
      The resulting args file.
    '''
    args_file = actions.declare_file(name)
    args = actions.args()
    args.add_all(
        srcs,
        omit_if_empty = False,
        map_each = _to_path,
    )
    actions.write(
        output = args_file,
        content = args,
        is_executable = False,
    )
    return args_file
