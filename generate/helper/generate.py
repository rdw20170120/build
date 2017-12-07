#!/usr/bin/env python

import argparse
import os
import sys

from bash_script import BashScript
from bash_script import VISITOR_MAP
from logging import getLogger
from my_logging import configure_logging
from my_system import maybe_create_directory
from my_system import recreate_directory
from renderer import Renderer

LOG = getLogger('generate')


def _abort_if_activated(script):
    script.add_blank_line()
    script.add_rule()
    script.add_note('ABORT: if project is already activated')
    script.add_text('[[ -n "$BO_Project" ]] &&')
    script.add_text(''' echo "FATAL: Project '$BO_Project' is already activated, aborting" &&''')
    script.add_line(' exit 100')

def _activate_for_linux(script):
    script.add_blank_line()
    script.add_rule()
    script.add_comment('Activate as a Linux project')
    script.add_blank_line()
    script.add_line('Script="$BO_Home/helper/activation/activate.src"')
    script.add_line('boScriptRequire "$Script" || boFailed "$0" "$LINENO" $? || return $?')
    script.add_line('source          "$Script" || boFailed "$0" "$LINENO" $? || return $?')

def _add_activation_comments(script):
    script.add_note("We MUST NOT EVER 'exit' during BriteOnyx bootstrap or activation")
    script.add_rule()
    script.add_debugging_comment()
    script.add_someday('Add inverse commands to isolate debugging')
    script.add_blank_line()
    script.add_rule()
    script.add_comment('Activate the BriteOnyx framework to manage this project directory tree')
    script.add_blank_comment()
    script.add_note("This script, and EVERY script that it calls, must NOT invoke 'exit'!  The user calling this")
    script.add_comment('  script must be allowed to preserve their shell and every effort must be made to inform the user')
    script.add_comment('  of problems while continuing execution where possible.  Terminating the shell robs the user of')
    script.add_comment("  useful feedback and interrupts their work, which is unacceptable.  Instead, the BASH 'return'")
    script.add_comment('  statement should be invoked to end execution with an appropriate status code.')
    script.add_blank_comment()
    script.add_someday('Verify that $BO_Project does indeed point to the root of our project directory tree')

def _capture_incoming_environment(script):
    script.add_blank_line()
    script.add_comment('Capture incoming BASH environment')
    script.add_line('if [[ -n "$TMPDIR" ]] ; then')
    script.add_line('  env | sort >$TMPDIR/BO-env-incoming.out')
    script.add_line('elif [[ -n "$BO_Project" ]] ; then')
    script.add_line('  env | sort >$BO_Project/BO-env-incoming.out')
    script.add_line('else')
    script.add_line('  env | sort >$PWD/BO-env-incoming.out')
    script.add_line('fi')

def _capture_outgoing_environment(script):
    script.add_blank_line()
    script.add_comment('Capture outgoing BASH environment')
    script.add_line('if [[ -n "$TMPDIR" ]] ; then')
    script.add_line('  env | sort >$TMPDIR/BO-env-outgoing.out')
    script.add_line('elif [[ -n "$BO_Project" ]] ; then')
    script.add_line('  env | sort >$BO_Project/BO-env-outgoing.out')
    script.add_line('else')
    script.add_line('  env | sort >$PWD/BO-env-outgoing.out')
    script.add_line('fi')

def _configure_for_briteonyx(script):
    script.add_blank_line()
    script.add_rule()
    script.add_comment('Configure for BriteOnyx')
    script.add_blank_line()
    script.add_line('Script="$BO_Project/BriteOnyx/env.src"')
    script.add_line('boScriptRequire "$Script" || boFailed "$0" "$LINENO" $? || return $?')
    script.add_line('source          "$Script" || boFailed "$0" "$LINENO" $? || return $?')

def _configure_for_project(script):
    script.add_blank_line()
    script.add_rule()
    script.add_comment('Configure for this project')
    script.add_blank_line()
    script.add_line('Script=$BO_Project/env.src')
    script.add_line('boScriptRequire $Script || boFailed "$0" "$LINENO" $? || return $?')
    script.add_line('source          $Script || boFailed "$0" "$LINENO" $? || return $?')

def _configure_for_user(script):
    script.add_blank_line()
    script.add_rule()
    script.add_comment('Configure for this user')
    script.add_blank_line()
    script.add_line('Script=$HOME/.BriteOnyx.src')
    script.add_line('boScriptRequire "$Script" || boFailed "$0" "$LINENO" $? || return $?')
    script.add_line('source          "$Script" || boFailed "$0" "$LINENO" $? || return $?')

