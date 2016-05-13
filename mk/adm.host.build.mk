
# adm.host.build.mk
# =================
# $Id$

# one host scope build driver makefile.
#
# used from: per-host directory
# triggers: service builds for all configured services
#
# Note: the 'stage-hostname' target is *not* the same as 'stage-host' -
#   the 'stage-hostname' target refers to staging of the files defined in
#   the host module, whereas 'stage-host' is staging of all host-connected
#   modules (e.g. the host's services, etc)

.if !defined(_ADM_HOST_BUILD_MK_)
_ADM_HOST_BUILD_MK_=1
.if ${MODTYPE} == host

# stage-host
# ----------

stage-host: _stagehostbanner _stagehostsvcs

_stagehostbanner:
	@echo "# ==> staging host ${MODNAME} (DESTDIR=${DESTDIR})"

# always trigger the 'host module' target defined in adm.host.defs.mk

_stagehostsvcs: stage-hostmod-${TGTHOST}

# push-host
# ---------
#
# Use rdist to push host-specific files to target.
#
# TODO: proper 'phase' targets (e.g. so push doesn't fail if ! stage ? )
#
# XXX this could be much smarter since the obj directory is deterministic -
# e.g. we have enough information to build a comprehensive, file-by-file
# rdist config with makefile-specified per-file rdist options,
# split-up per-service actions, and conditional service update ...
#
# For now:
#
#  - generate a simple rdistfile which:
#    - pushes the object tree to the target
#    - eventually, have optional capability to trigger a generic reload script
#      - generic reload script will call per-service scripts
#      - which actually do the 'real work' of reloading the service
#
#  - this 'stupid' rdistfile looks something like this::
#
#      HOSTS = ( tgthostname )
#      FILES = ( . )
#      ${FILES} -> ${HOSTS}
#              install -owhole /;
#              cmdspecial "/path/to/magic/script";
#    
#    and is called like this::
#
#      rdist -f rdistfile
#
#  Issues:
#
#    - in addition to above, there is a potential race condition in pushing
#      when per-service targets are used in a certain way. 
#      See adm.svc.build.mk for more details.
#

push-host: push-${MODNAME}

push-${MODNAME}: _pushhostbanner _pushhostobj

_pushhostbanner:
	@echo "# ==> pushing to host ${MODNAME}"

HOSTRDIST=${DESTDIR}.rdist

${HOSTRDIST}:
	@echo "# ===> building rdist(1) configuration for ${MODNAME}"
	@echo "# generated file - changes will be lost" > ${.TARGET}
	@echo "HOSTS = ( ${TGTHOST} )" >> ${.TARGET}
	@echo "FILES = ( . )" >> ${.TARGET}
	@echo '$${FILES} -> $${HOSTS}' >> ${.TARGET}
	@echo "        install -owhole /;" >> ${.TARGET}
	@echo "        cmdspecial \"logger -t adm.mk 'rdist run completed'\";" \
		>> ${.TARGET}

_pushhostobj: _pushhostrdistfile

_pushhostrdistfile: ${HOSTRDIST}
	@echo "# ===> runnning rdist(1) for ${MODNAME}"
	@( cd ${OBJDIR} && rdist -f ${HOSTRDIST} )

# host actions
# ------------

.for _ACT in ${ACTLIST}
${_ACT}: _${_ACT}host
${_ACT}-hostmod-${MODNAME}: ${_ACT}-${MODNAME}
${_ACT}-host: ${_ACT}-${TGTHOST}
_${_ACT}host: ${_ACT}-host
.endfor
.undef _ACT

# host:service expansion
# ----------------------

.for S in ${SYSSVCS}
.  for SH in ${${S}_HOSTS}
.    if ${TGTHOST} == ${SH}
.    include "${SRCTOP}/svc/${S}/${S}.mk"
TGTSVCS+= ${S}
_stagehostsvcs: stage-${S}-${SH}
.      for _ACT in ${ACTLIST}
${_ACT}-${S}-${SH}: ${_ACT}-${S}
_${_ACT}host: ${_ACT}-${S}-${SH}
.      endfor
.    endif
.  endfor
.endfor

.undef SH
.undef S

# hostdebug
# =========

hostdebug:
	@echo "TGTHOST : ${TGTHOST}"
	@echo "TGTSVCS: ${TGTSVCS}"
	@echo "MODTYPE: ${MODTYPE}"
	@echo "MODPATH: ${MODPATH}"
	@echo "MODNAME: ${MODNAME}"
	@echo "TOPMODTYPE: ${TOPMODTYPE}"
	@echo "TOPMODNAME: ${TOPMODNAME}"

# reset vars to fixup service include side effects
MODTYPE=	${TOPMODTYPE}
MODNAME=	${TOPMODNAME}
MODPATH=	${TOPMODPATH}

.endif # ${MODTYPE} == host
.endif # !defined(_ADM_HOST_BUILD_MK_)

