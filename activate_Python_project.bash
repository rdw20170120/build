#!/bin/bash
echo 'INFO: Activating the Python project...'

# NOTE: This script should be sourced into the shell environment
# NOTE: This script, and EVERY script that it calls, must NOT invoke 'exit'!
#       The user calling this script must be allowed to preserve their shell
#       and every effort must be made to inform the user of problems while
#       continuing execution where possible.  Exiting the shell robs the user
#       of useful feedback and interrupts their work, which is unacceptable.

[[   -z "$BO_Home" ]] && echo 'FATAL: Missing $BO_Home'             && return 1
[[ ! -d "$BO_Home" ]] && echo "FATAL: Missing directory '$BO_Home'" && return 1

# Configure the Linux environment
_Dir=$BO_Home/bin/Linux/helper
source ${_Dir}/declare.bash
[[ $? -ne 0 ]] && echo 'FATAL: Aborting' && return 1

# NOTE: Now we have our special BriteOnyx scripting functionality loaded, so we
#       can shift to using that rather than directly invoking BASH primitives.

# Configure the Python environment
_Dir=$BO_Home/bin/Python/helper

: <<'DisabledContent'
requireDirectory ${_Dir}
source ${_Dir}/configure_TMPDIR
source ${_Dir}/configure_pip
source ${_Dir}/configure_virtualenv
source ${_Dir}/configure_PATH
source ${_Dir}/configure_output
DisabledContent

# Return, but do NOT exit, with a success code
return 0