def _copy_starter_files(script):
    script.add_blank_line()
    script.add_rule()
    script.add_comment('Copy starter files into place as necessary')
    script.add_blank_line()
    script.add_line('DirSrc=$BO_Project/BriteOnyx/starter')
    script.add_blank_line()
    script.add_line('boVariableRequire HOME')
    script.add_line('DirTgt=$HOME')
    script.add_line('[[ ! -e "$DirTgt" ]] && mkdir -p $DirTgt')
    script.add_blank_line()
    script.add_line('FileTgt=$DirTgt/.BriteOnyx.src')
    script.add_comment('Move previous scripts to new path')
    script.add_line('[[   -f $DirTgt/BriteOnyx.src      ]] && mv $DirTgt/BriteOnyx.src      $FileTgt')
    script.add_line('[[   -f $DirTgt/BriteOnyx-env.bash ]] && mv $DirTgt/BriteOnyx-env.bash $FileTgt')
    script.add_line('[[   -f $DirTgt/BriteOnyx-env.src  ]] && mv $DirTgt/BriteOnyx-env.src  $FileTgt')
    script.add_comment('Copy starter script, if necessary')
    script.add_line('[[ ! -f $FileTgt ]] && cp $DirSrc/user-BriteOnyx.src $FileTgt')
    script.add_blank_line()
    script.add_line('DirTgt=$BO_Project')
    script.add_line('[[ ! -e "$DirTgt" ]] && mkdir -p $DirTgt')
    script.add_blank_line()
    script.add_line('FileTgt=$DirTgt/env.src')
    script.add_line('[[ ! -f $FileTgt ]] && cp $DirSrc/project-env.src $FileTgt')
    script.add_blank_line()
    script.add_line('FileTgt=$DirTgt/.hgignore')
    script.add_line('[[ ! -f $FileTgt ]] && cp $DirSrc/project.hgignore $FileTgt')
    script.add_blank_line()
    script.add_line('DirTgt=$BO_Project/bin')
    script.add_line('[[ ! -e "$DirTgt" ]] && mkdir -p $DirTgt')
    script.add_blank_line()
    script.add_line('FileTgt=$DirTgt/project-fix-permissions.bash')
    script.add_comment('Move previous scripts to new path')
    script.add_line('[[   -f $DirTgt/all-fix-permissions.bash ]] && mv $DirTgt/all-fix-permissions.bash $FileTgt')
    script.add_comment('Copy starter script, if necessary')
    script.add_line('[[ ! -f $FileTgt ]] && cp $DirSrc/project-fix-permissions.bash $FileTgt')
    script.add_blank_line()
    script.add_line(": <<'DisabledContent'")
    script.add_line('FileTgt=$DirTgt/declare.src')
    script.add_line('[[ ! -f $FileTgt ]] && cp $DirSrc/project-declare.src $FileTgt')
    script.add_blank_line()
    script.add_line('FileTgt=$DirTgt/development.rst')
    script.add_line('[[ ! -f $FileTgt ]] && cp $DirSrc/project-development.rst $FileTgt')
    script.add_blank_line()
    script.add_line('FileTgt=$DirTgt/README.rst')
    script.add_line('[[ ! -f $FileTgt ]] && cp $DirSrc/project-README.rst $FileTgt')
    script.add_blank_line()
    script.add_line('DirTgt=$BO_Project/bin/helper/Linux')
    script.add_line('[[ ! -e $DirTgt ]] && mkdir -p $DirTgt')
    script.add_blank_line()
    script.add_line('FileTgt=$DirTgt/declare-BASH.src')
    script.add_line('[[ ! -f $FileTgt ]] && cp $DirSrc/project-declare-BASH.src $FileTgt')
    script.add_line('DisabledContent')

def _create_random_tmpdir(script):
    script.add_blank_line()
    script.add_comment('Create random TMPDIR')
    script.add_line('Dir=$(mktemp --tmpdir -d BO-XXXXXXXX)')
    script.add_line('[[ -d "$Dir" ]] && export TMPDIR=$Dir')

def _declare_for_bootstrap(script):
    script.add_blank_line()
    script.add_rule()
    script.add_comment('Declare BriteOnyx support functionality')
    script.add_blank_line()
    script.add_line('Script="$BO_Project/BriteOnyx/declare.src"')
    script.add_line('''[[ ! -f "$Script" ]] && echo "FATAL: Missing script '$Script'" && return 63''')
    script.add_line('source "$Script" ; Status=$?')
    script.add_line('''[[ "${Status}" -ne 0 ]] && echo "FATAL: Script exited with '${Status}'" && return ${Status}''')
    script.add_blank_line()
    script.add_rule()
    script.add_note('Now that we have our support functionality declared, we can use it from here on')

def _declare_for_project(script):
    script.add_blank_line()
    script.add_rule()
    script.add_comment('Declare optional project functionality')
    script.add_blank_line()
    script.add_line('Script="$BO_Project/declare.src"')
    script.add_line('if [[ -f "$Script" ]] ; then')
    script.add_line('  source "$Script" ; Status=$?')
    script.add_line('''  [[ "${Status}" -ne 0 ]] && echo "FATAL: Script exited with '${Status}'" && return ${Status}''')
    script.add_line('fi')

def _demonstrate_logging(script):
    script.add_blank_line()
    script.add_rule()
    script.add_comment('Demonstrate logging')
    script.add_blank_line()
    script.add_line('logDebug  "EXAMPLE: This is a debugging message"')
    script.add_line('logInfo   "EXAMPLE: This is an informational message"')
    script.add_line('logWarn   "EXAMPLE: This is a warning message"')
    script.add_line('logError  "EXAMPLE: This is an error message"')
    script.add_line('_logFatal "EXAMPLE: This is a fatal message"')

def _generate(script, target_directory, target_file):
    Renderer(VISITOR_MAP).render(script, os.path.join(target_directory, target_file))

def _generate_activate(script, target_directory, target_file):
    script.add_source_header()
    _add_activation_comments(script)
    _abort_if_activated(script)
    _create_random_tmpdir(script)
    _initialize_logging_file(script)
    _capture_incoming_environment(script)
    _remember_project_root(script)
    _declare_for_bootstrap(script)
    _normalize_reference_to_project_root(script)
    _copy_starter_files(script)
    _configure_for_user(script)
    _configure_for_project(script)
    _configure_for_briteonyx(script)
    _verify_bootstrap(script)
    _remember_path(script)
    _activate_for_linux(script)
    _set_tmpdir(script)
    _declare_for_project(script)
    _demonstrate_logging(script)
    _shutdown(script)
    script.add_disabled_content_footer()
    _generate(script, target_directory, target_file)

