#!/bin/bash
echo 'INFO: Activating this Gradle-based project...'

# NOTE: This script should be sourced into the shell environment
# NOTE: This script, and EVERY script that it calls, must NOT invoke 'exit'!
#       The user calling this script must be allowed to preserve their shell
#       and every effort must be made to inform the user of problems while
#       continuing execution where possible.  Exiting the shell robs the user
#       of useful feedback and interrupts their work, which is unacceptable.

[[   -z "$BO_Home"    ]] && echo 'FATAL: Missing $BO_Home'                && return 1
[[ ! -d "$BO_Home"    ]] && echo "FATAL: Missing directory '$BO_Home'"    && return 1
[[   -z "$BO_Project" ]] && echo 'FATAL: Missing $BO_Project'             && return 1
[[ ! -d "$BO_Project" ]] && echo "FATAL: Missing directory '$BO_Project'" && return 1

# Configure the Linux environment
_Dir=$BO_Home/bin/Linux/helper
[[ ! -d "${_Dir}" ]] && echo "FATAL: Missing directory '${_Dir}'" && return 1
source ${_Dir}/declare.bash
[[ $? -ne 0 ]] && echo 'FATAL: Aborting' && return 1

logInfo "BriteOnyx scripting support loaded!"
# NOTE: Now we have our special BriteOnyx scripting functionality loaded, so we
#       can shift to using that rather than directly invoking BASH primitives.

# Configure the Gradle environment
logDebug 'Configuring temporary directory $TMPDIR...'
requireVariable TMPDIR  || return 1
createDirectory $TMPDIR || return 1
logDebug 'Configuring output directory...'
requireVariable BO_Project      || return 1
createDirectory $BO_Project/out || return 1
logDebug 'Configuring system execution $PATH...'
export BO_PathSystem=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
# TODO: Do we still require GRADLE_HOME, or can we drop in favor of Gradle wrapper?
# requireVariable GRADLE_HOME   || return 1
requireVariable JAVA_HOME     || return 1
requireVariable BO_Home       || return 1
requireVariable BO_PathSystem || return 1
requireVariable BO_Project    || return 1
_PathBuild=$BO_Home/bin/Linux
_PathGradle=$GRADLE_HOME/bin
_PathJava=$JAVA_HOME/bin
_PathProject=$BO_Project/bin/Linux
export PATH=${_PathProject}:${_PathBuild}:${_PathGradle}:${_PathJava}:${BO_PathSystem}

: <<'DisabledContent'
DisabledContent

# Return, but do NOT exit, with a success code
logInfo "Gradle project '$BO_Project' activated."
return 0

