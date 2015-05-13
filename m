From: CK Hu <ck.hu@mediatek.com>
Subject: [RFC][PATCH 2/2] drm/mediatek: Add DRM Driver for Mediatek SoC MT8173.
Date: Wed, 13 May 2015 23:23:46 +0800
Message-ID: <1431530626-31493-3-git-send-email-ck.hu@mediatek.com>
References: <1431530626-31493-1-git-send-email-ck.hu@mediatek.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1431530626-31493-1-git-send-email-ck.hu@mediatek.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, David Airlie <airlied@linux.ie>, Matthias Brugger <matthias.bgg@gmail.com>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-mediatek@lists.infradead.org, Rob Herring <robh@kernel.org>, Ashwin Chaugule <ashwin.chaugule@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Grant Likely <grant.likely@linaro.org>, Graeme Gregory <graeme.gregory@linaro.org>, dri-devel@lists.freedesktop.org, linux-api@vger.kernel.org, srv_heupstream@mediatek.com, Sascha Hauer <kernel@pengutronix.de>, Cawa Cheng <cawa.cheng@mediatek.com>, YT Shen <yt.shen@mediatek.com>, Jitao Shi <jitao.shi@mediatek.com>, CK Hu <ck.hu@mediatek.com>
List-Id: linux-api@vger.kernel.org

This patch is a DRM Driver for Mediatek SoC MT8173.
Now support one crtc with MIPI DSI interface.
We used GEM framework for buffer management and use iommu for
physically non-continuous memory.

Signed-off-by: CK Hu <ck.hu@mediatek.com>
---
 drivers/gpu/drm/Kconfig                           |    2 +
 drivers/gpu/drm/Makefile                          |    1 +
 drivers/gpu/drm/mediatek/Kconfig                  |   28 +
 drivers/gpu/drm/mediatek/Makefile                 |   13 +
 drivers/gpu/drm/mediatek/mediatek_drm_crtc.c      |  246 ++++
 drivers/gpu/drm/mediatek/mediatek_drm_crtc.h      |   80 ++
 drivers/gpu/drm/mediatek/mediatek_drm_crtc_main.c |  420 +++++++
 drivers/gpu/drm/mediatek/mediatek_drm_ddp.c       |  202 ++++
 drivers/gpu/drm/mediatek/mediatek_drm_ddp.h       |   23 +
 drivers/gpu/drm/mediatek/mediatek_drm_ddp_comp.c  |  346 ++++++
 drivers/gpu/drm/mediatek/mediatek_drm_ddp_comp.h  |   33 +
 drivers/gpu/drm/mediatek/mediatek_drm_drv.c       |  369 ++++++
 drivers/gpu/drm/mediatek/mediatek_drm_drv.h       |   37 +
 drivers/gpu/drm/mediatek/mediatek_drm_dsi.c       | 1333 +++++++++++++++++++++
 drivers/gpu/drm/mediatek/mediatek_drm_dsi.h       |   71 ++
 drivers/gpu/drm/mediatek/mediatek_drm_fb.c        |  339 ++++++
 drivers/gpu/drm/mediatek/mediatek_drm_fb.h        |   43 +
 drivers/gpu/drm/mediatek/mediatek_drm_gem.c       |  315 +++++
 drivers/gpu/drm/mediatek/mediatek_drm_gem.h       |   94 ++
 include/uapi/drm/mediatek_drm.h                   |   59 +
 20 files changed, 4054 insertions(+)
 create mode 100644 drivers/gpu/drm/mediatek/Kconfig
 create mode 100644 drivers/gpu/drm/mediatek/Makefile
 create mode 100644 drivers/gpu/drm/mediatek/mediatek_drm_crtc.c
 create mode 100644 drivers/gpu/drm/mediatek/mediatek_drm_crtc.h
 create mode 100644 drivers/gpu/drm/mediatek/mediatek_drm_crtc_main.c
 create mode 100644 drivers/gpu/drm/mediatek/mediatek_drm_ddp.c
 create mode 100644 drivers/gpu/drm/mediatek/mediatek_drm_ddp.h
 create mode 100644 drivers/gpu/drm/mediatek/mediatek_drm_ddp_comp.c
 create mode 100644 drivers/gpu/drm/mediatek/mediatek_drm_ddp_comp.h
 create mode 100644 drivers/gpu/drm/mediatek/mediatek_drm_drv.c
 create mode 100644 drivers/gpu/drm/mediatek/mediatek_drm_drv.h
 create mode 100644 drivers/gpu/drm/mediatek/mediatek_drm_dsi.c
 create mode 100644 drivers/gpu/drm/mediatek/mediatek_drm_dsi.h
 create mode 100644 drivers/gpu/drm/mediatek/mediatek_drm_fb.c
 create mode 100644 drivers/gpu/drm/mediatek/mediatek_drm_fb.h
 create mode 100644 drivers/gpu/drm/mediatek/mediatek_drm_gem.c
 create mode 100644 drivers/gpu/drm/mediatek/mediatek_drm_gem.h
 create mode 100644 include/uapi/drm/mediatek_drm.h

diff --git a/drivers/gpu/drm/Kconfig b/drivers/gpu/drm/Kconfig
index 47f2ce8..441be2d 100644
--- a/drivers/gpu/drm/Kconfig
+++ b/drivers/gpu/drm/Kconfig
@@ -217,3 +217,5 @@ source "drivers/gpu/drm/sti/Kconfig"
 source "drivers/gpu/drm/amd/amdkfd/Kconfig"
 
 source "drivers/gpu/drm/imx/Kconfig"
+
+source "drivers/gpu/drm/mediatek/Kconfig"
diff --git a/drivers/gpu/drm/Makefile b/drivers/gpu/drm/Makefile
index 7d4944e..55fe66c 100644
--- a/drivers/gpu/drm/Makefile
+++ b/drivers/gpu/drm/Makefile
@@ -67,6 +67,7 @@ obj-$(CONFIG_DRM_MSM) += msm/
 obj-$(CONFIG_DRM_TEGRA) += tegra/
 obj-$(CONFIG_DRM_STI) += sti/
 obj-$(CONFIG_DRM_IMX) += imx/
+obj-$(CONFIG_DRM_MEDIATEK) += mediatek/
 obj-y			+= i2c/
 obj-y			+= panel/
 obj-y			+= bridge/