def _generate_activate_gradle(script, target_directory, target_file):
    script.add_text('''#!/bin/cat
[[ -n "$BO_Trace" ]] && echo "TRACE: Executing '$BASH_SOURCE'"
####################################################################################################
# NOTE: We MUST NOT EVER 'exit' during BriteOnyx bootstrap or activation
####################################################################################################
# NOTE: Uncomment the following two lines for debugging
# set -o verbose
# set -o xtrace
# TODO: SOMEDAY: Add inverse commands to isolate debugging

####################################################################################################
# Verify pre-conditions

[[   -z "$BO_Home"          ]] && echo 'FATAL: Missing $BO_Home'                && return 63
[[ ! -d "$BO_Home"          ]] && echo "FATAL: Missing directory '$BO_Home'"    && return 63
[[   -z "$BO_Project"       ]] && echo 'FATAL: Missing $BO_Project'             && return 63
[[ ! -d "$BO_Project"       ]] && echo "FATAL: Missing directory '$BO_Project'" && return 63
[[   -z "$BO_GradleVersion" ]] && echo 'FATAL: Missing $BO_GradleVersion'       && return 63
[[   -z "$BO_PathSystem"    ]] && echo 'FATAL: Missing $BO_PathSystem'          && return 63
[[   -z "$JAVA_HOME"        ]] && echo 'FATAL: Missing $JAVA_HOME'              && return 63

Dir=$BO_Home/activation
[[ ! -d "${Dir}" ]] && echo "FATAL: Missing directory '${Dir}'" && return 63

####################################################################################################
# Configure environment for Linux

Script=${Dir}/activate.src
[[ ! -f "${Script}" ]] && echo "FATAL: Missing script '${Script}'" && return 63

source ${Script}

Status=$?
[[ ${Status} -ne 0 ]] && echo "FATAL: Exit code ${Status} at '$0':$LINENO" && return ${Status}

####################################################################################################
# Verify post-conditions

[[ -z "$BO_E_Config"  ]] && echo 'FATAL: Missing $BO_E_Config'  && return 63
[[ -z "$BO_E_Ok"      ]] && echo 'FATAL: Missing $BO_E_Ok'      && return "$BO_E_Config"
[[ -z "$BO_PathLinux" ]] && echo 'FATAL: Missing $BO_PathLinux' && return "$BO_E_Config"

####################################################################################################
# Configure environment for Gradle on Linux

export BO_PathGradle=$JAVA_HOME/bin

PATH=${BO_PathProject}
PATH=$PATH:${BO_PathGradle}
PATH=$PATH:${BO_PathLinux}
PATH=$PATH:${BO_PathSystem}
export PATH

####################################################################################################
: <<'DisabledContent'
DisabledContent''')
    _generate(script, target_directory, target_file)

def _generate_activate_linux(script, target_directory, target_file):
    script.add_text('''#!/bin/cat
[[ -n "$BO_Trace" ]] && echo "TRACE: Executing '$BASH_SOURCE'"
####################################################################################################
# NOTE: We MUST NOT EVER 'exit' during BriteOnyx bootstrap or activation
####################################################################################################
# NOTE: Uncomment the following two lines for debugging
# set -o verbose
# set -o xtrace
# TODO: SOMEDAY: Add inverse commands to isolate debugging

####################################################################################################
# Verify pre-conditions

[[   -z "$BO_Home"       ]] && echo 'FATAL: Missing $BO_Home'                && return 63
[[ ! -d "$BO_Home"       ]] && echo "FATAL: Missing directory '$BO_Home'"    && return 63
[[   -z "$BO_Project"    ]] && echo 'FATAL: Missing $BO_Project'             && return 63
[[ ! -d "$BO_Project"    ]] && echo "FATAL: Missing directory '$BO_Project'" && return 63
[[   -z "$BO_PathSystem" ]] && echo 'FATAL: Missing $BO_PathSystem'          && return 63

Dir="$BO_Home/helper/activation"
[[ ! -d "${Dir}" ]] && echo "FATAL: Missing directory '${Dir}'" && return 63

####################################################################################################
# Configure Linux environment

Script="${Dir}/declare.src"
[[ ! -f "${Script}" ]] && echo "FATAL: Missing script '${Script}'" && return 63

source "${Script}"

Status=$?
[[ ${Status} -ne 0 ]] && echo "FATAL: Exit code ${Status} at '$0':$LINENO" && return ${Status}

####################################################################################################
# Verify post-conditions

[[ -z "$BO_E_Config" ]] && echo 'FATAL: Missing $BO_E_Config' && return 63
[[ -z "$BO_E_Ok"     ]] && echo 'FATAL: Missing $BO_E_Ok'     && return "$BO_E_Config"

####################################################################################################
# Configure PATH

export BO_PathLinux="$BO_Home/helper/invocation"
export BO_PathProject="$BO_Project/bin"

PATH="${BO_PathProject}"
PATH="$PATH:${BO_PathLinux}"
PATH="$PATH:${BO_PathSystem}"
export PATH

####################################################################################################
# Configure TMPDIR

if [[ -z "$TMPDIR" ]]; then
  echo 'WARN:  Missing $TMPDIR'
  [[ -z "$TMPDIR" ]] && [[ -n "$HOME"     ]] && export TMPDIR="$HOME/tmp"
  [[ -z "$TMPDIR" ]] && [[ -d /tmp ]] && [[ -n "$USER"     ]] && export TMPDIR="/tmp/$USER"
  [[ -z "$TMPDIR" ]] && [[ -d /tmp ]] && [[ -n "$USERNAME" ]] && export TMPDIR="/tmp/$USERNAME"
  [[ -z "$TMPDIR" ]] && echo 'FATAL: Missing $TMPDIR' && return 63
  # TODO: return "$BO_E_Config"
fi
export TMPDIR=$TMPDIR/$BO_ProjectName
echo "INFO:  Remembering TMPDIR='$TMPDIR'"
[[ ! -d "$TMPDIR" ]] && mkdir -p "$TMPDIR" && echo "INFO:  Created '$TMPDIR'"
[[ ! -d "$TMPDIR" ]] && echo "FATAL: Missing directory '$TMPDIR'" && return 63
# TODO: return "$BO_E_Config"

####################################################################################################
# Define common aliases

alias ignored='hg status --ignored | grep -v work-in-progress | grep -v wip'
alias someday='grep -Einrw TODO . --include=*.bash --include=*.src --include=*.txt | sort | grep -v work-in-progress'
alias todo='grep -Einrw TODO . --include=*.bash --include=*.src --include=*.txt | sort | grep -v work-in-progress | grep -v SOMEDAY'

####################################################################################################
: <<'DisabledContent'
DisabledContent''')
    _generate(script, target_directory, target_file)

