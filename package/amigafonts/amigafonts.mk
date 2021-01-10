################################################################################
#
# amigafonts
#
################################################################################

AMIGAFONTS_VERSION = 1.02
AMIGAFONTS_SITE = $(call github,rewtnull,amigafonts,$(AMIGAFONTS_VERSION))
AMIGAFONTS_LICENSE = GPL-FE
AMIGAFONTS_LICENSE_FILES = README

define AMIGAFONTS_INSTALL_TARGET_CMDS
        find $(@D)/psf1 -name *.gz -exec gzip -d {} \;
        mkdir -p $(TARGET_DIR)/usr/share/amigafonts/
        cp -dpfr $(@D)/psf1/* $(TARGET_DIR)/usr/share/amigafonts/
endef

$(eval $(generic-package))
