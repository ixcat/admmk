
.include <adm.mod.defs.mk>

# define the stage-host-HOSTNAME target here to link the targets
# created by within the host module itself.

stage-hostmod-${MODNAME}: stage-${MODNAME}

