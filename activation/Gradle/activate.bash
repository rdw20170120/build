#!/bin/bash
echo "TRACE: Executing '$BASH_SOURCE'"

[[   -z "$BO_Home"    ]] && echo 'FATAL: Missing $BO_Home'                && return 1
[[ ! -d "$BO_Home"    ]] && echo "FATAL: Missing directory '$BO_Home'"    && return 1
[[   -z "$BO_Project" ]] && echo 'FATAL: Missing $BO_Project'             && return 1
[[ ! -d "$BO_Project" ]] && echo "FATAL: Missing directory '$BO_Project'" && return 1

[[ -z "$BO_PathSystem" ]] && echo 'FATAL: Missing $BO_PathSystem' && return 1
[[ -z "$JAVA_HOME"     ]] && echo 'FATAL: Missing $JAVA_HOME'     && return 1

# Configure environment for Linux

_Dir=$BO_Home/activation/Linux
[[ ! -d "${_Dir}" ]] && echo "FATAL: Missing directory '${_Dir}'" && return 1

_Script=${_Dir}/activate.bash
[[ ! -f "${_Script}" ]] && \
  echo "FATAL: Missing script '${_Script}'" && \
  return 1

source ${_Script}

_ExitCode=$?
[[ ${_ExitCode} -ne 0 ]] && \
  echo "FATAL: Exit code ${_ExitCode} at '$BASH_SOURCE':$LINENO" && \
  return ${_ExitCode}

# Configure environment for Gradle on Linux

BO_PathGradle=$JAVA_HOME/bin

PATH=${BO_PathProject}
PATH=$PATH:${BO_PathGradle}
PATH=$PATH:${BO_PathLinux}
PATH=$PATH:${BO_PathSystem}
export PATH

# Return, but do NOT exit, with a success code
return 0

: <<'DisabledContent'
DisabledContent

