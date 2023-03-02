#!/bin/bash
[[ -n "$BO_Trace" ]] && echo "TRACE: Executing '$BASH_SOURCE'"
###################################################################################################
# This script is intended to be an entry point, to be directly executed by a user or otherwise.

main () {
  parametersRequire 0 $#

  # abort $0:$FUNCNAME $LINENO 125 "Forced abort for testing"

  logDebug "Writing exam agenda epilogue"
  cat <<'HERE'
    </ul>
  </body>
</html>
HERE
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

