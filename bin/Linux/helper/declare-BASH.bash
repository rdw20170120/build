#!/bin/bash
# Declare functionality for BASH

abort () {
  # Abort BASH execution with message $3 and exit status $4
  [[ "$#" -lt 2 ]] && Oops "$FUNCNAME" "$LINENO" && return 1
  # $1 = name of script/function where call originated
  # $2 = line in script where call originated
  # $3 = optional message
  # $4 = optional exit status

  declare _Message="${3:-No message provided.}"
  declare -i _Status="${4:-1}"
  _logFatal "$1" "$2" "Aborting with status ${_Status}:  ${_Message}"
  if [[ "$SHLVL" -eq 1 ]] ; then
    logError "$1" "$2" 'At top level of BASH shell, NOT aborting!'
    dumpBash "$FUNCNAME" "$LINENO"
  else
    exit ${_Status}
  fi
}

abortIfMissing () {
  # Abort with message $4 if value $3 is missing (resolves to null)
  [[ "$#" -ne 4 ]] && Oops "$FUNCNAME" "$LINENO" && return 1
  # $1 = name of script/function where call originated
  # $2 = line in script where call originated
  # $3 = value that is required
  # $4 = message

  [[ -z "$3" ]] && abort "$1" "$2" "$4"
}

abortOnFail () {
  # Abort on failure of previous command reported as exit status $3
  requireParameters "$FUNCNAME" "$LINENO" 3 "$#"
  requireParameter  "$FUNCNAME" "$LINENO" "$1" 1 'script/function name'
  requireParameter  "$FUNCNAME" "$LINENO" "$2" 2 'script line'
  requireParameter  "$FUNCNAME" "$LINENO" "$3" 3 'previous command exit status'

  logDebug "$FUNCNAME" "$LINENO" "Last command exited with status '$3'"
  [[ "$3" -gt 0 ]] && abort "$1" "$2" "Command failed with exit status '$3'!"
}

dumpBash () {
  # Dump BASH variables
  [[ "$#" -ne 2 ]] && Oops "$FUNCNAME" "$LINENO" && return 1
  # $1 = name of script/function where call originated
  # $2 = line in script where call originated

  logDebug "$1" "$2" 'Dumping BASH variables...'
  trace "$1" "$2" BASH
  trace "$1" "$2" BASH_ARGC
  trace "$1" "$2" BASH_ARGV
  trace "$1" "$2" BASH_COMMAND
  trace "$1" "$2" BASH_ENV
  trace "$1" "$2" BASH_EXECUTION_STRING
  trace "$1" "$2" BASH_LINENO
  trace "$1" "$2" BASH_REMATCH
  trace "$1" "$2" BASH_SOURCE
  trace "$1" "$2" BASH_SUBSHELL
  trace "$1" "$2" BASH_VERSINFO[0]
  trace "$1" "$2" BASH_VERSINFO[1]
  trace "$1" "$2" BASH_VERSINFO[2]
  trace "$1" "$2" BASH_VERSINFO[3]
  trace "$1" "$2" BASH_VERSINFO[4]
  trace "$1" "$2" BASH_VERSINFO[5]
  trace "$1" "$2" BASH_VERSION
  trace "$1" "$2" BASHPID
  trace "$1" "$2" CDPATH
  trace "$1" "$2" DIRSTACK
  # trace "$1" "$2" EDITOR
  trace "$1" "$2" EUID
  trace "$1" "$2" FUNCNAME
  trace "$1" "$2" GLOBIGNORE
  trace "$1" "$2" GROUPS
  # trace "$1" "$2" HOME
  trace "$1" "$2" HOSTNAME
  trace "$1" "$2" HOSTTYPE
  trace "$1" "$2" IFS
  trace "$1" "$2" IGNOREEOF
  trace "$1" "$2" LC_COLLATE
  trace "$1" "$2" LC_CTYPE
  trace "$1" "$2" LINENO
  trace "$1" "$2" MACHTYPE
  trace "$1" "$2" OLDPWD
  trace "$1" "$2" OSTYPE
  # trace "$1" "$2" PATH
  trace "$1" "$2" PIPESTATUS
  trace "$1" "$2" PPID
  trace "$1" "$2" PROMPT_COMMAND
  trace "$1" "$2" PS1
  trace "$1" "$2" PS2
  trace "$1" "$2" PS3
  trace "$1" "$2" PS4
  trace "$1" "$2" PWD
  trace "$1" "$2" REPLY
  trace "$1" "$2" SECONDS
  trace "$1" "$2" SHELL
  trace "$1" "$2" SHELLOPTS
  trace "$1" "$2" SHLVL
  trace "$1" "$2" TMOUT
  trace "$1" "$2" UID
}

