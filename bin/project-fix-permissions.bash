#!/bin/bash
[[ -n "$BO_Trace" ]] && echo "TRACE: Executing '$BASH_SOURCE'"
################################################################################

main () {
  parametersRequire 0 $#

  # BROKEN: abort $BASH_SOURCE:$FUNCNAME $LINENO 125 "Forced abort for testing"
  # abort $0:$FUNCNAME $LINENO 125 "Forced abort for testing"

  variableRequire BO_Home
  local -r Script=$BO_Home/helper/invocation/project-fix-permissions.bash
  variableRequire BO_Project
  scriptExecute $0:$FUNCNAME $LINENO $Script $BO_Project/bin
  scriptExecute $0:$FUNCNAME $LINENO $Script $BO_Project/BriteOnyx
  scriptExecute $0:$FUNCNAME $LINENO $Script $BO_Project/doc
  scriptExecute $0:$FUNCNAME $LINENO $Script $BO_Project/helper
  scriptExecute $0:$FUNCNAME $LINENO $Script $BO_Project/sample_project
  scriptExecute $0:$FUNCNAME $LINENO $Script $BO_Project/src
  scriptExecute $0:$FUNCNAME $LINENO $Script $BO_Project/activate.src
  scriptExecute $0:$FUNCNAME $LINENO $Script $BO_Project/BO-env-incoming.out
  scriptExecute $0:$FUNCNAME $LINENO $Script $BO_Project/BO-env-outgoing.out
  scriptExecute $0:$FUNCNAME $LINENO $Script $BO_Project/current_tag.txt
  scriptExecute $0:$FUNCNAME $LINENO $Script $BO_Project/env.src
  scriptExecute $0:$FUNCNAME $LINENO $Script $BO_Project/LICENSE.rst
  scriptExecute $0:$FUNCNAME $LINENO $Script $BO_Project/README.rst
  scriptExecute $0:$FUNCNAME $LINENO $Script $BO_Project/.hgignore
  scriptExecute $0:$FUNCNAME $LINENO $Script $BO_Project/.hgtags
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

