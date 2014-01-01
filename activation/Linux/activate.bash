#!/bin/bash
echo "TRACE: Executing '$BASH_SOURCE'"
echo 'INFO: BriteOnyx is activating Linux for this project...'

[[   -z "$BO_Home"    ]] && echo 'FATAL: Missing $BO_Home'                && return 1
[[ ! -d "$BO_Home"    ]] && echo "FATAL: Missing directory '$BO_Home'"    && return 1
[[   -z "$BO_Project" ]] && echo 'FATAL: Missing $BO_Project'             && return 1
[[ ! -d "$BO_Project" ]] && echo "FATAL: Missing directory '$BO_Project'" && return 1

# Configure the Linux environment
_Dir=$BO_Home/activation/Linux
[[ ! -d "${_Dir}" ]] && echo "FATAL: Missing directory '${_Dir}'" && return 1
_Script=${_Dir}/declare.bash
[[ ! -f "${_Script}" ]] && \
  echo "FATAL: Missing script '${_Script}'" && \
  return 1
source ${_Script}
[[ $? -ne 0 ]] && echo 'FATAL: Aborting' && return 1

echo 'INFO: BriteOnyx scripting support loaded!'
# NOTE: Now we have our special BriteOnyx scripting functionality loaded, so we
#       can shift to using that rather than directly invoking BASH primitives.

# Configure environment for Gradle on Linux

# Must be first in PATH
_PathProject=$BO_Project/bin/Linux
PATH=${_PathProject}

_PathBuild=$BO_Home/bin/Linux
PATH=$PATH:${_PathBuild}

[[   -z "$BO_PathSystem" ]] && echo 'FATAL: Missing $BO_PathSystem' && return 1
PATH=$PATH:${BO_PathSystem}

export PATH

# Return, but do NOT exit, with a success code
echo "INFO: BriteOnyx has activated Linux for project '$BO_Project'."
return 0

: <<'DisabledContent'
DisabledContent

