from script_bash import VISITOR_MAP


####################################################################################################

def and_():
    return ' && '

def continue_():
    return '\\' + end_line()

def dq(text):
    """Return text wrapped in double quotes."""
    return '"' + text + '"'

def elif_(condition):
    return 'elif ' + condition

def else_():
    return 'else'

def end_line():
    return '\n'

def fi():
    return 'fi'

def if_(condition):
    return 'if ' + condition

def line(text=None):
    if text is not None: return text + end_line()
    else:                return end_line()

def or_():
    return ' || '

def seq():
    return ' ; '

def sq(text):
    """Return text wrapped in single quotes."""
    return "'" + text + "'"

def then():
    return 'then'

####################################################################################################

class _Statement(object):
    def __init__(self, statement):
        object.__init__(self)
        self.statement = statement

@VISITOR_MAP.register(_Statement)
def visit_statement(element, walker):
    walker.walk(element.statement)

####################################################################################################

class _Command(_Statement):
    def __init__(self, command, arguments=None):
        _Statement.__init__(self, '_Command')
        self.arguments = arguments
        self.command = command

@VISITOR_MAP.register(_Command)
def visit_command(element, walker):
    walker.walk(element.command)
    if element.arguments is not None:
        walker.emit(' ')
        walker.walk(element.arguments)

####################################################################################################

class _Assign(_Command):
    def __init__(self, variable, expression, command=None):
        if command is None: _Command.__init__(self, '_Assign')
        else:               _Command.__init__(self, command)
        self.expression = expression
        self.variable = variable

def assign(variable, expression):
    return _Assign(variable, expression)

@VISITOR_MAP.register(_Assign)
def visit_assign(element, walker):
    walker.walk(element.variable)
    walker.emit('=')
    walker.walk(element.expression)

####################################################################################################

class _Comment(_Statement):
    def __init__(self, comment):
        _Statement.__init__(self, '_Comment')
        self.comment = comment

def comment(comment=None):
    if comment is None: return _Comment('')
    else:               return _Comment(' ' + comment)

@VISITOR_MAP.register(_Comment)
def visit_comment(element, walker):
    walker.emit('#')
    walker.walk(element.comment)
    walker.emit('\n')

####################################################################################################

class _Echo(_Command):
    def __init__(self, arguments):
        _Command.__init__(self, 'echo', arguments)

def echo(arguments):
    return _Echo(arguments)

####################################################################################################

def exit(status):
    return 'exit ' + str(status)

####################################################################################################

class _Export(_Assign):
    def __init__(self, variable, expression):
        _Assign.__init__(self, variable, expression, 'export')

def export(variable, expression):
    return _Export(variable, expression)

@VISITOR_MAP.register(_Export)
def visit_export(element, walker):
    walker.emit(element.command)
    walker.emit(' ')
    walker.walk(element.variable)
    walker.emit('=')
    walker.walk(element.expression)

####################################################################################################

def return_(status):
    return 'return ' + str(status)

####################################################################################################

class _Shebang(_Comment):
    def __init__(self, comment):
        _Comment.__init__(self, comment)

def shebang_execute():
    return _Shebang(_Command('/bin/bash'))

def shebang_source():
    return _Shebang(_Command('/bin/cat'))

@VISITOR_MAP.register(_Shebang)
def visit_comment(element, walker):
    walker.emit('#!')
    walker.walk(element.comment)
    walker.emit('\n')

####################################################################################################

def source(filename):
    return 'source ' + filename

####################################################################################################

####################################################################################################

####################################################################################################

####################################################################################################

####################################################################################################
""" Disabled content
"""

