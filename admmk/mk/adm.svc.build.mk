
# adm.svc.build.mk
# ================
# $Id$
#
# Per-service build logic.
#
# XXX: FIXME
#    
#   - 'installing' from module context stages that modules files
#     but currently relies on generic host rdist rule, which pushes
#     everything in destdir.. this could be problematic if e.g:
#      - s1 is staged for h1
#      - s2 is installed for h1
#        ... resulting in s1&s2 push when only s2 push was desired
#
#     this could be fixed by implementing per-service push mechanism and/or
#     enforcing that per-service push requires either a blank tree, or
#     that service push is somehow 'newer than' service stage, etc.
#
#     for now, burden of verification is on the user... 
#     cross noted in adm.host.build.mk 'install' / 'rdist' notes
#    

.if !defined(_ADM_SVC_BUILD_MK_)
.if ${MODTYPE} == svc
_ADM_SVC_BUILD_MK_=1

# dynamic target stubs
# --------------------

#
# basically, anything in '_' will create a set of
# macros which, when expanded (see below), will trigger running that 
# action in a subdirectory..
#

_SVCACTS=stage push ${ACTLIST}
.for _AA in ${_SVCACTS}
_AA_BT:= _${_AA}svcbanner
_AA_MT:= _${_AA}svc
__AA_T:= __${_AA}svctarg
${_AA}-svc: ${_AA}-${MODNAME}
${_AA}-${MODNAME}: ${_AA_BT} ${_AA_MT}
${_AA_BT}:
	@echo "# ==> ${_AA}-${MODNAME}"
${_AA_MT}:
${__AA_T}: .USE
	@echo "# ===> ${.TARGET}"
	@( cd ${SRCTOP}/host/${.TARGET:C/^${_AA}-${MODNAME}-//} \
		&& ${MAKE} ${.TARGET} )
.endfor
.undef _AA
.undef _AA_BT
.undef _AA_MT
.undef __AA_T
.undef _SVCACTS

# install target
# --------------

install-svc: stage-svc push-svc
install: install-svc

push: push-svc
push-svc: push-${MODNAME}

# target generation
# -----------------

.for _H in ${${MODNAME}_HOSTS}
.if ( ! ${TGTHOST} ) || (${TGTHOST} && ${_H} == ${TGTHOST})
_H_I:= install-${MODNAME}-${_H}
_H_S:= stage-${MODNAME}-${_H}
_H_P:= push-${MODNAME}-${_H}
.PHONY: ${_H_S} ${_H_P}
${_H_I}: ${_H_S} ${_H_P}
${_H_S}: __stagesvctarg
${_H_P}: __pushsvctarg
_stagesvc: ${_H_S}
_pushsvc: ${_H_P}
.for _AA in ${ACTLIST}
_H_AA:= ${_AA}-${MODNAME}-${_H}
.PHONY: ${_H_AA}
${_H_AA}: __${_AA}svctarg
_${_AA}svc: ${_H_AA}
${_AA}: ${_AA}-svc
.endfor
.undef _AA
.undef _H_I
.undef _H_S
.undef _H_P
.endif
.endfor

.endif # ${MODTYPE} == svc
.endif # !defined(_ADM_SVC_BUILD_MK_)

