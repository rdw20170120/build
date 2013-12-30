#!/bin/bash
# Declare BASH functionality for logging

# NOTE:  Uses ANSI coloring

# NOTE:  This is a very low-level script used by practically all other scripts,
#        so it MUST NOT depend on any other scripts (beyond color)!

# NOTE:  Logging priorities are implicitly ordered as:
#        Debug < Info < Warn < Error < Fatal

[[ -z "$BO_Home" ]] && echo 'FATAL: Missing $BO_Home' && exit 1

_log () {
  # Log to STDERR the message $1
  # NOTE:  Should only be called from this script
  [[ "$#" -ne 1 ]] && Oops && exit 1
  # $1 = message

  declare -r _Message="${1:-No message provided.}"
  echo -e "${_Message}" >&2
}
export -f _log

_logFatal () {
  # Log a fatal message $1
  # NOTE:  Should only be called from abort()
  [[ "$#" -ne 1 ]] && Oops && exit 1
  # $1 = message

  declare -r _Color=$BO_Home/bin/Linux/color.bash
  _logWithPriority "$1" 'FATAL: ' "$(${_Color} red black)"
}
export -f _logFatal

_logWithPriority () {
  # Log with priority $2 colorized as $3 the message $1
  # NOTE:  Should only be called from this script
  [[ "$#" -ne 3 ]] && Oops && exit 1
  # $1 = message
  # $2 = priority (short text prefix)
  # $3 = ANSI color specification

  declare -r _Color=$BO_Home/bin/Linux/color.bash
  _log "$3$2$1$(${_Color} off)"
}
export -f _logWithPriority

logDebug () {
  # Log a debugging message $1
  [[ "$#" -ne 1 ]] && Oops && exit 1
  # $1 = message

  declare -r _Color=$BO_Home/bin/Linux/color.bash
  _logWithPriority "$1" 'DEBUG: ' "$(${_Color} magenta black)"
}
export -f logDebug

logError () {
  # Log an error message $1
  [[ "$#" -ne 1 ]] && Oops && exit 1
  # $1 = message

  declare -r _Color=$BO_Home/bin/Linux/color.bash
  _logWithPriority "$1" 'ERROR: ' "$(${_Color} red black)"
}
export -f logError

logInfo () {
  # Log an informational message $1
  [[ "$#" -ne 1 ]] && Oops && exit 1
  # $1 = message

  declare -r _Color=$BO_Home/bin/Linux/color.bash
  _logWithPriority "$1" 'INFO:  ' "$(${_Color} green black)"
}
export -f logInfo

logWarn () {
  # Log a warning message $1
  [[ "$#" -ne 1 ]] && Oops && exit 1
  # $1 = message

  declare -r _Color=$BO_Home/bin/Linux/color.bash
  _logWithPriority "$1" 'WARN:  ' "$(${_Color} yellow black)"
}
export -f logWarn

Oops () {
  # Echo to STDERR that an Oops occurred
  # NOTE:  This is usable to indicate an error in low-level code such as this
  # logging infrastructure that is then used to support error handling in
  # other higher-level code.

  echo "Oops!" >&2
}
export -f Oops

trace () {
  # Trace variable $1
  [[ "$#" -ne 1 ]] && Oops && exit 1
  # $1 = name of variable to trace

  declare -r _Name=$1
  declare -r _Value="${!_Name}"
  logDebug "${_Name}='${_Value}'"
}
export -f trace

: <<'DisabledContent'
DisabledContent

