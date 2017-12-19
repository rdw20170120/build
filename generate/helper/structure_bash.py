from script_bash import VISITOR_MAP


####################################################################################################

def and_():
    return ' && '

def elif_(condition):
    return ['elif ', condition]

def else_():
    return 'else'

def eol():
    return '\n'

def fi():
    return 'fi'

def if_(condition):
    return ['if ', condition]

def line(text=None):
    return [text, eol()]

def nl():
    return line('\\')

def or_():
    return ' || '

def pipe():
    return ' | '

def seq():
    return ' ; '

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

class _Arguments(object):
    def __init__(self, arguments):
        object.__init__(self)
        self.arguments = arguments

@VISITOR_MAP.register(_Arguments)
def visit_arguments(element, walker):
    if element.arguments is not None:
        for a in element.arguments:
            walker.emit(' ')
            walker.walk(a)

class _Command(_Statement):
    def __init__(self, command, arguments=None):
        _Statement.__init__(self, '_Command')
        if arguments is None:             self.arguments = None
        elif isinstance(arguments, list): self.arguments = _Arguments(arguments)
        else:                             self.arguments = _Arguments([arguments,])
        self.command = command

@VISITOR_MAP.register(_Command)
def visit_command(element, walker):
    walker.walk(element.command)
    walker.walk(element.arguments)

def command(command, arguments=None):
    return _Command(command, arguments)

####################################################################################################

class _Assign(_Command):
    def __init__(self, variable, expression, command=None):
        if command is None: _Command.__init__(self, '_Assign')
        else:               _Command.__init__(self, command)
        self.expression = expression
        self.variable = variable

@VISITOR_MAP.register(_Assign)
def visit_assign(element, walker):
    walker.walk(element.variable)
    walker.emit('=')
    walker.walk(element.expression)

def assign(variable, expression):
    return _Assign(variable, expression)

####################################################################################################

class _Comment(_Statement):
    def __init__(self, content):
        _Statement.__init__(self, '_Comment')
        self.content = content

@VISITOR_MAP.register(_Comment)
def visit_comment(element, walker):
    walker.emit('#')
    walker.walk(element.content)
    walker.emit('\n')

def comment(content=None):
    if content is None: return _Comment(None)
    else:               return _Comment([' ', content])

####################################################################################################

class _Condition(_Command):
    def __init__(self, arguments):
        arguments.append(']]')
        _Command.__init__(self, '[[', arguments)

def directory_exists(directory_name):
    return _Condition(['-d', dq(directory_name), ])

def file_exists(filename):
    return _Condition(['-f', dq(filename), ])

def path_does_not_exist(pathname):
    return _Condition(['!', '-e', dq(pathname), ])

def path_is_not_file(pathname):
    return _Condition(['!', '-f', dq(pathname), ])

def string_is_not_null(expression):
    return _Condition(['-n', dq(expression), ])

def string_is_null(expression):
    return _Condition(['-z', dq(expression), ])

####################################################################################################

class _Echo(_Command):
    def __init__(self, arguments):
        _Command.__init__(self, 'echo', arguments)

def echo(arguments):
    return _Echo(arguments)

####################################################################################################

class _Exit(_Command):
    def __init__(self, arguments):
        _Command.__init__(self, 'exit', arguments)

def exit(status):
    return _Exit(status)

####################################################################################################

class _Export(_Assign):
    def __init__(self, variable, expression):
        _Assign.__init__(self, variable, expression, 'export')

@VISITOR_MAP.register(_Export)
def visit_export(element, walker):
    walker.emit(element.command)
    walker.emit(' ')
    walker.walk(element.variable)
    walker.emit('=')
    walker.walk(element.expression)

def export(variable, expression):
    return _Export(variable, expression)

####################################################################################################

class _Return(_Command):
    def __init__(self, arguments):
        _Command.__init__(self, 'return', arguments)

def return_(status):
    return _Return(status)

def return_last_status():
    return return_('$?')

####################################################################################################

class _Shebang(_Comment):
    def __init__(self, content):
        _Comment.__init__(self, content)

@VISITOR_MAP.register(_Shebang)
def visit_comment(element, walker):
    walker.emit('#!')
    walker.walk(element.content)
    walker.emit('\n')

def shebang_execute():
    return _Shebang(_Command('/bin/bash'))

def shebang_source():
    return _Shebang(_Command('/bin/cat'))

####################################################################################################

class _Source(_Command):
    def __init__(self, arguments):
        _Command.__init__(self, 'source', arguments)

def source(filename):
    return _Source(filename)

####################################################################################################

class _DoubleQuoted(object):
    def __init__(self, content):
        object.__init__(self)
        self.content = content

@VISITOR_MAP.register(_DoubleQuoted)
def visit_double_quoted(element, walker):
    walker.emit('"')
    walker.walk(element.content)
    walker.emit('"')

def dq(content):
    return _DoubleQuoted(content)

####################################################################################################

class _SingleQuoted(object):
    def __init__(self, content):
        object.__init__(self)
        self.content = content

@VISITOR_MAP.register(_SingleQuoted)
def visit_single_quoted(element, walker):
    walker.emit("'")
    walker.walk(element.content)
    walker.emit("'")

def sq(content):
    return _SingleQuoted(content)

####################################################################################################
""" Disabled content
"""

