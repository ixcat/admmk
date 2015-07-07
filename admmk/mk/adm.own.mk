
# top-level commands and variable settings for common items
#
#	$Id$
#	modified for the adm.mk framework from:
#	$NetBSD: bsd.own.mk,v 1.696.2.3 2012/09/17 19:00:33 riz Exp $


.if !defined(_ADM_OWN_MK_)
_ADM_OWN_MK_=1

# NEED_OWN_INSTALL_TARGET is set to "no" by pkgsrc/mk/bsd.pkg.mk to
# ensure that things defined by <bsd.own.mk> (default targets,
# INSTALL_FILE, etc.) are not conflicting with bsd.pkg.mk.
#
NEED_OWN_INSTALL_TARGET?=	yes

# Define default locations for common tools.

SYSNAME!=	uname -s

INSTALL=	/usr/bin/install
LN=		/bin/ln

.if ${SYSNAME} == 'OpenBSD'
LNSFORCE=	${LN} -shf
.else
LNSFORCE=	${LN} -sf
.endif

RM=		/bin/rm
RMDIR=		/bin/rmdir

# file owners/permissions

BINOWN?=	root
BINGRP?=	wheel
BINDIR?=	${DESTDIR}/bin
BINMODE?=	555
NONBINMODE?=	444


# target structure buildup

# generically

TARGETS+=	all clean cleandir depend dependall includes \
		install lint obj regress tags html analyze
PHONY_NOTMAIN = all clean cleandir depend dependall distclean includes \
		install lint obj regress beforedepend afterdepend \
		beforeinstall afterinstall realinstall realdepend realall \
		html subdir-all subdir-install subdir-depend analyze

.PHONY:		${PHONY_NOTMAIN}
.NOTMAIN:	${PHONY_NOTMAIN}


.if ${NEED_OWN_INSTALL_TARGET} != "no"
.if !target(install)
install:	beforeinstall .WAIT \
		subdir-install realinstall .WAIT \
		afterinstall
beforeinstall:
subdir-install:
realinstall:
afterinstall:
.endif
all:		realall subdir-all
subdir-all:
realall:
depend:		realdepend subdir-depend
subdir-depend:
realdepend:
distclean:	cleandir
cleandir:	clean

dependall:	.NOTMAIN realdepend .MAKE
	@cd "${.CURDIR}"; ${MAKE} realall
.endif	# ${NEED_OWN_INSTALL_TARGET} != "no"

#
# MK* options which default to "yes".
#
_MKVARS.yes= \
	MKDOC \
	MKOBJ
.for var in ${_MKVARS.yes}
${var}?=	yes
.endfor

#
# MK* options which default to "no".
#
_MKVARS.no= \
	MKDEBUG \
	MKUPDATE
.for var in ${_MKVARS.no}
${var}?=no
.endfor

#
# install(1) parameters.
#
COPY?=		-c
.if ${MKUPDATE} == "no"
PRESERVE?=
.else
PRESERVE?=	-p
.endif

.if ${NEED_OWN_INSTALL_TARGET} != "no"
INSTALL_DIR?=		${INSTALL} ${INSTPRIV} -d
INSTALL_FILE?=		${INSTALL} ${INSTPRIV} ${COPY} ${PRESERVE}
.endif

#
# MAKEDIRTARGET dir target [extra make(1) params]
#	run "cd $${dir} && ${MAKEDIRTARGETENV} ${MAKE} [params] $${target}", with a pretty message
#
MAKEDIRTARGETENV?=
MAKEDIRTARGET=\
	@_makedirtarget() { \
		dir="$$1"; shift; \
		target="$$1"; shift; \
		case "$${dir}" in \
		/*)	this="$${dir}/"; \
			real="$${dir}" ;; \
		.)	this="${_THISDIR_}"; \
			real="${.CURDIR}" ;; \
		*)	this="${_THISDIR_}$${dir}/"; \
			real="${.CURDIR}/$${dir}" ;; \
		esac; \
		show=$${this:-.}; \
		echo "\# $${target} ===> $${show%/}$${1:+	(with: $$@)}"; \
		cd "$${real}" \
		&& ${MAKEDIRTARGETENV} ${MAKE} _THISDIR_="$${this}" "$$@" $${target}; \
	}; \
	_makedirtarget

#
# todo: MAKEVERBOSE support goes here
#

_MKMSG?=	@echo '\#  '

_MKMSG_INSTALL?=	${_MKMSG} "install "

_MKTARGET_INSTALL?=	${_MKMSG_INSTALL} ${.TARGET}

.endif	# !defined(_BSD_OWN_MK_)
