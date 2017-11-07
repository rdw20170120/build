#!/bin/bash
echo "TRACE: Executing '$BASH_SOURCE'"
logDebug 'Running Nose-based tests on this project...'

variableRequire $BASH_SOURCE $LINENO BO_Project
variableRequire $BASH_SOURCE $LINENO BO_HomePackage

directoryRequire "$BO_Project/src/$BO_HomePackage"

Config=${BO_Project}/cfg/nose.cfg
fileRequire "${Config}"

cd "${BO_Project}/src"
abortOnFail $0 $LINENO $?

Cmd=nosetests
Cmd="$Cmd --config=${Config}"
Cmd="$Cmd --id-file=${BO_Project}/.noseids"
Cmd="$Cmd --cover-package=${BO_HomePackage}"
$Cmd
abortOnFail $0 $LINENO $?