requireParameter () {
  # Require parameter passed as $1, indexed as $2, and described as $3;
  # abort if missing
  requireParameters "$FUNCNAME" "$LINENO" 5 "$#"
  requireValue "$FUNCNAME" "$LINENO" "$1" 'script/function name'
  requireValue "$FUNCNAME" "$LINENO" "$2" 'script line'
  # $3 = actual parameter value (may be null)
  requireValue "$FUNCNAME" "$LINENO" "$4" 'parameter index'
  requireValue "$FUNCNAME" "$LINENO" "$5" 'description'

  abortIfMissing "$1" "$2" "$3" "Missing parameter $4 = $5!"
}

requireParameters () {
  # Require exactly $3 parameters to calling function/script
  [[ "$#" -ne 4 ]] && Oops "$FUNCNAME" "$LINENO" && return 1
  requireValue "$FUNCNAME" "$LINENO" "$1" 'script/function name'
  requireValue "$FUNCNAME" "$LINENO" "$2" 'script line'
  requireValue "$FUNCNAME" "$LINENO" "$3" 'required parameter count'
  requireValue "$FUNCNAME" "$LINENO" "$4" 'actual parameter count (from $#)'

  [[ "$4" -ne "$3" ]] && \
    abort "$1" "$2" "'$4' parameters were passed when exactly '$3' are required!"
}

requireParametersAtLeast () {
  # Require at least $3 parameters to calling function/script
  requireParameters "$FUNCNAME" "$LINENO" 4 "$#"
  requireValue "$FUNCNAME" "$LINENO" "$1" 'script/function name'
  requireValue "$FUNCNAME" "$LINENO" "$2" 'script line'
  requireValue "$FUNCNAME" "$LINENO" "$3" 'required parameter count'
  requireValue "$FUNCNAME" "$LINENO" "$4" 'actual parameter count (from $#)'

  [[ "$4" -lt "$3" ]] && \
    abort "$1" "$2" "'$4' parameters were passed when at least '$3' are required!"
}

requireValue () {
  # Require value $3 described as $4, abort if missing (resolves to null)
  [[ "$#" -ne 4 ]] && Oops "$FUNCNAME" "$LINENO" && return 1
  # $1 = name of script/function where call originated
  # $2 = line in script where call originated
  # $3 = value that is required
  # $4 = description for value

  abortIfMissing "$1" "$2" "$3" "Value for '$4' is missing (non-null)!"
}

requireVariable () {
  # Require variable $3, abort if it is missing
  requireParameters "$FUNCNAME" "$LINENO" 3 "$#"
  requireParameter  "$FUNCNAME" "$LINENO" "$1" 1 'script/function name'
  requireParameter  "$FUNCNAME" "$LINENO" "$2" 2 'script line'
  requireParameter  "$FUNCNAME" "$LINENO" "$3" 3 'name of variable that is required'

  declare _Name=$3
  declare _Value="${!_Name}"
  [[ -z "${_Value}" ]] && \
    abort "$1" "$2" "Variable '$3' is required (defined and non-null)!"
}

