
# adm.mod.inc.mk
# ==============
#
# $Id$
#
# Top level definitions for modules

.if !defined(_TOPMOD_)
_TOPMOD_=1

TOPMODNAME:=	${MODNAME}
TOPMODTYPE:=	${MODTYPE}

# XXX: HACK
.include <adm.act.inc.mk>
.include <adm.${MODTYPE}.inc.mk>

TOPMODPATH:=	${MODPATH}

.endif

