#!/usr/bin/env false
"""Generate script to set PATH."""
# Internal packages (absolute references, distributed with Python)
# External packages (absolute references, NOT distributed with Python)
# Library modules   (absolute references, NOT packaged, in project)
from src_gen.script.bash.activating.frame import *
from src_gen.script.bash.activating.material import *

# Project modules   (relative references, NOT packaged, in project)


def _comments():
    return [
        comment("Set PATH for project"),
        comment(),
        note("This specific ordering of PATH elements is REQUIRED."),
        comment("The Anaconda environment MUST come first"),
        comment("in order to override everything else."),
        comment("The system PATH element MUST precede any user PATH elements"),
        comment("in order to make collisions fail-fast"),
        comment("and"),
        comment("to defeat simple attempts"),
        comment("at redirecting system commands"),
        comment("as an attack vector."),
        comment("Similarly,"),
        comment("the project PATH element MUST precede the user PATH element"),
        comment("in order to make collisions fail-fast."),
        comment("This arrangement is best"),
        comment("for ensuring consistent behavior"),
        comment("of the environment, the system, and the project."),
        comment("It puts at-risk"),
        comment("only those user-specific commands, tools, and scripts"),
        comment("relevant to the current deployed environment--"),
        comment("where the specific user is best positioned to address them"),
        comment("and failures are most likely limited"),
        comment("to affecting only"),
        comment("the current project and user"),
        comment("(as they should)."),
    ]


def _remember_paths():
    return [
        line(),
        export_if_null("BO_PathSystem", vr("PATH")), eol(),
        export_if_null("BO_PathTool", ""), eol(),
        line(),
        require_variable(vn("BO_PathProject")), eol(),
        require_variable(vn("BO_PathSystem")), eol(),
        someday( require_variable(vn("BO_PathTool")),), eol(),
        require_variable(vn("BO_PathUser")), eol(),
        line(),
        assign(vn("PATH"), vr("BO_PathTool")), eol(),
        assign(
            vn("PATH"),
            x(
            vr("PATH"),
                ":",
                vr("BO_PathSystem"),
                ),
            ), eol(),
        assign(
            vn("PATH"),
            x(
            vr("PATH"),
                ":",
                vr("BO_PathProject"),
                ),
            ), eol(),
        assign(
            vn("PATH"),
            x(
            vr("PATH"),
                ":",
                vr("BO_PathUser"),
                ),
            ), eol(),
        export(vn("PATH")), eol(),
        line(),
        remembering("BO_PathTool"), eol(),
        remembering("BO_PathSystem"), eol(),
        remembering("BO_PathProject"), eol(),
        remembering("BO_PathUser"), eol(),
        remembering("PATH"), eol(),
        line(),
    ]


def build():
    return [
        header_activation(),
        _comments(),
        _remember_paths(),
        disabled_content_footer(),
    ]


"""DisabledContent
"""
