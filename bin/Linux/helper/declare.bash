#!/bin/bash
echo 'INFO: Declaring all scripting functionality for BriteOnyx...'

[[ -z "$BO_Home" ]] && echo 'FATAL: Missing $BO_Home' && return 1
_Dir=$BO_Home/bin/Linux/helper
source ${_Dir}/declare-logging.bash
source ${_Dir}/declare-BASH.bash

: <<'DisabledContent'
source ${_Dir}/declare-POSIX.bash
source ${_Dir}/declare-Hudson.bash
source ${_Dir}/declare-Mercurial.bash
source ${_Dir}/declare-Subversion.bash
DisabledContent

# Return, but do NOT exit, with a success code
return 0