diff --git a/drivers/gpu/drm/mediatek/Kconfig b/drivers/gpu/drm/mediatek/Kconfig
new file mode 100644
index 0000000..fa581fb
--- /dev/null
+++ b/drivers/gpu/drm/mediatek/Kconfig
@@ -0,0 +1,28 @@
+config DRM_MEDIATEK
+	tristate "DRM Support for Mediatek SoCs"
+	depends on DRM
+	depends on ARCH_MEDIATEK || (ARM && COMPILE_TEST)
+	select MTK_SMI
+	select DRM_PANEL
+	select DRM_MIPI_DSI
+	select DRM_PANEL_SIMPLE
+	select DRM_KMS_HELPER
+	select IOMMU_DMA
+	help
+	  Choose this option if you have a Mediatek SoCs.
+	  The module will be called mediatek-drm
+	  This driver provides kernel mode setting and
+	  buffer management to userspace.
+
+config DRM_MEDIATEK_FBDEV
+	bool "Enable legacy fbdev support for Mediatek DRM"
+	depends on DRM_MEDIATEK
+	select FB_SYS_FILLRECT
+	select FB_SYS_COPYAREA
+	select FB_SYS_IMAGEBLIT
+	select DRM_KMS_FB_HELPER
+	help
+	  Choose this option if you have a need for the legacy
+	  fbdev support.  Note that this support also provides
+	  the Linux console on top of the Mediatek DRM mode
+	  setting driver.
diff --git a/drivers/gpu/drm/mediatek/Makefile b/drivers/gpu/drm/mediatek/Makefile
new file mode 100644
index 0000000..a566a83
--- /dev/null
+++ b/drivers/gpu/drm/mediatek/Makefile
@@ -0,0 +1,13 @@
+mediatek-drm-objs := mediatek_drm_drv.o \
+                  mediatek_drm_crtc.o \
+                  mediatek_drm_fb.o \
+                  mediatek_drm_gem.o \
+                  mediatek_drm_dsi.o \
+                  mediatek_drm_ddp.o \
+                  mediatek_drm_ddp_comp.o \
+                  mediatek_drm_crtc_main.o
+
+obj-$(CONFIG_DRM_MEDIATEK) += mediatek-drm.o
+
+ccflags-y += \
+ -Idrivers/gpu/drm
diff --git a/drivers/gpu/drm/mediatek/mediatek_drm_crtc.c b/drivers/gpu/drm/mediatek/mediatek_drm_crtc.c
new file mode 100644
index 0000000..e1437c6
--- /dev/null
+++ b/drivers/gpu/drm/mediatek/mediatek_drm_crtc.c
@@ -0,0 +1,246 @@
+/*
+ * Copyright (c) 2015 MediaTek Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <drm/drmP.h>
+#include <drm/drm_gem.h>
+#include <drm/drm_crtc_helper.h>
+#include <drm/drm_plane_helper.h>
+#include <linux/dma-buf.h>
+#include <linux/reservation.h>
+
+#include "mediatek_drm_drv.h"
+#include "mediatek_drm_crtc.h"
+#include "mediatek_drm_fb.h"
+#include "mediatek_drm_gem.h"
+
+
+void mtk_crtc_finish_page_flip(struct mtk_drm_crtc *mtk_crtc)
+{
+	struct drm_device *dev = mtk_crtc->base.dev;
+
+	drm_send_vblank_event(dev, mtk_crtc->event->pipe, mtk_crtc->event);
+	drm_crtc_vblank_put(&mtk_crtc->base);
+	mtk_crtc->event = NULL;
+}
+
+static void mediatek_drm_crtc_pending_ovl_config(struct mtk_drm_crtc *mtk_crtc,
+	bool enable, unsigned int addr)
+{
+	if (mtk_crtc->ops && mtk_crtc->ops->ovl_layer_config)
+		mtk_crtc->ops->ovl_layer_config(mtk_crtc, enable, addr);
+}
+
+static void mediatek_drm_crtc_pending_ovl_cursor_config(
+	struct mtk_drm_crtc *mtk_crtc,
+	bool enable, unsigned int addr)
+{
+	if (mtk_crtc->ops && mtk_crtc->ops->ovl_layer_config_cursor)
+		mtk_crtc->ops->ovl_layer_config_cursor(mtk_crtc, enable, addr);
+}
+
+static int mtk_drm_crtc_page_flip(struct drm_crtc *crtc,
+	struct drm_framebuffer *fb,
+	struct drm_pending_vblank_event *event,
+	uint32_t page_flip_flags)
+{
+	struct mtk_drm_crtc *mtk_crtc = to_mtk_crtc(crtc);
+	struct mtk_drm_fb *mtk_fb = to_mtk_fb(fb);
+	struct drm_device *dev = crtc->dev;
+	unsigned long flags;
+	bool busy;
+	int ret;
+
+	spin_lock_irqsave(&dev->event_lock, flags);
+	busy = !!mtk_crtc->event;
+	if (!busy)
+		mtk_crtc->event = event;
+	spin_unlock_irqrestore(&dev->event_lock, flags);
+	if (busy)
+		return -EBUSY;
+
+	if (fb->width != crtc->mode.hdisplay ||
+		fb->height != crtc->mode.vdisplay) {
+		DRM_ERROR("mtk_drm_crtc_page_flip width/height not match !!\n");
+		return -EINVAL;
+	}
+
+	if (event) {
+		ret = drm_crtc_vblank_get(crtc);
+		if (ret) {
+			DRM_ERROR("failed to acquire vblank events\n");
+			return ret;
+		}
+	}
+
+	/*
+	 * the values related to a buffer of the drm framebuffer
+	 * to be applied should be set at here. because these values
+	 * first, are set to shadow registers and then to
+	 * real registers at vsync front porch period.
+	 */
+	crtc->primary->fb = fb;
+	mtk_crtc->flip_buffer = to_mtk_gem_obj(mtk_fb->gem_obj[0])->buffer;
+
+	mediatek_drm_crtc_pending_ovl_config(mtk_crtc, true,
+		mtk_crtc->flip_buffer->mva_addr);
+
+	spin_lock_irqsave(&dev->event_lock, flags);
+	if (mtk_crtc->event)
+		mtk_crtc->pending_needs_vblank = true;
+	spin_unlock_irqrestore(&dev->event_lock, flags);
+
+	return ret;
+}
+
+static void mtk_drm_crtc_destroy(struct drm_crtc *crtc)
+{
+	drm_crtc_cleanup(crtc);
+}
+
+static void mtk_drm_crtc_prepare(struct drm_crtc *crtc)
+{
+	/* drm framework doesn't check NULL. */
+}
+
+static void mtk_drm_crtc_commit(struct drm_crtc *crtc)
+{
+	/*
+	 * when set_crtc is requested from user or at booting time,
+	 * crtc->commit would be called without dpms call so if dpms is
+	 * no power on then crtc->dpms should be called
+	 * with DRM_MODE_DPMS_ON for the hardware power to be on.
+	 */
+}
+
+static bool mtk_drm_crtc_mode_fixup(struct drm_crtc *crtc,
+	const struct drm_display_mode *mode,
+	struct drm_display_mode *adjusted_mode)
+{
+	/* drm framework doesn't check NULL */
+	return true;
+}
+
+static int mtk_drm_crtc_mode_set(struct drm_crtc *crtc,
+	struct drm_display_mode *mode,
+	struct drm_display_mode *adjusted_mode,
+	int x, int y, struct drm_framebuffer *old_fb)
+{
+	struct mtk_drm_crtc *mtk_crtc = to_mtk_crtc(crtc);
+	struct drm_framebuffer *fb;
+	struct mtk_drm_fb *mtk_fb;
+	struct mtk_drm_gem_buf *buffer;
+
+	fb = crtc->primary->fb;
+	mtk_fb = to_mtk_fb(fb);
+
+	buffer = to_mtk_gem_obj(mtk_fb->gem_obj[0])->buffer;
+
+	mediatek_drm_crtc_pending_ovl_config(mtk_crtc, true,
+		buffer->mva_addr);
+	/*
+	 * copy the mode data adjusted by mode_fixup() into crtc->mode
+	 * so that hardware can be seet to proper mode.
+	 */
+	memcpy(&crtc->mode, adjusted_mode, sizeof(*adjusted_mode));
+
+	/* Take a reference to the new fb as we're using it */
+	drm_framebuffer_reference(crtc->primary->fb);
+
+	return 0;
+}
+
+int mtk_drm_crtc_enable_vblank(struct drm_device *drm, int pipe)
+{
+	struct mtk_drm_private *priv =
+		(struct mtk_drm_private *)drm->dev_private;
+	struct mtk_drm_crtc *mtk_crtc;
+
+	if (pipe >= MAX_CRTC || pipe < 0) {
+		DRM_ERROR(" - %s: invalid crtc (%d)\n", __func__, pipe);
+		return -EINVAL;
+	}
+
+	mtk_crtc = to_mtk_crtc(priv->crtc[pipe]);
+
+	if (mtk_crtc->ops->enable_vblank)
+		mtk_crtc->ops->enable_vblank(mtk_crtc);
+
+	return 0;
+}
+
+void mtk_drm_crtc_disable_vblank(struct drm_device *drm, int pipe)
+{
+	struct mtk_drm_private *priv =
+		(struct mtk_drm_private *)drm->dev_private;
+	struct mtk_drm_crtc *mtk_crtc;
+
+	if (pipe >= MAX_CRTC || pipe < 0)
+		DRM_ERROR(" - %s: invalid crtc (%d)\n", __func__, pipe);
+
+	mtk_crtc = to_mtk_crtc(priv->crtc[pipe]);
+	if (mtk_crtc->ops->disable_vblank)
+		mtk_crtc->ops->disable_vblank(mtk_crtc);
+}
+
+static void mtk_drm_crtc_disable(struct drm_crtc *crtc)
+{
+	struct mtk_drm_crtc *mtk_crtc = to_mtk_crtc(crtc);
+
+	DRM_INFO("mtk_drm_crtc_disable %d\n", crtc->base.id);
+
+	mediatek_drm_crtc_pending_ovl_config(mtk_crtc, false, 0);
+	mediatek_drm_crtc_pending_ovl_cursor_config(mtk_crtc, false, 0);
+}
+
+static struct drm_crtc_funcs mediatek_crtc_funcs = {
+	.set_config		= drm_crtc_helper_set_config,
+	.page_flip		= mtk_drm_crtc_page_flip,
+	.destroy		= mtk_drm_crtc_destroy,
+};
+
+static struct drm_crtc_helper_funcs mediatek_crtc_helper_funcs = {
+	.prepare	= mtk_drm_crtc_prepare,
+	.commit		= mtk_drm_crtc_commit,
+	.mode_fixup	= mtk_drm_crtc_mode_fixup,
+	.mode_set	= mtk_drm_crtc_mode_set,
+	.disable	= mtk_drm_crtc_disable,
+};
+
+struct mtk_drm_crtc *mtk_drm_crtc_create(
+	struct drm_device *drm_dev, int pipe,
+	struct mediatek_drm_crtc_ops *ops,
+	void *ctx)
+{
+	struct mtk_drm_private *priv =
+		(struct mtk_drm_private *)drm_dev->dev_private;
+	struct mtk_drm_crtc *mtk_crtc;
+
+	mtk_crtc = devm_kzalloc(drm_dev->dev, sizeof(*mtk_crtc), GFP_KERNEL);
+	if (!mtk_crtc) {
+		DRM_ERROR("failed to allocate mtk crtc\n");
+		return ERR_PTR(-ENOMEM);
+	}
+
+	mtk_crtc->pipe = pipe;
+	mtk_crtc->ops = ops;
+	mtk_crtc->ctx = ctx;
+
+	priv->crtc[pipe] = &mtk_crtc->base;
+
+	drm_crtc_init(drm_dev, &mtk_crtc->base, &mediatek_crtc_funcs);
+	drm_crtc_helper_add(&mtk_crtc->base, &mediatek_crtc_helper_funcs);
+
+	return mtk_crtc;
+}
+
+
diff --git a/drivers/gpu/drm/mediatek/mediatek_drm_crtc.h b/drivers/gpu/drm/mediatek/mediatek_drm_crtc.h
new file mode 100644
index 0000000..1732927
--- /dev/null
+++ b/drivers/gpu/drm/mediatek/mediatek_drm_crtc.h
@@ -0,0 +1,80 @@
+/*
+ * Copyright (c) 2015 MediaTek Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+
+#ifndef _MEDIATEL_DRM_CRTC_H_
+#define _MEDIATEL_DRM_CRTC_H_
+
+#include "mediatek_drm_ddp.h"
+
+
+#define MAX_FB_BUFFER	4
+#define DEFAULT_ZPOS	-1
+
+struct mtk_drm_crtc;
+struct mediatek_drm_crtc_ops {
+	void (*dpms)(struct mtk_drm_crtc *crtc, int mode);
+	int (*enable_vblank)(struct mtk_drm_crtc *crtc);
+	void (*disable_vblank)(struct mtk_drm_crtc *crtc);
+	void (*ovl_layer_config)(struct mtk_drm_crtc *crtc,
+		bool enable, unsigned int addr);
+	void (*ovl_layer_config_cursor)(struct mtk_drm_crtc *crtc,
+		bool enable, unsigned int addr);
+};
+
+/*
+ * MediaTek specific crtc structure.
+ *
+ * @base: crtc object.
+ * @pipe: a crtc index created at load() with a new crtc object creation
+ *	and the crtc object would be set to private->crtc array
+ *	to get a crtc object corresponding to this pipe from private->crtc
+ *	array when irq interrupt occurred. the reason of using this pipe is that
+ *	drm framework doesn't support multiple irq yet.
+ *	we can refer to the crtc to current hardware interrupt occurred through
+ *	this pipe value.
+ */
+struct mtk_drm_crtc {
+	struct drm_crtc			base;
+
+	unsigned int			pipe;
+	struct drm_pending_vblank_event	*event;
+	struct mtk_drm_gem_buf *flip_buffer;
+	struct mediatek_drm_crtc_ops	*ops;
+	void				*ctx;
+	bool pending_needs_vblank;
+
+	bool pending_ovl_config;
+	bool pending_ovl_enabled;
+	unsigned int pending_ovl_addr;
+	unsigned int pending_ovl_width;
+	unsigned int pending_ovl_height;
+	unsigned int pending_ovl_pitch;
+	unsigned int pending_ovl_format;
+
+};
+
+#define to_mtk_crtc(x) container_of(x, struct mtk_drm_crtc, base)
+
+struct mtk_drm_crtc *mtk_drm_crtc_create(
+	struct drm_device *drm_dev,	int pipe,
+	struct mediatek_drm_crtc_ops *ops,
+	void *ctx);
+void mtk_drm_crtc_irq(struct mtk_drm_crtc *mtk_crtc);
+
+void mtk_crtc_finish_page_flip(struct mtk_drm_crtc *mtk_crtc);
+int mtk_drm_crtc_enable_vblank(struct drm_device *drm, int pipe);
+void mtk_drm_crtc_disable_vblank(struct drm_device *drm, int pipe);
+
+#endif
+
diff --git a/drivers/gpu/drm/mediatek/mediatek_drm_crtc_main.c b/drivers/gpu/drm/mediatek/mediatek_drm_crtc_main.c
new file mode 100644
index 0000000..4d16620
--- /dev/null
+++ b/drivers/gpu/drm/mediatek/mediatek_drm_crtc_main.c
@@ -0,0 +1,420 @@
+/*
+ * Copyright (c) 2015 MediaTek Inc.
+ * Authors:
+ *	YT Shen <yt.shen@mediatek.com>
+ *	CK Hu <ck.hu@mediatek.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <drm/drmP.h>
+#include <linux/kernel.h>
+#include <linux/platform_device.h>
+#include <linux/clk.h>
+#include <linux/of_device.h>
+#include <linux/component.h>
+#include <linux/pm_runtime.h>
+#include "mediatek_drm_drv.h"
+#include "mediatek_drm_crtc.h"
+#include "mediatek_drm_gem.h"
+#include "mediatek_drm_ddp_comp.h"
+
+
+struct crtc_main_context {
+	struct device		*dev;
+	struct drm_device	*drm_dev;
+	struct mtk_drm_crtc	*crtc;
+	int	pipe;
+
+	struct device		*ddp_dev;
+	struct clk		*ovl0_disp_clk;
+	struct clk		*rdma0_disp_clk;
+	struct clk		*color0_disp_clk;
+	struct clk		*aal_disp_clk;
+	struct clk		*ufoe_disp_clk;
+	struct clk		*od_disp_clk;
+
+	void __iomem		*ovl0_regs;
+	void __iomem		*rdma0_regs;
+	void __iomem		*color0_regs;
+	void __iomem		*aal_regs;
+	void __iomem		*ufoe_regs;
+	void __iomem		*od_regs;
+
+	bool			pending_ovl_config;
+	bool			pending_ovl_enable;
+	unsigned int		pending_ovl_addr;
+	unsigned int		pending_ovl_width;
+	unsigned int		pending_ovl_height;
+	unsigned int		pending_ovl_pitch;
+	unsigned int		pending_ovl_format;
+};
+
+
+static int crtc_main_ctx_initialize(struct crtc_main_context *ctx,
+	struct drm_device *drm_dev)
+{
+	struct mtk_drm_private *priv;
+
+	priv = drm_dev->dev_private;
+	ctx->drm_dev = drm_dev;
+	ctx->pipe = priv->pipe++;
+
+	return 0;
+}
+
+static void crtc_main_ctx_remove(struct crtc_main_context *ctx)
+{
+}
+
+static void crtc_main_power_on(struct crtc_main_context *ctx)
+{
+	int ret;
+
+	ret = clk_prepare_enable(ctx->ovl0_disp_clk);
+	if (ret != 0)
+		DRM_ERROR("clk_prepare_enable(ctx->ovl0_disp_clk) error!\n");
+
+	ret = clk_prepare_enable(ctx->rdma0_disp_clk);
+	if (ret != 0)
+		DRM_ERROR("clk_prepare_enable(ctx->rdma0_disp_clk) error!\n");
+
+	ret = clk_prepare_enable(ctx->color0_disp_clk);
+	if (ret != 0)
+		DRM_ERROR("clk_prepare_enable(ctx->color0_disp_clk) error!\n");
+
+	ret = clk_prepare_enable(ctx->aal_disp_clk);
+	if (ret != 0)
+		DRM_ERROR("clk_prepare_enable(ctx->aal_disp_clk) error!\n");
+
+	ret = clk_prepare_enable(ctx->ufoe_disp_clk);
+	if (ret != 0)
+		DRM_ERROR("clk_prepare_enable(ctx->ufoe_disp_clk) error!\n");
+
+	ret = clk_prepare_enable(ctx->od_disp_clk);
+	if (ret != 0)
+		DRM_ERROR("clk_prepare_enable(ctx->od_disp_clk) error!\n");
+}
+
+static void crtc_main_power_off(struct crtc_main_context *ctx)
+{
+	clk_disable_unprepare(ctx->ovl0_disp_clk);
+
+	clk_disable_unprepare(ctx->rdma0_disp_clk);
+
+	clk_disable_unprepare(ctx->color0_disp_clk);
+
+	clk_disable_unprepare(ctx->aal_disp_clk);
+
+	clk_disable_unprepare(ctx->ufoe_disp_clk);
+
+	clk_disable_unprepare(ctx->od_disp_clk);
+}
+
+static void crtc_main_dpms(struct mtk_drm_crtc *crtc, int mode)
+{
+	/* DRM_DEBUG_KMS("%s, %d\n", __FILE__, mode); */
+
+	switch (mode) {
+	case DRM_MODE_DPMS_ON:
+		crtc_main_power_on(crtc->ctx);
+		break;
+	case DRM_MODE_DPMS_STANDBY:
+	case DRM_MODE_DPMS_SUSPEND:
+	case DRM_MODE_DPMS_OFF:
+		crtc_main_power_off(crtc->ctx);
+		break;
+	default:
+		DRM_DEBUG_KMS("unspecified mode %d\n", mode);
+		break;
+	}
+}
+
+static int crtc_main_enable_vblank(struct mtk_drm_crtc *crtc)
+{
+	struct crtc_main_context *ctx = (struct crtc_main_context *)crtc->ctx;
+
+	mediatek_od_enable_vblank(ctx->od_regs);
+
+	return 0;
+}
+
+static void crtc_main_disable_vblank(struct mtk_drm_crtc *crtc)
+{
+	struct crtc_main_context *ctx = (struct crtc_main_context *)crtc->ctx;
+
+	mediatek_od_disable_vblank(ctx->od_regs);
+}
+
+static void crtc_main_ovl_layer_config(struct mtk_drm_crtc *crtc,
+	bool enable, unsigned int addr)
+{
+	struct crtc_main_context *ctx = (struct crtc_main_context *)crtc->ctx;
+	unsigned int pitch = 0;
+
+	if (crtc->base.primary->fb && crtc->base.primary->fb->pitches[0])
+		pitch = crtc->base.primary->fb->pitches[0];
+
+	ctx->pending_ovl_enable = enable;
+	if (enable) {
+		ctx->pending_ovl_addr = addr;
+		ctx->pending_ovl_width = crtc->base.mode.hdisplay;
+		ctx->pending_ovl_height = crtc->base.mode.vdisplay;
+		ctx->pending_ovl_pitch = pitch;
+		ctx->pending_ovl_format = crtc->base.primary->fb->pixel_format;
+	}
+	ctx->pending_ovl_config = true;
+}
+
+static struct mediatek_drm_crtc_ops crtc_main_crtc_ops = {
+	.dpms = crtc_main_dpms,
+	.enable_vblank = crtc_main_enable_vblank,
+	.disable_vblank = crtc_main_disable_vblank,
+	.ovl_layer_config = crtc_main_ovl_layer_config,
+};
+
+static void crtc_main_irq(struct crtc_main_context *ctx)
+{
+	struct drm_device *dev = ctx->drm_dev;
+	struct mtk_drm_crtc *mtk_crtc = ctx->crtc;
+	unsigned long flags;
+
+	if (ctx->pending_ovl_config) {
+		ctx->pending_ovl_config = false;
+		mediatek_ovl_layer_config(ctx->ovl0_regs,
+			ctx->pending_ovl_enable,
+			ctx->pending_ovl_addr,
+			ctx->pending_ovl_width,
+			ctx->pending_ovl_height,
+			ctx->pending_ovl_pitch,
+			ctx->pending_ovl_format);
+	}
+
+	drm_handle_vblank(ctx->drm_dev, ctx->pipe);
+	spin_lock_irqsave(&dev->event_lock, flags);
+	if (mtk_crtc->pending_needs_vblank) {
+		mtk_crtc_finish_page_flip(mtk_crtc);
+		mtk_crtc->pending_needs_vblank = false;
+	}
+	spin_unlock_irqrestore(&dev->event_lock, flags);
+}
+
+irqreturn_t crtc_main_irq_handler(int irq, void *dev_id)
+{
+	struct crtc_main_context *ctx = (struct crtc_main_context *)dev_id;
+
+	mediatek_od_clear_vblank(ctx->od_regs);
+
+	if (ctx->pipe < 0 || !ctx->drm_dev)
+		goto out;
+
+	crtc_main_irq(ctx);
+out:
+	return IRQ_HANDLED;
+}
+
+static int crtc_main_bind(struct device *dev, struct device *master, void *data)
+{
+	struct crtc_main_context *ctx = dev_get_drvdata(dev);
+	struct drm_device *drm_dev = data;
+	int ret;
+
+	ret = crtc_main_ctx_initialize(ctx, drm_dev);
+	if (ret) {
+		DRM_ERROR("crtc_main_ctx_initialize failed.\n");
+		return ret;
+	}
+
+	ctx->crtc = mtk_drm_crtc_create(drm_dev, ctx->pipe,
+		&crtc_main_crtc_ops, ctx);
+
+	if (IS_ERR(ctx->crtc)) {
+		crtc_main_ctx_remove(ctx);
+		return PTR_ERR(ctx->crtc);
+	}
+
+	DRM_INFO("mediatek_ddp_clock_on\n");
+	mediatek_ddp_clock_on(ctx->ddp_dev);
+
+	DRM_INFO("mediatek_ddp_main_path_setup\n");
+	mediatek_ddp_main_path_setup(ctx->ddp_dev);
+
+	DRM_INFO("main_disp_path_power_on\n");
+	main_disp_path_power_on(ctx->ovl0_regs, ctx->rdma0_regs,
+		ctx->color0_regs, ctx->ufoe_regs, ctx->od_regs);
+
+	return 0;
+
+}
+
+static void crtc_main_unbind(struct device *dev, struct device *master,
+			void *data)
+{
+	struct crtc_main_context *ctx = dev_get_drvdata(dev);
+
+	crtc_main_ctx_remove(ctx);
+}
+
+static const struct component_ops crtc_main_component_ops = {
+	.bind	= crtc_main_bind,
+	.unbind = crtc_main_unbind,
+};
+
+static int crtc_main_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct crtc_main_context *ctx;
+	struct device_node *node;
+	struct platform_device *ddp_pdev;
+	struct resource *regs;
+	int irq;
+	int ret;
+
+	if (!dev->of_node)
+		return -ENODEV;
+
+	ctx = devm_kzalloc(dev, sizeof(*ctx), GFP_KERNEL);
+	if (!ctx)
+		return -ENOMEM;
+
+	node = of_parse_phandle(dev->of_node, "ddp", 0);
+	if (!node) {
+		dev_err(dev, "crtc_main_probe: Get ddp node fail.\n");
+		ret = -EINVAL;
+		goto err;
+	}
+
+	ddp_pdev = of_find_device_by_node(node);
+	if (WARN_ON(!ddp_pdev)) {
+		dev_err(dev, "crtc_main_probe: Find ddp device fail.\n");
+		ret = -EINVAL;
+		goto err;
+	}
+	ctx->ddp_dev = &ddp_pdev->dev;
+
+	ctx->ovl0_disp_clk = devm_clk_get(dev, "ovl0_disp");
+	if (IS_ERR(ctx->ovl0_disp_clk)) {
+		dev_err(dev, "crtc_main_probe: Get ovl0_disp_clk fail.\n");
+		ret = PTR_ERR(ctx->ovl0_disp_clk);
+		goto err;
+	}
+
+	ctx->rdma0_disp_clk = devm_clk_get(dev, "rdma0_disp");
+	if (IS_ERR(ctx->rdma0_disp_clk)) {
+		dev_err(dev, "crtc_main_probe: Get rdma0_disp_clk.\n");
+		ret = PTR_ERR(ctx->rdma0_disp_clk);
+		goto err;
+	}
+
+	ctx->color0_disp_clk = devm_clk_get(dev, "color0_disp");
+	if (IS_ERR(ctx->color0_disp_clk)) {
+		dev_err(dev, "crtc_main_probe: Get color0_disp_clk fail.\n");
+		ret = PTR_ERR(ctx->color0_disp_clk);
+		goto err;
+	}
+
+	ctx->aal_disp_clk = devm_clk_get(dev, "aal_disp");
+	if (IS_ERR(ctx->aal_disp_clk)) {
+		dev_err(dev, "crtc_main_probe: Get aal_disp_clk fail.\n");
+		ret = PTR_ERR(ctx->aal_disp_clk);
+		goto err;
+	}
+
+	ctx->ufoe_disp_clk = devm_clk_get(dev, "ufoe_disp");
+	if (IS_ERR(ctx->ufoe_disp_clk)) {
+		dev_err(dev, "crtc_main_probe: Get ufoe_disp_clk fail.\n");
+		ret = PTR_ERR(ctx->ufoe_disp_clk);
+		goto err;
+	}
+
+	ctx->od_disp_clk = devm_clk_get(dev, "od_disp");
+	if (IS_ERR(ctx->od_disp_clk)) {
+		dev_err(dev, "crtc_main_probe: Get od_disp_clk fail.\n");
+		ret = PTR_ERR(ctx->od_disp_clk);
+		goto err;
+	}
+
+	regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	ctx->ovl0_regs = devm_ioremap_resource(dev, regs);
+	if (IS_ERR(ctx->ovl0_regs))
+		return PTR_ERR(ctx->ovl0_regs);
+
+	regs = platform_get_resource(pdev, IORESOURCE_MEM, 1);
+	ctx->rdma0_regs = devm_ioremap_resource(dev, regs);
+	if (IS_ERR(ctx->rdma0_regs))
+		return PTR_ERR(ctx->rdma0_regs);
+
+	regs = platform_get_resource(pdev, IORESOURCE_MEM, 2);
+	ctx->color0_regs = devm_ioremap_resource(dev, regs);
+	if (IS_ERR(ctx->color0_regs))
+		return PTR_ERR(ctx->color0_regs);
+
+	regs = platform_get_resource(pdev, IORESOURCE_MEM, 3);
+	ctx->aal_regs = devm_ioremap_resource(dev, regs);
+	if (IS_ERR(ctx->aal_regs))
+		return PTR_ERR(ctx->aal_regs);
+
+	regs = platform_get_resource(pdev, IORESOURCE_MEM, 4);
+	ctx->ufoe_regs = devm_ioremap_resource(dev, regs);
+	if (IS_ERR(ctx->ufoe_regs))
+		return PTR_ERR(ctx->ufoe_regs);
+
+	regs = platform_get_resource(pdev, IORESOURCE_MEM, 5);
+	ctx->od_regs = devm_ioremap_resource(dev, regs);
+	if (IS_ERR(ctx->od_regs))
+		return PTR_ERR(ctx->od_regs);
+
+	irq = platform_get_irq(pdev, 0);
+	ret = devm_request_irq(dev, irq, crtc_main_irq_handler,
+		IRQF_TRIGGER_NONE, dev_name(dev), ctx);
+	if (ret < 0) {
+		dev_err(dev, "devm_request_irq %d fail %d\n", irq, ret);
+		ret = -ENXIO;
+		goto err;
+	}
+
+	platform_set_drvdata(pdev, ctx);
+
+	ret = component_add(&pdev->dev, &crtc_main_component_ops);
+	if (ret)
+		goto err;
+
+	return 0;
+
+err:
+	if (node)
+		of_node_put(node);
+
+	return ret;
+}
+
+static int crtc_main_remove(struct platform_device *pdev)
+{
+	component_del(&pdev->dev, &crtc_main_component_ops);
+
+	return 0;
+}
+
+static const struct of_device_id crtc_main_driver_dt_match[] = {
+	{ .compatible = "mediatek,mt8173-crtc-main" },
+	{},
+};
+MODULE_DEVICE_TABLE(of, crtc_main_driver_dt_match);
+
+struct platform_driver mediatek_crtc_main_driver = {
+	.probe		= crtc_main_probe,
+	.remove		= crtc_main_remove,
+	.driver		= {
+		.name	= "mediatek-crtc-main",
+		.owner	= THIS_MODULE,
+		.of_match_table = crtc_main_driver_dt_match,
+	},
+};
+
diff --git a/drivers/gpu/drm/mediatek/mediatek_drm_ddp.c b/drivers/gpu/drm/mediatek/mediatek_drm_ddp.c
new file mode 100644
index 0000000..bb6959b
--- /dev/null
+++ b/drivers/gpu/drm/mediatek/mediatek_drm_ddp.c
@@ -0,0 +1,202 @@
+/*
+ * Copyright (c) 2015 MediaTek Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <drm/drmP.h>
+#include <linux/platform_device.h>
+#include <linux/clk.h>
+#include <linux/pm_runtime.h>
+#include <linux/of_device.h>
+#include <linux/component.h>
+
+#include "mediatek_drm_crtc.h"
+#include "mediatek_drm_ddp.h"
+
+
+#define DISP_REG_CONFIG_DISP_OVL0_MOUT_EN	0x040
+#define DISP_REG_CONFIG_DISP_OVL1_MOUT_EN	0x044
+#define DISP_REG_CONFIG_DISP_OD_MOUT_EN		0x048
+#define DISP_REG_CONFIG_DISP_GAMMA_MOUT_EN	0x04C
+#define DISP_REG_CONFIG_DISP_UFOE_MOUT_EN	0x050
+#define DISP_REG_CONFIG_DISP_COLOR0_SEL_IN	0x084
+#define DISP_REG_CONFIG_DISP_COLOR1_SEL_IN	0x088
+#define DISP_REG_CONFIG_DPI_SEL_IN		0x0AC
+#define DISP_REG_CONFIG_DISP_PATH1_SOUT_SEL_IN	0x0C8
+#define DISP_REG_CONFIG_MMSYS_CG_CON0		0x100
+
+#define DISP_REG_CONFIG_MUTEX_EN(n)      (0x20 + 0x20 * n)
+#define DISP_REG_CONFIG_MUTEX_MOD(n)     (0x2C + 0x20 * n)
+#define DISP_REG_CONFIG_MUTEX_SOF(n)     (0x30 + 0x20 * n)
+
+
+enum {
+	MUTEX_MOD_OVL0      = 11,
+	MUTEX_MOD_RDMA0     = 13,
+	MUTEX_MOD_COLOR0    = 18,
+	MUTEX_MOD_AAL       = 20,
+	MUTEX_MOD_UFOE      = 22,
+	MUTEX_MOD_PWM0      = 23,
+	MUTEX_MOD_OD        = 25,
+};
+
+enum {
+	MUTEX_SOF_DSI0      = 1,
+};
+
+enum {
+	OVL0_MOUT_EN_COLOR0     = 0x1,
+};
+
+enum {
+	OD_MOUT_EN_RDMA0        = 0x1,
+};
+
+enum {
+	UFOE_MOUT_EN_DSI0       = 0x1,
+};
+
+enum {
+	COLOR0_SEL_IN_OVL0      = 0x1,
+};
+
+struct ddp_context {
+	struct device			*dev;
+	struct drm_device		*drm_dev;
+	struct mediatek_drm_crtc	*crtc;
+	int				pipe;
+
+	struct clk			*mutex_disp_clk;
+
+	void __iomem			*config_regs;
+	void __iomem			*mutex_regs;
+
+	bool				pending_ovl_config;
+	bool				pending_ovl_enable;
+	unsigned int			pending_ovl_addr;
+	unsigned int			pending_ovl_width;
+	unsigned int			pending_ovl_height;
+	unsigned int			pending_ovl_pitch;
+	unsigned int			pending_ovl_format;
+};
+
+
+static void disp_config_main_path_connection(void __iomem *disp_base)
+{
+	writel(OVL0_MOUT_EN_COLOR0,
+		disp_base + DISP_REG_CONFIG_DISP_OVL0_MOUT_EN);
+	writel(OD_MOUT_EN_RDMA0, disp_base + DISP_REG_CONFIG_DISP_OD_MOUT_EN);
+	writel(UFOE_MOUT_EN_DSI0,
+		disp_base + DISP_REG_CONFIG_DISP_UFOE_MOUT_EN);
+	writel(COLOR0_SEL_IN_OVL0,
+		disp_base + DISP_REG_CONFIG_DISP_COLOR0_SEL_IN);
+}
+
+static void disp_config_main_path_mutex(void __iomem *mutex_base)
+{
+	unsigned int id = 0;
+
+	writel((1 << MUTEX_MOD_OVL0 | 1 << MUTEX_MOD_RDMA0 |
+		1 << MUTEX_MOD_COLOR0 | 1 << MUTEX_MOD_AAL |
+		1 << MUTEX_MOD_UFOE | 1 << MUTEX_MOD_PWM0 |
+		1 << MUTEX_MOD_OD),
+		mutex_base + DISP_REG_CONFIG_MUTEX_MOD(id));
+
+	writel(MUTEX_SOF_DSI0, mutex_base + DISP_REG_CONFIG_MUTEX_SOF(id));
+	writel(1, mutex_base + DISP_REG_CONFIG_MUTEX_EN(id));
+}
+
+void mediatek_ddp_main_path_setup(struct device *dev)
+{
+	struct ddp_context *ddp = dev_get_drvdata(dev);
+
+	disp_config_main_path_connection(ddp->config_regs);
+	disp_config_main_path_mutex(ddp->mutex_regs);
+}
+
+void mediatek_ddp_clock_on(struct device *dev)
+{
+	struct ddp_context *ddp = dev_get_drvdata(dev);
+	int ret;
+
+	/* disp_mtcmos */
+	ret = pm_runtime_get_sync(dev);
+	if (ret < 0)
+		DRM_ERROR("failed to get_sync(%d)\n", ret);
+
+	ret = clk_prepare_enable(ddp->mutex_disp_clk);
+	if (ret != 0)
+		DRM_ERROR("clk_prepare_enable(mutex_disp_clk) error!\n");
+}
+
+static int ddp_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct ddp_context *ddp;
+	struct resource *regs;
+	int ret;
+
+	if (!dev->of_node)
+		return -ENODEV;
+
+	ddp = devm_kzalloc(dev, sizeof(*ddp), GFP_KERNEL);
+	if (!ddp)
+		return -ENOMEM;
+
+	ddp->mutex_disp_clk = devm_clk_get(dev, "mutex_disp");
+	if (IS_ERR(ddp->mutex_disp_clk)) {
+		dev_err(dev, "ddp_probe: Get mutex_disp_clk fail.\n");
+		ret = PTR_ERR(ddp->mutex_disp_clk);
+		goto err;
+	}
+
+	regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	ddp->config_regs = devm_ioremap_resource(dev, regs);
+	if (IS_ERR(ddp->config_regs))
+		return PTR_ERR(ddp->config_regs);
+
+	regs = platform_get_resource(pdev, IORESOURCE_MEM, 1);
+	ddp->mutex_regs = devm_ioremap_resource(dev, regs);
+	if (IS_ERR(ddp->mutex_regs))
+		return PTR_ERR(ddp->mutex_regs);
+
+	platform_set_drvdata(pdev, ddp);
+
+	pm_runtime_enable(dev);
+
+	return 0;
+
+err:
+
+	return ret;
+}
+
+static int ddp_remove(struct platform_device *pdev)
+{
+	return 0;
+}
+
+static const struct of_device_id ddp_driver_dt_match[] = {
+	{ .compatible = "mediatek,mt8173-ddp" },
+	{},
+};
+MODULE_DEVICE_TABLE(of, ddp_driver_dt_match);
+
+struct platform_driver mediatek_ddp_driver = {
+	.probe		= ddp_probe,
+	.remove		= ddp_remove,
+	.driver		= {
+		.name	= "mediatek-ddp",
+		.owner	= THIS_MODULE,
+		.of_match_table = ddp_driver_dt_match,
+	},
+};
+
diff --git a/drivers/gpu/drm/mediatek/mediatek_drm_ddp.h b/drivers/gpu/drm/mediatek/mediatek_drm_ddp.h
new file mode 100644
index 0000000..07dd637
--- /dev/null
+++ b/drivers/gpu/drm/mediatek/mediatek_drm_ddp.h
@@ -0,0 +1,23 @@
+/*
+ * Copyright (c) 2015 MediaTek Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef _MEDIATEK_DRM_DDP_H_
+#define _MEDIATEK_DRM_DDP_H_
+
+void mediatek_ddp_main_path_setup(struct device *dev);
+
+void mediatek_ddp_clock_on(struct device *dev);
+
+
+#endif
+
diff --git a/drivers/gpu/drm/mediatek/mediatek_drm_ddp_comp.c b/drivers/gpu/drm/mediatek/mediatek_drm_ddp_comp.c
new file mode 100644
index 0000000..dd7ac83
--- /dev/null
+++ b/drivers/gpu/drm/mediatek/mediatek_drm_ddp_comp.c
@@ -0,0 +1,346 @@
+/*
+ * Copyright (c) 2015 MediaTek Inc.
+ * Authors:
+ *	YT Shen <yt.shen@mediatek.com>
+ *	CK Hu <ck.hu@mediatek.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <drm/drmP.h>
+#include <linux/clk.h>
+
+
+#define DISP_REG_OVL_INTEN                       0x0004
+#define DISP_REG_OVL_INTSTA                      0x0008
+#define DISP_REG_OVL_EN                          0x000C
+#define DISP_REG_OVL_RST                         0x0014
+#define DISP_REG_OVL_ROI_SIZE                    0x0020
+#define DISP_REG_OVL_ROI_BGCLR                   0x0028
+#define DISP_REG_OVL_SRC_CON                     0x002C
+#define DISP_REG_OVL_L0_CON                      0x0030
+#define DISP_REG_OVL_L0_SRCKEY                   0x0034
+#define DISP_REG_OVL_L0_SRC_SIZE                 0x0038
+#define DISP_REG_OVL_L0_OFFSET                   0x003C
+#define DISP_REG_OVL_L0_PITCH                    0x0044
+#define DISP_REG_OVL_L1_CON                      0x0050
+#define DISP_REG_OVL_L1_SRCKEY                   0x0054
+#define DISP_REG_OVL_L1_SRC_SIZE                 0x0058
+#define DISP_REG_OVL_L1_OFFSET                   0x005C
+#define DISP_REG_OVL_L1_PITCH                    0x0064
+#define DISP_REG_OVL_RDMA0_CTRL                  0x00C0
+#define DISP_REG_OVL_RDMA0_MEM_GMC_SETTING       0x00C8
+#define DISP_REG_OVL_RDMA1_CTRL                  0x00E0
+#define DISP_REG_OVL_RDMA1_MEM_GMC_SETTING       0x00E8
+#define DISP_REG_OVL_RDMA1_FIFO_CTRL             0x00F0
+#define DISP_REG_OVL_L0_ADDR                     0x0f40
+#define DISP_REG_OVL_L1_ADDR                     0x0f60
+
+#define DISP_REG_RDMA_INT_ENABLE          0x0000
+#define DISP_REG_RDMA_INT_STATUS          0x0004
+#define DISP_REG_RDMA_GLOBAL_CON          0x0010
+#define DISP_REG_RDMA_SIZE_CON_0          0x0014
+#define DISP_REG_RDMA_SIZE_CON_1          0x0018
+#define DISP_REG_RDMA_FIFO_CON            0x0040
+
+#define DISP_OD_EN                              0x000
+#define DISP_OD_INTEN                           0x008
+#define DISP_OD_INTS                            0x00C
+#define DISP_OD_CFG                             0x020
+#define DISP_OD_SIZE                            0x030
+
+#define DISP_REG_UFO_START			0x000
+
+#define DISP_COLOR_CFG_MAIN			0x400
+#define DISP_COLOR_START			0xC00
+
+enum DISPLAY_PATH {
+	PRIMARY_PATH = 0,
+	EXTERNAL_PATH = 1,
+};
+
+enum RDMA_MODE {
+	RDMA_MODE_DIRECT_LINK = 0,
+	RDMA_MODE_MEMORY = 1,
+};
+
+enum RDMA_OUTPUT_FORMAT {
+	RDMA_OUTPUT_FORMAT_ARGB = 0,
+	RDMA_OUTPUT_FORMAT_YUV444 = 1,
+};
+
+#define OVL_COLOR_BASE 30
+enum OVL_INPUT_FORMAT {
+	OVL_INFMT_RGB565 = 0,
+	OVL_INFMT_RGB888 = 1,
+	OVL_INFMT_RGBA8888 = 2,
+	OVL_INFMT_ARGB8888 = 3,
+	OVL_INFMT_UYVY = 4,
+	OVL_INFMT_YUYV = 5,
+	OVL_INFMT_UNKNOWN = 16,
+
+	OVL_INFMT_BGR565 = OVL_INFMT_RGB565 + OVL_COLOR_BASE,
+	OVL_INFMT_BGR888 = OVL_INFMT_RGB888 + OVL_COLOR_BASE,
+	OVL_INFMT_BGRA8888 = OVL_INFMT_RGBA8888 + OVL_COLOR_BASE,
+	OVL_INFMT_ABGR8888 = OVL_INFMT_ARGB8888 + OVL_COLOR_BASE,
+};
+
+enum {
+	OD_RELAY_MODE           = 0x1,
+};
+
+enum {
+	UFO_BYPASS              = 0x4,
+};
+
+enum {
+	COLOR_BYPASS_ALL        = (1UL<<7),
+	COLOR_SEQ_SEL           = (1UL<<13),
+};
+
+enum {
+	OVL_LAYER_SRC_DRAM      = 0,
+};
+
+
+static void mediatek_ovl_start(void __iomem *ovl_base)
+{
+	writel(0x01, ovl_base + DISP_REG_OVL_EN);
+}
+
+static void mediatek_ovl_roi(void __iomem *ovl_base,
+	unsigned int w, unsigned int h, unsigned int bg_color)
+{
+	writel(h << 16 | w, ovl_base + DISP_REG_OVL_ROI_SIZE);
+	writel(bg_color, ovl_base + DISP_REG_OVL_ROI_BGCLR);
+}
+
+void mediatek_ovl_layer_switch(void __iomem *ovl_base,
+	unsigned layer, bool en)
+{
+	u32 reg;
+
+	reg = readl(ovl_base + DISP_REG_OVL_SRC_CON);
+	if (en)
+		reg |= (1U<<layer);
+	else
+		reg &= ~(1U<<layer);
+
+	writel(reg, ovl_base + DISP_REG_OVL_SRC_CON);
+	writel(0x1, ovl_base + DISP_REG_OVL_RST);
+	writel(0x0, ovl_base + DISP_REG_OVL_RST);
+}
+
+static unsigned int ovl_fmt_convert(unsigned int fmt)
+{
+	switch (fmt) {
+	case DRM_FORMAT_RGB888:
+		return OVL_INFMT_RGB888;
+	case DRM_FORMAT_RGB565:
+		return OVL_INFMT_RGB565;
+	case DRM_FORMAT_ARGB8888:
+		return OVL_INFMT_ARGB8888;
+	case DRM_FORMAT_RGBA8888:
+		return OVL_INFMT_RGBA8888;
+	case DRM_FORMAT_BGR888:
+		return OVL_INFMT_BGR888;
+	case DRM_FORMAT_BGR565:
+		return OVL_INFMT_BGR565;
+	case DRM_FORMAT_ABGR8888:
+		return OVL_INFMT_ABGR8888;
+	case DRM_FORMAT_XRGB8888:
+	case DRM_FORMAT_BGRA8888:
+		return OVL_INFMT_BGRA8888;
+	case DRM_FORMAT_YUYV:
+		return OVL_INFMT_YUYV;
+	case DRM_FORMAT_UYVY:
+		return OVL_INFMT_UYVY;
+	default:
+		return OVL_INFMT_UNKNOWN;
+	}
+}
+
+void mediatek_ovl_layer_config(void __iomem *ovl_base, bool enabled,
+	unsigned int addr, unsigned int width, unsigned int height,
+	unsigned int pitch,	unsigned int format)
+{
+	unsigned int reg;
+	unsigned int dst_x = 0;
+	unsigned int dst_y = 0;
+	bool color_key_en = 1;
+	unsigned int color_key = 0xFF000000;
+	bool alpha_en = 0;
+	unsigned char alpha = 0x0;
+	unsigned int src_con, new_set;
+
+	unsigned int rgb_swap, bpp;
+	unsigned int fmt = ovl_fmt_convert(format);
+
+	if (fmt == OVL_INFMT_BGR888 || fmt == OVL_INFMT_BGR565 ||
+		fmt == OVL_INFMT_ABGR8888 || fmt == OVL_INFMT_BGRA8888) {
+		fmt -= OVL_COLOR_BASE;
+		rgb_swap = 1;
+	} else {
+		rgb_swap = 0;
+	}
+
+	switch (fmt) {
+	case OVL_INFMT_ARGB8888:
+	case OVL_INFMT_RGBA8888:
+		bpp = 4;
+		break;
+	case OVL_INFMT_RGB888:
+		bpp = 3;
+		break;
+	case OVL_INFMT_RGB565:
+	case OVL_INFMT_YUYV:
+	case OVL_INFMT_UYVY:
+		bpp = 2;
+		break;
+	default:
+		bpp = 1;
+	}
+
+	if (pitch == 0)
+		pitch = width * bpp;
+
+	src_con = readl(ovl_base + DISP_REG_OVL_SRC_CON);
+	if (enabled == true)
+		new_set = src_con | 0x1;
+	else
+		new_set = src_con & ~(0x1);
+
+	writel(0x1, ovl_base + DISP_REG_OVL_RST);
+	writel(0x0, ovl_base + DISP_REG_OVL_RST);
+
+	writel(new_set, ovl_base + DISP_REG_OVL_SRC_CON);
+
+	writel(0x00000001, ovl_base + DISP_REG_OVL_RDMA0_CTRL);
+	writel(0x40402020, ovl_base + DISP_REG_OVL_RDMA0_MEM_GMC_SETTING);
+
+	reg = color_key_en << 30 | OVL_LAYER_SRC_DRAM << 28 |
+		rgb_swap << 25 | fmt << 12 | alpha_en << 8 | alpha;
+	writel(reg, ovl_base + DISP_REG_OVL_L0_CON);
+	writel(color_key, ovl_base + DISP_REG_OVL_L0_SRCKEY);
+	writel(height << 16 | width, ovl_base + DISP_REG_OVL_L0_SRC_SIZE);
+	writel(dst_y << 16 | dst_x, ovl_base + DISP_REG_OVL_L0_OFFSET);
+	writel(addr, ovl_base + DISP_REG_OVL_L0_ADDR);
+	writel(pitch & 0xFFFF, ovl_base + DISP_REG_OVL_L0_PITCH);
+}
+
+static void mediatek_rdma_start(void __iomem *rdma_base)
+{
+	unsigned int reg;
+
+	writel(0x4, rdma_base + DISP_REG_RDMA_INT_ENABLE);
+	reg = readl(rdma_base + DISP_REG_RDMA_GLOBAL_CON);
+	reg |= 1;
+	writel(reg, rdma_base + DISP_REG_RDMA_GLOBAL_CON);
+}
+
+static void mediatek_rdma_config_direct_link(void __iomem *rdma_base,
+	unsigned width, unsigned height)
+{
+	unsigned int reg;
+	enum RDMA_MODE mode = RDMA_MODE_DIRECT_LINK;
+	enum RDMA_OUTPUT_FORMAT output_format = RDMA_OUTPUT_FORMAT_ARGB;
+
+	reg = readl(rdma_base + DISP_REG_RDMA_GLOBAL_CON);
+	if (mode == RDMA_MODE_DIRECT_LINK)
+		reg &= ~(0x2U);
+	writel(reg, rdma_base + DISP_REG_RDMA_GLOBAL_CON);
+
+	reg = readl(rdma_base + DISP_REG_RDMA_SIZE_CON_0);
+	if (output_format == RDMA_OUTPUT_FORMAT_ARGB)
+		reg &= ~(0x20000000U);
+	else
+		reg |= 0x20000000U;
+	writel(reg, rdma_base + DISP_REG_RDMA_SIZE_CON_0);
+
+	reg = readl(rdma_base + DISP_REG_RDMA_SIZE_CON_0);
+	reg = (reg & ~(0xFFFU)) | (width & 0xFFFU);
+	writel(reg, rdma_base + DISP_REG_RDMA_SIZE_CON_0);
+
+	reg = readl(rdma_base + DISP_REG_RDMA_SIZE_CON_1);
+	reg = (reg & ~(0xFFFFFU)) | (height & 0xFFFFFU);
+	writel(reg, rdma_base + DISP_REG_RDMA_SIZE_CON_1);
+
+	writel(0x80F00008, rdma_base + DISP_REG_RDMA_FIFO_CON);
+}
+
+void mediatek_od_enable_vblank(void __iomem *disp_base)
+{
+	writel(0x1, disp_base + DISP_OD_INTEN);
+}
+
+void mediatek_od_disable_vblank(void __iomem *disp_base)
+{
+	writel(0x0, disp_base + DISP_OD_INTEN);
+}
+
+void mediatek_od_clear_vblank(void __iomem *disp_base)
+{
+	writel(0x0, disp_base + DISP_OD_INTS);
+}
+
+static void mediatek_od_start(void __iomem *od_base, unsigned int w,
+	unsigned int h)
+{
+	writel(w << 16 | h, od_base + DISP_OD_SIZE);
+	writel(OD_RELAY_MODE, od_base + DISP_OD_CFG);
+	writel(1, od_base + DISP_OD_EN);
+}
+
+static void mediatek_ufoe_start(void __iomem *ufoe_base)
+{
+	writel(UFO_BYPASS, ufoe_base + DISP_REG_UFO_START);
+}
+
+static void mediatek_color_start(void __iomem *color_base)
+{
+	writel(COLOR_BYPASS_ALL | COLOR_SEQ_SEL,
+		color_base + DISP_COLOR_CFG_MAIN);
+	writel(0x1, color_base + DISP_COLOR_START);
+}
+
+void main_disp_path_power_on(void __iomem *ovl_base,
+	void __iomem *rdma_base,
+	void __iomem *color_base,
+	void __iomem *ufoe_base,
+	void __iomem *od_base)
+{
+	struct device_node *node;
+	unsigned int width, height;
+	int err;
+
+	node = of_find_compatible_node(NULL, NULL, "mediatek,mt8173-dsi");
+
+	err = of_property_read_u32(node, "mediatek,width", &width);
+	if (err < 0)
+		return;
+
+	err = of_property_read_u32(node, "mediatek,height", &height);
+	if (err < 0)
+		return;
+
+	width = ((width + 3)>>2)<<2;
+
+	mediatek_ovl_start(ovl_base);
+	mediatek_rdma_start(rdma_base);
+
+	mediatek_ovl_roi(ovl_base, width, height, 0x00000000);
+	mediatek_ovl_layer_switch(ovl_base, 0, 1);
+	mediatek_rdma_config_direct_link(rdma_base, width, height);
+	mediatek_od_start(od_base, width, height);
+	mediatek_ufoe_start(ufoe_base);
+	mediatek_color_start(color_base);
+}
+
+
diff --git a/drivers/gpu/drm/mediatek/mediatek_drm_ddp_comp.h b/drivers/gpu/drm/mediatek/mediatek_drm_ddp_comp.h
new file mode 100644
index 0000000..d3ed3e1
--- /dev/null
+++ b/drivers/gpu/drm/mediatek/mediatek_drm_ddp_comp.h
@@ -0,0 +1,33 @@
+/*
+ * Copyright (c) 2015 MediaTek Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef _MEDIATEK_DRM_DDP_COMP_H_
+#define _MEDIATEK_DRM_DDP_COMP_H_
+
+
+void mediatek_od_enable_vblank(void __iomem *drm_disp_base);
+void mediatek_od_disable_vblank(void __iomem *drm_disp_base);
+void mediatek_od_clear_vblank(void __iomem *drm_disp_base);
+void mediatek_ovl_layer_config(void __iomem *ovl_base, bool enabled,
+	unsigned int addr, unsigned int width, unsigned int height,
+	unsigned int pitch,	unsigned int format);
+
+void main_disp_path_power_on(void __iomem *ovl_base,
+	void __iomem *rdma_base, void __iomem *color_base,
+	void __iomem *ufoe_base, void __iomem *od_base);
+
+void mediatek_ovl_layer_switch(void __iomem *ovl_base,
+	unsigned layer, bool en);
+
+#endif
+
diff --git a/drivers/gpu/drm/mediatek/mediatek_drm_drv.c b/drivers/gpu/drm/mediatek/mediatek_drm_drv.c
new file mode 100644
index 0000000..dfd816f
--- /dev/null
+++ b/drivers/gpu/drm/mediatek/mediatek_drm_drv.c
@@ -0,0 +1,369 @@
+/*
+ * Copyright (c) 2015 MediaTek Inc.
+ * Author: YT SHEN <yt.shen@mediatek.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <drm/drmP.h>
+#include <drm/drm_gem.h>
+#include <drm/drm_crtc.h>
+#include <drm/drm_crtc_helper.h>
+#include <linux/of_platform.h>
+#include <linux/component.h>
+#include <linux/mtk-smi.h>
+#include <linux/pm_runtime.h>
+#include <linux/dma-iommu.h>
+
+#include "mediatek_drm_drv.h"
+#include "mediatek_drm_crtc.h"
+#include "mediatek_drm_fb.h"
+#include "mediatek_drm_gem.h"
+
+#include "drm/mediatek_drm.h"
+
+#define DRIVER_NAME "mediatek"
+#define DRIVER_DESC "Mediatek SoC DRM"
+#define DRIVER_DATE "20150513"
+#define DRIVER_MAJOR 1
+#define DRIVER_MINOR 0
+
+static struct drm_mode_config_funcs mediatek_drm_mode_config_funcs = {
+	.fb_create = mtk_drm_mode_fb_create,
+	.output_poll_changed = mtk_drm_mode_output_poll_changed,
+};
+
+static int mtk_drm_kms_init(struct drm_device *dev)
+{
+	struct device_node *node;
+	struct platform_device *pdev;
+	int err;
+
+	drm_mode_config_init(dev);
+
+	dev->mode_config.min_width = 640;
+	dev->mode_config.min_height = 480;
+
+	/*
+	 * set max width and height as default value(4096x4096).
+	 * this value would be used to check framebuffer size limitation
+	 * at drm_mode_addfb().
+	 */
+	dev->mode_config.max_width = 4096;
+	dev->mode_config.max_height = 4096;
+	dev->mode_config.funcs = &mediatek_drm_mode_config_funcs;
+
+	err = component_bind_all(dev->dev, dev);
+	if (err)
+		goto err_crtc;
+
+	/*
+	 * We don't use the drm_irq_install() helpers provided by the DRM
+	 * core, so we need to set this manually in order to allow the
+	 * DRM_IOCTL_WAIT_VBLANK to operate correctly.
+	 */
+	dev->irq_enabled = true;
+	err = drm_vblank_init(dev, MAX_CRTC);
+	if (err < 0)
+		goto err_crtc;
+
+	drm_kms_helper_poll_init(dev);
+
+	node = of_parse_phandle(dev->dev->of_node, "iommus", 0);
+	if (!node)
+		return 0;
+
+	pdev = of_find_device_by_node(node);
+	if (WARN_ON(!pdev)) {
+		of_node_put(node);
+		return -EINVAL;
+	}
+	err = iommu_dma_attach_device(dev->dev,
+			arch_get_dma_domain(&pdev->dev));
+	if (err)
+		DRM_ERROR("iommu_dma_attach_device fail %d\n", err);
+
+	node = of_parse_phandle(dev->dev->of_node, "larb", 0);
+	if (!node)
+		return 0;
+
+	pdev = of_find_device_by_node(node);
+	if (WARN_ON(!pdev)) {
+		of_node_put(node);
+		return -EINVAL;
+	}
+
+	err = mtk_smi_larb_get(&pdev->dev);
+	if (err)
+		DRM_ERROR("mtk_smi_larb_get fail %d\n", err);
+
+	node = of_parse_phandle(dev->dev->of_node, "larb", 1);
+	if (!node)
+		return 0;
+
+	pdev = of_find_device_by_node(node);
+	if (WARN_ON(!pdev)) {
+		of_node_put(node);
+		return -EINVAL;
+	}
+
+	err = mtk_smi_larb_get(&pdev->dev);
+	if (err)
+		DRM_ERROR("mtk_smi_larb_get fail %d\n", err);
+
+	mtk_fbdev_create(dev);
+
+	return 0;
+err_crtc:
+	drm_mode_config_cleanup(dev);
+
+	return err;
+}
+
+static int mtk_drm_load(struct drm_device *dev, unsigned long flags)
+{
+	struct mtk_drm_private *priv;
+
+	priv = devm_kzalloc(dev->dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	dev->dev_private = priv;
+	platform_set_drvdata(dev->platformdev, dev);
+
+	return mtk_drm_kms_init(dev);
+}
+
+static void mtk_drm_kms_deinit(struct drm_device *dev)
+{
+	drm_kms_helper_poll_fini(dev);
+
+	mtk_fbdev_destroy(dev);
+
+	drm_vblank_cleanup(dev);
+	drm_mode_config_cleanup(dev);
+
+	pm_runtime_disable(dev->dev);
+}
+
+static int mtk_drm_unload(struct drm_device *dev)
+{
+	mtk_drm_kms_deinit(dev);
+	dev->dev_private = NULL;
+
+	return 0;
+}
+
+static int mtk_drm_open(struct drm_device *drm, struct drm_file *filp)
+{
+	return 0;
+}
+
+static void mediatek_drm_preclose(struct drm_device *drm, struct drm_file *file)
+{
+}
+
+static void mediatek_drm_lastclose(struct drm_device *drm)
+{
+}
+
+static const struct vm_operations_struct mediatek_drm_gem_vm_ops = {
+	.open = drm_gem_vm_open,
+	.close = drm_gem_vm_close,
+};
+
+static const struct drm_ioctl_desc mtk_ioctls[] = {
+	DRM_IOCTL_DEF_DRV(MTK_GEM_CREATE, mediatek_gem_create_ioctl,
+			  DRM_UNLOCKED | DRM_AUTH),
+	DRM_IOCTL_DEF_DRV(MTK_GEM_MAP_OFFSET,
+			  mediatek_gem_map_offset_ioctl,
+			  DRM_UNLOCKED | DRM_AUTH),
+};
+
+static const struct file_operations mediatek_drm_fops = {
+	.owner = THIS_MODULE,
+	.open = drm_open,
+	.release = drm_release,
+	.unlocked_ioctl = drm_ioctl,
+	.mmap = mtk_drm_gem_mmap,
+	.poll = drm_poll,
+	.read = drm_read,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl = drm_compat_ioctl,
+#endif
+};
+
+static struct drm_driver mediatek_drm_driver = {
+	.driver_features = DRIVER_MODESET | DRIVER_GEM,
+	.load = mtk_drm_load,
+	.unload = mtk_drm_unload,
+	.open = mtk_drm_open,
+	.preclose = mediatek_drm_preclose,
+	.lastclose = mediatek_drm_lastclose,
+	.set_busid = drm_platform_set_busid,
+
+	.get_vblank_counter = drm_vblank_count,
+	.enable_vblank = mtk_drm_crtc_enable_vblank,
+	.disable_vblank = mtk_drm_crtc_disable_vblank,
+
+	.gem_free_object = mtk_drm_gem_free_object,
+	.gem_vm_ops = &mediatek_drm_gem_vm_ops,
+	.dumb_create = mtk_drm_gem_dumb_create,
+	.dumb_map_offset = mtk_drm_gem_dumb_map_offset,
+	.dumb_destroy = drm_gem_dumb_destroy,
+
+	.num_ioctls = 0,
+	.fops = &mediatek_drm_fops,
+
+	.set_busid = drm_platform_set_busid,
+
+	.name = DRIVER_NAME,
+	.desc = DRIVER_DESC,
+	.date = DRIVER_DATE,
+	.major = DRIVER_MAJOR,
+	.minor = DRIVER_MINOR,
+};
+
+static int compare_of(struct device *dev, void *data)
+{
+	return dev->of_node == data;
+}
+
+static int mtk_drm_add_components(struct device *master, struct master *m)
+{
+	struct device_node *np = master->of_node;
+	unsigned i;
+	int ret;
+
+	for (i = 0; ; i++) {
+		struct device_node *node;
+
+		node = of_parse_phandle(np, "connectors", i);
+		if (!node)
+			break;
+
+		ret = component_master_add_child(m, compare_of, node);
+		of_node_put(node);
+		if (ret) {
+			dev_err(master, "component_master_add_child %s fail.\n",
+				node->full_name);
+			return ret;
+		}
+	}
+
+	for (i = 0; ; i++) {
+		struct device_node *node;
+
+		node = of_parse_phandle(np, "crtcs", i);
+		if (!node)
+			break;
+
+		ret = component_master_add_child(m, compare_of, node);
+		of_node_put(node);
+		if (ret) {
+			dev_err(master, "component_master_add_child %s fail.\n",
+				node->full_name);
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
+static int mtk_drm_bind(struct device *dev)
+{
+	return drm_platform_init(&mediatek_drm_driver, to_platform_device(dev));
+}
+
+static void mtk_drm_unbind(struct device *dev)
+{
+	drm_put_dev(platform_get_drvdata(to_platform_device(dev)));
+}
+
+static const struct component_master_ops mtk_drm_ops = {
+	.add_components	= mtk_drm_add_components,
+	.bind		= mtk_drm_bind,
+	.unbind		= mtk_drm_unbind,
+};
+
+static int mtk_drm_probe(struct platform_device *pdev)
+{
+	component_master_add(&pdev->dev, &mtk_drm_ops);
+
+	return 0;
+}
+
+static int mtk_drm_remove(struct platform_device *pdev)
+{
+	drm_put_dev(platform_get_drvdata(pdev));
+
+	return 0;
+}
+
+static const struct of_device_id mediatek_drm_of_ids[] = {
+	{ .compatible = "mediatek,mt8173-drm", },
+	{ }
+};
+
+static struct platform_driver mediatek_drm_platform_driver = {
+	.probe	= mtk_drm_probe,
+	.remove	= mtk_drm_remove,
+	.driver	= {
+		.owner	= THIS_MODULE,
+		.name	= "mediatek-drm",
+		.of_match_table = mediatek_drm_of_ids,
+		/*.pm     = &mtk_pm_ops, */
+	},
+	/* .id_table = mtk_drm_platform_ids, */
+};
+
+static int mediatek_drm_init(void)
+{
+	int err;
+
+	err = platform_driver_register(&mediatek_ddp_driver);
+	if (err < 0) {
+		DRM_DEBUG_DRIVER("register ddp driver fail.\n");
+		return err;
+	}
+
+	err = platform_driver_register(&mtk_dsi_driver);
+	if (err < 0) {
+		DRM_DEBUG_DRIVER("register dsi driver fail.\n");
+		return err;
+	}
+
+	err = platform_driver_register(&mediatek_crtc_main_driver);
+	if (err < 0) {
+		DRM_DEBUG_DRIVER("register crtc_main driver fail.\n");
+		return err;
+	}
+
+	err = platform_driver_register(&mediatek_drm_platform_driver);
+	if (err < 0)
+		return err;
+
+	return 0;
+}
+
+static void mediatek_drm_exit(void)
+{
+	platform_driver_unregister(&mediatek_drm_platform_driver);
+	platform_driver_unregister(&mtk_dsi_driver);
+}
+
+late_initcall(mediatek_drm_init);
+module_exit(mediatek_drm_exit);
+
+MODULE_AUTHOR("YT SHEN <yt.shen@mediatek.com>");
+MODULE_DESCRIPTION("Mediatek SoC DRM driver");
+MODULE_LICENSE("GPL");
+
+
diff --git a/drivers/gpu/drm/mediatek/mediatek_drm_drv.h b/drivers/gpu/drm/mediatek/mediatek_drm_drv.h
new file mode 100644
index 0000000..10ee4c4
--- /dev/null
+++ b/drivers/gpu/drm/mediatek/mediatek_drm_drv.h
@@ -0,0 +1,37 @@
+/*
+ * Copyright (c) 2015 MediaTek Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef _MEDIATEK_DRM_DRV_H_
+#define _MEDIATEK_DRM_DRV_H_
+
+#define MAX_CRTC	2
+#define MAX_PLANE	4
+
+extern struct platform_driver mediatek_ddp_driver;
+extern struct platform_driver mtk_dsi_driver;
+extern struct platform_driver mediatek_crtc_main_driver;
+
+struct mtk_drm_private {
+	struct drm_fb_helper *fb_helper;
+
+	/*
+	 * created crtc object would be contained at this array and
+	 * this array is used to be aware of which crtc did it request vblank.
+	 */
+	struct drm_crtc *crtc[MAX_CRTC];
+	unsigned int pipe;
+};
+
+
+#endif
+
diff --git a/drivers/gpu/drm/mediatek/mediatek_drm_dsi.c b/drivers/gpu/drm/mediatek/mediatek_drm_dsi.c
new file mode 100644
index 0000000..199ff9d
--- /dev/null
+++ b/drivers/gpu/drm/mediatek/mediatek_drm_dsi.c
@@ -0,0 +1,1333 @@
+/*
+ * Copyright (c) 2015 MediaTek Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <drm/drmP.h>
+#include <drm/drm_gem.h>
+#include <drm/drm_crtc_helper.h>
+
+#include <linux/clk.h>
+#include <linux/debugfs.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
+#include <linux/reset.h>
+
+#include <linux/of_gpio.h>
+#include <linux/gpio.h>
+
+#include <linux/gpio/consumer.h>
+#include <linux/module.h>
+#include <linux/of_platform.h>
+#include <linux/of_graph.h>
+#include <linux/component.h>
+
+#include <linux/regulator/consumer.h>
+
+#include <drm/drm_mipi_dsi.h>
+#include <drm/drm_panel.h>
+
+#include <video/mipi_display.h>
+#include <video/videomode.h>
+
+#include "mediatek_drm_drv.h"
+#include "mediatek_drm_crtc.h"
+
+#include "mediatek_drm_ddp.h"
+
+#include "mediatek_drm_gem.h"
+#include "mediatek_drm_dsi.h"
+
+
+#define DSI_VIDEO_FIFO_DEPTH (1920 / 4)
+#define DSI_HOST_FIFO_DEPTH 64
+
+
+#define DSI_START		0x00
+
+#define	DSI_CON_CTRL	0x10
+	#define DSI_RESET		(1)
+
+#define DSI_MODE_CTRL	0x14
+	#define  MODE		2
+		#define CMD_MODE                  0
+		#define SYNC_PULSE_MODE    1
+		#define SYNC_EVENT_MODE    2
+		#define BURST_MODE              3
+	#define  FRM_MODE    (1<<16)
+	#define  MIX_MODE     (1<<17)
+
+#define DSI_TXRX_CTRL	0x18
+	#define VC_NUM	(2<<0)
+	#define LANE_NUM	(0xf<<2)
+	#define DIS_EOT		(1<<6)
+	#define NULL_EN		(1<<7)
+	#define TE_FREERUN		(1<<8)
+	#define EXT_TE_EN		(1<<9)
+	#define EXT_TE_EDGE		(1<<10)
+	#define MAX_RTN_SIZE		(0xf<<12)
+	#define HSTX_CKLP_EN		(1<<16)
+
+#define DSI_PSCTRL		0x1c
+	#define DSI_PS_WC		0x3fff
+	#define DSI_PS_SEL	 (2<<16)
+		#define PACKED_PS_16BIT_RGB565		(0<<16)
+		#define LOOSELY_PS_18BIT_RGB666		(1<<16)
+		#define PACKED_PS_18BIT_RGB666		(2<<16)
+		#define PACKED_PS_24BIT_RGB888		(3<<16)
+
+#define DSI_VSA_NL		0x20
+#define DSI_VBP_NL		0x24
+#define DSI_VFP_NL		0x28
+
+#define DSI_VACT_NL		0x2C
+
+#define DSI_HSA_WC		0x50
+#define DSI_HBP_WC		0x54
+#define DSI_HFP_WC		0x58
+
+#define	DSI_HSTX_CKL_WC	0x64
+
+#define DSI_PHY_LCCON	0x104
+	#define LC_HS_TX_EN					(1)
+	#define LC_ULPM_EN					(1<<1)
+	#define LC_WAKEUP_EN				(1<<2)
+
+#define DSI_PHY_LD0CON	0x108
+	#define LD0_HS_TX_EN				(1)
+	#define LD0_ULPM_EN					(1<<1)
+	#define LD0_WAKEUP_EN				(1<<2)
+
+#define	DSI_PHY_TIMECON0			0x0110
+	#define LPX			(0xff<<0)
+	#define HS_PRPR		(0xff<<8)
+	#define HS_ZERO		(0xff<<16)
+	#define HS_TRAIL		(0xff<<24)
+
+#define	DSI_PHY_TIMECON1			0x0114
+	#define TA_GO			(0xff<<0)
+	#define TA_SURE			(0xff<<8)
+	#define TA_GET			(0xff<<16)
+	#define DA_HS_EXIT		(0xff<<24)
+
+#define	DSI_PHY_TIMECON2			0x0118
+	#define CONT_DET		(0xff<<0)
+	#define CLK_ZERO		(0xff<<16)
+	#define CLK_TRAIL		(0xff<<24)
+
+#define	DSI_PHY_TIMECON3			0x011c
+	#define CLK_HS_PRPR		(0xff<<0)
+	#define CLK_HS_POST		(0xff<<8)
+	#define CLK_HS_EXIT		(0xff<<16)
+
+#define		MIPITX_DSI0_CON			0x00
+    #define RG_DSI0_LDOCORE_EN					(1)
+    #define RG_DSI0_CKG_LDOOUT_EN				(1<<1)
+    #define RG_DSI0_BCLK_SEL					(3<<2)
+    #define RG_DSI0_LD_IDX_SEL					(7<<4)
+    #define RG_DSI0_PHYCLK_SEL					(2<<8)
+    #define RG_DSI0_DSICLK_FREQ_SEL				(1<<10)
+    #define RG_DSI0_LPTX_CLMP_EN				(1<<11)
+
+#define		MIPITX_DSI0_CLOCK_LANE	0x04
+    #define RG_DSI0_LNTC_LDOOUT_EN				(1)
+    #define RG_DSI0_LNTC_CKLANE_EN				(1<<1)
+    #define RG_DSI0_LNTC_LPTX_IPLUS1			(1<<2)
+    #define RG_DSI0_LNTC_LPTX_IPLUS2			(1<<3)
+    #define RG_DSI0_LNTC_LPTX_IMINUS			(1<<4)
+    #define RG_DSI0_LNTC_LPCD_IPLUS				(1<<5)
+    #define RG_DSI0_LNTC_LPCD_IMLUS				(1<<6)
+    #define RG_DSI0_LNTC_RT_CODE				(0xf<<8)
+
+#define		MIPITX_DSI0_DATA_LANE0	0x08
+    #define RG_DSI0_LNT0_LDOOUT_EN				(1)
+    #define RG_DSI0_LNT0_CKLANE_EN				(1<<1)
+    #define RG_DSI0_LNT0_LPTX_IPLUS1			(1<<2)
+    #define RG_DSI0_LNT0_LPTX_IPLUS2			(1<<3)
+    #define RG_DSI0_LNT0_LPTX_IMINUS			(1<<4)
+    #define RG_DSI0_LNT0_LPCD_IPLUS				(1<<5)
+    #define RG_DSI0_LNT0_LPCD_IMINUS			(1<<6)
+    #define RG_DSI0_LNT0_RT_CODE				(0xf<<8)
+
+#define		MIPITX_DSI0_DATA_LANE1	0x0c
+    #define RG_DSI0_LNT1_LDOOUT_EN				(1)
+	#define RG_DSI0_LNT1_CKLANE_EN				(1<<1)
+	#define RG_DSI0_LNT1_LPTX_IPLUS1			(1<<2)
+	#define RG_DSI0_LNT1_LPTX_IPLUS2			(1<<3)
+	#define RG_DSI0_LNT1_LPTX_IMINUS			(1<<4)
+	#define RG_DSI0_LNT1_LPCD_IPLUS				(1<<5)
+	#define RG_DSI0_LNT1_LPCD_IMINUS			(1<<6)
+	#define RG_DSI0_LNT1_RT_CODE				(0xf<<8)
+
+#define		MIPITX_DSI0_DATA_LANE2	0x10
+    #define RG_DSI0_LNT2_LDOOUT_EN				(1)
+	#define RG_DSI0_LNT2_CKLANE_EN				(1<<1)
+	#define RG_DSI0_LNT2_LPTX_IPLUS1			(1<<2)
+	#define RG_DSI0_LNT2_LPTX_IPLUS2			(1<<3)
+	#define RG_DSI0_LNT2_LPTX_IMINUS			(1<<4)
+	#define RG_DSI0_LNT2_LPCD_IPLUS				(1<<5)
+	#define RG_DSI0_LNT2_LPCD_IMINUS			(1<<6)
+	#define RG_DSI0_LNT2_RT_CODE				(0xf<<8)
+
+#define		MIPITX_DSI0_DATA_LANE3	0x14
+	#define RG_DSI0_LNT3_LDOOUT_EN				(1)
+	#define RG_DSI0_LNT3_CKLANE_EN				(1<<1)
+	#define RG_DSI0_LNT3_LPTX_IPLUS1			(1<<2)
+	#define RG_DSI0_LNT3_LPTX_IPLUS2			(1<<3)
+	#define RG_DSI0_LNT3_LPTX_IMINUS			(1<<4)
+	#define RG_DSI0_LNT3_LPCD_IPLUS				(1<<5)
+	#define RG_DSI0_LNT3_LPCD_IMINUS			(1<<6)
+	#define RG_DSI0_LNT3_RT_CODE				(0xf<<8)
+
+#define		MIPITX_DSI_TOP_CON	0x40
+	#define RG_DSI_LNT_INTR_EN			(1)
+	#define RG_DSI_LNT_HS_BIAS_EN			(1<<1)
+	#define RG_DSI_LNT_IMP_CAL_EN			(1<<2)
+	#define RG_DSI_LNT_TESTMODE_EN		(1<<3)
+	#define RG_DSI_LNT_IMP_CAL_CODE		(0xf<<4)
+	#define RG_DSI_LNT_AIO_SEL				(7<<8)
+	#define RG_DSI_PAD_TIE_LOW_EN			(1<<11)
+	#define RG_DSI_DEBUG_INPUT_EN			(1<<12)
+	#define RG_DSI_PRESERVE			       (7<<13)
+
+#define		MIPITX_DSI_BG_CON		0x44
+	#define RG_DSI_BG_CORE_EN		1
+	#define RG_DSI_BG_CKEN			(1<<1)
+	#define RG_DSI_BG_DIV			(0x3<<2)
+	#define RG_DSI_BG_FAST_CHARGE		(1<<4)
+	#define RG_DSI_V12_SEL			 (7<<5)
+	#define RG_DSI_V10_SEL			 (7<<8)
+	#define RG_DSI_V072_SEL			 (7<<11)
+	#define RG_DSI_V04_SEL			 (7<<14)
+	#define RG_DSI_V032_SEL			 (7<<17)
+	#define RG_DSI_V02_SEL			 (7<<20)
+	#define rsv_23					 (1<<)
+	#define RG_DSI_BG_R1_TRIM		 (0xf<<24)
+	#define RG_DSI_BG_R2_TRIM		 (0xf<<28)
+
+#define		MIPITX_DSI_PLL_CON0		0x50
+    #define RG_DSI0_MPPLL_PLL_EN			(1<<0)
+    #define RG_DSI0_MPPLL_PREDIV			(3<<1)
+    #define RG_DSI0_MPPLL_TXDIV0			(3<<3)
+    #define RG_DSI0_MPPLL_TXDIV1			(3<<5)
+    #define RG_DSI0_MPPLL_POSDIV		(7<<7)
+    #define RG_DSI0_MPPLL_MONVC_EN		(1<<10)
+    #define RG_DSI0_MPPLL_MONREF_EN		(1<<11)
+	#define RG_DSI0_MPPLL_VOD_EN		(1<<12)
+
+#define		MIPITX_DSI_PLL_CON1		0x54
+    #define RG_DSI0_MPPLL_SDM_FRA_EN			(1)
+    #define RG_DSI0_MPPLL_SDM_SSC_PH_INIT			(1<<1)
+    #define RG_DSI0_MPPLL_SDM_SSC_EN			(1<<2)
+    #define RG_DSI0_MPPLL_SDM_SSC_PRD			(0xffff<<16)
+
+#define		MIPITX_DSI_PLL_CON2	0x58
+
+#define		MIPITX_DSI_PLL_PWR		0x68
+	#define RG_DSI_MPPLL_SDM_PWR_ON			(1<<0)
+	#define RG_DSI_MPPLL_SDM_ISO_EN			(1<<1)
+	#define RG_DSI_MPPLL_SDM_PWR_ACK		(1<<8)
+
+#define		MIPITX_DSI_SW_CTRL		0x80
+	#define SW_CTRL_EN		(1<<0)
+
+#define		MIPITX_DSI_SW_CTRL_CON0	0x84
+    #define SW_LNTC_LPTX_PRE_OE		(1<<0)
+    #define SW_LNTC_LPTX_OE			(1<<1)
+    #define SW_LNTC_LPTX_P			(1<<2)
+    #define SW_LNTC_LPTX_N			(1<<3)
+    #define SW_LNTC_HSTX_PRE_OE		(1<<4)
+    #define SW_LNTC_HSTX_OE			(1<<5)
+    #define SW_LNTC_HSTX_ZEROCLK	(1<<6)
+    #define SW_LNT0_LPTX_PRE_OE		(1<<7)
+    #define SW_LNT0_LPTX_OE			(1<<8)
+    #define SW_LNT0_LPTX_P			(1<<9)
+    #define SW_LNT0_LPTX_N			(1<<10)
+    #define SW_LNT0_HSTX_PRE_OE		(1<<11)
+    #define SW_LNT0_HSTX_OE			(1<<12)
+    #define SW_LNT0_LPRX_EN			(1<<13)
+    #define SW_LNT1_LPTX_PRE_OE		(1<<14)
+    #define SW_LNT1_LPTX_OE			(1<<15)
+    #define SW_LNT1_LPTX_P			(1<<16)
+    #define SW_LNT1_LPTX_N			(1<<17)
+    #define SW_LNT1_HSTX_PRE_OE		(1<<18)
+    #define SW_LNT1_HSTX_OE			(1<<19)
+    #define SW_LNT2_LPTX_PRE_OE		(1<<20)
+    #define SW_LNT2_LPTX_OE			(1<<21)
+    #define SW_LNT2_LPTX_P			(1<<22)
+    #define SW_LNT2_LPTX_N			(1<<23)
+    #define SW_LNT2_HSTX_PRE_OE		(1<<24)
+    #define SW_LNT2_HSTX_OE			(1<<25)
+
+#define NS_TO_CYCLE(n, c)    ((n) / c + (((n) % c) ? 1 : 0))
+
+
+static inline unsigned long mtk_dsi_readl(struct mtk_dsi *dsi,
+	unsigned long reg)
+{
+	return readl(dsi->dsi_reg_base + (reg << 2));
+}
+
+static inline void mtk_dsi_writel(struct mtk_dsi *dsi, unsigned long value,
+				    unsigned long reg)
+{
+	writel(value, dsi->dsi_reg_base + (reg << 2));
+}
+
+static int mtk_dsi_of_read_u32(const struct device_node *np,
+				  const char *propname, u32 *out_value)
+{
+	int ret = of_property_read_u32(np, propname, out_value);
+
+	if (ret < 0)
+		DRM_ERROR("%s: failed to get '%s' property\n", np->full_name,
+		       propname);
+
+	return ret;
+}
+
+static void dsi_phy_clk_switch_off(struct mtk_dsi *dsi)
+{
+	u32 tmp_reg;
+
+	tmp_reg = readl(dsi->dsi_tx_reg_base + MIPITX_DSI_SW_CTRL_CON0);
+
+	tmp_reg = tmp_reg  | (SW_LNTC_LPTX_PRE_OE | SW_LNTC_LPTX_OE |
+		SW_LNTC_HSTX_PRE_OE | SW_LNTC_HSTX_OE |
+		SW_LNT0_LPTX_PRE_OE | SW_LNT0_LPTX_OE |
+		SW_LNT0_HSTX_PRE_OE | SW_LNT0_HSTX_OE |
+		SW_LNT1_LPTX_PRE_OE | SW_LNT1_LPTX_OE |
+		SW_LNT1_HSTX_PRE_OE | SW_LNT1_HSTX_OE |
+		SW_LNT2_LPTX_PRE_OE | SW_LNT2_LPTX_OE |
+		SW_LNT2_HSTX_PRE_OE | SW_LNT2_HSTX_OE);
+	writel(tmp_reg, dsi->dsi_tx_reg_base + MIPITX_DSI_SW_CTRL_CON0);
+
+
+
+	tmp_reg = readl(dsi->dsi_tx_reg_base + MIPITX_DSI_SW_CTRL);
+	tmp_reg = (tmp_reg | SW_CTRL_EN);
+	writel(tmp_reg, dsi->dsi_tx_reg_base + MIPITX_DSI_SW_CTRL);
+
+
+	tmp_reg = readl(dsi->dsi_tx_reg_base + MIPITX_DSI_PLL_CON0);
+	tmp_reg = (tmp_reg & (~RG_DSI0_MPPLL_PLL_EN));
+	writel(tmp_reg, dsi->dsi_tx_reg_base + MIPITX_DSI_PLL_CON0);
+
+
+	udelay(100);
+
+	tmp_reg = readl(dsi->dsi_tx_reg_base + MIPITX_DSI_TOP_CON);
+	tmp_reg = (tmp_reg & (~(RG_DSI_LNT_HS_BIAS_EN |
+		RG_DSI_LNT_IMP_CAL_EN |
+		RG_DSI_LNT_TESTMODE_EN)));
+	writel(tmp_reg, dsi->dsi_tx_reg_base + MIPITX_DSI_TOP_CON);
+
+	tmp_reg = readl(dsi->dsi_tx_reg_base + MIPITX_DSI0_CLOCK_LANE);
+	tmp_reg = tmp_reg & (~RG_DSI0_LNTC_LDOOUT_EN);
+	writel(tmp_reg, dsi->dsi_tx_reg_base + MIPITX_DSI0_CLOCK_LANE);
+
+	tmp_reg = readl(dsi->dsi_tx_reg_base + MIPITX_DSI0_DATA_LANE0);
+	tmp_reg = tmp_reg & (~RG_DSI0_LNT0_LDOOUT_EN);
+	writel(tmp_reg, dsi->dsi_tx_reg_base + MIPITX_DSI0_DATA_LANE0);
+
+	tmp_reg = readl(dsi->dsi_tx_reg_base + MIPITX_DSI0_DATA_LANE1);
+	tmp_reg = tmp_reg & (~RG_DSI0_LNT1_LDOOUT_EN);
+	writel(tmp_reg, dsi->dsi_tx_reg_base + MIPITX_DSI0_DATA_LANE1);
+
+	tmp_reg = readl(dsi->dsi_tx_reg_base + MIPITX_DSI0_DATA_LANE2);
+	tmp_reg = tmp_reg & (~RG_DSI0_LNT2_LDOOUT_EN);
+	writel(tmp_reg, dsi->dsi_tx_reg_base + MIPITX_DSI0_DATA_LANE2);
+
+	tmp_reg = readl(dsi->dsi_tx_reg_base + MIPITX_DSI0_DATA_LANE3);
+	tmp_reg = tmp_reg & (~RG_DSI0_LNT3_LDOOUT_EN);
+	writel(tmp_reg, dsi->dsi_tx_reg_base + MIPITX_DSI0_DATA_LANE3);
+
+
+	udelay(100);
+
+	tmp_reg = readl(dsi->dsi_tx_reg_base + MIPITX_DSI0_CON);
+	tmp_reg = tmp_reg & (~(RG_DSI0_CKG_LDOOUT_EN |
+		RG_DSI0_LDOCORE_EN));
+	writel(tmp_reg, dsi->dsi_tx_reg_base + MIPITX_DSI0_CON);
+
+	tmp_reg = readl(dsi->dsi_tx_reg_base + MIPITX_DSI_BG_CON);
+	tmp_reg = tmp_reg & (~(RG_DSI_BG_CKEN | RG_DSI_BG_CORE_EN));
+	writel(tmp_reg, dsi->dsi_tx_reg_base + MIPITX_DSI_BG_CON);
+
+
+	udelay(100);
+
+	tmp_reg = readl(dsi->dsi_tx_reg_base + MIPITX_DSI_PLL_CON0);
+	tmp_reg = (tmp_reg & (~RG_DSI0_MPPLL_PLL_EN));
+	writel(tmp_reg, dsi->dsi_tx_reg_base + MIPITX_DSI_PLL_CON0);
+}
+
+static void dsi_phy_clk_setting(struct mtk_dsi *dsi)
+{
+	unsigned int data_Rate = dsi->pll_clk_rate * 2;
+	unsigned int txdiv = 0;
+	unsigned int txdiv0 = 0;
+	unsigned int txdiv1 = 0;
+	unsigned int pcw = 0;
+	u32 reg;
+	u32 temp;
+
+	reg = readl(dsi->dsi_tx_reg_base + MIPITX_DSI_BG_CON);
+	reg = (reg & (~RG_DSI_V032_SEL)) | (4<<17);
+	reg = (reg & (~RG_DSI_V04_SEL)) | (4<<14);
+	reg = (reg & (~RG_DSI_V072_SEL)) | (4<<11);
+	reg = (reg & (~RG_DSI_V10_SEL)) | (4<<8);
+	reg = (reg & (~RG_DSI_V12_SEL)) | (4<<5);
+	reg = (reg & (~RG_DSI_BG_CKEN)) | (1<<1);
+	reg = (reg & (~RG_DSI_BG_CORE_EN)) | (1);
+	writel(reg, dsi->dsi_tx_reg_base + MIPITX_DSI_BG_CON);
+
+	udelay(1000);
+
+	reg = readl(dsi->dsi_tx_reg_base + MIPITX_DSI_TOP_CON);
+	reg = (reg & (~RG_DSI_LNT_IMP_CAL_CODE)) | (8<<4);
+	reg = (reg & (~RG_DSI_LNT_HS_BIAS_EN)) | (1<<1);
+	writel(reg, dsi->dsi_tx_reg_base + MIPITX_DSI_TOP_CON);
+
+	reg = readl(dsi->dsi_tx_reg_base + MIPITX_DSI0_CON);
+	reg = (reg & (~RG_DSI0_CKG_LDOOUT_EN)) | (1<<1);
+	reg = (reg & (~RG_DSI0_LDOCORE_EN)) | (1);
+	writel(reg, dsi->dsi_tx_reg_base + MIPITX_DSI0_CON);
+
+	reg = readl(dsi->dsi_tx_reg_base + MIPITX_DSI_PLL_PWR);
+	reg = (reg & (~RG_DSI_MPPLL_SDM_PWR_ON)) | (1<<0);
+	reg = (reg & (~RG_DSI_MPPLL_SDM_ISO_EN));
+	writel(reg, dsi->dsi_tx_reg_base + MIPITX_DSI_PLL_PWR);
+
+	reg = readl(dsi->dsi_tx_reg_base + MIPITX_DSI_PLL_CON0);
+	reg = (reg & (~RG_DSI0_MPPLL_PLL_EN));
+	writel(reg, dsi->dsi_tx_reg_base + MIPITX_DSI_PLL_CON0);
+
+	udelay(1000);
+
+	if (data_Rate > 1250) {
+		txdiv = 1;
+		txdiv0 = 0;
+		txdiv1 = 0;
+	} else if (data_Rate >= 500) {
+		txdiv = 1;
+		txdiv0 = 0;
+		txdiv1 = 0;
+	} else if (data_Rate >= 250) {
+		txdiv = 2;
+		txdiv0 = 1;
+		txdiv1 = 0;
+	} else if (data_Rate >= 125) {
+		txdiv = 4;
+		txdiv0 = 2;
+		txdiv1 = 0;
+	} else if (data_Rate > 62) {
+		txdiv = 8;
+		txdiv0 = 2;
+		txdiv1 = 1;
+	} else if (data_Rate >= 50) {
+		txdiv = 16;
+		txdiv0 = 2;
+		txdiv1 = 2;
+	} else {
+	}
+
+	reg = readl(dsi->dsi_tx_reg_base + MIPITX_DSI_PLL_CON0);
+
+	switch (txdiv) {
+	case 1:
+		reg = (reg & (~RG_DSI0_MPPLL_TXDIV0)) | (0<<3);
+		reg = (reg & (~RG_DSI0_MPPLL_TXDIV1)) | (0<<5);
+
+		break;
+	case 2:
+		reg = (reg & (~RG_DSI0_MPPLL_TXDIV0)) | (1<<3);
+		reg = (reg & (~RG_DSI0_MPPLL_TXDIV1)) | (0<<5);
+		break;
+	case 4:
+		reg = (reg & (~RG_DSI0_MPPLL_TXDIV0)) | (2<<3);
+		reg = (reg & (~RG_DSI0_MPPLL_TXDIV1)) | (0<<5);
+		break;
+	case 8:
+		reg = (reg & (~RG_DSI0_MPPLL_TXDIV0)) | (2<<3);
+		reg = (reg & (~RG_DSI0_MPPLL_TXDIV1)) | (1<<5);
+		break;
+	case 16:
+		reg = (reg & (~RG_DSI0_MPPLL_TXDIV0)) | (2<<3);
+		reg = (reg & (~RG_DSI0_MPPLL_TXDIV1)) | (2<<5);
+		break;
+
+	default:
+		break;
+	}
+	reg = (reg & (~RG_DSI0_MPPLL_PREDIV));
+	writel(reg, dsi->dsi_tx_reg_base + MIPITX_DSI_PLL_CON0);
+
+	pcw = data_Rate * txdiv / 13;
+	temp = data_Rate * txdiv % 13;
+	reg = ((pcw & 0x7f)<<24) + (((256 * temp / 13) & 0xff)<<16)
+		+ (((256 * (256 * temp % 13)/13) & 0xff)<<8)
+		+ ((256 * (256 * (256 * temp % 13) % 13) / 13) & 0xff);
+	writel(reg, dsi->dsi_tx_reg_base + MIPITX_DSI_PLL_CON2);
+
+	reg = readl(dsi->dsi_tx_reg_base + MIPITX_DSI_PLL_CON1);
+	reg = (reg & (~RG_DSI0_MPPLL_SDM_FRA_EN)) | (1<<0);
+	writel(reg, dsi->dsi_tx_reg_base + MIPITX_DSI_PLL_CON1);
+
+	reg = readl(dsi->dsi_tx_reg_base + MIPITX_DSI0_CLOCK_LANE);
+	reg = (reg & (~RG_DSI0_LNTC_LDOOUT_EN)) | (1<<0);
+	writel(reg, dsi->dsi_tx_reg_base + MIPITX_DSI0_CLOCK_LANE);
+
+	reg = readl(dsi->dsi_tx_reg_base + MIPITX_DSI0_DATA_LANE0);
+	reg = (reg & (~RG_DSI0_LNT0_LDOOUT_EN)) | (1<<0);
+	writel(reg, dsi->dsi_tx_reg_base + MIPITX_DSI0_DATA_LANE0);
+
+	reg = readl(dsi->dsi_tx_reg_base + MIPITX_DSI0_DATA_LANE1);
+	reg = (reg & (~RG_DSI0_LNT1_LDOOUT_EN)) | (1<<0);
+	writel(reg, dsi->dsi_tx_reg_base + MIPITX_DSI0_DATA_LANE1);
+
+	reg = readl(dsi->dsi_tx_reg_base + MIPITX_DSI0_DATA_LANE2);
+	reg = (reg & (~RG_DSI0_LNT2_LDOOUT_EN)) | (1<<0);
+	writel(reg, dsi->dsi_tx_reg_base + MIPITX_DSI0_DATA_LANE2);
+
+	reg = readl(dsi->dsi_tx_reg_base + MIPITX_DSI0_DATA_LANE3);
+	reg = (reg & (~RG_DSI0_LNT3_LDOOUT_EN)) | (1<<0);
+	writel(reg, dsi->dsi_tx_reg_base + MIPITX_DSI0_DATA_LANE3);
+
+	reg = readl(dsi->dsi_tx_reg_base + MIPITX_DSI_PLL_CON0);
+	reg = (reg & (~RG_DSI0_MPPLL_PLL_EN)) | (1<<0);
+	writel(reg, dsi->dsi_tx_reg_base + MIPITX_DSI_PLL_CON0);
+
+	udelay(1000);
+	reg = readl(dsi->dsi_tx_reg_base + MIPITX_DSI_PLL_CON1);
+	reg = (reg & (~RG_DSI0_MPPLL_SDM_SSC_EN));
+	writel(reg, dsi->dsi_tx_reg_base + MIPITX_DSI_PLL_CON1);
+
+	reg = readl(dsi->dsi_tx_reg_base + MIPITX_DSI_TOP_CON);
+	reg = (reg & (~RG_DSI_PAD_TIE_LOW_EN));
+	writel(reg, dsi->dsi_tx_reg_base + MIPITX_DSI_TOP_CON);
+}
+
+static void dsi_phy_timconfig(struct mtk_dsi *dsi)
+{
+	u32 timcon0 = 0;
+	u32 timcon1 = 0;
+	u32 timcon2 = 0;
+	u32 timcon3 = 0;
+	unsigned int lane_no = dsi->lanes;
+	unsigned int cycle_time;
+	unsigned int ui;
+	unsigned int hs_trail_m, hs_trail_n;
+
+	ui = 1000/(250 * 2) + 0x01;
+	cycle_time = 8000/(250 * 2) + 0x01;
+
+	hs_trail_m = lane_no;
+	hs_trail_n =  NS_TO_CYCLE(((lane_no * 4 * ui) + 60), cycle_time);
+
+	timcon0 = (timcon0 & (~HS_TRAIL)) | (8<<24);
+	timcon0 = (timcon0 & (~HS_PRPR)) | 0x6<<8;
+
+	if ((timcon0 & HS_PRPR) == 0)
+		timcon0 = (timcon0 & (~HS_PRPR)) | 1<<8;
+
+	timcon0 =  (timcon0 & (~HS_ZERO)) | 0xA<<16;
+	timcon0 =  (timcon0 & (~LPX)) | 5;
+
+	if ((timcon0 & LPX) == 0)
+		timcon0 =  (timcon0 & (~LPX)) | 1;
+
+	timcon1 = (timcon1 & (~TA_GET)) | (5 * (timcon0 & LPX)<<16);
+	timcon1 = (timcon1 & (~TA_SURE)) | ((3 * (timcon0 & LPX) / 2) << 8);
+	timcon1 =  (timcon1 & (~TA_GO)) | (4 * (timcon0 & LPX));
+	timcon1 = (timcon1 & (~DA_HS_EXIT)) | (7<<24);
+	timcon2 = (timcon2 & (~CLK_TRAIL)) | ((NS_TO_CYCLE(0x64, cycle_time) +
+		0x0a)<<24);
+
+	if (((timcon2 & CLK_TRAIL)>>24) < 2)
+		timcon2 = (timcon2 & (~CLK_TRAIL)) | (2<<24);
+
+	timcon2 = (timcon2 & (~CONT_DET));
+	timcon3 =  (timcon3 & (~CLK_HS_PRPR)) | NS_TO_CYCLE(0x40, cycle_time);
+	if ((timcon3 & CLK_HS_PRPR) == 0)
+		timcon3 = (timcon3 & (~CLK_HS_PRPR)) | 1;
+
+	timcon2 = (timcon2 & (~CLK_ZERO)) |
+		(NS_TO_CYCLE(0x190 - (timcon3 & CLK_HS_PRPR) * cycle_time,
+		cycle_time)<<16);
+
+	timcon3 =  (timcon3 & (~CLK_HS_EXIT)) | ((2 * (timcon0 & LPX))<<16);
+	timcon3 =  (timcon3 & (~CLK_HS_POST)) | (NS_TO_CYCLE((80 + 52 * ui),
+		cycle_time)<<8);
+
+	writel(timcon0, dsi->dsi_reg_base + DSI_PHY_TIMECON0);
+	writel(timcon1, dsi->dsi_reg_base + DSI_PHY_TIMECON1);
+	writel(timcon2, dsi->dsi_reg_base + DSI_PHY_TIMECON2);
+	writel(timcon3, dsi->dsi_reg_base + DSI_PHY_TIMECON3);
+}
+
+static void mtk_dsi_reset(struct mtk_dsi *dsi)
+{
+	writel(3, dsi->dsi_reg_base + DSI_CON_CTRL);
+	writel(2, dsi->dsi_reg_base + DSI_CON_CTRL);
+}
+
+static int mtk_dsi_poweron(struct mtk_dsi *dsi)
+{
+	int ret;
+	struct drm_device *dev = dsi->drm_dev;
+
+	dsi_phy_clk_setting(dsi);
+
+	ret = clk_prepare_enable(dsi->dsi0_engine_clk_cg);
+	if (ret < 0) {
+		dev_err(dev->dev, "can't enable dsi0_engine_clk_cg %d\n", ret);
+		goto err_dsi0_engine_clk_cg;
+	}
+
+	ret = clk_prepare_enable(dsi->dsi0_digital_clk_cg);
+	if (ret < 0) {
+		dev_err(dev->dev, "can't enable dsi0_digital_clk_cg %d\n", ret);
+		goto err_dsi0_digital_clk_cg;
+	}
+
+	mtk_dsi_reset((dsi));
+	dsi_phy_timconfig(dsi);
+
+	return 0;
+
+err_dsi0_digital_clk_cg:
+	clk_disable_unprepare(dsi->dsi0_engine_clk_cg);
+
+err_dsi0_engine_clk_cg:
+
+	return ret;
+}
+
+static void dsi_clk_ulp_mode_enter(struct mtk_dsi *dsi)
+{
+	u32 tmp_reg1;
+
+	tmp_reg1 = readl(dsi->dsi_reg_base + DSI_PHY_LCCON);
+	tmp_reg1 = tmp_reg1 & (~LC_HS_TX_EN);
+	writel(tmp_reg1, dsi->dsi_reg_base + DSI_PHY_LCCON);
+	udelay(100);
+	tmp_reg1 = tmp_reg1 & (~LC_ULPM_EN);
+	writel(tmp_reg1, dsi->dsi_reg_base + DSI_PHY_LCCON);
+	udelay(100);
+}
+
+static void dsi_clk_ulp_mode_leave(struct mtk_dsi *dsi)
+{
+	u32 tmp_reg1;
+
+	tmp_reg1 = readl(dsi->dsi_reg_base + DSI_PHY_LCCON);
+	tmp_reg1 = tmp_reg1 & (~LC_ULPM_EN);
+	writel(tmp_reg1, dsi->dsi_reg_base + DSI_PHY_LCCON);
+	udelay(100);
+	tmp_reg1 = tmp_reg1 | LC_WAKEUP_EN;
+	writel(tmp_reg1, dsi->dsi_reg_base + DSI_PHY_LCCON);
+	udelay(100);
+	tmp_reg1 = tmp_reg1 & (~LC_WAKEUP_EN);
+	writel(tmp_reg1, dsi->dsi_reg_base + DSI_PHY_LCCON);
+	udelay(100);
+}
+
+static void dsi_lane0_ulp_mode(struct mtk_dsi *dsi, bool enter)
+{
+	u32 tmp_reg1;
+
+	tmp_reg1 = readl(dsi->dsi_reg_base + DSI_PHY_LD0CON);
+
+	if (enter) {
+		tmp_reg1 = tmp_reg1 & (~LD0_HS_TX_EN);
+		writel(tmp_reg1, dsi->dsi_reg_base + DSI_PHY_LD0CON);
+		udelay(100);
+		tmp_reg1 = tmp_reg1 & (~LD0_ULPM_EN);
+		writel(tmp_reg1, dsi->dsi_reg_base + DSI_PHY_LD0CON);
+		udelay(100);
+	} else {
+		tmp_reg1 = tmp_reg1 & (~LD0_ULPM_EN);
+		writel(tmp_reg1, dsi->dsi_reg_base + DSI_PHY_LD0CON);
+		udelay(100);
+		tmp_reg1 = tmp_reg1 | LD0_WAKEUP_EN;
+		writel(tmp_reg1, dsi->dsi_reg_base + DSI_PHY_LD0CON);
+		udelay(100);
+		tmp_reg1 = tmp_reg1 & (~LD0_WAKEUP_EN);
+		writel(tmp_reg1, dsi->dsi_reg_base + DSI_PHY_LD0CON);
+		udelay(100);
+	}
+}
+
+static bool dsi_clk_hs_state(struct mtk_dsi *dsi)
+{
+	u32 tmp_reg1;
+
+	tmp_reg1 = readl(dsi->dsi_reg_base + DSI_PHY_LCCON);
+
+	return ((tmp_reg1 & LC_HS_TX_EN) == 1) ? true : false;
+}
+
+static void dsi_clk_hs_mode(struct mtk_dsi *dsi, bool enter)
+{
+	u32 tmp_reg1;
+
+	tmp_reg1 = readl(dsi->dsi_reg_base + DSI_PHY_LCCON);
+
+	if (enter && !dsi_clk_hs_state(dsi)) {
+		tmp_reg1 = tmp_reg1 | LC_HS_TX_EN;
+		writel(tmp_reg1, dsi->dsi_reg_base + DSI_PHY_LCCON);
+	} else if (!enter && dsi_clk_hs_state(dsi)) {
+		tmp_reg1 = tmp_reg1 & (~LC_HS_TX_EN);
+		writel(tmp_reg1, dsi->dsi_reg_base + DSI_PHY_LCCON);
+	}
+}
+
+static void  dsi_set_mode(struct mtk_dsi *dsi)
+{
+	u32 tmp_reg1;
+
+	tmp_reg1 = 0;
+
+	if (dsi->mode_flags & MIPI_DSI_MODE_VIDEO) {
+		tmp_reg1 = SYNC_PULSE_MODE;
+
+		if (dsi->mode_flags & MIPI_DSI_MODE_VIDEO_BURST)
+			tmp_reg1 = BURST_MODE;
+
+		if (dsi->mode_flags & MIPI_DSI_MODE_VIDEO_SYNC_PULSE)
+			tmp_reg1 = SYNC_PULSE_MODE;
+	}
+
+	writel(tmp_reg1, dsi->dsi_reg_base + DSI_MODE_CTRL);
+}
+
+static void dsi_ps_control_vact(struct mtk_dsi *dsi)
+{
+	struct videomode *vm = &dsi->vm;
+	u32 dsiTmpBufBpp, ps_wc;
+	u32 tmp_reg;
+	u32 tmp_hstx_cklp_wc;
+
+	tmp_reg = 0;
+
+	if (dsi->format == MIPI_DSI_FMT_RGB565)
+		dsiTmpBufBpp = 2;
+	else
+		dsiTmpBufBpp = 3;
+
+	ps_wc = vm->vactive * dsiTmpBufBpp;
+
+	tmp_reg = ps_wc;
+
+	switch (dsi->format) {
+	case MIPI_DSI_FMT_RGB888:
+		tmp_reg |= PACKED_PS_24BIT_RGB888;
+		break;
+	case MIPI_DSI_FMT_RGB666:
+		tmp_reg |= PACKED_PS_18BIT_RGB666;
+		break;
+	case MIPI_DSI_FMT_RGB666_PACKED:
+		tmp_reg |= LOOSELY_PS_18BIT_RGB666;
+		break;
+	case MIPI_DSI_FMT_RGB565:
+		tmp_reg |= PACKED_PS_16BIT_RGB565;
+		break;
+	}
+
+	tmp_hstx_cklp_wc = ps_wc;
+
+	writel(vm->vactive, dsi->dsi_reg_base + DSI_VACT_NL);
+	writel(tmp_reg, dsi->dsi_reg_base + DSI_PSCTRL);
+	writel(tmp_hstx_cklp_wc, dsi->dsi_reg_base + DSI_HSTX_CKL_WC);
+}
+
+static void dsi_rxtx_control(struct mtk_dsi *dsi)
+{
+	u32 tmp_reg = 0;
+
+	switch (dsi->lanes) {
+	case 1:
+		tmp_reg = 1<<2;
+		break;
+	case 2:
+		tmp_reg = 3<<2;
+		break;
+	case 3:
+		tmp_reg = 7<<2;
+		break;
+	case 4:
+		tmp_reg = 0xF<<2;
+		break;
+	default:
+		tmp_reg = 0xF<<2;
+		break;
+	}
+
+	writel(tmp_reg, dsi->dsi_reg_base + DSI_TXRX_CTRL);
+}
+
+void dsi_ps_control(struct mtk_dsi *dsi)
+{
+	unsigned int dsi_tmp_buf_bpp;
+	u32 tmp_reg1 = 0;
+
+	switch (dsi->format) {
+	case MIPI_DSI_FMT_RGB888:
+		tmp_reg1 = PACKED_PS_24BIT_RGB888;
+		dsi_tmp_buf_bpp = 3;
+		break;
+	case MIPI_DSI_FMT_RGB666:
+		tmp_reg1 = LOOSELY_PS_18BIT_RGB666;
+		dsi_tmp_buf_bpp = 3;
+		break;
+	case MIPI_DSI_FMT_RGB666_PACKED:
+		tmp_reg1 = PACKED_PS_18BIT_RGB666;
+		dsi_tmp_buf_bpp = 3;
+		break;
+	case MIPI_DSI_FMT_RGB565:
+		tmp_reg1 = PACKED_PS_16BIT_RGB565;
+		dsi_tmp_buf_bpp = 2;
+		break;
+	default:
+		tmp_reg1 = PACKED_PS_24BIT_RGB888;
+		dsi_tmp_buf_bpp = 3;
+		break;
+	}
+
+	tmp_reg1 = tmp_reg1 + ((dsi->vm.hactive * dsi_tmp_buf_bpp) & DSI_PS_WC);
+
+	writel(tmp_reg1, dsi->dsi_reg_base + DSI_PSCTRL);
+}
+
+static void dsi_config_vdo_timing(struct mtk_dsi *dsi)
+{
+	unsigned int horizontal_sync_active_byte;
+	unsigned int horizontal_backporch_byte;
+	unsigned int horizontal_frontporch_byte;
+	unsigned int dsi_tmp_buf_bpp;
+
+	struct videomode *vm = &dsi->vm;
+
+	if (dsi->format == MIPI_DSI_FMT_RGB565)
+		dsi_tmp_buf_bpp = 2;
+	else
+		dsi_tmp_buf_bpp = 3;
+
+	writel(vm->vsync_len, dsi->dsi_reg_base + DSI_VSA_NL);
+	writel(vm->vback_porch, dsi->dsi_reg_base + DSI_VBP_NL);
+	writel(vm->vfront_porch, dsi->dsi_reg_base + DSI_VFP_NL);
+	writel(vm->vactive, dsi->dsi_reg_base + DSI_VACT_NL);
+
+	horizontal_sync_active_byte = (vm->hsync_len * dsi_tmp_buf_bpp - 10);
+
+	if (dsi->mode_flags & MIPI_DSI_MODE_VIDEO_SYNC_PULSE)
+		horizontal_backporch_byte =
+			(vm->hback_porch * dsi_tmp_buf_bpp - 10);
+	else
+		horizontal_backporch_byte = ((vm->hback_porch + vm->hsync_len) *
+			dsi_tmp_buf_bpp - 10);
+
+	horizontal_frontporch_byte = (vm->vfront_porch * dsi_tmp_buf_bpp - 12);
+
+	writel(vm->hsync_len, dsi->dsi_reg_base + DSI_HSA_WC);
+	writel(vm->hback_porch, dsi->dsi_reg_base + DSI_HBP_WC);
+	writel(vm->hfront_porch, dsi->dsi_reg_base + DSI_HFP_WC);
+
+	dsi_ps_control(dsi);
+}
+
+static void mtk_dsi_start(struct mtk_dsi *dsi)
+{
+	writel(0, dsi->dsi_reg_base + DSI_START);
+	writel(1, dsi->dsi_reg_base + DSI_START);
+}
+
+static void mtk_dsi_poweroff(struct mtk_dsi *dsi)
+{
+	clk_disable_unprepare(dsi->dsi0_engine_clk_cg);
+	clk_disable_unprepare(dsi->dsi0_digital_clk_cg);
+
+	usleep_range(10000, 20000);
+
+	dsi_phy_clk_switch_off(dsi);
+}
+
+static int mtk_output_dsi_enable(struct mtk_dsi *dsi)
+{
+	int ret;
+
+	if (dsi->enabled == true)
+		return 0;
+
+	ret = mtk_dsi_poweron(dsi);
+	if (ret < 0)
+		return ret;
+
+	dsi_rxtx_control(dsi);
+
+	dsi_clk_ulp_mode_leave(dsi);
+	dsi_lane0_ulp_mode(dsi, 0);
+	dsi_clk_hs_mode(dsi, 0);
+	dsi_set_mode(dsi);
+
+	dsi_ps_control_vact(dsi);
+	dsi_config_vdo_timing(dsi);
+
+	dsi_set_mode(dsi);
+	dsi_clk_hs_mode(dsi, 1);
+
+	mtk_dsi_start(dsi);
+
+	dsi->enabled = true;
+
+	return 0;
+}
+
+static int mtk_output_dsi_disable(struct mtk_dsi *dsi)
+{
+	if (dsi->enabled == false)
+		return 0;
+
+	dsi_lane0_ulp_mode(dsi, 1);
+	dsi_clk_ulp_mode_enter(dsi);
+	mtk_dsi_poweroff(dsi);
+	dsi_phy_clk_switch_off(dsi);
+
+	dsi->enabled = false;
+
+	return 0;
+}
+
+static void mtk_dsi_encoder_destroy(struct drm_encoder *encoder)
+{
+	drm_encoder_cleanup(encoder);
+}
+
+static const struct drm_encoder_funcs mtk_dsi_encoder_funcs = {
+	.destroy	= mtk_dsi_encoder_destroy,
+};
+
+static void mtk_dsi_encoder_dpms(struct drm_encoder *encoder, int mode)
+{
+	struct mtk_dsi *dsi = encoder_to_dsi(encoder);
+	struct drm_panel *panel = dsi->panel;
+
+	mtk_dsi_info("%s dpms mode = %d !\n", __func__, mode);
+
+	if (mode != DRM_MODE_DPMS_ON) {
+		drm_panel_disable(panel);
+		mtk_output_dsi_disable(dsi);
+	} else {
+		mtk_output_dsi_enable(dsi);
+		drm_panel_enable(panel);
+	}
+}
+
+static bool mtk_dsi_encoder_mode_fixup(struct drm_encoder *encoder,
+			       const struct drm_display_mode *mode,
+			       struct drm_display_mode *adjusted_mode)
+{
+	return true;
+}
+
+static void mtk_dsi_encoder_prepare(struct drm_encoder *encoder)
+{
+	/* drm framework doesn't check NULL. */
+}
+
+static void mtk_dsi_encoder_mode_set(struct drm_encoder *encoder,
+	struct drm_display_mode *mode, struct drm_display_mode *adjusted)
+{
+}
+
+static void mtk_dsi_encoder_commit(struct drm_encoder *encoder)
+{
+	/* DRM_MODE_DPMS_ON? */
+}
+
+static enum drm_connector_status mtk_dsi_connector_detect(
+	struct drm_connector *connector, bool force)
+{
+	enum drm_connector_status status = connector_status_unknown;
+
+	status = connector_status_connected; /* FIXME? */
+
+	return status;
+}
+
+static void mtk_dsi_connector_destroy(struct drm_connector *connector)
+{
+	drm_connector_unregister(connector);
+	drm_connector_cleanup(connector);
+}
+
+static const struct drm_display_mode default_modes[] = {
+	/* 1368x768@60Hz */
+	{ DRM_MODE("1368x768", DRM_MODE_TYPE_DRIVER, 72070,
+	1368, 1368 + 58, 1368 + 58 + 58, 1368 + 58 + 58 + 58, 0,
+	768, 768 + 4, 768 + 4 + 4, 768 + 4 + 4 + 4, 0, 0) },
+};
+
+static int mtk_dsi_connector_get_modes(struct drm_connector *connector)
+{
+	const struct drm_display_mode *ptr = &default_modes[0];
+	struct drm_display_mode *mode;
+	int count = 0;
+
+	mode = drm_mode_duplicate(connector->dev, ptr);
+	if (mode) {
+		drm_mode_probed_add(connector, mode);
+		count++;
+	}
+
+	connector->display_info.width_mm = mode->hdisplay;
+	connector->display_info.height_mm = mode->vdisplay;
+
+	return 1;
+}
+
+static struct drm_encoder *
+mtk_dsi_connector_best_encoder(struct drm_connector *connector)
+{
+	struct mtk_dsi *dsi = connector_to_dsi(connector);
+
+	return &dsi->encoder;
+}
+
+static const struct drm_encoder_helper_funcs mtk_dsi_encoder_helper_funcs = {
+	.dpms = mtk_dsi_encoder_dpms,
+	.mode_fixup = mtk_dsi_encoder_mode_fixup,
+	.prepare = mtk_dsi_encoder_prepare,
+	.mode_set = mtk_dsi_encoder_mode_set,
+	.commit = mtk_dsi_encoder_commit,
+};
+
+static const struct drm_connector_funcs mtk_dsi_connector_funcs = {
+	.dpms = drm_helper_connector_dpms,
+	.detect = mtk_dsi_connector_detect,
+	.fill_modes = drm_helper_probe_single_connector_modes,
+	.destroy = mtk_dsi_connector_destroy,
+};
+
+static const struct drm_connector_helper_funcs
+	mtk_dsi_connector_helper_funcs = {
+	.get_modes = mtk_dsi_connector_get_modes,
+	.best_encoder = mtk_dsi_connector_best_encoder,
+};
+
+struct bridge_init {
+	struct i2c_client *mipirx_client;
+	struct i2c_client *dptx_client;
+	struct device_node *node_mipirx;
+	struct device_node *node_dptx;
+};
+
+static int mtk_drm_attach_lcm_bridge(struct drm_bridge *bridge,
+	struct drm_encoder *encoder)
+{
+	int ret;
+
+	encoder->bridge = bridge;
+	bridge->encoder = encoder;
+	ret = drm_bridge_attach(encoder->dev, bridge);
+	if (ret) {
+		DRM_ERROR("Failed to attach bridge to drm\n");
+		return ret;
+	}
+
+	return 0;
+}
+
+static int mtk_dsi_create_conn_enc(struct mtk_dsi *dsi)
+{
+	int ret;
+
+	ret = drm_encoder_init(dsi->drm_dev, &dsi->encoder,
+			&mtk_dsi_encoder_funcs, DRM_MODE_ENCODER_DSI);
+
+	if (ret)
+		goto errcode;
+
+	drm_encoder_helper_add(&dsi->encoder, &mtk_dsi_encoder_helper_funcs);
+
+	dsi->encoder.possible_crtcs = 1;
+
+	/* Pre-empt DP connector creation if there's a bridge */
+	ret = mtk_drm_attach_lcm_bridge(dsi->bridge, &dsi->encoder);
+	if (!ret)
+		return 0;
+
+	ret = drm_connector_init(dsi->drm_dev, &dsi->conn,
+		&mtk_dsi_connector_funcs, DRM_MODE_CONNECTOR_DSI);
+	if (ret)
+		goto errcode;
+
+	drm_connector_helper_add(&dsi->conn, &mtk_dsi_connector_helper_funcs);
+
+	ret = drm_connector_register(&dsi->conn);
+	if (ret)
+		goto errcode;
+
+	dsi->conn.dpms = DRM_MODE_DPMS_OFF;
+	dsi->conn.encoder = &dsi->encoder;
+
+	drm_mode_connector_attach_encoder(&dsi->conn, &dsi->encoder);
+
+	if (dsi->panel)
+		ret = drm_panel_attach(dsi->panel, &dsi->conn);
+
+	return 0;
+
+errcode:
+	drm_encoder_cleanup(&dsi->encoder);
+	drm_connector_unregister(&dsi->conn);
+	drm_connector_cleanup(&dsi->conn);
+
+	return ret;
+}
+
+static void mtk_dsi_destroy_conn_enc(struct mtk_dsi *dsi)
+{
+	drm_encoder_cleanup(&dsi->encoder);
+	drm_connector_unregister(&dsi->conn);
+	drm_connector_cleanup(&dsi->conn);
+}
+
+static int mtk_dsi_bind(struct device *dev, struct device *master,
+	void *data)
+{
+	int ret;
+	struct mtk_dsi *dsi = NULL;
+
+	dsi = platform_get_drvdata(to_platform_device(dev));
+	if (!dsi) {
+		ret = -EFAULT;
+		goto errcode;
+	}
+
+	dsi->drm_dev = data;
+
+	ret = mtk_dsi_create_conn_enc(dsi);
+	if (ret) {
+		DRM_ERROR("Encoder create  failed with %d\n", ret);
+		return ret;
+	}
+
+	return 0;
+
+errcode:
+	return ret;
+
+}
+
+static void mtk_dsi_unbind(struct device *dev, struct device *master,
+	void *data)
+{
+	struct mtk_dsi *dsi = NULL;
+
+	dsi = platform_get_drvdata(to_platform_device(dev));
+	mtk_dsi_destroy_conn_enc(dsi);
+
+	dsi->drm_dev = NULL;
+}
+
+static const struct component_ops mtk_dsi_component_ops = {
+	.bind	= mtk_dsi_bind,
+	.unbind	= mtk_dsi_unbind,
+};
+
+static int mtk_dsi_host_attach(struct mipi_dsi_host *host,
+	struct mipi_dsi_device *device)
+{
+	struct mtk_dsi *dsi = host_to_mtk(host);
+
+	dsi->mode_flags = device->mode_flags;
+	dsi->format = device->format;
+	dsi->lanes = device->lanes;
+
+	dsi->panel = of_drm_find_panel(device->dev.of_node);
+	if (dsi->panel) {
+		if (dsi->conn.dev)
+			drm_helper_hpd_irq_event(dsi->conn.dev);
+	}
+
+	return 0;
+}
+
+static int mtk_dsi_host_detach(struct mipi_dsi_host *host,
+	struct mipi_dsi_device *device)
+{
+	struct mtk_dsi *dsi = host_to_mtk(host);
+
+	if (dsi->panel && &device->dev == dsi->panel->dev) {
+		if (dsi->conn.dev)
+			drm_helper_hpd_irq_event(dsi->conn.dev);
+
+		dsi->panel = NULL;
+	}
+
+	return 0;
+}
+
+static const struct mipi_dsi_host_ops mtk_dsi_host_ops = {
+	.attach = mtk_dsi_host_attach,
+	.detach = mtk_dsi_host_detach,
+};
+
+static int mtk_dsi_probe(struct platform_device *pdev)
+{
+	struct mtk_dsi *dsi = NULL;
+	struct device *dev = &pdev->dev;
+	struct device_node *panel_node, *bridge_node, *endpoint;
+	struct resource *regs;
+	int err;
+	int ret;
+
+	dsi = kzalloc(sizeof(struct mtk_dsi), GFP_KERNEL);
+
+	dsi->mode_flags = MIPI_DSI_MODE_VIDEO;
+	dsi->format = MIPI_DSI_FMT_RGB888;
+	dsi->lanes = 4;
+
+	dsi->vm.pixelclock = 76000;
+	dsi->vm.hactive	 = 1368;
+	dsi->vm.hback_porch = 100;
+	dsi->vm.hfront_porch = 106;
+	dsi->vm.hsync_len = 26;
+	dsi->vm.vactive   = 768;
+	dsi->vm.vback_porch = 10;
+	dsi->vm.vfront_porch = 10;
+	dsi->vm.vsync_len = 12;
+
+	err = mtk_dsi_of_read_u32(dev->of_node, "mediatek,width",
+				     &dsi->vm.hactive);
+	if (err < 0)
+		return err;
+
+	err = mtk_dsi_of_read_u32(dev->of_node, "mediatek,height",
+				     &dsi->vm.vactive);
+	if (err < 0)
+		return err;
+
+	err = mtk_dsi_of_read_u32(dev->of_node, "mediatek,mipi-tx-burst-freq",
+				     &dsi->pll_clk_rate);
+
+	if (err < 0)
+		return err;
+
+	endpoint = of_graph_get_next_endpoint(dev->of_node, NULL);
+	if (endpoint) {
+		bridge_node = of_graph_get_remote_port_parent(endpoint);
+		if (!bridge_node)
+			return -EPROBE_DEFER;
+
+		dsi->bridge = of_drm_find_bridge(bridge_node);
+		of_node_put(bridge_node);
+		if (!dsi->bridge)
+			return -EPROBE_DEFER;
+	}
+
+	dsi->dsi0_engine_clk_cg = devm_clk_get(dev, "dsi0_engine_disp_ck");
+	if (IS_ERR(dsi->dsi0_engine_clk_cg)) {
+		dev_err(dev, "cannot get dsi0_engine_clk_cg\n");
+		return PTR_ERR(dsi->dsi0_engine_clk_cg);
+	}
+
+	dsi->dsi0_digital_clk_cg = devm_clk_get(dev, "dsi0_digital_disp_ck");
+	if (IS_ERR(dsi->dsi0_digital_clk_cg)) {
+		dev_err(dev, "cannot get dsi0_digital_disp_ck\n");
+		return PTR_ERR(dsi->dsi0_digital_clk_cg);
+	}
+
+	regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	dsi->dsi_reg_base = devm_ioremap_resource(dev, regs);
+
+	if (IS_ERR(dsi->dsi_reg_base)) {
+		dev_err(dev, "cannot get dsi->dsi_reg_base\n");
+		return PTR_ERR(dsi->dsi_reg_base);
+	}
+
+	regs = platform_get_resource(pdev, IORESOURCE_MEM, 1);
+	dsi->dsi_tx_reg_base = devm_ioremap_resource(dev, regs);
+	if (IS_ERR(dsi->dsi_tx_reg_base)) {
+		dev_err(dev, "cannot get dsi->dsi_tx_reg_base\n");
+		return PTR_ERR(dsi->dsi_tx_reg_base);
+	}
+
+	dsi->disp_supplies = devm_regulator_get(&pdev->dev, "disp-bdg");
+	if (IS_ERR(dsi->disp_supplies)) {
+		dev_err(dev, "cannot get dsi->disp_supplies\n");
+		return PTR_ERR(dsi->disp_supplies);
+	}
+
+	ret = regulator_set_voltage(dsi->disp_supplies, 1800000, 1800000);
+	if (ret != 0)	{
+		dev_err(dev, "lcm failed to set lcm_vgp voltage:  %d\n", ret);
+		return PTR_ERR(dsi->disp_supplies);
+	}
+
+	ret = regulator_enable(dsi->disp_supplies);
+	if (ret != 0) {
+		dev_err(dev, "Failed to enable lcm_vgp: %d\n", ret);
+		return PTR_ERR(dsi->disp_supplies);
+	}
+
+	panel_node = of_parse_phandle(dev->of_node, "mediatek,panel", 0);
+	if (panel_node) {
+		dsi->panel = of_drm_find_panel(panel_node);
+		of_node_put(panel_node);
+		if (!dsi->panel)
+			return -EPROBE_DEFER;
+	} else
+		return -EPROBE_DEFER;
+
+	platform_set_drvdata(pdev, dsi);
+
+	ret = component_add(&pdev->dev, &mtk_dsi_component_ops);
+	if (ret)
+		goto err_del_component;
+
+	return 0;
+
+err_del_component:
+	component_del(&pdev->dev, &mtk_dsi_component_ops);
+	return -EPROBE_DEFER;
+
+}
+
+static int mtk_dsi_remove(struct platform_device *pdev)
+{
+	struct mtk_dsi *dsi = platform_get_drvdata(pdev);
+
+	mtk_output_dsi_disable(dsi);
+	component_del(&pdev->dev, &mtk_dsi_component_ops);
+
+	return 0;
+}
+
+static const struct of_device_id mtk_dsi_of_match[] = {
+	{ .compatible = "mediatek,mt8173-dsi" },
+	{ },
+};
+
+struct platform_driver mtk_dsi_driver = {
+	.probe = mtk_dsi_probe,
+	.remove = mtk_dsi_remove,
+	.driver = {
+		.name = "mtk-dsi",
+		.of_match_table = mtk_dsi_of_match,
+		.owner	= THIS_MODULE,
+	},
+};
+
+
diff --git a/drivers/gpu/drm/mediatek/mediatek_drm_dsi.h b/drivers/gpu/drm/mediatek/mediatek_drm_dsi.h
new file mode 100644
index 0000000..7b7b93b
--- /dev/null
+++ b/drivers/gpu/drm/mediatek/mediatek_drm_dsi.h
@@ -0,0 +1,71 @@
+/*
+ * Copyright (c) 2015 MediaTek Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef _MEDIATEK_DRM_DSI_H_
+#define _MEDIATEK_DRM_DSI_H_
+
+
+struct mtk_dsi {
+	struct drm_device *drm_dev;
+	struct drm_encoder encoder;
+	struct drm_connector conn;
+	struct drm_panel *panel;
+	struct drm_bridge *bridge;
+	struct mipi_dsi_host host;
+	struct regulator *disp_supplies;
+
+	void __iomem *dsi_reg_base;
+	void __iomem *dsi_tx_reg_base;
+
+	struct clk *dsi_disp_clk_cg;
+	struct clk *dsi_dsi_clk_cg;
+	struct clk *dsi_div2_clk_cg;
+
+	struct clk *dsi0_engine_clk_cg;
+	struct clk *dsi0_digital_clk_cg;
+
+	u32 pll_clk_rate;
+
+	unsigned long mode_flags;
+	enum mipi_dsi_pixel_format format;
+	unsigned int lanes;
+	struct videomode vm;
+	bool enabled;
+};
+
+
+static inline struct mtk_dsi *host_to_mtk(struct mipi_dsi_host *host)
+{
+	return container_of(host, struct mtk_dsi, host);
+}
+
+static inline struct mtk_dsi *encoder_to_dsi(struct drm_encoder *e)
+{
+	return container_of(e, struct mtk_dsi, encoder);
+}
+
+#define connector_to_dsi(c) container_of(c, struct mtk_dsi, conn)
+
+
+#define mtk_dsi_err(fmt, ...) \
+	pr_err("[mediatek drm dsi] ERROR!!! fun:%s, line:%d  " \
+	fmt, __func__, __LINE__,  ##__VA_ARGS__)
+#define mtk_dsi_info(fmt, ...) \
+	pr_info("[mediatek drm dsi] INFO fun:%s, line:%d  " \
+	fmt, __func__, __LINE__,  ##__VA_ARGS__)
+#define mtk_dsi_output(fmt, ...) \
+		pr_info(fmt, ##__VA_ARGS__)
+
+#endif
+
+
diff --git a/drivers/gpu/drm/mediatek/mediatek_drm_fb.c b/drivers/gpu/drm/mediatek/mediatek_drm_fb.c
new file mode 100644
index 0000000..fbaba95
--- /dev/null
+++ b/drivers/gpu/drm/mediatek/mediatek_drm_fb.c
@@ -0,0 +1,339 @@
+/*
+ * Copyright (c) 2015 MediaTek Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <drm/drmP.h>
+#include <drm/drm_gem.h>
+#include <drm/drm_crtc_helper.h>
+#include <drm/drm_fb_helper.h>
+
+#include "mediatek_drm_drv.h"
+#include "mediatek_drm_fb.h"
+#include "mediatek_drm_gem.h"
+
+
+static int mtk_drm_fb_create_handle(struct drm_framebuffer *fb,
+					struct drm_file *file_priv,
+					unsigned int *handle)
+{
+	struct mtk_drm_fb *mtk_fb = to_mtk_fb(fb);
+
+	return drm_gem_handle_create(file_priv, mtk_fb->gem_obj[0], handle);
+}
+
+static void mtk_drm_fb_destroy(struct drm_framebuffer *fb)
+{
+	unsigned int i;
+	struct mtk_drm_fb *mtk_fb = to_mtk_fb(fb);
+	struct drm_gem_object *gem;
+	int nr = drm_format_num_planes(fb->pixel_format);
+
+	drm_framebuffer_cleanup(fb);
+
+	for (i = 0; i < nr; i++) {
+		gem = mtk_fb->gem_obj[i];
+		drm_gem_object_unreference_unlocked(gem);
+	}
+}
+
+static struct drm_framebuffer_funcs mediatek_drm_fb_funcs = {
+	.create_handle = mtk_drm_fb_create_handle,
+	.destroy = mtk_drm_fb_destroy,
+};
+
+static struct mtk_drm_fb *mtk_drm_framebuffer_init(struct drm_device *dev,
+			    struct drm_mode_fb_cmd2 *mode,
+			    struct drm_gem_object **obj)
+{
+	struct mtk_drm_fb *mtk_fb;
+	unsigned int i;
+	int ret;
+
+	mtk_fb = devm_kzalloc(dev->dev, sizeof(*mtk_fb), GFP_KERNEL);
+	if (!mtk_fb)
+		return ERR_PTR(-ENOMEM);
+
+	drm_helper_mode_fill_fb_struct(&mtk_fb->base, mode);
+
+	for (i = 0; i < drm_format_num_planes(mode->pixel_format); i++)
+		mtk_fb->gem_obj[i] = obj[i];
+
+	ret = drm_framebuffer_init(dev, &mtk_fb->base, &mediatek_drm_fb_funcs);
+	if (ret) {
+		DRM_ERROR("failed to initialize framebuffer\n");
+		return ERR_PTR(ret);
+	}
+
+	return mtk_fb;
+}
+
+static int mtk_drm_fb_mmap(struct fb_info *info, struct vm_area_struct *vma)
+{
+	struct drm_fb_helper *helper = info->par;
+	struct device *dev = ((struct drm_device *)helper->dev)->dev;
+	struct mtk_drm_fb *mtk_fb = to_mtk_fb(helper->fb);
+	struct mtk_drm_gem_buf *buffer =
+		to_mtk_gem_obj(mtk_fb->gem_obj[0])->buffer;
+	int ret;
+
+	vma->vm_flags |= VM_MIXEDMAP;
+
+	if (dma_get_attr(DMA_ATTR_NO_KERNEL_MAPPING, &buffer->dma_attrs)) {
+		ret = dma_mmap_attrs(dev, vma, buffer->pages,
+			buffer->mva_addr, buffer->size, &buffer->dma_attrs);
+	} else {
+		ret = dma_mmap_attrs(dev, vma, buffer->kvaddr,
+			buffer->mva_addr, buffer->size, &buffer->dma_attrs);
+	}
+
+	if (ret) {
+		DRM_ERROR("failed to fb_mmap %d\n", ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+static struct fb_ops mediatek_fb_ops = {
+	.owner = THIS_MODULE,
+	.fb_fillrect = sys_fillrect,
+	.fb_copyarea = sys_copyarea,
+	.fb_imageblit = sys_imageblit,
+	.fb_check_var = drm_fb_helper_check_var,
+	.fb_set_par = drm_fb_helper_set_par,
+	.fb_blank = drm_fb_helper_blank,
+	.fb_pan_display = drm_fb_helper_pan_display,
+	.fb_setcmap = drm_fb_helper_setcmap,
+	.fb_mmap = mtk_drm_fb_mmap,
+};
+
+static int mtk_fbdev_probe(struct drm_fb_helper *helper,
+			     struct drm_fb_helper_surface_size *sizes)
+{
+	struct drm_device *dev = helper->dev;
+	struct drm_mode_fb_cmd2 mode = { 0 };
+	struct mtk_drm_fb *mtk_fb;
+	struct mtk_drm_gem_buf *buffer;
+	struct mtk_drm_gem_obj *mtk_gem;
+	struct drm_gem_object *gem;
+	struct fb_info *info;
+	struct drm_framebuffer *fb;
+	unsigned long offset;
+	size_t size;
+	int err;
+
+	mode.width = sizes->surface_width;
+	mode.height = sizes->surface_height;
+	mode.pitches[0] = sizes->surface_width * ((sizes->surface_bpp + 7) / 8);
+	mode.pixel_format = drm_mode_legacy_fb_format(sizes->surface_bpp,
+							sizes->surface_depth);
+
+	mode.height = mode.height;/* << 1; for fb use? */
+	size = mode.pitches[0] * mode.height;
+	dev_info(dev->dev, "mtk_fbdev_probe %dx%d bpp %d pitch %d size %zu\n",
+		mode.width, mode.height, sizes->surface_bpp, mode.pitches[0],
+		size);
+
+	mtk_gem = mtk_drm_gem_create(dev, 3, size);
+	if (IS_ERR(mtk_gem)) {
+		err = PTR_ERR(mtk_gem);
+		goto fini;
+	}
+
+	gem = &mtk_gem->base;
+	buffer = mtk_gem->buffer;
+
+	mtk_fb = mtk_drm_framebuffer_init(dev, &mode, &gem);
+	if (IS_ERR(mtk_fb)) {
+		dev_err(dev->dev, "failed to allocate DRM framebuffer\n");
+		err = PTR_ERR(mtk_fb);
+		goto free;
+	}
+	fb = &mtk_fb->base;
+
+	info = framebuffer_alloc(0, dev->dev);
+	if (!info) {
+		dev_err(dev->dev, "failed to allocate framebuffer info\n");
+		err = PTR_ERR(info);
+		goto release;
+	}
+
+	helper->fb = fb;
+	helper->fbdev = info;
+
+	info->par = helper;
+	info->flags = FBINFO_FLAG_DEFAULT;
+	info->fbops = &mediatek_fb_ops;
+
+	err = fb_alloc_cmap(&info->cmap, 256, 0);
+	if (err < 0) {
+		dev_err(dev->dev, "failed to allocate color map: %d\n", err);
+		goto destroy;
+	}
+
+	drm_fb_helper_fill_fix(info, fb->pitches[0], fb->depth);
+	drm_fb_helper_fill_var(info, helper, fb->width, fb->height);
+
+	offset = info->var.xoffset * (fb->bits_per_pixel + 7) / 8;
+	offset += info->var.yoffset * fb->pitches[0];
+
+	strcpy(info->fix.id, "mtk");
+	/* dev->mode_config.fb_base = (resource_size_t)bo->paddr; */
+	info->var.yres = info->var.yres_virtual;/* >> 1; for fb use? */
+	info->fix.smem_start = buffer->mva_addr + offset;
+	info->fix.smem_len = size;
+	info->screen_base = buffer->kvaddr + offset;
+	info->screen_size = size;
+
+	return 0;
+
+destroy:
+	drm_framebuffer_unregister_private(fb);
+	mtk_drm_fb_destroy(fb);
+release:
+	framebuffer_release(info);
+free:
+	mtk_drm_gem_free_object(&mtk_gem->base);
+fini:
+	dev_err(dev->dev, "mtk_fbdev_probe fail\n");
+	return err;
+}
+
+static struct drm_fb_helper_funcs mediatek_drm_fb_helper_funcs = {
+	.fb_probe = mtk_fbdev_probe,
+};
+
+int mtk_fbdev_create(struct drm_device *dev)
+{
+	struct mtk_drm_private *priv =
+		(struct mtk_drm_private *)dev->dev_private;
+	struct drm_fb_helper *fbdev;
+	int ret;
+
+	fbdev = devm_kzalloc(dev->dev, sizeof(*fbdev), GFP_KERNEL);
+	if (!fbdev)
+		return -ENOMEM;
+
+	drm_fb_helper_prepare(dev, fbdev, &mediatek_drm_fb_helper_funcs);
+
+	ret = drm_fb_helper_init(dev, fbdev, dev->mode_config.num_crtc,
+						dev->mode_config.num_connector);
+	if (ret) {
+		dev_err(dev->dev, "failed to initialize DRM FB helper\n");
+		goto fini;
+	}
+
+	ret = drm_fb_helper_single_add_all_connectors(fbdev);
+	if (ret) {
+		dev_err(dev->dev, "failed to add connectors\n");
+		goto fini;
+	}
+
+	drm_helper_disable_unused_functions(dev);
+
+	ret = drm_fb_helper_initial_config(fbdev, FBDEV_BPP);
+	if (ret) {
+		dev_err(dev->dev, "failed to set initial configuration\n");
+		goto fini;
+	}
+	priv->fb_helper = fbdev;
+
+	return 0;
+
+fini:
+	drm_fb_helper_fini(fbdev);
+
+	return ret;
+}
+
+void mtk_fbdev_destroy(struct drm_device *dev)
+{
+	struct mtk_drm_private *priv =
+		(struct mtk_drm_private *)dev->dev_private;
+	struct drm_fb_helper *fbdev = priv->fb_helper;
+	struct fb_info *info = priv->fb_helper->fbdev;
+
+	if (info) {
+		int err;
+
+		err = unregister_framebuffer(info);
+		if (err < 0)
+			DRM_DEBUG_KMS("failed to unregister framebuffer\n");
+
+		if (info->cmap.len)
+			fb_dealloc_cmap(&info->cmap);
+
+		framebuffer_release(info);
+	}
+
+	if (fbdev->fb) {
+		drm_framebuffer_unregister_private(fbdev->fb);
+		mtk_drm_fb_destroy(fbdev->fb);
+	}
+
+	drm_fb_helper_fini(fbdev);
+	kfree(fbdev);
+}
+
+void mtk_drm_mode_output_poll_changed(struct drm_device *dev)
+{
+	struct mtk_drm_private *priv =
+		(struct mtk_drm_private *)dev->dev_private;
+
+	if (priv->fb_helper)
+		drm_fb_helper_hotplug_event(priv->fb_helper);
+}
+
+struct drm_framebuffer *mtk_drm_mode_fb_create(struct drm_device *dev,
+					       struct drm_file *file,
+					       struct drm_mode_fb_cmd2 *cmd)
+{
+	unsigned int hsub, vsub, i;
+	struct mtk_drm_fb *mtk_fb;
+	struct drm_gem_object *gem[MAX_FB_OBJ];
+	int err;
+
+	hsub = drm_format_horz_chroma_subsampling(cmd->pixel_format);
+	vsub = drm_format_vert_chroma_subsampling(cmd->pixel_format);
+	for (i = 0; i < drm_format_num_planes(cmd->pixel_format); i++) {
+		unsigned int width = cmd->width / (i ? hsub : 1);
+		unsigned int height = cmd->height / (i ? vsub : 1);
+		unsigned int size, bpp;
+
+		gem[i] = drm_gem_object_lookup(dev, file, cmd->handles[i]);
+		if (!gem[i]) {
+			err = -ENOENT;
+			goto unreference;
+		}
+
+		bpp = drm_format_plane_cpp(cmd->pixel_format, i);
+		size = (height - 1) * cmd->pitches[i] + width * bpp;
+		size += cmd->offsets[i];
+
+		if (gem[i]->size < size) {
+			err = -EINVAL;
+			goto unreference;
+		}
+	}
+
+	mtk_fb = mtk_drm_framebuffer_init(dev, cmd, gem);
+
+	return &mtk_fb->base;
+
+unreference:
+	while (i--)
+		drm_gem_object_unreference_unlocked(gem[i]);
+
+	return ERR_PTR(err);
+}
+
+
diff --git a/drivers/gpu/drm/mediatek/mediatek_drm_fb.h b/drivers/gpu/drm/mediatek/mediatek_drm_fb.h
new file mode 100644
index 0000000..ee8b6a6
--- /dev/null
+++ b/drivers/gpu/drm/mediatek/mediatek_drm_fb.h
@@ -0,0 +1,43 @@
+/*
+ * Copyright (c) 2015 MediaTek Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef _MEDIATEK_DRM_FB_H_
+#define _MEDIATEK_DRM_FB_H_
+
+#define MAX_FB_OBJ	4
+#define FBDEV_BPP	16
+
+/*
+ * mtk specific framebuffer structure.
+ *
+ * @fb: drm framebuffer object.
+ * @mtk_gem_obj: array of mtk specific gem object containing a gem object.
+ */
+struct mtk_drm_fb {
+	struct drm_framebuffer	base;
+	struct drm_gem_object	*gem_obj[MAX_FB_OBJ]; /* FIXME? mtk_gem_obj? */
+};
+
+#define to_mtk_fb(x) container_of(x, struct mtk_drm_fb, base)
+
+void mtk_drm_mode_output_poll_changed(struct drm_device *dev);
+struct drm_framebuffer *mtk_drm_mode_fb_create(struct drm_device *dev,
+					       struct drm_file *file,
+					       struct drm_mode_fb_cmd2 *cmd);
+
+int mtk_fbdev_create(struct drm_device *dev);
+void mtk_fbdev_destroy(struct drm_device *dev);
+
+#endif
+
+
diff --git a/drivers/gpu/drm/mediatek/mediatek_drm_gem.c b/drivers/gpu/drm/mediatek/mediatek_drm_gem.c
new file mode 100644
index 0000000..3df3f4f
--- /dev/null
+++ b/drivers/gpu/drm/mediatek/mediatek_drm_gem.c
@@ -0,0 +1,315 @@
+/*
+ * Copyright (c) 2015 MediaTek Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <drm/drmP.h>
+#include <drm/drm_gem.h>
+
+#include "mediatek_drm_gem.h"
+#include "drm/mediatek_drm.h"
+
+
+struct mtk_drm_gem_obj *mtk_drm_gem_init(struct drm_device *dev,
+						      unsigned long size)
+{
+	struct mtk_drm_gem_obj *mtk_gem_obj;
+	struct drm_gem_object *obj;
+	int ret;
+
+	mtk_gem_obj = kzalloc(sizeof(*mtk_gem_obj), GFP_KERNEL);
+	if (!mtk_gem_obj)
+		return NULL;
+
+	mtk_gem_obj->size = size;
+	obj = &mtk_gem_obj->base;
+
+	ret = drm_gem_object_init(dev, obj, size);
+	if (ret < 0) {
+		DRM_ERROR("failed to initialize gem object\n");
+		kfree(mtk_gem_obj);
+		return NULL;
+	}
+
+	DRM_DEBUG_KMS("created file object = 0x%p\n", obj->filp);
+
+	return mtk_gem_obj;
+}
+
+struct mtk_drm_gem_obj *mtk_drm_gem_create(struct drm_device *dev,
+				unsigned int flags, unsigned long size)
+{
+	struct mtk_drm_gem_obj *mtk_gem;
+	struct mtk_drm_gem_buf *mtk_buf;
+	int ret;
+
+	if (!size) {
+		DRM_ERROR("invalid size.\n");
+		ret = -EINVAL;
+		goto err;
+	}
+
+	mtk_gem = kzalloc(sizeof(*mtk_gem), GFP_KERNEL);
+	if (!mtk_gem) {
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	mtk_buf = kzalloc(sizeof(*mtk_buf), GFP_KERNEL);
+	if (!mtk_buf) {
+		ret = -ENOMEM;
+		goto err_buf;
+	}
+	mtk_gem->buffer = mtk_buf;
+
+	if (flags == 0) {
+		size = round_up(size, PAGE_SIZE);
+		mtk_buf->kvaddr = kzalloc(size, GFP_KERNEL);
+		if (!mtk_buf->kvaddr) {
+			ret = -ENOMEM;
+			goto err_size;
+		}
+
+		mtk_buf->paddr = virt_to_phys(mtk_buf->kvaddr);
+		mtk_buf->size = size;
+		mtk_buf->mva_addr = mtk_buf->paddr;
+	} else {
+		struct page **pages;
+		int npages, size_pages;
+		int offset, index;
+
+		size = PAGE_ALIGN(size);
+		npages = size >> PAGE_SHIFT;
+		size_pages = npages * sizeof(*pages);
+		pages = kmalloc(size_pages, GFP_KERNEL);
+		if (!pages) {
+			ret = -ENOMEM;
+			goto err_size;
+		}
+		mtk_buf->pages = pages;
+
+		init_dma_attrs(&mtk_buf->dma_attrs);
+
+		mtk_buf->kvaddr = dma_alloc_attrs(dev->dev, size,
+			(dma_addr_t *)&mtk_buf->mva_addr, GFP_KERNEL,
+			&mtk_buf->dma_attrs);
+		if (!mtk_buf->kvaddr) {
+			ret = -ENOMEM;
+			goto err_mem;
+		}
+
+		mtk_buf->paddr = 0;
+		mtk_buf->size = size;
+
+		for (offset = 0, index = 0;
+			offset < size; offset += PAGE_SIZE, index++)
+			mtk_buf->pages[index] =
+				vmalloc_to_page(mtk_buf->kvaddr + offset);
+
+		mtk_buf->sgt = drm_prime_pages_to_sg(mtk_buf->pages, npages);
+	}
+	mtk_gem->flags = flags;
+
+	DRM_INFO("kvaddr = %p mva_addr = %X\n",
+		mtk_buf->kvaddr, mtk_buf->mva_addr);
+	ret = drm_gem_object_init(dev, &mtk_gem->base, size);
+	if (ret)
+		goto err_mem;
+
+	return mtk_gem;
+
+err_mem:
+	if (mtk_buf->paddr)
+		kfree(mtk_buf->kvaddr);
+	else
+		dma_free_attrs(dev->dev, size, mtk_buf->kvaddr,
+			mtk_buf->mva_addr, &mtk_buf->dma_attrs);
+
+	kfree(mtk_buf->pages);
+
+err_size:
+	kfree(mtk_buf);
+err_buf:
+	kfree(mtk_gem);
+err:
+	return ERR_PTR(ret);
+}
+
+void mtk_drm_gem_free_object(struct drm_gem_object *gem)
+{
+	struct mtk_drm_gem_obj *mtk_gem = to_mtk_gem_obj(gem);
+
+	DRM_DEBUG_KMS("handle count = %d\n", gem->handle_count);
+
+	drm_gem_free_mmap_offset(gem);
+
+	/* release file pointer to gem object. */
+	drm_gem_object_release(gem);
+
+	if (mtk_gem->flags == 0)
+		kfree(mtk_gem->buffer->kvaddr);
+	else
+		dma_free_attrs(gem->dev->dev, mtk_gem->buffer->size,
+			mtk_gem->buffer->kvaddr, mtk_gem->buffer->mva_addr,
+			&mtk_gem->buffer->dma_attrs);
+
+	kfree(mtk_gem->buffer->pages);
+	kfree(mtk_gem->buffer);
+	kfree(mtk_gem);
+}
+
+int mtk_drm_gem_dumb_create(struct drm_file *file_priv,
+			       struct drm_device *dev,
+			       struct drm_mode_create_dumb *args)
+
+{
+	struct mtk_drm_gem_obj *mtk_gem;
+	unsigned int min_pitch = args->width * ((args->bpp + 7) / 8);
+	int ret;
+
+	args->pitch = min_pitch;
+	args->size = args->pitch * args->height;
+
+	mtk_gem = mtk_drm_gem_create(dev, 3, args->size);
+	if (IS_ERR(mtk_gem))
+		return PTR_ERR(mtk_gem);
+
+	/*
+	 * allocate a id of idr table where the obj is registered
+	 * and handle has the id what user can see.
+	 */
+	ret = drm_gem_handle_create(file_priv, &mtk_gem->base, &args->handle);
+	if (ret)
+		return ret;
+
+	/* drop reference from allocate - handle holds it now. */
+	drm_gem_object_unreference_unlocked(&mtk_gem->base);
+
+	return 0;
+}
+
+int mtk_drm_gem_dumb_map_offset(struct drm_file *file_priv,
+				   struct drm_device *dev, uint32_t handle,
+				   uint64_t *offset)
+{
+	struct drm_gem_object *obj;
+	int ret = 0;
+
+	mutex_lock(&dev->struct_mutex);
+
+	/*
+	 * get offset of memory allocated for drm framebuffer.
+	 * - this callback would be called by user application
+	 *	with DRM_IOCTL_MODE_MAP_DUMB command.
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
+
+int mtk_drm_gem_mmap(struct file *filp, struct vm_area_struct *vma)
+{
+	struct mtk_drm_gem_obj *mtk_gem;
+	struct drm_gem_object *gem;
+	int ret;
+
+	/* set vm_area_struct. */
+	ret = drm_gem_mmap(filp, vma);
+	if (ret) {
+		DRM_ERROR("failed to mmap.\n");
+		return ret;
+	}
+
+	gem = vma->vm_private_data;
+	mtk_gem = to_mtk_gem_obj(gem);
+
+	if (mtk_gem->flags == 0) {
+		/*
+		 * get page frame number to physical memory to be mapped
+		 * to user space.
+		 */
+		ret = remap_pfn_range(vma, vma->vm_start,
+			mtk_gem->buffer->paddr >> PAGE_SHIFT,
+			vma->vm_end - vma->vm_start, vma->vm_page_prot);
+	} else {
+		struct drm_file *file_priv = filp->private_data;
+		struct drm_device *dev = file_priv->minor->dev;
+		struct mtk_drm_gem_buf *buffer = mtk_gem->buffer;
+
+		vma->vm_flags |= VM_MIXEDMAP;
+
+		ret = dma_mmap_attrs(dev->dev, vma, buffer->kvaddr,
+			buffer->mva_addr, buffer->size, &buffer->dma_attrs);
+		if (ret) {
+			DRM_ERROR("failed to remap dma %d\n", ret);
+			return ret;
+		}
+	}
+
+	if (ret)
+		drm_gem_vm_close(vma);
+
+	return ret;
+}
+
+int mediatek_gem_map_offset_ioctl(struct drm_device *drm, void *data,
+				  struct drm_file *file_priv)
+{
+	struct drm_mtk_gem_map_off *args = data;
+
+	return mtk_drm_gem_dumb_map_offset(file_priv, drm, args->handle,
+						&args->offset);
+}
+
+int mediatek_gem_create_ioctl(struct drm_device *dev, void *data,
+			      struct drm_file *file_priv)
+{
+	struct mtk_drm_gem_obj *mtk_gem;
+	struct drm_mtk_gem_create *args = data;
+	int ret;
+
+	mtk_gem = mtk_drm_gem_create(dev, 3, args->size);
+
+	if (IS_ERR(mtk_gem))
+		return PTR_ERR(mtk_gem);
+
+	/*
+	 * allocate a id of idr table where the obj is registered
+	 * and handle has the id what user can see.
+	 */
+	ret = drm_gem_handle_create(file_priv, &mtk_gem->base, &args->handle);
+	if (ret)
+		return ret;
+
+	/* drop reference from allocate - handle holds it now. */
+	drm_gem_object_unreference_unlocked(&mtk_gem->base);
+
+	return 0;
+}
+
+
diff --git a/drivers/gpu/drm/mediatek/mediatek_drm_gem.h b/drivers/gpu/drm/mediatek/mediatek_drm_gem.h
new file mode 100644
index 0000000..1529481
--- /dev/null
+++ b/drivers/gpu/drm/mediatek/mediatek_drm_gem.h
@@ -0,0 +1,94 @@
+/*
+ * Copyright (c) 2015 MediaTek Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef _MEDIATEK_DRM_GEM_H_
+#define _MEDIATEK_DRM_GEM_H_
+
+#include <drm/drm_gem.h>
+
+struct drm_gem_object;
+
+/*
+ * mtk drm gem buffer structure.
+ *
+ * @kvaddr: kernel virtual address to allocated memory region.
+ * @dma_addr: bus address(accessed by dma) to allocated memory region.
+ *	- this address could be physical address without IOMMU and
+ *	device address with IOMMU.
+ * @sgt: sg table to transfer page data.
+ * @pages: contain all pages to allocated memory region.
+ * @size: size of allocated memory region.
+ */
+struct mtk_drm_gem_buf {
+	void __iomem	*kvaddr;
+	dma_addr_t		dma_addr;
+	struct dma_attrs	dma_attrs;
+	struct sg_table	*sgt;
+	struct page		**pages;
+	unsigned long	size;
+	unsigned int	mva_addr;
+	unsigned int	paddr;
+};
+
+/*
+ * mtk drm buffer structure.
+ *
+ * @base: a gem object.
+ *	- a new handle to this gem object would be created
+ *	by drm_gem_handle_create().
+ * @buffer: a pointer to mtk_drm_gem_buffer object.
+ *	- contain the information to memory region allocated
+ *	by user request or at framebuffer creation.
+ *	continuous memory region allocated by user request
+ *	or at framebuffer creation.
+ * @size: total memory size to physically non-continuous memory region.
+ * @flags: indicate memory type to allocated buffer and cache attruibute.
+ *
+ * P.S. this object would be transferred to user as kms_bo.handle so
+ *	user can access the buffer through kms_bo.handle.
+ */
+struct mtk_drm_gem_obj {
+	struct drm_gem_object	base;
+	struct mtk_drm_gem_buf	*buffer;
+	unsigned long			size;
+	unsigned int			flags;
+};
+
+#define to_mtk_gem_obj(x)	container_of(x, struct mtk_drm_gem_obj, base)
+
+struct mtk_drm_gem_obj *mtk_drm_gem_init(struct drm_device *dev,
+						      unsigned long size);
+void mtk_drm_gem_free_object(struct drm_gem_object *gem);
+struct mtk_drm_gem_obj *mtk_drm_gem_create(struct drm_device *dev,
+				unsigned int flags,	unsigned long size);
+int mtk_drm_gem_dumb_create(struct drm_file *file_priv,
+		struct drm_device *dev,	struct drm_mode_create_dumb *args);
+int mtk_drm_gem_dumb_map_offset(struct drm_file *file_priv,
+		struct drm_device *dev, uint32_t handle, uint64_t *offset);
+int mtk_drm_gem_mmap(struct file *filp, struct vm_area_struct *vma);
+
+/*
+ * request gem object creation and buffer allocation as the size
+ * that it is calculated with framebuffer information such as width,
+ * height and bpp.
+ */
+int mediatek_gem_create_ioctl(struct drm_device *dev, void *data,
+			      struct drm_file *file_priv);
+
+/* get buffer offset to map to user space. */
+int mediatek_gem_map_offset_ioctl(struct drm_device *dev, void *data,
+				  struct drm_file *file_priv);
+
+
+#endif
+
diff --git a/include/uapi/drm/mediatek_drm.h b/include/uapi/drm/mediatek_drm.h
new file mode 100644
index 0000000..19ea357
--- /dev/null
+++ b/include/uapi/drm/mediatek_drm.h
@@ -0,0 +1,59 @@
+/*
+ * Copyright (c) 2015 MediaTek Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+
+#ifndef _UAPI_MEDIATEK_DRM_H
+#define _UAPI_MEDIATEK_DRM_H
+
+#include <drm/drm.h>
+
+/**
+ * User-desired buffer creation information structure.
+ *
+ * @size: user-desired memory allocation size.
+ *	- this size value would be page-aligned internally.
+ * @flags: user request for setting memory type or cache attributes.
+ * @handle: returned a handle to created gem object.
+ *	- this handle will be set by gem module of kernel side.
+ */
+struct drm_mtk_gem_create {
+	uint64_t size;
+	uint32_t flags;
+	uint32_t handle;
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
+struct drm_mtk_gem_map_off {
+	uint32_t handle;
+	uint32_t pad;
+	uint64_t offset;
+};
+
+#define DRM_MTK_GEM_CREATE		0x00
+#define DRM_MTK_GEM_MAP_OFFSET		0x01
+
+#define DRM_IOCTL_MTK_GEM_CREATE	DRM_IOWR(DRM_COMMAND_BASE + \
+		DRM_MTK_GEM_CREATE, struct drm_mtk_gem_create)
+
+#define DRM_IOCTL_MTK_GEM_MAP_OFFSET	DRM_IOWR(DRM_COMMAND_BASE + \
+		DRM_MTK_GEM_MAP_OFFSET, struct drm_mtk_gem_map_off)
+
+
+#endif /* _UAPI_MEDIATEK_DRM_H */
-- 
1.8.1.1.dirty
