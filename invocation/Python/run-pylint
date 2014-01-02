#!/bin/bash
echo "TRACE: Executing '$BASH_SOURCE'"
logDebug 'Running pylint on this project...'

requireVariable BO_Project
requireVariable BO_HomePackage

requireDirectory "$BO_Project/src/$BO_HomePackage"

_Config=${BO_Project}/cfg/pylintrc
requireFile "${_Config}"

_Dir=$BO_Project/out
createDirectory "${_Dir}"

cd "${BO_Project}/src"
abortOnFail "$?"

_Cmd=pylint
_Cmd="$_Cmd --rcfile=${_Config}"
_Cmd="$_Cmd ${BO_HomePackage}"
$_Cmd | tee ${BO_Project}/out/pylint.out
abortOnFail "$?"

