#!/bin/bash
echo "TRACE: Executing '$BASH_SOURCE'"
logDebug 'Running Nose-based tests on this project...'

requireVariable BO_Project
requireVariable BO_HomePackage

requireDirectory "$BO_Project/src/$BO_HomePackage"

_Config=${BO_Project}/cfg/nose.cfg
requireFile "${_Config}"

cd "${BO_Project}/src"
abortOnFail "$?"

_Cmd=nosetests
_Cmd="$_Cmd --config=${_Config}"
_Cmd="$_Cmd --id-file=${BO_Project}/.noseids"
_Cmd="$_Cmd --cover-package=${BO_HomePackage}"
$_Cmd
abortOnFail "$?"

