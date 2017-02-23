[[ -n "$BO_Sequence" ]] && echo 'Sequence 008 - verify preconditions'
boVariableRequire 'BO_Project' || boFailed "$BASH_SOURCE" "$LINENO" $? || return $?

