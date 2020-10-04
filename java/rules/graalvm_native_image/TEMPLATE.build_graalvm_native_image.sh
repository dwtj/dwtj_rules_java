#!/bin/sh -
# This file was generated from a template with the following substitutions:
#
# - NATIVE_IMAGE_EXEC: {NATIVE_IMAGE_EXEC}
# - CLASS_PATH: {CLASS_PATH}
# - MAIN_CLASS: {MAIN_CLASS}
# - OUTPUT_IMAGE: {OUTPUT_IMAGE}


"{NATIVE_IMAGE_EXEC}" --class-path "{CLASS_PATH}" "{MAIN_CLASS}" "{OUTPUT_IMAGE}"
