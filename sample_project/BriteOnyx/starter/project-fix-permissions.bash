#!/bin/bash
[[ -n "$BO_Trace" ]] && echo "TRACE: Executing '$0'"
################################################################################

main () {
  parametersRequire 0 $#

  variableRequire BO_Home
  local -r Script=$BO_Home/helper/invocation/project-fix-permissions.bash
  variableRequire BO_Project
  scriptExecute $Script $BO_Project/bin
  scriptExecute $Script $BO_Project/BriteOnyx
  # TODO: Add other subdirectories as necessary
}

################################################################################
# NOTE: Uncomment the following two lines for debugging
# set -o verbose
# set -o xtrace

if [[ -z "$BO_Project" ]] ; then
  echo "This project is not activated, aborting"
else
  # Reference our script context
  Self="$(getPathAbsolute $0)" ; abortOnFail $0 $LINENO $?
  This="$(dirname $Self)"      ; abortOnFail $0 $LINENO $?

  main $@
fi

################################################################################
: <<'DisabledContent'
DisabledContent

