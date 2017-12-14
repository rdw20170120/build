import script_bash
import script_briteonyx

from throw_out_your_templates_3_core_visitor_map import VisitorMap


class Script(script_briteonyx.Script):
    def __init__(self):
        script_briteonyx.Script.__init__(self)

    def generate(self):
        self.add_source_header()
        self.note('Declare needed environment variables here')
        self.line()
        self.comment('TODO: Implement as needed, but defer to $BO_Project/BriteOnyx/env.src for now')
        self.line()
        self.rule()
        self.line(": <<'DisabledContent'")
        self.note('Copy this content above, to override system portion of final PATH')
        self.line('export BO_PathSystem=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin')
        self.line('DisabledContent''')


VISITOR_MAP = VisitorMap(parent_map=script_bash.VISITOR_MAP)


def build():
    script = Script()
    script.generate()
    return script
    
def render(target_directory, target_file):
    script_bash.render(build(), VISITOR_MAP, target_directory, target_file)


""" Disabled content
"""

