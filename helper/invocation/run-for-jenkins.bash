#!/bin/bash
echo "TRACE: Executing '$BASH_SOURCE'"
logDebug 'Running continuous integration (Jenkins) build on this project...'

run-sloccount
abortOnFail $?

run-nose
abortOnFail $?

run-pylint
abortOnFail $?

build-sdist
abortOnFail $?