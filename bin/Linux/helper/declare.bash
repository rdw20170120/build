#!/bin/bash
echo 'INFO: Declaring all scripting functionality for BriteOnyx...'

[[ -z "$BO_Home" ]] && echo 'FATAL: Missing $BO_Home' && return 1
_Dir=$BO_Home/bin/Linux/helper
[[ ! -d "${_Dir}" ]] && echo "FATAL: Missing directory '${_Dir}'" && return 1
source ${_Dir}/declare-logging.bash
source ${_Dir}/declare-BASH.bash
source ${_Dir}/declare-POSIX.bash

logDebug "$BASH_SOURCE" "$LINENO" "This is an example debugging message"
logInfo  "$BASH_SOURCE" "$LINENO" "This is an example informational message"
logWarn  "$BASH_SOURCE" "$LINENO" "This is an example warning message"
logError "$BASH_SOURCE" "$LINENO" "This is an example error message"

: <<'DisabledContent'
# Integrate later, preferably as optional components
source ${_Dir}/declare-Hudson.bash
source ${_Dir}/declare-Mercurial.bash
source ${_Dir}/declare-Subversion.bash
DisabledContent

# Return, but do NOT exit, with a success code
return 0

