=========
BriteOnyx
=========
Overview
--------
BriteOnyx provides a reusable infrastructure for building software on various
development platforms.  Ultimately, the intent is to establish a continuous
delivery environment with minimal overhead in each project's directory tree.

Target platforms (in order)
---------------------------
#. Java on Linux
#. Groovy on Linux
#. Python on Linux
#. CoffeeScript on Linux
#. Java on Windows
#. Groovy on Windows
#. Python on Windows
#. CoffeeScript on Windows
#. .NET on Windows

So far Linux means Ubuntu (Lucid Lynx 10.04+) and Windows means Windows 7+ and.
Groovy means 2.1+, Python means 2.6+, Java means 1.6+, while CoffeeScript and
.NET will be recent versions but are not yet precisely defined.  I will
probably mix in Max OS X soon, after Linux but before Windows.

I don't like the implementation at the moment, which is constrained by the
design decision require the use of the 'activate' script, and doing so via
'source' on Linux.  Doing so means that I cannot call 'exit' from any of the
scripts since that will terminate the user's shell (close the terminal).
Instead, I will soon redesign so that the 'activate' script is optional and
only the 'cfg/project-env.bash' script must be 'source'd.  That will allow
most of the scripts to invoke 'exit' safely, which will dramatically simplify
the code.

On the other hand, I also intend to require Gradle as the primary build
scripting tool soon.  That will also dramatically simplify the code by moving
it into the realm of Gradle's ample functionality.

Beyond that, I am thinking that I want to support significant functionality
without Gradle for languages that do not really benefit as much from it,
meaning Python and CoffeeScript.  Since Gradle does not (yet) provide
dependency management for those languages, there is less to be gained by
involving Gradle in the first place.

----

NOTE: This file is designed for the hosting of this project at BitBucket_, so
it is formatted using reStructuredText_ syntax.

.. _BitBucket: http://bitbucket.org/
.. _reStructuredText: http://docutils.sourceforge.net/rst.html

