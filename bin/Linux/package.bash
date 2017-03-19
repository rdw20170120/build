#!/bin/bash
[[ -n "$BO_Trace" ]] && echo "TRACE: Executing '$BASH_SOURCE'"
################################################################################
# NOTE: Uncomment the following two lines for debugging
# set -o verbose
# set -o xtrace

################################################################################

if [[ -z "$BO_Project" ]] ; then
  echo 'This project is not activated, aborting'
else
  # Reference our script context
  Self="$BASH_SOURCE"
  This="$(dirname $Self)"

  variableRequire BO_ProjectName 
  variableRequire TMPDIR

  logInfo "Package $BO_ProjectName scripts"

  DirSrc=$BO_Project
  DirTgt=$TMPDIR/$BO_ProjectName
  directoryCreate $DirTgt
  FileTag=current_tag.txt
  Tag=$(cat $BO_Project/$FileTag)
  FileArchive=$DirTgt/${BO_ProjectName}-${Tag}.tb2

  # Clean old output
  [[ -f "$FileArchive" ]] && rm -f $FileArchive

  # Generate archive file
  cd $DirSrc
  Cmd='tar'
  Cmd+=' cv'
  Cmd+=' --anchored'
  Cmd+=' --auto-compress'
  Cmd+=" --file=$FileArchive"
  # NOTE: DISABLED: Owner is verified and rejected on CentOS
  # Cmd+=' --owner=bo'
  Cmd+=' --show-stored-names'
  Cmd+=" helper"
  Cmd+=" sample_project"
  Cmd+=" LICENSE.rst"
  Cmd+=" README.rst"
  Cmd+=" $FileTag"
  $Cmd
fi

################################################################################
: <<'DisabledContent'
DisabledContent

