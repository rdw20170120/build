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
        string_is_not_null(vr('BO_Project')), and_(),
        echo_fatal(['Project ', sq(vr('BO_Project')), ' is already activated, aborting']), and_(),
        exit(100), eol(),
    ]

def activate_for_linux():
    return [
        line(),
        rule(),
        comment('Activate as a Linux project'),
        line(),
        source_script(dq('$BO_Home/helper/activation/activate.src')),
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
        someday([
            'Verify that ',
            vr('BO_Project'),
            ' does indeed point to the root of our project directory tree',
        ]),
    ]

def capture_incoming_environment():
    return [
        line(),
        comment('Capture incoming BASH environment'),
        if_(string_is_not_null('$TMPDIR')), seq(), then(), eol(),
        '  ', command('env'), pipe(), command('sort', '>$TMPDIR/BO-env-incoming.out'), eol(),
        elif_(string_is_not_null(vr('BO_Project'))), seq(), then(), eol(),
        '  ', command('env'), pipe(),
        command('sort', ['>', pathname(vr('BO_Project'), 'BO-env-incoming.out')]),
        eol(), else_(), eol(),
        '  ', command('env'), pipe(), command('sort', '>$PWD/BO-env-incoming.out'), eol(),
        fi(), eol(),
    ]

def capture_outgoing_environment():
    return [
        line(),
        comment('Capture outgoing BASH environment'),
        if_(string_is_not_null('$TMPDIR')), seq(), then(), eol(),
        '  ', command('env'), pipe(), command('sort', '>$TMPDIR/BO-env-outgoing.out'), eol(),
        elif_(string_is_not_null(vr('BO_Project'))), seq(), then(), eol(),
        '  ', command('env'), pipe(),
        command('sort', ['>', pathname(vr('BO_Project'), 'BO-env-outgoing.out')]),
        eol(), else_(), eol(),
        '  ', command('env'), pipe(), command('sort', '>$PWD/BO-env-outgoing.out'), eol(),
        fi(), eol(),
    ]

def configure_for_briteonyx():
    return [
        line(),
        rule(),
        comment('Configure for BriteOnyx'),
        line(),
        source_script(dq(pathname(vr('BO_Project'), 'BriteOnyx/env.src'))),
    ]

def configure_for_project():
    return [
        line(),
        rule(),
        comment('Configure for this project'),
        line(),
        source_script(pathname(vr('BO_Project'), 'env.src')),
    ]

def configure_for_user():
    return [
        line(),
        rule(),
        comment('Configure for this user'),
        line(),
        source_script('$HOME/.BriteOnyx.src'),
    ]

def copy_starter_files():
    return [
        line(),
        rule(),
        comment('Copy starter files into place as necessary'),
        line(),
        assign('DirSrc', pathname(vr('BO_Project'), 'BriteOnyx/starter')), eol(),
        line(),
        require_variable('HOME'), eol(),
        assign('DirTgt', '$HOME'), eol(),
        path_does_not_exist('$DirTgt'), and_(),
        command('mkdir', ['-p', '$DirTgt']), eol(),
        line(),
        assign('FileTgt', '$DirTgt/.BriteOnyx.src'), eol(),
        comment('Move previous scripts to new path'),
        file_exists('$DirTgt/BriteOnyx.src'), and_(),
        command('mv', ['$DirTgt/BriteOnyx.src', '$FileTgt']), eol(),
        file_exists('$DirTgt/BriteOnyx-env.bash'), and_(),
        command('mv', ['$DirTgt/BriteOnyx-env.bash', '$FileTgt']), eol(),
        file_exists('$DirTgt/BriteOnyx-env.src'), and_(),
        command('mv', ['$DirTgt/BriteOnyx-env.src',  '$FileTgt']), eol(),
        comment('Copy starter script, if necessary'),
        path_is_not_file('$FileTgt'), and_(),
        command('cp', ['$DirSrc/user-BriteOnyx.src', '$FileTgt']), eol(),
        line(),
        assign('DirTgt', pathname(vr('BO_Project'))), eol(),
        path_does_not_exist('$DirTgt'), and_(),
        command('mkdir', ['-p', '$DirTgt']), eol(),
        line(),
        assign('FileTgt', '$DirTgt/env.src'), eol(),
        path_is_not_file('$FileTgt'), and_(),
        command('cp', ['$DirSrc/project-env.src', '$FileTgt']), eol(),
        line(),
        assign('FileTgt', '$DirTgt/.hgignore'), eol(),
        path_is_not_file('$FileTgt'), and_(),
        command('cp', ['$DirSrc/project.hgignore', '$FileTgt']), eol(),
        line(),
        assign('DirTgt', pathname(vr('BO_Project'), 'bin')), eol(),
        path_does_not_exist('$DirTgt'), and_(),
        command('mkdir', ['-p', '$DirTgt']), eol(),
        line(),
        assign('FileTgt', '$DirTgt/project-fix-permissions.bash'), eol(),
        comment('Move previous scripts to new path'),
        file_exists('$DirTgt/all-fix-permissions.bash'), and_(),
        command('mv', ['$DirTgt/all-fix-permissions.bash', '$FileTgt']), eol(),
        comment('Copy starter script, if necessary'),
        path_is_not_file('$FileTgt'), and_(),
        command('cp', ['$DirSrc/project-fix-permissions.bash', '$FileTgt']), eol(),
        line(),
        line(": <<'DisabledContent'"),
        assign('FileTgt', '$DirTgt/declare.src'), eol(),
        path_is_not_file('$FileTgt'), and_(),
        command('cp', ['$DirSrc/project-declare.src', '$FileTgt']), eol(),
        line(),
        assign('FileTgt', '$DirTgt/development.rst'), eol(),
        path_is_not_file('$FileTgt'), and_(),
        command('cp', ['$DirSrc/project-development.rst', '$FileTgt']), eol(),
        line(),
        assign('FileTgt', '$DirTgt/README.rst'), eol(),
        path_is_not_file('$FileTgt'), and_(),
        command('cp', ['$DirSrc/project-README.rst', '$FileTgt']), eol(),
        line(),
        assign('DirTgt', pathname(vr('BO_Project'), 'bin/helper/Linux')), eol(),
        path_does_not_exist('$DirTgt'), and_(),
        command('mkdir', ['-p', '$DirTgt']), eol(),
        line(),
        assign('FileTgt', '$DirTgt/declare-BASH.src'), eol(),
        path_is_not_file('$FileTgt'), and_(),
        command('cp', ['$DirSrc/project-declare-BASH.src', '$FileTgt']), eol(),
        line('DisabledContent'),
    ]

