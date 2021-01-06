################################################################################
#
# WHDload
#
################################################################################

WHDLOAD_VERSION = latest
WHDLOAD_SOURCE = WHDLoad_usr_small.lha
WHDLOAD_SITE = http://whdload.de/whdload
WHDLOAD_LICENSE = WHDLoad
WHDLOAD_DEPENDENCIES = host-lhasa aros

DH0_SYSTEM = /home/user/hdd/System/

#do not check Amiga files target architecture
WHDLOAD_BIN_ARCH_EXCLUDE = $(DH0_SYSTEM)

define WHDLOAD_EXTRACT_CMDS
#        -j flat directory structure
        $(HOST_DIR)/bin/lha xw=$(@D) $(WHDLOAD_DL_DIR)/$(WHDLOAD_SOURCE)
endef

define WHDLOAD_INSTALL_TARGET_CMDS
        cp -r $(@D)/WHDLoad/C $(@D)/WHDLoad/Docs* $(@D)/WHDLoad/S $(TARGET_DIR)/$(DH0_SYSTEM)
endef

$(eval $(generic-package))
