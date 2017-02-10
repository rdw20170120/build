#!/bin/bash
[[ -n "$BO_Trace" ]] && echo "TRACE: Executing '$BASH_SOURCE'"
################################################################################
# NOTE: Uncomment the following two lines for debugging
# set -o verbose
# set -o xtrace

################################################################################
echo 'Build BriteOnyx scripts from source'

[[ -z "$TMPDIR" ]] && TMPDIR=$HOME/tmp

DirSrc=$PWD/src
DirTgt=$TMPDIR/tgt
Script=$DirSrc/build-all.bash

# Clean old output
[[ -d "$DirTgt" ]] && rm -fr "$DirTgt"

# Build new output
mkdir "$DirTgt"
[[ -f "$Script" ]] && "$Script" "$DirSrc" "$DirTgt"

################################################################################
: <<'DisabledContent'
DisabledContent
