#!/bin/bash
[[ -n "$BO_Trace" ]] && echo "TRACE: Executing '$BASH_SOURCE'"
################################################################################
# NOTE: Uncomment the following two lines for debugging
# set -o verbose
# set -o xtrace

################################################################################
# Reference our script context
Self="$BASH_SOURCE"
This="$(dirname $Self)"

################################################################################
echo 'Package BriteOnyx scripts'

[[ -z "$TMPDIR" ]] && TMPDIR=$HOME/tmp/BriteOnyx

DirSrc=$This/..
FileArchive=$TMPDIR/BriteOnyx.tb2

# Clean old output
[[ -f "$FileArchive" ]] && rm -f $FileArchive

# Generate archive file
cd $DirSrc
Cmd='tar'
Cmd+=' cvv'
Cmd+=' --anchored'
Cmd+=' --auto-compress'
Cmd+=" --file=$FileArchive"
# NOTE: Owner is verified and rejected on CentOS
# Cmd+=' --owner=bo'
Cmd+=' --show-stored-names'
Cmd+=" activation"
Cmd+=" doc"
Cmd+=" invocation"
Cmd+=" sample_project"
Cmd+=" README.rst"
$Cmd

################################################################################
: <<'DisabledContent'
DisabledContent
