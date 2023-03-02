#!/bin/bash
[[ -n "$BO_Trace" ]] && echo "TRACE: Executing '$BASH_SOURCE'"
################################################################################
# This script is intended to be an entry point, to be directly executed by a user or otherwise.

################################################################################

main () {
  parametersRequire 0 $#

  # abort $0:$FUNCNAME $LINENO 125 "Forced abort for testing"

  variableRequire BO_ProjectName
  variableRequire This

  local -r DirTgt=$TMPDIR/tgt

  logInfo "Generating scripts for project '$BO_ProjectName' into directory '$DirTgt'"

  # Configure Python path
  local -r DirHelperProject=$BO_Project/helper/Python
  local -r DirHelperThird=$BO_Project/lib/tavisrudd-throw-out-your-templates
  directoryRequire $DirHelperProject
  directoryRequire $DirHelperThird
  export PYTHONPATH=$DirHelperProject:$DirHelperThird:$PYTHONPATH

  scriptExecute $0:$FUNCNAME $LINENO $This/helper/all_generate.py "$This" "$DirTgt"

  logWarn "Please manually synchronize updates into the project from the generated output"
  logInfo "meld '$DirTgt' '$BO_Project'"
  meld >/dev/null 2>&1 --newtab "$DirTgt" "$BO_Project" &
}

################################################################################

if [[ -z "$BO_Project" ]] ; then
  echo 'This project is not activated, aborting'
else
  Self="$(getPathAbsolute $BASH_SOURCE)"
  This="$(dirname $Self)"
  main $@
  abortOnFail $0 $LINENO $?
fi

################################################################################
: <<'DisabledContent'
DisabledContent

