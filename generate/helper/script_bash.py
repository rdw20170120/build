from throw_out_your_templates import default_visitors_map


VISITOR_MAP = default_visitors_map.copy()

class BashScript(object):
    def __init__(self):
        object.__init__(self)
        self._text = []

    def add_blank_comment(self):
        self.add_line('#')

    def add_blank_line(self):
        self.add_text('\n')

    def add_comment(self, comment):
        self.add_line('# ' + comment)

    def add_debugging_comment(self):
        self.add_note('Uncomment the following two lines for debugging')
        self.add_comment('set -o verbose')
        self.add_comment('set -o xtrace')

    def add_disabled_content_footer(self):
        self.add_blank_line()
        self.add_rule()
        self.add_line(": <<'DisabledContent'")
        self.add_line('DisabledContent')

    def add_execute_shebang(self):
        self.add_line('#!/bin/bash')

    def add_execution_trace(self):
        self.add_line('''[[ -n "$BO_Trace" ]] && echo "TRACE: Executing '$BASH_SOURCE'"''')

    def add_line(self, text):
        self.add_text(text + '\n')

    def add_note(self, note):
        self.add_comment('NOTE: ' + note)

    def add_rule(self):
        self.add_line('#' * 100)

    def add_someday(self, task):
        self.add_todo('SOMEDAY: ' + task)

    def add_source_header(self):
        self.add_source_shebang()
        self.add_execution_trace()
        self.add_rule()

    def add_source_shebang(self):
        self.add_line('#!/bin/cat')

    def add_text(self, text):
        self._text.append(text)

    def add_todo(self, task):
        self.add_comment('TODO: ' + task)

        
@VISITOR_MAP.register(BashScript)
def visit_bash_script(script, walker):
    walker.walk(script._text)


""" Disabled content
"""

