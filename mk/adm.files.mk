#	adapted to adm.mk model from:
#	$NetBSD: bsd.files.mk,v 1.42 2011/09/10 16:57:35 apb Exp $

.if !defined(_ADM_FILES_MK_)
_ADM_FILES_MK_=1

.include <adm.init.mk>

# hmm: FILESGROUPS?=	FILES ala bsd.files.mk in Free/DragonFly ?

.if !target(__fileinstall)
##### Basic targets
realinstall:	filesinstall
realall:	filesbuild

##### Default values
FILESDIR?=			# is a vpath, defaulting to '/'
FILESOWN?=	${BINOWN}
FILESGRP?=	${BINGRP}
FILESMODE?=	${NONBINMODE}

##### Build rules
filesbuild:
.PHONY:		filesbuild

##### Install rules
filesinstall::	# ensure existence
.PHONY:		filesinstall

__fileinstall: .USE
	${_MKTARGET_INSTALL}
	${INSTALL_FILE} \
		-o ${FILESOWN_${.ALLSRC:T}:U${FILESOWN}} \
		-g ${FILESGRP_${.ALLSRC:T}:U${FILESGRP}} \
		-m ${FILESMODE_${.ALLSRC:T}:U${FILESMODE}} \
		${SYSPKGTAG} ${.ALLSRC} ${.TARGET}

.endif # !target(__fileinstall)

.for F in ${FILES:O:u}

_FDIR:=         ${FILESDIR_${F}:U${FILESDIR}}           # dir override
_FNAME:=        ${FILESNAME_${F}:U${FILESNAME:U${F:T}}} # name override
_F:=            ${DESTDIR}${_FDIR}/${_FNAME}            # installed path
_FDOBUILD:=     ${FILESBUILD_${F}:U${FILESBUILD:Uno}}

${_F}:	${F} __fileinstall
filesbuild: ${F}
filesinstall:: ${_F}

.endfor

.undef _FDIR
.undef _FNAME
.undef _F
.undef _FDOBUILD

.endif	# !defined(_ADM_FILES_MK_)

