#!/bin/bash
# Activate this project using the BriteOnyx framework

# NOTE: This script should be sourced into the shell environment
# NOTE: This script, and EVERY script that it calls, must NOT invoke 'exit'!
#       The user calling this script must be allowed to preserve their shell
#       and every effort must be made to inform the user of problems while
#       continuing execution where possible.  Exiting the shell robs the user
#       of useful feedback and interrupts their work, which is unacceptable.

echo 'WARN: This script should be executed as "source ./activate.bash", was it?'

# Dump incoming environment for potential troubleshooting
env | sort > ./env.out

# Remember the current directory as our project home
export BO_Project=$PWD
[[ -z "$BO_Project" ]] && echo 'FATAL: Missing $BO_Project' && return 1

source $BO_Project/cfg/project-env.bash
[[ $? -ne 0 ]] && echo 'FATAL: Aborting' && return 1

source $BO_Project/bootstrap.bash
[[ $? -ne 0 ]] && echo 'FATAL: Aborting' && return 1

[[ -z "$BO_Home" ]] && echo 'FATAL: Missing $BO_Home' && return 1
source $BO_Home/activate_Python_project.bash
[[ $? -ne 0 ]] && echo 'FATAL: Aborting' && return 1

: <<'DisabledContent'
DisabledContent

# Return, but do NOT exit, with a success code
echo "INFO: Project '$BO_Project' is now activated, done."
return 0

