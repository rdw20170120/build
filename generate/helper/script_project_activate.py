import script_bash
import script_briteonyx

from throw_out_your_templates_3_core_visitor_map import VisitorMap

from structure_bash import *
from structure_briteonyx import *


def abort_if_activated():
    return [
        line(),
        rule(),
        note('ABORT: if project is already activated'),
        '[[ -n "$BO_Project" ]]', and_(),
        echo('''"FATAL: Project '$BO_Project' is already activated, aborting"'''), and_(),
        exit(100), eol(),
    ]

def activate_for_linux():
    return [
        line(),
        rule(),
        comment('Activate as a Linux project'),
        line(),
        assign('Script', '"$BO_Home/helper/activation/activate.src"'), eol(),
        require_script('"$Script"'), or_(),
        failed(), or_(),
        return_('$?'), eol(),
        source('         "$Script"'), or_(),
        failed(), or_(),
        return_('$?'), eol(),
    ]

def comments():
    return [
        note("We MUST NOT EVER 'exit' during BriteOnyx bootstrap or activation"),
        rule(),
        debugging_comment(),
        someday('Add inverse commands to isolate debugging'),
        line(),
        rule(),
        comment('Activate the BriteOnyx framework to manage this project directory tree'),
        comment(),
        note("This script, and EVERY script that it calls, must NOT invoke 'exit'!  The user calling this"),
        comment('  script must be allowed to preserve their shell and every effort must be made to inform the user'),
        comment('  of problems while continuing execution where possible.  Terminating the shell robs the user of'),
        comment("  useful feedback and interrupts their work, which is unacceptable.  Instead, the BASH 'return'"),
        comment('  statement should be invoked to end execution with an appropriate status code.'),
        comment(),
        someday('Verify that $BO_Project does indeed point to the root of our project directory tree'),
    ]

def capture_incoming_environment():
    return [
        line(),
        comment('Capture incoming BASH environment'),
        if_('[[ -n "$TMPDIR" ]]'), seq(), then(), eol(),
        '  ', line('env | sort >$TMPDIR/BO-env-incoming.out'),
        elif_('[[ -n "$BO_Project" ]]'), seq(), then(), eol(),
        '  ', line('env | sort >$BO_Project/BO-env-incoming.out'),
        else_(), eol(),
        '  ', line('env | sort >$PWD/BO-env-incoming.out'),
        fi(), eol(),
    ]

def capture_outgoing_environment():
    return [
        line(),
        comment('Capture outgoing BASH environment'),
        if_('[[ -n "$TMPDIR" ]]'), seq(), then(), eol(),
        '  ', line('env | sort >$TMPDIR/BO-env-outgoing.out'),
        elif_('[[ -n "$BO_Project" ]]'), seq(), then(), eol(),
        '  ', line('env | sort >$BO_Project/BO-env-outgoing.out'),
        else_(), eol(),
        '  ', line('env | sort >$PWD/BO-env-outgoing.out'),
        fi(), eol(),
    ]

def configure_for_briteonyx():
    return [
        line(),
        rule(),
        comment('Configure for BriteOnyx'),
        line(),
        assign('Script', '"$BO_Project/BriteOnyx/env.src"'), eol(),
        require_script('"$Script"'), or_(),
        failed(), or_(),
        return_('$?'), eol(),
        source('         "$Script"'), or_(),
        failed(), or_(),
        return_('$?'), eol(),
    ]

def configure_for_project():
    return [
        line(),
        rule(),
        comment('Configure for this project'),
        line(),
        assign('Script', '$BO_Project/env.src'), eol(),
        require_script('$Script'), or_(),
        failed(), or_(),
        return_('$?'), eol(),
        source('         $Script'), or_(),
        failed(), or_(),
        return_('$?'), eol(),
    ]

def configure_for_user():
    return [
        line(),
        rule(),
        comment('Configure for this user'),
        line(),
        assign('Script', '$HOME/.BriteOnyx.src'), eol(),
        require_script('"$Script"'), or_(),
        failed(), or_(),
        return_('$?'), eol(),
        source('         "$Script"'), or_(),
        failed(), or_(),
        return_('$?'), eol(),
    ]

