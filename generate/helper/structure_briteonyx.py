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

def echo_fatal(*elements):
    return echo(dq('FATAL: ', *elements))

def echo_info(*elements):
    return echo(dq('INFO:  ', *elements))

def echo_warn(*elements):
    return echo(dq('WARN:  ', *elements))

def execution_trace():
    return line('''[[ -n "$BO_Trace" ]] && echo "TRACE: Executing '$BASH_SOURCE'"''')

def note(*elements):
    return comment('NOTE: ', *elements)

def rule():
    return line('#' * 100)

def someday(*elements):
    return todo('SOMEDAY: ', *elements)

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

def todo(*elements):
    return comment('TODO: ', *elements)

####################################################################################################

class _BoLogInfo(_Command):
    def __init__(self, *elements):
        _Command.__init__(self, 'boLogInfo', dq(elements))

def bo_log_info(*elements):
    return _BoLogInfo(*elements)

####################################################################################################

class _Failed(_Command):
    def __init__(self):
        _Command.__init__(self, 'boFailed', dq('$0'), dq('$LINENO'), '$?')

def failed():
    return _Failed()

####################################################################################################

class _Log(_Command):
    def __init__(self, command, *elements):
        _Command.__init__(self, command, dq(elements))

def log_debug(*elements):
    return _Log('logDebug', *elements)

def log_error(*elements):
    return _Log('logError', *elements)

def log_fatal(*elements):
    return _Log('_logFatal', *elements)

def log_info(*elements):
    return _Log('logInfo', *elements)

def log_warn(*elements):
    return _Log('logWarn', *elements)

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

