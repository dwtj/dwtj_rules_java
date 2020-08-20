#!/bin/sh -
#
# This script was generated from a template with the following substitutions:
#
# - JAVAC_EXECUTABLE: {JAVAC_EXECUTABLE}
# - OUTPUT_CLASS_DIR: {OUTPUT_CLASS_DIR}
# - PROCESSOR_PATH_ARGS_FILE: {PROCESSOR_PATH_ARGS_FILE}
# - CLASS_PATH_ARGS_FILE: {CLASS_PATH_ARGS_FILE}
# - JAVA_SOURCES_ARGS_FILE: {JAVA_SOURCES_ARGS_FILE}
# - ERROR_PRONE_LOG_FILE: {ERROR_PRONE_LOG_FILE}

"{JAVAC_EXECUTABLE}" \
    -d "{OUTPUT_CLASS_DIR}" \
    --processor-path "@{PROCESSOR_PATH_ARGS_FILE}" \
    "-Xplugin:ErrorProne" \
    "-XDcompilePolicy=byfile" \
    "@{CLASS_PATH_ARGS_FILE}" \
    "@{JAVA_SOURCES_ARGS_FILE}" \
        2>&1 > "{ERROR_PRONE_LOG_FILE}"
RETURN_CODE=$?

cat "{ERROR_PRONE_LOG_FILE}"

exit $RETURN_CODE
