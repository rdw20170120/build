[[ -n "$BO_Sequence" ]] && echo 'Sequence 000 - skip'
# Skip if BriteOnyx is already activated

Msg='$BO_Home is defined, assuming BriteOnyx already activated'
[[ -n "$BO_Home" ]] && logDebug "$Msg" && return 0

