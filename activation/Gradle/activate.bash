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
[[ $? -ne 0 ]] && echo 'FATAL: Aborting' && return 1

# Configure environment for Gradle on Linux
_PathBuild=$BO_Home/bin/Linux
PATH=$PATH:${_PathBuild}

# TODO: Do we still require GRADLE_HOME, or drop in favor of Gradle wrapper?
# requireVariable GRADLE_HOME
# _PathGradle=$GRADLE_HOME/bin
# PATH=$PATH:${_PathGradle}

[[   -z "$JAVA_HOME" ]] && echo 'FATAL: Missing $JAVA_HOME' && return 1
_PathJava=$JAVA_HOME/bin
PATH=$PATH:${_PathJava}

[[   -z "$BO_PathSystem" ]] && echo 'FATAL: Missing $BO_PathSystem' && return 1
PATH=$PATH:${BO_PathSystem}

export PATH

# Return, but do NOT exit, with a success code
return 0

: <<'DisabledContent'
DisabledContent

