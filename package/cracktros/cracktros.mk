################################################################################
#
# cracktros
#
################################################################################

CRACKTROS_VERSION = latest
CRACKTROS_SOURCE = WHDICtros.lzh
CRACKTROS_SITE = http://archive.whdload.de
CRACKTROS_LICENSE = WHDLoad
CRACKTROS_DEPENDENCIES = host-lhasa aros

DH1_WORK = /home/user/hdd/Work/

#do not check Amiga files target architecture
CRACKTROS_BIN_ARCH_EXCLUDE = $(DH1_WORK)

define CRACKTROS_EXTRACT_CMDS
#        -j flat directory structure
        mkdir $(@D)/Cracktros
        $(HOST_DIR)/bin/lha xw=$(@D) $(CRACKTROS_DL_DIR)/$(CRACKTROS_SOURCE)
        find $(@D) -name *.lha -exec $(HOST_DIR)/bin/lha xw=$(@D)/Cracktros {} \;
endef

define CRACKTROS_INSTALL_TARGET_CMDS
        mkdir -p $(TARGET_DIR)/$(DH1_WORK)
        cp -r $(@D)/Cracktros $(TARGET_DIR)/$(DH1_WORK)
endef

$(eval $(generic-package))
