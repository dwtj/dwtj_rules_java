#!/bin/sh -
#
# This script was generated from a template with the following substitutions:
# 
# - JAVA_EXECUTABLE: {JAVA_EXECUTABLE}
# - CLASS_PATH_ARGUMENTS_FILE: {CLASS_PATH_ARGUMENTS_FILE}
# - MAIN_CLASS: {MAIN_CLASS}

set -e

"{JAVA_EXECUTABLE}" "@{CLASS_PATH_ARGUMENTS_FILE}" "{MAIN_CLASS}"
