===========
Development
===========

In order to support development of this project within a lab environment (VM or cloud instance), the following steps are needed for setup.

#. Optionally install Dropbox client (to reference shared files used below)
#. Install the Mercurial client
  sudo apt-get update
  sudo apt-get install mercurial
#. Install SSH private key (BB-robwilliams-RSA-private.key)
#. Install SSH user configuration (BB-SSH-config)
#. Install Mercurial user configuration file (.hgrc), see sample content below
#. Clone the Mercurial repository
  hg clone ssh://hg@bb/robwilliams/couchbase ~/inBB/couchbase/code

BB-SSH-config
-------------
Host bb
  Compression yes
  HostName bitbucket.org
  IdentityFile ~/BB-robwilliams-RSA-private.key
  StrictHostKeyChecking no
  User hg

Mercurial user configuration (~/.hgrc)
--------------------------------------
[alias]
slog = log --limit 21 --template "{rev}:{node|short} {desc|firstline} ({author})\n"

[auth]
bb.password =
bb.prefix = bitbucket.org/robwilliams/
bb.schemes = https
bb.username = robwilliams

[extensions]
rebase =
# NO!!! fetch =

[ui]
ssh = ssh -F ~/BB-SSH-config
username = Rob Williams <rdw.bitbucket.robwilliams@refactory.biz>

NOTE: This file is designed for the hosting of this project at BitBucket_, so it is formatted using reStructuredText_ syntax.

.. _BitBucket: http://bitbucket.org/
.. _BriteOnyx: http://bitbucket.org/robwilliams/build
.. _reStructuredText: http://docutils.sourceforge.net/rst.html
