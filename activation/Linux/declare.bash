#!/bin/bash
echo "TRACE: Executing '$BASH_SOURCE'"

[[ -z "$BO_Home" ]] && echo 'FATAL: Missing $BO_Home' && return 64 

_Dir="$BO_Home/activation/Linux"
[[ ! -d "${_Dir}" ]] && echo "FATAL: Missing directory '${_Dir}'" && return 64

_Script="${_Dir}/declare-exit.bash"
[[ ! -f "${_Script}" ]] && \
  echo "FATAL: Missing script '${_Script}'" && \
  return 64
source "${_Script}"
_ExitCode=$?
[[ ${_ExitCode} -ne 0 ]] && \
  echo "FATAL: Exit code ${_ExitCode} at '$BASH_SOURCE':$LINENO" && \
  return ${_ExitCode}

[[ -z "$BO_E_Config"      ]] && echo 'FATAL: Missing $BO_E_Config'      && return 64
[[ -z "$BO_E_Ok"          ]] && echo 'FATAL: Missing $BO_E_Ok'          && return "$BO_E_Config"
[[ -z "$BO_E_Unavailable" ]] && echo 'FATAL: Missing $BO_E_Unavailable' && return "$BO_E_Config"

_Script="${_Dir}/declare-logging.bash"
[[ ! -f "${_Script}" ]] && \
  echo "FATAL: Missing script '${_Script}'" && \
  return "$BO_E_Unavailable"
source "${_Script}"
_ExitCode=$?
[[ ${_ExitCode} -ne 0 ]] && \
  echo "FATAL: Exit code ${_ExitCode} at '$BASH_SOURCE':$LINENO" && \
  return ${_ExitCode}

_Script="${_Dir}/declare-abort.bash"
[[ ! -f "${_Script}" ]] && \
  echo "FATAL: Missing script '${_Script}'" && \
  return "$BO_E_Unavailable"
source "${_Script}"
_ExitCode=$?
[[ ${_ExitCode} -ne 0 ]] && \
  echo "FATAL: Exit code ${_ExitCode} at '$BASH_SOURCE':$LINENO" && \
  return ${_ExitCode}

_Script="${_Dir}/declare-BASH.bash"
[[ ! -f "${_Script}" ]] && \
  echo "FATAL: Missing script '${_Script}'" && \
  return "$BO_E_Unavailable"
source "${_Script}"
_ExitCode=$?
[[ ${_ExitCode} -ne 0 ]] && \
  echo "FATAL: Exit code ${_ExitCode} at '$BASH_SOURCE':$LINENO" && \
  return ${_ExitCode}

_Script="${_Dir}/declare-POSIX.bash"
[[ ! -f "${_Script}" ]] && \
  echo "FATAL: Missing script '${_Script}'" && \
  return "$BO_E_Unavailable"
source "${_Script}"
_ExitCode=$?
[[ ${_ExitCode} -ne 0 ]] && \
  echo "FATAL: Exit code ${_ExitCode} at '$BASH_SOURCE':$LINENO" && \
  return ${_ExitCode}

# Return, but do NOT exit, with a success code
return "$BO_E_Ok"

: <<'DisabledContent'
DisabledContent

