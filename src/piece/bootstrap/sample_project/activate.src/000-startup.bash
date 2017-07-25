# Startup

if [[ -n "$BO_Home" ]] ; then
  echo "Activating..." >$BO_Home/BO.log
else
  echo "Activating..." >$PWD/BO.log
fi

echo "INFO:  Activating the BriteOnyx framework for this project..."
echo "WARN:  This script MUST be executed as 'source activate.src', WAS IT?"
env | sort >./BO-env-incoming.out

