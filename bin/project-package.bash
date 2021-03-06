#!/bin/bash
[[ -n "$BO_Trace" ]] && echo "TRACE: Executing '$BASH_SOURCE'"
################################################################################

main () {
  parametersRequire 0 $#

  # BROKEN: abort $BASH_SOURCE:$FUNCNAME $LINENO 125 "Forced abort for testing"
  # abort $0:$FUNCNAME $LINENO 125 "Forced abort for testing"

  variableRequire BO_ProjectName 
  variableRequire TMPDIR

  logInfo "Package $BO_ProjectName scripts"

  DirSrc=$BO_Project
  DirTgt=$TMPDIR
  directoryCreate $DirTgt
  FileTag=current_tag.txt
  Tag=$(cat $BO_Project/$FileTag)
  FileArchive=${BO_ProjectName}-${Tag}.tb2
  FileSig=${FileArchive}.md5

  # Clean old output
  [[ -f "$DirTgt/$FileArchive" ]] && rm -f $DirTgt/$FileArchive
  [[ -f "$DirTgt/$FileSig"     ]] && rm -f $DirTgt/$FileSig

  # Generate archive file
  cd $DirSrc
  Cmd='tar'
  Cmd+=' cv'
  Cmd+=' --anchored'
  Cmd+=' --auto-compress'
  Cmd+=" --file=$DirTgt/$FileArchive"
  # NOTE: DISABLED: Owner is verified and rejected on CentOS
  # Cmd+=' --owner=bo'
  Cmd+=' --show-stored-names'
  Cmd+=" helper"
  Cmd+=" sample_project"
  Cmd+=" LICENSE.rst"
  Cmd+=" README.rst"
  Cmd+=" $FileTag"
  $Cmd
  abortOnFail $0 $LINENO $?

  # Generate signature
  cd $DirTgt
  md5sum --tag $FileArchive >$FileSig
  abortOnFail $0 $LINENO $?
}

################################################################################

if [[ -z "$BO_Project" ]] ; then
  echo 'This project is not activated, aborting'
else
  main $@
  abortOnFail $0 $LINENO $?
fi
################################################################################
: <<'DisabledContent'
DisabledContent

