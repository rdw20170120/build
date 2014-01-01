#!/bin/bash
echo "TRACE: Executing '$BASH_SOURCE'"

[[   -z "$BO_Home"    ]] && echo 'FATAL: Missing $BO_Home'                && return 1
[[ ! -d "$BO_Home"    ]] && echo "FATAL: Missing directory '$BO_Home'"    && return 1
[[   -z "$BO_Project" ]] && echo 'FATAL: Missing $BO_Project'             && return 1
[[ ! -d "$BO_Project" ]] && echo "FATAL: Missing directory '$BO_Project'" && return 1

[[ -z "$BO_PathSystem" ]] && echo 'FATAL: Missing $BO_PathSystem' && return 1

# Configure the Linux environment

_Dir=$BO_Home/activation/Linux
[[ ! -d "${_Dir}" ]] && echo "FATAL: Missing directory '${_Dir}'" && return 1

_Script=${_Dir}/declare.bash
[[ ! -f "${_Script}" ]] && \
  echo "FATAL: Missing script '${_Script}'" && \
  return 1

source ${_Script}

_ExitCode=$?
[[ ${_ExitCode} -ne 0 ]] && \
  echo "FATAL: Exit code ${_ExitCode} at '$BASH_SOURCE':$LINENO" && \
  return ${_ExitCode}

BO_PathProject=$BO_Project/bin/Linux
BO_PathLinux=$BO_Home/invocation/Linux

PATH=${BO_PathProject}
PATH=$PATH:${BO_PathLinux}
PATH=$PATH:${BO_PathSystem}
export PATH

# Configure TMPDIR
[[ -z "$TMPDIR" ]] && echo 'FATAL: Missing $TMPDIR' && return 1

# Demonstrate logging
logDebug  "EXAMPLE: This is a debugging message"
logInfo   "EXAMPLE: This is an informational message"
logWarn   "EXAMPLE: This is a warning message"
logError  "EXAMPLE: This is an error message"
_logFatal "EXAMPLE: This is a fatal message"

# Return, but do NOT exit, with a success code
# Return, but do NOT exit, with a success code
return 0

: <<'DisabledContent'
DisabledContent

