#!/bin/bash
[[ -n "$BO_Trace" ]] && echo "TRACE: Executing '$BASH_SOURCE'"
###################################################################################################
# This script is intended to be an entry point, to be directly executed by a user or otherwise.

main () {
  parametersRequire 2 $#
  parameterRequire "$1" 1 'exam task identifier'
  parameterRequire "$2" 2 'exam item identifier'

  # abort $0:$FUNCNAME $LINENO 125 "Forced abort for testing"

  local -r Name=$(getTaskOutputFileName $1 $2)
  # TODO: SOMEDAY: REFACTOR: make reusable function for calculating link target
  local -r Link=./$Name.html

  logDebug "Writing exam agenda for task '$1' covering item '$2'"
  printf '      <li><a href="%s"/>Exam Task %s</a></li>\n' $Link $1
}

###################################################################################################

if [[ -z "$BO_Project" ]] ; then
  echo 'This project is not activated, aborting'
else
  main $@
  abortOnFail $0 $LINENO $?
fi

###################################################################################################
: <<'DisabledContent'
DisabledContent

