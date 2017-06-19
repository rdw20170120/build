# Verify BriteOnyx bootstrap configuration

boVariableRequire   BO_Home || boFailed "$BASH_SOURCE" "$LINENO" $? || return $?
boDirectoryRequire $BO_Home || boFailed "$BASH_SOURCE" "$LINENO" $? || return $?

boVariableRequire BO_ProjectName || boFailed "$BASH_SOURCE" "$LINENO" $? || return $?

