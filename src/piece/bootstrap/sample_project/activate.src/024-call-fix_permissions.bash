[[ -n "$BO_Sequence" ]] && echo 'Sequence 024 - call fix_permissions'
# Fix file permissions throughout project

Script="$BO_Project/bin/Linux/all-fix-permissions.bash"
boScriptRequire "$Script" || boFailed "$BASH_SOURCE" "$LINENO" $? || return $?
                "$Script" || boFailed "$BASH_SOURCE" "$LINENO" $? || return $?

