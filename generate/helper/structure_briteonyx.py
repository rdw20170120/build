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

def echo_fatal(content):
    return echo(dq(['FATAL: ', content]))

def echo_info(content):
    return echo(dq(['INFO:  ', content]))

def echo_warn(content):
    return echo(dq(['WARN:  ', content]))

def execution_trace():
    return line('''[[ -n "$BO_Trace" ]] && echo "TRACE: Executing '$BASH_SOURCE'"''')

def note(content):
    return comment(['NOTE: ', content])

def rule():
    return line('#' * 100)

def someday(task):
    return todo(['SOMEDAY: ', task])

def source_header():
    return [
        shebang_source(),
        execution_trace(),
        rule(),
    ]

def source_script(file_name):
    return [
        assign('Script', file_name), eol(),
        require_script('"$Script"'), or_(), failed(), or_(), return_('$?'), eol(),
        source('         "$Script"'), or_(), failed(), or_(), return_('$?'), eol(),
    ]

def todo(task):
    return comment(['TODO: ', task])

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

class _Log(_Command):
    def __init__(self, command, text):
        _Command.__init__(self, command, dq(text))

def log_debug(text):
    return _Log('logDebug', text)

def log_error(text):
    return _Log('logError', text)

def log_fatal(text):
    return _Log('_logFatal', text)

def log_info(text):
    return _Log('logInfo', text)

def log_warn(text):
    return _Log('logWarn', text)

####################################################################################################

class _BoRequireDirectory(_Command):
    def __init__(self, directory_name):
        _Command.__init__(self, 'boDirectoryRequire', directory_name)

def require_directory(directory_name):
    return _BoRequireDirectory(dq(directory_name))

####################################################################################################

class _BoRequireScript(_Command):
    def __init__(self, file_name):
        _Command.__init__(self, 'boScriptRequire', file_name)

def require_script(file_name):
    return _BoRequireScript(file_name)

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

