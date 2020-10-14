#!/bin/sh -

set -e

EXEC="$1"

"./${EXEC}" | tee testlog.sh

grep 'Hello, from `st.java.MyTestBin#main()`' testlog.sh
