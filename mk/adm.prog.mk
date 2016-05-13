
# adm.prog.mk:
#
# top-level build driver makefile
#
#	$Id$
#	heavily modified from, but inspired-by:
#	$NetBSD: bsd.prog.mk,v 1.270.2.1 2012/03/02 18:27:55 riz Exp $
#	@(#)bsd.prog.mk 8.2 (Berkeley) 4/2/94

.ifndef HOSTPROG

.include <adm.init.mk>

##### Pull in related .mk logic

.include <adm.build.mk>
.include <adm.dirs.mk>
.include <adm.files.mk>

${TARGETS}:	# ensure existence

.endif	# HOSTPROG

