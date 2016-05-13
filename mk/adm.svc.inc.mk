# adm.svc.inc.mk
# ==============
# $Id$
# 
# top-level service include file
#
# grr - this makes paths staticish again..
#  unless I want to define some top-level svcname:svcpath mapping
#  for now, use this and override locally when needed

MODTYPE:=			svc
SVCMODTOP:=			${SRCTOP}/${MODTYPE}
SVCMODNAME:=			${MODNAME}
SVCMODPATH?=			${SVCMODTOP}/${SVCMODNAME}
${SVCMODNAME}SRC:= 		${SVCMODPATH}

MODPATH:=			${SVCMODPATH}

