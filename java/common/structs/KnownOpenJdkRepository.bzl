_ATTRIBUTE_VALID_VALUES = {
    "provider": [
        "__default__",
        "adoptopenjdk_upstream",
        "amazon_corretto",
        "jdk_java_net",
        "adoptopenjdk",
    ],
    "os": [
        "linux",
        "macos",
        "windows",
    ],
    "cpu_arch": [
        "x64",
        "aarch64",
    ],
    "jvm": [
        "hotspot",
        "openj9",
    ],
    "version": "string",
    "url": "string",
    "sha256": "string",
    "strip_prefix": "string",
}

_ATTRIBUTE_DEFAULT_VALUES = {
    "version": "__default__",
    "provider": "__default__",
    "os": "linux",
    "cpu_arch": "x64",
    "jvm": "hotspot",
}

def _find_any_unknown_attribute(**kwargs):
    known_attrs = _ATTRIBUTE_VALID_VALUES.keys()
    for attr in kwargs.keys():
        if attr not in known_attrs:
            return attr
    return None

def KnownOpenJdkRepository(**kwargs):
    # Check that we were not given any unknown attributes.
    unknown_attr = _find_any_unknown_attribute(**kwargs)
    if not unknown_attr == None:
        fail("Unknown attribute for `KnownOpenJdkRepository` struct: " + unknown_attr)

    # Check that all of our attributes have valid values.
    for (attr, value) in kwargs.items():
        valid_values = _ATTRIBUTE_VALID_VALUES[attr]
        if type(valid_values) == "list":
            if value not in valid_values:
                msg = """A `KnownOpenJdkRepository` was given an invalid value for an attribute: `{} = {}`""".format(attr, value)
                fail(msg)
        else:
            # TODO(dwtj): Can I use `isinstance` in Starlark?
            if not type(value) == valid_values:
                fail("A `KnownOpenJdkRepository` was given a value of invalid type for an attribute: `type({}) == {}`, but expected `{}`.".format(value, type(value), valid_values))

    # Apply default values for any missing attributes.
    for (attr, value) in _ATTRIBUTE_DEFAULT_VALUES.items():
        kwargs.setdefault(attr, value)

    return struct(**kwargs)
