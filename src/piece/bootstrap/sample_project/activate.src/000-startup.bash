# Startup

if [[ -n "$BO_Project" ]] ; then
  echo "Activating..." >$BO_Project/BO.log
else
  echo "Activating..." >$PWD/BO.log
fi

echo "INFO:  Activating the BriteOnyx framework for this project..."
echo "WARN:  This script MUST be executed as 'source activate.src', WAS IT?"
env | sort >./BO-env-incoming.out

