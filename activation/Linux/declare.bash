#!/bin/bash
echo 'INFO: Declaring all BASH scripting functionality for BriteOnyx...'

[[ -z "$BO_Home" ]] && echo 'FATAL: Missing $BO_Home' && return 1

_Dir=$BO_Home/activation/Linux
[[ ! -d "${_Dir}" ]] && echo "FATAL: Missing directory '${_Dir}'" && return 1

_Script=${_Dir}/declare-logging.bash
[[ ! -f "${_Script}" ]] && \
  echo "FATAL: Missing script '${_Script}'" && \
  return 1
source ${_Script}

_Script=${_Dir}/declare-BASH.bash
[[ ! -f "${_Script}" ]] && \
  echo "FATAL: Missing script '${_Script}'" && \
  return 1
source ${_Script}

dumpBash | grep declare.bash

_Script=${_Dir}/declare-POSIX.bash
[[ ! -f "${_Script}" ]] && \
  echo "FATAL: Missing script '${_Script}'" && \
  return 1
source ${_Script}

# Return, but do NOT exit, with a success code
return 0

: <<'DisabledContent'
DisabledContent

