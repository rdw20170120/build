#!/bin/bash
echo "TRACE: Executing '$BASH_SOURCE'"
logDebug 'Running pylint on this project...'

requireVariable BO_Project
requireVariable BO_HomePackage

requireDirectory "$BO_Project/src/$BO_HomePackage"

Config=${BO_Project}/cfg/pylintrc
requireFile "${Config}"

Dir=$BO_Project/out
createDirectory "${Dir}"

cd "${BO_Project}/src"
abortOnFail $?

Cmd=pylint
Cmd="$Cmd --rcfile=${Config}"
Cmd="$Cmd ${BO_HomePackage}"
$Cmd | tee ${BO_Project}/out/pylint.out
abortOnFail $?
