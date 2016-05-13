
MODNAME=		s2
MODTYPE=		svc

S2CONF?=		${s2SRC}/s2.conf

MODFILES=		${S2CONF}
FILESNAME_${S2CONF}=	s2.conf

.include <adm.svc.inc.mk>
.include <adm.svc.defs.mk>

