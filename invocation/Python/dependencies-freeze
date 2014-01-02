#!/bin/bash
echo "TRACE: Executing '$BASH_SOURCE'"
logDebug 'Freezing the dependencies for this project using PIP...'

requireVariable BO_Project

_File=${BO_Project}/cfg/freeze.pip

pip freeze -r ${_File} > ${_File}
abortOnFail "$?"
requireFile "${_File}"

