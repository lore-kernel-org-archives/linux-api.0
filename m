From: mark yao <yzq@rock-chips.com>
Subject: [PATCH 1/9] drm: Add drm driver for Rockchip Socs
Date: Mon,  4 Aug 2014 12:45:07 +0800
Message-ID: <1407127507-1612-1-git-send-email-yzq@rock-chips.com>
References: <1407127274-1356-1-git-send-email-mark.yao@rock-chips.com>
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <1407127274-1356-1-git-send-email-mark.yao@rock-chips.com>
Sender: linux-doc-owner@vger.kernel.org
To: heiko@sntech.de, Rob Clark <robdclark@gmail.com>, Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Randy Dunlap <rdunlap@infradead.org>, David Airlie <airlied@linux.ie>, Grant Likely <grant.likely@linaro.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, John Stultz <john.stultz@linaro.org>, Rom Lemarchand <romlem@google.com>
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-api@vger.kernel.org, olof@lixom.net, djkurtz@chromium.org, xjq@rock-chips.com, kfx@rock-chips.com, cym@rock-chips.com, cf@rock-chips.com, zyw@rock-chips.com, zwl@rock-chips.com, xxm@rock-chips.com, huangtao@rock-chips.com, kever.yang@rock-chips.com, zhangqing@rock-chips.com, yxj@rock-chips.com, wxt@rock-chips.com, xw@rock-chips.com, mark yao <yzq@rock-chips.com>
List-Id: linux-api@vger.kernel.org

This patch is a DRM Driver for Rockchip Socs, driver provides an abstraction
for the graphics hardware, such as lcd controller and connector interface.

Signed-off-by: mark yao <yzq@rock-chips.com>
---
 drivers/gpu/drm/Kconfig                           |    2 +
 drivers/gpu/drm/Makefile                          |    1 +
 drivers/gpu/drm/rockchip/Kconfig                  |   40 ++
 drivers/gpu/drm/rockchip/Makefile                 |   12 +
 drivers/gpu/drm/rockchip/rockchip_drm_connector.c |  412 ++++++++++++
 drivers/gpu/drm/rockchip/rockchip_drm_connector.h |   36 ++
 drivers/gpu/drm/rockchip/rockchip_drm_drv.c       |  600 +++++++++++++++++
 drivers/gpu/drm/rockchip/rockchip_drm_drv.h       |  128 ++++
 drivers/gpu/drm/rockchip/rockchip_drm_fb.c        |   48 ++
 drivers/gpu/drm/rockchip/rockchip_drm_fb.h        |   28 +
 drivers/gpu/drm/rockchip/rockchip_drm_fbdev.c     |   63 ++
 drivers/gpu/drm/rockchip/rockchip_drm_fbdev.h     |   24 +
 drivers/gpu/drm/rockchip/rockchip_drm_gem.c       |  163 +++++
 drivers/gpu/drm/rockchip/rockchip_drm_gem.h       |   40 ++
 drivers/gpu/drm/rockchip/rockchip_drm_lcdc.c      |  720 +++++++++++++++++++++
 drivers/gpu/drm/rockchip/rockchip_drm_lcdc.h      |  131 ++++
 include/uapi/drm/rockchip_drm.h                   |  110 ++++
 17 files changed, 2558 insertions(+)
 create mode 100644 drivers/gpu/drm/rockchip/Kconfig
 create mode 100644 drivers/gpu/drm/rockchip/Makefile
 create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_connector.c
 create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_connector.h
 create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_drv.c
 create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_drv.h
 create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_fb.c
 create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_fb.h
 create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_fbdev.c
 create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_fbdev.h
 create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_gem.c
 create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_gem.h
 create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_lcdc.c
 create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_lcdc.h
 create mode 100644 include/uapi/drm/rockchip_drm.h

diff --git a/drivers/gpu/drm/Kconfig b/drivers/gpu/drm/Kconfig
index f512004..5951c2c 100644
--- a/drivers/gpu/drm/Kconfig
+++ b/drivers/gpu/drm/Kconfig
@@ -170,6 +170,8 @@ config DRM_SAVAGE
 
 source "drivers/gpu/drm/exynos/Kconfig"
 
+source "drivers/gpu/drm/rockchip/Kconfig"
+
 source "drivers/gpu/drm/vmwgfx/Kconfig"
 
 source "drivers/gpu/drm/gma500/Kconfig"
diff --git a/drivers/gpu/drm/Makefile b/drivers/gpu/drm/Makefile
index dd2ba42..40babd2 100644
--- a/drivers/gpu/drm/Makefile
+++ b/drivers/gpu/drm/Makefile
@@ -51,6 +51,7 @@ obj-$(CONFIG_DRM_VMWGFX)+= vmwgfx/
 obj-$(CONFIG_DRM_VIA)	+=via/
 obj-$(CONFIG_DRM_NOUVEAU) +=nouveau/
 obj-$(CONFIG_DRM_EXYNOS) +=exynos/
+obj-$(CONFIG_DRM_ROCKCHIP) +=rockchip/
 obj-$(CONFIG_DRM_GMA500) += gma500/
 obj-$(CONFIG_DRM_UDL) += udl/
 obj-$(CONFIG_DRM_AST) += ast/