def _generate_activate_python(script, target_directory, target_file):
    script.add_text('''#!/bin/cat
[[ -n "$BO_Trace" ]] && echo "TRACE: Executing '$BASH_SOURCE'"
####################################################################################################
# NOTE: We MUST NOT EVER 'exit' during BriteOnyx bootstrap or activation
####################################################################################################
# NOTE: Uncomment the following two lines for debugging
# set -o verbose
# set -o xtrace
# TODO: SOMEDAY: Add inverse commands to isolate debugging

####################################################################################################
# Verify pre-conditions

[[   -z "$BO_Home"        ]] && echo 'FATAL: Missing $BO_Home'                && return 63
[[ ! -d "$BO_Home"        ]] && echo "FATAL: Missing directory '$BO_Home'"    && return 63
[[   -z "$BO_Project"     ]] && echo 'FATAL: Missing $BO_Project'             && return 63
[[ ! -d "$BO_Project"     ]] && echo "FATAL: Missing directory '$BO_Project'" && return 63
[[   -z "$BO_HomePackage" ]] && echo 'FATAL: Missing $BO_HomePackage'         && return 63
[[   -z "$BO_PathSystem"  ]] && echo 'FATAL: Missing $BO_PathSystem'          && return 63

Dir=$BO_Home/activation
[[ ! -d "${Dir}" ]] && echo "FATAL: Missing directory '${Dir}'" && return 63

####################################################################################################
# Configure environment for Linux

Script=${Dir}/activate.src
[[ ! -f "${Script}" ]] && echo "FATAL: Missing script '${Script}'" && return 63

source ${Script}

Status=$?
[[ ${Status} -ne 0 ]] && echo "FATAL: Exit code ${Status} at '$0':$LINENO" && return ${Status}

####################################################################################################
# Verify post-conditions

[[ -z "$BO_E_Config"  ]] && echo 'FATAL: Missing $BO_E_Config'  && return 63
[[ -z "$BO_E_Ok"      ]] && echo 'FATAL: Missing $BO_E_Ok'      && return "$BO_E_Config"
[[ -z "$BO_PathLinux" ]] && echo 'FATAL: Missing $BO_PathLinux' && return "$BO_E_Config"

####################################################################################################
# Configure environment for Python on Linux

DirPVE=$BO_Project/PVE
export BO_PathProject=$BO_PathProject:${DirPVE}/bin
export BO_PathPython=$BO_Home/invocation/Python

PATH=${BO_PathProject}
PATH=$PATH:${BO_PathPython}
PATH=$PATH:${BO_PathLinux}
PATH=$PATH:${BO_PathSystem}
export PATH

####################################################################################################
# Configure PIP_DOWNLOAD_CACHE

if [[ -z "$PIP_DOWNLOAD_CACHE" ]]; then
  echo 'WARN: Missing $PIP_DOWNLOAD_CACHE'
  [[ -z "$PIP_DOWNLOAD_CACHE" ]] && [[ -n "$TMPDIR" ]] && export PIP_DOWNLOAD_CACHE="$TMPDIR/pip"
  [[ -z "$PIP_DOWNLOAD_CACHE" ]] && echo 'FATAL: Missing $PIP_DOWNLOAD_CACHE' && return 63
  echo "INFO: Remembering PIP_DOWNLOAD_CACHE='$PIP_DOWNLOAD_CACHE'"
fi
[[ ! -d "$PIP_DOWNLOAD_CACHE" ]] && mkdir -p "$PIP_DOWNLOAD_CACHE"
[[ ! -d "$PIP_DOWNLOAD_CACHE" ]] && echo "FATAL: Missing directory '$PIP_DOWNLOAD_CACHE'" && return 63

####################################################################################################
# Configure Python virtual environment (PVE)

export PIP_REQUIRE_VIRTUALENV=true
export PIP_RESPECT_VIRTUALENV=true

Script=${DirPVE}/bin/activate
if [[ ! -f "${Script}" ]]; then
  # If the virtual environment does not already exist, create it
  # TODO: This code assumes that the Python virtual environment package is
  # already installed, but it may not be.  Eventually we should handle that,
  # either with a more-specific message or by actually installing it.
  echo "WARN: Creating Python virtual environment (PVE) in '${DirPVE}'"
  echo "WARN: This requires the 'python-virtualenv' package to have been installed"
  virtualenv "${DirPVE}"
  Status=$?
  [[ ${Status} -ne 0 ]] && echo "FATAL: Exit code ${Status} at '$0':$LINENO" && return ${Status}
fi

[[ ! -d "${DirPVE}" ]] && echo "FATAL: Missing directory '${DirPVE}'" && return 63
[[ ! -f "${Script}" ]] && echo "FATAL: Missing script '${Script}'" && return 63

source ${Script}

Status=$?
[[ ${Status} -ne 0 ]] && echo "FATAL: Exit code ${Status} at '$0':$LINENO" && return ${Status}

[[ -z "$VIRTUAL_ENV" ]] && echo 'FATAL: Missing $VIRTUAL_ENV' && return 63
export PYTHONHOME=$VIRTUAL_ENV
[[ -z "$PYTHONHOME"  ]] && echo 'FATAL: Missing $PYTHONHOME'  && return 63

echo "INFO: Activated Python virtual environment (PVE) in '${DirPVE}'"
echo "INFO: Found '$(python --version 2>&1)' at '$(which python)'"

####################################################################################################
: <<'DisabledContent'
DisabledContent''')
    _generate(script, target_directory, target_file)

