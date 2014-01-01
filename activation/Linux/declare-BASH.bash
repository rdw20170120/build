#!/bin/bash
echo 'INFO: Declaring BASH general functionality for BriteOnyx...'

abort () {
  # Abort BASH execution with message $3 and exit status $4
  # $1 = optional message
  # $2 = optional exit status

  declare _Message="${1:-No message provided.}"
  declare -i _Status="${2:-1}"
  _logFatal "Aborting with status ${_Status}:  ${_Message}"
  if [[ "$SHLVL" -eq 1 ]] ; then
    logWarn 'At top level of BASH shell'
    # dumpBash
  fi
  exit ${_Status}
}
export -f abort

abortIfMissing () {
  # Abort with message $2 if value $1 is missing (resolves to null)
  [[ "$#" -ne 2 ]] && Oops && exit 1
  # $1 = value that is required
  # $2 = message

  [[ -n "$1" ]] && return 0
  abort "$2"
}
export -f abortIfMissing

abortOnFail () {
  # Abort on failure of previous command reported as exit status $1
  requireParameters 1 "$#"
  requireParameter "$1" 1 'previous command exit status'

  [[ "$1" -eq 0 ]] && return 0
  abort "Last command failed with exit status '$1'!"
}
export -f abortOnFail

dumpBash () {
  # Dump BASH variables
  logDebug 'Dumping BASH variables...'
  trace 0
  trace BASH
  trace BASH_ARGC
  trace BASH_ARGV
  trace BASH_COMMAND
  trace BASH_ENV
  trace BASH_EXECUTION_STRING
  trace BASH_LINENO
  trace BASH_REMATCH
  trace BASH_SOURCE
  trace BASH_SUBSHELL
  trace BASH_VERSINFO[0]
  trace BASH_VERSINFO[1]
  trace BASH_VERSINFO[2]
  trace BASH_VERSINFO[3]
  trace BASH_VERSINFO[4]
  trace BASH_VERSINFO[5]
  trace BASH_VERSION
  trace BASHPID
  trace CDPATH
  trace DIRSTACK
  # trace EDITOR
  trace EUID
  trace FUNCNAME
  trace GLOBIGNORE
  trace GROUPS
  # trace HOME
  trace HOSTNAME
  trace HOSTTYPE
  trace IFS
  trace IGNOREEOF
  trace LC_COLLATE
  trace LC_CTYPE
  trace LINENO
  trace MACHTYPE
  trace OLDPWD
  trace OSTYPE
  trace PATH
  trace PIPESTATUS
  trace PPID
  trace PROMPT_COMMAND
  trace PS1
  trace PS2
  trace PS3
  trace PS4
  trace PWD
  trace REPLY
  trace SECONDS
  trace SHELL
  trace SHELLOPTS
  trace SHLVL
  trace TMOUT
  trace UID
}
export -f dumpBash

requireParameter () {
  # Require parameter passed as $1, indexed as $2, and described as $3;
  # abort if missing
  requireParameters 3 "$#"
  # $1 = actual parameter value (may be null)
  requireValue "$2" 'parameter index'
  requireValue "$3" 'description'

  abortIfMissing "$1" "Missing parameter $2: $3!"
}
export -f requireParameter

requireParameters () {
  # Require exactly $1 parameters to calling function/script
  [[ "$#" -ne 2 ]] && Oops && exit 1
  requireValue "$1" 'required parameter count'
  requireValue "$2" 'actual parameter count'

  [[ "$2" -eq "$1" ]] && return 0
  abort "'$2' parameters were passed when exactly '$1' are required!"
}
export -f requireParameters

requireParametersAtLeast () {
  # Require at least $1 parameters to calling function/script
  requireParameters 2 "$#"
  requireValue "$1" 'required parameter count'
  requireValue "$2" 'actual parameter count'

  [[ "$2" -ge "$1" ]] && return 0
  abort "'$2' parameters were passed when at least '$1' are required!"
}
export -f requireParametersAtLeast

requireValue () {
  # Require value $1 described as $2, abort if missing (resolves to null)
  [[ "$#" -ne 2 ]] && Oops && exit 1
  # $1 = value that is required
  # $2 = description for value

  abortIfMissing "$1" "Value for '$2' is missing (non-null)!"
}
export -f requireValue

requireVariable () {
  # Require variable $1, abort if it is missing
  requireParameters 1 "$#"
  requireParameter  "$1" 1 'name of variable that is required'

  declare _Name=$1
  declare _Value="${!_Name}"
  [[ -n "${_Value}" ]] && return 0
  abort "Variable '$1' is required (defined and non-null)!"
}
export -f requireVariable

dumpBash | grep declare-BASH.bash

# Return, but do NOT exit, with a success code
return 0

: <<'DisabledContent'
DisabledContent

