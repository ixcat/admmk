#	adapted to the adm.mk framework from:
#	$NetBSD: bsd.init.mk,v 1.2 2003/07/28 02:38:33 lukem Exp $

# <adm.init.mk> includes Makefile.inc and <bsd.own.mk>; this is used at the
# top of all <adm.*.mk> files which actually "build something"

.if !defined(_ADM_INIT_MK_)
_ADM_INIT_MK_=1

.-include "${.CURDIR}/../Makefile.inc"
.include <adm.own.mk>
.include <adm.mod.inc.mk>

# hack putting here

# build type globals
# ==================

BUILDHOST!=     hostname
.if ${TOPMODTYPE} == host
TGTHOST?=               ${TOPMODNAME}
.else
TGTHOST?=
.endif
#
SYSOBJDIR?=${SYS}/obj
OBJDIR:=${SYSOBJDIR}/${TGTHOST}
DESTDIR?=${OBJDIR}
#
# XXX - set BUILDHOST / TGTHOST in e.g. 'modtype.mk' ?
#   ... for now, we are safe, since this file is read once per convocation
#   ... and the assumption is that only host-build convocations 'do' anything.
#
.if ${DESTDIR:N${SYSOBJDIR}*}
.  if ${TGTHOST} == ${BUILDHOST}
NATIVEMODE=1
.  else
.    error native install to incorrect host. did you mean to set BUILDHOST?
.  endif
.else
NATIVEMODE=0
.endif

.MAIN:		all

.endif	# !defined(_ADM_INIT_MK_)
