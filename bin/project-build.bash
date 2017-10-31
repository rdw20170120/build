#!/bin/bash
[[ -n "$BO_Trace" ]] && echo "TRACE: Executing '$BASH_SOURCE'"
################################################################################

if [[ -z "$BO_Project" ]] ; then
    echo 'This project is not activated, aborting'
else
  variableRequire BO_ProjectName 
  variableRequire TMPDIR

  logInfo "Build $BO_ProjectName scripts from source"

  DirSrc=$BO_Project/src
  DirTgt=$TMPDIR/tgt

  # Build new output
  directoryRecreate $DirTgt
  scriptExecute $BO_Project/src/bin/build-all.bash $DirSrc $DirTgt
fi

################################################################################
: <<'DisabledContent'
DisabledContent