def _generate_bootstrap(script, target_directory, target_file):
    script.add_text('''#!/bin/cat
[[ -n "$BO_Trace" ]] && echo "TRACE: Executing '$BASH_SOURCE'"
####################################################################################################
# NOTE: By convention, BriteOnyx is configured via environment variables prefixed by 'BO_'.

boVariableRequire 'BO_Project' || boFailed "$0" "$LINENO" $? || return $?

####################################################################################################
# Copy starter files into place as necessary

DirSrc=$BO_Project/BriteOnyx/starter
DirTgt=$BO_Project

[[ ! -f $DirTgt/.hgignore ]] && cp $DirSrc/project.hgignore $DirTgt/sample.hgignore

FileTgt=$DirTgt/declare.src
[[ ! -f $FileTgt ]] && cp $DirSrc/project-declare.src $FileTgt

FileTgt=$DirTgt/development.rst
[[ ! -f $FileTgt ]] && cp $DirSrc/project-development.rst $FileTgt

FileTgt=$DirTgt/env.src
[[ ! -f $FileTgt ]] && cp $DirSrc/project-env.src $FileTgt

FileTgt=$DirTgt/README.rst
[[ ! -f $FileTgt ]] && cp $DirSrc/project-README.rst $FileTgt

DirTgt=$BO_Project/bin
FileTgt=$DirTgt/all-fix-permissions.bash
[[ ! -f $FileTgt ]] && cp $DirSrc/project-all-fix-permissions.bash $FileTgt

DirTgt=$BO_Project/bin/helper/Linux
[[ ! -e $DirTgt ]] && mkdir -p $DirTgt
FileTgt=$DirTgt/declare-BASH.src
[[ ! -f $FileTgt ]] && cp $DirSrc/project-declare-BASH.src $FileTgt

DirTgt=$HOME
FileTgt=$DirTgt/.BriteOnyx.src
# Move previous scripts to new path
[[   -f $DirTgt/BriteOnyx-env.bash ]] && mv $DirTgt/BriteOnyx-env.bash $FileTgt
[[   -f $DirTgt/BriteOnyx-env.src  ]] && mv $DirTgt/BriteOnyx-env.src  $FileTgt
[[ ! -f $FileTgt ]] && cp $DirSrc/user-BriteOnyx.src $FileTgt

####################################################################################################
# Configure for this user

Script=$HOME/.BriteOnyx.src
boScriptRequire "$Script" || boFailed "$0" "$LINENO" $? || return $?
source          "$Script" || boFailed "$0" "$LINENO" $? || return $?

####################################################################################################
# Configure for this project

Script=$BO_Project/env.src
boScriptRequire $Script || boFailed "$0" "$LINENO" $? || return $?
source          $Script || boFailed "$0" "$LINENO" $? || return $?

####################################################################################################
# Configure for BriteOnyx

Script="$BO_Project/BriteOnyx/env.src"
boScriptRequire "$Script" || boFailed "$0" "$LINENO" $? || return $?
source          "$Script" || boFailed "$0" "$LINENO" $? || return $?

####################################################################################################
# Verify BriteOnyx bootstrap configuration

boVariableRequire 'BO_Parent'  || boFailed "$0" "$LINENO" $? || return $?
boVariableRequire 'BO_Url'     || boFailed "$0" "$LINENO" $? || return $?
boVariableRequire 'BO_Version' || boFailed "$0" "$LINENO" $? || return $?

####################################################################################################
: <<'DisabledContent'
# Checkout the BriteOnyx source

boDirectoryCreate "$BO_Parent" || boFailed "$0" "$LINENO" $? || return $?

[[ -z "$BO_Home" ]] && export BO_Home=$(boNodeCanonical "$BO_Parent/$BO_Version")
boVariableRequire 'BO_Home' || boFailed "$0" "$LINENO" $? || return $?

if boDirectoryExists "$BO_Home" ; then
  boLogDebug "Directory '$BO_Home' already exists, skipping Mercurial clone."
elif [[ "$BO_Version" == "predeployed" ]]; then
  boLogWarn "Ignoring Mercurial clone of version '$BO_Version'"
else
  boLogInfo "Cloning version '$BO_Version' from '$BO_Url' into '$BO_Home'..."
  Cmd="hg clone"
  Cmd+=" --rev $BO_Version"
  Cmd+=" $BO_Url"
  Cmd+=" $BO_Home"
  Msg="Mercurial failed to clone into directory '$BO_Home'!"
  boExecute "$Cmd" "$Msg" || boFailed "$0" "$LINENO" $? || return $?
fi

boDirectoryRequire "$BO_Home" || boFailed "$0" "$LINENO" $? || return $?

if [[ "$BO_Version" == "tip" ]]; then
  # Update Mercurial clone of 'tip' to support development of BriteOnyx framework
  boLogInfo "Updating clone of version '$BO_Version' from '$BO_Url' into '$BO_Home'..."
  cd "$BO_Home" || boFailed "$0" "$LINENO" $? || return $?
  Cmd="hg pull --update"
  Msg="Mercurial failed to update clone in directory '$BO_Home'!"
  boExecute "$Cmd" "$Msg" || boFailed "$0" "$LINENO" $? || return $?
else
  boLogDebug "BriteOnyx version '$BO_Version' should be stable, skipping update of clone."
fi
DisabledContent

####################################################################################################
: <<'DisabledContent'
DisabledContent''')
    _generate(script, target_directory, target_file)

