################################################################################
#
# LHASA
#
################################################################################

LHASA_VERSION = 4382ea6b1914f37fef4f163ed79f71877433b17f
LHASA_SITE = $(call github,fragglet,lhasa,$(LHASA_VERSION))
LHASA_INSTALL_STAGING = YES
LHASA_DEPENDENCIES = host-autoconf
LHASA_LICENSE = ISC
LHASA_LICENSE_FILES = COPYING

LHASA_MAKE_OPTS += GIT_REV=$(LHASA_VERSION)

# This package uses autoconf, but not automake, so we need to call
# their special autogen.sh script, and have custom target and staging
# installation commands.

define LHASA_RUN_AUTOGEN
	cd $(@D) && PATH=$(BR_PATH) ./autogen.sh
endef
HOST_LHASA_PRE_CONFIGURE_HOOKS += LHASA_RUN_AUTOGEN

define HOST_LHASA_INSTALL_TARGET_CMDS
	$(HOST_TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) \
		PREFIX=/usr \
		STRIP=/bin/true \
		DESTDIR=$(TARGET_DIR) \
		install
endef

define HOST_LHASA_INSTALL_STAGING_CMDS
	$(HOST_TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) \
		PREFIX=/usr \
		STRIP=/bin/true \
		DESTDIR=$(STAGING_DIR) \
		install
endef

$(eval $(host-autotools-package))
