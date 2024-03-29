import script_bash
import script_briteonyx

from throw_out_your_templates_3_core_visitor_map import VisitorMap

from structure_bash import *
from structure_briteonyx import *


class Script(script_briteonyx.Script):
    def __init__(self, content):
        script_briteonyx.Script.__init__(self)
        self._content = content


def build():
    return Script(
        [
            source_header(),
            note(
                "By convention, BriteOnyx is configured via environment variables prefixed by 'BO_'."
            ),
            line(),
            """boVariableRequire 'BO_Project' ||""",
            ' boFailed "$0" "$LINENO" $? ||',
            line(" return $?"),
            line(),
            rule(),
            comment("Copy starter files into place as necessary"),
            line(),
            line("DirSrc=$BO_Project/BriteOnyx/starter"),
            line("DirTgt=$BO_Project"),
            line(),
            "[[ ! -f $DirTgt/.hgignore ]] &&",
            line(" cp $DirSrc/project.hgignore $DirTgt/sample.hgignore"),
            line(),
            line("FileTgt=$DirTgt/declare.src"),
            "[[ ! -f $FileTgt ]] &&",
            line(" cp $DirSrc/project-declare.src $FileTgt"),
            line(),
            line("FileTgt=$DirTgt/development.rst"),
            "[[ ! -f $FileTgt ]] &&",
            line(" cp $DirSrc/project-development.rst $FileTgt"),
            line(),
            line("FileTgt=$DirTgt/env.src"),
            "[[ ! -f $FileTgt ]] &&",
            line(" cp $DirSrc/project-env.src $FileTgt"),
            line(),
            line("FileTgt=$DirTgt/README.rst"),
            "[[ ! -f $FileTgt ]] &&",
            line(" cp $DirSrc/project-README.rst $FileTgt"),
            line(),
            line("DirTgt=$BO_Project/bin"),
            line("FileTgt=$DirTgt/all-fix-permissions.bash"),
            "[[ ! -f $FileTgt ]] &&",
            line(" cp $DirSrc/project-all-fix-permissions.bash $FileTgt"),
            line(),
            line("DirTgt=$BO_Project/bin/helper/Linux"),
            "[[ ! -e $DirTgt ]] &&",
            line(" mkdir -p $DirTgt"),
            line("FileTgt=$DirTgt/declare-BASH.src"),
            "[[ ! -f $FileTgt ]] &&",
            line(" cp $DirSrc/project-declare-BASH.src $FileTgt"),
            line(),
            line("DirTgt=$HOME"),
            line("FileTgt=$DirTgt/.BriteOnyx.src"),
            comment("Move previous scripts to new path"),
            "[[   -f $DirTgt/BriteOnyx-env.bash ]] &&",
            line(" mv $DirTgt/BriteOnyx-env.bash $FileTgt"),
            "[[   -f $DirTgt/BriteOnyx-env.src  ]] &&",
            line(" mv $DirTgt/BriteOnyx-env.src  $FileTgt"),
            "[[ ! -f $FileTgt ]] &&",
            line(" cp $DirSrc/user-BriteOnyx.src $FileTgt"),
            line(),
            rule(),
            comment("Configure for this user"),
            line(),
            line("Script=$HOME/.BriteOnyx.src"),
            'boScriptRequire "$Script" ||',
            ' boFailed "$0" "$LINENO" $? ||',
            line(" return $?"),
            'source          "$Script" ||',
            ' boFailed "$0" "$LINENO" $? ||',
            line(" return $?"),
            line(),
            rule(),
            comment("Configure for this project"),
            line(),
            line("Script=$BO_Project/env.src"),
            "boScriptRequire $Script ||",
            ' boFailed "$0" "$LINENO" $? ||',
            line(" return $?"),
            "source          $Script ||",
            ' boFailed "$0" "$LINENO" $? ||',
            line(" return $?"),
            line(),
            rule(),
            comment("Configure for BriteOnyx"),
            line(),
            line('Script="$BO_Project/BriteOnyx/env.src"'),
            'boScriptRequire "$Script" ||',
            ' boFailed "$0" "$LINENO" $? ||',
            line(" return $?"),
            'source          "$Script" ||',
            ' boFailed "$0" "$LINENO" $? ||',
            line(" return $?"),
            line(),
            rule(),
            comment("Verify BriteOnyx bootstrap configuration"),
            line(),
            """boVariableRequire 'BO_Parent'  ||""",
            ' boFailed "$0" "$LINENO" $? ||',
            line(" return $?"),
            """boVariableRequire 'BO_Url'     ||""",
            ' boFailed "$0" "$LINENO" $? ||',
            line(" return $?"),
            """boVariableRequire 'BO_Version' ||""",
            ' boFailed "$0" "$LINENO" $? ||',
            line(" return $?"),
            line(),
            rule(),
            line(": <<'DisabledContent'"),
            comment("Checkout the BriteOnyx source"),
            line(),
            'boDirectoryCreate "$BO_Parent" ||',
            ' boFailed "$0" "$LINENO" $? ||',
            line(" return $?"),
            line(),
            '[[ -z "$BO_Home" ]] &&',
            line(""" export BO_Home=$(boNodeCanonical "$BO_Parent/$BO_Version")"""),
            """boVariableRequire 'BO_Home' ||""",
            ' boFailed "$0" "$LINENO" $? ||',
            line(" return $?"),
            line(),
            'if boDirectoryExists "$BO_Home" ;',
            line(" then"),
            line(
                '''  boLogDebug "Directory '$BO_Home' already exists, skipping Mercurial clone."'''
            ),
            'elif [[ "$BO_Version" == "predeployed" ]];',
            line(" then"),
            line('''  boLogWarn "Ignoring Mercurial clone of version '$BO_Version'"'''),
            line("else"),
            line(
                '''  boLogInfo "Cloning version '$BO_Version' from '$BO_Url' into '$BO_Home'..."'''
            ),
            line('  Cmd="hg clone"'),
            line('  Cmd+=" --rev $BO_Version"'),
            line('  Cmd+=" $BO_Url"'),
            line('  Cmd+=" $BO_Home"'),
            line('''  Msg="Mercurial failed to clone into directory '$BO_Home'!"'''),
            '  boExecute "$Cmd" "$Msg" ||',
            ' boFailed "$0" "$LINENO" $? ||',
            line(" return $?"),
            line("fi"),
            line(),
            'boDirectoryRequire "$BO_Home" ||',
            ' boFailed "$0" "$LINENO" $? ||',
            line(" return $?"),
            line(),
            'if [[ "$BO_Version" == "tip" ]];',
            line(" then"),
            line(
                "  # Update Mercurial clone of 'tip' to support development of BriteOnyx framework"
            ),
            line(
                '''  boLogInfo "Updating clone of version '$BO_Version' from '$BO_Url' into '$BO_Home'..."'''
            ),
            '  cd "$BO_Home" ||',
            ' boFailed "$0" "$LINENO" $? ||',
            line(" return $?"),
            line('  Cmd="hg pull --update"'),
            line(
                '''  Msg="Mercurial failed to update clone in directory '$BO_Home'!"'''
            ),
            '  boExecute "$Cmd" "$Msg" ||',
            ' boFailed "$0" "$LINENO" $? ||',
            line(" return $?"),
            line("else"),
            line(
                '''  boLogDebug "BriteOnyx version '$BO_Version' should be stable, skipping update of clone."'''
            ),
            line("fi"),
            line("DisabledContent"),
            disabled_content_footer(),
        ]
    )


VISITOR_MAP = VisitorMap(parent_map=script_bash.VISITOR_MAP)


def render(target_directory, target_file):
    script_bash.render(build(), VISITOR_MAP, target_directory, target_file)


""" Disabled content
"""