def create_random_tmpdir():
    return [
        line(),
        comment('Create random TMPDIR'),
        assign('Dir', '$(mktemp --tmpdir -d BO-XXXXXXXX)'), eol(),
        directory_exists('$Dir'), and_(),
        export('TMPDIR', '$Dir'), eol(),
    ]

def declare_for_bootstrap():
    return [
        line(),
        rule(),
        comment('Declare BriteOnyx support functionality'),
        line(),
        assign('Script', dq(pathname(vr('BO_Project'), 'BriteOnyx/declare.src'))), eol(),
        path_is_not_file('$Script'), and_(),
        echo_fatal("Missing script '$Script'"), and_(),
        return_(63), eol(),
        source(dq('$Script')), seq(),
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
        assign('Script', dq(pathname(vr('BO_Project'), 'declare.src'))), eol(),
        if_(file_exists('$Script')), seq(), then(), eol(),
        '  ', source(dq('$Script')), seq(),
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
        log_debug('EXAMPLE: This is a debugging message'), eol(),
        log_info('EXAMPLE: This is an informational message'), eol(),
        log_warn('EXAMPLE: This is a warning message'), eol(),
        log_error('EXAMPLE: This is an error message'), eol(),
        log_fatal('"EXAMPLE: This is a fatal message'), eol(),
    ]

def initialize_logging_file():
    return [
        line(),
        comment('Initialize BriteOnyx logging file'),
        assign('BO_FileLog', 'BO.log'), eol(),
        if_(string_is_not_null('$TMPDIR')), seq(), then(), eol(),
        '  ', export('BO_FileLog', '$TMPDIR/$BO_FileLog'), eol(),
        elif_(string_is_not_null(vr('BO_Project'))), seq(), then(), eol(),
        '  ', export('BO_FileLog', pathname(vr('BO_Project'), '$BO_FileLog')), eol(),
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
        require_variable(sq(vn('BO_Project'))), or_(),
        failed(), or_(),
        return_last_status(), eol(),
        trace_variable(sq(vn('BO_Project'))), eol(),
        export(vn('BO_Project'), dq(['$(boNodeCanonical ', vr('BO_Project'), ')'])), eol(),
        trace_variable(sq(vn('BO_Project'))), eol(),
        bo_log_info([
            'Canonical form of ',
            vn('BO_Project'),
            ' directory pathname is ',
            sq(vr('BO_Project')),
        ]),
        eol(),
        require_directory(vr('BO_Project')), or_(),
        failed(), or_(),
        return_last_status(), eol(),
    ]

def remember_path():
    return [
        line(),
        rule(),
        comment('Remember PATH'),
        line(),
        string_is_null('$BO_PathSystem'), and_(), nl(),
        '  ', export('BO_PathSystem', '$PATH'), and_(), nl(),
        '  ', echo_info("Remembering BO_PathSystem='$BO_PathSystem'"), eol(),
    ]

def remember_project_root():
    return [
        line(),
        rule(),
        comment('Remember the directory containing this script as our project root'),
        line(),
        export(vn('BO_Project'), '"$(dirname $BASH_SOURCE)"'), eol(),
        line(),
        todo('REVIEW: Shall we NOT cd into our project directory since it changes'),
        comment("the caller's execution environment?"),
        comment([command('cd', dq(pathname(vr('BO_Project')))), or_(), return_last_status()]),
    ]

def set_tmpdir():
    return [
        line(),
        rule(),
        comment('Set TMPDIR '),
        comment('DISABLED: MOVED: to Linux activation script'),
        line(),
        comment(export('TMPDIR', pathname('$TMPDIR', vr('BO_ProjectName')))),
        comment(echo_info("Remembering TMPDIR='$TMPDIR'")),
    ]

def shutdown():
    return [
        line(),
        rule(),
        comment('Shutdown'),
        line(),
        log_info([
            'Project ',
            sq(vr('BO_ProjectName')),
            ' in directory ',
            sq(vr('BO_Project')),
            ' is now activated, done.',
        ]),
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
        return_last_status(), eol(),
        require_directory('$BO_Home'), or_(),
        failed(), or_(),
        return_last_status(), eol(),
        line(),
        require_variable(vn('BO_ProjectName')), or_(),
        failed(), or_(),
        return_last_status(), eol(),
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

