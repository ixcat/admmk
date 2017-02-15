
# adm.svcs.build.mk
# =================
#
# build driver for all svc scope
#
# used from: top-level service directory
# triggers: per-service build for each configured service for all hosts

.if !defined(_ADM_SVCS_BUILD_MK_)
_ADM_SVCS_BUILD_MK_=1
.if ${MODTYPE} == allsvcs

# install target
# --------------

install-allsvcs: stage-allsvcs push-allsvcs

# dynamic target stubs
# --------------------
# basically, anything in '_ALLSVCACTS' will create a set of
# macros which, when expanded (see below), will trigger running that 
# action in a subdirectory..
#

_ALLSVCACTS=stage push
.for _AA in ${_ALLSVCACTS}
_AA_BT:= _${_AA}allsvcsbanner
_AA_MT:= _${_AA}allsvcs
__AA_T:= __${_AA}allsvcstarg
${_AA}-allsvcs:: ${_AA_BT} ${_AA_MT}
${_AA_BT}:
	@echo "# ==> ${_AA_BT}"
${_AA_MT}::
${__AA_T}: .USE
	@echo "# ===> ${.TARGET}"
	( cd ${SRCTOP}/svc/${.TARGET:C/^${_AA}-//} && ${MAKE} ${_AA} )
.undef _AA
.undef _AA_BT
.undef _AA_MT
.undef __AA_T
.endfor
.undef _ALLSVCACTS

# target generation/definition
# ----------------------------
# Here, expand the 'dynamic target stubs', above, into host-specific 
# targets which trigger the appropriate action within that 
# host subdirectory.

.for S in ${SYSSVCS}
_S_I:= install-${S}
_S_S:= stage-${S}
_S_P:= push-${S}
.PHONY: ${_S_S} ${_S_P}
${_S_I}: ${_S_S} ${_S_P}
${_S_S}: __stageallsvcstarg
${_S_P}: __pushallsvcstarg
_stageallsvcs:: ${_S_S}
_pushallsvcs:: ${_S_P}
.undef _S_I
.undef _S_S
.undef _S_P
.endfor


# reimplementing... 
.if 0
allsvcs::
	@echo "# ==> building all svcs"

realstage: allsvcs

# XXX: cant use SVCMODTOP via adm.host.mk b/c it sets vars

__svctarg: .USE
	@echo "# ===> entering ${.TARGET}"
	@( cd ${SRCTOP}/svc/${.TARGET} && ${MAKE} svc )

.for S in ${SYSSVCS}
_S:= ${S}
.PHONY: ${_S}
${_S}: __svctarg
TGTSVCS+= ${S}
allsvcs:: ${_S}
.endfor
.undef _S

.endif # 0 

.endif # ${MODTYPE} == allsvcs
.endif # !defined(_ADM_SVCS_BUILD_MK_)

