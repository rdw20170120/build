Things TODO for this project
============================
* Add script to upload packaged distribution to Amazon S3
* Fix invocation scripts to abort if project is not yet activated
* Refactor scripts that fix filesystem permissions
* Enhance scripts that fix file permissions to also force ownership to `$USER`

Big Tasks
=========
* Refactor `search.bash`, `attempt.bash`, and `replace.bash` scripts into one
* Fix bootstrap/activation to remove all uses of `exit` and `return`
* Fix invocation scripts to activate project if needed
* Refactor BriteOnyx so that it is bootstrapped into a using project, but
  afterwards leaves no residual other than the relevant BriteOnyx files needed
  to support that project
* Within each project tree that uses BriteOnyx, consider creating a temporary
  directory into which we assemble the complete contents from this BriteOnyx
  that are needed by that project, then put that temporary directory on the
  project's PATH so that there is no further reference back to BriteOnyx
* Enhance the use of SLOCcount to include the relevant files from BriteOnyx

Done
====
* Remove all references to variable `BO_Sequence`
* Add script to package distribution
* Refactor directory structure

----

NOTE: This file is designed for the hosting of this project at BitBucket_, so
it is formatted using reStructuredText_ syntax.

.. _BitBucket: http://bitbucket.org/
.. _reStructuredText: http://docutils.sourceforge.net/rst.html

