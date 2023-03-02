=========
BriteOnyx
=========
Overview
--------
BriteOnyx provides a reusable infrastructure for building and deploying custom
application software on various platforms.  Ultimately, I intend to establish
a Continuous Delivery (DevOps) pipeline based on minimal overhead in each
source project's directory tree.

Platforms
---------
Development and deployment platforms are intentionally open-ended.  My
primary target platform is Linux, focused initially on Ubuntu and CentOS/RHEL.
I hope to eventually encompass essentially all of Linux, BSD, Unix, and
variants including particularly NixOS.  Linux is my primary target because it
encompasses both client and server platforms, it is the most tractable, and it
includes the vast majority of cloud options.

My secondary target platform is Apple Mac OS X, but it is not primary because
it is limited to a much smaller audience (i.e., client machines and not
cloud).  I hope to cover most/all BSD variants as a derivative of my effort.

I do not intend to exclude any of the Unix platforms, but I do not anticipate
having the resources (hardware, license fees, etc.) to pursue them explicitly.
I hope to incorporate them adequately as a natural consequence of my pursuit
of the higher-priority platforms coupled with my careful avoidance of lock-in.

Microsoft Windows and similar (mostly) closed, proprietary platforms are
obviously problematic and therefore are much lower priority.  They are the
least tractable and the least cost-effective in the cloud, and they
consistently elude decent management.  Nevertheless, Windows is a very common
client (development) platform and deserves inclusion as a tertiary platform
for that reason.  Other proprietary platforms are not envisioned on the
foreseeable horizon.

My true primary deployment platform is the cloud:  whether public, private, or
hybrid.  I intend to target the Amazon and Rackspace public clouds first.  I
will treat cloud deployment as a deployment preparation step, along with the
planned targeting of the automated creation of virtual machines (VMs).

I intend BriteOnyx to be able to manage ANY computer, whether physical or
virtual.  My design criteria specifically includes auditing and managing pre-
existing computers that were not previously deployed or managed by BriteOnyx.
I intend BriteOnyx to know, respect, and manage that aspect (physical
or virtual) of each computer.  I intend BriteOnyx to be able to manage the
machine image (OS and software, installation and configuration) on each such
computer regardless of that nature.

Tooling
-------
I am designing for usage scenarios within the scope of Continuous Delivery and
DevOps.  My primary usage scenario supports development and deployment that is
driven from a shell (command-line interface = CLI).  This includes manual
execution as well as full-blown automation.

I prefer to use Vim, but my target usage is strictly unconstrained regarding
the use of text editors and/or integrated development environments (IDE).  For
IDEs, I intend to focus on IntelliJ IDEA, then Eclipse, and finally Microsoft
Visual Studio.  I do not intend to impede the use of any text editor or IDE.

Likewise, I primarily use Mercurial, then Git, and finally Subversion.  I do
not intend to impede the use of any source control tool though I strongly lean
towards distributed version control systems (DVCSs).

My primary programming languages are Groovy, Java, JavaScript (node.js),
and Python.  I have been looking at CoffeeScript and Go.  I also intend to
support C.  For Windows, I am focused on C#.  BriteOnyx will be designed to
deploy ANY application regardless of underlying language, but development
support is focused on this short list.  Others will be readily able to add
support for any other language.

My primary software build tool is Gradle, which leverages Ant and Ivy.  I will
never directly support Maven, especially since Gradle already provides a
suitable migration path.  Again, I do not intend to specifically impede the use
of any particular tool.

Technique
---------
I intend to properly support two invocation scenarios.

The first invocation scenario involves the user opening a shell, changing
directory to the location of a suitable source project, and invoking an
'activate' script.  This script serves as the universal entry point for that
source project to use the BriteOnyx framework.  Therefore, it minimally
reconfigures that shell to facilitate easy management of that project via
easy invocation of the BriteOnyx tools.

The other invocation scenario involves the user triggering the execution of a
specific project script (such as a 'build' or 'deploy' script) via any other
means besides a live shell.  This will primarily include invocation by a build
automation tool such as Jenkins.  It will also include invocation by any text
editor or IDE.  It will include invoking the script via a file browser, such
as double-clicking on the script.  It will ultimately include invoking the
script via ANY means available for executing scripts.

Therefore, underlying these invocation scenarios is my primary design
requirement that the BriteOnyx framework MUST manage its own configuration
explicitly, it must expose misconfiguration explicitly, and it must provide
easy discovery of how to correct such misconfigurations.

What does that actually mean?  It means that every entry point (script) MUST
be able to automatically trigger proper configuration of the project and the
BriteOnyx framework, OR it MUST be able to abort without doing harm yet while
providing usable information about how to correct the issue.

