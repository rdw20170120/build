# Verify post-conditions

boVariableRequire   BO_Home || boFailed "$0" "$LINENO" $? || return $?
boDirectoryRequire $BO_Home || boFailed "$0" "$LINENO" $? || return $?

boVariableRequire   BO_Project || boFailed "$0" "$LINENO" $? || return $?
boDirectoryRequire $BO_Project || boFailed "$0" "$LINENO" $? || return $?

