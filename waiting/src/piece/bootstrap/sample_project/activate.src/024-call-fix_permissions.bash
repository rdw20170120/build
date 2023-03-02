# Fix file permissions throughout project

Script="$BO_Project/bin/all-fix-permissions.bash"
boScriptRequire "$Script" || boFailed "$0" "$LINENO" $? || return $?
                "$Script" || boFailed "$0" "$LINENO" $? || return $?

