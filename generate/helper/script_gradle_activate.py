import script_bash
import script_briteonyx

from throw_out_your_templates_3_core_visitor_map import VisitorMap


class Script(script_briteonyx.Script):
    def __init__(self):
        script_briteonyx.Script.__init__(self)

    def generate(self):
        self.add_source_header()
        self.note("We MUST NOT EVER 'exit' during BriteOnyx bootstrap or activation")
        self.rule()
        self.note('Uncomment the following two lines for debugging')
        self.comment('set -o verbose')
        self.comment('set -o xtrace')
        self.someday('Add inverse commands to isolate debugging')
        self.line()
        self.rule()
        self.comment('Verify pre-conditions')
        self.line()
        self.text('[[   -z "$BO_Home"          ]] &&')
        self.text(" echo 'FATAL: Missing $BO_Home'                &&")
        self.line(' return 63')
        self.text('[[ ! -d "$BO_Home"          ]] &&')
        self.text(''' echo "FATAL: Missing directory '$BO_Home'"    &&''')
        self.line(' return 63')
        self.text('[[   -z "$BO_Project"       ]] &&')
        self.text(" echo 'FATAL: Missing $BO_Project'             &&")
        self.line(' return 63')
        self.text('[[ ! -d "$BO_Project"       ]] &&')
        self.text(''' echo "FATAL: Missing directory '$BO_Project'" &&''')
        self.line(' return 63')
        self.text('[[   -z "$BO_GradleVersion" ]] &&')
        self.text(''' echo 'FATAL: Missing $BO_GradleVersion'       &&''')
        self.line(' return 63')
        self.text('[[   -z "$BO_PathSystem"    ]] &&')
        self.text(''' echo 'FATAL: Missing $BO_PathSystem'          &&''')
        self.line(' return 63')
        self.text('[[   -z "$JAVA_HOME"        ]] &&')
        self.text(''' echo 'FATAL: Missing $JAVA_HOME'              &&''')
        self.line(' return 63')
        self.line()
        self.line('Dir=$BO_Home/activation')
        self.text('[[ ! -d "${Dir}" ]] &&')
        self.text(''' echo "FATAL: Missing directory '${Dir}'" &&''')
        self.line(' return 63')
        self.line()
        self.rule()
        self.comment('Configure environment for Linux')
        self.line()
        self.line('Script=${Dir}/activate.src')
        self.text('[[ ! -f "${Script}" ]] &&')
        self.text(''' echo "FATAL: Missing script '${Script}'" &&''')
        self.line(' return 63')
        self.line()
        self.line('source ${Script}')
        self.line()
        self.line('Status=$?')
        self.text('[[ ${Status} -ne 0 ]] &&')
        self.text(''' echo "FATAL: Exit code ${Status} at '$0':$LINENO" &&''')
        self.line(' return ${Status}')
        self.line()
        self.rule()
        self.comment('Verify post-conditions')
        self.line()
        self.text('[[ -z "$BO_E_Config"  ]] &&')
        self.text(''' echo 'FATAL: Missing $BO_E_Config'  &&''')
        self.line(' return 63')
        self.text('[[ -z "$BO_E_Ok"      ]] &&')
        self.text(''' echo 'FATAL: Missing $BO_E_Ok'      &&''')
        self.line(' return "$BO_E_Config"')
        self.text('[[ -z "$BO_PathLinux" ]] &&')
        self.text(''' echo 'FATAL: Missing $BO_PathLinux' &&''')
        self.line(' return "$BO_E_Config"')
        self.line()
        self.rule()
        self.comment('Configure environment for Gradle on Linux')
        self.line()
        self.line('export BO_PathGradle=$JAVA_HOME/bin')
        self.line()
        self.line('PATH=${BO_PathProject}')
        self.line('PATH=$PATH:${BO_PathGradle}')
        self.line('PATH=$PATH:${BO_PathLinux}')
        self.line('PATH=$PATH:${BO_PathSystem}')
        self.line('export PATH')
        self.add_disabled_content_footer()


VISITOR_MAP = VisitorMap(parent_map=script_bash.VISITOR_MAP)


def build():
    script = Script()
    script.generate()
    return script
    
def render(target_directory, target_file):
    script_bash.render(build(), VISITOR_MAP, target_directory, target_file)


""" Disabled content
"""

