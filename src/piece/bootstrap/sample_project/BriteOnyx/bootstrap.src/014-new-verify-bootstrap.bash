[[ -n "$BO_Sequence" ]] && echo 'Sequence 014 - new verify bootstrap'
# Verify BriteOnyx bootstrap configuration

boVariableRequire   BO_Home || boFailed "$BASH_SOURCE" "$LINENO" $? || return $?
boDirectoryRequire $BO_Home || boFailed "$BASH_SOURCE" "$LINENO" $? || return $?

boVariableRequire BO_PathSystem || boFailed "$BASH_SOURCE" "$LINENO" $? || return $?

# TODO: Implement additional verifications?

