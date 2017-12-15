import script_bash
import script_briteonyx

from throw_out_your_templates_3_core_visitor_map import VisitorMap

from structure_bash import *
from structure_briteonyx import *


class Script(script_briteonyx.Script):
    def __init__(self):
        script_briteonyx.Script.__init__(self)

    def generate(self):
        self.add(source_header())
        self.add(note("We MUST NOT EVER 'exit' during BriteOnyx bootstrap or activation"))
        self.add(rule())
        self.add(note('Uncomment the following two lines for debugging'))
        self.add(comment('set -o verbose'))
        self.add(comment('set -o xtrace'))
        self.add(someday('Add inverse commands to isolate debugging'))
        self.add(line())
        self.add(rule())
        self.add(comment('Verify pre-conditions'))
        self.add(line())
        self.add('[[   -z "$BO_Home"          ]] &&')
        self.add(" echo 'FATAL: Missing $BO_Home'                &&")
        self.add(line(' return 63'))
        self.add('[[ ! -d "$BO_Home"          ]] &&')
        self.add(''' echo "FATAL: Missing directory '$BO_Home'"    &&''')
        self.add(line(' return 63'))
        self.add('[[   -z "$BO_Project"       ]] &&')
        self.add(" echo 'FATAL: Missing $BO_Project'             &&")
        self.add(line(' return 63'))
        self.add('[[ ! -d "$BO_Project"       ]] &&')
        self.add(''' echo "FATAL: Missing directory '$BO_Project'" &&''')
        self.add(line(' return 63'))
        self.add('[[   -z "$BO_GradleVersion" ]] &&')
        self.add(''' echo 'FATAL: Missing $BO_GradleVersion'       &&''')
        self.add(line(' return 63'))
        self.add('[[   -z "$BO_PathSystem"    ]] &&')
        self.add(''' echo 'FATAL: Missing $BO_PathSystem'          &&''')
        self.add(line(' return 63'))
        self.add('[[   -z "$JAVA_HOME"        ]] &&')
        self.add(''' echo 'FATAL: Missing $JAVA_HOME'              &&''')
        self.add(line(' return 63'))
        self.add(line())
        self.add(line('Dir=$BO_Home/activation'))
        self.add('[[ ! -d "${Dir}" ]] &&')
        self.add(''' echo "FATAL: Missing directory '${Dir}'" &&''')
        self.add(line(' return 63'))
        self.add(line())
        self.add(rule())
        self.add(comment('Configure environment for Linux'))
        self.add(line())
        self.add(line('Script=${Dir}/activate.src'))
        self.add('[[ ! -f "${Script}" ]] &&')
        self.add(''' echo "FATAL: Missing script '${Script}'" &&''')
        self.add(line(' return 63'))
        self.add(line())
        self.add(line('source ${Script}'))
        self.add(line())
        self.add(line('Status=$?'))
        self.add('[[ ${Status} -ne 0 ]] &&')
        self.add(''' echo "FATAL: Exit code ${Status} at '$0':$LINENO" &&''')
        self.add(line(' return ${Status}'))
        self.add(line())
        self.add(rule())
        self.add(comment('Verify post-conditions'))
        self.add(line())
        self.add('[[ -z "$BO_E_Config"  ]] &&')
        self.add(''' echo 'FATAL: Missing $BO_E_Config'  &&''')
        self.add(line(' return 63'))
        self.add('[[ -z "$BO_E_Ok"      ]] &&')
        self.add(''' echo 'FATAL: Missing $BO_E_Ok'      &&''')
        self.add(line(' return "$BO_E_Config"'))
        self.add('[[ -z "$BO_PathLinux" ]] &&')
        self.add(''' echo 'FATAL: Missing $BO_PathLinux' &&''')
        self.add(line(' return "$BO_E_Config"'))
        self.add(line())
        self.add(rule())
        self.add(comment('Configure environment for Gradle on Linux'))
        self.add(line())
        self.add(line('export BO_PathGradle=$JAVA_HOME/bin'))
        self.add(line())
        self.add(line('PATH=${BO_PathProject}'))
        self.add(line('PATH=$PATH:${BO_PathGradle}'))
        self.add(line('PATH=$PATH:${BO_PathLinux}'))
        self.add(line('PATH=$PATH:${BO_PathSystem}'))
        self.add(line('export PATH'))
        self.add(disabled_content_footer())


def build():
    script = Script()
    script.generate()
    return script
    

VISITOR_MAP = VisitorMap(parent_map=script_bash.VISITOR_MAP)


def render(target_directory, target_file):
    script_bash.render(build(), VISITOR_MAP, target_directory, target_file)


""" Disabled content
"""

