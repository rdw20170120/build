#!/bin/bash
echo "TRACE: Executing '$BASH_SOURCE'"
logDebug 'Counting the lines of source code (SLOC) in this project...'
# TODO: This script requires the 'sloccount' package to have been installed

requireVariable BO_Project

_Dir=$BO_Project/out
createDirectory "${_Dir}"

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
_Cmd=sloccount
_Cmd="${_Cmd} --addlangall --details --wide"
_Cmd="${_Cmd} $BO_Project/activate"
_Cmd="${_Cmd} $BO_Project/MANIFEST.in"
_Cmd="${_Cmd} $BO_Project/README.rst"
_Cmd="${_Cmd} $BO_Project/setup.py"
_Cmd="${_Cmd} $BO_Project/bin"
_Cmd="${_Cmd} $BO_Project/BriteOnyx"
_Cmd="${_Cmd} $BO_Project/cfg"
_Cmd="${_Cmd} $BO_Project/doc"
_Cmd="${_Cmd} $BO_Project/src"
${_Cmd} > $BO_Project/out/sloccount.sc
abortOnFail "$?"

