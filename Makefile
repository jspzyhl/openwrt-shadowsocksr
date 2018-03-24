include $(TOPDIR)/rules.mk

PKG_NAME:=shadowsocksr-libev
PKG_VERSION:=2.5.3
PKG_RELEASE:=d63ff86

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/shadowsocksrr/shadowsocksr-libev.git
PKG_SOURCE_VERSION:=d63ff863800a5645aca4309d5dd5962bd1e95543
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)-$(PKG_SOURCE_VERSION)
PKG_SOURCE:=$(PKG_SOURCE_SUBDIR).tar.gz

PKG_LICENSE:=GPLv3
PKG_LICENSE_FILES:=LICENSE
PKG_MAINTAINER:=breakwa11

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_SOURCE_SUBDIR)

PKG_INSTALL:=1
PKG_FIXUP:=autoreconf
PKG_USE_MIPS16:=0
PKG_BUILD_PARALLEL:=1

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
  SECTION:=net
  CATEGORY:=Network
  SUBMENU:=Web Servers/Proxies
  TITLE:=Lightweight Secured Socks5 Proxy (OpenSSL)
  VARIANT:=openssl
  URL:=https://github.com/shadowsocksrr/shadowsocksr-libev
  DEPENDS:=+libpcre +libpthread +libopenssl +zlib
  DEPENDS+= +SSR_LIBEV_SSLIB:libev +SSR_LIBEV_SSLIB:libsodium +SSR_LIBEV_SSLIB:libudns
endef

define Package/$(PKG_NAME)/description
ShadowsocksR-libev is a lightweight secured socks5 proxy for embedded devices and low end boxes.
endef

define Package/$(PKG_NAME)/config
  source "$(SOURCE)/Config.in"
endef

CONFIGURE_ARGS += --disable-ssp --disable-documentation --disable-assert \
  $(if $(CONFIG_SSR_LIBEV_SSLIB),--enable-system-shared-lib)

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/src/ss-local $(1)/usr/bin/ssr-local
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/src/ss-redir $(1)/usr/bin/ssr-redir
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/src/ss-local $(1)/usr/bin/ssr-tunnel
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
