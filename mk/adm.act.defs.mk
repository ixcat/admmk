
#
# adm.act.defs.mk
# ===============
#
# install 'action' framework target definition macro include.
# see adm.act.inc.mk for more details.
#

# per svc macro expansion
# =======================
#
# Define service actions according to current build mode.
#

.for _ACT in ${ACTLIST}
.  if !defined(${_ACT}-${MODNAME}-cmd)
${_ACT}-${MODNAME}-cmd:= ${ACTSCRIPTDIR}/${MODNAME}.svc ${_ACT:C/^svc//}
.  endif
_LA:=	${_ACT}-${MODNAME}
.  if !defined(${_LA})
.    if ${NATIVEMODE} == 1
${_LA}: __mklocalact
.    else
${_LA}: __mkremoteact
.    endif
.  endif
.endfor

.undef _LA
.undef _ACT

