From: mark yao <yzq-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
Subject: [PATCH 5/9] drm: add Rockchip rk3288 lcd controller driver
Date: Mon,  4 Aug 2014 12:51:46 +0800
Message-ID: <1407127906-1790-1-git-send-email-yzq@rock-chips.com>
References: <1407127274-1356-1-git-send-email-mark.yao@rock-chips.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1407127274-1356-1-git-send-email-mark.yao-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: heiko-4mtYJXux2i+zQB+pC5nmwQ@public.gmane.org, Rob Clark <robdclark-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, David Airlie <airlied-cv59FeDIM0c@public.gmane.org>, Grant Likely <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Rom Lemarchand <romlem-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, olof-nZhT3qVonbNeoWH0uzbU5w@public.gmane.org, djkurtz-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, xjq-TNX95d0MmH7DzftRWevZcw@public.gmane.org, kfx-TNX95d0MmH7DzftRWevZcw@public.gmane.org, cym-TNX95d0MmH7DzftRWevZcw@public.gmane.org, cf-TNX95d0MmH7DzftRWevZcw@public.gmane.org, zyw-TNX95d0MmH7DzftRWevZcw@public.gmane.org, zwl-TNX95d0MmH7DzftRWevZcw@public.gmane.org, xxm-TNX95d0MmH7DzftRWevZcw@public.gmane.org, huangtao-TNX95d0MmH7DzftRWevZcw@public.gmane.org, kever.yang-TNX95d0MmH7DzftRWevZcw@public.gmane.org, zhangqing-TNX95d0MmH7DzftRWevZcw@public.gmane.org, yxj-TNX95d0MmH7DzftRWevZcw@public.gmane.org, wxt-TNX95d0MmH7DzftRWevZcw@public.gmane.org, xw-TNX95d0MmH7DzftRWevZcw@public.gmane.org, mark yao <yzq-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Signed-off-by: mark yao <yzq-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
---
 drivers/gpu/drm/rockchip/Kconfig            |    2 +
 drivers/gpu/drm/rockchip/Makefile           |    2 +-
 drivers/gpu/drm/rockchip/lcdc/Kconfig       |    9 +
 drivers/gpu/drm/rockchip/lcdc/Makefile      |    4 +
 drivers/gpu/drm/rockchip/lcdc/rk3288_lcdc.c |  819 ++++++++++++++++++
 drivers/gpu/drm/rockchip/lcdc/rk3288_lcdc.h | 1202 +++++++++++++++++++++++++++
 6 files changed, 2037 insertions(+), 1 deletion(-)
 create mode 100644 drivers/gpu/drm/rockchip/lcdc/Kconfig
 create mode 100644 drivers/gpu/drm/rockchip/lcdc/Makefile
 create mode 100644 drivers/gpu/drm/rockchip/lcdc/rk3288_lcdc.c
 create mode 100644 drivers/gpu/drm/rockchip/lcdc/rk3288_lcdc.h

diff --git a/drivers/gpu/drm/rockchip/Kconfig b/drivers/gpu/drm/rockchip/Kconfig
index 592e999..ccce827 100644
--- a/drivers/gpu/drm/rockchip/Kconfig
+++ b/drivers/gpu/drm/rockchip/Kconfig
@@ -38,3 +38,5 @@ config DRM_ROCKCHIP_CONNECTOR
 	  Choose this option if you want to use Rockchip Primary DISPLAY.
 	  The driver provides an abstraction for Rockchip display devices,
 	  such as lcd plane, lvds, edp , mipi, etc.
+
+source "drivers/gpu/drm/rockchip/lcdc/Kconfig"
diff --git a/drivers/gpu/drm/rockchip/Makefile b/drivers/gpu/drm/rockchip/Makefile
index a5e5132..6d49edc 100644
--- a/drivers/gpu/drm/rockchip/Makefile
+++ b/drivers/gpu/drm/rockchip/Makefile
@@ -9,5 +9,5 @@ rockchipdrm-y := rockchip_drm_drv.o rockchip_drm_gem.o \
 		rockchip_panel.o
 
 obj-$(CONFIG_DRM_ROCKCHIP_CONNECTOR) += rockchip_drm_connector.o
-obj-$(CONFIG_DRM_ROCKCHIP_LCDC) += rockchip_drm_lcdc.o
+obj-$(CONFIG_DRM_ROCKCHIP_LCDC) += rockchip_drm_lcdc.o lcdc/
 obj-$(CONFIG_DRM_ROCKCHIP) += rockchipdrm.o
