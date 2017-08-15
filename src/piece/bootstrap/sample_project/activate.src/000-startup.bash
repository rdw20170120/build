# Create random TMPDIR
Dir=$(mktemp --tmpdir -d BO-XXXXXXXX)
[[ -d "$Dir" ]] && export TMPDIR=$Dir

# Initialize BriteOnyx logging file
BO_FileLog=BO.log
if [[ -n "$TMPDIR" ]] ; then
  export BO_FileLog=$TMPDIR/$BO_FileLog
elif [[ -n "$BO_Project" ]] ; then
  export BO_FileLog=$BO_Project/$BO_FileLog
else
  export BO_FileLog=$PWD/$BO_FileLog
fi
echo "INFO:  Activating..." >$BO_FileLog
echo "INFO:  Activating the BriteOnyx framework for this project..."
echo "WARN:  This script MUST be executed as 'source activate.src', WAS IT?"

# Capture incoming BASH environment
if [[ -n "$TMPDIR" ]] ; then
  env | sort >$TMPDIR/BO-env-incoming.out
elif [[ -n "$BO_Project" ]] ; then
  env | sort >$BO_Project/BO-env-incoming.out
else
  env | sort >$PWD/BO-env-incoming.out
fi

