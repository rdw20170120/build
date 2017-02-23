[[ -n "$BO_Sequence" ]] && echo 'Sequence 005 - verify preconditions'
boVariableRequire 'BO_Project' || boFailed "$BASH_SOURCE" "$LINENO" $? || return $?

