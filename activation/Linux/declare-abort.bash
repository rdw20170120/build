#!/bin/bash
[[ -n "$BO_Trace" ]] && echo "TRACE: Executing '$BASH_SOURCE'"

###################################################################################################
# Verify pre-conditions

[[ -z "$BO_E_Config" ]] && echo 'FATAL: Missing $BO_E_Config' && return 63
[[ -z "$BO_E_Ok"     ]] && echo 'FATAL: Missing $BO_E_Ok'     && return "$BO_E_Config"
[[ -z "$BO_E_Usage"  ]] && echo 'FATAL: Missing $BO_E_Usage'  && return "$BO_E_Config"

###################################################################################################

abort () {
  # Abort BASH execution with exit status $1 and message $2
  [[ "$#" -ne 2 ]] && Oops && exit "$BO_E_Usage"
  # $1 = exit status
  # $2 = message

  _logFatal "ABORT: status $1: $2"
  if [[ "$SHLVL" -eq 1 ]] ; then
    logWarn 'At top level of BASH shell'
    # dumpBash
  fi
  exit $1
}
export -f abort

abortIfMissing () {
  # Abort with message $2 if value $1 is missing (resolves to empty string)
  [[ "$#" -ne 2 ]] && Oops && exit "$BO_E_Usage"
  # $1 = value that is required
  # $2 = message

  [[ -n "$1" ]] && return "$BO_E_Ok"
  abort 1 "Missing '$2'"
}
export -f abortIfMissing

abortOnFail () {
  # Abort on failure of previous command with exit status $1
  [[ "$#" -ne 1 ]] && Oops && exit "$BO_E_Usage"
  # $1 = exit status

  [[ "$1" -eq 0 ]] && return "$BO_E_Ok"
  abort "$1" 'Last command failed'
}
export -f abortOnFail

report () {
  # Report BASH execution with exit status $1 and message $2
  [[ "$#" -ne 2 ]] && Oops && exit "$BO_E_Usage"
  # $1 = exit status
  # $2 = message

  logWarn "Last command exited with status $1: $2"
}
export -f report

reportOnFail () {
  # Report on failure of previous command with exit status $1
  [[ "$#" -ne 1 ]] && Oops && exit "$BO_E_Usage"
  # $1 = exit status

  [[ "$1" -eq 0 ]] && return "$BO_E_Ok"
  report "$1" 'Last command failed'
}
export -f reportOnFail

###################################################################################################
# Return, but do NOT exit, with a success code
return "$BO_E_Ok"

###################################################################################################
: <<'DisabledContent'
DisabledContent