In other words, BriteOnyx is designed to be usable.  It must be reasonably
simple and discoverable.  It must avoid magic and instead be transparent.  It
must span the breadth and depth of its target scope, which is the general
support of development and deployment in light of Continuous Delivery and
DevOps.  This means that is must not leave gaps or holes that force a user to
resort to other means and tools.  This does NOT imply that BriteOnyx must be
all-encompassing.

Rather, it means that BriteOnyx must be capable of facilitating the
development and deployment of custom application software from source to
production.  BriteOnyx must orchestrate those processes starting from nothing:
such as a new shell on a developer's workstation, a new build job on a
continuous integration server, or via an "external tool" hook in an IDE.
BriteOnyx must be able to integrate various tools to support those processes,
cleanly and transparently.

What does this NOT mean?  It means that BriteOnyx CANNOT be closed and
proprietary.  It means that it CANNOT manifest any form of specific vendor,
tool, or technology lock-in.  It means that it CANNOT be haphazard, myopic, or
merely thrown-together as a casual off-the-cuff response to something else.
This means that BriteOnyx CANNOT imitate such counter-examples as Chef and
Maven.  It also means that BriteOnyx CANNOT be built using underlying
technologies and techniques that are problems in-and-of themselves.  In other
words, BriteOnyx should solve the configuration management problems of
development and deployment rather than create a whole new family of problems
instead.

In the future, I will have more specific things to say about this as I have
time to write about each manifestation.  However, I don't want to do that in
detail until I can also demonstrate how BriteOnyx has also solved each one.  I
know what it needs to look like, but now I need to spend the time to actually
assemble/build it.

Development platform
--------------------
I am primarily developing on Linux Mint 15 Olivia Cinnamon, running as a
virtual machine (VM) within VMware Fusion 5.0.4.  This is hosted on an Apple
MacBook Pro running OS X 10.9.1 Mavericks.  I tend to keep updates current on
each.  I also do Microsoft Windows 7 Ultimate running in a VM.

Design/Implementation
---------------------
As I have used various configuration management and build engineering tools
over the years, I have repeatedly encountered the fact that essentially ALL of
these tools fail to take a holistic approach and thereby leave one hanging.
Typically this manifests in a design/implementation that starts with the
invocation of the tool and specifically ignores the surrounding context.  The
boundary between the two manifests as a "magic" script that tries to make
"intelligent" guesses about the configuration of your machine in order to run
the tool.

Two specific examples are the 'ant' and 'mvn' scripts for invoking Ant and
Maven respectively.  These scripts try to guess where you might have Java
installed, along with many other major and minor configuration concerns.  As a
consequence, two executions of the relevant script can result in radically
different behavior due to "accidental" differences in configuration.  Neither
script--nor their tools as a whole--addresses the common problem of
misconfiguration and discovery.

In my humble opinion, a decent configuration management and/or build
engineering tool MUST (by definition) identify and report misconfiguration in
a useful way.  In particular, that way of reporting MUST provide a workable
route of discovery for the user.  Going back to our examples of the 'ant' and
'mvn' scripts, I think that they should reliably detect whether a suitable
Java environment has been installed and configured.  If not, those scripts
should explicitly abort with meaningful messages indicating exactly what is
misconfigured.  So, for example, these scripts should abort if the 'JAVA_HOME'
environment variable is not set properly and they should tell you why (and
even how).  That behavior should be consistently implemented, consistently
reported, and thoroughly reliable.  Such scripts, such tools, should NEVER
just silently make guesses nor attempt to operate with a partial or wrong
configuration.

BriteOnyx addresses this shortcoming by embracing a holistic approach that
leverages such principles as fail-fast, discovery, SOLID, and many others.
BriteOnyx does not draw an arbitrary line in the sand and tell you that you
are left to your own devices outside it.

One particular manifestation of that fact takes us back to our example 'ant'
and 'mvn' scripts.  These scripts are responsible for "bootstrapping" the
respective tools.  As a consequence, these "magic" scripts cannot leverage the
power of the tool since the tool is not available yet (we are bootstrapping
the tool, remember?).  Unfortunately, such bootstrapping usually fails to
receive the kind of love and attention that it deserves.  The result is
unreliable behavior from the tool, lots of support issues, and lots of user
frustration.