def copy_starter_files():
    return [
        line(),
        rule(),
        comment('Copy starter files into place as necessary'),
        line(),
        assign('DirSrc', '$BO_Project/BriteOnyx/starter'), eol(),
        line(),
        require_variable('HOME'), eol(),
        assign('DirTgt', '$HOME'), eol(),
        '[[ ! -e "$DirTgt" ]]', and_(),
        line('mkdir -p $DirTgt'),
        line(),
        assign('FileTgt', '$DirTgt/.BriteOnyx.src'), eol(),
        comment('Move previous scripts to new path'),
        '[[   -f $DirTgt/BriteOnyx.src      ]]', and_(),
        line('mv $DirTgt/BriteOnyx.src      $FileTgt'),
        '[[   -f $DirTgt/BriteOnyx-env.bash ]]', and_(),
        line('mv $DirTgt/BriteOnyx-env.bash $FileTgt'),
        '[[   -f $DirTgt/BriteOnyx-env.src  ]]', and_(),
        line('mv $DirTgt/BriteOnyx-env.src  $FileTgt'),
        comment('Copy starter script, if necessary'),
        '[[ ! -f $FileTgt ]]', and_(),
        line('cp $DirSrc/user-BriteOnyx.src $FileTgt'),
        line(),
        assign('DirTgt', '$BO_Project'), eol(),
        '[[ ! -e "$DirTgt" ]]', and_(),
        line('mkdir -p $DirTgt'),
        line(),
        assign('FileTgt', '$DirTgt/env.src'), eol(),
        '[[ ! -f $FileTgt ]]', and_(),
        line('cp $DirSrc/project-env.src $FileTgt'),
        line(),
        assign('FileTgt', '$DirTgt/.hgignore'), eol(),
        '[[ ! -f $FileTgt ]]', and_(),
        line('cp $DirSrc/project.hgignore $FileTgt'),
        line(),
        assign('DirTgt', '$BO_Project/bin'), eol(),
        '[[ ! -e "$DirTgt" ]]', and_(),
        line('mkdir -p $DirTgt'),
        line(),
        assign('FileTgt', '$DirTgt/project-fix-permissions.bash'), eol(),
        comment('Move previous scripts to new path'),
        '[[   -f $DirTgt/all-fix-permissions.bash ]]', and_(),
        line('mv $DirTgt/all-fix-permissions.bash $FileTgt'),
        comment('Copy starter script, if necessary'),
        '[[ ! -f $FileTgt ]]', and_(),
        line('cp $DirSrc/project-fix-permissions.bash $FileTgt'),
        line(),
        line(": <<'DisabledContent'"),
        assign('FileTgt', '$DirTgt/declare.src'), eol(),
        '[[ ! -f $FileTgt ]]', and_(),
        line('cp $DirSrc/project-declare.src $FileTgt'),
        line(),
        assign('FileTgt', '$DirTgt/development.rst'), eol(),
        '[[ ! -f $FileTgt ]]', and_(),
        line('cp $DirSrc/project-development.rst $FileTgt'),
        line(),
        assign('FileTgt', '$DirTgt/README.rst'), eol(),
        '[[ ! -f $FileTgt ]]', and_(),
        line('cp $DirSrc/project-README.rst $FileTgt'),
        line(),
        assign('DirTgt', '$BO_Project/bin/helper/Linux'), eol(),
        '[[ ! -e $DirTgt ]]', and_(),
        line('mkdir -p $DirTgt'),
        line(),
        assign('FileTgt', '$DirTgt/declare-BASH.src'), eol(),
        '[[ ! -f $FileTgt ]]', and_(),
        line('cp $DirSrc/project-declare-BASH.src $FileTgt'),
        line('DisabledContent'),
    ]

def create_random_tmpdir():
    return [
        line(),
        comment('Create random TMPDIR'),
        assign('Dir', '$(mktemp --tmpdir -d BO-XXXXXXXX)'), eol(),
        '[[ -d "$Dir" ]]', and_(),
        export('TMPDIR', '$Dir'), eol(),
    ]

def declare_for_bootstrap():
    return [
        line(),
        rule(),
        comment('Declare BriteOnyx support functionality'),
        line(),
        assign('Script', '"$BO_Project/BriteOnyx/declare.src"'), eol(),
        '[[ ! -f "$Script" ]]', and_(),
        echo_fatal("Missing script '$Script'"), and_(),
        return_(63), eol(),
        source('"$Script"'), seq(),
        assign('Status', '$?'), eol(),
        '[[ "${Status}" -ne 0 ]]', and_(),
        echo_fatal("Script exited with '${Status}'"), and_(),
        return_('${Status}'), eol(),
        line(),
        rule(),
        note('Now that we have our support functionality declared, we can use it from here on'),
    ]

def declare_for_project():
    return [
        line(),
        rule(),
        comment('Declare optional project functionality'),
        line(),
        assign('Script', '"$BO_Project/declare.src"'), eol(),
        if_('[[ -f "$Script" ]]'), seq(), then(), eol(),
        '  ', source('"$Script"'), seq(),
        assign('Status', '$?'), eol(),
        '  ', '[[ "${Status}" -ne 0 ]]', and_(),
        echo_fatal("Script exited with '${Status}'"), and_(),
        return_('${Status}'), eol(),
        fi(), eol(),
    ]

