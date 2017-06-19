# Copy starter files into place as necessary

DirSrc=$BO_Project/BriteOnyx/starter
DirTgt=$BO_Project

[[ ! -f $DirTgt/.hgignore ]] && cp $DirSrc/project.hgignore $DirTgt/sample.hgignore

FileTgt=$DirTgt/declare.src
[[ ! -f $FileTgt ]] && cp $DirSrc/project-declare.src $FileTgt

FileTgt=$DirTgt/development.rst
[[ ! -f $FileTgt ]] && cp $DirSrc/project-development.rst $FileTgt

FileTgt=$DirTgt/env.src
[[ ! -f $FileTgt ]] && cp $DirSrc/project-env.src $FileTgt

FileTgt=$DirTgt/README.rst
[[ ! -f $FileTgt ]] && cp $DirSrc/project-README.rst $FileTgt

DirTgt=$BO_Project/bin/Linux
FileTgt=$DirTgt/all-fix-permissions.bash
[[ ! -f $FileTgt ]] && cp $DirSrc/project-all-fix-permissions.bash $FileTgt

DirTgt=$BO_Project/bin/Linux/helper
[[ ! -e $DirTgt ]] && mkdir -p $DirTgt
FileTgt=$DirTgt/declare-BASH.src
[[ ! -f $FileTgt ]] && cp $DirSrc/project-declare-BASH.src $FileTgt

DirTgt=$HOME
FileTgt=$DirTgt/.BriteOnyx.src
# Move previous scripts to new path
[[   -f $DirTgt/BriteOnyx-env.bash ]] && mv $DirTgt/BriteOnyx-env.bash $FileTgt
[[   -f $DirTgt/BriteOnyx-env.src  ]] && mv $DirTgt/BriteOnyx-env.src  $FileTgt
[[ ! -f $FileTgt ]] && cp $DirSrc/user-BriteOnyx.src $FileTgt

