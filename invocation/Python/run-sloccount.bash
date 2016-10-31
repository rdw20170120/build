#!/bin/bash
echo "TRACE: Executing '$BASH_SOURCE'"
logDebug 'Counting the lines of source code (SLOC) in this project...'
# TODO: This script requires the 'sloccount' package to have been installed

variableRequire BO_Project

Dir=$BO_Project/out
directoryCreate "${Dir}"

fileRequire "$BO_Project/activate"
fileRequire "$BO_Project/MANIFEST.in"
fileRequire "$BO_Project/README.rst"
fileRequire "$BO_Project/setup.py"

directoryRequire "$BO_Project/bin"
directoryRequire "$BO_Project/BriteOnyx"
directoryRequire "$BO_Project/cfg"
directoryRequire "$BO_Project/doc"
directoryRequire "$BO_Project/src"

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
