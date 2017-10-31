#!/bin/bash
echo "TRACE: Executing '$0'"
logDebug 'Running pylint on this project...'

variableRequire BO_Project
variableRequire BO_HomePackage

directoryRequire "$BO_Project/src/$BO_HomePackage"

Config=${BO_Project}/cfg/pylintrc
fileRequire "${Config}"

Dir=$BO_Project/out
directoryCreate "${Dir}"

cd "${BO_Project}/src"
abortOnFail $? $0 $LINENO

Cmd=pylint
Cmd="$Cmd --rcfile=${Config}"
Cmd="$Cmd ${BO_HomePackage}"
$Cmd | tee ${BO_Project}/out/pylint.out
abortOnFail $? $0 $LINENO

