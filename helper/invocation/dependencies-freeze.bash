#!/bin/bash
echo "TRACE: Executing '$0'"
logDebug 'Freezing the dependencies for this project using PIP...'

variableRequire BO_Project

File=${BO_Project}/cfg/freeze.pip

pip freeze -r ${File} > ${File}
abortOnFail $? $0 $LINENO
fileRequire "${File}"
