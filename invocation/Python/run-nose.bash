#!/bin/bash
echo "TRACE: Executing '$BASH_SOURCE'"
logDebug 'Running Nose-based tests on this project...'

requireVariable BO_Project
requireVariable BO_HomePackage

requireDirectory "$BO_Project/src/$BO_HomePackage"

Config=${BO_Project}/cfg/nose.cfg
requireFile "${Config}"

cd "${BO_Project}/src"
abortOnFail $?

Cmd=nosetests
Cmd="$Cmd --config=${Config}"
Cmd="$Cmd --id-file=${BO_Project}/.noseids"
Cmd="$Cmd --cover-package=${BO_HomePackage}"
$Cmd
abortOnFail $?
