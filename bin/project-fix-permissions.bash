#!/bin/bash
[[ -n "$BO_Trace" ]] && echo "TRACE: Executing '$BASH_SOURCE'"
################################################################################

main () {
  parametersRequire 0 $#

  variableRequire BO_Home
  local -r Script=$BO_Home/helper/invocation/project-fix-permissions.bash
  variableRequire BO_Project
  scriptExecute $Script $BO_Project/bin
  scriptExecute $Script $BO_Project/BriteOnyx
  scriptExecute $Script $BO_Project/doc
  scriptExecute $Script $BO_Project/helper
  scriptExecute $Script $BO_Project/sample_project
  scriptExecute $Script $BO_Project/src
  scriptExecute $Script $BO_Project/activate.src
  scriptExecute $Script $BO_Project/BO-env-incoming.out
  scriptExecute $Script $BO_Project/BO-env-outgoing.out
  scriptExecute $Script $BO_Project/current_tag.txt
  scriptExecute $Script $BO_Project/env.src
  scriptExecute $Script $BO_Project/LICENSE.rst
  scriptExecute $Script $BO_Project/README.rst
  scriptExecute $Script $BO_Project/.hgignore
  scriptExecute $Script $BO_Project/.hgtags
}

################################################################################
# NOTE: Uncomment the following two lines for debugging
# set -o verbose
# set -o xtrace

if [[ -z "$BO_Project" ]] ; then
  echo "This project is not activated, aborting"
else
  # Reference our script context
  Self="$(getPathAbsolute $BASH_SOURCE)" ; abortOnFail $?
  This="$(dirname $Self)"                ; abortOnFail $?

  main $@
fi

################################################################################
: <<'DisabledContent'
DisabledContent

