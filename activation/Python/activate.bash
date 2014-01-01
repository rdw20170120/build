#!/bin/bash
echo "TRACE: Executing '$BASH_SOURCE'"

[[   -z "$BO_Home"    ]] && echo 'FATAL: Missing $BO_Home'                && return 1
[[ ! -d "$BO_Home"    ]] && echo "FATAL: Missing directory '$BO_Home'"    && return 1
[[   -z "$BO_Project" ]] && echo 'FATAL: Missing $BO_Project'             && return 1
[[ ! -d "$BO_Project" ]] && echo "FATAL: Missing directory '$BO_Project'" && return 1

[[ -z "$BO_PathSystem" ]] && echo 'FATAL: Missing $BO_PathSystem' && return 1

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

# Configure environment for Python on Linux
[[ -z "$BO_PathLinux" ]] && echo 'FATAL: Missing $BO_PathLinux' && return 1

export BO_PathProject=$BO_Project/bin/Linux:$BO_Project/PVE/bin
export BO_PathPython=$BO_Home/invocation/Python

PATH=${BO_PathProject}
PATH=$PATH:${BO_PathPython}
PATH=$PATH:${BO_PathLinux}
PATH=$PATH:${BO_PathSystem}
export PATH

_Dir=$BO_Home/activation/Python
[[ ! -d "${_Dir}" ]] && echo "FATAL: Missing directory '${_Dir}'" && return 1

_Script=${_Dir}/configure_output
[[ ! -f "${_Script}" ]] && \
  echo "FATAL: Missing script '${_Script}'" && \
  return 1
source ${_Script}

# Configure PIP_DOWNLOAD_CACHE
if [[ -z "$PIP_DOWNLOAD_CACHE" ]]; then
  echo 'WARN: Missing $PIP_DOWNLOAD_CACHE'
  [[ -z "$PIP_DOWNLOAD_CACHE" ]] && [[ -n "$TMPDIR" ]] && export PIP_DOWNLOAD_CACHE="$TMPDIR/pip"
  [[ -z "$PIP_DOWNLOAD_CACHE" ]] && echo 'FATAL: Missing $PIP_DOWNLOAD_CACHE' && return 1
  echo "INFO: Remembering PIP_DOWNLOAD_CACHE='$PIP_DOWNLOAD_CACHE'"
fi
[[ ! -d "$PIP_DOWNLOAD_CACHE" ]] && mkdir -p "$PIP_DOWNLOAD_CACHE"
[[ ! -d "$PIP_DOWNLOAD_CACHE" ]] && echo "FATAL: Missing directory '$PIP_DOWNLOAD_CACHE'" && return 1

_Script=${_Dir}/configure_virtualenv
[[ ! -f "${_Script}" ]] && \
  echo "FATAL: Missing script '${_Script}'" && \
  return 1
# source ${_Script}

# Return, but do NOT exit, with a success code
return 0

: <<'DisabledContent'
DisabledContent

