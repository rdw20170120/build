# Verify BriteOnyx bootstrap configuration

boVariableRequire   BO_Home || boFailed "$0" "$LINENO" $? || return $?
boDirectoryRequire $BO_Home || boFailed "$0" "$LINENO" $? || return $?

boVariableRequire BO_ProjectName || boFailed "$0" "$LINENO" $? || return $?

