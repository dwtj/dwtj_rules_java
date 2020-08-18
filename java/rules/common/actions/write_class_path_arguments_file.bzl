'''Defines functions which write Java class-path arguments files.

This is meant to be used by various Java rules.
'''

def _to_path(class_path_item):
    '''Used as a map function to convert a file to its path.
    '''
    return class_path_item.path

def _to_short_path(class_path_item):
    '''Used as a map function to convert a file to its short path.
    '''
    return class_path_item.short_path

def write_run_time_class_path_arguments_file(name, jars, actions, class_path_separator):
    return _write_class_path_arguments_file(
        name,
        jars,
        actions,
        class_path_separator,
        variant = "run_time",
    )

def write_compile_time_class_path_arguments_file(name, jars, actions, class_path_separator):
    return _write_class_path_arguments_file(
        name,
        jars,
        actions,
        class_path_separator,
        variant = "compile_time",
    )

def _write_class_path_arguments_file(name, jars, actions, class_path_separator, variant):
    '''Writes an arguments file with the classpath made from `jars`.

    The `java` and `javac` commands accept "Command Line Arguments Files" using
    the `@filename` notation. This is a helper class to write such a file.
    
    The `variant` argument is used to indicate whether the file is meant to be
    used at runtime or at compile time. (This is relevant to how `file`s are
    converted to path strings.)

    If `jars` is empty, then the built file will be empty. Otherwise, the built
    file has two lines: the first is always `--class-path`, and the second is
    the class path itself (with path entries separated by the selected
    `class_path_separator`).

    Args:
      name: The name of the file to be written. (This is passed directly to
          `actions.declare_file`.)
      jars: A depset of JAR `File`s to be included in the runtime
          classpath.
      actions: The `actions` object to used (e.g. to emit the the write action).
      class_path_separator: E.g. `:` or `;`.
      variant: One of two strings: "compile_time" or "run_time".

    Returns:
      A `File` handle to the new class path arguments file.
    '''
    if variant != "compile_time" and variant != "run_time":
        fail("Unexpected `variant` argument value: " + variant)

    cp_file_to_path_fn = _to_path if variant == "compile_time" else _to_short_path

    args_file = actions.declare_file(name)
    args = actions.args()
    args.add_joined(
        "--class-path",
        jars,
        join_with = class_path_separator,
        omit_if_empty = True,
        map_each = cp_file_to_path_fn,
    )

    actions.write(
        output = args_file,
        content = args,
        is_executable = False,
    )

    return args_file
