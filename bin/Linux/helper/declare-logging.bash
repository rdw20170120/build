#!/bin/bash
# Declare BASH functionality for logging

# NOTE:  Uses ANSI coloring

# NOTE:  This is a very low-level script used by practically all other scripts,
#        so it MUST NOT depend on any other scripts (beyond color)!

# NOTE:  Logging priorities are implicitly ordered as:
#        Debug < Info < Warn < Error < Fatal

# For logging the source of calls below, pass $LINENO for the line and either
# $FUNCNAME, $BASH_SOURCE, or $0 for the name.

[[ -z "$BO_Home" ]] && echo 'FATAL: Missing $BO_Home' && return 1
_Dir=$BO_Home/bin/Linux/helper
_Color=${_Dir}/color.bash

_log () {
  # Log to STDERR the message $3 that originated in line $2 of script $1
  # NOTE:  Should only be called from this script
  [[ "$#" -ne 3 ]] && Oops "$FUNCNAME" "$LINENO" && return 1
  # $1 = name of script/function where call originated
  # $2 = line in script where call originated
  # $3 = message

  declare -r _Name="${1:-Unknown}"
  declare -r _Line="${2:-0}"
  declare -r _Message="${3:-No message provided.}"
  echo -e "${_Name}:${_Line} ${_Message}" >&2
}

_logFatal () {
  # Log a fatal message $3 that originated in line $2 of script $1
  # NOTE:  Should only be called from abort()
  [[ "$#" -ne 3 ]] && Oops "$FUNCNAME" "$LINENO" && return 1
  # $1 = name of script/function where call originated
  # $2 = line in script where call originated
  # $3 = message

  _logWithPriority "$1" "$2" "$3" 'FATAL: ' "$(${_Color} red black)"
}

_logWithPriority () {
  # Log with priority $4 colorized as $5 the message $3 that originated in line
  # $2 of script $1
  # NOTE:  Should only be called from this script
  [[ "$#" -ne 5 ]] && Oops "$FUNCNAME" "$LINENO" && return 1
  # $1 = name of script/function where call originated
  # $2 = line in script where call originated
  # $3 = message
  # $4 = priority (short text prefix)
  # $5 = ANSI color specification

  _log "$1" "$2" "$5$4$3$(${_Color} off)"
}

logDebug () {
  # Log a debugging message $3 that originated in line $2 of script $1
  [[ "$#" -ne 3 ]] && Oops "$FUNCNAME" "$LINENO" && return 1
  # $1 = name of script/function where call originated
  # $2 = line in script where call originated
  # $3 = message

  _logWithPriority "$1" "$2" "$3" 'DEBUG: ' "$(${_Color} magenta black)"
}

logError () {
  # Log an error message $3 that originated in line $2 of script $1
  [[ "$#" -ne 3 ]] && Oops "$FUNCNAME" "$LINENO" && return 1
  # $1 = name of script/function where call originated
  # $2 = line in script where call originated
  # $3 = message

  _logWithPriority "$1" "$2" "$3" 'ERROR: ' "$(${_Color} yellow black)"
}

logInfo () {
  # Log an informational message $3 that originated in line $2 of script $1
  [[ "$#" -ne 3 ]] && Oops "$FUNCNAME" "$LINENO" && return 1
  # $1 = name of script/function where call originated
  # $2 = line in script where call originated
  # $3 = message

  _logWithPriority "$1" "$2" "$3" 'INFO:  ' "$(${_Color} blue black)"
}

logWarn () {
  # Log a warning message $3 that originated in line $2 of script $1
  [[ "$#" -ne 3 ]] && Oops "$FUNCNAME" "$LINENO" && return 1
  # $1 = name of script/function where call originated
  # $2 = line in script where call originated
  # $3 = message

  _logWithPriority "$1" "$2" "$3" 'WARN:  ' "$(${_Color} cyan black)"
}

Oops () {
  # Echo to STDERR that an Oops originated in line $2 of script $1
  # NOTE:  This is usable to indicate an error in low-level code such as this
  # logging infrastructure that is then used to support error handling in
  # other higher-level code.
  # $1 = name of script/function where call originated
  # $2 = line in script where call originated

  echo "$1:$2 had an Oops!" >&2
}

trace () {
  # Trace variable $3 that originated in line $2 of script $1
  [[ "$#" -ne 3 ]] && Oops "$FUNCNAME" "$LINENO" && return 1
  # $1 = name of script/function where call originated
  # $2 = line in script where call originated
  # $3 = name of variable to trace

  declare -r _Name=$3
  declare -r _Value="${!_Name}"
  logDebug "$1" "$2" "${_Name}='${_Value}'"
}

