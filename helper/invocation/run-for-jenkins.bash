#!/bin/bash
echo "TRACE: Executing '$0'"
logDebug 'Running continuous integration (Jenkins) build on this project...'

run-sloccount
abortOnFail $? $0 $LINENO

run-nose
abortOnFail $? $0 $LINENO

run-pylint
abortOnFail $? $0 $LINENO

build-sdist
abortOnFail $? $0 $LINENO

