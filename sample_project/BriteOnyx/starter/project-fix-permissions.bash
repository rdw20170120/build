#!/bin/bash
[[ -n "$BO_Trace" ]] && echo "TRACE: Executing '$BASH_SOURCE'"
################################################################################

main () {
  parametersRequire 0 $#

  variableRequire BO_Home
  local -r Script=$BO_Home/helper/invocation/project-fix-permissions.bash
  variableRequire BO_Project
  scriptExecute $0:$FUNCNAME $LINENO $Script $BO_Project/bin
  scriptExecute $0:$FUNCNAME $LINENO $Script $BO_Project/BriteOnyx
  # TODO: Add other subdirectories as necessary
}

################################################################################

if [[ -z "$BO_Project" ]] ; then
  echo "This project is not activated, aborting"
else
  main $@
  abortOnFail $0 $LINENO $?
fi

################################################################################
: <<'DisabledContent'
DisabledContent

