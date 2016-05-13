
# sys.mk
# ======
#
# adm.mk bmake makefile library configuration file.
#
# required for bmake(1) 'library' (-m) usage
# used to define the system source tree and load system configuration from it
#
# $Id$

.if !defined(_SYS_MK_)
_SYS_MK_=1


SRCTOP=${SYS}/src
.include "${SRCTOP}/sys.mk"
.if (!defined(SYSHOSTS) || !defined(SYSSVCS))
.  error system definition incomplete - incomplete SRCTOP/sys.mk?
.endif

.endif # !defined(_SYS_MK_)

