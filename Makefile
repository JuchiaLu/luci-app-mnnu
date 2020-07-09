include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-mnnu
PKG_VERSION:=1.0.0
PKG_RELEASE:=1

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/luci-app-mnnu
	SECTION:=LuCI
	CATEGORY:=LuCI
	SUBMENU:=3. Applications
	TITLE:=MNNU for LuCI
	PKGARCH:=all
endef

define Package/luci-app-mnnu/description
	LuCI Support for MNNU.
endef

define Package/luci-app-mnnu/conffiles
/etc/config/mnnu
endef

define Package/luci-app-mnnu/postinst
#!/bin/sh
if [ -z "$${IPKG_INSTROOT}" ]; then
	rm -rf /tmp/luci-indexcache /tmp/luci-modulecache
fi

if [ -z "$$IPKG_INSTROOT" ]; then
  ( . /etc/uci-defaults/luci-app-mnnu )
  rm -f /etc/uci-defaults/luci-app-mnnu
fi

exit 0
endef

define Build/Prepare
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/luci-app-mnnu/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) ./files/root/usr/bin/mnnu $(1)/usr/bin/mnnu
    
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_CONF) ./files/root/etc/config/mnnu $(1)/etc/config/mnnu
    
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/root/etc/init.d/mnnu $(1)/etc/init.d/mnnu
    
	$(INSTALL_DIR) $(1)/etc/uci-defaults
	$(INSTALL_DATA) ./files/root/etc/uci-defaults/luci-app-mnnu $(1)/etc/uci-defaults/luci-app-mnnu
    
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/model/cbi/mnnu
	$(INSTALL_DATA) ./files/luci/model/cbi/mnnu/mnnu.lua $(1)/usr/lib/lua/luci/model/cbi/mnnu/mnnu.lua
    
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/controller
	$(INSTALL_DATA) ./files/luci/controller/mnnu.lua $(1)/usr/lib/lua/luci/controller/mnnu.lua
endef

$(eval $(call BuildPackage,luci-app-mnnu))