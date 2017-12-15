import script_bash
import script_briteonyx

from throw_out_your_templates_3_core_visitor_map import VisitorMap

from structure_bash import *
from structure_briteonyx import *


class Script(script_briteonyx.Script):
    def __init__(self):
        script_briteonyx.Script.__init__(self)

    def generate(self):
        self.add(add_source_header())
        self.add(comment('Configure this project'))
        self.add(line())
        self.add(comment('TODO: Implement'))
        self.add(line('export BO_ProjectName=TODO'))
        self.add(add_disabled_content_footer())


def build():
    script = Script()
    script.generate()
    return script
    

VISITOR_MAP = VisitorMap(parent_map=script_bash.VISITOR_MAP)


def render(target_directory, target_file):
    script_bash.render(build(), VISITOR_MAP, target_directory, target_file)


""" Disabled content
"""

