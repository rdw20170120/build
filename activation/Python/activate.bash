#!/bin/bash
echo "TRACE: Executing '$BASH_SOURCE'"

###################################################################################################
# Verify pre-conditions

[[   -z "$BO_Home"        ]] && echo 'FATAL: Missing $BO_Home'                && return 63
[[ ! -d "$BO_Home"        ]] && echo "FATAL: Missing directory '$BO_Home'"    && return 63
[[   -z "$BO_Project"     ]] && echo 'FATAL: Missing $BO_Project'             && return 63
[[ ! -d "$BO_Project"     ]] && echo "FATAL: Missing directory '$BO_Project'" && return 63
[[   -z "$BO_HomePackage" ]] && echo 'FATAL: Missing $BO_HomePackage'         && return 63
[[   -z "$BO_PathSystem"  ]] && echo 'FATAL: Missing $BO_PathSystem'          && return 63

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
# Configure environment for Python on Linux

_DirPVE=$BO_Project/PVE
export BO_PathProject=$BO_Project/bin/Linux:${_DirPVE}/bin
export BO_PathPython=$BO_Home/invocation/Python

PATH=${BO_PathProject}
PATH=$PATH:${BO_PathPython}
PATH=$PATH:${BO_PathLinux}
PATH=$PATH:${BO_PathSystem}
export PATH

###################################################################################################
# Configure PIP_DOWNLOAD_CACHE

if [[ -z "$PIP_DOWNLOAD_CACHE" ]]; then
  echo 'WARN: Missing $PIP_DOWNLOAD_CACHE'
  [[ -z "$PIP_DOWNLOAD_CACHE" ]] && [[ -n "$TMPDIR" ]] && export PIP_DOWNLOAD_CACHE="$TMPDIR/pip"
  [[ -z "$PIP_DOWNLOAD_CACHE" ]] && echo 'FATAL: Missing $PIP_DOWNLOAD_CACHE' && return 63
  echo "INFO: Remembering PIP_DOWNLOAD_CACHE='$PIP_DOWNLOAD_CACHE'"
fi
[[ ! -d "$PIP_DOWNLOAD_CACHE" ]] && mkdir -p "$PIP_DOWNLOAD_CACHE"
[[ ! -d "$PIP_DOWNLOAD_CACHE" ]] && echo "FATAL: Missing directory '$PIP_DOWNLOAD_CACHE'" && return 63

###################################################################################################
# Configure Python virtual environment (PVE)

export PIP_REQUIRE_VIRTUALENV=true
export PIP_RESPECT_VIRTUALENV=true

_Script=${_DirPVE}/bin/activate
if [[ ! -f "${_Script}" ]]; then
  # If the virtual environment does not already exist, create it
  # TODO: This code assumes that the Python virtual environment package is
  # already installed, but it may not be.  Eventually we should handle that,
  # either with a more-specific message or by actually installing it.
  echo "WARN: Creating Python virtual environment (PVE) in '${_DirPVE}'"
  echo "WARN: This requires the 'python-virtualenv' package to have been installed"
  virtualenv "${_DirPVE}"
  _ExitCode=$?
  [[ ${_ExitCode} -ne 0 ]] && echo "FATAL: Exit code ${_ExitCode} at '$BASH_SOURCE':$LINENO" && return ${_ExitCode}
fi

[[ ! -d "${_DirPVE}" ]] && echo "FATAL: Missing directory '${_DirPVE}'" && return 63
[[ ! -f "${_Script}" ]] && echo "FATAL: Missing script '${_Script}'" && return 63

source ${_Script}

_ExitCode=$?
[[ ${_ExitCode} -ne 0 ]] && echo "FATAL: Exit code ${_ExitCode} at '$BASH_SOURCE':$LINENO" && return ${_ExitCode}

[[ -z "$VIRTUAL_ENV" ]] && echo 'FATAL: Missing $VIRTUAL_ENV' && return 63
export PYTHONHOME=$VIRTUAL_ENV
[[ -z "$PYTHONHOME"  ]] && echo 'FATAL: Missing $PYTHONHOME'  && return 63

echo "INFO: Activated Python virtual environment (PVE) in '${_DirPVE}'"
echo "INFO: Found '$(python --version 2>&1)' at '$(which python)'"

###################################################################################################
# Return, but do NOT exit, with a success code
return "$BO_E_Ok"

###################################################################################################
: <<'DisabledContent'
DisabledContent

