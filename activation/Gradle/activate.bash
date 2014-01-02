#!/bin/bash
echo "TRACE: Executing '$BASH_SOURCE'"

###################################################################################################
# Verify pre-conditions

[[   -z "$BO_Home"          ]] && echo 'FATAL: Missing $BO_Home'                && return 63
[[ ! -d "$BO_Home"          ]] && echo "FATAL: Missing directory '$BO_Home'"    && return 63
[[   -z "$BO_Project"       ]] && echo 'FATAL: Missing $BO_Project'             && return 63
[[ ! -d "$BO_Project"       ]] && echo "FATAL: Missing directory '$BO_Project'" && return 63
[[   -z "$BO_GradleVersion" ]] && echo 'FATAL: Missing $BO_GradleVersion'       && return 63
[[   -z "$BO_PathSystem"    ]] && echo 'FATAL: Missing $BO_PathSystem'          && return 63
[[   -z "$JAVA_HOME"        ]] && echo 'FATAL: Missing $JAVA_HOME'              && return 63

_Dir=$BO_Home/activation/Linux
[[ ! -d "${_Dir}" ]] && echo "FATAL: Missing directory '${_Dir}'" && return 63

###################################################################################################
# Configure environment for Linux

_Script=${_Dir}/activate.bash
[[ ! -f "${_Script}" ]] && echo "FATAL: Missing script '${_Script}'" && return 63

source ${_Script}

_ExitCode=$?
[[ ${_ExitCode} -ne 0 ]] && echo "FATAL: Exit code ${_ExitCode} at '$BASH_SOURCE':$LINENO" && return ${_ExitCode}

###################################################################################################
# Verify post-conditions

[[ -z "$BO_E_Config"  ]] && echo 'FATAL: Missing $BO_E_Config'  && return 63
[[ -z "$BO_E_Ok"      ]] && echo 'FATAL: Missing $BO_E_Ok'      && return "$BO_E_Config"
[[ -z "$BO_PathLinux" ]] && echo 'FATAL: Missing $BO_PathLinux' && return "$BO_E_Config"

###################################################################################################
# Configure environment for Gradle on Linux

export BO_PathGradle=$JAVA_HOME/bin

PATH=${BO_PathProject}
PATH=$PATH:${BO_PathGradle}
PATH=$PATH:${BO_PathLinux}
PATH=$PATH:${BO_PathSystem}
export PATH

###################################################################################################
# Return, but do NOT exit, with a success code
return "$BO_E_Ok"

###################################################################################################
: <<'DisabledContent'
DisabledContent

