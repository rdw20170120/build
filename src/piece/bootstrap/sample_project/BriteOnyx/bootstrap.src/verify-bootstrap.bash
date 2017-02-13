# Verify BriteOnyx bootstrap configuration

boVariableRequire 'BO_Parent'  || boFailed "$BASH_SOURCE" "$LINENO" $? || return $?
boVariableRequire 'BO_Url'     || boFailed "$BASH_SOURCE" "$LINENO" $? || return $?
boVariableRequire 'BO_Version' || boFailed "$BASH_SOURCE" "$LINENO" $? || return $?