def demonstrate_logging():
    return [
        line(),
        rule(),
        comment('Demonstrate logging'),
        line(),
        line('logDebug  "EXAMPLE: This is a debugging message"'),
        line('logInfo   "EXAMPLE: This is an informational message"'),
        line('logWarn   "EXAMPLE: This is a warning message"'),
        line('logError  "EXAMPLE: This is an error message"'),
        line('_logFatal "EXAMPLE: This is a fatal message"'),
    ]

def initialize_logging_file():
    return [
        line(),
        comment('Initialize BriteOnyx logging file'),
        assign('BO_FileLog', 'BO.log'), eol(),
        if_('[[ -n "$TMPDIR" ]]'), seq(), then(), eol(),
        '  ', export('BO_FileLog', '$TMPDIR/$BO_FileLog'), eol(),
        elif_('[[ -n "$BO_Project" ]]'), seq(), then(), eol(),
        '  ', export('BO_FileLog', '$BO_Project/$BO_FileLog'), eol(),
        else_(), eol(),
        '  ', export('BO_FileLog', '$PWD/$BO_FileLog'), eol(),
        fi(), eol(),
        echo_info("Activating..."), ' >$BO_FileLog', eol(),
        echo_info("Activating the BriteOnyx framework for this project..."), eol(),
        echo_warn("This script MUST be executed as 'source activate.src', WAS IT?"), eol(),
    ]

def normalize_reference_to_project_root():
    return [
        line(),
        require_variable("'BO_Project'"), or_(),
        failed(), or_(),
        return_('$?'), eol(),
        trace_variable("'BO_Project'"), eol(),
        export('BO_Project', '"$(boNodeCanonical $BO_Project)"'), eol(),
        trace_variable("'BO_Project'"), eol(),
        bo_log_info("Canonical form of BO_Project directory pathname is '$BO_Project'"),
        eol(),
        require_directory('"$BO_Project"'), or_(),
        failed(), or_(),
        return_('$?'), eol(),
    ]

def remember_path():
    return [
        line(),
        rule(),
        comment('Remember PATH'),
        line(),
        '[[ -z "$BO_PathSystem" ]]', and_(), nl(),
        '  ', export('BO_PathSystem', '$PATH'), and_(), nl(),
        '  ', echo_info("Remembering BO_PathSystem='$BO_PathSystem'"), eol(),
    ]

def remember_project_root():
    return [
        line(),
        rule(),
        comment('Remember the directory containing this script as our project root'),
        line(),
        export('BO_Project', '"$(dirname $BASH_SOURCE)"'), eol(),
        line(),
        todo('REVIEW: Shall we NOT cd into our project directory since it changes'),
        comment("the caller's execution environment?"),
        comment('cd "$BO_Project" || return $?'),
    ]

def set_tmpdir():
    return [
        line(),
        rule(),
        comment('Set TMPDIR '),
        comment('DISABLED: MOVED: to Linux activation script'),
        line(),
        comment('export TMPDIR=$TMPDIR/$BO_ProjectName'),
        comment('''echo "INFO:  Remembering TMPDIR='$TMPDIR'"'''),
    ]

def shutdown():
    return [
        line(),
        rule(),
        comment('Shutdown'),
        line(),
        log_info("Project '$BO_ProjectName' in directory '$BO_Project' is now activated, done."),
        eol(),
        capture_outgoing_environment(),
    ]

def verify_briteonyx_bootstrap():
    return [
        line(),
        rule(),
        comment('Verify BriteOnyx bootstrap configuration'),
        line(),
        require_variable('  BO_Home'), or_(),
        failed(), or_(),
        return_('$?'), eol(),
        require_directory('$BO_Home'), or_(),
        failed(), or_(),
        return_('$?'), eol(),
        line(),
        require_variable('BO_ProjectName'), or_(),
        failed(), or_(),
        return_('$?'), eol(),
    ]


class Script(script_briteonyx.Script):
    def __init__(self, content):
        script_briteonyx.Script.__init__(self)
        self._content = content


def build():
    return Script([
        source_header(),
        comments(),
        abort_if_activated(),
        create_random_tmpdir(),
        initialize_logging_file(),
        capture_incoming_environment(),
        remember_project_root(),
        declare_for_bootstrap(),
        normalize_reference_to_project_root(),
        copy_starter_files(),
        configure_for_user(),
        configure_for_project(),
        configure_for_briteonyx(),
        verify_briteonyx_bootstrap(),
        remember_path(),
        activate_for_linux(),
        set_tmpdir(),
        declare_for_project(),
        demonstrate_logging(),
        shutdown(),
        disabled_content_footer(),
    ])
    

VISITOR_MAP = VisitorMap(parent_map=script_briteonyx.VISITOR_MAP)


def render(target_directory, target_file):
    script_bash.render(build(), VISITOR_MAP, target_directory, target_file)


""" Disabled content
"""

