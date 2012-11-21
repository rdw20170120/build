#!/bin/bash
echo 'INFO: Declaring all scripting functionality for BriteOnyx...'

_Dir=$BO_Home/bin/Linux/helper

: <<'DisabledContent'
source ${_Dir}/declare-logging.bash
source ${_Dir}/declare-BASH.bash
source ${_Dir}/declare-POSIX.bash
source ${_Dir}/declare-Hudson.bash
source ${_Dir}/declare-Mercurial.bash
source ${_Dir}/declare-Subversion.bash
DisabledContent

# Return, but do NOT exit, with a success code
return 0

