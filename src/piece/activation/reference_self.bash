# Reference our script context
Self="$(getPathAbsolute $BASH_SOURCE)" ; abortOnFail $?
This="$(dirname $Self)"                ; abortOnFail $?
# TODO: Replace with new form (does not require BriteOnyx functions)
# Self="$BASH_SOURCE"
# This="$(dirname $Self)"
