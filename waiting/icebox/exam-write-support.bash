#!/bin/bash
[[ -n "$BO_Trace" ]] && echo "TRACE: Executing '$BASH_SOURCE'"
###################################################################################################
# This script is NOT intended to be an entry point, to be directly executed by a user or otherwise.

main () {
  parametersRequire 0 $#

  # abort $0:$FUNCNAME $LINENO 125 "Forced abort for testing"

  logInfo "Writing exam support pages"

  # Configure Python search path variable
  local -r DirHelper=$BO_Project/bin/helper/Python
  directoryRequire $DirHelper
  local -r DirLibrary=$BO_Project/lib/tavisrudd-throw-out-your-templates
  directoryRequire $DirLibrary
  export PYTHONPATH=$DirHelper:$DirLibrary:$PYTHONPATH

  variableRequire   TMPDIR
  directoryCreate  $TMPDIR/support
  directoryRequire $TMPDIR/support

  local -rx Timing=$(getTaskTimingFilePath support)

  local -ir Began="$(writeBegan $Timing)"

  scriptExecute $0:$FUNCNAME $LINENO $DirHelper/write-BASH.py           ; abortOnFail $0 $LINENO $?
  scriptExecute $0:$FUNCNAME $LINENO $DirHelper/write-cut_and_paste.py  ; abortOnFail $0 $LINENO $?
  scriptExecute $0:$FUNCNAME $LINENO $DirHelper/write-do_then_undo.py   ; abortOnFail $0 $LINENO $?
  scriptExecute $0:$FUNCNAME $LINENO $DirHelper/write-focus.py          ; abortOnFail $0 $LINENO $?
  scriptExecute $0:$FUNCNAME $LINENO $DirHelper/write-machine_naming.py ; abortOnFail $0 $LINENO $?
  scriptExecute $0:$FUNCNAME $LINENO $DirHelper/write-overview.py       ; abortOnFail $0 $LINENO $?
  scriptExecute $0:$FUNCNAME $LINENO $DirHelper/write-session.py        ; abortOnFail $0 $LINENO $?
  scriptExecute $0:$FUNCNAME $LINENO $DirHelper/write-ssh.py            ; abortOnFail $0 $LINENO $?
  scriptExecute $0:$FUNCNAME $LINENO $DirHelper/write-sudo.py           ; abortOnFail $0 $LINENO $?
  scriptExecute $0:$FUNCNAME $LINENO $DirHelper/write-UI.py             ; abortOnFail $0 $LINENO $?

  writeEnded $Timing $Began
  [[ -n "$CB_Debug" ]] && writeTaskOutput 'support' timing $Timing
  return 0
}

####################################################################################################

if [[ -z "$BO_Project" ]] ; then
  echo 'This project is not activated, aborting'
else
  main $@
  abortOnFail $0 $LINENO $?
fi

###################################################################################################
: <<'DisabledContent'
DisabledContent

