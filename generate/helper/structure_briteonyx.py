from script_briteonyx import VISITOR_MAP
from structure_bash import _Command

from structure_bash import *


####################################################################################################

def debugging_comment():
    return [
        note('Uncomment the following two lines for debugging'),
        comment('set -o verbose'),
        comment('set -o xtrace'),
    ]

def disabled_content_footer():
    return [
        line(),
        rule(),
        ': <<', line(sq('DisabledContent')),
        line('DisabledContent'),
    ]

def echo_fatal(text):
    return echo(dq('FATAL: ' + text))

def echo_info(text):
    return echo(dq('INFO:  ' + text))

def echo_warn(text):
    return echo(dq('WARN:  ' + text))

def execution_trace():
    return line('''[[ -n "$BO_Trace" ]] && echo "TRACE: Executing '$BASH_SOURCE'"''')

def note(note):
    return comment('NOTE: ' + note)

def rule():
    return line('#' * 100)

def someday(task):
    return todo('SOMEDAY: ' + task)

def source_header():
    return [
        shebang_source(),
        execution_trace(),
        rule(),
    ]

def todo(task):
    return comment('TODO: ' + task)

####################################################################################################

class _BoLogInfo(_Command):
    def __init__(self, text):
        _Command.__init__(self, 'boLogInfo', dq(text))

def bo_log_info(text):
    return _BoLogInfo(text)

####################################################################################################

class _Failed(_Command):
    def __init__(self):
        _Command.__init__(self, 'boFailed', [dq('$0'), dq('$LINENO'), '$?'])

def failed():
    return _Failed()

####################################################################################################

class _LogInfo(_Command):
    def __init__(self, text):
        _Command.__init__(self, 'logInfo', dq(text))

def log_info(text):
    return _LogInfo(text)

####################################################################################################

class _BoRequireDirectory(_Command):
    def __init__(self, directory_name):
        _Command.__init__(self, 'boDirectoryRequire', directory_name)

def require_directory(directory_name):
    return _BoRequireDirectory(directory_name)

####################################################################################################

class _BoRequireScript(_Command):
    def __init__(self, filename):
        _Command.__init__(self, 'boScriptRequire', filename)

def require_script(filename):
    return _BoRequireScript(filename)

####################################################################################################

class _BoRequireVariable(_Command):
    def __init__(self, variable_name):
        _Command.__init__(self, 'boVariableRequire', variable_name)

def require_variable(variable_name):
    return _BoRequireVariable(variable_name)

####################################################################################################

class _BoTraceVariable(_Command):
    def __init__(self, variable_name):
        _Command.__init__(self, 'boTraceVariable', variable_name)

def trace_variable(variable_name):
    return _BoTraceVariable(variable_name)

####################################################################################################
""" Disabled content
"""

