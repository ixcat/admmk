#	$Id$
#	adapted to adm.mk model from:
#	$NetBSD: bsd.files.mk,v 1.42 2011/09/10 16:57:35 apb Exp $

.if !defined(_ADM_DIRS_MK_)
_ADM_DIRS_MK_=1

.include <adm.init.mk>

.if !target(__dirinstall)
##### Basic targets
# realinstall:	dirsinstall
beforeinstall:	dirsinstall
realall:	filesbuild

##### Default values
DIRSOWN?=	${BINOWN}
DIRSGRP?=	${BINGRP}
DIRSMODE?=	755

##### Install rules
dirsinstall::	# ensure existence

.PHONY:		dirsinstall

# build DESTDIR (aka objdir) before files only if != native
#
# we don't do this in native installs, since the DESTDIR root is
# not directly managed and we don't want to inadvertently alter the
# status quo.
#
# XXX customizable perms? intuition says no
#

.if ${NATIVEMODE} == 0 && ( ${TOPMODTYPE} == host || ${TOPMODTYPE} == svc )

objdir: ${OBJDIR}

${OBJDIR}:
	${_MKTARGET_INSTALL} \(objdir\)
	${INSTALL_DIR} \
		-o ${DIRSOWN} -g ${DIRSGRP} -m ${DIRSMODE} \
		${OBJDIR}

# XXX tbd toplevel target buildup happens elsehwere
# dirsinstall:: objdir

.else:

objdir:

.endif # NATIVEMODE ...

__dirinstall: .USE
	${_MKTARGET_INSTALL}
	${INSTALL_DIR} \
		-o ${DIRSOWN_${.TARGET:S/${DESTDIR}//}:U${DIRSOWN}} \
		-g ${DIRSGRP_${.TARGET:S/${DESTDIR}//}:U${DIRSGRP}} \
		-m ${DIRSMODE_${.TARGET:S/${DESTDIR}//}:U${DIRSMODE}} \
		${SYSPKGTAG} ${.TARGET}

.endif # !target(__dirinstall)

.for D in ${DIRS:O:u}

_D:=		${DESTDIR}${D}

# XXX: safety/vs performance - todo buildvar
.PHONY:		${_D}

${_D}: __dirinstall
dirsinstall:: ${_D}

.endfor

.undef _D

.endif	# !defined(_ADM_DIRS_MK_)