def _generate_declare(script, target_directory, target_file):
    script.add_text('''#!/bin/cat
[[ -n "$BO_Trace" ]] && echo "TRACE: Executing '$BASH_SOURCE'"
####################################################################################################
# NOTE: Assumes this project has been activated using the BriteOnyx framework.
# NOTE: We MUST NOT EVER 'exit' during BriteOnyx bootstrap or activation
####################################################################################################
# NOTE: Uncomment the following two lines for debugging
# set -o verbose
# set -o xtrace
# TODO: SOMEDAY: Add inverse commands to isolate debugging

####################################################################################################
# Declare needed functionality to support the BriteOnyx framework
# NOTE: We use the 'bo' prefix by convention for all our BriteOnyx support functions.

####################################################################################################
# Functions in this section should NOT call functions from following sections

boLog () {
  # Log the message $1 to STDERR
  # NOTE:  Should only be called from this script
  # $1 = message
  echo -e "$1" >&2
} && export -f boLog

boNodeCanonical () {
  # Return the canonical pathname for file system node $1
  # NOTE: Must be called via command substitution, e.g.:
  #   "$(boNodeCanonical '$1')"
  [[ $# -eq 1 ]] || return 100
  # $1 = pathname of file system node
  declare Result
  # NOTE: This call to "readlink" is not supported on Apple Mac OS X, so deal with it...
  Result="$(readlink -m $1)"
  [[ $? -eq 0   ]] && echo "$Result" && return 0
  [[ "$1" = "." ]] && echo "$PWD"       && return 0
  echo "$1"
} && export -f boNodeCanonical

boTrace () {
  # Trace message $1
  # $1 = message
  [[ -n "$BO_Trace" ]] && boLog "TRACE: $1"
} && export -f boTrace

boTraceEntry () {
  # Trace the entry of execution into caller with source location name $1 and line $2 called with
  #   argument count $3 and arguments $4
  [[ $# -eq 4 ]] || return 100
  # $1 = caller source location name ($FUNCNAME or $0)
  # $2 = caller source location line ($LINENO)
  # $3 = caller argument count ($#)
  # $4 = caller arguments ($*)
  boTrace "'$1:$2' called with $3 args: '$4'"
} && export -f boTraceEntry

boTraceValue () {
  # Trace value $2 described as $1
  [[ $# -eq 2 ]] || return 100
  # $1 = description of value
  # $2 = value
  boTrace "$1 = '$2'"
} && export -f boTraceValue

boTraceVariable () {
  # Trace environment variable $1
  [[ $# -eq 1 ]] || return 100
  # $1 = name of environment variable
  declare -r Name="$1"
  declare -r Value="${!Name}"
  boTraceValue "Variable '$Name'" "$Value"
} && export -f boTraceVariable

####################################################################################################
# Functions in this section should NOT call functions from following sections

boDirectoryExists () {
  boNodeIsDirectory "$1"
} && export -f boDirectoryExists

boFileExists () {
  boNodeIsFile "$1"
} && export -f boFileExists

boNodeExists () {
  # Return whether node $1 exists
  [[ $# -eq 1 ]] || return 100
  # $1 = node pathname
  [[ -e "$1" ]]
} && export -f boNodeExists

boNodeIsDirectory () {
  # Return whether node $1 is a directory
  [[ $# -eq 1 ]] || return 100
  # $1 = node pathname
  [[ -d "$1" ]]
} && export -f boNodeIsDirectory

boNodeIsFile () {
  # Return whether node $1 is a file
  [[ $# -eq 1 ]] || return 100
  # $1 = node pathname
  [[ -f "$1" ]]
} && export -f boNodeIsFile

boVariableIsMissing () {
  # Return whether environment variable $1 is missing (undefined or empty)
  [[ $# -eq 1 ]] || return 100
  # $1 = name of environment variable
  declare -r Name="$1"
  declare -r Value="${!Name}"
  [[ -z "$Value" ]]
} && export -f boVariableIsMissing

####################################################################################################
# Functions in this section should NOT call functions from following sections

boLogDebug () {
  boLog "DEBUG: $1"
} && export -f boLogDebug

boLogError () {
  boLog "ERROR: $1"
} && export -f boLogError

boLogFatal () {
  boLog "FATAL: $1"
} && export -f boLogFatal

boLogInfo () {
  boLog "INFO:  $1"
} && export -f boLogInfo

boLogWarn () {
  boLog "WARN:  $1"
} && export -f boLogWarn

####################################################################################################
# Functions in this section should NOT call functions from following sections

boAbort () {
  boTraceEntry "$FUNCNAME" "$LINENO" $# "$*"
  # Abort execution due to previous command's status $3 while reporting fatal log message $5
  #   (including source location name $1 and line $2) and propagating outgoing status code $4
  # TODO: Rename to boFail?
  [[ $# -eq 5 ]] || return 100
  # $1 = caller source location name ($FUNCNAME or $0)
  # $2 = caller source location line ($LINENO)
  # $3 = incoming status code from previous command ($?, non-zero)
  # $4 = outgoing status code (repeat $? unless overriding)
  # $5 = message
  [[ "$3" -eq 0 ]] && return 100
  boLogFatal "ABORT: Status $3 at '$1:$2' -> status $4: $5"
  return "$4"
} && export -f boAbort

boFailed () {
  boTraceEntry "$FUNCNAME" "$LINENO" $# "$*"
  # Log failed execution due to previous command's status $3 as reported at source location name
  #   $1 and line $2, then propagate the failed status
  [[ $# -eq 3 ]] || return 100
  # $1 = caller source location name ($FUNCNAME or $0)
  # $2 = caller source location line ($LINENO)
  # $3 = incoming status code from previous command ($?, non-zero)
  [[ "$3" -eq 0 ]] && return 100
  boLogFatal "FAILED: Status $3 at '$1:$2'"
  return "$3"
} && export -f boFailed

####################################################################################################
# Functions in this section should NOT call functions from following sections

boArgsRequire () {
  boTraceEntry "$FUNCNAME" "$LINENO" $# "$*"
  # Require that the actual argument count $3 equal the expected argument count $4 in the caller
  #   with source location name $1 and line $2
  [[ $# -eq 4 ]] || return 100
  # $1 = caller source location name ($FUNCNAME or $0)
  # $2 = caller source location line ($LINENO)
  # $3 = actual argument count ($#)
  # $4 = expected argument count
  declare -r Msg="Expected $4 arguments but got $3!"
  [[ $3 -eq $4 ]] || boAbort "$1" "$2" $? 100 "$Msg" || return $?
} && export -f boArgsRequire

####################################################################################################
# Functions in this section should NOT call functions from following sections

boDirectoryCreate () {
  boTraceEntry "$FUNCNAME" "$LINENO" $# "$*"
  # Create directory $1, if it does not already exist
  boArgsRequire "$FUNCNAME" "$LINENO" $# 1 || return $?
  # $1 = directory pathname
  declare Msg="Directory '$1' already exists, skipping creation."
  boNodeIsDirectory "$1" && boLogDebug "$Msg"                            && return $?
  Msg="Unable to create directory '$1', failed!"
  mkdir -p "$1"           || boAbort "$FUNCNAME" "$LINENO" $? 100 "$Msg" || return $?
  boDirectoryRequire "$1" || boAbort "$FUNCNAME" "$LINENO" $? 100 "$Msg" || return $?
} && export -f boDirectoryCreate

boDirectoryRequire () {
  boTraceEntry "$FUNCNAME" "$LINENO" $# "$*"
  # Require directory $1, abort if it is missing
  boArgsRequire "$FUNCNAME" "$LINENO" $# 1 || return $?
  # $1 = pathname of required directory
  boNodeIsDirectory "$1" && return $?
  Msg="Directory '$1' is required but is missing!"
  boNodeExists "$1" || boAbort "$FUNCNAME" "$LINENO" $? 100 "$Msg" || return $?
  Msg="Directory '$1' is required but is blocked by a non-directory!"
  boAbort "$FUNCNAME" "$LINENO" 100 100 "$Msg" || return $?
} && export -f boDirectoryRequire

boFileRequire () {
  boTraceEntry "$FUNCNAME" "$LINENO" $# "$*"
  # Require that file $1 exists, abort if it is missing
  # TODO: Should we check other characteristics like readability or executability?
  boArgsRequire "$FUNCNAME" "$LINENO" $# 1 || return $?
  # $1 = required script file pathname
  declare -r Msg="File '$1' is required but missing!"
  boNodeIsFile "$1" || boAbort "$FUNCNAME" "$LINENO" $? 100 "$Msg" || return $?
} && export -f boFileRequire

boScriptRequire () {
  # Require that script file $1 exists, abort if it is missing
  # TODO: Should we check other characteristics like readability or executability?
  boFileRequire "$1" || boFailed "$FUNCNAME" "$LINENO" $? || return $?
} && export -f boScriptRequire

boVariableRequire () {
  boTraceEntry "$FUNCNAME" "$LINENO" $# "$*"
  # Require environment variable $1, abort if it is missing
  boArgsRequire "$FUNCNAME" "$LINENO" $# 1 || return $?
  # $1 = name of required environment variable
  declare -r Msg="Variable '$1' is required but is undefined or empty!"
  ! boVariableIsMissing "$1" || boAbort "$FUNCNAME" "$LINENO" $? 100 "$Msg" || return $?
} && export -f boVariableRequire

####################################################################################################
# Functions in this section should NOT call functions from following sections

boExecute () {
  boTraceEntry "$FUNCNAME" "$LINENO" $# "$*"
  # Execute command $1; if it fails, abort with message $2
  boArgsRequire "$FUNCNAME" "$LINENO" $# 2 || return $?
  # $1 = command to execute
  # $2 = message for abort upon failure
  boLogDebug "Executing command: $1"
  $1 || boAbort "$FUNCNAME" "$LINENO" $? $? "$2" || return $?
} && export -f boExecute

####################################################################################################
# Successfully 'return', but do NOT 'exit'
return 0

####################################################################################################
: <<'DisabledContent'
DisabledContent''')
    _generate(script, target_directory, target_file)

