from throw_out_your_templates import default_visitors_map


VISITOR_MAP = default_visitors_map.copy()

class BashScript(object):
    def __init__(self):
        object.__init__(self)
        self._text = []

    def add_debugging_comment(self):
        self.note('Uncomment the following two lines for debugging')
        self.comment('set -o verbose')
        self.comment('set -o xtrace')

    def add_disabled_content_footer(self):
        self.line()
        self.rule()
        self.line(': <<' + self.sq('DisabledContent'))
        self.line('DisabledContent')

    def add_execution_trace(self):
        self.line('''[[ -n "$BO_Trace" ]] && echo "TRACE: Executing '$BASH_SOURCE'"''')

    def add_source_header(self):
        self.shebang_source()
        self.add_execution_trace()
        self.rule()

    def and_(self):
        self.text(' && ')
        return self

    def assign(self, variable_name, expression):
        self.text(variable_name).text('=').text(expression)
        return self

    def bo_log_info(self, text):
        self.text('boLogInfo ' + self.dq(text))
        return self

    def comment(self, comment=None):
        if comment is None: self.line('#')
        else:               self.line('# ' + comment)

    def continue_(self):
        self.text('\\').end_line()

    def dq(self, text):
        """Return text wrapped in double quotes."""
        return '"' + text + '"'

    def echo(self, text):
        self.text('echo ' + text)
        return self

    def echo_fatal(self, text):
        self.echo(self.dq('FATAL: ' + text))
        return self

    def echo_info(self, text):
        self.echo(self.dq('INFO:  ' + text))
        return self

    def echo_warn(self, text):
        self.echo(self.dq('WARN:  ' + text))
        return self

    def elif_(self, condition):
        self.text('elif ').text(condition)
        return self

    def else_(self):
        self.text('else')
        return self

    def end_line(self):
        self.text('\n')

    def exit(self, status):
        self.text('exit ' + str(status))
        return self

    def export(self, variable_name, expression):
        self.text('export ').assign(variable_name, expression)
        return self

    def failed(self):
        self.text('boFailed "$0" "$LINENO" $?')
        return self

    def fi(self):
        self.text('fi')
        return self

    def if_(self, condition):
        self.text('if ').text(condition)
        return self

    def line(self, text=None):
        if text is not None: self.text(text)
        self.end_line()
        return self

    def log_info(self, text):
        self.text('logInfo ' + self.dq(text))
        return self

    def note(self, note):
        self.comment('NOTE: ' + note)

    def or_(self):
        self.text(' || ')
        return self

    def require_directory(self, directory_name):
        self.text('boDirectoryRequire ').text(directory_name)
        return self

    def require_script(self, filename):
        self.text('boScriptRequire ').text(filename)
        return self

    def require_variable(self, variable_name):
        self.text('boVariableRequire ').text(variable_name)
        return self

    def return_(self, status):
        self.text('return ').text(status)
        return self

    def rule(self):
        self.line('#' * 100)

    def seq(self):
        self.text(' ; ')
        return self

    def shebang_execute(self):
        self.line('#!/bin/bash')

    def shebang_source(self):
        self.line('#!/bin/cat')

    def someday(self, task):
        self.todo('SOMEDAY: ' + task)

    def source(self, filename):
        self.text('source ').text(filename)
        return self

    def sq(self, text):
        """Return text wrapped in single quotes."""
        return "'" + text + "'"

    def text(self, text):
        self._text.append(text)
        return self

    def then(self):
        self.text('then')
        return self

    def todo(self, task):
        self.comment('TODO: ' + task)

    def trace_variable(self, variable_name):
        self.text('boTraceVariable ').text(variable_name)
        return self

        
@VISITOR_MAP.register(BashScript)
def visit_bash_script(script, walker):
    walker.walk(script._text)


""" Disabled content
"""

