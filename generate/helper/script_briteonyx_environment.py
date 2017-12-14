import script_bash
import script_briteonyx

from throw_out_your_templates_3_core_visitor_map import VisitorMap


class Script(script_briteonyx.Script):
    def __init__(self):
        script_briteonyx.Script.__init__(self)

    def generate(self):
        self.add_source_header()
        self.comment('Configure BriteOnyx deployment')
        self.someday('Keep BO_Version updated to latest published revision')
        self.line()
        self.text('[[ -z "$BO_Parent"  ]] &&')
        self.line(' export BO_Parent=$HOME/.BO')
        self.text('[[ -z "$BO_Version" ]] &&')
        self.line(' export BO_Version=rev36')
        self.text('[[ -z "$BO_Home"    ]] &&')
        self.line(' export BO_Home=$BO_Parent/$BO_Version')
        self.line()
        self.line("alias functions='declare -F | sort'")
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

