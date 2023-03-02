Things TODO for this project
============================
* Remove old content left by recent refactor
* Add `revision` script to report BriteOnyx revision
* Apply permanent version tags to releases in Mercurial
* Add `version` script to report BriteOnyx version tag from Mercurial
* Automate release packaging
* Add script to upload packaged distribution to Amazon S3
* Refactor scripts that fix filesystem permissions
* Enhance scripts that fix file permissions to also force ownership to `$USER`

Big Tasks
=========
* Create and configure support for easy use of source repository tools Mercurial and Git
  ** `add`
  ** `commit`
  ** `ignored`
  ** `log`
  ** `pull`
  ** `push`
  ** `slog`
  ** `status`
* Enhance script(s) for bulk source changes
  ** Refactor `search.bash`, `attempt.bash`, and `replace.bash` scripts into one
  ** Enhance search/replace script(s) to better control which source files are affected
  ** Enhance search/replace script(s) to exclude files private to source-control tool
* Fix bootstrap/activation to remove all uses of `exit` and `return`
* Extend activation
  ** Fix invocation scripts to abort if project is not yet activated
  ** Enhance invocation scripts to activate project if needed
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

