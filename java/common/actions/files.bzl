"""Defines some Starlark helper functions to manipulate Bazel files.
"""

def make_empty_file(actions, file_path):
    """Emit actions which declare and create an empty file at the given path.
    """
    file = actions.declare_file(file_path)
    actions.write(file, content = "")
    return file
