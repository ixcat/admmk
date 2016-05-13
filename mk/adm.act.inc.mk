
#
# adm.act.inc.mk
# ==============
#
# install 'action' framework
#
# $Id$
#
# This is a 2-component framework:
#
#   - action framework makefiles (adm.act.{inc,def,build?}.mk)
#   - per-service 'action' scripts
#
# The makefiles are used to define per-service targets,
# which in turn will trigger execution of the appropriate
# action script on the appropriate target.
#
# As an oversimplified example, if the framework is used to define an 
# action of 'svcstart', the makefile will create a 'modulename-svcstart'
# target, which will run ${SVCSCRIPTDIR}/${MODULENAME}.svc start
# on the target host over ssh in remote mode or simply run the command
# directly when operating in native build mode.
#
# Todo/Fixme:
#
#  - todo: top level 'driver' script for host-side client use
#    e.g. ~/bin/adm.svc svcname:action ...
#  - aggregate action target 'collection' 
#    (e.g. svc modules 'build up list' of appropriate actions)
#  - better integration with push logic 
#    (e.g. update svc if prereq file changed)
#  - possibly configurable list of actions? 
#    this probably depends on per-service definable targets so that
#    if a module creates a new action, other modules are not automatically 
#    expected to provide that action.
#

.if !defined(_ADM_ACT_MK_)
_ADM_ACT_MK_=1

ACTSCRIPTDIR=		/root/bin
ACTRSH=			ssh
ACTLIST=		bininstall \
			svcconfig svcstart svcstop \
			svcreload svcrestart

__mklocalact: .USE
	@echo "# => ${.TARGET:C/-.*//} ${.TARGET:C/.*-//}"
	@${${.TARGET}-cmd}

__mkremoteact: .USE
	@echo "# => ${.TARGET:C/-.*//} ${.TARGET:C/.*-//}"
	@${ACTRSH} ${TGTHOST} ${${.TARGET}-cmd}

.endif # !defined(_ADM_ACT_MK_)
