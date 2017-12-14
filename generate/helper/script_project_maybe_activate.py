import script_bash
import script_briteonyx

from throw_out_your_templates_3_core_visitor_map import VisitorMap


class Script(script_briteonyx.Script):
    def __init__(self):
        script_briteonyx.Script.__init__(self)

    def generate(self):
        self.add_source_header()
        self.note("We MUST NOT EVER 'exit' during BriteOnyx bootstrap or activation")
        self.rule()
        self.note('Uncomment the following two lines for debugging')
        self.comment('set -o verbose')
        self.comment('set -o xtrace')
        self.someday('Add inverse commands to isolate debugging')
        self.line()
        self.rule()
        self.comment('Skip if BriteOnyx is already activated')
        self.line()
        self.line("Msg='$BO_Home is defined, assuming BriteOnyx already activated'")
        self.text('[[ -n "$BO_Home" ]] &&')
        self.text(' logDebug "$Msg" &&')
        self.line(' return 0')
        self.line()
        self.rule()
        self.comment('Activate BriteOnyx')
        self.line()
        self.line('Script="$(dirname "$0")/../activate.src"')
        self.text('[[ ! -f "$Script" ]] &&')
        self.text(''' echo "FATAL: Missing script '$Script'" &&''')
        self.line(' return 63')
        self.text('source "$Script";')
        self.line(' Status=$?')
        self.line('''Msg="FATAL: Status $Status at '$0:$LINENO'"''')
        self.text('[[ $Status -ne 0 ]] &&')
        self.text(' echo "$Msg" &&')
        self.line(' return $Status')
        self.line()
        self.rule()
        self.comment('Verify post-conditions')
        self.line()
        self.text('boVariableRequire   BO_Home ||')
        self.text(' boFailed "$0" "$LINENO" $? ||')
        self.line(' return $?')
        self.text('boDirectoryRequire $BO_Home ||')
        self.text(' boFailed "$0" "$LINENO" $? ||')
        self.line(' return $?')
        self.line()
        self.text('boVariableRequire   BO_Project ||')
        self.text(' boFailed "$0" "$LINENO" $? ||')
        self.line(' return $?')
        self.text('boDirectoryRequire $BO_Project ||')
        self.text(' boFailed "$0" "$LINENO" $? ||')
        self.line(' return $?')
        self.line()
        self.rule()
        self.comment("Successfully 'return', but do NOT 'exit'")
        self.line('return 0')
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

