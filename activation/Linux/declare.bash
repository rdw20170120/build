#!/bin/bash
echo "TRACE: Executing '$BASH_SOURCE'"

[[ -z "$BO_Home" ]] && echo 'FATAL: Missing $BO_Home' && return 1

_Dir=$BO_Home/activation/Linux
[[ ! -d "${_Dir}" ]] && echo "FATAL: Missing directory '${_Dir}'" && return 1

_Script=${_Dir}/declare-logging.bash
[[ ! -f "${_Script}" ]] && \
  echo "FATAL: Missing script '${_Script}'" && \
  return 1
source ${_Script}
_ExitCode=$?
[[ ${_ExitCode} -ne 0 ]] && \
  echo "FATAL: Script exited with ${_ExitCode}, aborting!" && \
  return ${_ExitCode}

_Script=${_Dir}/declare-BASH.bash
[[ ! -f "${_Script}" ]] && \
  echo "FATAL: Missing script '${_Script}'" && \
  return 1
source ${_Script}
_ExitCode=$?
[[ ${_ExitCode} -ne 0 ]] && \
  echo "FATAL: Script exited with ${_ExitCode}, aborting!" && \
  return ${_ExitCode}

_Script=${_Dir}/declare-POSIX.bash
[[ ! -f "${_Script}" ]] && \
  echo "FATAL: Missing script '${_Script}'" && \
  return 1
source ${_Script}
_ExitCode=$?
[[ ${_ExitCode} -ne 0 ]] && \
  echo "FATAL: Script exited with ${_ExitCode}, aborting!" && \
  return ${_ExitCode}

# Return, but do NOT exit, with a success code
return 1

: <<'DisabledContent'
DisabledContent

