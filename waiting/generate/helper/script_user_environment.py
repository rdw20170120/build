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
            note("Declare needed environment variables here"),
            line(),
            comment(
                "TODO: Implement as needed, but defer to $BO_Project/BriteOnyx/env.src for now"
            ),
            line(),
            rule(),
            line(": <<'DisabledContent'"),
            note("Copy this content above, to override system portion of final PATH"),
            line(
                "export BO_PathSystem=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
            ),
            line("DisabledContent" ""),
        ]
    )


VISITOR_MAP = VisitorMap(parent_map=script_bash.VISITOR_MAP)


def render(target_directory, target_file):
    script_bash.render(build(), VISITOR_MAP, target_directory, target_file)


""" Disabled content
"""
