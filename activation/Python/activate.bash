#!/bin/bash
echo "TRACE: Executing '$BASH_SOURCE'"

[[   -z "$BO_Home"    ]] && echo 'FATAL: Missing $BO_Home'                && return 1
[[ ! -d "$BO_Home"    ]] && echo "FATAL: Missing directory '$BO_Home'"    && return 1
[[   -z "$BO_Project" ]] && echo 'FATAL: Missing $BO_Project'             && return 1
[[ ! -d "$BO_Project" ]] && echo "FATAL: Missing directory '$BO_Project'" && return 1

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

_Dir=$BO_Home/activation/Python
[[ ! -d "${_Dir}" ]] && echo "FATAL: Missing directory '${_Dir}'" && return 1

_Script=${_Dir}/configure_TMPDIR
[[ ! -f "${_Script}" ]] && \
  echo "FATAL: Missing script '${_Script}'" && \
  return 1
source ${_Script}
_ExitCode=$?
[[ ${_ExitCode} -ne 0 ]] && \
  echo "FATAL: Exit code ${_ExitCode} at '$BASH_SOURCE':$LINENO" && \
  return ${_ExitCode}

_Script=${_Dir}/configure_output
[[ ! -f "${_Script}" ]] && \
  echo "FATAL: Missing script '${_Script}'" && \
  return 1
source ${_Script}
_ExitCode=$?
[[ ${_ExitCode} -ne 0 ]] && \
  echo "FATAL: Exit code ${_ExitCode} at '$BASH_SOURCE':$LINENO" && \
  return ${_ExitCode}

_Script=${_Dir}/configure_pip
[[ ! -f "${_Script}" ]] && \
  echo "FATAL: Missing script '${_Script}'" && \
  return 1
source ${_Script}
_ExitCode=$?
[[ ${_ExitCode} -ne 0 ]] && \
  echo "FATAL: Exit code ${_ExitCode} at '$BASH_SOURCE':$LINENO" && \
  return ${_ExitCode}

_Script=${_Dir}/configure_virtualenv
[[ ! -f "${_Script}" ]] && \
  echo "FATAL: Missing script '${_Script}'" && \
  return 1
source ${_Script}
_ExitCode=$?
[[ ${_ExitCode} -ne 0 ]] && \
  echo "FATAL: Exit code ${_ExitCode} at '$BASH_SOURCE':$LINENO" && \
  return ${_ExitCode}

_Script=${_Dir}/configure_PATH
[[ ! -f "${_Script}" ]] && \
  echo "FATAL: Missing script '${_Script}'" && \
  return 1
source ${_Script}
_ExitCode=$?
[[ ${_ExitCode} -ne 0 ]] && \
  echo "FATAL: Exit code ${_ExitCode} at '$BASH_SOURCE':$LINENO" && \
  return ${_ExitCode}

# Return, but do NOT exit, with a success code
return 0

: <<'DisabledContent'
# Must be first in PATH
_PathProject=$BO_Project/bin/Linux
PATH=${_PathProject}

_PathBuild=$BO_Home/bin/Linux
PATH=$PATH:${_PathBuild}

# TODO: Move to user-specific configuration file?
export BO_PathSystem=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
requireVariable BO_PathSystem
PATH=$PATH:${BO_PathSystem}

export PATH
DisabledContent
