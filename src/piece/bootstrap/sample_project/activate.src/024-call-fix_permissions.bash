# Fix file permissions throughout project

Script="$BO_Project/bin/all-fix-permissions.bash"
boScriptRequire "$Script" || boFailed "$BASH_SOURCE" "$LINENO" $? || return $?
                "$Script" || boFailed "$BASH_SOURCE" "$LINENO" $? || return $?

