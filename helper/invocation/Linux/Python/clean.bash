#!/bin/bash
echo "TRACE: Executing '$BASH_SOURCE'"
logDebug 'Cleaning this project of all output and temporary files...'

variableRequire BO_Project

rm ${BO_Project}/MANIFEST

rm -fr ${BO_Project}/dist

find ${BO_Project} \( -type f -a -name "*.out"         \) -exec rm {} \;
find ${BO_Project} \( -type f -a -name "*.pyc"         \) -exec rm {} \;
find ${BO_Project} \( -type f -a -name ".coverage"     \) -exec rm {} \;
find ${BO_Project} \( -type f -a -name "coverage.xml"  \) -exec rm {} \;
find ${BO_Project} \( -type f -a -name "nosetests.xml" \) -exec rm {} \;
find ${BO_Project} \( -type f -a -name "sloccount.sc"  \) -exec rm {} \;
