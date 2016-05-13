
MODNAME=		s1
MODTYPE=		svc

# 1st include : get s1SRC and other stuffs 
.include <adm.svc.inc.mk>

S1CONF?=		${s1SRC}/s1.conf

MODFILES=		${S1CONF}
FILESNAME_${S1CONF}=	s1.conf

FILESDIR_${S1CONF}=	/s1.d
MODDIRS=		${FILESDIR_${S1CONF}}
MODDIRS+=		/bonusdir

# 2nd include: rerun loops to build up per-mod targs
.include <adm.svc.defs.mk>
	


