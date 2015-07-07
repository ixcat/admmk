
# adm.hosts.build.mk
# ==================
# .. $Id$
#
# build driver for all host scope builds.
#
# used from: top-level host directory
# triggers: per-host host builds for all configured hosts

.if !defined(_ADM_HOSTS_BUILD_MK_)
_ADM_HOSTS_BUILD_MK_=1
.if ${MODTYPE} == allhosts

# top-level targets
# -----------------

install-allhosts: stage-allhosts push-allhosts

# dynamic target stubs
# --------------------
# basically, anything in '_ALLHOSTACTS' will create a set of
# macros which, when expanded (see below), will trigger running that 
# action in a subdirectory..
#

_ALLHOSTACTS=stage push ${ACTLIST}
.for _AA in ${_ALLHOSTACTS}
_AA_BT:= _${_AA}allhostsbanner
_AA_MT:= _${_AA}allhosts
__AA_T:= __${_AA}allhoststarg
${_AA}-allhosts:: ${_AA_BT} ${_AA_MT}
${_AA_BT}:
	@echo "# ==> ${_AA}-${MODNAME}"
${_AA_MT}::
${__AA_T}: .USE
	@echo "# ===> ${.TARGET}"
	@( cd ${SRCTOP}/host/${.TARGET:C/^${_AA}-//} && ${MAKE} ${_AA} )
.endfor
.undef _AA
.undef _AA_BT
.undef _AA_MT
.undef __AA_T
.undef _ALLHOSTACTS

# target generation/definition
# ----------------------------
#
# Here, expand the 'dynamic target stubs', above, into host-specific 
# targets which trigger the appropriate action within that 
# host subdirectory.
#

# generate per-host 'build phase' targets
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.for H in ${SYSHOSTS}
_H_I:= install-${H}
_H_S:= stage-${H}
_H_P:= push-${H}
.PHONY: ${H} ${_H_S} ${_H_P}
${H}: ${_H_I}
${_H_I}: ${_H_S} ${_H_P}
${_H_S}: __stageallhoststarg
${_H_P}: __pushallhoststarg
_stageallhosts:: ${_H_S}
_pushallhosts:: ${_H_P}
.for _AA in ${ACTLIST}
_H_AA:= ${_AA}-${H}
.PHONY: ${_H_AA}
${_H_AA}: __${_AA}allhoststarg
_${_AA}allhosts:: ${_H_AA}
.endfor
.undef _AA
.undef _H_I
.undef _H_S
.undef _H_P
.endfor

# generate per-host 'service action' targets
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.for A in install stage push ${ACTLIST}
.  for S in ${SYSSVCS}
.    for SH in ${${S}_HOSTS}
_A_SH_S:= ${A}-${S}-${SH}
__A_SH_S:= _${_A_SH_S}
${__A_SH_S}: .USE
	@echo "# ===> ${.TARGET}"
	@( cd ${SRCTOP}/host/${.TARGET:C/^${A}-${S}-//} && ${MAKE} ${.TARGET} )
${_A_SH_S}: ${__A_SH_S}
.    endfor
.  endfor
.endfor

.endif # ${MODTYPE} == allhosts
.endif # !defined(_ADM_HOSTS_BUILD_MK_)