diff --git a/drivers/gpu/drm/rockchip/Kconfig b/drivers/gpu/drm/rockchip/Kconfig
new file mode 100644
index 0000000..592e999
--- /dev/null
+++ b/drivers/gpu/drm/rockchip/Kconfig
@@ -0,0 +1,40 @@
+config DRM_ROCKCHIP
+	tristate "DRM Support for Rockchip"
+	depends on DRM
+	select DRM_KMS_HELPER
+	select DRM_KMS_FB_HELPER
+	select DRM_KMS_CMA_HELPER
+	select DRM_GEM_CMA_HELPER
+	select DRM_PANEL
+	select FB_CFB_FILLRECT
+	select FB_CFB_COPYAREA
+	select FB_CFB_IMAGEBLIT
+	select VT_HW_CONSOLE_BINDING if FRAMEBUFFER_CONSOLE
+	select VIDEOMODE_HELPERS
+	select OF
+	help
+	  Choose this option if you have a Rockchip soc chipset.
+	  This driver provides kernel mode setting and buffer
+	  management to userspace. This driver does not provides
+	  2D or 3D acceleration; acceleration is performed by other
+	  IP found on the SoC.
+
+config DRM_ROCKCHIP_LCDC
+	bool "ROCKCHIP DRM LCDC"
+	depends on DRM_ROCKCHIP
+	select FB_MODE_HELPERS
+	help
+	  Choose this option if you want to use Rockchip lcdc for DRM.
+	  The driver provides an abstraction for Rockchip lcd controller,
+	  lcd controller is the display interface from memory frame buffer
+	  to display device.
+
+config DRM_ROCKCHIP_CONNECTOR
+	bool "ROCKCHIP DRM CONNECTOR"
+	depends on OF && DRM_ROCKCHIP && DRM_ROCKCHIP_LCDC
+	select FB_MODE_HELPERS
+	select VIDEOMODE_HELPERS
+	help
+	  Choose this option if you want to use Rockchip Primary DISPLAY.
+	  The driver provides an abstraction for Rockchip display devices,
+	  such as lcd plane, lvds, edp , mipi, etc.
diff --git a/drivers/gpu/drm/rockchip/Makefile b/drivers/gpu/drm/rockchip/Makefile
new file mode 100644
index 0000000..45c9d50
--- /dev/null
+++ b/drivers/gpu/drm/rockchip/Makefile
@@ -0,0 +1,12 @@
+#
+# Makefile for the drm device driver.  This driver provides support for the
+# Direct Rendering Infrastructure (DRI) in XFree86 4.1.0 and higher.
+
+ccflags-y := -Iinclude/drm -Idrivers/gpu/drm/rockchip
+
+rockchipdrm-y := rockchip_drm_drv.o rockchip_drm_gem.o \
+		rockchip_drm_fb.o rockchip_drm_fbdev.o
+
+obj-$(CONFIG_DRM_ROCKCHIP_CONNECTOR) += rockchip_drm_connector.o
+obj-$(CONFIG_DRM_ROCKCHIP_LCDC) += rockchip_drm_lcdc.o
+obj-$(CONFIG_DRM_ROCKCHIP) += rockchipdrm.o
diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_connector.c b/drivers/gpu/drm/rockchip/rockchip_drm_connector.c
new file mode 100644
index 0000000..337b618
--- /dev/null
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_connector.c
@@ -0,0 +1,412 @@
+/*
+ * Copyright (C) Fuzhou Rockchip Electronics Co.Ltd
+ * Author:mark yao <mark.yao@rock-chips.com>
+ *
+ * based on exynos_drm_dpi.c
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <drm/drmP.h>
+#include <drm/drm_crtc_helper.h>
+#include <drm/drm_panel.h>
+
+#include <linux/component.h>
+
+#include <video/of_videomode.h>
+#include <video/videomode.h>
+
+#include "rockchip_drm_drv.h"
+#include "rockchip_drm_connector.h"
+#include "rockchip_drm_lcdc.h"
+
+struct rockchip_conn_context {
+	struct device *dev;
+
+	struct drm_panel *panel;
+	struct rockchip_connector *conn;
+	struct drm_connector connector;
+	struct drm_encoder encoder;
+
+	struct drm_display_mode mode;
+
+	u32 flags;
+	int type;
+
+	int dpms_mode;
+};
+
+#define connector_to_ctx(c) \
+		container_of(c, struct rockchip_conn_context, connector)
+
+#define encoder_to_ctx(c) \
+		container_of(c, struct rockchip_conn_context, encoder)
+
+static inline int rockchip_convert_conn_type(int type)
+{
+	switch (type) {
+	case ROCKCHIP_DISPLAY_TYPE_RGB:
+	case ROCKCHIP_DISPLAY_TYPE_LVDS:
+		return DRM_MODE_CONNECTOR_LVDS;
+	case ROCKCHIP_DISPLAY_TYPE_EDP:
+		return DRM_MODE_CONNECTOR_eDP;
+	}
+
+	return  DRM_MODE_CONNECTOR_Unknown;
+}
+
+static inline int rockchip_convert_encoder_type(int type)
+{
+	switch (type) {
+	case ROCKCHIP_DISPLAY_TYPE_RGB:
+	case ROCKCHIP_DISPLAY_TYPE_LVDS:
+	case ROCKCHIP_DISPLAY_TYPE_EDP:
+		return DRM_MODE_ENCODER_LVDS;
+	}
+
+	return DRM_MODE_ENCODER_NONE;
+}
+
+static enum drm_connector_status
+rockchip_conn_detect(struct drm_connector *connector, bool force)
+{
+	return true;
+}
+
+static void rockchip_connector_destroy(struct drm_connector *connector)
+{
+	drm_sysfs_connector_remove(connector);
+	drm_connector_cleanup(connector);
+}
+
+static struct drm_connector_funcs rockchip_connector_funcs = {
+	.dpms = drm_helper_connector_dpms,
+	.detect = rockchip_conn_detect,
+	.fill_modes = drm_helper_probe_single_connector_modes,
+	.destroy = rockchip_connector_destroy,
+};
+
+static int rockchip_conn_get_modes(struct drm_connector *connector)
+{
+	struct rockchip_conn_context *ctx = connector_to_ctx(connector);
+	struct drm_panel *panel = ctx->panel;
+
+	return panel->funcs->get_modes(panel);
+}
+
+static struct drm_encoder *
+	rockchip_conn_best_encoder(struct drm_connector *connector)
+{
+	struct rockchip_conn_context *ctx = connector_to_ctx(connector);
+
+	return &ctx->encoder;
+}
+
+static struct drm_connector_helper_funcs rockchip_connector_helper_funcs = {
+	.get_modes = rockchip_conn_get_modes,
+	.best_encoder = rockchip_conn_best_encoder,
+};
+
+static void rockchip_drm_encoder_dpms(struct drm_encoder *encoder, int mode)
+{
+	struct rockchip_conn_context *ctx = encoder_to_ctx(encoder);
+	struct rockchip_connector *conn = ctx->conn;
+
+	switch (mode) {
+	case DRM_MODE_DPMS_ON:
+		if (ctx->dpms_mode != DRM_MODE_DPMS_ON) {
+			conn->enable(conn);
+			ctx->panel->funcs->enable(ctx->panel);
+		}
+		break;
+	case DRM_MODE_DPMS_STANDBY:
+	case DRM_MODE_DPMS_SUSPEND:
+	case DRM_MODE_DPMS_OFF:
+		if (ctx->dpms_mode == DRM_MODE_DPMS_ON) {
+			ctx->panel->funcs->disable(ctx->panel);
+			conn->disable(conn);
+		}
+		break;
+	default:
+		break;
+	}
+
+	ctx->dpms_mode = mode;
+}
+
+static bool
+rockchip_drm_encoder_mode_fixup(struct drm_encoder *encoder,
+				const struct drm_display_mode *mode,
+				struct drm_display_mode *adjusted_mode)
+{
+	struct rockchip_panel_special *priv_mode =
+					(void *)adjusted_mode->private;
+	struct rockchip_conn_context *ctx = encoder_to_ctx(encoder);
+
+	priv_mode->out_type = ctx->conn->type;
+
+	return true;
+}
+
+static void rockchip_drm_encoder_mode_set(struct drm_encoder *encoder,
+					  struct drm_display_mode *mode,
+					  struct drm_display_mode *adjusted)
+{
+	/* just set dummy now */
+}
+
+static void rockchip_drm_encoder_prepare(struct drm_encoder *encoder)
+{
+	/* drm framework doesn't check NULL. */
+}
+
+static void rockchip_drm_encoder_commit(struct drm_encoder *encoder)
+{
+	rockchip_drm_encoder_dpms(encoder, DRM_MODE_DPMS_ON);
+}
+
+static void rockchip_drm_encoder_disable(struct drm_encoder *encoder)
+{
+	struct drm_plane *plane;
+	struct drm_device *dev = encoder->dev;
+
+	rockchip_drm_encoder_dpms(encoder, DRM_MODE_DPMS_OFF);
+
+	/* all planes connected to this encoder should be also disabled. */
+	list_for_each_entry(plane, &dev->mode_config.plane_list, head) {
+		if (plane->crtc && (plane->crtc == encoder->crtc))
+			plane->funcs->disable_plane(plane);
+	}
+}
+
+
+static struct drm_encoder_helper_funcs rockchip_encoder_helper_funcs = {
+	.dpms = rockchip_drm_encoder_dpms,
+	.mode_fixup = rockchip_drm_encoder_mode_fixup,
+	.mode_set = rockchip_drm_encoder_mode_set,
+	.prepare = rockchip_drm_encoder_prepare,
+	.commit = rockchip_drm_encoder_commit,
+	.disable = rockchip_drm_encoder_disable,
+};
+static void rockchip_drm_encoder_destroy(struct drm_encoder *encoder)
+{
+	drm_encoder_cleanup(encoder);
+}
+
+static struct drm_encoder_funcs rockchip_encoder_funcs = {
+	.destroy = rockchip_drm_encoder_destroy,
+};
+
+static unsigned int rockchip_drm_encoder_clones(struct drm_encoder *encoder)
+{
+	struct rockchip_conn_context *ctx = encoder_to_ctx(encoder);
+	struct drm_encoder *clone;
+	struct drm_device *dev = encoder->dev;
+	unsigned int clone_mask = 0;
+	int cnt = 0;
+
+	list_for_each_entry(clone, &dev->mode_config.encoder_list, head) {
+		switch (ctx->type) {
+		case ROCKCHIP_DISPLAY_TYPE_RGB:
+		case ROCKCHIP_DISPLAY_TYPE_LVDS:
+		case ROCKCHIP_DISPLAY_TYPE_EDP:
+		case ROCKCHIP_DISPLAY_TYPE_HDMI:
+			clone_mask |= (1 << (cnt++));
+			break;
+		default:
+			continue;
+		}
+	}
+
+	return clone_mask;
+}
+
+static int rockchip_conn_bind(struct device *dev, struct device *master,
+			      void *data)
+{
+	struct rockchip_conn_context *ctx;
+	unsigned long possible_crtcs = 0;
+	struct drm_encoder *encoder;
+	struct drm_connector *connector;
+	struct device_node *panel_node;
+	struct drm_device *drm_dev = data;
+	int ret;
+
+	ctx = rockchip_drm_component_data_get(dev,
+					      ROCKCHIP_DEVICE_TYPE_CONNECTOR);
+	if (!ctx) {
+		DRM_ERROR("can't find dp content form component\n");
+		return -EINVAL;
+	}
+
+	ret = rockchip_drm_pipe_get(dev);
+	if (ret < 0) {
+		DRM_ERROR("failed to bind display port\n");
+		return ret;
+	}
+
+	possible_crtcs |= 1 << ret;
+
+	encoder = &ctx->encoder;
+	encoder->possible_crtcs = possible_crtcs;
+
+	DRM_DEBUG_KMS("possible_crtcs = 0x%x\n", encoder->possible_crtcs);
+
+	ret = drm_encoder_init(drm_dev, encoder, &rockchip_encoder_funcs,
+			       rockchip_convert_encoder_type(ctx->type));
+	if (ret) {
+		DRM_ERROR("failed to initialize encoder with drm\n");
+		return ret;
+	}
+
+	drm_encoder_helper_add(encoder, &rockchip_encoder_helper_funcs);
+
+	connector = &ctx->connector;
+	connector->polled = DRM_CONNECTOR_POLL_HPD;
+	connector->dpms = DRM_MODE_DPMS_OFF;
+
+	ret = drm_connector_init(drm_dev, connector,
+				 &rockchip_connector_funcs,
+				 rockchip_convert_conn_type(ctx->type));
+	if (ret) {
+		DRM_ERROR("failed to initialize connector with drm\n");
+		goto err_free_encoder;
+	}
+
+	drm_connector_helper_add(connector,
+				 &rockchip_connector_helper_funcs);
+
+	ret = drm_sysfs_connector_add(connector);
+	if (ret) {
+		DRM_ERROR("failed to add drm_sysfs\n");
+		goto err_free_connector;
+	}
+
+	ret = drm_mode_connector_attach_encoder(connector, encoder);
+	if (ret) {
+		DRM_ERROR("failed to attach connector and encoder\n");
+		goto err_free_connector_sysfs;
+	}
+
+	panel_node = of_parse_phandle(dev->of_node, "rockchip,panel", 0);
+	if (!panel_node) {
+		DRM_ERROR("failed to find diaplay panel\n");
+		goto err_free_connector_sysfs;
+	}
+	ctx->panel = of_drm_find_panel(panel_node);
+	if (!ctx->panel) {
+		DRM_ERROR("failed to find diaplay panel\n");
+		ret = -ENODEV;
+		goto err_free_connector_sysfs;
+	}
+
+	of_node_put(panel_node);
+
+	ret = drm_panel_attach(ctx->panel, connector);
+	if (ret) {
+		DRM_ERROR("failed to attach connector and encoder\n");
+		goto err_free_connector_sysfs;
+	}
+
+	return 0;
+
+err_free_connector_sysfs:
+	drm_sysfs_connector_remove(connector);
+err_free_connector:
+	drm_connector_cleanup(connector);
+err_free_encoder:
+	drm_encoder_cleanup(encoder);
+	return ret;
+}
+
+static void rockchip_conn_unbind(struct device *dev, struct device *master,
+				 void *data)
+{
+	struct rockchip_conn_context *ctx;
+	struct drm_encoder *encoder;
+
+	ctx = rockchip_drm_component_data_get(dev,
+					      ROCKCHIP_DEVICE_TYPE_CONNECTOR);
+	encoder = &ctx->encoder;
+
+	drm_panel_detach(ctx->panel);
+
+	rockchip_drm_encoder_dpms(encoder, DRM_MODE_DPMS_OFF);
+	encoder->funcs->destroy(encoder);
+	drm_sysfs_connector_remove(&ctx->connector);
+	drm_connector_cleanup(&ctx->connector);
+	drm_encoder_cleanup(encoder);
+
+	rockchip_drm_component_del(dev, ROCKCHIP_DEVICE_TYPE_CONNECTOR);
+}
+
+static const struct component_ops rockchip_conn_component_ops = {
+	.bind = rockchip_conn_bind,
+	.unbind = rockchip_conn_unbind,
+};
+
+void *rockchip_connector_register(struct rockchip_connector *conn)
+{
+	struct rockchip_conn_context *ctx;
+	struct device *dev = conn->dev;
+	int ret;
+
+	if (!dev) {
+		DRM_ERROR("please provide a device at dp register\n");
+		return NULL;
+	}
+
+	ctx = devm_kzalloc(dev, sizeof(*ctx), GFP_KERNEL);
+	if (!ctx)
+		return NULL;
+
+	ret = rockchip_drm_component_add(dev, ROCKCHIP_DEVICE_TYPE_CONNECTOR,
+					 conn->type, ctx);
+	if (ret < 0) {
+		DRM_ERROR("register connector component fail ret =%d\n", ret);
+		return NULL;
+	}
+
+	ctx->conn = conn;
+	ctx->dev = dev;
+	ctx->type = conn->type;
+	ctx->dpms_mode = DRM_MODE_DPMS_OFF;
+
+	ret = component_add(dev, &rockchip_conn_component_ops);
+	if (ret)
+		goto err_del_component;
+
+	DRM_DEBUG_KMS("succes register connector type=%d\n", conn->type);
+
+	return ctx;
+
+err_del_component:
+	rockchip_drm_component_del(dev, ROCKCHIP_DEVICE_TYPE_CONNECTOR);
+	return NULL;
+}
+
+void rockchip_connector_unregister(void *data)
+{
+	struct rockchip_conn_context *ctx = data;
+
+	if (!ctx)
+		return;
+	rockchip_drm_component_del(ctx->dev, ROCKCHIP_DEVICE_TYPE_CONNECTOR);
+	component_del(ctx->dev, &rockchip_conn_component_ops);
+}
+
+void rockchip_drm_encoder_setup(struct drm_device *dev)
+{
+	struct drm_encoder *encoder;
+
+	list_for_each_entry(encoder, &dev->mode_config.encoder_list, head)
+		encoder->possible_clones =
+				rockchip_drm_encoder_clones(encoder);
+}
diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_connector.h b/drivers/gpu/drm/rockchip/rockchip_drm_connector.h
new file mode 100644
index 0000000..191f9fc
--- /dev/null
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_connector.h
@@ -0,0 +1,36 @@
+/*
+ * Copyright (C) Fuzhou Rockchip Electronics Co.Ltd
+ * Author:mark yao <mark.yao@rock-chips.com>
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef _ROCKCHIP_DRM_CONNECTOR_H_
+#define _ROCKCHIP_DRM_CONNECTOR_H_
+
+#include <drm/drm_crtc.h>
+
+#include "rockchip_drm_drv.h"
+
+struct rockchip_connector {
+	struct device *dev;
+	int type;
+	void *priv;
+	u32 flags;
+
+	void (*enable)(struct rockchip_connector *conn);
+	void (*disable)(struct rockchip_connector *conn);
+	int (*setmode)(struct rockchip_connector *conn,
+		       struct drm_display_mode *mode);
+};
+
+void *rockchip_connector_register(struct rockchip_connector *conn);
+void rockchip_connector_unregister(void *data);
+#endif
diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_drv.c b/drivers/gpu/drm/rockchip/rockchip_drm_drv.c
new file mode 100644
index 0000000..4871867
--- /dev/null
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_drv.c
@@ -0,0 +1,600 @@
+/*
+ * Copyright (C) Fuzhou Rockchip Electronics Co.Ltd
+ * Author:mark yao <mark.yao@rock-chips.com>
+ *
+ * based on exynos_drm_drv.c
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/pm_runtime.h>
+#include <drm/drmP.h>
+#include <drm/drm_crtc_helper.h>
+#include <drm/drm_gem_cma_helper.h>
+
+#include <linux/anon_inodes.h>
+#include <linux/component.h>
+
+#include <drm/rockchip_drm.h>
+
+#include "rockchip_drm_drv.h"
+#include "rockchip_drm_fb.h"
+#include "rockchip_drm_fbdev.h"
+#include "rockchip_drm_gem.h"
+
+#define DRIVER_NAME	"rockchip-drm"
+#define DRIVER_DESC	"RockChip Soc DRM"
+#define DRIVER_DATE	"20140725"
+#define DRIVER_MAJOR	1
+#define DRIVER_MINOR	0
+
+#define VBLANK_OFF_DELAY	50000
+
+static struct platform_device *rockchip_drm_pdev;
+
+static DEFINE_MUTEX(drm_component_lock);
+static LIST_HEAD(drm_component_list);
+
+struct component_dev {
+	struct list_head list;
+	struct device *crtc_dev;
+	struct device *conn_dev;
+	unsigned int out_type;
+	int pipe;
+	void *crtc_data;
+	void *conn_data;
+};
+
+static int rockchip_drm_load(struct drm_device *dev, unsigned long flags)
+{
+	struct rockchip_drm_private *private;
+	int ret;
+	int nr;
+
+	private = kzalloc(sizeof(*private), GFP_KERNEL);
+	if (!private)
+		return -ENOMEM;
+
+	dev_set_drvdata(dev->dev, dev);
+	dev->dev_private = (void *)private;
+
+	drm_mode_config_init(dev);
+
+	rockchip_drm_mode_config_init(dev);
+
+
+	/* Try to bind all sub drivers. */
+	ret = component_bind_all(dev->dev, dev);
+	if (ret)
+		goto err_cleanup_vblank;
+
+	for (nr = 0; nr < MAX_PLANE; nr++) {
+		struct drm_plane *plane;
+		unsigned long possible_crtcs = (1 << MAX_CRTC) - 1;
+
+		plane = rockchip_plane_init(dev, possible_crtcs, false);
+		if (!plane)
+			goto err_mode_config_cleanup;
+	}
+
+	/* init kms poll for handling hpd */
+	drm_kms_helper_poll_init(dev);
+
+	ret = drm_vblank_init(dev, MAX_CRTC);
+	if (ret)
+		goto err_mode_config_cleanup;
+
+	/* setup possible_clones. */
+	rockchip_drm_encoder_setup(dev);
+
+	drm_vblank_offdelay = VBLANK_OFF_DELAY;
+
+	platform_set_drvdata(dev->platformdev, dev);
+	rockchip_drm_fbdev_init(dev);
+
+	/* force connectors detection */
+	drm_helper_hpd_irq_event(dev);
+
+	return 0;
+
+err_cleanup_vblank:
+	drm_vblank_cleanup(dev);
+err_mode_config_cleanup:
+	drm_mode_config_cleanup(dev);
+	kfree(private);
+
+	return ret;
+}
+
+static int rockchip_drm_unload(struct drm_device *dev)
+{
+	rockchip_drm_fbdev_fini(dev);
+	drm_vblank_cleanup(dev);
+	drm_kms_helper_poll_fini(dev);
+	drm_mode_config_cleanup(dev);
+
+	kfree(dev->dev_private);
+
+	component_unbind_all(dev->dev, dev);
+	dev->dev_private = NULL;
+
+	return 0;
+}
+
+static int rockchip_drm_suspend(struct drm_device *dev, pm_message_t state)
+{
+	struct drm_connector *connector;
+
+	drm_modeset_lock_all(dev);
+	list_for_each_entry(connector, &dev->mode_config.connector_list, head) {
+		int old_dpms = connector->dpms;
+
+		if (connector->funcs->dpms)
+			connector->funcs->dpms(connector, DRM_MODE_DPMS_OFF);
+
+		/* Set the old mode back to the connector for resume */
+		connector->dpms = old_dpms;
+	}
+	drm_modeset_unlock_all(dev);
+
+	return 0;
+}
+
+static int rockchip_drm_resume(struct drm_device *dev)
+{
+	struct drm_connector *connector;
+
+	drm_modeset_lock_all(dev);
+	list_for_each_entry(connector, &dev->mode_config.connector_list, head) {
+		if (connector->funcs->dpms)
+			connector->funcs->dpms(connector, connector->dpms);
+	}
+	drm_modeset_unlock_all(dev);
+
+	drm_helper_resume_force_mode(dev);
+
+	return 0;
+}
+
+static int rockchip_drm_open(struct drm_device *dev, struct drm_file *file)
+{
+	return 0;
+}
+
+static void rockchip_drm_postclose(struct drm_device *dev,
+				   struct drm_file *file)
+{
+	struct drm_pending_event *e, *et;
+	unsigned long flags;
+
+	if (!file->driver_priv)
+		return;
+
+	/* Release all events not unhandled by page flip handler. */
+	rockchip_drm_crtc_cancel_pending_flip(dev);
+
+	spin_lock_irqsave(&dev->event_lock, flags);
+
+	/* Release all events handled by page flip handler but not freed. */
+	list_for_each_entry_safe(e, et, &file->event_list, link) {
+		list_del(&e->link);
+		e->destroy(e);
+	}
+
+	spin_unlock_irqrestore(&dev->event_lock, flags);
+
+	kfree(file->driver_priv);
+	file->driver_priv = NULL;
+}
+
+static const struct drm_ioctl_desc rockchip_ioctls[] = {
+	DRM_IOCTL_DEF_DRV(ROCKCHIP_GEM_CREATE, rockchip_drm_gem_create_ioctl,
+			  DRM_UNLOCKED | DRM_AUTH),
+	DRM_IOCTL_DEF_DRV(ROCKCHIP_GEM_MAP_OFFSET,
+			  rockchip_drm_gem_map_offset_ioctl, DRM_UNLOCKED |
+			  DRM_AUTH),
+	DRM_IOCTL_DEF_DRV(ROCKCHIP_GEM_MMAP, rockchip_drm_gem_mmap_ioctl,
+			  DRM_UNLOCKED | DRM_AUTH),
+	DRM_IOCTL_DEF_DRV(ROCKCHIP_GEM_GET, rockchip_drm_gem_get_ioctl,
+			  DRM_UNLOCKED),
+};
+
+static const struct file_operations rockchip_drm_driver_fops = {
+	.owner = THIS_MODULE,
+	.open = drm_open,
+	.mmap = drm_gem_cma_mmap,
+	.poll = drm_poll,
+	.read = drm_read,
+	.unlocked_ioctl = drm_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl = drm_compat_ioctl,
+#endif
+	.release = drm_release,
+};
+
+static struct drm_driver rockchip_drm_driver = {
+	.driver_features	= DRIVER_MODESET | DRIVER_GEM | DRIVER_PRIME,
+	.load			= rockchip_drm_load,
+	.unload			= rockchip_drm_unload,
+	.suspend		= rockchip_drm_suspend,
+	.resume			= rockchip_drm_resume,
+	.open			= rockchip_drm_open,
+	.postclose		= rockchip_drm_postclose,
+	.get_vblank_counter	= drm_vblank_count,
+	.enable_vblank		= rockchip_drm_crtc_enable_vblank,
+	.disable_vblank		= rockchip_drm_crtc_disable_vblank,
+	.gem_free_object        = drm_gem_cma_free_object,
+	.gem_vm_ops             = &drm_gem_cma_vm_ops,
+	.dumb_create            = drm_gem_cma_dumb_create,
+	.dumb_map_offset        = drm_gem_cma_dumb_map_offset,
+	.dumb_destroy           = drm_gem_dumb_destroy,
+	.prime_handle_to_fd	= drm_gem_prime_handle_to_fd,
+	.prime_fd_to_handle	= drm_gem_prime_fd_to_handle,
+	.gem_prime_import       = drm_gem_prime_import,
+	.gem_prime_export       = drm_gem_prime_export,
+	.gem_prime_get_sg_table = drm_gem_cma_prime_get_sg_table,
+	.gem_prime_import_sg_table = drm_gem_cma_prime_import_sg_table,
+	.gem_prime_vmap         = drm_gem_cma_prime_vmap,
+	.gem_prime_vunmap       = drm_gem_cma_prime_vunmap,
+	.gem_prime_mmap         = drm_gem_cma_prime_mmap,
+	.ioctls			= rockchip_ioctls,
+	.num_ioctls		= ARRAY_SIZE(rockchip_ioctls),
+	.fops			= &rockchip_drm_driver_fops,
+	.name	= DRIVER_NAME,
+	.desc	= DRIVER_DESC,
+	.date	= DRIVER_DATE,
+	.major	= DRIVER_MAJOR,
+	.minor	= DRIVER_MINOR,
+};
+
+#ifdef CONFIG_PM_SLEEP
+static int rockchip_drm_sys_suspend(struct device *dev)
+{
+	struct drm_device *drm_dev = dev_get_drvdata(dev);
+	pm_message_t message;
+
+	if (pm_runtime_suspended(dev))
+		return 0;
+
+	message.event = PM_EVENT_SUSPEND;
+
+	return rockchip_drm_suspend(drm_dev, message);
+}
+
+static int rockchip_drm_sys_resume(struct device *dev)
+{
+	struct drm_device *drm_dev = dev_get_drvdata(dev);
+
+	if (pm_runtime_suspended(dev))
+		return 0;
+
+	return rockchip_drm_resume(drm_dev);
+}
+#endif
+
+static const struct dev_pm_ops rockchip_drm_pm_ops = {
+	SET_SYSTEM_SLEEP_PM_OPS(rockchip_drm_sys_suspend,
+				rockchip_drm_sys_resume)
+};
+
+int rockchip_drm_pipe_get(struct device *dev)
+{
+	struct component_dev *cdev, *next;
+	int pipe = -1;
+
+	mutex_lock(&drm_component_lock);
+
+	list_for_each_entry_safe(cdev, next, &drm_component_list, list) {
+		if ((cdev->crtc_dev == dev) || (cdev->conn_dev == dev)) {
+			pipe = cdev->pipe;
+			break;
+		}
+	}
+
+	mutex_unlock(&drm_component_lock);
+
+	return pipe;
+}
+
+int rockchip_drm_out_type_get(struct device *dev)
+{
+	struct component_dev *cdev, *next;
+	int type = -1;
+
+	mutex_lock(&drm_component_lock);
+
+	list_for_each_entry_safe(cdev, next, &drm_component_list, list) {
+		if ((cdev->crtc_dev == dev) || (cdev->conn_dev == dev)) {
+			type = cdev->out_type;
+			break;
+		}
+	}
+
+	mutex_unlock(&drm_component_lock);
+
+	return type;
+}
+
+void *rockchip_drm_component_data_get(struct device *dev,
+				      enum rockchip_drm_device_type dev_type)
+{
+	struct component_dev *cdev, *next;
+	void *data = NULL;
+
+	mutex_lock(&drm_component_lock);
+
+	list_for_each_entry_safe(cdev, next, &drm_component_list, list) {
+		if ((cdev->crtc_dev == dev) || (cdev->conn_dev == dev)) {
+			if (dev_type == ROCKCHIP_DEVICE_TYPE_CRTC)
+				data = cdev->crtc_data;
+			else if (dev_type == ROCKCHIP_DEVICE_TYPE_CONNECTOR)
+				data = cdev->conn_data;
+			break;
+		}
+	}
+
+	mutex_unlock(&drm_component_lock);
+
+	return data;
+}
+
+int rockchip_drm_component_add(struct device *dev,
+			       enum rockchip_drm_device_type dev_type,
+			       int out_type, void *data)
+{
+	struct component_dev *cdev;
+	int pipe = -1;
+
+	if (dev_type != ROCKCHIP_DEVICE_TYPE_CRTC &&
+	    dev_type != ROCKCHIP_DEVICE_TYPE_CONNECTOR) {
+		DRM_ERROR("invalid device type.\n");
+		return -EINVAL;
+	}
+
+	mutex_lock(&drm_component_lock);
+
+	/*
+	 * Make sure to check if there is a component which has two device
+	 * objects, for connector and for encoder/connector.
+	 * It should make sure that crtc and encoder/connector drivers are
+	 * ready before rockchip drm core binds them.
+	 */
+	list_for_each_entry(cdev, &drm_component_list, list) {
+		pipe++;
+		/*
+		 * out_type from crtc and display port, crtc set possible
+		 * out_type maskbit at out_type, and display posr set out_type
+		 * directly. and if crtc and display port all register, set
+		 * out_type not maskbit;
+		 */
+		if (cdev->out_type & out_type) {
+			if (cdev->crtc_dev && cdev->conn_dev) {
+				DRM_ERROR("already register, not allow");
+				return -EINVAL;
+			}
+
+			if (dev_type == ROCKCHIP_DEVICE_TYPE_CRTC) {
+				cdev->pipe = pipe;
+				cdev->crtc_dev = dev;
+				cdev->crtc_data = data;
+			} else if (dev_type == ROCKCHIP_DEVICE_TYPE_CONNECTOR) {
+				cdev->conn_dev = dev;
+				cdev->conn_data = data;
+				cdev->out_type = out_type;
+			}
+
+			mutex_unlock(&drm_component_lock);
+			return 0;
+		}
+	}
+
+	mutex_unlock(&drm_component_lock);
+
+	cdev = kzalloc(sizeof(*cdev), GFP_KERNEL);
+	if (!cdev)
+		return -ENOMEM;
+
+	if (dev_type == ROCKCHIP_DEVICE_TYPE_CRTC) {
+		cdev->crtc_dev = dev;
+		cdev->crtc_data = data;
+	} else if (dev_type == ROCKCHIP_DEVICE_TYPE_CONNECTOR) {
+		cdev->conn_dev = dev;
+		cdev->conn_data = data;
+	}
+
+	cdev->out_type = out_type;
+
+	mutex_lock(&drm_component_lock);
+	list_add_tail(&cdev->list, &drm_component_list);
+	mutex_unlock(&drm_component_lock);
+
+	return 0;
+}
+
+void rockchip_drm_component_del(struct device *dev,
+				enum rockchip_drm_device_type dev_type)
+{
+	struct component_dev *cdev, *next;
+
+	mutex_lock(&drm_component_lock);
+
+	list_for_each_entry_safe(cdev, next, &drm_component_list, list) {
+		if (dev_type == ROCKCHIP_DEVICE_TYPE_CRTC) {
+			if (cdev->crtc_dev == dev)
+				cdev->crtc_dev = NULL;
+		}
+
+		if (dev_type == ROCKCHIP_DEVICE_TYPE_CONNECTOR) {
+			if (cdev->conn_dev == dev)
+				cdev->conn_dev = NULL;
+		}
+
+		/*
+		 * Release cdev object only in case that both of crtc and
+		 * encoder/connector device objects are NULL.
+		 */
+		if (!cdev->crtc_dev && !cdev->conn_dev) {
+			list_del(&cdev->list);
+			kfree(cdev);
+		}
+
+		break;
+	}
+
+	mutex_unlock(&drm_component_lock);
+}
+
+static int compare_of(struct device *dev, void *data)
+{
+	return dev == (struct device *)data;
+}
+
+static int rockchip_drm_add_components(struct device *dev, struct master *m)
+{
+	struct component_dev *cdev;
+	unsigned int attach_cnt = 0;
+
+	mutex_lock(&drm_component_lock);
+
+	list_for_each_entry(cdev, &drm_component_list, list) {
+		int ret;
+
+		/*
+		 * Add components to master only in case that crtc and
+		 * encoder/connector device objects exist.
+		 */
+		if (!cdev->crtc_dev || !cdev->conn_dev)
+			continue;
+
+		attach_cnt++;
+
+		mutex_unlock(&drm_component_lock);
+
+		/*
+		 * Do not chage below call order.
+		 * crtc device first should be added to master because
+		 * connector/encoder need pipe number of crtc when they
+		 * are created.
+		 */
+		ret = component_master_add_child(m, compare_of, cdev->crtc_dev);
+		ret |= component_master_add_child(m, compare_of,
+						  cdev->conn_dev);
+		if (ret < 0)
+			return ret;
+
+		mutex_lock(&drm_component_lock);
+	}
+
+	mutex_unlock(&drm_component_lock);
+
+	return attach_cnt ? 0 : -ENODEV;
+}
+
+static int rockchip_drm_bind(struct device *dev)
+{
+	return drm_platform_init(&rockchip_drm_driver, to_platform_device(dev));
+}
+
+static void rockchip_drm_unbind(struct device *dev)
+{
+	drm_put_dev(dev_get_drvdata(dev));
+}
+
+static const struct component_master_ops rockchip_drm_ops = {
+	.add_components = rockchip_drm_add_components,
+	.bind = rockchip_drm_bind,
+	.unbind = rockchip_drm_unbind,
+};
+
+static int rockchip_drm_platform_probe(struct platform_device *pdev)
+{
+	int ret;
+
+	pdev->dev.coherent_dma_mask = DMA_BIT_MASK(32);
+	rockchip_drm_driver.num_ioctls = ARRAY_SIZE(rockchip_ioctls);
+
+	ret = component_master_add(&pdev->dev, &rockchip_drm_ops);
+	if (ret < 0)
+		DRM_DEBUG_KMS("re-tried by last sub driver probed later.\n");
+
+	return 0;
+}
+
+static int rockchip_drm_platform_remove(struct platform_device *pdev)
+{
+	component_master_del(&pdev->dev, &rockchip_drm_ops);
+
+	return 0;
+}
+
+static struct platform_driver rockchip_drm_platform_driver = {
+	.probe = rockchip_drm_platform_probe,
+	.remove = rockchip_drm_platform_remove,
+	.driver = {
+		.owner = THIS_MODULE,
+		.name = "rockchip-drm",
+		.pm = &rockchip_drm_pm_ops,
+	},
+};
+
+static int rockchip_drm_init(void)
+{
+	int ret;
+
+	ret = platform_driver_register(&rockchip_panel_platform_driver);
+	if (ret < 0)
+		return -ENOMEM;
+
+#ifdef CONFIG_DRM_ROCKCHIP_LCDC
+	ret = platform_driver_register(&rockchip_lcdc_platform_driver);
+	if (ret < 0)
+		goto out_lcdc;
+#endif
+
+	rockchip_drm_pdev = platform_device_register_simple("rockchip-drm", -1,
+							    NULL, 0);
+	if (IS_ERR(rockchip_drm_pdev)) {
+		ret = PTR_ERR(rockchip_drm_pdev);
+		goto out_drm_pdev;
+	}
+
+	ret = platform_driver_register(&rockchip_drm_platform_driver);
+	if (ret)
+		goto out_drm_driver;
+
+	return 0;
+
+out_drm_driver:
+	platform_device_unregister(rockchip_drm_pdev);
+out_drm_pdev:
+#ifdef CONFIG_DRM_ROCKCHIP_LCDC
+	platform_driver_unregister(&rockchip_lcdc_platform_driver);
+out_lcdc:
+#endif
+	platform_driver_unregister(&rockchip_panel_platform_driver);
+	return ret;
+}
+
+static void rockchip_drm_exit(void)
+{
+	platform_device_unregister(rockchip_drm_pdev);
+	platform_driver_unregister(&rockchip_drm_platform_driver);
+#ifdef CONFIG_DRM_ROCKCHIP_LCDC
+	platform_driver_unregister(&rockchip_lcdc_platform_driver);
+#endif
+	platform_driver_unregister(&rockchip_panel_platform_driver);
+}
+
+module_init(rockchip_drm_init);
+module_exit(rockchip_drm_exit);
+
+MODULE_AUTHOR("mark yao <mark.yao@rock-chips.com>");
+MODULE_DESCRIPTION("ROCKCHIP DRM Driver");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_drv.h b/drivers/gpu/drm/rockchip/rockchip_drm_drv.h
new file mode 100644
index 0000000..c0c1d89
--- /dev/null
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_drv.h
@@ -0,0 +1,128 @@
+/*
+ * Copyright (C) Fuzhou Rockchip Electronics Co.Ltd
+ * Author:mark yao <mark.yao@rock-chips.com>
+ *
+ * based on exynos_drm_drv.h
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef _ROCKCHIP_DRM_DRV_H_
+#define _ROCKCHIP_DRM_DRV_H_
+
+#include <linux/module.h>
+
+#define MAX_CRTC	3
+#define MAX_PLANE	5
+#define MAX_FB_BUFFER	4
+#define DEFAULT_ZPOS	-1
+
+struct drm_device;
+struct drm_connector;
+
+/*
+ * display output interface supported by rockchip lcdc
+ */
+#define ROCKCHIP_OUTFACE_P888	0
+#define ROCKCHIP_OUTFACE_P666	1
+#define ROCKCHIP_OUTFACE_P565	2
+/* for use special outface */
+#define ROCKCHIP_OUTFACE_AAAA	15
+
+#define ROCKCHIP_COLOR_SWAP_RG	0x1
+#define ROCKCHIP_COLOR_SWAP_RB	0x2
+#define ROCKCHIP_COLOR_SWAP_GB	0x4
+/*
+ * Special panel info for rockchip
+ *
+ * @out_type: lcd controller need to know the sceen type.
+ * @out_face: the output pin interface.
+ * @color_swap: if want to swap color at output, use this.
+ * @pwr18: choice the power supply 1.8 or 3.3 mode for lcdc
+ * @dither: use dither func at lcd output
+ * @flags: the display flags, now just for pin sync level.
+ */
+struct rockchip_panel_special {
+	int out_type;
+	int out_face;
+	u32 color_swap;
+	bool pwr18;
+	bool dither;
+	u32 flags;
+};
+
+/* This enumerates device type. */
+enum rockchip_drm_device_type {
+	ROCKCHIP_DEVICE_TYPE_NONE,
+	ROCKCHIP_DEVICE_TYPE_CRTC,
+	ROCKCHIP_DEVICE_TYPE_CONNECTOR,
+};
+
+/* this enumerates display type. */
+enum rockchip_drm_output_type {
+	ROCKCHIP_DISPLAY_TYPE_NONE = 0,
+	/* RGB Interface. */
+	ROCKCHIP_DISPLAY_TYPE_RGB = (1 << 0),
+	/* LVDS Interface. */
+	ROCKCHIP_DISPLAY_TYPE_LVDS = (1 << 1),
+	/* DUAL LVDS Interface. */
+	ROCKCHIP_DISPLAY_TYPE_DUAL_LVDS = (1 << 2),
+	/* EDP Interface. */
+	ROCKCHIP_DISPLAY_TYPE_EDP = (1 << 3),
+	/* MIPI Interface. */
+	ROCKCHIP_DISPLAY_TYPE_MIPI = (1 << 4),
+	/* HDMI Interface. */
+	ROCKCHIP_DISPLAY_TYPE_HDMI = (1 << 5),
+};
+
+/*
+ * Rockchip drm private structure.
+ *
+ * @pipe: the pipe number for this crtc/manager.
+ */
+struct rockchip_drm_private {
+	struct drm_fbdev_cma *fbdev_cma;
+	/*
+	 * created crtc object would be contained at this array and
+	 * this array is used to be aware of which crtc did it request vblank.
+	 */
+	struct drm_crtc *crtc[MAX_CRTC];
+	struct drm_property *plane_zpos_property;
+	struct drm_property *crtc_mode_property;
+
+	unsigned int pipe;
+};
+
+
+void rockchip_drm_crtc_finish_pageflip(struct drm_device *dev, int pipe);
+void rockchip_drm_crtc_cancel_pending_flip(struct drm_device *dev);
+int rockchip_drm_crtc_enable_vblank(struct drm_device *dev, int pipe);
+void rockchip_drm_crtc_disable_vblank(struct drm_device *dev, int pipe);
+
+struct drm_plane *rockchip_plane_init(struct drm_device *dev,
+				      unsigned long possible_crtcs, bool priv);
+
+void rockchip_drm_encoder_setup(struct drm_device *dev);
+
+void *rockchip_drm_component_data_get(struct device *dev,
+				      enum rockchip_drm_device_type dev_type);
+int rockchip_drm_pipe_get(struct device *dev);
+
+int rockchip_drm_component_add(struct device *dev,
+			       enum rockchip_drm_device_type dev_type,
+			       int out_type, void *data);
+void rockchip_drm_component_del(struct device *dev,
+				enum rockchip_drm_device_type dev_type);
+
+extern struct platform_driver rockchip_panel_platform_driver;
+#ifdef CONFIG_DRM_ROCKCHIP_LCDC
+extern struct platform_driver rockchip_lcdc_platform_driver;
+#endif
+#endif /* _ROCKCHIP_DRM_DRV_H_ */
diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_fb.c b/drivers/gpu/drm/rockchip/rockchip_drm_fb.c
new file mode 100644
index 0000000..a04024b
--- /dev/null
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_fb.c
@@ -0,0 +1,48 @@
+/*
+ * Copyright (C) Fuzhou Rockchip Electronics Co.Ltd
+ * Author:mark yao <mark.yao@rock-chips.com>
+ *
+ * based on exynos_drm_fb.c
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <drm/drmP.h>
+#include <drm/drm_fb_cma_helper.h>
+#include <drm/drm_fb_helper.h>
+
+#include <uapi/drm/rockchip_drm.h>
+
+static struct drm_framebuffer *
+rockchip_user_fb_create(struct drm_device *dev, struct drm_file *file_priv,
+			struct drm_mode_fb_cmd2 *mode_cmd)
+{
+	return drm_fb_cma_create(dev, file_priv, mode_cmd);
+}
+
+static const struct drm_mode_config_funcs rockchip_drm_mode_config_funcs = {
+	.fb_create = rockchip_user_fb_create,
+};
+
+void rockchip_drm_mode_config_init(struct drm_device *dev)
+{
+	dev->mode_config.min_width = 0;
+	dev->mode_config.min_height = 0;
+
+	/*
+	 * set max width and height as default value(4096x4096).
+	 * this value would be used to check framebuffer size limitation
+	 * at drm_mode_addfb().
+	 */
+	dev->mode_config.max_width = 4096;
+	dev->mode_config.max_height = 4096;
+
+	dev->mode_config.funcs = &rockchip_drm_mode_config_funcs;
+}
diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_fb.h b/drivers/gpu/drm/rockchip/rockchip_drm_fb.h
new file mode 100644
index 0000000..6258de6
--- /dev/null
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_fb.h
@@ -0,0 +1,28 @@
+/*
+ *
+ * Copyright (C) Fuzhou Rockchip Electronics Co.Ltd
+ * Author:mark yao <mark.yao@rock-chips.com>
+ *
+ * based on exynos_drm_fb.h
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef _ROCKCHIP_DRM_FB_H_
+#define _ROCKCHIP_DRM_FB_H_
+
+struct drm_framebuffer *
+rockchip_drm_framebuffer_init(struct drm_device *dev,
+			      struct drm_mode_fb_cmd2 *mode_cmd,
+			      struct drm_gem_object *obj);
+
+void rockchip_drm_mode_config_init(struct drm_device *dev);
+
+#endif /* _ROCKCHIP_DRM_FB_H_ */
diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_fbdev.c b/drivers/gpu/drm/rockchip/rockchip_drm_fbdev.c
new file mode 100644
index 0000000..d32fa57
--- /dev/null
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_fbdev.c
@@ -0,0 +1,63 @@
+/*
+ * Copyright (C) Fuzhou Rockchip Electronics Co.Ltd
+ * Author:mark yao <mark.yao@rock-chips.com>
+ *
+ * based on exynos_drm_fbdev.c
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <drm/drmP.h>
+#include <drm/drm_fb_cma_helper.h>
+
+#include <drm/rockchip_drm.h>
+
+#include "rockchip_drm_drv.h"
+
+#define MAX_CONNECTOR		4
+#define PREFERRED_BPP		32
+
+int rockchip_drm_fbdev_init(struct drm_device *dev)
+{
+	struct rockchip_drm_private *private = dev->dev_private;
+	struct drm_fbdev_cma *fbdev_cma;
+	unsigned int num_crtc;
+
+	if (!dev->mode_config.num_crtc || !dev->mode_config.num_connector)
+		return 0;
+
+	if (private->fbdev_cma) {
+		DRM_ERROR("no allow to reinit cma fbdev\n");
+		return -EINVAL;
+	}
+
+	num_crtc = dev->mode_config.num_crtc;
+
+	fbdev_cma = drm_fbdev_cma_init(dev, PREFERRED_BPP, num_crtc,
+				       MAX_CONNECTOR);
+	if (!fbdev_cma) {
+		DRM_ERROR("failed to init cma fbdev\n");
+		return -ENOMEM;
+	}
+
+	private->fbdev_cma = fbdev_cma;
+
+	return 0;
+}
+
+void rockchip_drm_fbdev_fini(struct drm_device *dev)
+{
+	struct rockchip_drm_private *private = dev->dev_private;
+
+	if (!private || !private->fbdev_cma)
+		return;
+
+	drm_fbdev_cma_fini(private->fbdev_cma);
+}
diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_fbdev.h b/drivers/gpu/drm/rockchip/rockchip_drm_fbdev.h
new file mode 100644
index 0000000..91cb535
--- /dev/null
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_fbdev.h
@@ -0,0 +1,24 @@
+/*
+ *
+ * Copyright (C) Fuzhou Rockchip Electronics Co.Ltd
+ * Author:mark yao <mark.yao@rock-chips.com>
+ *
+ * based on exynos_drm_fbdev.h
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef _ROCKCHIP_DRM_FBDEV_H_
+#define _ROCKCHIP_DRM_FBDEV_H_
+
+int rockchip_drm_fbdev_init(struct drm_device *dev);
+void rockchip_drm_fbdev_fini(struct drm_device *dev);
+
+#endif /* _ROCKCHIP_DRM_FBDEV_H_ */
diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_gem.c b/drivers/gpu/drm/rockchip/rockchip_drm_gem.c
new file mode 100644
index 0000000..f0219cd
--- /dev/null
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_gem.c
@@ -0,0 +1,163 @@
+/*
+ *
+ * Copyright (C) Fuzhou Rockchip Electronics Co.Ltd
+ * Author:mark yao <mark.yao@rock-chips.com>
+ *
+ * based on exynos_drm_gem.c
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <drm/drmP.h>
+#include <drm/drm_vma_manager.h>
+#include <drm/drm_gem_cma_helper.h>
+
+#include <drm/rockchip_drm.h>
+
+#include "rockchip_drm_drv.h"
+#include "rockchip_drm_gem.h"
+
+int rockchip_drm_gem_create_ioctl(struct drm_device *dev, void *data,
+				  struct drm_file *file_priv)
+{
+	struct drm_rockchip_gem_create *args = data;
+	struct drm_gem_cma_object *cma_obj;
+	struct drm_gem_object *gem_obj;
+	int ret;
+
+	cma_obj = drm_gem_cma_create(dev, args->size);
+	if (IS_ERR(cma_obj))
+		return PTR_ERR_OR_ZERO(cma_obj);
+
+	gem_obj = &cma_obj->base;
+
+	/*
+	 * allocate a id of idr table where the obj is registered
+	 * and handle has the id what user can see.
+	 */
+	ret = drm_gem_handle_create(file_priv, gem_obj, &args->handle);
+	if (ret)
+		goto err_handle_create;
+
+	/* drop reference from allocate - handle holds it now. */
+	drm_gem_object_unreference_unlocked(gem_obj);
+
+	return PTR_ERR_OR_ZERO(cma_obj);
+
+err_handle_create:
+	drm_gem_cma_free_object(gem_obj);
+	return ret;
+}
+
+int rockchip_drm_gem_map_offset_ioctl(struct drm_device *dev, void *data,
+				      struct drm_file *file_priv)
+{
+	struct drm_rockchip_gem_map_off *args = data;
+
+	DRM_DEBUG_KMS("handle = 0x%x, offset = 0x%lx\n",
+		      args->handle, (unsigned long)args->offset);
+
+	return drm_gem_cma_dumb_map_offset(file_priv, dev, args->handle,
+					   &args->offset);
+}
+
+int rockchip_drm_gem_mmap_ioctl(struct drm_device *dev, void *data,
+				struct drm_file *file_priv)
+{
+	struct drm_rockchip_gem_mmap *args = data;
+	struct drm_gem_object *obj;
+	unsigned long addr;
+
+	mutex_lock(&dev->struct_mutex);
+
+	obj = drm_gem_object_lookup(dev, file_priv, args->handle);
+	if (!obj) {
+		DRM_ERROR("failed to lookup gem object.\n");
+		mutex_unlock(&dev->struct_mutex);
+		return -EINVAL;
+	}
+
+	addr = vm_mmap(obj->filp, 0, args->size, PROT_READ | PROT_WRITE,
+		       MAP_SHARED, 0);
+
+	drm_gem_object_unreference(obj);
+
+	if (IS_ERR_VALUE(addr)) {
+		mutex_unlock(&dev->struct_mutex);
+		return (int)addr;
+	}
+
+	mutex_unlock(&dev->struct_mutex);
+
+	args->mapped = addr;
+
+	DRM_DEBUG_KMS("mapped = 0x%lx\n", (unsigned long)args->mapped);
+
+	return 0;
+}
+
+int rockchip_drm_gem_get_ioctl(struct drm_device *dev, void *data,
+			       struct drm_file *file_priv)
+{
+	struct drm_rockchip_gem_info *args = data;
+	struct drm_gem_object *obj;
+
+	mutex_lock(&dev->struct_mutex);
+
+	obj = drm_gem_object_lookup(dev, file_priv, args->handle);
+	if (!obj) {
+		DRM_ERROR("failed to lookup gem object.\n");
+		mutex_unlock(&dev->struct_mutex);
+		return -EINVAL;
+	}
+
+	args->size = obj->size;
+
+	drm_gem_object_unreference(obj);
+	mutex_unlock(&dev->struct_mutex);
+
+	return 0;
+}
+
+int rockchip_drm_gem_dumb_map_offset(struct drm_file *file_priv,
+				     struct drm_device *dev, uint32_t handle,
+				     uint64_t *offset)
+{
+	struct drm_gem_object *obj;
+	int ret = 0;
+
+	mutex_lock(&dev->struct_mutex);
+
+	/*
+	 * get offset of memory allocated for drm framebuffer.
+	 * - this callback would be called by user application
+	 * with DRM_IOCTL_MODE_MAP_DUMB command.
+	 */
+
+	obj = drm_gem_object_lookup(dev, file_priv, handle);
+	if (!obj) {
+		DRM_ERROR("failed to lookup gem object.\n");
+		ret = -EINVAL;
+		goto unlock;
+	}
+
+	ret = drm_gem_create_mmap_offset(obj);
+	if (ret)
+		goto out;
+
+	*offset = drm_vma_node_offset_addr(&obj->vma_node);
+	DRM_DEBUG_KMS("offset = 0x%lx\n", (unsigned long)*offset);
+
+out:
+	drm_gem_object_unreference(obj);
+unlock:
+	mutex_unlock(&dev->struct_mutex);
+	return ret;
+}
diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_gem.h b/drivers/gpu/drm/rockchip/rockchip_drm_gem.h
new file mode 100644
index 0000000..fe8285f
--- /dev/null
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_gem.h
@@ -0,0 +1,40 @@
+/*
+ * Copyright (C) Fuzhou Rockchip Electronics Co.Ltd
+ * Author:mark yao <mark.yao@rock-chips.com>
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef _ROCKCHIP_DRM_GEM_H_
+#define _ROCKCHIP_DRM_GEM_H_
+
+/*
+ * request gem object creation and buffer allocation as the size
+ * that it is calculated with framebuffer information such as width,
+ * height and bpp.
+ */
+int rockchip_drm_gem_create_ioctl(struct drm_device *dev, void *data,
+				  struct drm_file *file_priv);
+
+/* get buffer offset to map to user space. */
+int rockchip_drm_gem_map_offset_ioctl(struct drm_device *dev, void *data,
+				      struct drm_file *file_priv);
+
+/*
+ * mmap the physically continuous memory that a gem object contains
+ * to user space.
+ */
+int rockchip_drm_gem_mmap_ioctl(struct drm_device *dev, void *data,
+				struct drm_file *file_priv);
+
+/* get buffer information to memory region allocated by gem. */
+int rockchip_drm_gem_get_ioctl(struct drm_device *dev, void *data,
+			       struct drm_file *file_priv);
+#endif
diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_lcdc.c b/drivers/gpu/drm/rockchip/rockchip_drm_lcdc.c
new file mode 100644
index 0000000..68991d4
--- /dev/null
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_lcdc.c
@@ -0,0 +1,720 @@
+/*
+ * Copyright (C) Fuzhou Rockchip Electronics Co.Ltd
+ * Author:mark yao <mark.yao@rock-chips.com>
+ *
+ * based on exynos_drm_fimd.c
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+#include <drm/drmP.h>
+#include <drm/drm_crtc.h>
+#include <drm/drm_crtc_helper.h>
+#include <drm/drm_fb_cma_helper.h>
+#include <drm/drm_gem_cma_helper.h>
+
+#include <linux/kernel.h>
+#include <linux/platform_device.h>
+#include <linux/clk.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
+#include <linux/pm_runtime.h>
+#include <linux/component.h>
+
+#include <drm/rockchip_drm.h>
+
+#include <video/of_display_timing.h>
+#include <video/of_videomode.h>
+
+#include "rockchip_drm_drv.h"
+#include "rockchip_drm_fbdev.h"
+#include "rockchip_drm_lcdc.h"
+
+#define LCDC_DEFAULT_FRAMERATE 60
+
+#define ROCKCHIP_DISPLAY_TYPE_LCD (ROCKCHIP_DISPLAY_TYPE_RGB | \
+					ROCKCHIP_DISPLAY_TYPE_LVDS | \
+					ROCKCHIP_DISPLAY_TYPE_EDP)
+
+static const uint32_t formats[] = {
+	DRM_FORMAT_XRGB8888,
+	DRM_FORMAT_ARGB8888,
+};
+
+struct rockchip_plane {
+	int zpos;
+	struct drm_plane base;
+};
+
+struct lcdc_context {
+	struct device *dev;
+	struct drm_device *drm_dev;
+	struct drm_crtc crtc;
+	struct drm_pending_vblank_event *event;
+	struct drm_display_mode mode;
+	struct drm_plane *plane;
+	struct lcdc_driver *drv;
+	unsigned int default_win;
+	unsigned int dpms;
+	int pipe;
+	wait_queue_head_t wait_vsync_queue;
+	atomic_t wait_vsync_event;
+};
+
+#define to_lcdc_data(x) ((x)->drv->data)
+#define to_lcdc_ctx(x) container_of(x, struct lcdc_context, crtc)
+#define to_rockchip_plane(x) container_of(x, struct rockchip_plane, base)
+
+const struct of_device_id lcdc_driver_dt_match[] = {
+#ifdef CONFIG_LCDC_RK3288
+	{ .compatible = "rockchip,rk3288-lcdc",
+	  .data = (void *)&rockchip_rk3288_lcdc },
+#endif
+	{},
+};
+
+static inline struct lcdc_driver_data *drm_lcdc_get_driver_data(
+	struct platform_device *pdev)
+{
+	const struct of_device_id *of_id =
+			of_match_device(lcdc_driver_dt_match, &pdev->dev);
+
+	return (struct lcdc_driver_data *)of_id->data;
+}
+
+static int rockchip_plane_get_size(int start, unsigned length, unsigned last)
+{
+	int end = start + length;
+	int size = 0;
+
+	if (start <= 0) {
+		if (end > 0)
+			size = min_t(unsigned, end, last);
+	} else if (start <= last) {
+		size = min_t(unsigned, last - start, length);
+	}
+
+	return size;
+}
+
+static int rockchip_update_plane(struct drm_plane *plane, struct drm_crtc *crtc,
+				 struct drm_framebuffer *fb, int crtc_x,
+				 int crtc_y, unsigned int crtc_w,
+				 unsigned int crtc_h, uint32_t src_x,
+				 uint32_t src_y, uint32_t src_w, uint32_t src_h)
+{
+	struct rockchip_plane *rockchip_plane = to_rockchip_plane(plane);
+	struct lcdc_context *ctx = to_lcdc_ctx(crtc);
+	struct lcdc_driver_data *lcdc_data = to_lcdc_data(ctx);
+	struct drm_gem_cma_object *gem;
+	struct lcdc_win_data *win_data;
+	unsigned long offset;
+	unsigned int actual_w;
+	unsigned int actual_h;
+	int win;
+
+	DRM_DEBUG_KMS("LINE[%d]\n", __LINE__);
+	gem = drm_fb_cma_get_gem_obj(fb, 0);
+	if (!gem) {
+		DRM_ERROR("fail to get cma object from framebuffer\n");
+		return -EINVAL;
+	}
+
+	actual_w = rockchip_plane_get_size(crtc_x,
+					   crtc_w, crtc->mode.hdisplay);
+	actual_h = rockchip_plane_get_size(crtc_y,
+					   crtc_h, crtc->mode.vdisplay);
+	if (crtc_x < 0) {
+		if (actual_w)
+			src_x -= crtc_x;
+		crtc_x = 0;
+	}
+
+	if (crtc_y < 0) {
+		if (actual_h)
+			src_y -= crtc_y;
+		crtc_y = 0;
+	}
+
+	win = rockchip_plane->zpos;
+	if (win == DEFAULT_ZPOS)
+		win = ctx->default_win;
+
+	if (win < 0 || win >= ZPOS_MAX_NUM)
+		return -EINVAL;
+
+	offset = (src_x >> 16) * (fb->bits_per_pixel >> 3);
+	offset += (src_y >> 16) * fb->pitches[0];
+
+	DRM_DEBUG_KMS("offset = 0x%lx, pitch = %x\n", offset, fb->pitches[0]);
+
+	win_data = lcdc_data->get_win(ctx->drv, win);
+
+	win_data->xpos = crtc_x;
+	win_data->ypos = crtc_y;
+	win_data->xsize = actual_w;
+	win_data->ysize = actual_h;
+	win_data->xact = fb->width;
+	win_data->yact = fb->height;
+	win_data->y_vir_stride = fb->pitches[0] / (fb->bits_per_pixel >> 3);
+	win_data->yrgb_addr = gem->paddr + offset;
+	win_data->uv_addr = 0;
+	win_data->alpha_en = false;
+
+	switch (fb->pixel_format) {
+	case DRM_FORMAT_ARGB8888:
+		win_data->alpha_en = true;
+	case DRM_FORMAT_XRGB8888:
+		win_data->format = ARGB888;
+		break;
+	case DRM_FORMAT_RGB565:
+		win_data->format = RGB565;
+		win_data->y_vir_stride =
+			((win_data->y_vir_stride * 3) >> 2)
+			+ win_data->y_vir_stride % 3;
+		break;
+	default:
+		DRM_DEBUG_KMS("invalid pixel size so using unpacked 24bpp.\n");
+		win_data->alpha_en = false;
+		win_data->format = ARGB888;
+		break;
+	}
+	win_data->enabled = true;
+	DRM_DEBUG_KMS("offset_x = %d, offset_y = %d\n",
+		      win_data->xpos, win_data->ypos);
+	DRM_DEBUG_KMS("ovl_width = %d, ovl_height = %d\n",
+		      win_data->xsize, win_data->ysize);
+	DRM_DEBUG_KMS("paddr = 0x%lx\n", (unsigned long)win_data->yrgb_addr);
+	DRM_DEBUG_KMS("fb_width = %d, actual_w = %d\n",
+		      fb->width, actual_w);
+
+	lcdc_data->win_commit(ctx->drv, win_data);
+	return 0;
+}
+
+static int rockchip_disable_plane(struct drm_plane *plane)
+{
+	struct rockchip_plane *rockchip_plane = to_rockchip_plane(plane);
+	struct lcdc_context *ctx = to_lcdc_ctx(plane->crtc);
+	struct lcdc_driver_data *lcdc_data = to_lcdc_data(ctx);
+	struct lcdc_win_data *win_data;
+	int win = rockchip_plane->zpos;
+
+	if (win == DEFAULT_ZPOS)
+		win = ctx->default_win;
+
+	if (win < 0 || win >= ZPOS_MAX_NUM)
+		return -EINVAL;
+
+	win_data = lcdc_data->get_win(ctx->drv, win);
+
+	win_data->enabled = false;
+	lcdc_data->win_commit(ctx->drv, win_data);
+
+	return 0;
+}
+
+static void rockchip_plane_destroy(struct drm_plane *plane)
+{
+	struct rockchip_plane *rockchip_plane = to_rockchip_plane(plane);
+
+	DRM_DEBUG_KMS("LINE[%d]\n", __LINE__);
+	rockchip_disable_plane(plane);
+	drm_plane_cleanup(plane);
+	kfree(rockchip_plane);
+}
+
+static int rockchip_plane_set_property(struct drm_plane *plane,
+				       struct drm_property *property,
+				       uint64_t val)
+{
+	struct drm_device *dev = plane->dev;
+	struct rockchip_plane *rockchip_plane = to_rockchip_plane(plane);
+	struct rockchip_drm_private *dev_priv = dev->dev_private;
+
+	DRM_DEBUG_KMS("LINE[%d]\n", __LINE__);
+	if (property == dev_priv->plane_zpos_property) {
+		rockchip_plane->zpos = val;
+		return 0;
+	}
+
+	return -EINVAL;
+}
+
+static struct drm_plane_funcs rockchip_plane_funcs = {
+	.update_plane = rockchip_update_plane,
+	.disable_plane = rockchip_disable_plane,
+	.destroy = rockchip_plane_destroy,
+	.set_property = rockchip_plane_set_property,
+};
+
+static void rockchip_plane_attach_zpos_property(struct drm_plane *plane)
+{
+	struct drm_device *dev = plane->dev;
+	struct rockchip_drm_private *dev_priv = dev->dev_private;
+	struct drm_property *prop;
+
+	DRM_DEBUG_KMS("LINE[%d]\n", __LINE__);
+	prop = dev_priv->plane_zpos_property;
+	if (!prop) {
+		prop = drm_property_create_range(dev, 0, "zpos", 0,
+						 MAX_PLANE - 1);
+		if (!prop)
+			return;
+
+		dev_priv->plane_zpos_property = prop;
+	}
+
+	drm_object_attach_property(&plane->base, prop, 0);
+}
+
+struct drm_plane *rockchip_plane_init(struct drm_device *dev,
+				      unsigned long possible_crtcs, bool priv)
+{
+	struct rockchip_plane *rockchip_plane;
+	struct rockchip_drm_private *private = dev->dev_private;
+	int err;
+
+	DRM_DEBUG_KMS("LINE[%d]\n", __LINE__);
+	rockchip_plane = kzalloc(sizeof(*rockchip_plane), GFP_KERNEL);
+	if (!rockchip_plane)
+		return NULL;
+
+	err = drm_plane_init(dev, &rockchip_plane->base, possible_crtcs,
+			     &rockchip_plane_funcs, formats,
+			     ARRAY_SIZE(formats), priv);
+	if (err) {
+		DRM_ERROR("failed to initialize plane\n");
+		kfree(rockchip_plane);
+		return NULL;
+	}
+
+	if (priv) {
+		rockchip_plane->base.crtc = private->crtc[0];
+		rockchip_plane->zpos = DEFAULT_ZPOS;
+	} else {
+		rockchip_plane_attach_zpos_property(&rockchip_plane->base);
+	}
+
+	return &rockchip_plane->base;
+}
+
+int rockchip_drm_crtc_enable_vblank(struct drm_device *dev, int pipe)
+{
+	struct rockchip_drm_private *private = dev->dev_private;
+	struct lcdc_context *ctx = to_lcdc_ctx(private->crtc[pipe]);
+	struct lcdc_driver_data *lcdc_data = to_lcdc_data(ctx);
+
+	DRM_DEBUG_KMS("LINE[%d]\n", __LINE__);
+	if (ctx->dpms != DRM_MODE_DPMS_ON)
+		return -EPERM;
+
+	lcdc_data->enable_vblank(ctx->drv);
+
+	return 0;
+}
+
+void rockchip_drm_crtc_disable_vblank(struct drm_device *dev, int pipe)
+{
+	struct rockchip_drm_private *private = dev->dev_private;
+	struct lcdc_context *ctx = to_lcdc_ctx(private->crtc[pipe]);
+	struct lcdc_driver_data *lcdc_data = to_lcdc_data(ctx);
+
+	DRM_DEBUG_KMS("LINE[%d]\n", __LINE__);
+	if (ctx->dpms != DRM_MODE_DPMS_ON)
+		return;
+
+	lcdc_data->disable_vblank(ctx->drv);
+}
+
+static void rockchip_drm_crtc_dpms(struct drm_crtc *crtc, int mode)
+{
+	struct lcdc_context *ctx = to_lcdc_ctx(crtc);
+	struct lcdc_driver_data *lcdc_data = to_lcdc_data(ctx);
+
+	DRM_DEBUG_KMS("crtc[%d] mode[%d]\n", crtc->base.id, mode);
+
+	if (ctx->dpms == mode) {
+		DRM_DEBUG_KMS("desired dpms mode is same as previous one.\n");
+		return;
+	}
+
+	if (mode > DRM_MODE_DPMS_ON) {
+		/* wait for the completion of page flip. */
+		if (!wait_event_timeout(ctx->wait_vsync_queue,
+					!atomic_read(&ctx->wait_vsync_event),
+					HZ/20))
+			DRM_DEBUG_KMS("vblank wait timed out.\n");
+		drm_vblank_off(crtc->dev, ctx->pipe);
+	}
+
+	switch (mode) {
+	case DRM_MODE_DPMS_ON:
+		lcdc_data->dpms(ctx->drv, DRM_MODE_DPMS_ON);
+		break;
+	case DRM_MODE_DPMS_STANDBY:
+	case DRM_MODE_DPMS_SUSPEND:
+	case DRM_MODE_DPMS_OFF:
+		lcdc_data->dpms(ctx->drv, DRM_MODE_DPMS_OFF);
+		break;
+	default:
+		DRM_DEBUG_KMS("unspecified mode %d\n", mode);
+		break;
+	}
+
+	ctx->dpms = mode;
+}
+
+static void rockchip_drm_crtc_prepare(struct drm_crtc *crtc)
+{
+	/* drm framework doesn't check NULL. */
+}
+
+static bool rockchip_drm_crtc_mode_fixup(struct drm_crtc *crtc,
+					 const struct drm_display_mode *mode,
+					 struct drm_display_mode *adjusted_mode)
+{
+	/* just do dummy now */
+
+	return true;
+}
+
+static int rockchip_drm_crtc_mode_set(struct drm_crtc *crtc,
+				      struct drm_display_mode *mode,
+				      struct drm_display_mode *adjusted_mode,
+				      int x, int y,
+				      struct drm_framebuffer *fb)
+{
+	struct lcdc_context *ctx = to_lcdc_ctx(crtc);
+	struct lcdc_driver_data *lcdc_data = to_lcdc_data(ctx);
+
+	DRM_DEBUG_KMS("LINE[%d]\n", __LINE__);
+	/* nothing to do if we haven't set the mode yet */
+	if (adjusted_mode->htotal == 0 || adjusted_mode->vtotal == 0)
+		return -EINVAL;
+
+	drm_mode_copy(&ctx->mode, adjusted_mode);
+	lcdc_data->mode_set(ctx->drv, &ctx->mode);
+
+	return 0;
+}
+static int rockchip_drm_crtc_mode_set_base(struct drm_crtc *crtc, int x, int y,
+					   struct drm_framebuffer *old_fb)
+{
+	struct lcdc_context *ctx = to_lcdc_ctx(crtc);
+	unsigned int crtc_w;
+	unsigned int crtc_h;
+	int ret;
+
+	crtc_w = crtc->primary->fb->width - crtc->x;
+	crtc_h = crtc->primary->fb->height - crtc->y;
+
+	ret = rockchip_update_plane(ctx->plane, crtc, crtc->primary->fb, 0, 0,
+				    crtc_w, crtc_h, crtc->x, crtc->y, crtc_w,
+				    crtc_h);
+	if (ret < 0) {
+		DRM_ERROR("fail to update plane\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static void rockchip_drm_crtc_commit(struct drm_crtc *crtc)
+{
+	rockchip_drm_crtc_mode_set_base(crtc, crtc->x, crtc->y,
+					crtc->primary->fb);
+}
+
+static struct drm_crtc_helper_funcs rockchip_crtc_helper_funcs = {
+	.dpms = rockchip_drm_crtc_dpms,
+	.prepare = rockchip_drm_crtc_prepare,
+	.mode_fixup = rockchip_drm_crtc_mode_fixup,
+	.mode_set = rockchip_drm_crtc_mode_set,
+	.mode_set_base = rockchip_drm_crtc_mode_set_base,
+	.commit = rockchip_drm_crtc_commit,
+};
+
+static int rockchip_drm_crtc_page_flip(struct drm_crtc *crtc,
+				       struct drm_framebuffer *fb,
+				       struct drm_pending_vblank_event *event,
+				       uint32_t page_flip_flags)
+{
+	struct drm_device *dev = crtc->dev;
+	struct lcdc_context *ctx = to_lcdc_ctx(crtc);
+	struct drm_framebuffer *old_fb = crtc->primary->fb;
+	unsigned int crtc_w;
+	unsigned int crtc_h;
+	int ret = -EINVAL;
+
+	DRM_DEBUG_KMS("LINE[%d]\n", __LINE__);
+	/* when the page flip is requested, crtc's dpms should be on */
+	if (ctx->dpms > DRM_MODE_DPMS_ON) {
+		DRM_ERROR("failed page flip request.\n");
+		return -EINVAL;
+	}
+
+	mutex_lock(&dev->struct_mutex);
+
+	/*
+	 * the pipe from user always is 0 so we can set pipe number
+	 * of current owner to event.
+	 */
+	ret = drm_vblank_get(dev, ctx->pipe);
+	if (ret) {
+		DRM_DEBUG("failed to acquire vblank counter\n");
+		goto out;
+	}
+
+	spin_lock_irq(&dev->event_lock);
+	if (ctx->event) {
+		spin_unlock_irq(&dev->event_lock);
+		DRM_ERROR("already pending flip!\n");
+		ret = -EBUSY;
+		goto out;
+	}
+	ctx->event = event;
+	atomic_set(&ctx->wait_vsync_event, 1);
+	spin_unlock_irq(&dev->event_lock);
+
+	crtc->primary->fb = fb;
+	crtc_w = crtc->primary->fb->width - crtc->x;
+	crtc_h = crtc->primary->fb->height - crtc->y;
+
+	ret = rockchip_update_plane(ctx->plane, crtc, fb, 0, 0, crtc_w, crtc_h,
+				    crtc->x, crtc->y, crtc_w, crtc_h);
+	if (ret) {
+		crtc->primary->fb = old_fb;
+
+		spin_lock_irq(&dev->event_lock);
+		drm_vblank_put(dev, ctx->pipe);
+		atomic_set(&ctx->wait_vsync_event, 0);
+		ctx->event = NULL;
+		spin_unlock_irq(&dev->event_lock);
+
+		goto out;
+	}
+out:
+	mutex_unlock(&dev->struct_mutex);
+	return ret;
+}
+
+void rockchip_drm_crtc_finish_pageflip(struct drm_device *dev, int pipe)
+{
+	struct rockchip_drm_private *dev_priv = dev->dev_private;
+	struct drm_crtc *drm_crtc = dev_priv->crtc[pipe];
+	struct lcdc_context *ctx;
+	struct drm_pending_vblank_event *event;
+	unsigned long flags;
+
+	DRM_DEBUG_KMS("LINE[%d]\n", __LINE__);
+	if (!drm_crtc)
+		return;
+
+	ctx = to_lcdc_ctx(drm_crtc);
+	event = ctx->event;
+
+	spin_lock_irqsave(&dev->event_lock, flags);
+
+	if (event) {
+		ctx->event = NULL;
+		drm_send_vblank_event(dev, -1, event);
+		drm_vblank_put(dev, pipe);
+		atomic_set(&ctx->wait_vsync_event, 0);
+		wake_up(&ctx->wait_vsync_queue);
+	}
+
+	spin_unlock_irqrestore(&dev->event_lock, flags);
+}
+
+void rockchip_drm_crtc_cancel_pending_flip(struct drm_device *dev)
+{
+	int i;
+
+	DRM_DEBUG_KMS("cancle pending flip\n");
+	for (i = 0; i < dev->num_crtcs; i++)
+		rockchip_drm_crtc_finish_pageflip(dev, i);
+}
+
+static void rockchip_drm_crtc_destroy(struct drm_crtc *crtc)
+{
+	struct lcdc_context *ctx = to_lcdc_ctx(crtc);
+	struct rockchip_drm_private *private = crtc->dev->dev_private;
+
+	DRM_DEBUG_KMS("LINE[%d]\n", __LINE__);
+	private->crtc[ctx->pipe] = NULL;
+
+	drm_crtc_cleanup(crtc);
+}
+
+static struct drm_crtc_funcs rockchip_crtc_funcs = {
+	.set_config = drm_crtc_helper_set_config,
+	.page_flip = rockchip_drm_crtc_page_flip,
+	.destroy = rockchip_drm_crtc_destroy,
+};
+
+void lcdc_vsync_event_handler(struct device *dev)
+{
+	struct drm_pending_vblank_event *event;
+	struct lcdc_context *ctx = dev_get_drvdata(dev);
+	struct drm_device *drm_dev;
+	unsigned long flags;
+
+	DRM_DEBUG_KMS("LINE[%d]\n", __LINE__);
+	/* check the crtc is detached already from encoder */
+	if (ctx && (ctx->pipe < 0 || !ctx->drm_dev))
+		return;
+
+	drm_handle_vblank(ctx->drm_dev, ctx->pipe);
+
+	event = ctx->event;
+	drm_dev = ctx->drm_dev;
+
+	spin_lock_irqsave(&drm_dev->event_lock, flags);
+
+	if (event) {
+		ctx->event = NULL;
+		drm_send_vblank_event(drm_dev, -1, event);
+		drm_vblank_put(drm_dev, ctx->pipe);
+		atomic_set(&ctx->wait_vsync_event, 0);
+		wake_up(&ctx->wait_vsync_queue);
+	}
+
+	spin_unlock_irqrestore(&drm_dev->event_lock, flags);
+}
+
+static int lcdc_bind(struct device *dev, struct device *master, void *data)
+{
+	struct drm_device *drm_dev = data;
+	struct rockchip_drm_private *private = drm_dev->dev_private;
+	struct lcdc_context *ctx = dev_get_drvdata(dev);
+	struct drm_crtc *crtc;
+
+	ctx->drm_dev = drm_dev;
+
+	ctx->pipe = rockchip_drm_pipe_get(dev);
+	ctx->dpms = DRM_MODE_DPMS_OFF;
+	crtc = &ctx->crtc;
+
+	private->crtc[ctx->pipe] = crtc;
+	ctx->plane = rockchip_plane_init(drm_dev, 1 << ctx->pipe, true);
+	drm_crtc_init(drm_dev, crtc, &rockchip_crtc_funcs);
+	drm_crtc_helper_add(crtc, &rockchip_crtc_helper_funcs);
+
+	/*
+	 * enable drm irq mode.
+	 * - with irq_enabled = true, we can use the vblank feature.
+	 *
+	 * P.S. note that we wouldn't use drm irq handler but
+	 *      just specific driver own one instead because
+	 *      drm framework supports only one irq handler.
+	 */
+	drm_dev->irq_enabled = true;
+
+	/*
+	 * with vblank_disable_allowed = true, vblank interrupt will be disabled
+	 * by drm timer once a current process gives up ownership of
+	 * vblank event.(after drm_vblank_put function is called)
+	 */
+	drm_dev->vblank_disable_allowed = true;
+
+	return 0;
+}
+
+static void lcdc_unbind(struct device *dev, struct device *master,
+			void *data)
+{	struct drm_device *drm_dev = data;
+	struct rockchip_drm_private *private = drm_dev->dev_private;
+	struct lcdc_context *ctx = dev_get_drvdata(dev);
+	struct drm_crtc *crtc = &ctx->crtc;
+
+	drm_crtc_cleanup(crtc);
+	private->crtc[ctx->pipe] = NULL;
+}
+
+static const struct component_ops lcdc_component_ops = {
+	.bind = lcdc_bind,
+	.unbind = lcdc_unbind,
+};
+
+static int lcdc_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct lcdc_context *ctx;
+	struct lcdc_driver *lcdc_drv;
+	struct lcdc_driver_data *lcdc_data = drm_lcdc_get_driver_data(pdev);
+	int ret = -EINVAL;
+
+	ctx = devm_kzalloc(dev, sizeof(*ctx), GFP_KERNEL);
+	if (!ctx)
+		return -ENOMEM;
+
+	if (!(lcdc_data->num_win && lcdc_data->init &&
+	      lcdc_data->deinit && lcdc_data->dpms &&
+	      lcdc_data->mode_set && lcdc_data->enable_vblank &&
+	      lcdc_data->disable_vblank &&
+	      lcdc_data->win_commit)) {
+		DRM_ERROR("lcdc driver ops is Incomplete\n");
+		return -EINVAL;
+	}
+	lcdc_drv = lcdc_data->init(pdev);
+	if (!lcdc_drv)
+		return -EINVAL;
+
+	lcdc_drv->data = lcdc_data;
+	ret = rockchip_drm_component_add(&pdev->dev, ROCKCHIP_DEVICE_TYPE_CRTC,
+					 ROCKCHIP_DISPLAY_TYPE_LCD, ctx);
+	if (ret)
+		goto err_deinit_lcdc;
+
+	ctx->dev = dev;
+	ctx->default_win = ZPOS_DEFAULT_WIN;
+
+	ctx->drv = lcdc_drv;
+
+	init_waitqueue_head(&ctx->wait_vsync_queue);
+	atomic_set(&ctx->wait_vsync_event, 0);
+
+	platform_set_drvdata(pdev, ctx);
+
+	pm_runtime_enable(&pdev->dev);
+
+	ret = component_add(&pdev->dev, &lcdc_component_ops);
+	if (ret)
+		goto err_disable_pm_runtime;
+
+	return ret;
+
+err_disable_pm_runtime:
+	pm_runtime_disable(dev);
+	rockchip_drm_component_del(dev, ROCKCHIP_DEVICE_TYPE_CRTC);
+err_deinit_lcdc:
+	lcdc_data->deinit(ctx->drv);
+	return ret;
+}
+
+static int lcdc_remove(struct platform_device *pdev)
+{
+	pm_runtime_disable(&pdev->dev);
+
+	component_del(&pdev->dev, &lcdc_component_ops);
+	rockchip_drm_component_del(&pdev->dev, ROCKCHIP_DEVICE_TYPE_CRTC);
+
+	return 0;
+}
+
+struct platform_driver rockchip_lcdc_platform_driver = {
+	.probe = lcdc_probe,
+	.remove = lcdc_remove,
+	.driver = {
+		.name = "rockchip-lcdc",
+		.owner = THIS_MODULE,
+		.of_match_table = of_match_ptr(lcdc_driver_dt_match),
+	},
+};
diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_lcdc.h b/drivers/gpu/drm/rockchip/rockchip_drm_lcdc.h
new file mode 100644
index 0000000..0a0f9c2
--- /dev/null
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_lcdc.h
@@ -0,0 +1,131 @@
+/*
+ * Copyright (C) Fuzhou Rockchip Electronics Co.Ltd
+ * Author:mark yao <mark.yao@rock-chips.com>
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef _ROCKCHIP_DRM_LCDC_H_
+#define _ROCKCHIP_DRM_LCDC_H_
+#include <linux/platform_device.h>
+#include <drm/drm_crtc.h>
+
+#include "rockchip_drm_drv.h"
+
+enum {
+	ZPOS_DEFAULT_WIN = 0,
+	ZPOS_CURSOR_WIN,
+	ZPOS_MAX_NUM,
+	ZPOS_UNUSED_WIN
+};
+
+enum data_format {
+	ARGB888 = 0,
+	RGB888,
+	RGB565,
+	YUV420 = 4,
+	YUV422,
+	YUV444,
+	XRGB888,
+	XBGR888,
+	ABGR888,
+	YUV420_A = 10,
+	YUV422_A,
+	YUV444_A
+};
+
+struct lcdc_win_data {
+	int zpos;
+	int id;
+	enum data_format format;
+	u32 xact;
+	u32 yact;
+	u32 xsize;
+	u32 ysize;
+	u32 xpos;
+	u32 ypos;
+	u32 y_vir_stride;
+	u32 uv_vir_stride;
+	bool alpha_en;
+	bool enabled;
+	bool resume;
+
+	dma_addr_t yrgb_addr;
+	dma_addr_t uv_addr;
+
+	int dsp_stx;
+	int dsp_sty;
+	/* win sel layer */
+	int z_order;
+	u8 fmt_cfg;
+	u8 fmt_10;
+	u8 swap_rb;
+	u32 reserved;
+	u32 area_num;
+	u32 scale_yrgb_x;
+	u32 scale_yrgb_y;
+	u32 scale_cbcr_x;
+	u32 scale_cbcr_y;
+	bool support_3d;
+
+	u8 win_lb_mode;
+
+	u8 bic_coe_el;
+	/* h 01:scale up ;10:down */
+	u8 yrgb_hor_scl_mode;
+	/* v 01:scale up ;10:down */
+	u8 yrgb_ver_scl_mode;
+	/* h scale down mode */
+	u8 yrgb_hsd_mode;
+	/* v scale up mode */
+	u8 yrgb_vsu_mode;
+	/* v scale down mode */
+	u8 yrgb_vsd_mode;
+	u8 cbr_hor_scl_mode;
+	u8 cbr_ver_scl_mode;
+	u8 cbr_hsd_mode;
+	u8 cbr_vsu_mode;
+	u8 cbr_vsd_mode;
+	u8 vsd_yrgb_gt4;
+	u8 vsd_yrgb_gt2;
+	u8 vsd_cbr_gt4;
+	u8 vsd_cbr_gt2;
+
+	u32 alpha_mode;
+	u32 g_alpha_val;
+	u32 color_key_val;
+};
+
+struct lcdc_driver_data {
+	int num_win;
+	struct lcdc_driver * (*init)(struct platform_device *pdev);
+	void (*deinit)(struct lcdc_driver *drv);
+	void (*dpms)(struct lcdc_driver *drv, int mode);
+	void (*mode_set)(struct lcdc_driver *drv,
+			 struct drm_display_mode *mode);
+	void (*enable_vblank)(struct lcdc_driver *drv);
+	void (*disable_vblank)(struct lcdc_driver *drv);
+	struct lcdc_win_data * (*get_win)(struct lcdc_driver *drv, int zpos);
+	void (*win_commit)(struct lcdc_driver *drv,
+			   struct lcdc_win_data *win);
+};
+
+struct lcdc_driver {
+	int id;
+
+	struct lcdc_driver_data *data;
+};
+
+
+void lcdc_vsync_event_handler(struct device *dev);
+#ifdef CONFIG_LCDC_RK3288
+extern struct lcdc_driver_data rockchip_rk3288_lcdc;
+#endif
+#endif /* _ROCKCHIP_DRM_LCDC_H_ */
diff --git a/include/uapi/drm/rockchip_drm.h b/include/uapi/drm/rockchip_drm.h
new file mode 100644
index 0000000..1b567f7
--- /dev/null
+++ b/include/uapi/drm/rockchip_drm.h
@@ -0,0 +1,110 @@
+/*
+ *
+ * Copyright (c) Fuzhou Rockchip Electronics Co.Ltd
+ * Authors:
+ *       mark yao <yzq@rock-chips.com>
+ *
+ * base on exynos_drm.h
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ */
+
+#ifndef _UAPI_ROCKCHIP_DRM_H_
+#define _UAPI_ROCKCHIP_DRM_H_
+
+#include <drm/drm.h>
+
+/**
+ * User-desired buffer creation information structure.
+ *
+ * @size: user-desired memory allocation size.
+ *     - this size value would be page-aligned internally.
+ * @flags: user request for setting memory type or cache attributes.
+ * @handle: returned a handle to created gem object.
+ *     - this handle will be set by gem module of kernel side.
+ */
+struct drm_rockchip_gem_create {
+	uint64_t size;
+	unsigned int flags;
+	unsigned int handle;
+};
+
+/**
+ * A structure for getting buffer offset.
+ *
+ * @handle: a pointer to gem object created.
+ * @pad: just padding to be 64-bit aligned.
+ * @offset: relatived offset value of the memory region allocated.
+ *     - this value should be set by user.
+ */
+struct drm_rockchip_gem_map_off {
+	unsigned int handle;
+	unsigned int pad;
+	uint64_t offset;
+};
+
+/**
+ * A structure for mapping buffer.
+ *
+ * @handle: a handle to gem object created.
+ * @pad: just padding to be 64-bit aligned.
+ * @size: memory size to be mapped.
+ * @mapped: having user virtual address mmaped.
+ *      - this variable would be filled by rockchip gem module
+ *      of kernel side with user virtual address which is allocated
+ *      by do_mmap().
+ */
+struct drm_rockchip_gem_mmap {
+	unsigned int handle;
+	unsigned int pad;
+	uint64_t size;
+	uint64_t mapped;
+};
+
+/**
+ * A structure to gem information.
+ *
+ * @handle: a handle to gem object created.
+ * @flags: flag value including memory type and cache attribute and
+ *      this value would be set by driver.
+ * @size: size to memory region allocated by gem and this size would
+ *      be set by driver.
+ */
+struct drm_rockchip_gem_info {
+	unsigned int handle;
+	unsigned int flags;
+	uint64_t size;
+};
+
+/* memory type definitions. */
+enum e_drm_rockchip_gem_mem_type {
+	/* non-cachable mapping and used as default. */
+	ROCKCHIP_BO_NONCACHABLE = 0 << 0,
+	/* cachable mapping. */
+	ROCKCHIP_BO_CACHABLE = 1 << 0,
+	/* write-combine mapping. */
+	ROCKCHIP_BO_WC = 1 << 1,
+	ROCKCHIP_BO_MASK = ROCKCHIP_BO_CACHABLE | ROCKCHIP_BO_WC
+};
+
+#define DRM_ROCKCHIP_GEM_CREATE		0x00
+#define DRM_ROCKCHIP_GEM_MAP_OFFSET	0x01
+#define DRM_ROCKCHIP_GEM_MMAP		0x02
+/* Reserved 0x03 ~ 0x05 for rockchip specific gem ioctl */
+#define DRM_ROCKCHIP_GEM_GET		0x04
+
+#define DRM_IOCTL_ROCKCHIP_GEM_CREATE	DRM_IOWR(DRM_COMMAND_BASE + \
+		DRM_ROCKCHIP_GEM_CREATE, struct drm_rockchip_gem_create)
+
+#define DRM_IOCTL_ROCKCHIP_GEM_MAP_OFFSET	DRM_IOWR(DRM_COMMAND_BASE + \
+		DRM_ROCKCHIP_GEM_MAP_OFFSET, struct drm_rockchip_gem_map_off)
+
+#define DRM_IOCTL_ROCKCHIP_GEM_MMAP	DRM_IOWR(DRM_COMMAND_BASE + \
+		DRM_ROCKCHIP_GEM_MMAP, struct drm_rockchip_gem_mmap)
+
+#define DRM_IOCTL_ROCKCHIP_GEM_GET	DRM_IOWR(DRM_COMMAND_BASE + \
+		DRM_ROCKCHIP_GEM_GET, struct drm_rockchip_gem_info)
+#endif /* _UAPI_ROCKCHIP_DRM_H_ */
-- 
1.7.9.5


