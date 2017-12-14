import os

from renderer import Renderer
from throw_out_your_templates_3_core_visitor_map import VisitorMap
from throw_out_your_templates_4_core_default_visitors import default_visitors_map


class _Assign(object):
    def __init__(self, variable, expression):
        object.__init__(self)
        self.expression = expression
        self.variable = variable

class Script(object):
    def __init__(self):
        object.__init__(self)
        self._content = []

    def add(self, content):
        self._content.append(content)
        return self

    def and_(self):
        return self.text(' && ')

    def assign(self, variable, expression):
        return self.add(_Assign(variable, expression))
        # self.text(variable).text('=').text(expression)

    def comment(self, comment=None):
        if comment is None: self.line('#')
        else:               self.line('# ' + comment)

    def continue_(self):
        self.text('\\').end_line()

    def dq(self, text):
        """Return text wrapped in double quotes."""
        return '"' + text + '"'

    def echo(self, text):
        return self.text('echo ' + text)

    def elif_(self, condition):
        self.text('elif ').text(condition)
        return self

    def else_(self):
        return self.text('else')

    def end_line(self):
        self.text('\n')

    def exit(self, status):
        return self.text('exit ' + str(status))

    def export(self, variable_name, expression):
        self.text('export ').assign(variable_name, expression)
        return self

    def fi(self):
        return self.text('fi')

    def if_(self, condition):
        self.text('if ').text(condition)
        return self

    def line(self, text=None):
        if text is not None: self.text(text)
        self.end_line()
        return self

    def or_(self):
        return self.text(' || ')

    def return_(self, status):
        self.text('return ').text(status)
        return self

    def seq(self):
        return self.text(' ; ')

    def shebang_execute(self):
        self.line('#!/bin/bash')

    def shebang_source(self):
        self.line('#!/bin/cat')

    def source(self, filename):
        self.text('source ').text(filename)
        return self

    def sq(self, text):
        """Return text wrapped in single quotes."""
        return "'" + text + "'"

    def text(self, text):
        return self.add(text)

    def then(self):
        return self.text('then')


def render(script, visitor_map, target_directory, target_file):
    Renderer(visitor_map).render(script, os.path.join(target_directory, target_file))


VISITOR_MAP = VisitorMap(parent_map=default_visitors_map)


@VISITOR_MAP.register(Script)
def visit_script(script, walker):
    walker.walk(script._content)

@VISITOR_MAP.register(_Assign)
def visit_assign(content, walker):
    walker.walk(content.variable)
    walker.emit('=')
    walker.walk(content.expression)


""" Disabled content
"""

