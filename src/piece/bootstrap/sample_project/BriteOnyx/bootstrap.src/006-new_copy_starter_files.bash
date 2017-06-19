# Copy starter files into place as necessary

DirSrc=$BO_Project/BriteOnyx/starter

variableRequire HOME
DirTgt=$HOME
[[ ! -e "$DirTgt" ]] && mkdir -p $DirTgt

FileTgt=$DirTgt/.BriteOnyx.src
# Move previous scripts to new path
[[   -f $DirTgt/BriteOnyx.src      ]] && mv $DirTgt/BriteOnyx.src      $FileTgt
[[   -f $DirTgt/BriteOnyx-env.bash ]] && mv $DirTgt/BriteOnyx-env.bash $FileTgt
[[   -f $DirTgt/BriteOnyx-env.src  ]] && mv $DirTgt/BriteOnyx-env.src  $FileTgt
# Copy starter script, if necessary
[[ ! -f $FileTgt ]] && cp $DirSrc/user-BriteOnyx.src $FileTgt

DirTgt=$BO_Project
[[ ! -e "$DirTgt" ]] && mkdir -p $DirTgt

FileTgt=$DirTgt/env.src
[[ ! -f $FileTgt ]] && cp $DirSrc/project-env.src $FileTgt

FileTgt=$DirTgt/.hgignore
[[ ! -f $FileTgt ]] && cp $DirSrc/project.hgignore $FileTgt

DirTgt=$BO_Project/bin/Linux
[[ ! -e "$DirTgt" ]] && mkdir -p $DirTgt

FileTgt=$DirTgt/project-fix-permissions.bash
# Move previous scripts to new path
[[   -f $DirTgt/all-fix-permissions.bash ]] && mv $DirTgt/all-fix-permissions.bash $FileTgt
# Copy starter script, if necessary
[[ ! -f $FileTgt ]] && cp $DirSrc/project-fix-permissions.bash $FileTgt

: <<'DisabledContent'
FileTgt=$DirTgt/declare.src
[[ ! -f $FileTgt ]] && cp $DirSrc/project-declare.src $FileTgt

FileTgt=$DirTgt/development.rst
[[ ! -f $FileTgt ]] && cp $DirSrc/project-development.rst $FileTgt

FileTgt=$DirTgt/README.rst
[[ ! -f $FileTgt ]] && cp $DirSrc/project-README.rst $FileTgt

DirTgt=$BO_Project/bin/Linux/helper
[[ ! -e $DirTgt ]] && mkdir -p $DirTgt

FileTgt=$DirTgt/declare-BASH.src
[[ ! -f $FileTgt ]] && cp $DirSrc/project-declare-BASH.src $FileTgt
DisabledContent

