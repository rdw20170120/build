import script_bash
import script_briteonyx

from throw_out_your_templates_3_core_visitor_map import VisitorMap

from structure_bash import *
from structure_briteonyx import *


class Script(script_briteonyx.Script):
    def __init__(self):
        script_briteonyx.Script.__init__(self)

    def abort_if_activated(self):
        self.add(line())
        self.add(rule())
        self.add(note('ABORT: if project is already activated'))
        self.add('[[ -n "$BO_Project" ]]').add(and_())
        self.add(echo('''"FATAL: Project '$BO_Project' is already activated, aborting"''')).add(and_())
        self.add(exit(100))
        self.add(eol())

    def activate_for_linux(self):
        self.add(line())
        self.add(rule())
        self.add(comment('Activate as a Linux project'))
        self.add(line())
        self.add(assign('Script', '"$BO_Home/helper/activation/activate.src"')).add(eol())
        self.add(require_script('"$Script"')).add(or_())
        self.add(failed()).add(or_())
        self.add(return_('$?')).add(eol())
        self.add(source('         "$Script"')).add(or_())
        self.add(failed()).add(or_())
        self.add(return_('$?')).add(eol())

    def comments(self):
        self.add(note("We MUST NOT EVER 'exit' during BriteOnyx bootstrap or activation"))
        self.add(rule())
        self.add(debugging_comment())
        self.add(someday('Add inverse commands to isolate debugging'))
        self.add(line())
        self.add(rule())
        self.add(comment('Activate the BriteOnyx framework to manage this project directory tree'))
        self.add(comment())
        self.add(note("This script, and EVERY script that it calls, must NOT invoke 'exit'!  The user calling this"))
        self.add(comment('  script must be allowed to preserve their shell and every effort must be made to inform the user'))
        self.add(comment('  of problems while continuing execution where possible.  Terminating the shell robs the user of'))
        self.add(comment("  useful feedback and interrupts their work, which is unacceptable.  Instead, the BASH 'return'"))
        self.add(comment('  statement should be invoked to end execution with an appropriate status code.'))
        self.add(comment())
        self.add(someday('Verify that $BO_Project does indeed point to the root of our project directory tree'))

    def capture_incoming_environment(self):
        self.add(line())
        self.add(comment('Capture incoming BASH environment'))
        self.add(if_('[[ -n "$TMPDIR" ]]')).add(seq()).add(then()).add(eol())
        self.add('  ').add(line('env | sort >$TMPDIR/BO-env-incoming.out'))
        self.add(elif_('[[ -n "$BO_Project" ]]')).add(seq()).add(then()).add(eol())
        self.add('  ').add(line('env | sort >$BO_Project/BO-env-incoming.out'))
        self.add(else_()).add(eol())
        self.add('  ').add(line('env | sort >$PWD/BO-env-incoming.out'))
        self.add(fi()).add(eol())

    def capture_outgoing_environment(self):
        self.add(line())
        self.add(comment('Capture outgoing BASH environment'))
        self.add(if_('[[ -n "$TMPDIR" ]]')).add(seq()).add(then()).add(eol())
        self.add('  ').add(line('env | sort >$TMPDIR/BO-env-outgoing.out'))
        self.add(elif_('[[ -n "$BO_Project" ]]')).add(seq()).add(then()).add(eol())
        self.add('  ').add(line('env | sort >$BO_Project/BO-env-outgoing.out'))
        self.add(else_()).add(eol())
        self.add('  ').add(line('env | sort >$PWD/BO-env-outgoing.out'))
        self.add(fi()).add(eol())

    def configure_for_briteonyx(self):
        self.add(line())
        self.add(rule())
        self.add(comment('Configure for BriteOnyx'))
        self.add(line())
        self.add(assign('Script', '"$BO_Project/BriteOnyx/env.src"')).add(eol())
        self.add(require_script('"$Script"')).add(or_())
        self.add(failed()).add(or_())
        self.add(return_('$?')).add(eol())
        self.add(source('         "$Script"')).add(or_())
        self.add(failed()).add(or_())
        self.add(return_('$?')).add(eol())

    def configure_for_project(self):
        self.add(line())
        self.add(rule())
        self.add(comment('Configure for this project'))
        self.add(line())
        self.add(assign('Script', '$BO_Project/env.src')).add(eol())
        self.add(require_script('$Script')).add(or_())
        self.add(failed()).add(or_())
        self.add(return_('$?')).add(eol())
        self.add(source('         $Script')).add(or_())
        self.add(failed()).add(or_())
        self.add(return_('$?')).add(eol())

    def configure_for_user(self):
        self.add(line())
        self.add(rule())
        self.add(comment('Configure for this user'))
        self.add(line())
        self.add(assign('Script', '$HOME/.BriteOnyx.src')).add(eol())
        self.add(require_script('"$Script"')).add(or_())
        self.add(failed()).add(or_())
        self.add(return_('$?')).add(eol())
        self.add(source('         "$Script"')).add(or_())
        self.add(failed()).add(or_())
        self.add(return_('$?')).add(eol())

    def copy_starter_files(self):
        self.add(line())
        self.add(rule())
        self.add(comment('Copy starter files into place as necessary'))
        self.add(line())
        self.add(assign('DirSrc', '$BO_Project/BriteOnyx/starter')).add(eol())
        self.add(line())
        self.add(require_variable('HOME')).add(eol())
        self.add(assign('DirTgt', '$HOME')).add(eol())
        self.add('[[ ! -e "$DirTgt" ]]').add(and_())
        self.add(line('mkdir -p $DirTgt'))
        self.add(line())
        self.add(assign('FileTgt', '$DirTgt/.BriteOnyx.src')).add(eol())
        self.add(comment('Move previous scripts to new path'))
        self.add('[[   -f $DirTgt/BriteOnyx.src      ]]').add(and_())
        self.add(line('mv $DirTgt/BriteOnyx.src      $FileTgt'))
        self.add('[[   -f $DirTgt/BriteOnyx-env.bash ]]').add(and_())
        self.add(line('mv $DirTgt/BriteOnyx-env.bash $FileTgt'))
        self.add('[[   -f $DirTgt/BriteOnyx-env.src  ]]').add(and_())
        self.add(line('mv $DirTgt/BriteOnyx-env.src  $FileTgt'))
        self.add(comment('Copy starter script, if necessary'))
        self.add('[[ ! -f $FileTgt ]]').add(and_())
        self.add(line('cp $DirSrc/user-BriteOnyx.src $FileTgt'))
        self.add(line())
        self.add(assign('DirTgt', '$BO_Project')).add(eol())
        self.add('[[ ! -e "$DirTgt" ]]').add(and_())
        self.add(line('mkdir -p $DirTgt'))
        self.add(line())
        self.add(assign('FileTgt', '$DirTgt/env.src')).add(eol())
        self.add('[[ ! -f $FileTgt ]]').add(and_())
        self.add(line('cp $DirSrc/project-env.src $FileTgt'))
        self.add(line())
        self.add(assign('FileTgt', '$DirTgt/.hgignore')).add(eol())
        self.add('[[ ! -f $FileTgt ]]').add(and_())
        self.add(line('cp $DirSrc/project.hgignore $FileTgt'))
        self.add(line())
        self.add(assign('DirTgt', '$BO_Project/bin')).add(eol())
        self.add('[[ ! -e "$DirTgt" ]]').add(and_())
        self.add(line('mkdir -p $DirTgt'))
        self.add(line())
        self.add(assign('FileTgt', '$DirTgt/project-fix-permissions.bash')).add(eol())
        self.add(comment('Move previous scripts to new path'))
        self.add('[[   -f $DirTgt/all-fix-permissions.bash ]]').add(and_())
        self.add(line('mv $DirTgt/all-fix-permissions.bash $FileTgt'))
        self.add(comment('Copy starter script, if necessary'))
        self.add('[[ ! -f $FileTgt ]]').add(and_())
        self.add(line('cp $DirSrc/project-fix-permissions.bash $FileTgt'))
        self.add(line())
        self.add(line(": <<'DisabledContent'"))
        self.add(assign('FileTgt', '$DirTgt/declare.src')).add(eol())
        self.add('[[ ! -f $FileTgt ]]').add(and_())
        self.add(line('cp $DirSrc/project-declare.src $FileTgt'))
        self.add(line())
        self.add(assign('FileTgt', '$DirTgt/development.rst')).add(eol())
        self.add('[[ ! -f $FileTgt ]]').add(and_())
        self.add(line('cp $DirSrc/project-development.rst $FileTgt'))
        self.add(line())
        self.add(assign('FileTgt', '$DirTgt/README.rst')).add(eol())
        self.add('[[ ! -f $FileTgt ]]').add(and_())
        self.add(line('cp $DirSrc/project-README.rst $FileTgt'))
        self.add(line())
        self.add(assign('DirTgt', '$BO_Project/bin/helper/Linux')).add(eol())
        self.add('[[ ! -e $DirTgt ]]').add(and_())
        self.add(line('mkdir -p $DirTgt'))
        self.add(line())
        self.add(assign('FileTgt', '$DirTgt/declare-BASH.src')).add(eol())
        self.add('[[ ! -f $FileTgt ]]').add(and_())
        self.add(line('cp $DirSrc/project-declare-BASH.src $FileTgt'))
        self.add(line('DisabledContent'))

    def create_random_tmpdir(self):
        self.add(line())
        self.add(comment('Create random TMPDIR'))
        self.add(assign('Dir', '$(mktemp --tmpdir -d BO-XXXXXXXX)')).add(eol())
        self.add('[[ -d "$Dir" ]]').add(and_())
        self.add(export('TMPDIR', '$Dir')).add(eol())

    def declare_for_bootstrap(self):
        self.add(line())
        self.add(rule())
        self.add(comment('Declare BriteOnyx support functionality'))
        self.add(line())
        self.add(assign('Script', '"$BO_Project/BriteOnyx/declare.src"')).add(eol())
        self.add('[[ ! -f "$Script" ]]').add(and_())
        self.add(echo_fatal("Missing script '$Script'")).add(and_())
        self.add(return_(63)).add(eol())
        self.add(source('"$Script"')).add(seq())
        self.add(assign('Status', '$?')).add(eol())
        self.add('[[ "${Status}" -ne 0 ]]').add(and_())
        self.add(echo_fatal("Script exited with '${Status}'")).add(and_())
        self.add(return_('${Status}')).add(eol())
        self.add(line())
        self.add(rule())
        self.add(note('Now that we have our support functionality declared, we can use it from here on'))

    def declare_for_project(self):
        self.add(line())
        self.add(rule())
        self.add(comment('Declare optional project functionality'))
        self.add(line())
        self.add(assign('Script', '"$BO_Project/declare.src"')).add(eol())
        self.add(if_('[[ -f "$Script" ]]')).add(seq()).add(then()).add(eol())
        self.add('  ').add(source('"$Script"')).add(seq())
        self.add(assign('Status', '$?')).add(eol())
        self.add('  ').add('[[ "${Status}" -ne 0 ]]').add(and_())
        self.add(echo_fatal("Script exited with '${Status}'")).add(and_())
        self.add(return_('${Status}')).add(eol())
        self.add(fi()).add(eol())

    def demonstrate_logging(self):
        self.add(line())
        self.add(rule())
        self.add(comment('Demonstrate logging'))
        self.add(line())
        self.add(line('logDebug  "EXAMPLE: This is a debugging message"'))
        self.add(line('logInfo   "EXAMPLE: This is an informational message"'))
        self.add(line('logWarn   "EXAMPLE: This is a warning message"'))
        self.add(line('logError  "EXAMPLE: This is an error message"'))
        self.add(line('_logFatal "EXAMPLE: This is a fatal message"'))

    def generate(self):
        self.add(source_header())
        self.comments()
        self.abort_if_activated()
        self.create_random_tmpdir()
        self.initialize_logging_file()
        self.capture_incoming_environment()
        self.remember_project_root()
        self.declare_for_bootstrap()
        self.normalize_reference_to_project_root()
        self.copy_starter_files()
        self.configure_for_user()
        self.configure_for_project()
        self.configure_for_briteonyx()
        self.verify_briteonyx_bootstrap()
        self.remember_path()
        self.activate_for_linux()
        self.set_tmpdir()
        self.declare_for_project()
        self.demonstrate_logging()
        self.shutdown()
        self.add(disabled_content_footer())

    def initialize_logging_file(self):
        self.add(line())
        self.add(comment('Initialize BriteOnyx logging file'))
        self.add(assign('BO_FileLog', 'BO.log')).add(eol())
        self.add(if_('[[ -n "$TMPDIR" ]]')).add(seq()).add(then()).add(eol())
        self.add('  ').add(export('BO_FileLog', '$TMPDIR/$BO_FileLog')).add(eol())
        self.add(elif_('[[ -n "$BO_Project" ]]')).add(seq()).add(then()).add(eol())
        self.add('  ').add(export('BO_FileLog', '$BO_Project/$BO_FileLog')).add(eol())
        self.add(else_()).add(eol())
        self.add('  ').add(export('BO_FileLog', '$PWD/$BO_FileLog')).add(eol())
        self.add(fi()).add(eol())
        self.add(echo_info("Activating...")).add(' >$BO_FileLog').add(eol())
        self.add(echo_info("Activating the BriteOnyx framework for this project...")).add(eol())
        self.add(echo_warn("This script MUST be executed as 'source activate.src', WAS IT?")).add(eol())

    def normalize_reference_to_project_root(self):
        self.add(line())
        self.add(require_variable("'BO_Project'")).add(or_())
        self.add(failed()).add(or_())
        self.add(return_('$?')).add(eol())
        self.add(trace_variable("'BO_Project'")).add(eol())
        self.add(export('BO_Project', '"$(boNodeCanonical $BO_Project)"')).add(eol())
        self.add(trace_variable("'BO_Project'")).add(eol())
        self.add(bo_log_info("Canonical form of BO_Project directory pathname is '$BO_Project'"))
        self.add(eol())
        self.add(require_directory('"$BO_Project"')).add(or_())
        self.add(failed()).add(or_())
        self.add(return_('$?')).add(eol())

    def remember_path(self):
        self.add(line())
        self.add(rule())
        self.add(comment('Remember PATH'))
        self.add(line())
        self.add('[[ -z "$BO_PathSystem" ]]').add(and_()).add(nl())
        self.add('  ').add(export('BO_PathSystem', '$PATH')).add(and_()).add(nl())
        self.add('  ').add(echo_info("Remembering BO_PathSystem='$BO_PathSystem'")).add(eol())

    def remember_project_root(self):
        self.add(line())
        self.add(rule())
        self.add(comment('Remember the directory containing this script as our project root'))
        self.add(line())
        self.add(export('BO_Project', '"$(dirname $BASH_SOURCE)"')).add(eol())
        self.add(line())
        self.add(todo('REVIEW: Shall we NOT cd into our project directory since it changes'))
        self.add(comment("the caller's execution environment?"))
        self.add(comment('cd "$BO_Project" || return $?'))

    def set_tmpdir(self):
        self.add(line())
        self.add(rule())
        self.add(comment('Set TMPDIR '))
        self.add(comment('DISABLED: MOVED: to Linux activation script'))
        self.add(line())
        self.add(comment('export TMPDIR=$TMPDIR/$BO_ProjectName'))
        self.add(comment('''echo "INFO:  Remembering TMPDIR='$TMPDIR'"'''))

    def shutdown(self):
        self.add(line())
        self.add(rule())
        self.add(comment('Shutdown'))
        self.add(line())
        self.add(log_info("Project '$BO_ProjectName' in directory '$BO_Project' is now activated, done."))
        self.add(eol())
        self.capture_outgoing_environment()

    def verify_briteonyx_bootstrap(self):
        self.add(line())
        self.add(rule())
        self.add(comment('Verify BriteOnyx bootstrap configuration'))
        self.add(line())
        self.add(require_variable('  BO_Home')).add(or_())
        self.add(failed()).add(or_())
        self.add(return_('$?')).add(eol())
        self.add(require_directory('$BO_Home')).add(or_())
        self.add(failed()).add(or_())
        self.add(return_('$?')).add(eol())
        self.add(line())
        self.add(require_variable('BO_ProjectName')).add(or_())
        self.add(failed()).add(or_())
        self.add(return_('$?')).add(eol())


def build():
    script = Script()
    script.generate()
    return script
    

VISITOR_MAP = VisitorMap(parent_map=script_briteonyx.VISITOR_MAP)


def render(target_directory, target_file):
    script_bash.render(build(), VISITOR_MAP, target_directory, target_file)


""" Disabled content
"""

