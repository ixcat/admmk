.. $Id$

BMake Details
=============

.. todo: 
..  - ftp line similar to usr/share/mk to extract bmake

This directory contains information relating to the BMake/PMake
installation used by the the admmk system.

The 'pmake' utility was chosen as base utility for admmk because
of it's it has a long and proven track record in the building &
deployment of BSD-derived systems. Bmake's flexible, shell-like
syntax and lisp-like list target processing logic is in the author's
opinion vastly superior to other lesser makes. Because of it's
simplicity, flexibility, and consistency with historical source
code build systems, it could be said that in contrast to certain
popular, commercially backed, pseudo open-source or binary-only
host administration systems, using make, and specifically PMake,
is in line with the 'true the unix way' of managing the base system,
which from the very beginning has always been from source, via
carefully curated source code trees.  Admmk has been created to
honor and preserve this lineage and philosophy by extending the
makefile support beyond the base system build and into the realm
of systems managment by providing a common, extensible, open source
makefile library for systems managment, hoping in this way to
disprove the false claims of novelty or newfound managment simplicity
common to the venture-backed marketing propaganda of these recent
for-profit innovations. While it so far does not yet have all
of the bells and whistles common to many of these systems,
it is hoped that the admmk codebase can grow to encompass many
of these features without detracting from the simplicity of
a simple configuration tree managed by a small set of easy
to understand makefiles and a few auxilliary utilities.

NetBSD's pmake is somewhat the 'reference copy' of bmake, since the
NetBSD project focuses heavily on portability and also some efforts
have been made to unify PMake fragmentation in the BSD community
in recent years, most specifically ~2011-2013 in FreeBSD and
DragonFlyBSD, which is an additional benefit to it's selection.

A copy of the NetBSD 6.0.1 make source archive is available in the
subdirectory 'bmake' for reference and also in order to facilitate
use on platforms where sufficiently compatible bmake package is not
available - the tool can be built via::

  # make -f Makefile.boot

using either an existing PMake or GNUMake - specific compatibility
checks were not make concerning exact versions, but this was tested
at least against OpenBSD 5.4's older PMake as well as gmake version
3.8.2 on OpenBSD 5.4.

For compatibility with RHEL systems, the bmake-20111010-1.el6.rf.x86_64
package from repoforge has also been tested, which in turn is based
on a portable clone of NetBSD's pmake.

Partial installation notes for redhat-compatible systems are kept
in the 'bmake-prep.yum' and 'bmake-inst.yum' files, and will be
expanded into a proper 'bmake bootstrap' script in the future.

As concerns the actual makefile library -

The BSD projects provide a large library of makefiles for the common
tasks needed to build an OS project, such as processing / installing
files, managing output directories, etc, which are essentially all
of the common tasks needed for managing a system - however, they
do not include any notion of remote or multiple systems, and so
have been used more for inspiration than as a direct porting base.

specifically, two makefile libraries were referred to in the
course of implementing v1.0:

  1) The NetBSD 6.0.1 Makefile library in, obtained via::

       ftp -o - \
         ftp://ftp.NetBSD.org/pub/NetBSD-archive/NetBSD-6.0.1/\
           source/sets/sharesrc.tgz \
           |tar zxvf - usr/src/share/mk

  2) SJG's portable makefile library, obtained via::

     http://www.crufty.net/ftp/pub/sjg/mk-20111010.tar.gz

These libraries should be considered as 'references', with an actual
makefile library consisting of 'used'/'live' makefiles being placed
under the project /mk area. It is anticipated that a mix of features
from these sets and local development will be created here, since
the NetBSD library is geared towards maintaining the NetBSD system,
and SJG's makefiles are geared towards managing various software
projects, and certain features needed for the task of adminsitration
might be missing in one but present in the other, and vice-versa.
Specifically, for example, an analog of the the bsd.files.mk makefile
is not available in SJG's library, however it contains more support
for non-operating system type projects, etc. 

Specific documentation concerning the admmk makefiles will be kept
within the actual top-level ${SYS}/mk directory along with the
makefiles. Generally speaking, the target structure of these makefiles
will attempt to be modelled after an extremely minimalist subset
or reimplementation of the NetBSD makefiles needed to provide support
for managing systems, with extra features merged from sjg make where
desired, and with custom features added where not present in either.

To run PMake with the proper arguments, the ${SYS}/bin/mk script
is used, with ${SYS}/mk.env setting PATH appropriately so that it
is included.