def _generate_environment_for_briteonyx(script, target_directory, target_file):
    script.add_text('''#!/bin/cat
[[ -n "$BO_Trace" ]] && echo "TRACE: Executing '$BASH_SOURCE'"
####################################################################################################
# Configure BriteOnyx deployment
# TODO: SOMEDAY: Keep BO_Version updated to latest published revision

[[ -z "$BO_Parent"  ]] && export BO_Parent=$HOME/.BO
[[ -z "$BO_Version" ]] && export BO_Version=rev36
[[ -z "$BO_Home"    ]] && export BO_Home=$BO_Parent/$BO_Version

alias functions='declare -F | sort'

####################################################################################################
: <<'DisabledContent'
DisabledContent''')
    _generate(script, target_directory, target_file)

def _generate_environment_for_project(script, target_directory, target_file):
    script.add_text('''#!/bin/cat
[[ -n "$BO_Trace" ]] && echo "TRACE: Executing '$BASH_SOURCE'"
####################################################################################################
# Configure this project

# TODO: Implement
export BO_ProjectName=TODO

####################################################################################################
: <<'DisabledContent'
DisabledContent''')
    _generate(script, target_directory, target_file)

def _generate_environment_for_user(script, target_directory, target_file):
    script.add_text('''#!/bin/cat
[[ -n "$BO_Trace" ]] && echo "TRACE: Executing '$BASH_SOURCE'"
####################################################################################################
# NOTE: Declare needed environment variables here

# TODO: Implement as needed, but defer to $BO_Project/BriteOnyx/env.src for now

####################################################################################################
: <<'DisabledContent'
# NOTE: Copy this content above, to override system portion of final PATH
export BO_PathSystem=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
DisabledContent''')
    _generate(script, target_directory, target_file)

def _generate_maybe_activate(script, target_directory, target_file):
    script.add_text('''#!/bin/cat
[[ -n "$BO_Trace" ]] && echo "TRACE: Executing '$BASH_SOURCE'"
####################################################################################################
# NOTE: We MUST NOT EVER 'exit' during BriteOnyx bootstrap or activation
####################################################################################################
# NOTE: Uncomment the following two lines for debugging
# set -o verbose
# set -o xtrace
# TODO: SOMEDAY: Add inverse commands to isolate debugging

####################################################################################################
# Skip if BriteOnyx is already activated

Msg='$BO_Home is defined, assuming BriteOnyx already activated'
[[ -n "$BO_Home" ]] && logDebug "$Msg" && return 0

####################################################################################################
# Activate BriteOnyx

Script="$(dirname "$0")/../activate.src"
[[ ! -f "$Script" ]] && echo "FATAL: Missing script '$Script'" && return 63
source "$Script"; Status=$?
Msg="FATAL: Status $Status at '$0:$LINENO'"
[[ $Status -ne 0 ]] && echo "$Msg" && return $Status

####################################################################################################
# Verify post-conditions

boVariableRequire   BO_Home || boFailed "$0" "$LINENO" $? || return $?
boDirectoryRequire $BO_Home || boFailed "$0" "$LINENO" $? || return $?

boVariableRequire   BO_Project || boFailed "$0" "$LINENO" $? || return $?
boDirectoryRequire $BO_Project || boFailed "$0" "$LINENO" $? || return $?

####################################################################################################
# Successfully 'return', but do NOT 'exit'
return 0

####################################################################################################
: <<'DisabledContent'
DisabledContent''')
    _generate(script, target_directory, target_file)

