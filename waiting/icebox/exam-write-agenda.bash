#!/bin/bash
[[ -n "$BO_Trace" ]] && echo "TRACE: Executing '$BASH_SOURCE'"
###################################################################################################
# This script is NOT intended to be an entry point, to be directly executed by a user or otherwise.

executeFor () {
  parametersRequireAtLeast 2 $#
  parameterRequire "$1" 1 'exam task identifier'
  parameterRequire "$2" 2 'exam item identifier'
  # optional parameters $3 thru $14 = exam item segments for variability

  # abort $0:$FUNCNAME $LINENO 125 "Forced abort for testing"

  variableRequire DirExam
  variableRequire Out
  variableRequire Timing

  local Cmd=$BO_Project/bin/helper/Linux/exam-write-agenda-task.bash
  Cmd+=" $1 $2"

  logDebug "Writing agenda for exam task '$1' covering exam item '$2', to '$Out'"

  writeCommand $Timing "$Cmd"

  # NOTE: No redirection of stderr because it should go to the console
  $Cmd 1>>$Out ; abortOnFail $0 $LINENO $?
}
export -f executeFor

main () {
  parametersRequire 2 $#
  parameterRequire "$1" 1 'exam tasks script'
  parameterRequire "$2" 2 'exam segments script'

  # abort $0:$FUNCNAME $LINENO 125 "Forced abort for testing"

  local -r ScriptTasks=$1
  local -r ScriptSegments=$2

  logInfo "Writing exam tasks '$ScriptTasks' using segments in '$ScriptSegments'"

  variableRequire DirExam

  # Configure Python search path variable
  local -r DirHelper=$BO_Project/bin/helper/Python
  directoryRequire $DirHelper
  local -r DirLibrary=$BO_Project/lib/tavisrudd-throw-out-your-templates
  directoryRequire $DirLibrary
  export PYTHONPATH=$DirHelper:$DirLibrary:$PYTHONPATH

  variableRequire   TMPDIR
  directoryCreate  $TMPDIR
  directoryRequire $TMPDIR

  local -rx Out=$(getTaskWebpageFilePath index)
  local -rx Timing=$(getTaskTimingFilePath index)

  local -ir Began="$(writeBegan $Timing)"
  scriptExecute $0:$FUNCNAME $LINENO $BO_Project/bin/helper/Linux/exam-write-agenda-prologue.bash 1>$Out

  # cd $CB_DirBank/$2 ; abortOnFail $0 $LINENO $?
  scriptRequire $0:$FUNCNAME $LINENO $ScriptSegments ; source $ScriptSegments ; abortOnFail $0 $LINENO $?
  scriptExecute $0:$FUNCNAME $LINENO $ScriptTasks                             ; abortOnFail $0 $LINENO $?

  scriptExecute $0:$FUNCNAME $LINENO $BO_Project/bin/helper/Linux/exam-write-agenda-epilogue.bash 1>>$Out
  writeEnded $Timing $Began
  [[ -n "$CB_Debug" ]] && writeTaskOutput 'agenda' stdout $Out
  [[ -n "$CB_Debug" ]] && writeTaskOutput 'agenda' timing $Timing
  return 0
}

####################################################################################################

if [[ -z "$BO_Project" ]] ; then
  echo 'This project is not activated, aborting'
else
  # Reference our script context
  Self="$BASH_SOURCE"
  This="$(dirname $Self)"

  main $@
  abortOnFail $0 $LINENO $?
fi

###################################################################################################
: <<'DisabledContent'
DisabledContent

