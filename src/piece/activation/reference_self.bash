# Reference our script context
Self="$(getPathAbsolute $0)" ; abortOnFail $0 $LINENO $?
This="$(dirname $Self)"      ; abortOnFail $0 $LINENO $?

