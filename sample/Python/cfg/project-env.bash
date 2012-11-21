#!/bin/bash
# Configure the shell for this project

# NOTE: This script should be sourced into the shell environment

echo 'INFO: Configure project (specific)'

# Configure project home package (parent package of all project source)
# NOTE:  All project source should be contained in
#        ${BO_Project}/src/${BO_Package}
export BO_Package=PACKAGE

# Configure BriteOnyx
export BO_Parent=~/tool/BriteOnyx
export BO_Version=tip

# Configure TMPDIR
if [[ -z "$TMPDIR" ]]; then
    echo 'WARN: Missing $TMPDIR'
    [[ -z "$TMPDIR" ]] && [[ -n "$USER"     ]] && export TMPDIR="/tmp/$USER"
    [[ -z "$TMPDIR" ]] && [[ -n "$USERNAME" ]] && export TMPDIR="/tmp/$USERNAME"
    echo "INFO: Remembering TMPDIR='$TMPDIR'"
fi

# Configure PIP download cache
[[ -z "$TMPDIR" ]] && echo 'FATAL: Missing $TMPDIR' && return 1
export PIP_DOWNLOAD_CACHE=$TMPDIR/pip

# Return, but do NOT exit, with a success code
return 0