def _initialize_logging_file(script):
    script.add_blank_line()
    script.add_comment('Initialize BriteOnyx logging file')
    script.add_line('BO_FileLog=BO.log')
    script.add_line('if [[ -n "$TMPDIR" ]] ; then')
    script.add_line('  export BO_FileLog=$TMPDIR/$BO_FileLog')
    script.add_line('elif [[ -n "$BO_Project" ]] ; then')
    script.add_line('  export BO_FileLog=$BO_Project/$BO_FileLog')
    script.add_line('else')
    script.add_line('  export BO_FileLog=$PWD/$BO_FileLog')
    script.add_line('fi')
    script.add_line('echo "INFO:  Activating..." >$BO_FileLog')
    script.add_line('echo "INFO:  Activating the BriteOnyx framework for this project..."')
    script.add_line('''echo "WARN:  This script MUST be executed as 'source activate.src', WAS IT?"''')

def _normalize_reference_to_project_root(script):
    script.add_blank_line()
    script.add_line('''boVariableRequire 'BO_Project' || boFailed "$0" "$LINENO" $? || return $?''')
    script.add_line("boTraceVariable 'BO_Project'")
    script.add_line('export BO_Project="$(boNodeCanonical $BO_Project)"')
    script.add_line("boTraceVariable 'BO_Project'")
    script.add_line('''boLogInfo "Canonical form of BO_Project directory pathname is '$BO_Project'"''')
    script.add_line('boDirectoryRequire "$BO_Project" || boFailed "$0" "$LINENO" $? || return $?')

def _remember_path(script):
    script.add_blank_line()
    script.add_rule()
    script.add_comment('Remember PATH')
    script.add_blank_line()
    script.add_line('[[ -z "$BO_PathSystem" ]] && \\')
    script.add_line('  export BO_PathSystem=$PATH && \\')
    script.add_line('''  echo "INFO:  Remembering BO_PathSystem='$BO_PathSystem'"''')

def _remember_project_root(script):
    script.add_blank_line()
    script.add_rule()
    script.add_comment('Remember the directory containing this script as our project root')
    script.add_blank_line()
    script.add_line('export BO_Project="$(dirname $BASH_SOURCE)"')
    script.add_blank_line()
    script.add_todo('REVIEW: Shall we NOT cd into our project directory since it changes')
    script.add_line("# the caller's execution environment?")
    script.add_comment('cd "$BO_Project" || return $?')

def _set_tmpdir(script):
    script.add_blank_line()
    script.add_rule()
    script.add_comment('Set TMPDIR ')
    script.add_comment('DISABLED: MOVED: to Linux activation script')
    script.add_blank_line()
    script.add_comment('export TMPDIR=$TMPDIR/$BO_ProjectName')
    script.add_line('''# echo "INFO:  Remembering TMPDIR='$TMPDIR'"''')

def _shutdown(script):
    script.add_blank_line()
    script.add_rule()
    script.add_comment('Shutdown')
    script.add_blank_line()
    script.add_line('''logInfo "Project '$BO_ProjectName' in directory '$BO_Project' is now activated, done."''')
    _capture_outgoing_environment(script)

def _verify_bootstrap(script):
    script.add_blank_line()
    script.add_rule()
    script.add_comment('Verify BriteOnyx bootstrap configuration')
    script.add_blank_line()
    script.add_line('boVariableRequire   BO_Home || boFailed "$0" "$LINENO" $? || return $?')
    script.add_line('boDirectoryRequire $BO_Home || boFailed "$0" "$LINENO" $? || return $?')
    script.add_blank_line()
    script.add_line('boVariableRequire BO_ProjectName || boFailed "$0" "$LINENO" $? || return $?')

def main():
    try:
        configure_logging()
        LOG.debug("main() try = began")

        parser = argparse.ArgumentParser()
        parser.add_argument('source_directory', help='from which to generate output')
        parser.add_argument('target_directory', help='into which to generate output')
        args = parser.parse_args()

        LOG.info("Generating scripts from directory '{0}' into directory '{1}'".format(
            args.source_directory, args.target_directory
        ))
        recreate_directory(args.target_directory)

        directory = os.path.join(args.target_directory, 'helper', 'activation')
        maybe_create_directory(directory)
        _generate_activate_linux(BashScript(), directory, 'activate.src')

        directory = os.path.join(args.target_directory, 'helper', 'activation', 'add_on')
        maybe_create_directory(directory)
        _generate_activate_gradle(BashScript(), directory, 'activate-Gradle.src')
        _generate_activate_python(BashScript(), directory, 'activate-Python.src')

        directory = os.path.join(args.target_directory, 'sample_project')
        maybe_create_directory(directory)
        _generate_activate(BashScript(), directory, 'activate.src')

        directory = os.path.join(args.target_directory, 'sample_project', 'BriteOnyx')
        maybe_create_directory(directory)
        _generate_bootstrap(BashScript(), directory, 'bootstrap.src')
        _generate_declare(BashScript(), directory, 'declare.src')
        _generate_environment_for_briteonyx(BashScript(), directory, 'env.src')
        _generate_maybe_activate(BashScript(), directory, 'maybeActivate.src')

        directory = os.path.join(args.target_directory, 'sample_project', 'BriteOnyx', 'starter')
        maybe_create_directory(directory)
        _generate_environment_for_project(BashScript(), directory, 'project-env.src')
        _generate_environment_for_user(BashScript(), directory, 'user-BriteOnyx.src')
    except Exception as e:
        LOG.error("main() except Exception = failure")
        LOG.exception(e)
        sys.exit(1)
    else:
        LOG.debug("main() else = success")
        sys.exit(0)
    finally:
        LOG.debug("main() finally = ended")


if __name__ == '__main__':
    main()


""" Disabled content
"""

