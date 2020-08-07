'''Defines the `java_agent` macro.
'''

load("@dwtj_rules_java//java:rules/java_library.bzl", "java_library")

def java_agent(**attributes):
    '''A helper macro which wraps a `java_library` rule. Expects a `premain_class` attribute to be set.

    Args:
      **attributes: A kwargs-dict of keywords known to `java_library` plus the `premain_class` string attribute.
    
    Returns:
      None
    '''
    if 'premain_class' not in attributes:
        fail("Expected an attribute: `premain_class`")
    if type(attributes['premain_class']) != 'string':
        fail("Expected attribute `premain_class` to be a `string`.")

    attributes.setdefault('include_in_jar_manifest', []).append("Premain-Class: " + attributes['premain_class'])
    attributes.pop('premain_class')

    java_library(**attributes)