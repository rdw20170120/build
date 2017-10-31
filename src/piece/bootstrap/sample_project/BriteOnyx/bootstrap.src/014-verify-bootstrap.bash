# Verify BriteOnyx bootstrap configuration

boVariableRequire 'BO_Parent'  || boFailed "$0" "$LINENO" $? || return $?
boVariableRequire 'BO_Url'     || boFailed "$0" "$LINENO" $? || return $?
boVariableRequire 'BO_Version' || boFailed "$0" "$LINENO" $? || return $?

