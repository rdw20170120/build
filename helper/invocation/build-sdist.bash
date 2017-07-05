#!/bin/bash
echo "TRACE: Executing '$BASH_SOURCE'"
logDebug 'Building a source distribution (sdist) of this project...'

variableRequire BO_Project

File=${BO_Project}/setup.py
fileRequire "${File}"

cd "${BO_Project}"
abortOnFail $?

python "${File}" sdist
abortOnFail $?
