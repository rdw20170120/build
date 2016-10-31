#!/bin/bash
echo "TRACE: Executing '$BASH_SOURCE'"
logDebug 'Counting the lines of source code (SLOC) in this project...'
# TODO: This script requires the 'sloccount' package to have been installed

requireVariable BO_Project

Dir=$BO_Project/out
createDirectory "${Dir}"

requireFile "$BO_Project/activate"
requireFile "$BO_Project/MANIFEST.in"
requireFile "$BO_Project/README.rst"
requireFile "$BO_Project/setup.py"

requireDirectory "$BO_Project/bin"
requireDirectory "$BO_Project/BriteOnyx"
requireDirectory "$BO_Project/cfg"
requireDirectory "$BO_Project/doc"
requireDirectory "$BO_Project/src"

# NOTE:  Do NOT include subdirectories "dist", "out", or "PVE"
Cmd=sloccount
Cmd="${Cmd} --addlangall --details --wide"
Cmd="${Cmd} $BO_Project/activate"
Cmd="${Cmd} $BO_Project/MANIFEST.in"
Cmd="${Cmd} $BO_Project/README.rst"
Cmd="${Cmd} $BO_Project/setup.py"
Cmd="${Cmd} $BO_Project/bin"
Cmd="${Cmd} $BO_Project/BriteOnyx"
Cmd="${Cmd} $BO_Project/cfg"
Cmd="${Cmd} $BO_Project/doc"
Cmd="${Cmd} $BO_Project/src"
${Cmd} > $BO_Project/out/sloccount.sc
abortOnFail $?
