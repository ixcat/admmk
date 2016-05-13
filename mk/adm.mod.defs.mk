
# adm.mod.defs.mk
# ===============
# .. $Id$
#
# Define per-service stub targets when operating in host context which
# can be assembled into the global targets.  #
#
# For 'library' usage of service modules (e.g. from host dir),
# we define a host-specific target to be used by adm.host.build.mk
#
# In 'service' context (e.g. from service directory), 
# these targets are defined from adm.svc.build.mk and trigger the 
# appropriate related host specific sub-build.
#

.include <adm.mod.dirs.mk>
.include <adm.mod.files.mk>
.include <adm.act.inc.mk>

.if defined(TOPMODTYPE) # don't have topmod in svcbuild ctx

.include <adm.act.defs.mk>

# Define 'resolved' per-host targets for modules in hostbuild ctx-
# these targets refer to subdirectory driver targets in svcbuild 
# (and hostsbuild?) ctx and are created instead in the service 
# build makefile.

.  if ${TOPMODTYPE} == host
stage-${MODNAME}: objdir dirstage-${MODNAME} filestage-${MODNAME}
#    define action targets
.    if ${MODTYPE} != host
#    and build up resolved per-host targets
stage-${MODNAME}-${TOPMODNAME}: stage-${MODNAME}
push-${MODNAME}-${TOPMODNAME}: push-${MODNAME}
push-${MODNAME}:
	@echo ERROR: per-service push is not yet implemented.
	@exit 1
.    endif
.  endif
.endif # defined(TOPMODTYPE)

