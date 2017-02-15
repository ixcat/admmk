# src/sys.mk: source tree 'system' definition file

.if !defined(_SRC_SYS_MK_)
_SRC_SYS_MK_=1

SYSHOSTS=	h1 h2 h3 example
SYSSVCS=	s1 s2

s1_HOSTS=	h1 h2
s2_HOSTS=	h2 h3

.endif # !defined(_SRC_SYS_MK_)



