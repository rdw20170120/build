#!/bin/bash
[[ -n "$BO_Trace" ]] && echo "TRACE: Executing '$BASH_SOURCE'"
# NOTE: Assumes that this project has been activated using the BriteOnyx framework.
###################################################################################################

variableRequire 'BO_Project'
directoryRequire "$BO_Project"

###################################################################################################
logInfo 'Cleaning up in project'

find "$BO_Project" -type f -name "*~" -exec ls -al '{}' \;
find "$BO_Project" -type f -name "*~" -exec rm     '{}' \;

###################################################################################################
: <<'DisabledContent'
DisabledContent
