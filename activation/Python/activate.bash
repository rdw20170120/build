#!/bin/bash
# NOTE: This script must NOT be 'source'd into a user shell since it might 'exit'
# NOTE: This script MUST be 'source'd from other scripts
echo 'INFO: BriteOnyx is activating Python for this project...'

[[   -z "$BO_Home"    ]] && echo 'FATAL: Missing $BO_Home'                && exit 1
[[ ! -d "$BO_Home"    ]] && echo "FATAL: Missing directory '$BO_Home'"    && exit 1
[[   -z "$BO_Project" ]] && echo 'FATAL: Missing $BO_Project'             && exit 1
[[ ! -d "$BO_Project" ]] && echo "FATAL: Missing directory '$BO_Project'" && exit 1

# Configure environment for Linux
_Dir=$BO_Home/activation/Linux
[[ ! -d "${_Dir}" ]] && echo "FATAL: Missing directory '${_Dir}'" && exit 1
source ${_Dir}/activate.bash
[[ $? -ne 0 ]] && echo 'FATAL: Aborting' && exit 1

# Configure environment for Python on Linux
requireVariable BO_Home
requireVariable BO_Project

_Dir=$BO_Home/activation/Python
requireDirectory ${_Dir}

source ${_Dir}/configure_TMPDIR
abortOnFail "$?"
source ${_Dir}/configure_output
abortOnFail "$?"
source ${_Dir}/configure_pip
abortOnFail "$?"
source ${_Dir}/configure_virtualenv
abortOnFail "$?"
source ${_Dir}/configure_PATH
abortOnFail "$?"

# Return, but do NOT exit, with a success code
logInfo "BriteOnyx has activated Python for project '$BO_Project'."
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

