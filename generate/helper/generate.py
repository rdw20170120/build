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

        directory = args.target_directory        
        maybe_create_directory(directory)

        _generate_activate(BashScript(), directory, 'activate.src')
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