Ironically, the users contribute greatly to this problem by their own habits
that perpetuate it.  This can be readily seen in the realm of application
programming, where the solution is also more readily seen.  Unfortunately,
most programmers write most of their code directly in terms of the programming
language's basic operations and available library calls.  As a consequence,
their code has lots of redundancy around each instance of using each of the
language's basic features.  So, for example, each time the programmer needs to
make a web service call in their application code, you will typically see the
same invocation of the appropriate library method surrounded by the same
"boilerplate" housekeeping code.  This might be as little as two-or-three
lines of code, or as much as dozens-to-hundreds of lines.  A proper solution
is to refactor the code into reusable chunks (methods, classes, etc.).  This
can and should actually be done in layers.  Some languages actually present
this as an explicit feature in various forms, and such an approach also
manifests under various techniques such as domain-specific languages (DSLs).

This shows up in the realm of tools such as Ant and Maven as a similar lack of
layering.  Little attention is often given to the build scripts themselves in
terms of design principles such as layering.  The bootstrapping scripts are
typically used as-is without any proper consideration.  The environments in
which those bootstrapping scripts are invoked is often ignored altogether.

I believe that an holistic approach to configuration management and build
engineering demands leveraging such techniques.  This manifests in BriteOnyx
initially as three explicit design/implementation layers.  The first is the
bootstrapping or "activation" layer, the second is the main "invocation"
layer, and the third is within the scope of Gradle (or similar tools).  Within
each of these layers, there are sublayers to build up from base functionality
towards the needed high-level functionality.

In the first two layers, there are some very special considerations.  This
layer is implemented in operating-system-level scripting languages--initially
and primarily in BASH.  It interacts with the operating system and controls
the overall processing.  It literally creates the environment within which the
rest of BriteOnyx runs along with everything it controls.  As such, each
script invocation may involve the creation of an operating-system-level
process or at least a subshell.

This is special in several ways.  For one, it means that we are using the
coarsest and most limited tools (BASH or equivalent) in our entire
infrastructure.  For another, it means that messing up here can corrupt the
environmental context for EVERYTHING else that BriteOnyx controls.  As the
universal means for invoking BriteOnyx, it also means that it is the most
visible and most used part of the whole framework.  This combines with the
low-level nature of this interface, and the fact that most people are
relatively unfamiliar and uncomfortable with a CLI/shell, to also give us the
most potential for mistakes and misuse.  All this adds up to give us the most
potential for frustrating our users.

The first "activation" layer has an even more special consideration with a
monumental potential for user frustration.  To help manage it, I have made
several critical design decisions.

The first is to require the use of an 'activate' script, and to allow the user
to do so via the BASH 'source' command.  As you may recall, the BASH 'source'
command runs the specified script within the context of the existing shell.
This is typically done because it allows the script to alter that shell's
environment.  Normal script execution creates a subshell that inherits its
environment from the parent shell but discards that (modified) environment
when the script terminates.  For BriteOnyx to do its work, we want it to modify
the environment of the shell in which it was invoked.  For the "activation"
layer of scripts, that shell is intentionally the one launched by the user.

This is significant because BASH scripts and every other program have the
potential to (and often actually do) terminate the shell in which they
execute.  If that shell was launched by the user, the result is that their
terminal closes and disappears.  All of the feedback (console output) is lost
and the user finds themselves having to relaunch their shell in order to resume
their work.  Losing one's shell terminal in this way is merely an annoyance
when it happens every great once in a while.  For a tool suite and framework
like BriteOnyx, there is a potential for it to happen upon every invocation.

Therefore, the design of the "activation" layer must strive to NEVER terminate
the user's shell terminal.  Doing so means that I cannot call 'exit' from any
of these "activation" scripts.  This requirement separates this layer from the
main tool "invocation" layer.  So the scripts in the "activation" layer expect
(and sometimes require) being 'source'd, while the scripts in the "invocation"
layer do NOT expect (and often forbid) being 'source'd.  This separation will
allow most of the scripts (in the "invocation" layer) to invoke 'exit' safely,
which will dramatically simplify the code.  It also allows the second layer of
scripts to be written at a much higher level of abstraction.

The third layer will be dominated by Gradle scripts.  These are written in
Groovy with the support of a build DSL that wraps Ant and Ivy.  This is
ultimately where we want most of our functionality, with the full power of a
modern dynamic language running on top of the most mature and best supported
execution platform (Java).

Beyond that, I am thinking that I want to support significant functionality
without Gradle for languages that do not really benefit as much from it,
meaning .NET, CoffeeScript, and Python.  Since Gradle does not (yet) provide
dependency management for those languages, there is less to be gained by
involving Gradle in the first place.

----

NOTE: This file is designed for the hosting of this project at BitBucket_, so
it is formatted using reStructuredText_ syntax.

.. _BitBucket: http://bitbucket.org/
.. _reStructuredText: http://docutils.sourceforge.net/rst.html

