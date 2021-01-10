################################################################################
#
# Aros
#
################################################################################

AROS_VERSION = 20210110
AROS_SOURCE = download
AROS_SITE = https://sourceforge.net/projects/aros/files/nightly2/$(AROS_VERSION)/Binaries/AROS-$(AROS_VERSION)-amiga-m68k-boot-iso.zip
AROS_LICENSE = Aros
AROS_DEPENDENCIES = amiberry

XORRISO := $(HOST_DIR)/bin/xorriso
ISO_NAME = aros-amiga-m68k
HDD = /home/user/hdd/
DH0_SYSTEM = $(HDD)/System/
DH1_WORK = $(HDD)/Work/

#do not check Amiga files target architecture
AROS_BIN_ARCH_EXCLUDE = $(HDD)

# extract into a flat directory structure
define AROS_EXTRACT_CMDS
        $(UNZIP) -j -d $(@D) $(AROS_DL_DIR)/$(AROS_SOURCE)
        $(XORRISO) -osirrox on -indev $(@D)/$(ISO_NAME).iso -extract / $(@D)/$(ISO_NAME)
endef

# remove installation and developer files
define AROS_CONFIGURE_CMDS
        rm -rf $(@D)/$(ISO_NAME)/.backdrop
        rm -rf $(@D)/$(ISO_NAME)/.gdbinit
        rm -rf $(@D)/$(ISO_NAME)/Developer
        rm -rf $(@D)/$(ISO_NAME)/Developer.info
        rm -rf $(@D)/$(ISO_NAME)/disk.info
        rm -rf $(@D)/$(ISO_NAME)/Emergency-Boot
        rm -rf $(@D)/$(ISO_NAME)/Emergency-Boot.adf
        rm -rf $(@D)/$(ISO_NAME)/Emergency-Boot.info
        rm -rf $(@D)/$(ISO_NAME)/Expansion
        rm -rf $(@D)/$(ISO_NAME)/README.txt
        rm -rf $(@D)/$(ISO_NAME)/README.txt.info
        rm -rf $(@D)/$(ISO_NAME)/Prefs/Env-Archive/SYS/Packages/Developer
endef

define AROS_INSTALL_TARGET_CMDS
        mkdir -p $(TARGET_DIR)/$(DH0_SYSTEM)
        mkdir -p $(TARGET_DIR)/$(DH1_WORK)
        cp -r $(@D)/$(ISO_NAME)/* $(TARGET_DIR)/$(DH0_SYSTEM)
# custom small changes (icons placement, screenmode...)
        cp -r $(BR2_EXTERNAL_FREEMIGA_PATH)/package/aros/hdd/* $(TARGET_DIR)/$(HDD)
endef

$(eval $(generic-package))
