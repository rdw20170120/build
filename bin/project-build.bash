#!/bin/bash
[[ -n "$BO_Trace" ]] && echo "TRACE: Executing '$BASH_SOURCE'"
################################################################################

main () {
  parametersRequire 0 $#

  # BROKEN: abort $BASH_SOURCE:$FUNCNAME $LINENO 125 "Forced abort for testing"
  # abort $0:$FUNCNAME $LINENO 125 "Forced abort for testing"

  variableRequire BO_ProjectName 
  variableRequire TMPDIR

  logInfo "Build $BO_ProjectName scripts from source"

  DirSrc=$BO_Project/src
  DirTgt=$TMPDIR/tgt

  # Build new output
  directoryRecreate $DirTgt
  scriptExecute $BO_Project/src/bin/build-all.bash $DirSrc $DirTgt
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

