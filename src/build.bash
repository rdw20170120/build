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
echo 'Build BriteOnyx scripts from source'

[[ -z "$TMPDIR" ]] && TMPDIR=$HOME/tmp

DirSrc=$This
DirTgt=$TMPDIR/BriteOnyx/tgt
Script=$DirSrc/bin/build-all.bash

# Clean old output
[[ -d "$DirTgt" ]] && rm -fr $DirTgt

# Build new output
mkdir -p $DirTgt
[[ -f "$Script" ]] && $Script $DirSrc $DirTgt

################################################################################
: <<'DisabledContent'
DisabledContent
