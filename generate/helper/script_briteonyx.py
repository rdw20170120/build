import script_bash

from throw_out_your_templates_3_core_visitor_map import VisitorMap


class Script(script_bash.Script):
    def __init__(self):
        script_bash.Script.__init__(self)

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

    def bo_log_info(self, text):
        return self.text('boLogInfo ' + self.dq(text))

    def echo_fatal(self, text):
        return self.echo(self.dq('FATAL: ' + text))

    def echo_info(self, text):
        return self.echo(self.dq('INFO:  ' + text))

    def echo_warn(self, text):
        return self.echo(self.dq('WARN:  ' + text))

    def failed(self):
        return self.text('boFailed "$0" "$LINENO" $?')

    def log_info(self, text):
        return self.text('logInfo ' + self.dq(text))

    def note(self, note):
        self.comment('NOTE: ' + note)

    def require_directory(self, directory_name):
        self.text('boDirectoryRequire ').text(directory_name)
        return self

    def require_script(self, filename):
        self.text('boScriptRequire ').text(filename)
        return self

    def require_variable(self, variable_name):
        self.text('boVariableRequire ').text(variable_name)
        return self

    def rule(self):
        self.line('#' * 100)

    def someday(self, task):
        self.todo('SOMEDAY: ' + task)

    def todo(self, task):
        self.comment('TODO: ' + task)

    def trace_variable(self, variable_name):
        return self.text('boTraceVariable ').text(variable_name)


VISITOR_MAP = VisitorMap(parent_map=script_bash.VISITOR_MAP)


""" Disabled content
"""

