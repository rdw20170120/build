from throw_out_your_templates import default_visitors_map
from throw_out_your_templates import get_default_encoding
from throw_out_your_templates import Serializer


class Renderer(object):
    def __init__(self, visitor_map=default_visitors_map, encoding=get_default_encoding()):
        object.__init__(self)
        self._encoding = encoding
        self._visitor_map = visitor_map

    def _get_output(self, content):
        return self._get_serializer().serialize(content)

    def _get_serializer(self):
        return Serializer(self._visitor_map, self._encoding)

    def _print_output(self, output):
        print output.encode(self._encoding)

    def render(self, content, filename=None):
        if filename is None:
            self._print_output(self._get_output(content))
        else:
            with open(filename, 'w') as f:
                f.write(self._get_output(content).encode(self._encoding))


""" Disabled content
"""

