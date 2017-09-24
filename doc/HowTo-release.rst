HowTo release this project
==========================
The release of this project involves the coordinated creation of a tarball, generating a checksum,
and updating the source repository.  These tasks should be automated, but they are done manually for
now as described here.

Source files involved
=====================
The release of this project currently involves and is controlled by these files:

* `current_tag.txt`
* `helper/invocation/BriteOnyx-update-here.bash`
* `bin/build.bash`
* `bin/package.bash`
* `bin/project-fix-permissions.bash`
* `activate.src`

Release process
===============
1. Checkout BriteOnyx source project, if not already done (TODO: Document process)
#. Activate project
   a) Open a new shell
   #) Change directory to root of BriteOnyx source project
   #) `source activate.src`
#. Revise source
   a) Edit source as appropriate
   #) `project-fix-permissions.bash`
   #) `hg add .`
   #) `hg commit -m 'DESCRIPTION OF SOURCE EDITS'`
   #) `package.bash`
   #) Publish packaged release tarball & checksum files
   #) Deploy packaged release
   #) Test packaged release
   #) Repeat as needed
#. Commit release
   #) `project-fix-permissions.bash`
   #) `hg add .`
   #) `hg commit -m 'DESCRIPTION OF RELEASE'`
   #) `hg tag REVISION` (TODO: Update to permanent tags)
   #) `hg tag VERSION` (if appropriate, TODO: Update to permanent tags)
#. Increment for next revision
   #) `clear ; grep -Er REVISION | grep -v .hg | grep -v outgoing.out`
   #) NOTE: The listed files need to be edited to increment the revision
   #) `vim current_tag.txt`
      1. Increment revision in file
      #. Save changes to file
   #) `vim src/piece/bootstrap/sample_project/BriteOnyx/env.src/009b-new-set-BriteOnyx_variables.src`
      1. Increment revision in file
      #. Save changes to file
   #) `build.bash`
   #) `meld --newtab $TMPDIR/tgt $BO_Project &`
   #) In Meld UI, typically disable 'Same' and 'New' buttons, enable only 'Modified' button
   #) Apply file changes as appropriate from left panel into right panel
   #) `BriteOnyx-update-here.bash`
   #) `clear ; grep -Er REVISION | grep -v .hg | grep -v outgoing.out`
   #) NOTE: There should be NO files listed that still need to be edited to increment the revision
   #) `project-fix-permissions.bash`
   #) `hg add .`
   #) `hg commit -m 'Increment revision to begin work on next release'`
   #) `hg push`
#. Repeat as needed

----

NOTE: This file is designed for the hosting of this project at BitBucket_, so
it is formatted using reStructuredText_ syntax.

.. _BitBucket: http://bitbucket.org/
.. _reStructuredText: http://docutils.sourceforge.net/rst.html

