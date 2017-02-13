# Checkout the BriteOnyx source

boDirectoryCreate "$BO_Parent" || boFailed "$BASH_SOURCE" "$LINENO" $? || return $?

[[ -z "$BO_Home" ]] && export BO_Home=$(boNodeCanonical "$BO_Parent/$BO_Version")
boVariableRequire 'BO_Home' || boFailed "$BASH_SOURCE" "$LINENO" $? || return $?

if boDirectoryExists "$BO_Home" ; then
  boLogDebug "Directory '$BO_Home' already exists, skipping Mercurial clone."
elif [[ "$BO_Version" == "predeployed" ]]; then
  boLogWarn "Ignoring Mercurial clone of version '$BO_Version'"
else
  boLogInfo "Cloning version '$BO_Version' from '$BO_Url' into '$BO_Home'..."
  Cmd="hg clone"
  Cmd+=" --rev $BO_Version"
  Cmd+=" $BO_Url"
  Cmd+=" $BO_Home"
  Msg="Mercurial failed to clone into directory '$BO_Home'!"
  boExecute "$Cmd" "$Msg" || boFailed "$BASH_SOURCE" "$LINENO" $? || return $?
fi

boDirectoryRequire "$BO_Home" || boFailed "$BASH_SOURCE" "$LINENO" $? || return $?

if [[ "$BO_Version" == "tip" ]]; then
  # Update Mercurial clone of 'tip' to support development of BriteOnyx framework
  boLogInfo "Updating clone of version '$BO_Version' from '$BO_Url' into '$BO_Home'..."
  cd "$BO_Home" || boFailed "$BASH_SOURCE" "$LINENO" $? || return $?
  Cmd="hg pull --update"
  Msg="Mercurial failed to update clone in directory '$BO_Home'!"
  boExecute "$Cmd" "$Msg" || boFailed "$BASH_SOURCE" "$LINENO" $? || return $?
else
  boLogDebug "BriteOnyx version '$BO_Version' should be stable, skipping update of clone."
fi

