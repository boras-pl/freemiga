################################################################################
#
# amiberry
#
################################################################################

AMIBERRY_VERSION = v3.3
AMIBERRY_SITE = https://github.com/midwan/amiberry.git
AMIBERRY_SITE_METHOD = git
AMIBERRY_GIT_SUBMODULES = YES
AMIBERRY_DEPENDENCIES = sdl2 sdl2_image sdl2_ttf libmpeg2 mpg123 flac libxml2

ifeq ($(BR2_aarch64),y)
	AMIBERRY_PLATFORM=pi64
else
	AMIBERRY_PLATFORM=rpi4-sdl2
endif

define AMIBERRY_BUILD_CMDS
	CFLAGS="$(TARGET_CFLAGS) $(COMPILER_COMMONS_GCC_LINKER_OPTIMIZATION_EXECUTABLE)" \
	CXXFLAGS="$(TARGET_CXXFLAGS) $(COMPILER_COMMONS_GCC_LINKER_OPTIMIZATION_EXECUTABLE)" \
	LDFLAGS="$(TARGET_LDFLAGS) $(COMPILER_COMMONS_GCC_LINKER_OPTIMIZATION_EXECUTABLE)" \
	$(MAKE) CXX="$(TARGET_CXX)" \
		CC="$(TARGET_CC)" \
		AS="$(TARGET_AS)" \
		STRIP="$(TARGET_STRIP)" \
		-C $(@D) \
		-f Makefile \
		PLATFORM="$(AMIBERRY_PLATFORM)"
endef

define AMIBERRY_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/amiberry $(TARGET_DIR)/usr/bin/amiberry
	mkdir -p $(TARGET_DIR)/usr/share/amiberry
	cp -R $(@D)/data $(TARGET_DIR)/usr/share/amiberry
	cp -R $(@D)/whdboot $(TARGET_DIR)/usr/share/amiberry
	rm $(TARGET_DIR)/usr/share/amiberry/whdboot/save-data/Savegames/foo.txt
	rm $(TARGET_DIR)/usr/share/amiberry/whdboot/save-data/Kickstarts/foo.txt
	rm $(TARGET_DIR)/usr/share/amiberry/whdboot/save-data/Debugs/foo.txt
	rm $(TARGET_DIR)/usr/share/amiberry/whdboot/save-data/Autoboots/foo.txt
endef

$(eval $(generic-package))
