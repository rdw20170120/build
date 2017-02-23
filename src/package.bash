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
DirPackage=$TMPDIR/package
FileArchive=$TMPDIR/BriteOnyx.tb2

# Clean old output
[[ -d "$DirPackage"  ]] && rm -fr $DirPackage
[[ -f "$FileArchive" ]] && rm -f  $FileArchive

# Build new output
mkdir -p $DirPackage
cp -R $DirSrc $DirPackage
rm -fr $DirPackage/.hg
rm -f  $DirPackage/.hgignore
rm -f  $DirPackage/.hgtags
rm -fr $DirPackage/src

# Generate archive file
Cmd='tar'
Cmd+=' cvp'
Cmd+=' --anchored'
Cmd+=' --auto-compress'
Cmd+=" --directory=$DirPackage"
Cmd+=" --file=$FileArchive"
Cmd+=' --owner=bo'
Cmd+=' --show-stored-names'
Cmd+=" $DirPackage"
$Cmd

################################################################################
: <<'DisabledContent'
DisabledContent
