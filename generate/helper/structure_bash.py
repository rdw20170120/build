from script_bash import VISITOR_MAP


####################################################################################################

def and_():
    return ' && '

def continue_():
    return '\\' + end_line()

def dq(text):
    """Return text wrapped in double quotes."""
    return '"' + text + '"'

def echo(text):
    return 'echo ' + text

def elif_(condition):
    return 'elif ' + condition

def else_():
    return 'else'

def end_line():
    return '\n'

def exit(status):
    return 'exit ' + str(status)

def fi():
    return 'fi'

def if_(condition):
    return 'if ' + condition

def line(text=None):
    if text is not None: return text + end_line()
    else:                return end_line()

def or_():
    return ' || '

def return_(status):
    return 'return ' + str(status)

def seq():
    return ' ; '

def shebang_execute():
    return line('#!/bin/bash')

def shebang_source():
    return line('#!/bin/cat')

def source(filename):
    return 'source ' + filename

def sq(text):
    """Return text wrapped in single quotes."""
    return "'" + text + "'"

def then():
    return 'then'

####################################################################################################

class _Assign(object):
    def __init__(self, variable, expression):
        object.__init__(self)
        self.expression = expression
        self.variable = variable

def assign(variable, expression):
    return _Assign(variable, expression)

@VISITOR_MAP.register(_Assign)
def visit_assign(content, walker):
    walker.walk(content.variable)
    walker.emit('=')
    walker.walk(content.expression)

####################################################################################################

class _Comment(object):
    def __init__(self, text):
        object.__init__(self)
        self.text = text

def comment(comment=None):
    if comment is None: return _Comment('#' + end_line())
    else:               return _Comment('# ' + comment + end_line())

@VISITOR_MAP.register(_Comment)
def visit_comment(content, walker):
    walker.walk(content.text)

####################################################################################################

class _Export(object):
    def __init__(self, variable, expression):
        object.__init__(self)
        self.expression = expression
        self.variable = variable

def export(variable, expression):
    return _Export(variable, expression)

@VISITOR_MAP.register(_Export)
def visit_export(content, walker):
    walker.emit('export ')
    walker.walk(content.variable)
    walker.emit('=')
    walker.walk(content.expression)

####################################################################################################
""" Disabled content
"""

