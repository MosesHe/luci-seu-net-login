include $(TOPDIR)/rules.mk

PKG_NAME:=luci-seu-net-login
PKG_VERSION:=1.2
PKG_RELEASE:=1

PKG_LICENSE:=MIT

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
  SECTION:=luci
  CATEGORY:=LuCI
  SUBMENU:=3. Applications
  TITLE:=SEU Network Login for LuCI
  PKGARCH:=all
  DEPENDS:=+curl
endef

define Package/$(PKG_NAME)/description
  LuCI support for SEU Network Login
endef

define Build/Compile
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci
	$(CP) ./luasrc/* $(1)/usr/lib/lua/luci/
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) ./root/usr/bin/seu_net_login.sh $(1)/usr/bin/
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_CONF) ./root/etc/config/seu_net_login $(1)/etc/config/
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/view/seu_net_login
	$(INSTALL_DATA) ./luasrc/view/seu_net_login/* $(1)/usr/lib/lua/luci/view/seu_net_login/
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
