"""Defines the `symlink_resources_into_dir()` helper function.
"""

def symlink_resources_into_dir(actions, resources, jar_build_root_dir):
    """For each Java resource, add a symlink to it under the JAR root directory.

    For each Java resource, we create a symlink from the resource file to a path
    under the given directory.

    Args:
      actions: A Bazel `actions` object with which we emit actions.
      resources: A `dict` from a Java resource to a string specifying the
        path within the JAR root directory that resource file should end up
        These path strings are expected to be relative paths. Resource path
        strings are interpreted to be relative to the `jar_build_root_dir`.
      jar_build_root_dir: A non-empty string encoding the path of a directory under
        which all resource symlinks will be placed.

    Returns:
      A `list` of the `File`s declared by and created by actions emited by this
      function.
    """
    symlinks = list()
    for src, dest_path in resources.items():
        # NOTE(dwtj): `src` is a Bazel `Target`, which may include many files.
        # These are encoded as a depset.
        src_files = src.files.to_list()
        if len(src_files) != 1:
            fail("Target used as a Java resource needs to include exactly one file. However, `{}` includes {} files.".format(src, len(src.files)))
        src_file = src_files[0]
        dest_symlink = actions.declare_file(jar_build_root_dir + "/" + dest_path)
        actions.symlink(
            output = dest_symlink,
            target_file = src_file,
            progress_message = "Symlink Java resource into JAR's build directory: " + dest_path,
        )
        symlinks.append(dest_symlink)
    return symlinks