diff --git a/drivers/gpu/drm/rockchip/lcdc/Kconfig b/drivers/gpu/drm/rockchip/lcdc/Kconfig
new file mode 100644
index 0000000..2b94057
--- /dev/null
+++ b/drivers/gpu/drm/rockchip/lcdc/Kconfig
@@ -0,0 +1,9 @@
+config LCDC_RK3288
+        bool "rk3288 lcdc support"
+        depends on DRM_ROCKCHIP_LCDC
+        help
+	  Choose this option if you have a rk3288 lcd controller.
+	  rk3288 lcdc is the display interface from memory frame buffer
+	  to display device. There are two lcd controllers on rk3288,
+	  They have same regs setting, can use same drivers. We use the
+	  lcdc id distinguish between them
diff --git a/drivers/gpu/drm/rockchip/lcdc/Makefile b/drivers/gpu/drm/rockchip/lcdc/Makefile
new file mode 100644
index 0000000..943dcd6
--- /dev/null
+++ b/drivers/gpu/drm/rockchip/lcdc/Makefile
@@ -0,0 +1,4 @@
+#
+# Makefile for the lcd control device driver.
+
+obj-$(CONFIG_LCDC_RK3288) += rk3288_lcdc.o
diff --git a/drivers/gpu/drm/rockchip/lcdc/rk3288_lcdc.c b/drivers/gpu/drm/rockchip/lcdc/rk3288_lcdc.c
new file mode 100644
index 0000000..f1b016c
--- /dev/null
+++ b/drivers/gpu/drm/rockchip/lcdc/rk3288_lcdc.c
@@ -0,0 +1,819 @@
+/*
+ * Copyright (C) Fuzhou Rockchip Electronics Co.Ltd
+ * Author:
+ *      hjc <hjc-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
+ *      mark yao <mark.yao-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#include <linux/clk.h>
+#include <linux/device.h>
+#include <linux/delay.h>
+#include <linux/interrupt.h>
+#include <linux/platform_device.h>
+#include <video/display_timing.h>
+#include <drm/rockchip_drm.h>
+#include <drm/drm_crtc.h>
+
+#ifdef CONFIG_OF
+#include <linux/of.h>
+#include <linux/of_gpio.h>
+#endif
+
+#include "../rockchip_drm_lcdc.h"
+#include "rk3288_lcdc.h"
+
+#define RK3288_LCDC_BIG_BASE 0xff930000
+#define RK3288_LCDC_LIT_BASE 0xff940000
+
+static struct lcdc_win_data lcdc_win[] = {
+	[0] = {
+		.id = 0,
+		.zpos = ZPOS_DEFAULT_WIN,
+		.fmt_10 = 0,
+		.win_lb_mode = 0x4,
+		.swap_rb = 0,
+	},
+	[1] = {
+		.id = 1,
+		.zpos = ZPOS_UNUSED_WIN,
+		.fmt_10 = 0,
+		.win_lb_mode = 0x4,
+		.swap_rb = 0,
+	},
+	[2] = {
+		.id = 2,
+		.zpos = ZPOS_CURSOR_WIN,
+		.fmt_10 = 0,
+		.win_lb_mode = 0x4,
+		.swap_rb = 0,
+	},
+	[3] = {
+		.id = 3,
+		.zpos = ZPOS_UNUSED_WIN,
+	},
+};
+
+static void rk3288_lcdc_win_commit(struct lcdc_driver *lcdc_drv,
+				   struct lcdc_win_data *win);
+static void rk3288_lcdc_dpms(struct lcdc_driver *lcdc_drv, int mode);
+
+static int rk3288_lcdc_get_id(u32 phy_base)
+{
+	if (phy_base == RK3288_LCDC_BIG_BASE)
+		return 0;
+	else if (phy_base == RK3288_LCDC_LIT_BASE)
+		return 1;
+	else
+		return -EINVAL;
+}
+
+static int rk3288_lcdc_clk_enable(struct lcdc_device *lcdc_dev)
+{
+	int ret = 0;
+
+	if (!lcdc_dev->clk_on) {
+		ret = clk_prepare_enable(lcdc_dev->hclk);
+		if (ret < 0) {
+			dev_err(lcdc_dev->dev, "failed to enable hclk\n");
+			return ret;
+		}
+
+		ret = clk_prepare_enable(lcdc_dev->dclk);
+		if (ret < 0) {
+			dev_err(lcdc_dev->dev, "failed to enable dclk\n");
+			goto err_dclk;
+		}
+
+		clk_prepare_enable(lcdc_dev->aclk);
+		if (ret < 0) {
+			dev_err(lcdc_dev->dev, "failed to enable aclk\n");
+			goto err_aclk;
+		}
+
+		spin_lock(&lcdc_dev->reg_lock);
+		lcdc_dev->clk_on = 1;
+		spin_unlock(&lcdc_dev->reg_lock);
+	}
+
+	return ret;
+err_aclk:
+	clk_disable_unprepare(lcdc_dev->aclk);
+err_dclk:
+	clk_disable_unprepare(lcdc_dev->hclk);
+	return ret;
+}
+
+static void rk3288_lcdc_clk_disable(struct lcdc_device *lcdc_dev)
+{
+	if (lcdc_dev->clk_on) {
+		spin_lock(&lcdc_dev->reg_lock);
+		lcdc_dev->clk_on = 0;
+		spin_unlock(&lcdc_dev->reg_lock);
+		mdelay(25);
+		clk_disable_unprepare(lcdc_dev->dclk);
+		clk_disable_unprepare(lcdc_dev->hclk);
+		clk_disable_unprepare(lcdc_dev->aclk);
+	}
+}
+
+static void rk3288_lcdc_disable_irq(struct lcdc_device *lcdc_dev)
+{
+	u32 mask, val;
+
+	if (likely(lcdc_dev->clk_on)) {
+		spin_lock(&lcdc_dev->reg_lock);
+		mask = M_DSP_HOLD_VALID_INTR_EN | M_FS_INTR_EN |
+			M_LINE_FLAG_INTR_EN | M_BUS_ERROR_INTR_EN;
+		val = V_DSP_HOLD_VALID_INTR_EN(0) | V_FS_INTR_EN(0) |
+			V_LINE_FLAG_INTR_EN(0) | V_BUS_ERROR_INTR_EN(0);
+		lcdc_msk_reg(lcdc_dev, INTR_CTRL0, mask, val);
+
+		mask = M_DSP_HOLD_VALID_INTR_CLR | M_FS_INTR_CLR |
+			M_LINE_FLAG_INTR_CLR | M_LINE_FLAG_INTR_CLR;
+		val = V_DSP_HOLD_VALID_INTR_CLR(0) | V_FS_INTR_CLR(0) |
+			V_LINE_FLAG_INTR_CLR(0) | V_BUS_ERROR_INTR_CLR(0);
+		lcdc_msk_reg(lcdc_dev, INTR_CTRL0, mask, val);
+
+		mask = M_WIN0_EMPTY_INTR_EN | M_WIN1_EMPTY_INTR_EN |
+			M_WIN2_EMPTY_INTR_EN | M_WIN3_EMPTY_INTR_EN |
+			M_HWC_EMPTY_INTR_EN | M_POST_BUF_EMPTY_INTR_EN |
+			M_POST_BUF_EMPTY_INTR_EN;
+		val = V_WIN0_EMPTY_INTR_EN(0) | V_WIN1_EMPTY_INTR_EN(0) |
+			V_WIN2_EMPTY_INTR_EN(0) | V_WIN3_EMPTY_INTR_EN(0) |
+			V_HWC_EMPTY_INTR_EN(0) | V_POST_BUF_EMPTY_INTR_EN(0) |
+			V_PWM_GEN_INTR_EN(0);
+		lcdc_msk_reg(lcdc_dev, INTR_CTRL1, mask, val);
+
+		mask = M_WIN0_EMPTY_INTR_CLR | M_WIN1_EMPTY_INTR_CLR |
+			M_WIN2_EMPTY_INTR_CLR | M_WIN3_EMPTY_INTR_CLR |
+			M_HWC_EMPTY_INTR_CLR | M_POST_BUF_EMPTY_INTR_CLR |
+			M_POST_BUF_EMPTY_INTR_CLR;
+		val = V_WIN0_EMPTY_INTR_CLR(0) | V_WIN1_EMPTY_INTR_CLR(0) |
+			V_WIN2_EMPTY_INTR_CLR(0) | V_WIN3_EMPTY_INTR_CLR(0) |
+			V_HWC_EMPTY_INTR_CLR(0) |
+			V_POST_BUF_EMPTY_INTR_CLR(0) |
+			V_PWM_GEN_INTR_CLR(0);
+		lcdc_msk_reg(lcdc_dev, INTR_CTRL1, mask, val);
+		lcdc_cfg_done(lcdc_dev);
+		spin_unlock(&lcdc_dev->reg_lock);
+	}
+}
+
+static void rk3288_lcdc_enable_irq(struct lcdc_device *lcdc_dev)
+{
+	u32 mask, val;
+
+	if (likely(lcdc_dev->clk_on)) {
+		spin_lock(&lcdc_dev->reg_lock);
+		mask = M_FS_INTR_CLR | M_FS_INTR_EN;
+		val = V_FS_INTR_CLR(1) | V_FS_INTR_EN(1);
+		lcdc_msk_reg(lcdc_dev, INTR_CTRL0, mask, val);
+		spin_unlock(&lcdc_dev->reg_lock);
+	}
+}
+
+static irqreturn_t rk3288_lcdc_isr(int irq, void *dev_id)
+{
+	struct lcdc_device *lcdc_dev =
+			(struct lcdc_device *)dev_id;
+	u32 intr0_reg;
+
+	intr0_reg = lcdc_readl(lcdc_dev, INTR_CTRL0);
+	if (intr0_reg & M_FS_INTR_STS) {
+		lcdc_msk_reg(lcdc_dev, INTR_CTRL0, M_FS_INTR_CLR,
+			     V_FS_INTR_CLR(1));
+		lcdc_vsync_event_handler(lcdc_dev->dev);
+	}
+
+	return IRQ_HANDLED;
+}
+
+static void rk3288_lcdc_alpha_cfg(struct lcdc_device *lcdc_dev,
+				  struct lcdc_win_data *layer)
+{
+	struct alpha_config alpha_config;
+
+	u32 mask, val;
+	int ppixel_alpha, global_alpha;
+	u32 src_alpha_ctl, dst_alpha_ctl;
+
+	ppixel_alpha = ((layer->format == ARGB888) ||
+			(layer->format == ABGR888)) ? 1 : 0;
+	global_alpha = (layer->g_alpha_val == 0) ? 0 : 1;
+	alpha_config.src_global_alpha_val = layer->g_alpha_val;
+	layer->alpha_mode = AB_SRC_OVER;
+	switch (layer->alpha_mode) {
+	case AB_USER_DEFINE:
+		break;
+	case AB_CLEAR:
+		alpha_config.src_factor_mode = AA_ZERO;
+		alpha_config.dst_factor_mode = AA_ZERO;
+		break;
+	case AB_SRC:
+		alpha_config.src_factor_mode = AA_ONE;
+		alpha_config.dst_factor_mode = AA_ZERO;
+		break;
+	case AB_DST:
+		alpha_config.src_factor_mode = AA_ZERO;
+		alpha_config.dst_factor_mode = AA_ONE;
+		break;
+	case AB_SRC_OVER:
+		alpha_config.src_color_mode = AA_SRC_PRE_MUL;
+		if (global_alpha)
+			alpha_config.src_factor_mode = AA_SRC_GLOBAL;
+		else
+			alpha_config.src_factor_mode = AA_ONE;
+		alpha_config.dst_factor_mode = AA_SRC_INVERSE;
+		break;
+	case AB_DST_OVER:
+		alpha_config.src_color_mode = AA_SRC_PRE_MUL;
+		alpha_config.src_factor_mode = AA_SRC_INVERSE;
+		alpha_config.dst_factor_mode = AA_ONE;
+		break;
+	case AB_SRC_IN:
+		alpha_config.src_color_mode = AA_SRC_PRE_MUL;
+		alpha_config.src_factor_mode = AA_SRC;
+		alpha_config.dst_factor_mode = AA_ZERO;
+		break;
+	case AB_DST_IN:
+		alpha_config.src_factor_mode = AA_ZERO;
+		alpha_config.dst_factor_mode = AA_SRC;
+		break;
+	case AB_SRC_OUT:
+		alpha_config.src_color_mode = AA_SRC_PRE_MUL;
+		alpha_config.src_factor_mode = AA_SRC_INVERSE;
+		alpha_config.dst_factor_mode = AA_ZERO;
+		break;
+	case AB_DST_OUT:
+		alpha_config.src_factor_mode = AA_ZERO;
+		alpha_config.dst_factor_mode = AA_SRC_INVERSE;
+		break;
+	case AB_SRC_ATOP:
+		alpha_config.src_color_mode = AA_SRC_PRE_MUL;
+		alpha_config.src_factor_mode = AA_SRC;
+		alpha_config.dst_factor_mode = AA_SRC_INVERSE;
+		break;
+	case AB_DST_ATOP:
+		alpha_config.src_color_mode = AA_SRC_PRE_MUL;
+		alpha_config.src_factor_mode = AA_SRC_INVERSE;
+		alpha_config.dst_factor_mode = AA_SRC;
+		break;
+	case XOR:
+		alpha_config.src_color_mode = AA_SRC_PRE_MUL;
+		alpha_config.src_factor_mode = AA_SRC_INVERSE;
+		alpha_config.dst_factor_mode = AA_SRC_INVERSE;
+		break;
+	case AB_SRC_OVER_GLOBAL:
+		alpha_config.src_global_alpha_mode = AA_PER_PIX_GLOBAL;
+		alpha_config.src_color_mode = AA_SRC_NO_PRE_MUL;
+		alpha_config.src_factor_mode = AA_SRC_GLOBAL;
+		alpha_config.dst_factor_mode = AA_SRC_INVERSE;
+		break;
+	default:
+		pr_err("alpha mode error\n");
+		break;
+	}
+	if ((ppixel_alpha == 1) && (global_alpha == 1))
+		alpha_config.src_global_alpha_mode = AA_PER_PIX_GLOBAL;
+	else if (ppixel_alpha == 1)
+		alpha_config.src_global_alpha_mode = AA_PER_PIX;
+	else if (global_alpha == 1)
+		alpha_config.src_global_alpha_mode = AA_GLOBAL;
+	else
+		dev_warn(lcdc_dev->dev, "alpha_en should be 0\n");
+	alpha_config.src_alpha_mode = AA_STRAIGHT;
+	alpha_config.src_alpha_cal_m0 = AA_NO_SAT;
+
+	switch (layer->id) {
+	case 0:
+		src_alpha_ctl = 0x60;
+		dst_alpha_ctl = 0x64;
+		break;
+	case 1:
+		src_alpha_ctl = 0xa0;
+		dst_alpha_ctl = 0xa4;
+		break;
+	case 2:
+		src_alpha_ctl = 0xdc;
+		dst_alpha_ctl = 0xec;
+		break;
+	case 3:
+		src_alpha_ctl = 0x12c;
+		dst_alpha_ctl = 0x13c;
+		break;
+	}
+	mask = M_WIN0_DST_FACTOR_M0;
+	val = V_WIN0_DST_FACTOR_M0(alpha_config.dst_factor_mode);
+	lcdc_msk_reg(lcdc_dev, dst_alpha_ctl, mask, val);
+	mask = M_WIN0_SRC_ALPHA_EN | M_WIN0_SRC_COLOR_M0 |
+		M_WIN0_SRC_ALPHA_M0 | M_WIN0_SRC_BLEND_M0 |
+		M_WIN0_SRC_ALPHA_CAL_M0 | M_WIN0_SRC_FACTOR_M0|
+		M_WIN0_SRC_GLOBAL_ALPHA;
+	val = V_WIN0_SRC_ALPHA_EN(1) |
+		V_WIN0_SRC_COLOR_M0(alpha_config.src_color_mode) |
+		V_WIN0_SRC_ALPHA_M0(alpha_config.src_alpha_mode) |
+		V_WIN0_SRC_BLEND_M0(alpha_config.src_global_alpha_mode) |
+		V_WIN0_SRC_ALPHA_CAL_M0(alpha_config.src_alpha_cal_m0) |
+		V_WIN0_SRC_FACTOR_M0(alpha_config.src_factor_mode) |
+		V_WIN0_SRC_GLOBAL_ALPHA(alpha_config.src_global_alpha_val);
+	lcdc_msk_reg(lcdc_dev, src_alpha_ctl, mask, val);
+}
+
+static void rk3288_lcdc_win01_set(struct lcdc_device *lcdc_dev,
+				  struct lcdc_win_data *win)
+{
+	unsigned int mask, val;
+	unsigned int off = win->id * 0x40;
+	struct drm_display_mode *mode = lcdc_dev->mode;
+
+	spin_lock(&lcdc_dev->reg_lock);
+
+	if (mode && win->enabled) {
+		u32 dsp_stx = win->xpos + mode->htotal - mode->hsync_start;
+		u32 dsp_sty = win->ypos + mode->vtotal - mode->vsync_start;
+
+		mask = M_WIN0_EN | M_WIN0_DATA_FMT | M_WIN0_FMT_10 |
+			M_WIN0_LB_MODE | M_WIN0_RB_SWAP;
+		val = V_WIN0_EN(1) | V_WIN0_DATA_FMT(win->format) |
+			V_WIN0_FMT_10(win->fmt_10) |
+			V_WIN0_LB_MODE(win->win_lb_mode) |
+			V_WIN0_RB_SWAP(win->swap_rb);
+		lcdc_msk_reg(lcdc_dev, WIN0_CTRL0+off, mask, val);
+
+		mask = M_WIN0_BIC_COE_SEL |
+			M_WIN0_VSD_YRGB_GT4 | M_WIN0_VSD_YRGB_GT2 |
+			M_WIN0_VSD_CBR_GT4 | M_WIN0_VSD_CBR_GT2 |
+			M_WIN0_YRGB_HOR_SCL_MODE | M_WIN0_YRGB_VER_SCL_MODE |
+			M_WIN0_YRGB_HSD_MODE | M_WIN0_YRGB_VSU_MODE |
+			M_WIN0_YRGB_VSD_MODE | M_WIN0_CBR_HOR_SCL_MODE |
+			M_WIN0_CBR_VER_SCL_MODE | M_WIN0_CBR_HSD_MODE |
+			M_WIN0_CBR_VSU_MODE | M_WIN0_CBR_VSD_MODE;
+		val = V_WIN0_BIC_COE_SEL(win->bic_coe_el) |
+			V_WIN0_VSD_YRGB_GT4(win->vsd_yrgb_gt4) |
+			V_WIN0_VSD_YRGB_GT2(win->vsd_yrgb_gt2) |
+			V_WIN0_VSD_CBR_GT4(win->vsd_cbr_gt4) |
+			V_WIN0_VSD_CBR_GT2(win->vsd_cbr_gt2) |
+			V_WIN0_YRGB_HOR_SCL_MODE(win->yrgb_hor_scl_mode) |
+			V_WIN0_YRGB_VER_SCL_MODE(win->yrgb_ver_scl_mode) |
+			V_WIN0_YRGB_HSD_MODE(win->yrgb_hsd_mode) |
+			V_WIN0_YRGB_VSU_MODE(win->yrgb_vsu_mode) |
+			V_WIN0_YRGB_VSD_MODE(win->yrgb_vsd_mode) |
+			V_WIN0_CBR_HOR_SCL_MODE(win->cbr_hor_scl_mode) |
+			V_WIN0_CBR_VER_SCL_MODE(win->cbr_ver_scl_mode) |
+			V_WIN0_CBR_HSD_MODE(win->cbr_hsd_mode) |
+			V_WIN0_CBR_VSU_MODE(win->cbr_vsu_mode) |
+			V_WIN0_CBR_VSD_MODE(win->cbr_vsd_mode);
+		lcdc_msk_reg(lcdc_dev, WIN0_CTRL1+off, mask, val);
+
+		val = V_WIN0_VIR_STRIDE(win->y_vir_stride) |
+			V_WIN0_VIR_STRIDE_UV(win->uv_vir_stride);
+		lcdc_writel(lcdc_dev, WIN0_VIR+off, val);
+		lcdc_writel(lcdc_dev, WIN0_YRGB_MST+off, win->yrgb_addr);
+		lcdc_writel(lcdc_dev, WIN0_CBR_MST+off, win->uv_addr);
+		val = V_WIN0_ACT_WIDTH(win->xact) |
+			V_WIN0_ACT_HEIGHT(win->yact);
+		lcdc_writel(lcdc_dev, WIN0_ACT_INFO+off, val);
+
+		val = V_WIN0_DSP_WIDTH(win->xsize) |
+			V_WIN0_DSP_HEIGHT(win->ysize);
+		lcdc_writel(lcdc_dev, WIN0_DSP_INFO+off, val);
+
+		val = V_WIN0_DSP_XST(dsp_stx) |
+			V_WIN0_DSP_YST(dsp_sty);
+		lcdc_writel(lcdc_dev, WIN0_DSP_ST+off, val);
+
+		val = V_WIN0_HS_FACTOR_YRGB(0x1000) |
+			V_WIN0_VS_FACTOR_YRGB(0x1000);
+		lcdc_writel(lcdc_dev, WIN0_SCL_FACTOR_YRGB+off, val);
+
+		val = V_WIN0_HS_FACTOR_CBR(0x1000) |
+			V_WIN0_VS_FACTOR_CBR(0x1000);
+		lcdc_writel(lcdc_dev, WIN0_SCL_FACTOR_CBR+off, val);
+
+		lcdc_writel(lcdc_dev, WIN0_COLOR_KEY, 0x80000000);
+		if (win->alpha_en == 1) {
+			rk3288_lcdc_alpha_cfg(lcdc_dev, win);
+		} else {
+			mask = M_WIN0_SRC_ALPHA_EN;
+			val = V_WIN0_SRC_ALPHA_EN(0);
+			lcdc_msk_reg(lcdc_dev,
+				     WIN0_SRC_ALPHA_CTRL+off, mask, val);
+		}
+	} else {
+		mask = M_WIN0_EN;
+		val = V_WIN0_EN(0);
+		lcdc_msk_reg(lcdc_dev, WIN0_CTRL0+off, mask, val);
+	}
+
+	spin_unlock(&lcdc_dev->reg_lock);
+}
+
+static void rk3288_lcdc_win23_set(struct lcdc_device *lcdc_dev,
+				  struct lcdc_win_data *win)
+{
+	unsigned int mask, val;
+	unsigned int off = (win->id-2) * 0x50;
+	struct drm_display_mode *mode = lcdc_dev->mode;
+
+	if (mode && win->enabled) {
+		u32 dsp_stx = win->xpos + mode->htotal - mode->hdisplay;
+		u32 dsp_sty = win->ypos + mode->vtotal - mode->vdisplay;
+
+		mask = M_WIN2_EN | M_WIN2_DATA_FMT | M_WIN2_RB_SWAP;
+		val = V_WIN2_EN(1) | V_WIN2_DATA_FMT(win->fmt_cfg) |
+			V_WIN2_RB_SWAP(win->swap_rb);
+		lcdc_msk_reg(lcdc_dev, WIN2_CTRL0+off, mask, val);
+		mask = M_WIN2_MST0_EN;
+		val = V_WIN2_MST0_EN(1);
+		lcdc_msk_reg(lcdc_dev, WIN2_CTRL0+off, mask, val);
+
+		mask = M_WIN2_VIR_STRIDE0;
+		val = V_WIN2_VIR_STRIDE0(win->y_vir_stride);
+		lcdc_msk_reg(lcdc_dev, WIN2_VIR0_1+off, mask, val);
+
+		lcdc_writel(lcdc_dev, WIN2_MST0+off, win->yrgb_addr);
+		val = V_WIN2_DSP_WIDTH0(win->xsize) |
+			V_WIN2_DSP_HEIGHT0(win->ysize);
+		lcdc_writel(lcdc_dev, WIN2_DSP_INFO0+off, val);
+		val = V_WIN2_DSP_XST0(dsp_stx) |
+			V_WIN2_DSP_YST0(dsp_sty);
+		lcdc_writel(lcdc_dev, WIN2_DSP_ST0+off, val);
+		if (win->alpha_en == 1) {
+			rk3288_lcdc_alpha_cfg(lcdc_dev, win);
+		} else {
+			mask = M_WIN2_SRC_ALPHA_EN;
+			val = V_WIN2_SRC_ALPHA_EN(0);
+			lcdc_msk_reg(lcdc_dev,
+				     WIN2_SRC_ALPHA_CTRL+off, mask, val);
+		}
+	} else {
+		mask = M_WIN2_EN | M_WIN2_MST0_EN |
+			M_WIN2_MST0_EN | M_WIN2_MST2_EN |
+			M_WIN2_MST3_EN;
+		val = V_WIN2_EN(0) | V_WIN2_MST0_EN(0) |
+			V_WIN2_MST1_EN(0) | V_WIN2_MST2_EN(0) |
+			V_WIN2_MST3_EN(0);
+		lcdc_msk_reg(lcdc_dev, WIN2_CTRL0+off, mask, val);
+	}
+}
+
+static int rk3288_lcdc_initial(struct lcdc_device *lcdc_dev)
+{
+	int i;
+
+	lcdc_dev->hclk = devm_clk_get(lcdc_dev->dev, "hclk_lcdc");
+	lcdc_dev->aclk = devm_clk_get(lcdc_dev->dev, "aclk_lcdc");
+	lcdc_dev->dclk = devm_clk_get(lcdc_dev->dev, "dclk_lcdc");
+
+	if ((IS_ERR(lcdc_dev->aclk)) || (IS_ERR(lcdc_dev->dclk)) ||
+	    (IS_ERR(lcdc_dev->hclk))) {
+		dev_err(lcdc_dev->dev, "failed to get lcdc%d clk source\n",
+			lcdc_dev->id);
+		return -ENODEV;
+	}
+
+	if (rk3288_lcdc_clk_enable(lcdc_dev) < 0) {
+		dev_err(lcdc_dev->dev, "failed to enable lcdc%d clks\n",
+			lcdc_dev->id);
+		return -ENODEV;
+	}
+
+	memcpy(lcdc_dev->regsbak, lcdc_dev->regs, lcdc_dev->len);
+
+	lcdc_set_bit(lcdc_dev, SYS_CTRL, M_AUTO_GATING_EN);
+	lcdc_cfg_done(lcdc_dev);
+
+	lcdc_dev->standby = DRM_MODE_DPMS_OFF;
+
+	for (i = 0; i < ARRAY_SIZE(lcdc_win); i++) {
+		lcdc_win[i].enabled = false;
+		rk3288_lcdc_win_commit(&lcdc_dev->lcdc_drv, &lcdc_win[i]);
+	}
+
+	return 0;
+}
+
+static struct lcdc_driver *rk3288_lcdc_init(struct platform_device *pdev)
+{
+	struct lcdc_device *lcdc_dev;
+	struct lcdc_driver *lcdc_drv;
+	struct device *dev = &pdev->dev;
+	struct resource *res;
+	struct device_node *np;
+	int ret = 0;
+
+	if (!dev->of_node)
+		return NULL;
+
+	np = pdev->dev.of_node;
+
+	/* if the primary lcdc has not registered, the extend
+	 * lcdc register later
+	*/
+	lcdc_dev = devm_kzalloc(dev, sizeof(struct lcdc_device), GFP_KERNEL);
+	if (!lcdc_dev) {
+		dev_err(&pdev->dev, "rk3288 lcdc device kmalloc fail!");
+		return NULL;
+	}
+	lcdc_dev->dev = dev;
+	lcdc_drv = &lcdc_dev->lcdc_drv;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	lcdc_dev->reg_phy_base = res->start;
+	lcdc_dev->len = resource_size(res);
+	lcdc_dev->regs = devm_ioremap_resource(dev, res);
+	if (IS_ERR(lcdc_dev->regs)) {
+		dev_err(&pdev->dev, "ioremap lcdc devices fail\n");
+		return NULL;
+	}
+
+	lcdc_dev->regsbak = devm_kzalloc(dev, lcdc_dev->len, GFP_KERNEL);
+	if (IS_ERR(lcdc_dev->regsbak)) {
+		dev_err(&pdev->dev, "lcdc devices kzalloc reg backup fail\n");
+		return NULL;
+	}
+
+	lcdc_dev->id = rk3288_lcdc_get_id(lcdc_dev->reg_phy_base);
+	if (lcdc_dev->id < 0) {
+		dev_err(&pdev->dev, "no such lcdc device id[%d]!\n",
+			lcdc_dev->id);
+		return NULL;
+	}
+
+	dev_set_name(lcdc_dev->dev, "lcdc%d", lcdc_dev->id);
+
+	lcdc_dev->irq = platform_get_irq(pdev, 0);
+	if (lcdc_dev->irq < 0) {
+		dev_err(&pdev->dev, "cannot find IRQ for lcdc%d\n",
+			lcdc_dev->id);
+		return NULL;
+	}
+
+	ret = devm_request_irq(dev, lcdc_dev->irq, rk3288_lcdc_isr,
+			       IRQF_DISABLED | IRQF_SHARED,
+			       dev_name(dev), lcdc_dev);
+	if (ret) {
+		dev_err(&pdev->dev, "cannot requeset irq %d - err %d\n",
+			lcdc_dev->irq, ret);
+		return NULL;
+	}
+
+	spin_lock_init(&lcdc_dev->reg_lock);
+
+	ret = rk3288_lcdc_initial(lcdc_dev);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "cannot initial lcdc dev - err %d\n", ret);
+		return NULL;
+	}
+
+	dev_info(dev, "lcdc%d probe ok\n", lcdc_dev->id);
+
+	return lcdc_drv;
+}
+
+static void rk3288_lcdc_deinit(struct lcdc_driver *lcdc_drv)
+{
+}
+
+static void rk3288_lcdc_dpms(struct lcdc_driver *lcdc_drv, int mode)
+{
+	struct lcdc_device *lcdc_dev =
+			container_of(lcdc_drv, struct lcdc_device, lcdc_drv);
+
+	if (lcdc_dev->standby == mode)
+		return;
+
+	if (mode == DRM_MODE_DPMS_ON) {
+		if (rk3288_lcdc_clk_enable(lcdc_dev) < 0) {
+			dev_err(lcdc_dev->dev, "failed to enable lcdc%d clks\n",
+				lcdc_dev->id);
+			return;
+		}
+
+		spin_lock(&lcdc_dev->reg_lock);
+		lcdc_msk_reg(lcdc_dev, SYS_CTRL, M_STANDBY_EN, V_STANDBY_EN(0));
+		spin_unlock(&lcdc_dev->reg_lock);
+	} else {
+		if (lcdc_dev->clk_on) {
+			spin_lock(&lcdc_dev->reg_lock);
+			lcdc_msk_reg(lcdc_dev, SYS_CTRL,
+				     M_STANDBY_EN, V_STANDBY_EN(1));
+			spin_unlock(&lcdc_dev->reg_lock);
+			rk3288_lcdc_clk_disable(lcdc_dev);
+		}
+	}
+
+	lcdc_dev->standby = mode;
+}
+
+static void rk3288_lcdc_mode_set(struct lcdc_driver *lcdc_drv,
+				 struct drm_display_mode *mode)
+{
+	struct lcdc_device *lcdc_dev =
+			container_of(lcdc_drv, struct lcdc_device, lcdc_drv);
+	struct rockchip_panel_special *priv_mode = (void *)mode->private;
+	u32 mask, val;
+	u16 x_res = mode->hdisplay;
+	u16 y_res = mode->vdisplay;
+	u16 h_total = mode->htotal;
+	u16 v_total = mode->vtotal;
+	u16 hsync_len = mode->hsync_end - mode->hsync_start;
+	u16 left_margin = mode->htotal - mode->hsync_end;
+	u16 vsync_len = mode->vsync_end - mode->vsync_start;
+	u16 upper_margin = mode->vtotal - mode->vsync_end;
+
+	u16 face = priv_mode->out_face;
+	u8 pin_hsync = (priv_mode->flags & DISPLAY_FLAGS_HSYNC_HIGH) ? 1 : 0;
+	u8 pin_vsync = (priv_mode->flags & DISPLAY_FLAGS_VSYNC_HIGH) ? 1 : 0;
+	u8 pin_den = (priv_mode->flags & DISPLAY_FLAGS_DE_HIGH) ? 1 : 0;
+	u8 pin_dclk = (priv_mode->flags &
+		       DISPLAY_FLAGS_PIXDATA_NEGEDGE) ? 1 : 0;
+	u8 swap_rb = (priv_mode->color_swap & ROCKCHIP_COLOR_SWAP_RB) ? 1 : 0;
+	u8 swap_rg = (priv_mode->color_swap & ROCKCHIP_COLOR_SWAP_RG) ? 1 : 0;
+	u8 swap_gb = (priv_mode->color_swap & ROCKCHIP_COLOR_SWAP_GB) ? 1 : 0;
+	u8 swap_dumy = 0;
+	u8 swap_delta = 0;
+	bool dither = priv_mode->dither;
+	u8 type = priv_mode->out_type;
+
+	spin_lock(&lcdc_dev->reg_lock);
+	if (likely(lcdc_dev->clk_on)) {
+		val = 0;
+		switch (face) {
+		case ROCKCHIP_OUTFACE_P565:
+			val = V_DITHER_DOWN_EN(1) | V_DITHER_DOWN_MODE(0) |
+				V_DITHER_DOWN_SEL(1);
+			break;
+		case ROCKCHIP_OUTFACE_P666:
+			val = V_DITHER_DOWN_EN(1) | V_DITHER_DOWN_MODE(1) |
+				V_DITHER_DOWN_SEL(1);
+			break;
+		case ROCKCHIP_OUTFACE_P888:
+			break;
+		default:
+			dev_err(lcdc_dev->dev, "un supported interface[%d]!\n",
+				face);
+			break;
+		}
+
+		mask = M_DITHER_DOWN_EN | M_DITHER_DOWN_MODE |
+			M_DITHER_DOWN_SEL;
+		lcdc_msk_reg(lcdc_dev, DSP_CTRL1, mask, val);
+
+		if (dither)
+			face = ROCKCHIP_OUTFACE_P888;
+
+		switch (type) {
+		case ROCKCHIP_DISPLAY_TYPE_RGB:
+		case ROCKCHIP_DISPLAY_TYPE_LVDS:
+			mask = M_RGB_OUT_EN;
+			val = V_RGB_OUT_EN(1);
+			break;
+		case ROCKCHIP_DISPLAY_TYPE_HDMI:
+			face = ROCKCHIP_OUTFACE_AAAA;
+			mask = M_HDMI_OUT_EN;
+			val = V_HDMI_OUT_EN(1);
+			break;
+		case ROCKCHIP_DISPLAY_TYPE_MIPI:
+			mask = M_MIPI_OUT_EN;
+			val = V_MIPI_OUT_EN(1);
+			break;
+		case ROCKCHIP_DISPLAY_TYPE_EDP:
+			face = ROCKCHIP_OUTFACE_AAAA;
+			mask = M_DITHER_DOWN_EN | M_DITHER_UP_EN;
+			val = V_DITHER_DOWN_EN(0) | V_DITHER_UP_EN(0);
+			lcdc_msk_reg(lcdc_dev, DSP_CTRL1, mask, val);
+			mask = M_EDP_OUT_EN;
+			val = V_EDP_OUT_EN(1);
+			break;
+		default:
+			dev_err(lcdc_dev->dev, "unsupported display type[%d]\n",
+				type);
+		}
+		lcdc_msk_reg(lcdc_dev, SYS_CTRL, mask, val);
+
+		mask = M_DSP_OUT_MODE | M_DSP_HSYNC_POL | M_DSP_VSYNC_POL |
+			M_DSP_DEN_POL | M_DSP_DCLK_POL | M_DSP_BG_SWAP |
+			M_DSP_RB_SWAP | M_DSP_RG_SWAP | M_DSP_DELTA_SWAP |
+			M_DSP_DUMMY_SWAP | M_DSP_OUT_ZERO | M_DSP_BLANK_EN |
+			M_DSP_BLACK_EN | M_DSP_X_MIR_EN | M_DSP_Y_MIR_EN;
+		val = V_DSP_OUT_MODE(face) | V_DSP_HSYNC_POL(pin_hsync) |
+			V_DSP_VSYNC_POL(pin_vsync) |
+			V_DSP_DEN_POL(pin_den) | V_DSP_DCLK_POL(pin_dclk) |
+			V_DSP_BG_SWAP(swap_gb) | V_DSP_RB_SWAP(swap_rb) |
+			V_DSP_RG_SWAP(swap_rg) |
+			V_DSP_DELTA_SWAP(swap_delta) |
+			V_DSP_DUMMY_SWAP(swap_dumy) | V_DSP_OUT_ZERO(0) |
+			V_DSP_BLANK_EN(0) | V_DSP_BLACK_EN(0);
+		lcdc_msk_reg(lcdc_dev, DSP_CTRL0, mask, val);
+
+		mask = M_DSP_BG_BLUE | M_DSP_BG_GREEN | M_DSP_BG_RED;
+		val = V_DSP_BG_BLUE(0) | V_DSP_BG_GREEN(0) | V_DSP_BG_RED(0);
+		lcdc_msk_reg(lcdc_dev, DSP_BG, mask, val);
+
+		mask = M_DSP_HS_PW | M_DSP_HTOTAL;
+		val = V_DSP_HS_PW(hsync_len) | V_DSP_HTOTAL(h_total);
+		lcdc_msk_reg(lcdc_dev, DSP_HTOTAL_HS_END, mask, val);
+
+		mask = M_DSP_HACT_END | M_DSP_HACT_ST;
+		val = V_DSP_HACT_END(hsync_len + left_margin + x_res) |
+			V_DSP_HACT_ST(hsync_len + left_margin);
+		lcdc_msk_reg(lcdc_dev, DSP_HACT_ST_END, mask, val);
+
+		mask = M_DSP_VS_PW | M_DSP_VTOTAL;
+		val = V_DSP_VS_PW(vsync_len) | V_DSP_VTOTAL(v_total);
+		lcdc_msk_reg(lcdc_dev, DSP_VTOTAL_VS_END, mask, val);
+
+		mask = M_DSP_VACT_END | M_DSP_VACT_ST;
+		val = V_DSP_VACT_END(vsync_len + upper_margin + y_res) |
+			V_DSP_VACT_ST(vsync_len + upper_margin);
+		lcdc_msk_reg(lcdc_dev, DSP_VACT_ST_END, mask, val);
+
+		mask = M_DSP_HACT_END_POST | M_DSP_HACT_ST_POST;
+		val = V_DSP_HACT_END_POST(hsync_len + left_margin + x_res) |
+			V_DSP_HACT_ST_POST(hsync_len + left_margin);
+		lcdc_msk_reg(lcdc_dev, POST_DSP_HACT_INFO, mask, val);
+
+		mask = M_DSP_VACT_END_POST | M_DSP_VACT_ST_POST;
+		val = V_DSP_VACT_END_POST(vsync_len + upper_margin + y_res) |
+			V_DSP_VACT_ST_POST(vsync_len + upper_margin);
+		lcdc_msk_reg(lcdc_dev, POST_DSP_VACT_INFO, mask, val);
+	}
+
+	spin_unlock(&lcdc_dev->reg_lock);
+	clk_set_rate(lcdc_dev->dclk, mode->clock * 1000);
+
+	lcdc_dev->mode = mode;
+}
+
+static void rk3288_lcdc_enable_vblank(struct lcdc_driver *lcdc_drv)
+{
+	rk3288_lcdc_enable_irq(container_of(lcdc_drv,
+					    struct lcdc_device, lcdc_drv));
+}
+
+static void rk3288_lcdc_disable_vblank(struct lcdc_driver *lcdc_drv)
+{
+	rk3288_lcdc_disable_irq(container_of(lcdc_drv,
+					     struct lcdc_device, lcdc_drv));
+}
+
+static struct lcdc_win_data *
+	rk3288_lcdc_get_win(struct lcdc_driver *lcdc_drv, int zpos)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(lcdc_win); i++) {
+		if (lcdc_win[i].zpos == zpos)
+			return &lcdc_win[i];
+	}
+
+	return NULL;
+}
+
+static void rk3288_lcdc_win_commit(struct lcdc_driver *lcdc_drv,
+				   struct lcdc_win_data *win)
+{
+	struct lcdc_device *lcdc_dev =
+			container_of(lcdc_drv, struct lcdc_device, lcdc_drv);
+	struct device *dev = lcdc_dev->dev;
+
+	switch (win->id) {
+	case 0:
+	case 1:
+		rk3288_lcdc_win01_set(lcdc_dev, win);
+		break;
+	case 2:
+	case 3:
+		rk3288_lcdc_win23_set(lcdc_dev, win);
+		break;
+	default:
+		dev_info(dev, "not support win%d\n", win->id);
+	}
+
+	spin_lock(&lcdc_dev->reg_lock);
+	lcdc_cfg_done(lcdc_dev);
+	spin_unlock(&lcdc_dev->reg_lock);
+}
+
+struct lcdc_driver_data rockchip_rk3288_lcdc = {
+	.init = rk3288_lcdc_init,
+	.deinit = rk3288_lcdc_deinit,
+	.dpms = rk3288_lcdc_dpms,
+	.mode_set = rk3288_lcdc_mode_set,
+	.enable_vblank = rk3288_lcdc_enable_vblank,
+	.disable_vblank = rk3288_lcdc_disable_vblank,
+	.get_win = rk3288_lcdc_get_win,
+	.win_commit = rk3288_lcdc_win_commit,
+	.num_win = ARRAY_SIZE(lcdc_win),
+};
diff --git a/drivers/gpu/drm/rockchip/lcdc/rk3288_lcdc.h b/drivers/gpu/drm/rockchip/lcdc/rk3288_lcdc.h
new file mode 100644
index 0000000..d2e1110
--- /dev/null
+++ b/drivers/gpu/drm/rockchip/lcdc/rk3288_lcdc.h
@@ -0,0 +1,1202 @@
+/*
+ * Copyright (C) Fuzhou Rockchip Electronics Co.Ltd
+ * Author:
+ *      hjc <hjc-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
+ *      mark yao <mark.yao-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#ifndef _RK3288_LCDC_H_
+#define _RK3288_LCDC_H_
+
+#define SET_BIT(x, bit) ((x) << (bit))
+#define SET_BIT_MASK(x, bit, mask) SET_BIT((x) & (mask), bit)
+
+#define GPIO		0
+#define REGULATOR	1
+
+/* register definition */
+#define REG_CFG_DONE			(0x0000)
+#define VERSION_INFO			(0x0004)
+#define M_RTL_VERSION			SET_BIT(0xffff, 0)
+#define M_FPGA_VERSION			SET_BIT(0xffff, 16)
+#define SYS_CTRL			(0x0008)
+#define V_DIRECT_PATH_EN(x)		SET_BIT_MASK(x, 0, 1)
+#define V_DIRECT_PATCH_SEL(x)		SET_BIT_MASK(x, 1, 3)
+#define V_DOUB_CHANNEL_EN(x)		SET_BIT_MASK(x, 3, 1)
+#define V_DOUB_CH_OVERLAP_NUM(x)	SET_BIT_MASK(x, 4, 0xf)
+#define V_EDPI_HALT_EN(x)		SET_BIT_MASK(x, 8, 1)
+#define V_EDPI_WMS_MODE(x)		SET_BIT_MASK(x, 9, 1)
+#define V_EDPI_WMS_FS(x)		SET_BIT_MASK(x, 10, 1)
+#define V_RGB_OUT_EN(x)			SET_BIT_MASK(x, 12, 1)
+#define V_HDMI_OUT_EN(x)		SET_BIT_MASK(x, 13, 1)
+#define V_EDP_OUT_EN(x)			SET_BIT_MASK(x, 14, 1)
+#define V_MIPI_OUT_EN(x)		SET_BIT_MASK(x, 15, 1)
+#define V_DMA_BURST_LENGTH(x)		SET_BIT_MASK(x, 18, 3)
+#define V_MMU_EN(x)			SET_BIT_MASK(x, 20, 1)
+#define V_DMA_STOP(x)			SET_BIT_MASK(x, 21, 1)
+#define V_STANDBY_EN(x)			SET_BIT_MASK(x, 22, 1)
+#define V_AUTO_GATING_EN(x)		SET_BIT_MASK(x, 23, 1)
+
+#define M_DIRECT_PATH_EN		SET_BIT(1, 0)
+#define M_DIRECT_PATCH_SEL		SET_BIT(3, 1)
+#define M_DOUB_CHANNEL_EN		SET_BIT(1, 3)
+#define M_DOUB_CH_OVERLAP_NUM		SET_BIT(0xf, 4)
+#define M_EDPI_HALT_EN			SET_BIT(1, 8)
+#define M_EDPI_WMS_MODE			SET_BIT(1, 9)
+#define M_EDPI_WMS_FS			SET_BIT(1, 10)
+#define M_RGB_OUT_EN			SET_BIT(1, 12)
+#define M_HDMI_OUT_EN			SET_BIT(1, 13)
+#define M_EDP_OUT_EN			SET_BIT(1, 14)
+#define M_MIPI_OUT_EN			SET_BIT(1, 15)
+#define M_DMA_BURST_LENGTH		SET_BIT(3, 18)
+#define M_MMU_EN			SET_BIT(1, 20)
+#define M_DMA_STOP			SET_BIT(1, 21)
+#define M_STANDBY_EN			SET_BIT(1, 22)
+#define M_AUTO_GATING_EN		SET_BIT(1, 23)
+#define SYS_CTRL1			(0x000c)
+#define V_NOC_HURRY_EN(x)		SET_BIT_MASK(x, 0, 0x1)
+#define V_NOC_HURRY_VALUE(x)		SET_BIT_MASK(x, 1, 0x3)
+#define V_NOC_HURRY_THRESHOLD(x)	SET_BIT_MASK(x, 3, 0x3f)
+#define V_NOC_QOS_EN(x)			SET_BIT_MASK(x, 9, 0x1)
+#define V_NOC_WIN_QOS(x)		SET_BIT_MASK(x, 10, 0x3)
+#define V_AXI_MAX_OUTSTANDING_EN(x)	SET_BIT_MASK(x, 12, 0x1)
+#define V_AXI_OUTSTANDING_MAX_NUM(x)	SET_BIT_MASK(x, 13, 0x1f)
+
+#define M_NOC_HURRY_EN			SET_BIT(0x1, 0)
+#define M_NOC_HURRY_VALUE		SET_BIT(0x3, 1)
+#define M_NOC_HURRY_THRESHOLD		SET_BIT(0x3f, 3)
+#define M_NOC_QOS_EN			SET_BIT(0x1, 9)
+#define M_NOC_WIN_QOS			SET_BIT(0x3, 10)
+#define M_AXI_MAX_OUTSTANDING_EN	SET_BIT(0x1, 12)
+#define M_AXI_OUTSTANDING_MAX_NUM	SET_BIT(0x1f, 13)
+
+#define DSP_CTRL0		(0x0010)
+#define V_DSP_OUT_MODE(x)	SET_BIT_MASK(x, 0, 0x0f)
+#define V_DSP_HSYNC_POL(x)	SET_BIT_MASK(x, 4, 1)
+#define V_DSP_VSYNC_POL(x)	SET_BIT_MASK(x, 5, 1)
+#define V_DSP_DEN_POL(x)	SET_BIT_MASK(x, 6, 1)
+#define V_DSP_DCLK_POL(x)	SET_BIT_MASK(x, 7, 1)
+#define V_DSP_DCLK_DDR(x)	SET_BIT_MASK(x, 8, 1)
+#define V_DSP_DDR_PHASE(x)	SET_BIT_MASK(x, 9, 1)
+#define V_DSP_INTERLACE(x)	SET_BIT_MASK(x, 10, 1)
+#define V_DSP_FIELD_POL(x)	SET_BIT_MASK(x, 11, 1)
+#define V_DSP_BG_SWAP(x)	SET_BIT_MASK(x, 12, 1)
+#define V_DSP_RB_SWAP(x)	SET_BIT_MASK(x, 13, 1)
+#define V_DSP_RG_SWAP(x)	SET_BIT_MASK(x, 14, 1)
+#define V_DSP_DELTA_SWAP(x)	SET_BIT_MASK(x, 15, 1)
+#define V_DSP_DUMMY_SWAP(x)	SET_BIT_MASK(x, 16, 1)
+#define V_DSP_OUT_ZERO(x)	SET_BIT_MASK(x, 17, 1)
+#define V_DSP_BLANK_EN(x)	SET_BIT_MASK(x, 18, 1)
+#define V_DSP_BLACK_EN(x)	SET_BIT_MASK(x, 19, 1)
+#define V_DSP_CCIR656_AVG(x)	SET_BIT_MASK(x, 20, 1)
+#define V_DSP_YUV_CLIP(x)	SET_BIT_MASK(x, 21, 1)
+#define V_DSP_X_MIR_EN(x)	SET_BIT_MASK(x, 22, 1)
+#define V_DSP_Y_MIR_EN(x)	SET_BIT_MASK(x, 23, 1)
+#define M_DSP_OUT_MODE		SET_BIT(0x0f, 0)
+#define M_DSP_HSYNC_POL		SET_BIT(1, 4)
+#define M_DSP_VSYNC_POL		SET_BIT(1, 5)
+#define M_DSP_DEN_POL		SET_BIT(1, 6)
+#define M_DSP_DCLK_POL		SET_BIT(1, 7)
+#define M_DSP_DCLK_DDR		SET_BIT(1, 8)
+#define M_DSP_DDR_PHASE		SET_BIT(1, 9)
+#define M_DSP_INTERLACE		SET_BIT(1, 10)
+#define M_DSP_FIELD_POL		SET_BIT(1, 11)
+#define M_DSP_BG_SWAP		SET_BIT(1, 12)
+#define M_DSP_RB_SWAP		SET_BIT(1, 13)
+#define M_DSP_RG_SWAP		SET_BIT(1, 14)
+#define M_DSP_DELTA_SWAP	SET_BIT(1, 15)
+#define M_DSP_DUMMY_SWAP	SET_BIT(1, 16)
+#define M_DSP_OUT_ZERO		SET_BIT(1, 17)
+#define M_DSP_BLANK_EN		SET_BIT(1, 18)
+#define M_DSP_BLACK_EN		SET_BIT(1, 19)
+#define M_DSP_CCIR656_AVG	SET_BIT(1, 20)
+#define M_DSP_YUV_CLIP		SET_BIT(1, 21)
+#define M_DSP_X_MIR_EN		SET_BIT(1, 22)
+#define M_DSP_Y_MIR_EN		SET_BIT(1, 23)
+
+#define DSP_CTRL1		(0x0014)
+#define V_DSP_LUT_EN(x)		SET_BIT_MASK(x, 0, 1)
+#define V_PRE_DITHER_DOWN_EN(x)	SET_BIT_MASK(x, 1, 1)
+#define V_DITHER_DOWN_EN(x)	SET_BIT_MASK(x, 2, 1)
+#define V_DITHER_DOWN_MODE(x)	SET_BIT_MASK(x, 3, 1)
+#define V_DITHER_DOWN_SEL(x)	SET_BIT_MASK(x, 4, 1)
+#define V_DITHER_UP_EN(x)	SET_BIT_MASK(x, 6, 1)
+#define V_DSP_LAYER0_SEL(x)	SET_BIT_MASK(x, 8, 3)
+#define V_DSP_LAYER1_SEL(x)	SET_BIT_MASK(x, 10, 3)
+#define V_DSP_LAYER2_SEL(x)	SET_BIT_MASK(x, 12, 3)
+#define V_DSP_LAYER3_SEL(x)	SET_BIT_MASK(x, 14, 3)
+#define M_DSP_LUT_EN		SET_BIT(1, 0)
+#define M_PRE_DITHER_DOWN_EN	SET_BIT(1, 1)
+#define M_DITHER_DOWN_EN	SET_BIT(1, 2)
+#define M_DITHER_DOWN_MODE	SET_BIT(1, 3)
+#define M_DITHER_DOWN_SEL	SET_BIT(1, 4)
+#define M_DITHER_UP_EN		SET_BIT(1, 6)
+#define M_DSP_LAYER0_SEL	SET_BIT(3, 8)
+#define M_DSP_LAYER1_SEL	SET_BIT(3, 10)
+#define M_DSP_LAYER2_SEL	SET_BIT(3, 12)
+#define M_DSP_LAYER3_SEL	SET_BIT(3, 14)
+
+#define DSP_BG			(0x0018)
+#define V_DSP_BG_BLUE(x)	SET_BIT_MASK(x << 2, 0, 0x3ff)
+#define V_DSP_BG_GREEN(x)	SET_BIT_MASK(x << 2, 10, 0x3ff)
+#define V_DSP_BG_RED(x)		SET_BIT_MASK(x << 2, 20, 0x3ff)
+#define M_DSP_BG_BLUE		SET_BIT(0x3ff, 0)
+#define M_DSP_BG_GREEN		SET_BIT(0x3ff, 10)
+#define M_DSP_BG_RED		SET_BIT(0x3ff, 20)
+
+#define MCU_CTRL		(0x001c)
+#define V_MCU_PIX_TOTAL(x)	SET_BIT_MASK(x, 0, 0x3f)
+#define V_MCU_CS_PST(x)		SET_BIT_MASK(x, 6, 0xf)
+#define V_MCU_CS_PEND(x)	SET_BIT_MASK(x, 10, 0x3f)
+#define V_MCU_RW_PST(x)		SET_BIT_MASK(x, 16, 0xf)
+#define V_MCU_RW_PEND(x)	SET_BIT_MASK(x, 20, 0x3f)
+#define V_MCU_CLK_SEL(x)	SET_BIT_MASK(x, 26, 1)
+#define V_MCU_HOLD_MODE(x)	SET_BIT_MASK(x, 27, 1)
+#define V_MCU_FRAME_ST(x)	SET_BIT_MASK(x, 28, 1)
+#define V_MCU_RS(x)		SET_BIT_MASK(x, 29, 1)
+#define V_MCU_BYPASS(x)		SET_BIT_MASK(x, 30, 1)
+#define V_MCU_TYPE(x)		SET_BIT_MASK(x, 31, 1)
+#define M_MCU_PIX_TOTAL		SET_BIT(0x3f, 0)
+#define M_MCU_CS_PST		SET_BIT(0xf, 6)
+#define M_MCU_CS_PEND		SET_BIT(0x3f, 10)
+#define M_MCU_RW_PST		SET_BIT(0xf, 16)
+#define M_MCU_RW_PEND		SET_BIT(0x3f, 20)
+#define M_MCU_CLK_SEL		SET_BIT(1, 26)
+#define M_MCU_HOLD_MODE		SET_BIT(1, 27)
+#define M_MCU_FRAME_ST		SET_BIT(1, 28)
+#define M_MCU_RS		SET_BIT(1, 29)
+#define M_MCU_BYPASS		SET_BIT(1, 30)
+#define M_MCU_TYPE		SET_BIT((u32)1, 31)
+
+#define INTR_CTRL0			(0x0020)
+#define V_DSP_HOLD_VALID_INTR_STS(x)	SET_BIT_MASK(x, 0, 1)
+#define V_FS_INTR_STS(x)		SET_BIT_MASK(x, 1, 1)
+#define V_LINE_FLAG_INTR_STS(x)		SET_BIT_MASK(x, 2, 1)
+#define V_BUS_ERROR_INTR_STS(x)		SET_BIT_MASK(x, 3, 1)
+#define V_DSP_HOLD_VALID_INTR_EN(x)	SET_BIT_MASK(x, 4, 1)
+#define V_FS_INTR_EN(x)			SET_BIT_MASK(x, 5, 1)
+#define V_LINE_FLAG_INTR_EN(x)		SET_BIT_MASK(x, 6, 1)
+#define V_BUS_ERROR_INTR_EN(x)		SET_BIT_MASK(x, 7, 1)
+#define V_DSP_HOLD_VALID_INTR_CLR(x)	SET_BIT_MASK(x, 8, 1)
+#define V_FS_INTR_CLR(x)		SET_BIT_MASK(x, 9, 1)
+#define V_LINE_FLAG_INTR_CLR(x)		SET_BIT_MASK(x, 10, 1)
+#define V_BUS_ERROR_INTR_CLR(x)		SET_BIT_MASK(x, 11, 1)
+#define V_DSP_LINE_FLAG_NUM(x)		SET_BIT_MASK(x, 12, 0xfff)
+
+#define M_DSP_HOLD_VALID_INTR_STS	SET_BIT(1, 0)
+#define M_FS_INTR_STS			SET_BIT(1, 1)
+#define M_LINE_FLAG_INTR_STS		SET_BIT(1, 2)
+#define M_BUS_ERROR_INTR_STS		SET_BIT(1, 3)
+#define M_DSP_HOLD_VALID_INTR_EN	SET_BIT(1, 4)
+#define M_FS_INTR_EN			SET_BIT(1, 5)
+#define M_LINE_FLAG_INTR_EN		SET_BIT(1, 6)
+#define M_BUS_ERROR_INTR_EN		SET_BIT(1, 7)
+#define M_DSP_HOLD_VALID_INTR_CLR	SET_BIT(1, 8)
+#define M_FS_INTR_CLR			SET_BIT(1, 9)
+#define M_LINE_FLAG_INTR_CLR		SET_BIT(1, 10)
+#define M_BUS_ERROR_INTR_CLR		SET_BIT(1, 11)
+#define M_DSP_LINE_FLAG_NUM		SET_BIT(0xfff, 12)
+
+#define INTR_CTRL1			(0x0024)
+#define V_WIN0_EMPTY_INTR_STS(x)	SET_BIT_MASK(x, 0, 1)
+#define V_WIN1_EMPTY_INTR_STS(x)	SET_BIT_MASK(x, 1, 1)
+#define V_WIN2_EMPTY_INTR_STS(x)	SET_BIT_MASK(x, 2, 1)
+#define V_WIN3_EMPTY_INTR_STS(x)	SET_BIT_MASK(x, 3, 1)
+#define V_HWC_EMPTY_INTR_STS(x)		SET_BIT_MASK(x, 4, 1)
+#define V_POST_BUF_EMPTY_INTR_STS(x)	SET_BIT_MASK(x, 5, 1)
+#define V_PWM_GEN_INTR_STS(x)		SET_BIT_MASK(x, 6, 1)
+#define V_WIN0_EMPTY_INTR_EN(x)		SET_BIT_MASK(x, 8, 1)
+#define V_WIN1_EMPTY_INTR_EN(x)		SET_BIT_MASK(x, 9, 1)
+#define V_WIN2_EMPTY_INTR_EN(x)		SET_BIT_MASK(x, 10, 1)
+#define V_WIN3_EMPTY_INTR_EN(x)		SET_BIT_MASK(x, 11, 1)
+#define V_HWC_EMPTY_INTR_EN(x)		SET_BIT_MASK(x, 12, 1)
+#define V_POST_BUF_EMPTY_INTR_EN(x)	SET_BIT_MASK(x, 13, 1)
+#define V_PWM_GEN_INTR_EN(x)		SET_BIT_MASK(x, 14, 1)
+#define V_WIN0_EMPTY_INTR_CLR(x)	SET_BIT_MASK(x, 16, 1)
+#define V_WIN1_EMPTY_INTR_CLR(x)	SET_BIT_MASK(x, 17, 1)
+#define V_WIN2_EMPTY_INTR_CLR(x)	SET_BIT_MASK(x, 18, 1)
+#define V_WIN3_EMPTY_INTR_CLR(x)	SET_BIT_MASK(x, 19, 1)
+#define V_HWC_EMPTY_INTR_CLR(x)		SET_BIT_MASK(x, 20, 1)
+#define V_POST_BUF_EMPTY_INTR_CLR(x)	SET_BIT_MASK(x, 21, 1)
+#define V_PWM_GEN_INTR_CLR(x)		SET_BIT_MASK(x, 22, 1)
+
+#define M_WIN0_EMPTY_INTR_STS		SET_BIT(1, 0)
+#define M_WIN1_EMPTY_INTR_STS		SET_BIT(1, 1)
+#define M_WIN2_EMPTY_INTR_STS		SET_BIT(1, 2)
+#define M_WIN3_EMPTY_INTR_STS		SET_BIT(1, 3)
+#define M_HWC_EMPTY_INTR_STS		SET_BIT(1, 4)
+#define M_POST_BUF_EMPTY_INTR_STS	SET_BIT(1, 5)
+#define M_PWM_GEN_INTR_STS		SET_BIT(1, 6)
+#define M_WIN0_EMPTY_INTR_EN		SET_BIT(1, 8)
+#define M_WIN1_EMPTY_INTR_EN		SET_BIT(1, 9)
+#define M_WIN2_EMPTY_INTR_EN		SET_BIT(1, 10)
+#define M_WIN3_EMPTY_INTR_EN		SET_BIT(1, 11)
+#define M_HWC_EMPTY_INTR_EN		SET_BIT(1, 12)
+#define M_POST_BUF_EMPTY_INTR_EN	SET_BIT(1, 13)
+#define M_PWM_GEN_INTR_EN		SET_BIT(1, 14)
+#define M_WIN0_EMPTY_INTR_CLR		SET_BIT(1, 16)
+#define M_WIN1_EMPTY_INTR_CLR		SET_BIT(1, 17)
+#define M_WIN2_EMPTY_INTR_CLR		SET_BIT(1, 18)
+#define M_WIN3_EMPTY_INTR_CLR		SET_BIT(1, 19)
+#define M_HWC_EMPTY_INTR_CLR		SET_BIT(1, 20)
+#define M_POST_BUF_EMPTY_INTR_CLR	SET_BIT(1, 21)
+#define M_PWM_GEN_INTR_CLR		SET_BIT(1, 22)
+
+/* win0 register */
+#define WIN0_CTRL0			(0x0030)
+#define V_WIN0_EN(x)			SET_BIT_MASK(x, 0, 1)
+#define V_WIN0_DATA_FMT(x)		SET_BIT_MASK(x, 1, 7)
+#define V_WIN0_FMT_10(x)		SET_BIT_MASK(x, 4, 1)
+#define V_WIN0_LB_MODE(x)		SET_BIT_MASK(x, 5, 7)
+#define V_WIN0_INTERLACE_READ(x)	SET_BIT_MASK(x, 8, 1)
+#define V_WIN0_NO_OUTSTANDING(x)	SET_BIT_MASK(x, 9, 1)
+#define V_WIN0_CSC_MODE(x)		SET_BIT_MASK(x, 10, 3)
+#define V_WIN0_RB_SWAP(x)		SET_BIT_MASK(x, 12, 1)
+#define V_WIN0_ALPHA_SWAP(x)		SET_BIT_MASK(x, 13, 1)
+#define V_WIN0_MID_SWAP(x)		SET_BIT_MASK(x, 14, 1)
+#define V_WIN0_UV_SWAP(x)		SET_BIT_MASK(x, 15, 1)
+#define V_WIN0_PPAS_ZERO_EN(x)		SET_BIT_MASK(x, 16, 1)
+#define V_WIN0_YRGB_DEFLICK(x)		SET_BIT_MASK(x, 18, 1)
+#define V_WIN0_CBR_DEFLICK(x)		SET_BIT_MASK(x, 19, 1)
+#define V_WIN0_YUV_CLIP(x)		SET_BIT_MASK(x, 20, 1)
+
+#define M_WIN0_EN			SET_BIT(1, 0)
+#define M_WIN0_DATA_FMT			SET_BIT(7, 1)
+#define M_WIN0_FMT_10			SET_BIT(1, 4)
+#define M_WIN0_LB_MODE			SET_BIT(7, 5)
+#define M_WIN0_INTERLACE_READ		SET_BIT(1, 8)
+#define M_WIN0_NO_OUTSTANDING		SET_BIT(1, 9)
+#define M_WIN0_CSC_MODE			SET_BIT(3, 10)
+#define M_WIN0_RB_SWAP			SET_BIT(1, 12)
+#define M_WIN0_ALPHA_SWAP		SET_BIT(1, 13)
+#define M_WIN0_MID_SWAP			SET_BIT(1, 14)
+#define M_WIN0_UV_SWAP			SET_BIT(1, 15)
+#define M_WIN0_PPAS_ZERO_EN		SET_BIT(1, 16)
+#define M_WIN0_YRGB_DEFLICK		SET_BIT(1, 18)
+#define M_WIN0_CBR_DEFLICK		SET_BIT(1, 19)
+#define M_WIN0_YUV_CLIP			SET_BIT(1, 20)
+
+#define WIN0_CTRL1			(0x0034)
+#define V_WIN0_YRGB_AXI_GATHER_EN(x)	SET_BIT_MASK(x, 0, 1)
+#define V_WIN0_CBR_AXI_GATHER_EN(x)	SET_BIT_MASK(x, 1, 1)
+#define V_WIN0_BIC_COE_SEL(x)		SET_BIT_MASK(x, 2, 3)
+#define V_WIN0_VSD_YRGB_GT4(x)		SET_BIT_MASK(x, 4, 1)
+#define V_WIN0_VSD_YRGB_GT2(x)		SET_BIT_MASK(x, 5, 1)
+#define V_WIN0_VSD_CBR_GT4(x)		SET_BIT_MASK(x, 6, 1)
+#define V_WIN0_VSD_CBR_GT2(x)		SET_BIT_MASK(x, 7, 1)
+#define V_WIN0_YRGB_AXI_GATHER_NUM(x)	SET_BIT_MASK(x, 8, 0xf)
+#define V_WIN0_CBR_AXI_GATHER_NUM(x)	SET_BIT_MASK(x, 12, 7)
+#define V_WIN0_LINE_LOAD_MODE(x)	SET_BIT_MASK(x, 15, 1)
+#define V_WIN0_YRGB_HOR_SCL_MODE(x)	SET_BIT_MASK(x, 16, 3)
+#define V_WIN0_YRGB_VER_SCL_MODE(x)	SET_BIT_MASK(x, 18, 3)
+#define V_WIN0_YRGB_HSD_MODE(x)		SET_BIT_MASK(x, 20, 3)
+#define V_WIN0_YRGB_VSU_MODE(x)		SET_BIT_MASK(x, 22, 1)
+#define V_WIN0_YRGB_VSD_MODE(x)		SET_BIT_MASK(x, 23, 1)
+#define V_WIN0_CBR_HOR_SCL_MODE(x)	SET_BIT_MASK(x, 24, 3)
+#define V_WIN0_CBR_VER_SCL_MODE(x)	SET_BIT_MASK(x, 26, 3)
+#define V_WIN0_CBR_HSD_MODE(x)		SET_BIT_MASK(x, 28, 3)
+#define V_WIN0_CBR_VSU_MODE(x)		SET_BIT_MASK(x, 30, 1)
+#define V_WIN0_CBR_VSD_MODE(x)		SET_BIT_MASK(x, 31, 1)
+
+#define M_WIN0_YRGB_AXI_GATHER_EN	SET_BIT(1, 0)
+#define M_WIN0_CBR_AXI_GATHER_EN	SET_BIT(1, 1)
+#define M_WIN0_BIC_COE_SEL		SET_BIT(3, 2)
+#define M_WIN0_VSD_YRGB_GT4		SET_BIT(1, 4)
+#define M_WIN0_VSD_YRGB_GT2		SET_BIT(1, 5)
+#define M_WIN0_VSD_CBR_GT4		SET_BIT(1, 6)
+#define M_WIN0_VSD_CBR_GT2		SET_BIT(1, 7)
+#define M_WIN0_YRGB_AXI_GATHER_NUM	SET_BIT(0xf, 8)
+#define M_WIN0_CBR_AXI_GATHER_NUM	SET_BIT(7, 12)
+#define M_WIN0_LINE_LOAD_MODE		SET_BIT(1, 15)
+#define M_WIN0_YRGB_HOR_SCL_MODE	SET_BIT(3, 16)
+#define M_WIN0_YRGB_VER_SCL_MODE	SET_BIT(3, 18)
+#define M_WIN0_YRGB_HSD_MODE		SET_BIT(3, 20)
+#define M_WIN0_YRGB_VSU_MODE		SET_BIT(1, 22)
+#define M_WIN0_YRGB_VSD_MODE		SET_BIT(1, 23)
+#define M_WIN0_CBR_HOR_SCL_MODE		SET_BIT(3, 24)
+#define M_WIN0_CBR_VER_SCL_MODE		SET_BIT(3, 26)
+#define M_WIN0_CBR_HSD_MODE		SET_BIT(3, 28)
+#define M_WIN0_CBR_VSU_MODE		SET_BIT((u32)1, 30)
+#define M_WIN0_CBR_VSD_MODE		SET_BIT((u32)1, 31)
+
+#define WIN0_COLOR_KEY			(0x0038)
+#define V_WIN0_COLOR_KEY(x)		SET_BIT_MASK(x, 0, 0x3fffffff)
+#define V_WIN0_COLOR_KEY_EN(x)		SET_BIT_MASK(x, 31, 1)
+#define M_WIN0_COLOR_KEY		SET_BIT(0x3fffffff, 0)
+#define M_WIN0_COLOR_KEY_EN		SET_BIT((u32)1, 31)
+
+#define WIN0_VIR			(0x003c)
+#define V_WIN0_VIR_STRIDE(x)		SET_BIT_MASK(x, 0, 0x3fff)
+#define V_WIN0_VIR_STRIDE_UV(x)		SET_BIT_MASK(x, 16, 0x3fff)
+#define M_WIN0_VIR_STRIDE		SET_BIT(0x3fff, 0)
+#define M_WIN0_VIR_STRIDE_UV		SET_BIT(0x3fff, 16)
+
+#define WIN0_YRGB_MST			(0x0040)
+#define WIN0_CBR_MST			(0x0044)
+#define WIN0_ACT_INFO			(0x0048)
+#define V_WIN0_ACT_WIDTH(x)		SET_BIT_MASK(x-1, 0, 0x1fff)
+#define V_WIN0_ACT_HEIGHT(x)		SET_BIT_MASK(x-1, 16, 0x1fff)
+#define M_WIN0_ACT_WIDTH		SET_BIT(0x1fff, 0)
+#define M_WIN0_ACT_HEIGHT		SET_BIT(0x1fff, 16)
+
+#define WIN0_DSP_INFO			(0x004c)
+#define V_WIN0_DSP_WIDTH(x)		SET_BIT_MASK(x-1, 0, 0xfff)
+#define V_WIN0_DSP_HEIGHT(x)		SET_BIT_MASK(x-1, 16, 0xfff)
+#define M_WIN0_DSP_WIDTH		SET_BIT(0xfff, 0)
+#define M_WIN0_DSP_HEIGHT		SET_BIT(0xfff, 16)
+
+#define WIN0_DSP_ST			(0x0050)
+#define V_WIN0_DSP_XST(x)		SET_BIT_MASK(x, 0, 0x1fff)
+#define V_WIN0_DSP_YST(x)		SET_BIT_MASK(x, 16, 0x1fff)
+#define M_WIN0_DSP_XST			SET_BIT(0x1fff, 0)
+#define M_WIN0_DSP_YST			SET_BIT(0x1fff, 16)
+
+#define WIN0_SCL_FACTOR_YRGB		(0x0054)
+#define V_WIN0_HS_FACTOR_YRGB(x)	SET_BIT_MASK(x, 0, 0xffff)
+#define V_WIN0_VS_FACTOR_YRGB(x)	SET_BIT_MASK(x, 16, 0xffff)
+#define M_WIN0_HS_FACTOR_YRGB		SET_BIT(0xffff, 0)
+#define M_WIN0_VS_FACTOR_YRGB		SET_BIT((u32)0xffff, 16)
+
+#define WIN0_SCL_FACTOR_CBR		(0x0058)
+#define V_WIN0_HS_FACTOR_CBR(x)		SET_BIT_MASK(x, 0, 0xffff)
+#define V_WIN0_VS_FACTOR_CBR(x)		SET_BIT_MASK(x, 16, 0xffff)
+#define M_WIN0_HS_FACTOR_CBR		SET_BIT(0xffff, 0)
+#define M_WIN0_VS_FACTOR_CBR		SET_BIT((u32)0xffff, 16)
+
+#define WIN0_SCL_OFFSET			(0x005c)
+#define V_WIN0_HS_OFFSET_YRGB(x)	SET_BIT_MASK(x, 0, 0xff)
+#define V_WIN0_HS_OFFSET_CBR(x)		SET_BIT_MASK(x, 8, 0xff)
+#define V_WIN0_VS_OFFSET_YRGB(x)	SET_BIT_MASK(x, 16, 0xff)
+#define V_WIN0_VS_OFFSET_CBR(x)		SET_BIT_MASK(x, 24, 0xff)
+
+#define M_WIN0_HS_OFFSET_YRGB		SET_BIT(0xff, 0)
+#define M_WIN0_HS_OFFSET_CBR		SET_BIT(0xff, 8)
+#define M_WIN0_VS_OFFSET_YRGB		SET_BIT(0xff, 16)
+#define M_WIN0_VS_OFFSET_CBR		SET_BIT((u32)0xff, 24)
+
+#define WIN0_SRC_ALPHA_CTRL		(0x0060)
+#define V_WIN0_SRC_ALPHA_EN(x)		SET_BIT_MASK(x, 0, 1)
+#define V_WIN0_SRC_COLOR_M0(x)		SET_BIT_MASK(x, 1, 1)
+#define V_WIN0_SRC_ALPHA_M0(x)		SET_BIT_MASK(x, 2, 1)
+#define V_WIN0_SRC_BLEND_M0(x)		SET_BIT_MASK(x, 3, 3)
+#define V_WIN0_SRC_ALPHA_CAL_M0(x)	SET_BIT_MASK(x, 5, 1)
+#define V_WIN0_SRC_FACTOR_M0(x)		SET_BIT_MASK(x, 6, 7)
+#define V_WIN0_SRC_GLOBAL_ALPHA(x)	SET_BIT_MASK(x, 16, 0xff)
+#define V_WIN0_FADING_VALUE(x)		SET_BIT_MASK(x, 24, 0xff)
+
+#define M_WIN0_SRC_ALPHA_EN		SET_BIT(1, 0)
+#define M_WIN0_SRC_COLOR_M0		SET_BIT(1, 1)
+#define M_WIN0_SRC_ALPHA_M0		SET_BIT(1, 2)
+#define M_WIN0_SRC_BLEND_M0		SET_BIT(3, 3)
+#define M_WIN0_SRC_ALPHA_CAL_M0		SET_BIT(1, 5)
+#define M_WIN0_SRC_FACTOR_M0		SET_BIT(7, 6)
+#define M_WIN0_SRC_GLOBAL_ALPHA		SET_BIT(0xff, 16)
+#define M_WIN0_FADING_VALUE		SET_BIT(0xff, 24)
+
+#define WIN0_DST_ALPHA_CTRL		(0x0064)
+#define V_WIN0_DST_FACTOR_M0(x)		SET_BIT_MASK(x, 6, 7)
+#define M_WIN0_DST_FACTOR_M0		SET_BIT(7, 6)
+
+#define WIN0_FADING_CTRL		(0x0068)
+#define V_WIN0_FADING_OFFSET_R(x)	SET_BIT_MASK(x, 0, 0xff)
+#define V_WIN0_FADING_OFFSET_G(x)	SET_BIT_MASK(x, 8, 0xff)
+#define V_WIN0_FADING_OFFSET_B(x)	SET_BIT_MASK(x, 16, 0xff)
+#define V_WIN0_FADING_EN(x)		SET_BIT_MASK(x, 24, 1)
+
+#define M_WIN0_FADING_OFFSET_R		SET_BIT(0xff, 0)
+#define M_WIN0_FADING_OFFSET_G		SET_BIT(0xff, 8)
+#define M_WIN0_FADING_OFFSET_B		SET_BIT(0xff, 16)
+#define M_WIN0_FADING_EN		SET_BIT(1, 24)
+
+/* win1 register */
+#define WIN1_CTRL0			(0x0070)
+#define V_WIN1_EN(x)			SET_BIT_MASK(x, 0, 1)
+#define V_WIN1_DATA_FMT(x)		SET_BIT_MASK(x, 1, 7)
+#define V_WIN1_FMT_10(x)		SET_BIT_MASK(x, 4, 1)
+#define V_WIN1_LB_MODE(x)		SET_BIT_MASK(x, 5, 7)
+#define V_WIN1_INTERLACE_READ_MODE(x)	SET_BIT_MASK(x, 8, 1)
+#define V_WIN1_NO_OUTSTANDING(x)	SET_BIT_MASK(x, 9, 1)
+#define V_WIN1_CSC_MODE(x)		SET_BIT_MASK(x, 10, 3)
+#define V_WIN1_RB_SWAP(x)		SET_BIT_MASK(x, 12, 1)
+#define V_WIN1_ALPHA_SWAP(x)		SET_BIT_MASK(x, 13, 1)
+#define V_WIN1_MID_SWAP(x)		SET_BIT_MASK(x, 14, 1)
+#define V_WIN1_UV_SWAP(x)		SET_BIT_MASK(x, 15, 1)
+#define V_WIN1_PPAS_ZERO_EN(x)		SET_BIT_MASK(x, 16, 1)
+#define V_WIN1_YRGB_DEFLICK(x)		SET_BIT_MASK(x, 18, 1)
+#define V_WIN1_CBR_DEFLICK(x)		SET_BIT_MASK(x, 19, 1)
+#define V_WIN1_YUV_CLIP(x)		SET_BIT_MASK(x, 20, 1)
+
+#define M_WIN1_EN			SET_BIT(1, 0)
+#define M_WIN1_DATA_FMT			SET_BIT(7, 1)
+#define M_WIN1_FMT_10			SET_BIT(1, 4)
+#define M_WIN1_LB_MODE			SET_BIT(7, 5)
+#define M_WIN1_INTERLACE_READ_MODE	SET_BIT(1, 8)
+#define M_WIN1_NO_OUTSTANDING		SET_BIT(1, 9)
+#define M_WIN1_CSC_MODE			SET_BIT(3, 10)
+#define M_WIN1_RB_SWAP			SET_BIT(1, 12)
+#define M_WIN1_ALPHA_SWAP		SET_BIT(1, 13)
+#define M_WIN1_MID_SWAP			SET_BIT(1, 14)
+#define M_WIN1_UV_SWAP			SET_BIT(1, 15)
+#define M_WIN1_PPAS_ZERO_EN		SET_BIT(1, 16)
+#define M_WIN1_YRGB_DEFLICK		SET_BIT(1, 18)
+#define M_WIN1_CBR_DEFLICK		SET_BIT(1, 19)
+#define M_WIN1_YUV_CLIP			SET_BIT(1, 20)
+
+#define WIN1_CTRL1			(0x0074)
+#define V_WIN1_YRGB_AXI_GATHER_EN(x)	SET_BIT_MASK(x, 0, 1)
+#define V_WIN1_CBR_AXI_GATHER_EN(x)	SET_BIT_MASK(x, 1, 1)
+#define V_WIN1_BIC_COE_SEL(x)		SET_BIT_MASK(x, 2, 3)
+#define V_WIN1_VSD_YRGB_GT4(x)		SET_BIT_MASK(x, 4, 1)
+#define V_WIN1_VSD_YRGB_GT2(x)		SET_BIT_MASK(x, 5, 1)
+#define V_WIN1_VSD_CBR_GT4(x)		SET_BIT_MASK(x, 6, 1)
+#define V_WIN1_VSD_CBR_GT2(x)		SET_BIT_MASK(x, 7, 1)
+#define V_WIN1_YRGB_AXI_GATHER_NUM(x)	SET_BIT_MASK(x, 8, 0xf)
+#define V_WIN1_CBR_AXI_GATHER_NUM(x)	SET_BIT_MASK(x, 12, 7)
+#define V_WIN1_LINE_LOAD_MODE(x)	SET_BIT_MASK(x, 15, 1)
+#define V_WIN1_YRGB_HOR_SCL_MODE(x)	SET_BIT_MASK(x, 16, 3)
+#define V_WIN1_YRGB_VER_SCL_MODE(x)	SET_BIT_MASK(x, 18, 3)
+#define V_WIN1_YRGB_HSD_MODE(x)		SET_BIT_MASK(x, 20, 3)
+#define V_WIN1_YRGB_VSU_MODE(x)		SET_BIT_MASK(x, 22, 1)
+#define V_WIN1_YRGB_VSD_MODE(x)		SET_BIT_MASK(x, 23, 1)
+#define V_WIN1_CBR_HOR_SCL_MODE(x)	SET_BIT_MASK(x, 24, 3)
+#define V_WIN1_CBR_VER_SCL_MODE(x)	SET_BIT_MASK(x, 26, 3)
+#define V_WIN1_CBR_HSD_MODE(x)		SET_BIT_MASK(x, 28, 3)
+#define V_WIN1_CBR_VSU_MODE(x)		SET_BIT_MASK(x, 30, 1)
+#define V_WIN1_CBR_VSD_MODE(x)		SET_BIT_MASK(x, 31, 1)
+
+#define M_WIN1_YRGB_AXI_GATHER_EN	SET_BIT(1, 0)
+#define M_WIN1_CBR_AXI_GATHER_EN	SET_BIT(1, 1)
+#define M_WIN1_BIC_COE_SEL		SET_BIT(3, 2)
+#define M_WIN1_VSD_YRGB_GT4		SET_BIT(1, 4)
+#define M_WIN1_VSD_YRGB_GT2		SET_BIT(1, 5)
+#define M_WIN1_VSD_CBR_GT4		SET_BIT(1, 6)
+#define M_WIN1_VSD_CBR_GT2		SET_BIT(1, 7)
+#define M_WIN1_YRGB_AXI_GATHER_NUM	SET_BIT(0xf, 8)
+#define M_WIN1_CBR_AXI_GATHER_NUM	SET_BIT(7, 12)
+#define M_WIN1_LINE_LOAD_MODE		SET_BIT(1, 15)
+#define M_WIN1_YRGB_HOR_SCL_MODE	SET_BIT(3, 16)
+#define M_WIN1_YRGB_VER_SCL_MODE	SET_BIT(3, 18)
+#define M_WIN1_YRGB_HSD_MODE		SET_BIT(3, 20)
+#define M_WIN1_YRGB_VSU_MODE		SET_BIT(1, 22)
+#define M_WIN1_YRGB_VSD_MODE		SET_BIT(1, 23)
+#define M_WIN1_CBR_HOR_SCL_MODE		SET_BIT(3, 24)
+#define M_WIN1_CBR_VER_SCL_MODE		SET_BIT(3, 26)
+#define M_WIN1_CBR_HSD_MODE		SET_BIT(3, 28)
+#define M_WIN1_CBR_VSU_MODE		SET_BIT(1, 30)
+#define M_WIN1_CBR_VSD_MODE		SET_BIT((u32)1, 31)
+
+#define WIN1_COLOR_KEY			(0x0078)
+#define V_WIN1_COLOR_KEY(x)		SET_BIT_MASK(x, 0, 0x3fffffff)
+#define V_WIN1_COLOR_KEY_EN(x)		SET_BIT_MASK(x, 31, 1)
+#define M_WIN1_COLOR_KEY		SET_BIT(0x3fffffff, 0)
+#define M_WIN1_COLOR_KEY_EN		SET_BIT((u32)1, 31)
+
+#define WIN1_VIR			(0x007c)
+#define V_WIN1_VIR_STRIDE(x)		SET_BIT_MASK(x, 0, 0x3fff)
+#define V_WIN1_VIR_STRIDE_UV(x)		SET_BIT_MASK(x, 16, 0x3fff)
+#define M_WIN1_VIR_STRIDE		SET_BIT(0x3fff, 0)
+#define M_WIN1_VIR_STRIDE_UV		SET_BIT(0x3fff, 16)
+
+#define WIN1_YRGB_MST			(0x0080)
+#define WIN1_CBR_MST			(0x0084)
+#define WIN1_ACT_INFO			(0x0088)
+#define V_WIN1_ACT_WIDTH(x)		SET_BIT_MASK(x-1, 0, 0x1fff)
+#define V_WIN1_ACT_HEIGHT(x)		SET_BIT_MASK(x-1, 16, 0x1fff)
+#define M_WIN1_ACT_WIDTH		SET_BIT(0x1fff, 0)
+#define M_WIN1_ACT_HEIGHT		SET_BIT(0x1fff, 16)
+
+#define WIN1_DSP_INFO			(0x008c)
+#define V_WIN1_DSP_WIDTH(x)		SET_BIT_MASK(x-1, 0, 0xfff)
+#define V_WIN1_DSP_HEIGHT(x)		SET_BIT_MASK(x-1, 16, 0xfff)
+#define M_WIN1_DSP_WIDTH		SET_BIT(0xfff, 0)
+#define M_WIN1_DSP_HEIGHT		SET_BIT(0xfff, 16)
+
+#define WIN1_DSP_ST			(0x0090)
+#define V_WIN1_DSP_XST(x)		SET_BIT_MASK(x, 0, 0x1fff)
+#define V_WIN1_DSP_YST(x)		SET_BIT_MASK(x, 16, 0x1fff)
+#define M_WIN1_DSP_XST			SET_BIT(0x1fff, 0)
+#define M_WIN1_DSP_YST			SET_BIT(0x1fff, 16)
+
+#define WIN1_SCL_FACTOR_YRGB		(0x0094)
+#define V_WIN1_HS_FACTOR_YRGB(x)	SET_BIT_MASK(x, 0, 0xffff)
+#define V_WIN1_VS_FACTOR_YRGB(x)	SET_BIT_MASK(x, 16, 0xffff)
+#define M_WIN1_HS_FACTOR_YRGB		SET_BIT(0xffff, 0)
+#define M_WIN1_VS_FACTOR_YRGB		SET_BIT((u32)0xffff, 16)
+
+#define WIN1_SCL_FACTOR_CBR		(0x0098)
+#define V_WIN1_HS_FACTOR_CBR(x)		SET_BIT_MASK(x, 0, 0xffff)
+#define V_WIN1_VS_FACTOR_CBR(x)		SET_BIT_MASK(x, 16, 0xffff)
+#define M_WIN1_HS_FACTOR_CBR		SET_BIT(0xffff, 0)
+#define M_WIN1_VS_FACTOR_CBR		SET_BIT((u32)0xffff, 16)
+
+#define WIN1_SCL_OFFSET			(0x009c)
+#define V_WIN1_HS_OFFSET_YRGB(x)	SET_BIT_MASK(x, 0, 0xff)
+#define V_WIN1_HS_OFFSET_CBR(x)		SET_BIT_MASK(x, 8, 0xff)
+#define V_WIN1_VS_OFFSET_YRGB(x)	SET_BIT_MASK(x, 16, 0xff)
+#define V_WIN1_VS_OFFSET_CBR(x)		SET_BIT_MASK(x, 24, 0xff)
+
+#define M_WIN1_HS_OFFSET_YRGB		SET_BIT(0xff, 0)
+#define M_WIN1_HS_OFFSET_CBR		SET_BIT(0xff, 8)
+#define M_WIN1_VS_OFFSET_YRGB		SET_BIT(0xff, 16)
+#define M_WIN1_VS_OFFSET_CBR		SET_BIT((u32)0xff, 24)
+
+#define WIN1_SRC_ALPHA_CTRL		(0x00a0)
+#define V_WIN1_SRC_ALPHA_EN(x)		SET_BIT_MASK(x, 0, 1)
+#define V_WIN1_SRC_COLOR_M0(x)		SET_BIT_MASK(x, 1, 1)
+#define V_WIN1_SRC_ALPHA_M0(x)		SET_BIT_MASK(x, 2, 1)
+#define V_WIN1_SRC_BLEND_M0(x)		SET_BIT_MASK(x, 3, 3)
+#define V_WIN1_SRC_ALPHA_CAL_M0(x)	SET_BIT_MASK(x, 5, 1)
+#define V_WIN1_SRC_FACTOR_M0(x)		SET_BIT_MASK(x, 6, 7)
+#define V_WIN1_SRC_GLOBAL_ALPHA(x)	SET_BIT_MASK(x, 16, 0xff)
+#define V_WIN1_FADING_VALUE(x)		SET_BIT_MASK(x, 24, 0xff)
+
+#define M_WIN1_SRC_ALPHA_EN		SET_BIT(1, 0)
+#define M_WIN1_SRC_COLOR_M0		SET_BIT(1, 1)
+#define M_WIN1_SRC_ALPHA_M0		SET_BIT(1, 2)
+#define M_WIN1_SRC_BLEND_M0		SET_BIT(3, 3)
+#define M_WIN1_SRC_ALPHA_CAL_M0		SET_BIT(1, 5)
+#define M_WIN1_SRC_FACTOR_M0		SET_BIT(7, 6)
+#define M_WIN1_SRC_GLOBAL_ALPHA		SET_BIT(0xff, 16)
+#define M_WIN1_FADING_VALUE		SET_BIT(0xff, 24)
+
+#define WIN1_DST_ALPHA_CTRL		(0x00a4)
+#define V_WIN1_DST_FACTOR_M0(x)		SET_BIT_MASK(x, 6, 7)
+#define M_WIN1_DST_FACTOR_M0		SET_BIT(7, 6)
+
+#define WIN1_FADING_CTRL		(0x00a8)
+#define V_WIN1_FADING_OFFSET_R(x)	SET_BIT_MASK(x, 0, 0xff)
+#define V_WIN1_FADING_OFFSET_G(x)	SET_BIT_MASK(x, 8, 0xff)
+#define V_WIN1_FADING_OFFSET_B(x)	SET_BIT_MASK(x, 16, 0xff)
+#define V_WIN1_FADING_EN(x)		SET_BIT_MASK(x, 24, 1)
+
+#define M_WIN1_FADING_OFFSET_R		SET_BIT(0xff, 0)
+#define M_WIN1_FADING_OFFSET_G		SET_BIT(0xff, 8)
+#define M_WIN1_FADING_OFFSET_B		SET_BIT(0xff, 16)
+#define M_WIN1_FADING_EN		SET_BIT(1, 24)
+
+/* win2 register */
+#define WIN2_CTRL0			(0x00b0)
+#define V_WIN2_EN(x)			SET_BIT_MASK(x, 0, 1)
+#define V_WIN2_DATA_FMT(x)		SET_BIT_MASK(x, 1, 7)
+#define V_WIN2_MST0_EN(x)		SET_BIT_MASK(x, 4, 1)
+#define V_WIN2_MST1_EN(x)		SET_BIT_MASK(x, 5, 1)
+#define V_WIN2_MST2_EN(x)		SET_BIT_MASK(x, 6, 1)
+#define V_WIN2_MST3_EN(x)		SET_BIT_MASK(x, 7, 1)
+#define V_WIN2_INTERLACE_READ(x)	SET_BIT_MASK(x, 8, 1)
+#define V_WIN2_NO_OUTSTANDING(x)	SET_BIT_MASK(x, 9, 1)
+#define V_WIN2_CSC_MODE(x)		SET_BIT_MASK(x, 10, 1)
+#define V_WIN2_RB_SWAP(x)		SET_BIT_MASK(x, 12, 1)
+#define V_WIN2_ALPHA_SWAP(x)		SET_BIT_MASK(x, 13, 1)
+#define V_WIN2_ENDIAN_MODE(x)		SET_BIT_MASK(x, 14, 1)
+#define V_WIN2_LUT_EN(x)		SET_BIT_MASK(x, 18, 1)
+
+#define M_WIN2_EN			SET_BIT(1, 0)
+#define M_WIN2_DATA_FMT			SET_BIT(7, 1)
+#define M_WIN2_MST0_EN			SET_BIT(1, 4)
+#define M_WIN2_MST1_EN			SET_BIT(1, 5)
+#define M_WIN2_MST2_EN			SET_BIT(1, 6)
+#define M_WIN2_MST3_EN			SET_BIT(1, 7)
+#define M_WIN2_INTERLACE_READ		SET_BIT(1, 8)
+#define M_WIN2_NO_OUTSTANDING		SET_BIT(1, 9)
+#define M_WIN2_CSC_MODE			SET_BIT(1, 10)
+#define M_WIN2_RB_SWAP			SET_BIT(1, 12)
+#define M_WIN2_ALPHA_SWAP		SET_BIT(1, 13)
+#define M_WIN2_ENDIAN_MODE		SET_BIT(1, 14)
+#define M_WIN2_LUT_EN			SET_BIT(1, 18)
+
+#define WIN2_CTRL1			(0x00b4)
+#define V_WIN2_AXI_GATHER_EN(x)		SET_BIT_MASK(x, 0, 1)
+#define V_WIN2_AXI_GATHER_NUM(x)	SET_BIT_MASK(x, 4, 0xf)
+#define M_WIN2_AXI_GATHER_EN		SET_BIT(1, 0)
+#define M_WIN2_AXI_GATHER_NUM		SET_BIT(0xf, 4)
+
+#define WIN2_VIR0_1			(0x00b8)
+#define V_WIN2_VIR_STRIDE0(x)		SET_BIT_MASK(x, 0, 0x1fff)
+#define V_WIN2_VIR_STRIDE1(x)		SET_BIT_MASK(x, 16, 0x1fff)
+#define M_WIN2_VIR_STRIDE0		SET_BIT(0x1fff, 0)
+#define M_WIN2_VIR_STRIDE1		SET_BIT(0x1fff, 16)
+
+#define WIN2_VIR2_3			(0x00bc)
+#define V_WIN2_VIR_STRIDE2(x)		SET_BIT_MASK(x, 0, 0x1fff)
+#define V_WIN2_VIR_STRIDE3(x)		SET_BIT_MASK(x, 16, 0x1fff)
+#define M_WIN2_VIR_STRIDE2		SET_BIT(0x1fff, 0)
+#define M_WIN2_VIR_STRIDE3		SET_BIT(0x1fff, 16)
+
+#define WIN2_MST0			(0x00c0)
+#define WIN2_DSP_INFO0			(0x00c4)
+#define V_WIN2_DSP_WIDTH0(x)		SET_BIT_MASK(x-1, 0, 0xfff)
+#define V_WIN2_DSP_HEIGHT0(x)		SET_BIT_MASK(x-1, 16, 0xfff)
+#define M_WIN2_DSP_WIDTH0		SET_BIT(0xfff, 0)
+#define M_WIN2_DSP_HEIGHT0		SET_BIT(0xfff, 16)
+
+#define WIN2_DSP_ST0			(0x00c8)
+#define V_WIN2_DSP_XST0(x)		SET_BIT_MASK(x, 0, 0x1fff)
+#define V_WIN2_DSP_YST0(x)		SET_BIT_MASK(x, 16, 0x1fff)
+#define M_WIN2_DSP_XST0			SET_BIT(0x1fff, 0)
+#define M_WIN2_DSP_YST0			SET_BIT(0x1fff, 16)
+
+#define WIN2_COLOR_KEY			(0x00cc)
+#define V_WIN2_COLOR_KEY(x)		SET_BIT_MASK(x, 0, 0xffffff)
+#define V_WIN2_KEY_EN(x)		SET_BIT_MASK(x, 24, 1)
+#define M_WIN2_COLOR_KEY		SET_BIT(0xffffff, 0)
+#define M_WIN2_KEY_EN			SET_BIT((u32)1, 24)
+
+#define WIN2_MST1			(0x00d0)
+#define WIN2_DSP_INFO1			(0x00d4)
+#define V_WIN2_DSP_WIDTH1(x)		SET_BIT_MASK(x-1, 0, 0xfff)
+#define V_WIN2_DSP_HEIGHT1(x)		SET_BIT_MASK(x-1, 16, 0xfff)
+
+#define M_WIN2_DSP_WIDTH1		SET_BIT(0xfff, 0)
+#define M_WIN2_DSP_HEIGHT1		SET_BIT(0xfff, 16)
+
+#define WIN2_DSP_ST1			(0x00d8)
+#define V_WIN2_DSP_XST1(x)		SET_BIT_MASK(x, 0, 0x1fff)
+#define V_WIN2_DSP_YST1(x)		SET_BIT_MASK(x, 16, 0x1fff)
+
+#define M_WIN2_DSP_XST1			SET_BIT(0x1fff, 0)
+#define M_WIN2_DSP_YST1			SET_BIT(0x1fff, 16)
+
+#define WIN2_SRC_ALPHA_CTRL		(0x00dc)
+#define V_WIN2_SRC_ALPHA_EN(x)		SET_BIT_MASK(x, 0, 1)
+#define V_WIN2_SRC_COLOR_M0(x)		SET_BIT_MASK(x, 1, 1)
+#define V_WIN2_SRC_ALPHA_M0(x)		SET_BIT_MASK(x, 2, 1)
+#define V_WIN2_SRC_BLEND_M0(x)		SET_BIT_MASK(x, 3, 3)
+#define V_WIN2_SRC_ALPHA_CAL_M0(x)	SET_BIT_MASK(x, 5, 1)
+#define V_WIN2_SRC_FACTOR_M0(x)		SET_BIT_MASK(x, 6, 7)
+#define V_WIN2_SRC_GLOBAL_ALPHA(x)	SET_BIT_MASK(x, 16, 0xff)
+#define V_WIN2_FADING_VALUE(x)		SET_BIT_MASK(x, 24, 0xff)
+
+#define M_WIN2_SRC_ALPHA_EN		SET_BIT(1, 0)
+#define M_WIN2_SRC_COLOR_M0		SET_BIT(1, 1)
+#define M_WIN2_SRC_ALPHA_M0		SET_BIT(1, 2)
+#define M_WIN2_SRC_BLEND_M0		SET_BIT(3, 3)
+#define M_WIN2_SRC_ALPHA_CAL_M0		SET_BIT(1, 5)
+#define M_WIN2_SRC_FACTOR_M0		SET_BIT(7, 6)
+#define M_WIN2_SRC_GLOBAL_ALPHA		SET_BIT(0xff, 16)
+#define M_WIN2_FADING_VALUE		SET_BIT(0xff, 24)
+
+#define WIN2_MST2			(0x00e0)
+#define WIN2_DSP_INFO2			(0x00e4)
+#define V_WIN2_DSP_WIDTH2(x)		SET_BIT_MASK(x-1, 0, 0xfff)
+#define V_WIN2_DSP_HEIGHT2(x)		SET_BIT_MASK(x-1, 16, 0xfff)
+
+#define M_WIN2_DSP_WIDTH2		SET_BIT(0xfff, 0)
+#define M_WIN2_DSP_HEIGHT2		SET_BIT(0xfff, 16)
+
+#define WIN2_DSP_ST2			(0x00e8)
+#define V_WIN2_DSP_XST2(x)		SET_BIT_MASK(x, 0, 0x1fff)
+#define V_WIN2_DSP_YST2(x)		SET_BIT_MASK(x, 16, 0x1fff)
+#define M_WIN2_DSP_XST2			SET_BIT(0x1fff, 0)
+#define M_WIN2_DSP_YST2			SET_BIT(0x1fff, 16)
+
+#define WIN2_DST_ALPHA_CTRL		(0x00ec)
+#define V_WIN2_DST_FACTOR_M0(x)		SET_BIT_MASK(x, 6, 7)
+#define M_WIN2_DST_FACTOR_M0		SET_BIT(7, 6)
+
+#define WIN2_MST3			(0x00f0)
+#define WIN2_DSP_INFO3			(0x00f4)
+#define V_WIN2_DSP_WIDTH3(x)		SET_BIT_MASK(x-1, 0, 0xfff)
+#define V_WIN2_DSP_HEIGHT3(x)		SET_BIT_MASK(x-1, 16, 0xfff)
+#define M_WIN2_DSP_WIDTH3		SET_BIT(0xfff, 0)
+#define M_WIN2_DSP_HEIGHT3		SET_BIT(0xfff, 16)
+
+#define WIN2_DSP_ST3			(0x00f8)
+#define V_WIN2_DSP_XST3(x)		SET_BIT_MASK(x, 0, 0x1fff)
+#define V_WIN2_DSP_YST3(x)		SET_BIT_MASK(x, 16, 0x1fff)
+#define M_WIN2_DSP_XST3			SET_BIT(0x1fff, 0)
+#define M_WIN2_DSP_YST3			SET_BIT(0x1fff, 16)
+
+#define WIN2_FADING_CTRL		(0x00fc)
+#define V_WIN2_FADING_OFFSET_R(x)	SET_BIT_MASK(x, 0, 0xff)
+#define V_WIN2_FADING_OFFSET_G(x)	SET_BIT_MASK(x, 8, 0xff)
+#define V_WIN2_FADING_OFFSET_B(x)	SET_BIT_MASK(x, 16, 0xff)
+#define V_WIN2_FADING_EN(x)		SET_BIT_MASK(x, 24, 1)
+
+#define M_WIN2_FADING_OFFSET_R		SET_BIT(0xff, 0)
+#define M_WIN2_FADING_OFFSET_G		SET_BIT(0xff, 8)
+#define M_WIN2_FADING_OFFSET_B		SET_BIT(0xff, 16)
+#define M_WIN2_FADING_EN		SET_BIT(1, 24)
+
+/* win3 register */
+#define WIN3_CTRL0			(0x0100)
+#define V_WIN3_EN(x)			SET_BIT_MASK(x, 0, 1)
+#define V_WIN3_DATA_FMT(x)		SET_BIT_MASK(x, 1, 7)
+#define V_WIN3_MST0_EN(x)		SET_BIT_MASK(x, 4, 1)
+#define V_WIN3_MST1_EN(x)		SET_BIT_MASK(x, 5, 1)
+#define V_WIN3_MST2_EN(x)		SET_BIT_MASK(x, 6, 1)
+#define V_WIN3_MST3_EN(x)		SET_BIT_MASK(x, 7, 1)
+#define V_WIN3_INTERLACE_READ(x)	SET_BIT_MASK(x, 8, 1)
+#define V_WIN3_NO_OUTSTANDING(x)	SET_BIT_MASK(x, 9, 1)
+#define V_WIN3_CSC_MODE(x)		SET_BIT_MASK(x, 10, 1)
+#define V_WIN3_RB_SWAP(x)		SET_BIT_MASK(x, 12, 1)
+#define V_WIN3_ALPHA_SWAP(x)		SET_BIT_MASK(x, 13, 1)
+#define V_WIN3_ENDIAN_MODE(x)		SET_BIT_MASK(x, 14, 1)
+#define V_WIN3_LUT_EN(x)		SET_BIT_MASK(x, 18, 1)
+
+#define M_WIN3_EN			SET_BIT(1, 0)
+#define M_WIN3_DATA_FMT			SET_BIT(7, 1)
+#define M_WIN3_MST0_EN			SET_BIT(1, 4)
+#define M_WIN3_MST1_EN			SET_BIT(1, 5)
+#define M_WIN3_MST2_EN			SET_BIT(1, 6)
+#define M_WIN3_MST3_EN			SET_BIT(1, 7)
+#define M_WIN3_INTERLACE_READ		SET_BIT(1, 8)
+#define M_WIN3_NO_OUTSTANDING		SET_BIT(1, 9)
+#define M_WIN3_CSC_MODE			SET_BIT(1, 10)
+#define M_WIN3_RB_SWAP			SET_BIT(1, 12)
+#define M_WIN3_ALPHA_SWAP		SET_BIT(1, 13)
+#define M_WIN3_ENDIAN_MODE		SET_BIT(1, 14)
+#define M_WIN3_LUT_EN			SET_BIT(1, 18)
+
+#define WIN3_CTRL1			(0x0104)
+#define V_WIN3_AXI_GATHER_EN(x)		SET_BIT_MASK(x, 0, 1)
+#define V_WIN3_AXI_GATHER_NUM(x)	SET_BIT_MASK(x, 4, 0xf)
+#define M_WIN3_AXI_GATHER_EN		SET_BIT(1, 0)
+#define M_WIN3_AXI_GATHER_NUM		SET_BIT(0xf, 4)
+
+#define WIN3_VIR0_1			(0x0108)
+#define V_WIN3_VIR_STRIDE0(x)		SET_BIT_MASK(x, 0, 0x1fff)
+#define V_WIN3_VIR_STRIDE1(x)		SET_BIT_MASK(x, 16, 0x1fff)
+#define M_WIN3_VIR_STRIDE0		SET_BIT(0x1fff, 0)
+#define M_WIN3_VIR_STRIDE1		SET_BIT(0x1fff, 16)
+
+#define WIN3_VIR2_3			(0x010c)
+#define V_WIN3_VIR_STRIDE2(x)		SET_BIT_MASK(x, 0, 0x1fff)
+#define V_WIN3_VIR_STRIDE3(x)		SET_BIT_MASK(x, 16, 0x1fff)
+#define M_WIN3_VIR_STRIDE2		SET_BIT(0x1fff, 0)
+#define M_WIN3_VIR_STRIDE3		SET_BIT(0x1fff, 16)
+
+#define WIN3_MST0			(0x0110)
+#define WIN3_DSP_INFO0			(0x0114)
+#define V_WIN3_DSP_WIDTH0(x)		SET_BIT_MASK(x-1, 0, 0xfff)
+#define V_WIN3_DSP_HEIGHT0(x)		SET_BIT_MASK(x-1, 16, 0xfff)
+#define M_WIN3_DSP_WIDTH0		SET_BIT(0xfff, 0)
+#define M_WIN3_DSP_HEIGHT0		SET_BIT(0xfff, 16)
+
+#define WIN3_DSP_ST0			(0x0118)
+#define V_WIN3_DSP_XST0(x)		SET_BIT_MASK(x, 0, 0x1fff)
+#define V_WIN3_DSP_YST0(x)		SET_BIT_MASK(x, 16, 0x1fff)
+#define M_WIN3_DSP_XST0			SET_BIT(0x1fff, 0)
+#define M_WIN3_DSP_YST0			SET_BIT(0x1fff, 16)
+
+#define WIN3_COLOR_KEY			(0x011c)
+#define V_WIN3_COLOR_KEY(x)		SET_BIT_MASK(x, 0, 0xffffff)
+#define V_WIN3_KEY_EN(x)		SET_BIT_MASK(x, 24, 1)
+#define M_WIN3_COLOR_KEY		SET_BIT(0xffffff, 0)
+#define M_WIN3_KEY_EN			SET_BIT((u32)1, 24)
+
+#define WIN3_MST1			(0x0120)
+#define WIN3_DSP_INFO1			(0x0124)
+#define V_WIN3_DSP_WIDTH1(x)		SET_BIT_MASK(x-1, 0, 0xfff)
+#define V_WIN3_DSP_HEIGHT1(x)		SET_BIT_MASK(x-1, 16, 0xfff)
+#define M_WIN3_DSP_WIDTH1		SET_BIT(0xfff, 0)
+#define M_WIN3_DSP_HEIGHT1		SET_BIT(0xfff, 16)
+
+#define WIN3_DSP_ST1			(0x0128)
+#define V_WIN3_DSP_XST1(x)		SET_BIT_MASK(x, 0, 0x1fff)
+#define V_WIN3_DSP_YST1(x)		SET_BIT_MASK(x, 16, 0x1fff)
+#define M_WIN3_DSP_XST1			SET_BIT(0x1fff, 0)
+#define M_WIN3_DSP_YST1			SET_BIT(0x1fff, 16)
+
+#define WIN3_SRC_ALPHA_CTRL		(0x012c)
+#define V_WIN3_SRC_ALPHA_EN(x)		SET_BIT_MASK(x, 0, 1)
+#define V_WIN3_SRC_COLOR_M0(x)		SET_BIT_MASK(x, 1, 1)
+#define V_WIN3_SRC_ALPHA_M0(x)		SET_BIT_MASK(x, 2, 1)
+#define V_WIN3_SRC_BLEND_M0(x)		SET_BIT_MASK(x, 3, 3)
+#define V_WIN3_SRC_ALPHA_CAL_M0(x)	SET_BIT_MASK(x, 5, 1)
+#define V_WIN3_SRC_FACTOR_M0(x)		SET_BIT_MASK(x, 6, 7)
+#define V_WIN3_SRC_GLOBAL_ALPHA(x)	SET_BIT_MASK(x, 16, 0xff)
+#define V_WIN3_FADING_VALUE(x)		SET_BIT_MASK(x, 24, 0xff)
+
+#define M_WIN3_SRC_ALPHA_EN		SET_BIT(1, 0)
+#define M_WIN3_SRC_COLOR_M0		SET_BIT(1, 1)
+#define M_WIN3_SRC_ALPHA_M0		SET_BIT(1, 2)
+#define M_WIN3_SRC_BLEND_M0		SET_BIT(3, 3)
+#define M_WIN3_SRC_ALPHA_CAL_M0		SET_BIT(1, 5)
+#define M_WIN3_SRC_FACTOR_M0		SET_BIT(7, 6)
+#define M_WIN3_SRC_GLOBAL_ALPHA		SET_BIT(0xff, 16)
+#define M_WIN3_FADING_VALUE		SET_BIT(0xff, 24)
+
+#define WIN3_MST2			(0x0130)
+#define WIN3_DSP_INFO2			(0x0134)
+#define V_WIN3_DSP_WIDTH2(x)		SET_BIT_MASK(x-1, 0, 0xfff)
+#define V_WIN3_DSP_HEIGHT2(x)		SET_BIT_MASK(x-1, 16, 0xfff)
+#define M_WIN3_DSP_WIDTH2		SET_BIT(0xfff, 0)
+#define M_WIN3_DSP_HEIGHT2		SET_BIT(0xfff, 16)
+
+#define WIN3_DSP_ST2			(0x0138)
+#define V_WIN3_DSP_XST2(x)		SET_BIT_MASK(x, 0, 0x1fff)
+#define V_WIN3_DSP_YST2(x)		SET_BIT_MASK(x, 16, 0x1fff)
+#define M_WIN3_DSP_XST2			SET_BIT(0x1fff, 0)
+#define M_WIN3_DSP_YST2			SET_BIT(0x1fff, 16)
+
+#define WIN3_DST_ALPHA_CTRL		(0x013c)
+#define V_WIN3_DST_FACTOR_M0(x)		SET_BIT_MASK(x, 6, 7)
+#define M_WIN3_DST_FACTOR_M0		SET_BIT(7, 6)
+
+#define WIN3_MST3			(0x0140)
+#define WIN3_DSP_INFO3			(0x0144)
+#define V_WIN3_DSP_WIDTH3(x)		SET_BIT_MASK(x-1, 0, 0xfff)
+#define V_WIN3_DSP_HEIGHT3(x)		SET_BIT_MASK(x-1, 16, 0xfff)
+#define M_WIN3_DSP_WIDTH3		SET_BIT(0xfff, 0)
+#define M_WIN3_DSP_HEIGHT3		SET_BIT(0xfff, 16)
+
+#define WIN3_DSP_ST3			(0x0148)
+#define V_WIN3_DSP_XST3(x)		SET_BIT_MASK(x, 0, 0x1fff)
+#define V_WIN3_DSP_YST3(x)		SET_BIT_MASK(x, 16, 0x1fff)
+#define M_WIN3_DSP_XST3			SET_BIT(0x1fff, 0)
+#define M_WIN3_DSP_YST3			SET_BIT(0x1fff, 16)
+
+#define WIN3_FADING_CTRL		(0x014c)
+#define V_WIN3_FADING_OFFSET_R(x)	SET_BIT_MASK(x, 0, 0xff)
+#define V_WIN3_FADING_OFFSET_G(x)	SET_BIT_MASK(x, 8, 0xff)
+#define V_WIN3_FADING_OFFSET_B(x)	SET_BIT_MASK(x, 16, 0xff)
+#define V_WIN3_FADING_EN(x)		SET_BIT_MASK(x, 24, 1)
+
+#define M_WIN3_FADING_OFFSET_R		SET_BIT(0xff, 0)
+#define M_WIN3_FADING_OFFSET_G		SET_BIT(0xff, 8)
+#define M_WIN3_FADING_OFFSET_B		SET_BIT(0xff, 16)
+#define M_WIN3_FADING_EN		SET_BIT(1, 24)
+
+/* hwc register */
+#define HWC_CTRL0			(0x0150)
+#define V_HWC_EN(x)			SET_BIT_MASK(x, 0, 1)
+#define V_HWC_DATA_FMT(x)		SET_BIT_MASK(x, 1, 7)
+#define V_HWC_MODE(x)			SET_BIT_MASK(x, 4, 1)
+#define V_HWC_SIZE(x)			SET_BIT_MASK(x, 5, 3)
+#define V_HWC_INTERLACE_READ(x)		SET_BIT_MASK(x, 8, 1)
+#define V_HWC_NO_OUTSTANDING(x)		SET_BIT_MASK(x, 9, 1)
+#define V_HWC_CSC_MODE(x)		SET_BIT_MASK(x, 10, 1)
+#define V_HWC_RB_SWAP(x)		SET_BIT_MASK(x, 12, 1)
+#define V_HWC_ALPHA_SWAP(x)		SET_BIT_MASK(x, 13, 1)
+#define V_HWC_ENDIAN_MODE(x)		SET_BIT_MASK(x, 14, 1)
+#define V_HWC_LUT_EN(x)			SET_BIT_MASK(x, 18, 1)
+
+#define M_HWC_EN			SET_BIT(1, 0)
+#define M_HWC_DATA_FMT			SET_BIT(7, 1)
+#define M_HWC_MODE			SET_BIT(1, 4)
+#define M_HWC_SIZE			SET_BIT(3, 5)
+#define M_HWC_INTERLACE_READ		SET_BIT(1, 8)
+#define M_HWC_NO_OUTSTANDING		SET_BIT(1, 9)
+#define M_HWC_CSC_MODE			SET_BIT(1, 10)
+#define M_HWC_RB_SWAP			SET_BIT(1, 12)
+#define M_HWC_ALPHA_SWAP		SET_BIT(1, 13)
+#define M_HWC_ENDIAN_MODE		SET_BIT(1, 14)
+#define M_HWC_LUT_EN			SET_BIT(1, 18)
+
+#define HWC_CTRL1			(0x0154)
+#define V_HWC_AXI_GATHER_EN(x)		SET_BIT_MASK(x, 0, 1)
+#define V_HWC_AXI_GATHER_NUM(x)		SET_BIT_MASK(x, 4, 7)
+#define M_HWC_AXI_GATHER_EN		SET_BIT(1, 0)
+#define M_HWC_AXI_GATHER_NUM		SET_BIT(7, 4)
+
+#define HWC_MST				(0x0158)
+#define HWC_DSP_ST			(0x015c)
+#define V_HWC_DSP_XST3(x)		SET_BIT_MASK(x, 0, 0x1fff)
+#define V_HWC_DSP_YST3(x)		SET_BIT_MASK(x, 16, 0x1fff)
+#define M_HWC_DSP_XST3			SET_BIT(0x1fff, 0)
+#define M_HWC_DSP_YST3			SET_BIT(0x1fff, 16)
+
+#define HWC_SRC_ALPHA_CTRL		(0x0160)
+#define V_HWC_SRC_ALPHA_EN(x)		SET_BIT_MASK(x, 0, 1)
+#define V_HWC_SRC_COLOR_M0(x)		SET_BIT_MASK(x, 1, 1)
+#define V_HWC_SRC_ALPHA_M0(x)		SET_BIT_MASK(x, 2, 1)
+#define V_HWC_SRC_BLEND_M0(x)		SET_BIT_MASK(x, 3, 3)
+#define V_HWC_SRC_ALPHA_CAL_M0(x)	SET_BIT_MASK(x, 5, 1)
+#define V_HWC_SRC_FACTOR_M0(x)		SET_BIT_MASK(x, 6, 7)
+#define V_HWC_SRC_GLOBAL_ALPHA(x)	SET_BIT_MASK(x, 16, 0xff)
+#define V_HWC_FADING_VALUE(x)		SET_BIT_MASK(x, 24, 0xff)
+
+#define M_HWC_SRC_ALPHA_EN		SET_BIT(1, 0)
+#define M_HWC_SRC_COLOR_M0		SET_BIT(1, 1)
+#define M_HWC_SRC_ALPHA_M0		SET_BIT(1, 2)
+#define M_HWC_SRC_BLEND_M0		SET_BIT(3, 3)
+#define M_HWC_SRC_ALPHA_CAL_M0		SET_BIT(1, 5)
+#define M_HWC_SRC_FACTOR_M0		SET_BIT(7, 6)
+#define M_HWC_SRC_GLOBAL_ALPHA		SET_BIT(0xff, 16)
+#define M_HWC_FADING_VALUE		SET_BIT(0xff, 24)
+
+#define HWC_DST_ALPHA_CTRL		(0x0164)
+#define V_HWC_DST_FACTOR_M0(x)		SET_BIT_MASK(x, 6, 7)
+#define M_HWC_DST_FACTOR_M0		SET_BIT(7, 6)
+
+#define HWC_FADING_CTRL			(0x0168)
+#define V_HWC_FADING_OFFSET_R(x)	SET_BIT_MASK(x, 0, 0xff)
+#define V_HWC_FADING_OFFSET_G(x)	SET_BIT_MASK(x, 8, 0xff)
+#define V_HWC_FADING_OFFSET_B(x)	SET_BIT_MASK(x, 16, 0xff)
+#define V_HWC_FADING_EN(x)		SET_BIT_MASK(x, 24, 1)
+
+#define M_HWC_FADING_OFFSET_R		SET_BIT(0xff, 0)
+#define M_HWC_FADING_OFFSET_G		SET_BIT(0xff, 8)
+#define M_HWC_FADING_OFFSET_B		SET_BIT(0xff, 16)
+#define M_HWC_FADING_EN			SET_BIT(1, 24)
+
+/* post process register */
+#define POST_DSP_HACT_INFO		(0x0170)
+#define V_DSP_HACT_END_POST(x)		SET_BIT_MASK(x, 0, 0x1fff)
+#define V_DSP_HACT_ST_POST(x)		SET_BIT_MASK(x, 16, 0x1fff)
+#define M_DSP_HACT_END_POST		SET_BIT(0x1fff, 0)
+#define M_DSP_HACT_ST_POST		SET_BIT(0x1fff, 16)
+
+#define POST_DSP_VACT_INFO		(0x0174)
+#define V_DSP_VACT_END_POST(x)		SET_BIT_MASK(x, 0, 0x1fff)
+#define V_DSP_VACT_ST_POST(x)		SET_BIT_MASK(x, 16, 0x1fff)
+#define M_DSP_VACT_END_POST		SET_BIT(0x1fff, 0)
+#define M_DSP_VACT_ST_POST		SET_BIT(0x1fff, 16)
+
+#define POST_SCL_FACTOR_YRGB		(0x0178)
+#define V_POST_HS_FACTOR_YRGB(x)	SET_BIT_MASK(x, 0, 0xffff)
+#define V_POST_VS_FACTOR_YRGB(x)	SET_BIT_MASK(x, 16, 0xffff)
+#define M_POST_HS_FACTOR_YRGB		SET_BIT(0xffff, 0)
+#define M_POST_VS_FACTOR_YRGB		SET_BIT(0xffff, 16)
+
+#define POST_SCL_CTRL			(0x0180)
+#define V_POST_HOR_SD_EN(x)		SET_BIT_MASK(x, 0, 1)
+#define V_POST_VER_SD_EN(x)		SET_BIT_MASK(x, 1, 1)
+
+#define M_POST_HOR_SD_EN		SET_BIT(0x1, 0)
+#define M_POST_VER_SD_EN		SET_BIT(0x1, 1)
+
+#define POST_DSP_VACT_INFO_F1		(0x0184)
+#define V_DSP_VACT_END_POST_F1(x)	SET_BIT_MASK(x, 0, 0x1fff)
+#define V_DSP_VACT_ST_POST_F1(x)	SET_BIT_MASK(x, 16, 0x1fff)
+
+#define M_DSP_VACT_END_POST_F1		SET_BIT(0x1fff, 0)
+#define M_DSP_VACT_ST_POST_F1		SET_BIT(0x1fff, 16)
+
+#define DSP_HTOTAL_HS_END		(0x0188)
+#define V_DSP_HS_PW(x)			SET_BIT_MASK(x, 0, 0x1fff)
+#define V_DSP_HTOTAL(x)			SET_BIT_MASK(x, 16, 0x1fff)
+#define M_DSP_HS_PW			SET_BIT(0x1fff, 0)
+#define M_DSP_HTOTAL			SET_BIT(0x1fff, 16)
+
+#define DSP_HACT_ST_END			(0x018c)
+#define V_DSP_HACT_END(x)		SET_BIT_MASK(x, 0, 0x1fff)
+#define V_DSP_HACT_ST(x)		SET_BIT_MASK(x, 16, 0x1fff)
+#define M_DSP_HACT_END			SET_BIT(0x1fff, 0)
+#define M_DSP_HACT_ST			SET_BIT(0x1fff, 16)
+
+#define DSP_VTOTAL_VS_END		(0x0190)
+#define V_DSP_VS_PW(x)			SET_BIT_MASK(x, 0, 0x1fff)
+#define V_DSP_VTOTAL(x)			SET_BIT_MASK(x, 16, 0x1fff)
+#define M_DSP_VS_PW			SET_BIT(0x1fff, 0)
+#define M_DSP_VTOTAL			SET_BIT(0x1fff, 16)
+
+#define DSP_VACT_ST_END			(0x0194)
+#define V_DSP_VACT_END(x)		SET_BIT_MASK(x, 0, 0x1fff)
+#define V_DSP_VACT_ST(x)		SET_BIT_MASK(x, 16, 0x1fff)
+#define M_DSP_VACT_END			SET_BIT(0x1fff, 0)
+#define M_DSP_VACT_ST			SET_BIT(0x1fff, 16)
+
+#define DSP_VS_ST_END_F1		(0x0198)
+#define V_DSP_VS_END_F1(x)		SET_BIT_MASK(x, 0, 0x1fff)
+#define V_DSP_VS_ST_F1(x)		SET_BIT_MASK(x, 16, 0x1fff)
+#define M_DSP_VS_END_F1			SET_BIT(0x1fff, 0)
+#define M_DSP_VS_ST_F1			SET_BIT(0x1fff, 16)
+
+#define DSP_VACT_ST_END_F1		(0x019c)
+#define V_DSP_VACT_END_F1(x)		SET_BIT_MASK(x, 0, 0x1fff)
+#define V_DSP_VAC_ST_F1(x)		SET_BIT_MASK(x, 16, 0x1fff)
+#define M_DSP_VACT_END_F1		SET_BIT(0x1fff, 0)
+#define M_DSP_VAC_ST_F1			SET_BIT(0x1fff, 16)
+
+enum lb_mode {
+	LB_YUV_3840X5 = 0x0,
+	LB_YUV_2560X8,
+	LB_RGB_3840X2,
+	LB_RGB_2560X4,
+	LB_RGB_1920X5,
+	LB_RGB_1280X8
+};
+
+enum sacle_up_mode {
+	SCALE_UP_BIL = 0x0,
+	SCALE_UP_BIC
+};
+
+enum scale_down_mode {
+	SCALE_DOWN_BIL = 0x0,
+	SCALE_DOWN_AVG
+};
+
+/* ALPHA BLENDING MODE */
+enum alpha_mode {
+	AB_USER_DEFINE = 0x0,
+	AB_CLEAR,
+	AB_SRC,
+	AB_DST,
+	AB_SRC_OVER,
+	AB_DST_OVER,
+	AB_SRC_IN,
+	AB_DST_IN,
+	AB_SRC_OUT,
+	AB_DST_OUT,
+	AB_SRC_ATOP,
+	AB_DST_ATOP,
+	XOR,
+	AB_SRC_OVER_GLOBAL
+};
+
+enum src_alpha_mode {
+	AA_STRAIGHT = 0x0,
+	AA_INVERSE
+};
+
+enum global_alpha_mode {
+	AA_GLOBAL = 0x0,
+	AA_PER_PIX,
+	AA_PER_PIX_GLOBAL
+};
+
+enum src_alpha_sel {
+	AA_SAT = 0x0,
+	AA_NO_SAT
+};
+
+enum src_color_mode {
+	AA_SRC_PRE_MUL = 0x0,
+	AA_SRC_NO_PRE_MUL
+};
+
+enum factor_mode {
+	AA_ZERO = 0x0,
+	AA_ONE,
+	AA_SRC,
+	AA_SRC_INVERSE,
+	AA_SRC_GLOBAL
+};
+
+struct lcdc_device {
+	int id;
+	struct device *dev;
+	struct lcdc_driver lcdc_drv;
+
+	struct drm_display_mode *mode;
+
+	void __iomem *regs;
+	/* back up reg */
+	void *regsbak;
+	/* physical basic address of lcdc register*/
+	u32 reg_phy_base;
+	/* physical map length of lcdc register*/
+	u32 len;
+	/* one time only one process allowed to config the register */
+	spinlock_t reg_lock;
+
+	int __iomem *dsp_lut_addr_base;
+
+	/* used for primary or extended display device */
+	int prop;
+	bool pre_init;
+	/* if aclk or hclk is closed , cess to register is not allowed */
+	bool clk_on;
+	/* active layer counter, hen atv_layer_cnt = 0, isable lcdc */
+	u8 atv_layer_cnt;
+
+	unsigned int irq;
+
+	/* lcdc AHP clk */
+	struct clk *hclk;
+	/* lcdc dclk */
+	struct clk *dclk;
+	/* lcdc share memory frequency */
+	struct clk *aclk;
+	u32 pixclock;
+	/* 1:standby, 0:wrok */
+	u32 standby;
+};
+
+struct alpha_config {
+	/* win0_src_alpha_m0 */
+	enum src_alpha_mode src_alpha_mode;
+	/* win0_src_global_alpha */
+	u32 src_global_alpha_val;
+	/* win0_src_blend_m0 */
+	enum global_alpha_mode src_global_alpha_mode;
+	/* win0_src_alpha_cal_m0 */
+	enum src_alpha_sel src_alpha_cal_m0;
+	/* win0_src_color_m0 */
+	enum src_color_mode src_color_mode;
+	/* win0_src_factor_m0 */
+	enum factor_mode src_factor_mode;
+	/* win0_dst_factor_m0 */
+	enum factor_mode dst_factor_mode;
+};
+
+static inline void lcdc_writel(struct lcdc_device *lcdc_dev, u32 offset, u32 v)
+{
+	u32 *_pv = (u32 *)lcdc_dev->regsbak;
+
+	_pv += (offset >> 2);
+	*_pv = v;
+	writel_relaxed(v, lcdc_dev->regs + offset);
+}
+
+static inline u32 lcdc_readl(struct lcdc_device *lcdc_dev, u32 offset)
+{
+	u32 v;
+	u32 *_pv = (u32 *)lcdc_dev->regsbak;
+
+	_pv += (offset >> 2);
+	v = readl_relaxed(lcdc_dev->regs + offset);
+	*_pv = v;
+
+	return v;
+}
+
+static inline u32 lcdc_read_bit(struct lcdc_device *lcdc_dev,
+				u32 offset, u32 msk)
+{
+	u32 _v = readl_relaxed(lcdc_dev->regs + offset);
+
+	_v &= msk;
+
+	return _v >> msk;
+}
+
+static inline void lcdc_set_bit(struct lcdc_device *lcdc_dev,
+				u32 offset, u32 msk)
+{
+	u32 *_pv = (u32 *)lcdc_dev->regsbak;
+
+	_pv += (offset >> 2);
+	(*_pv) |= msk;
+	writel_relaxed(*_pv, lcdc_dev->regs + offset);
+}
+
+static inline void lcdc_clr_bit(struct lcdc_device *lcdc_dev,
+				u32 offset, u32 msk)
+{
+	u32 *_pv = (u32 *)lcdc_dev->regsbak;
+
+	_pv += (offset >> 2);
+	(*_pv) &= (~msk);
+	writel_relaxed(*_pv, lcdc_dev->regs + offset);
+}
+
+static inline void lcdc_msk_reg(struct lcdc_device *lcdc_dev,
+				u32 offset, u32 msk, u32 v)
+{
+	u32 *_pv = (u32 *)lcdc_dev->regsbak;
+
+	_pv += (offset >> 2);
+	(*_pv) &= (~msk);
+	(*_pv) |= v;
+	writel_relaxed(*_pv, lcdc_dev->regs + offset);
+}
+
+static inline void lcdc_cfg_done(struct lcdc_device *lcdc_dev)
+{
+	writel_relaxed(0x01, lcdc_dev->regs + REG_CFG_DONE);
+	dsb();
+}
+#endif /* _RK3288_LCDC_H_ */
-- 
1.7.9.5
