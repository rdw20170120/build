#!/bin/bash
echo "TRACE: Executing '$BASH_SOURCE'"
logDebug 'Building a source distribution (sdist) of this project...'

requireVariable BO_Project

_File=${BO_Project}/setup.py
requireFile "${_File}"

cd "${BO_Project}"
abortOnFail "$?"

python "${_File}" sdist
abortOnFail "$?"

