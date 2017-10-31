#!/bin/bash
echo "TRACE: Executing '$0'"
logDebug 'Installing the dependencies for this project using PIP...'

variableRequire BO_Project

File=${BO_Project}/cfg/freeze.pip
fileRequire "${File}"

# Install from the previously-frozen dependency list
Cmd=pip
Cmd="${Cmd} install -r ${File}"
# TODO:  Cmd="${Cmd} --quiet"
${Cmd}
abortOnFail $? $0 $LINENO

# Report the installed dependencies
pip freeze
abortOnFail $? $0 $LINENO
