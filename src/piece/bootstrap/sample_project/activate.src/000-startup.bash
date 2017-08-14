# Startup

Dir=$(mktemp --tmpdir -d BO-XXXXXXXX)
[[ -d "$Dir" ]] && export TMPDIR=$Dir

BO_FileLog=BO.log
if [[ -n "$TMPDIR" ]] ; then
  export BO_FileLog=$TMPDIR/$BO_FileLog
elif [[ -n "$BO_Project" ]] ; then
  export BO_FileLog=$BO_Project/$BO_FileLog
else
  export BO_FileLog=$PWD/$BO_FileLog
fi
echo "Activating..." >$BO_FileLog

echo "INFO:  Activating the BriteOnyx framework for this project..."
echo "WARN:  This script MUST be executed as 'source activate.src', WAS IT?"
env | sort >./BO-env-incoming.out

