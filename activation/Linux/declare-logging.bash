#!/bin/bash
echo "TRACE: Executing '$BASH_SOURCE'"

# NOTE:  Uses ANSI coloring
# NOTE:  Logging priorities are implicitly ordered as:
#        Debug < Info < Warn < Error < Fatal

[[ -z "$BO_Home" ]] && echo 'FATAL: Missing $BO_Home' && return 1

# Remember ANSI color escape sequences for our logging priorities
_Script=$(dirname $BASH_SOURCE)/../../invocation/Linux/color.bash
export BO_ColorOff="$(${_Script} off)"
export BO_ColorDebug="$(${_Script} magenta black)"
export BO_ColorInfo="$(${_Script} green black)"
export BO_ColorWarn="$(${_Script} cyan black)"
export BO_ColorError="$(${_Script} yellow black)"
export BO_ColorFatal="$(${_Script} red black)"

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

  _logWithPriority "$1" 'FATAL: ' "$BO_ColorFatal"
}
export -f _logFatal

_logWithPriority () {
  # Log with priority $2 colorized as $3 the message $1
  # NOTE:  Should only be called from this script
  [[ "$#" -ne 3 ]] && Oops && exit 1
  # $1 = message
  # $2 = priority (short text prefix)
  # $3 = ANSI color specification

  _log "$3$2$1$BO_ColorOff"
}
export -f _logWithPriority

logDebug () {
  # Log a debugging message $1
  [[ "$#" -ne 1 ]] && Oops && exit 1
  # $1 = message

  _logWithPriority "$1" 'DEBUG: ' "$BO_ColorDebug"
}
export -f logDebug

logError () {
  # Log an error message $1
  [[ "$#" -ne 1 ]] && Oops && exit 1
  # $1 = message

  _logWithPriority "$1" 'ERROR: ' "$BO_ColorError"
}
export -f logError

logInfo () {
  # Log an informational message $1
  [[ "$#" -ne 1 ]] && Oops && exit 1
  # $1 = message

  _logWithPriority "$1" 'INFO:  ' "$BO_ColorInfo"
}
export -f logInfo

logWarn () {
  # Log a warning message $1
  [[ "$#" -ne 1 ]] && Oops && exit 1
  # $1 = message

  _logWithPriority "$1" 'WARN:  ' "$BO_ColorWarn"
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

return 0

: <<'DisabledContent'
DisabledContent

