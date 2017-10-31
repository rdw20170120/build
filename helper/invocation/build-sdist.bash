#!/bin/bash
echo "TRACE: Executing '$0'"
logDebug 'Building a source distribution (sdist) of this project...'

variableRequire BO_Project

File=${BO_Project}/setup.py
fileRequire "${File}"

cd "${BO_Project}"
abortOnFail $? $0 $LINENO

python "${File}" sdist
abortOnFail $? $0 $LINENO
