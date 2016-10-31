#!/bin/bash
echo "TRACE: Executing '$BASH_SOURCE'"
logDebug 'Installing the dependencies for this project using PIP...'

requireVariable BO_Project

File=${BO_Project}/cfg/freeze.pip
requireFile "${File}"

# Install from the previously-frozen dependency list
Cmd=pip
Cmd="${Cmd} install -r ${File}"
# TODO:  Cmd="${Cmd} --quiet"
${Cmd}
abortOnFail $?

# Report the installed dependencies
pip freeze
abortOnFail $?
