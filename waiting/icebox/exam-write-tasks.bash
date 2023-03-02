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

  local -r Name=$(getTaskOutputFileName $1 $2)
  local    Out
  local -r Timing=$(getTaskTimingFilePath $Name)

  cd $CB_DirBank/$2 ; abortOnFail $0 $LINENO $?

  local Cmd=./write.py
  if [[ -f "$Cmd" ]] ; then
    Cmd+=" --task=$1 --item=$2 --seg1=$3 --seg2=$4 --seg3=$5 --seg4=$6 --seg5=$7 --seg6=$8"
    Cmd+=" --seg7=$9 --seg8=${10} --seg9=${11} --seg10=${12} --seg11=${13} --seg12=${14}"
    [[ -n "$CB_Debug" ]] && Cmd+=" --debug=1"
    Out=$(getTaskWebpageFilePath $Name)
  else
    # TODO: REMOVE: Look for old BASH script if new Python script does not yet exist
    logWarn "Did NOT find Python script, executing BASH script instead"
    Cmd=./write.bash
    Cmd+=" $1 $3 $4 $5 $6 $7 $8 $9 ${10} ${11} ${12} ${13} ${14}"
    Out=$(getTaskStdoutFilePath $Name)
  fi

  logDebug "Writing exam task '$1' for exam item '$2', writing to '$Out'"

  local -ir Began="$(writeBegan $Timing)"
  writeCommand $Timing "$Cmd"

  # NOTE: No redirection of stderr because it should go to the console
  $Cmd 1>$Out ; abortOnFail $0 $LINENO $?

  writeEnded $Timing $Began
  [[ -n "$CB_Debug" ]] && writeTaskOutput $1 stdout $Out
  [[ -n "$CB_Debug" ]] && writeTaskOutput $1 timing $Timing
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

  variableRequire CB_DirBank

  # Configure Python search path variable
  local -r DirHelper=$BO_Project/bin/helper/Python
  directoryRequire $DirHelper
  local -r DirLibrary=$BO_Project/lib/tavisrudd-throw-out-your-templates
  directoryRequire $DirLibrary
  export PYTHONPATH=$DirHelper:$DirLibrary:$PYTHONPATH

  variableRequire   TMPDIR
  directoryCreate  $TMPDIR
  directoryRequire $TMPDIR

  scriptRequire $0:$FUNCNAME $LINENO $ScriptSegments ; source $ScriptSegments ; abortOnFail $0 $LINENO $?
  scriptExecute $0:$FUNCNAME $LINENO $ScriptTasks                             ; abortOnFail $0 $LINENO $?
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

