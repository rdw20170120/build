#!/bin/bash
echo "TRACE: Executing '$BASH_SOURCE'"
logDebug 'Building a source distribution (sdist) of this project...'

requireVariable BO_Project

File=${BO_Project}/setup.py
requireFile "${File}"

cd "${BO_Project}"
abortOnFail $?

python "${File}" sdist
abortOnFail $?
