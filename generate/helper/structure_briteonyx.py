from script_briteonyx import VISITOR_MAP

from structure_bash import *


####################################################################################################

def add_debugging_comment(script):
    script.add(note('Uncomment the following two lines for debugging'))
    script.add(comment('set -o verbose'))
    script.add(comment('set -o xtrace'))

def add_disabled_content_footer():
    return line() + rule() + line(': <<' + sq('DisabledContent')) + line('DisabledContent')

def add_execution_trace():
    return line('''[[ -n "$BO_Trace" ]] && echo "TRACE: Executing '$BASH_SOURCE'"''')

def add_source_header():
    return shebang_source() + add_execution_trace() + rule()

def bo_log_info(text):
    return 'boLogInfo ' + dq(text)

def echo_fatal(text):
    return echo(dq('FATAL: ' + text))

def echo_info(text):
    return echo(dq('INFO:  ' + text))

def echo_warn(text):
    return echo(dq('WARN:  ' + text))

def failed():
    return 'boFailed "$0" "$LINENO" $?'

def log_info(text):
    return 'logInfo ' + dq(text)

def note(note):
    return comment('NOTE: ' + note)

def require_directory(directory_name):
    return 'boDirectoryRequire ' + directory_name

def require_script(filename):
    return 'boScriptRequire ' + filename

def require_variable(variable_name):
    return 'boVariableRequire ' + variable_name

def rule():
    return line('#' * 100)

def someday(task):
    return todo('SOMEDAY: ' + task)

def todo(task):
    return comment('TODO: ' + task)

def trace_variable(variable_name):
    return 'boTraceVariable ' + variable_name

####################################################################################################
""" Disabled content
"""

