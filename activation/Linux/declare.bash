#!/bin/bash
echo 'INFO: Declaring all BASH scripting functionality for BriteOnyx...'

[[ -z "$BO_Home" ]] && echo 'FATAL: Missing $BO_Home' && return 1

_Dir=$BO_Home/activation/Linux
[[ ! -d "${_Dir}" ]] && echo "FATAL: Missing directory '${_Dir}'" && return 1
source ${_Dir}/declare-logging.bash
# source ${_Dir}/declare-BASH.bash
# source ${_Dir}/declare-POSIX.bash

# Return, but do NOT exit, with a success code
return 0

: <<'DisabledContent'
DisabledContent

