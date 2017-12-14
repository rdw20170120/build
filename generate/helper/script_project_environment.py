import script_bash
import script_briteonyx

from throw_out_your_templates_3_core_visitor_map import VisitorMap


class Script(script_briteonyx.Script):
    def __init__(self):
        script_briteonyx.Script.__init__(self)

    def generate(self):
        self.add_source_header()
        self.comment('Configure this project')
        self.line()
        self.comment('TODO: Implement')
        self.line('export BO_ProjectName=TODO')
        self.add_disabled_content_footer()


VISITOR_MAP = VisitorMap(parent_map=script_bash.VISITOR_MAP)


def build():
    script = Script()
    script.generate()
    return script
    
def render(target_directory, target_file):
    script_bash.render(build(), VISITOR_MAP, target_directory, target_file)


""" Disabled content
"""

