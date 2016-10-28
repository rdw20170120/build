#!/bin/bash
echo "TRACE: Executing '$BASH_SOURCE'"
logDebug 'Installing the dependencies for this project using PIP...'

requireVariable BO_Project

_File=${BO_Project}/cfg/freeze.pip
requireFile "${_File}"

# Install from the previously-frozen dependency list
_Cmd=pip
_Cmd="${_Cmd} install -r ${_File}"
# TODO:  _Cmd="${_Cmd} --quiet"
${_Cmd}
abortOnFail "$?"

# Report the installed dependencies
pip freeze
abortOnFail "$?"

