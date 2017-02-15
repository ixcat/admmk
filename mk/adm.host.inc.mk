
# adm.host.inc.mk: common variables for host-specific logic

# grr - this makes paths staticish again..
#  unless I want to define some top-level svcname:svcpath mapping
#  for now, use this and override locally when needed

MODTYPE:=			host
HOSTMODTOP:=			${SRCTOP}/${MODTYPE}
HOSTMODNAME:=			${MODNAME}
HOSTMODPATH?=			${HOSTMODTOP}/${HOSTMODNAME}
${HOSTMODNAME}SRC:= 		${HOSTMODPATH}

MODPATH:=			${HOSTMODPATH}
