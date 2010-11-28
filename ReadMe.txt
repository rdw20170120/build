###############################################################################
This Mercurial repository is being used to establish a continuous delivery
environment.

###############################################################################
Tools awaiting integration are:

someday Trac + Mercurial + Bitten?

Hudson plugins:
    Cobertura
        nosetests --with-coverage (writes **/coverage.xml)
    Promoted Builds
    Violations
        PyLint
Python packages
    coverage
    fabric
    nose
        nosetests
            --with-xunit
            --enable-audit
            --enable-cover
        Update Hudson job:
            Check "Publish JUnit test result report"
            Set "Test report XMLs" = **/nosetests.xml
    pip
    pygments
    pylint
    pyreverse
    unittest-xml-reporting
    virtualenv
        http://iamzed.com/2009/05/07/a-primer-on-virtualenv/#content
Ubuntu packages
    build-essential
    openjdk-6-jre-headless (instead of Oracle Java)
    python-dev

###############################################################################
Tools that should be avoided are:

NoseXUnit (obsolete, use Nose)

###############################################################################
Tools already integrated are:

Dell Precision 390 Workstation
Ubuntu 10.10 Maverick Meerkat desktop amd64
Python 2.6.6
Mercurial 1.6.3
Oracle Java SE 1.6.0_22-b04 HotSpot 64-Bit Server
Oracle Hudson 1.386
Mozilla Firefox 3.6.12

###############################################################################
Key commands to establish environment:

wget -O /tmp/hudson-ci.org.key http://hudson-ci.org/debian/hudson-ci.org.key
sudo apt-key add /tmp/hudson-ci.org.key

sudo apt-get install adduser daemon psmisc
sudo apt-get install sun-java6-jre
sudo apt-get install java-virtual-machine java2-runtime

wget -O /tmp/hudson.deb http://hudson-ci.org/latest/debian/hudson.deb
sudo dpkg --install /tmp/hudson.deb

sudo apt-get update
sudo apt-get install hudson

sudo apt-get install mercurial
sudo apt-get install python-dev
sudo apt-get install python-virtualenv
sudo apt-get install sloccount

###############################################################################
Key configuration steps for Hudson:

Uninstall CVS plugin
Uninstall Maven Integration plugin
Uninstall Subversion plugin
Install Cobertura plugin
    ???
Install Green Balls plugin
Install Mercurial plugin
    configure for project
Install Python plugin
Install SafeRestart plugin
Install SLOCCount plugin
    configure for project
Install Violations plugin
    configure for project

