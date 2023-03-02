# Shutdown

logInfo "Project '$BO_ProjectName' in directory '$BO_Project' is now activated, done."

# Capture outgoing BASH environment
if [[ -n "$TMPDIR" ]] ; then
  env | sort >$TMPDIR/BO-env-outgoing.out
elif [[ -n "$BO_Project" ]] ; then
  env | sort >$BO_Project/BO-env-outgoing.out
else
  env | sort >$PWD/BO-env-outgoing.out
fi

