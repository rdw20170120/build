# Verify post-conditions

boVariableRequire   'BO_Home' || boFailed "$BASH_SOURCE" "$LINENO" $? || return $?
boDirectoryRequire "$BO_Home" || boFailed "$BASH_SOURCE" "$LINENO" $? || return $?

