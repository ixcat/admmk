
#
# adm.mod.dirs.mk
# ===============
#
# based on 'adm.dirs.mk', but hooks into module-defined targets
# to be used as a 'macro include' from modules
#
#

.if !defined(_ADM_MOD_DIRS_MK_)
_ADM_MOD_DIRS_MK_=1

__stagemoddir: .USE
	${_MKTARGET_INSTALL}
	${INSTALL_DIR} \
		-o ${DIRSOWN_${.TARGET:S/${DESTDIR}//}:U${DIRSOWN}} \
		-g ${DIRSGRP_${.TARGET:S/${DESTDIR}//}:U${DIRSGRP}} \
		-m ${DIRSMODE_${.TARGET:S/${DESTDIR}//}:U${DIRSMODE}} \
		${SYSPKGTAG} ${.TARGET}

.endif # !defined(_ADM_MOD_DIRS_MK_)

.if ( ${MODTYPE} == svc || ${MODTYPE} == host )

.for MD in ${MODDIRS:O:u}

_MD:=		${DESTDIR}${MD}

${_MD}: __stagemoddir

dirstage-${MODNAME}: ${_MD}

.endfor # MD in ${MODDIRS:O:u}

.undef _MD

# ensure target
.if !target(dirstage-${MODNAME})
dirstage-${MODNAME}:
.endif

.endif # ( ${MODTYPE} == svc || ${MODTYPE} == host )
