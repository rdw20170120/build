import script_bash
import script_briteonyx

from throw_out_your_templates_3_core_visitor_map import VisitorMap

from structure_bash import *
from structure_briteonyx import *


class Script(script_briteonyx.Script):
    def __init__(self):
        script_briteonyx.Script.__init__(self)

    def generate(self):
        self.add(source_header())
        self.add(note('Declare needed environment variables here'))
        self.add(line())
        self.add(comment('TODO: Implement as needed, but defer to $BO_Project/BriteOnyx/env.src for now'))
        self.add(line())
        self.add(rule())
        self.add(line(": <<'DisabledContent'"))
        self.add(note('Copy this content above, to override system portion of final PATH'))
        self.add(line('export BO_PathSystem=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'))
        self.add(line('DisabledContent'''))


def build():
    script = Script()
    script.generate()
    return script
    

VISITOR_MAP = VisitorMap(parent_map=script_bash.VISITOR_MAP)


def render(target_directory, target_file):
    script_bash.render(build(), VISITOR_MAP, target_directory, target_file)


""" Disabled content
"""

