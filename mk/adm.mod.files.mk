
#
# adm.svc.files.mk 
# ================
#
# based on 'adm.files.mk', but hooks into module-defined targets
#

.if !defined(_ADM_SVC_FILES_MK_)
_ADM_SVC_FILES_MK_=1

__stagemodfile: .USE
	${_MKTARGET_INSTALL}
	${INSTALL_FILE} \
		-o ${FILESOWN_${.ALLSRC:T}:U${FILESOWN}} \
		-g ${FILESGRP_${.ALLSRC:T}:U${FILESGRP}} \
		-m ${FILESMODE_${.ALLSRC:T}:U${FILESMODE}} \
		${SYSPKGTAG} ${.ALLSRC} ${.TARGET}

.endif # !defined(_ADM_SVC_FILES_MK_)

.if (${MODTYPE} == host || ${MODTYPE} == svc)

.for MF in ${MODFILES:O:u}

_MN:=		${MODNAME}
_MFDIR:=	${FILESDIR_${MF}:U${FILESDIR}}			# dir override
_MFNAME:=	${FILESNAME_${MF}:U${FILESNAME:U${MF:T}}}	# name override
_MF:=		${DESTDIR}${_MFDIR}/${_MFNAME}			# installed path
_MFDOBUILD:=	${FILESBUILD_${MF}:U${FILESBUILD:Uno}}

# XXX: safety/vs performance - todo buildvar
# .PHONY:		${_MF}

${_MF}: ${MF} __stagemodfile

filestage-${MODNAME}: ${_MF}

.endfor # MF in ${MODFILES:O:u}

.undef _MN
.undef _MFDIR
.undef _MFNAME
.undef _MF
.undef _MFDOBUILD

# ensure target
.if !target(filestage-${MODNAME})
filestage-${MODNAME}:
.endif

.endif # ${MODTYPE} == host || ${MODTYPE} == svc

