
# build-time/buildtype definitions/logic

.if !defined(_ADM_BUILD_MK_)
_ADM_BUILD_MK_=1

# specfic build types
# ===================

.include <adm.hosts.build.mk>
.include <adm.host.build.mk>
.include <adm.svcs.build.mk>
.include <adm.svc.build.mk>
.include <adm.act.inc.mk>

# top-level target
# ================

# XXX support NATIVEMODE target chaining

.if 0 # REALLY A BLOCK COMMENT

    .if ${NATIVEMODE}
    install: stage
    stage: realstage
      ... realstage (common)
    push: stage nopush
    postinst: push localpost
      ... localpost:
    .else
    install: stage push
    stage: realstage
      ... realstage (common)
    push: realpush
    postinst: remotepost
    .endif

    realstage: <svcactions> <hostactions>
       svcactions:
          <svc>-install 

.endif # REALLY A BLOCK COMMENT

# Non-Host Builds
# ===============
#
.if ${TOPMODTYPE} != host
#
# define toplevel targets for non-host modules - 
# aka "is this a 'real build' or a 'driver build' ?"

# XXX: also for $ACTIONS ish?

# fixme: should this be more 'officialized' somewhere e.g. adm.own.mk?

TLTARGS=install stage push ${ACTLIST}
.for T in ${TLTARGS}
.  if !target(${T}-${MODNAME})
${T}-${MODNAME}: __${T}-${MODNAME}
.  endif
.  if !target(__${T}-${MODNAME})
__${T}-${MODNAME}:
	@echo "# ===> ${T}-${MODNAME}"
.  endif
${T}: ${T}-${MODNAME}
.endfor
.undef T
.undef TLTARGS

# Host Builds
# ===========
#
.else # ${TOPMODTYPE} == host

# native-mode host builds
# -----------------------
#
.  if ${NATIVEMODE} == 1
#

stage: stage-host

install: stage
push: stage
push-host: stage

# remote-mode host builds
# -----------------------
#
.  else # ${NATIVEMODE} != 1
#

install: stage push

stage: stage-host
push: push-host

.  endif # ${NATIVEMODE}
.endif # ${TOPMODTYPE} == host

# misc
# ====

showglobals:
	@echo globaltarg
	@echo BUILDHOST: ${BUILDHOST}
	@echo BUILDHOST_SHORT: ${BUILDHOST_SHORT}
	@echo TGTHOST: \'${TGTHOST}\'
	@echo TGTHOST_SHORT: ${TGTHOST_SHORT}
	@echo NATIVEMODE: ${NATIVEMODE}
	@echo PWD: ${PWD}
	@echo SRCTOP: ${SRCTOP}
	@echo SYSOBJDIR: ${SYSOBJDIR}
	@echo OBJDIR: ${OBJDIR}
	@echo DESTDIR: ${DESTDIR}
	@echo TGTSVCS: ${TGTSVCS}
	@echo
	@echo .TARGET : ${.TARGET}
	@echo .TARGETS : ${.TARGETS}
	@echo MAKE : ${MAKE}
	@echo .MAKE.LEVEL : ${.MAKE.LEVEL}
	@echo .MAKEFLAGS : ${MAKEFLAGS}
	@echo
	@echo TOPMAKE: ${TOPMAKE}
	@echo TOPMAKE_MODPATH: ${TOPMAKE_MODPATH}
	@echo TOPMAKE_TARGETS: ${TOPMAKE_TARGETS}
	@echo TOPMODNAME: ${TOPMODNAME}
	@echo TOPMODTYPE: ${TOPMODTYPE}
	@echo TOPMODPATH: ${TOPMODPATH}
	@echo
	@echo PRESERVE: ${PRESERVE}
	@echo INSTALL: ${INSTALL}
	@echo INSTALL_FILE: ${INSTALL_FILE}
	@echo MKUPDATE: ${MKUPDATE}

.endif # !defined(_ADM_BUILD_MK_)

