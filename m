From: Mark yao <mark.yao-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
Subject: [PATCH v4 5/5] drm/rockchip: Add support for Rockchip Soc EDP
Date: Mon, 22 Sep 2014 19:02:08 +0800
Message-ID: <1411383728-2075-1-git-send-email-mark.yao@rock-chips.com>
References: <1411382820-1615-1-git-send-email-mark.yao@rock-chips.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1411382820-1615-1-git-send-email-mark.yao-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: heiko-4mtYJXux2i+zQB+pC5nmwQ@public.gmane.org, Boris BREZILLON <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, David Airlie <airlied-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Rob Clark <robdclark-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Grant Likely <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Rom Lemarchand <romlem-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rockchip-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, dianders-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, marcheu-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, dbehr-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, olof-nZhT3qVonbNeoWH0uzbU5w@public.gmane.org, djkurtz-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, xjq-TNX95d0MmH7DzftRWevZcw@public.gmane.org, kfx-TNX95d0MmH7DzftRWevZcw@public.gmane.org, cym-TNX95d0MmH7DzftRWevZcw@public.gmane.org, cf-TNX95d0MmH7DzftRWevZcw@public.gmane.org, zyw-TNX95d0MmH7DzftRWevZcw@public.gmane.org, xxm-TNX95d0MmH7DzftRWevZcw@public.gmane.org, huangtao-TNX95d0MmH7DzftRWevZcw@public.gmane.org, kever.yang-TNX95d0MmH7DzftRWevZcw@public.gmane.org, yxj-TNX95d0MmH7DzftRWevZcw@public.gmane.org, wxt-TNX95d0MmH7DzftRWevZcw@public.gmane.org, xw-TNX95d0MmH7DzftRWevZcw@public.gmane.org, Mark yao <mark.yao-TNX95d0MmH7DzftRWevZcw@public.gmane.org>, Jeff Chen <jeff.chen-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

This adds support for Rockchip soc edp found on rk3288

Signed-off-by: Mark Yao <mark.yao-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
Signed-off-by: Jeff Chen <jeff.chen-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
---
Changes in v2:
- fix code sytle
- use some define from drm_dp_helper.h
- use panel-simple driver for primary display.
- remove unnecessary clock clk_24m_parent.

Changes in v3: None

Changes in v4: None

 drivers/gpu/drm/rockchip/Kconfig             |    9 +
 drivers/gpu/drm/rockchip/Makefile            |    2 +
 drivers/gpu/drm/rockchip/rockchip_edp_core.c |  853 ++++++++++++++++++
 drivers/gpu/drm/rockchip/rockchip_edp_core.h |  309 +++++++
 drivers/gpu/drm/rockchip/rockchip_edp_reg.c  | 1202 ++++++++++++++++++++++++++
 drivers/gpu/drm/rockchip/rockchip_edp_reg.h  |  345 ++++++++
 6 files changed, 2720 insertions(+)
 create mode 100644 drivers/gpu/drm/rockchip/rockchip_edp_core.c
 create mode 100644 drivers/gpu/drm/rockchip/rockchip_edp_core.h
 create mode 100644 drivers/gpu/drm/rockchip/rockchip_edp_reg.c
 create mode 100644 drivers/gpu/drm/rockchip/rockchip_edp_reg.h

diff --git a/drivers/gpu/drm/rockchip/Kconfig b/drivers/gpu/drm/rockchip/Kconfig
index 7146c80..04b1f8c 100644
--- a/drivers/gpu/drm/rockchip/Kconfig
+++ b/drivers/gpu/drm/rockchip/Kconfig
@@ -17,3 +17,12 @@ config DRM_ROCKCHIP
 	  management to userspace. This driver does not provides
 	  2D or 3D acceleration; acceleration is performed by other
 	  IP found on the SoC.
+
+config ROCKCHIP_EDP
+	bool "Rockchip edp support"
+	depends on DRM_ROCKCHIP
+	help
+	  Choose this option if you have a Rockchip eDP.
+	  Rockchip rk3288 SoC has eDP TX Controller can be used.
+	  If you have an Embedded DisplayPort Panel, say Y to enable its
+	  driver.
diff --git a/drivers/gpu/drm/rockchip/Makefile b/drivers/gpu/drm/rockchip/Makefile
index 6e6d468..a0fc3a1 100644
--- a/drivers/gpu/drm/rockchip/Makefile
+++ b/drivers/gpu/drm/rockchip/Makefile
@@ -7,4 +7,6 @@ ccflags-y := -Iinclude/drm -Idrivers/gpu/drm/rockchip
 rockchipdrm-y := rockchip_drm_drv.o rockchip_drm_fb.o rockchip_drm_fbdev.o \
 		rockchip_drm_gem.o rockchip_drm_vop.o
 
+rockchipdrm-$(CONFIG_ROCKCHIP_EDP) += rockchip_edp_core.o rockchip_edp_reg.o
+
 obj-$(CONFIG_DRM_ROCKCHIP) += rockchipdrm.o
diff --git a/drivers/gpu/drm/rockchip/rockchip_edp_core.c b/drivers/gpu/drm/rockchip/rockchip_edp_core.c
new file mode 100644
index 0000000..5450d1fa
--- /dev/null
+++ b/drivers/gpu/drm/rockchip/rockchip_edp_core.c
@@ -0,0 +1,853 @@
+/*
+* Copyright (C) Fuzhou Rockchip Electronics Co.Ltd
+* Author:
+*      Andy yan <andy.yan-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
+*      Jeff chen <jeff.chen-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
+*
+* based on exynos_dp_core.c
+*
+* This program is free software; you can redistribute it and/or modify it
+* under the terms of the GNU General Public License as published by the
+* Free Software Foundation; either version 2 of the License, or (at your
+* option) any later version.
+*/
+
+#include <drm/drmP.h>
+#include <drm/drm_crtc_helper.h>
+#include <drm/drm_panel.h>
+#include <drm/drm_of.h>
+
+#include <linux/component.h>
+#include <linux/clk.h>
+#include <linux/mfd/syscon.h>
+#include <linux/regmap.h>
+#include <linux/reset.h>
+
+#include <video/of_videomode.h>
+#include <video/videomode.h>
+
+#include "rockchip_edp_core.h"
+
+#define connector_to_edp(c) \
+		container_of(c, struct rockchip_edp_device, connector)
+
+#define encoder_to_edp(c) \
+		container_of(c, struct rockchip_edp_device, encoder)
+
+static struct rockchip_edp_soc_data soc_data[2] = {
+	/* rk3288 */
+	{.grf_soc_con6 = 0x025c,
+	 .grf_soc_con12 = 0x0274},
+	/* no edp switching needed */
+	{.grf_soc_con6 = -1,
+	 .grf_soc_con12 = -1},
+};
+
+static const struct of_device_id rockchip_edp_dt_ids[] = {
+	{.compatible = "rockchip,rk3288-edp",
+	 .data = (void *)&soc_data[0] },
+	{}
+};
+
+MODULE_DEVICE_TABLE(of, rockchip_edp_dt_ids);
+
+static int rockchip_edp_clk_enable(struct rockchip_edp_device *edp)
+{
+	int ret = 0;
+
+	if (!edp->clk_on) {
+		ret = clk_prepare_enable(edp->pclk);
+		if (ret < 0) {
+			dev_err(edp->dev, "cannot enable edp pclk %d\n", ret);
+			goto err_pclk;
+		}
+
+		ret = clk_prepare_enable(edp->clk_edp);
+		if (ret < 0) {
+			dev_err(edp->dev, "cannot enable clk_edp %d\n", ret);
+			goto err_clk_edp;
+		}
+
+		ret = clk_set_rate(edp->clk_24m, 24000000);
+		if (ret < 0) {
+			dev_err(edp->dev, "cannot set edp clk_24m %d\n",
+				ret);
+			goto err_clk_24m;
+		}
+
+		ret = clk_prepare_enable(edp->clk_24m);
+		if (ret < 0) {
+			dev_err(edp->dev, "cannot enable edp clk_24m %d\n",
+				ret);
+			goto err_clk_24m;
+		}
+
+		edp->clk_on = true;
+	}
+
+	return 0;
+
+err_clk_24m:
+	clk_disable_unprepare(edp->clk_edp);
+err_clk_edp:
+	clk_disable_unprepare(edp->pclk);
+err_pclk:
+	edp->clk_on = false;
+
+	return ret;
+}
+
+static int rockchip_edp_clk_disable(struct rockchip_edp_device *edp)
+{
+	if (edp->clk_on) {
+		clk_disable_unprepare(edp->pclk);
+		clk_disable_unprepare(edp->clk_edp);
+		clk_disable_unprepare(edp->clk_24m);
+		edp->clk_on = false;
+	}
+
+	return 0;
+}
+
+static int rockchip_edp_pre_init(struct rockchip_edp_device *edp)
+{
+	u32 val;
+	int ret;
+
+	val = GRF_EDP_REF_CLK_SEL_INTER | (GRF_EDP_REF_CLK_SEL_INTER << 16);
+	ret = regmap_write(edp->grf, edp->soc_data->grf_soc_con12, val);
+	if (ret != 0) {
+		dev_err(edp->dev, "Could not write to GRF: %d\n", ret);
+		return ret;
+	}
+
+	reset_control_assert(edp->rst);
+	usleep_range(10, 20);
+	reset_control_deassert(edp->rst);
+
+	return 0;
+}
+
+static int rockchip_edp_init_edp(struct rockchip_edp_device *edp)
+{
+	rockchip_edp_reset(edp);
+	rockchip_edp_init_refclk(edp);
+	rockchip_edp_init_interrupt(edp);
+	rockchip_edp_enable_sw_function(edp);
+	rockchip_edp_init_analog_func(edp);
+	rockchip_edp_init_hpd(edp);
+	rockchip_edp_init_aux(edp);
+
+	return 0;
+}
+
+static int rockchip_edp_get_max_rx_bandwidth(
+					struct rockchip_edp_device *edp,
+					u8 *bandwidth)
+{
+	u8 data;
+	int retval;
+
+	/*
+	 * For DP rev.1.1, Maximum link rate of Main Link lanes
+	 * 0x06 = 1.62 Gbps, 0x0a = 2.7 Gbps
+	 */
+	retval = rockchip_edp_read_byte_from_dpcd(
+			edp, DP_MAX_LINK_RATE, &data);
+	if (retval < 0)
+		*bandwidth = 0;
+	else
+		*bandwidth = data;
+
+	return retval;
+}
+
+static int rockchip_edp_get_max_rx_lane_count(struct rockchip_edp_device *edp,
+					      u8 *lane_count)
+{
+	u8 data;
+	int retval;
+
+	/*
+	 * For DP rev.1.1, Maximum number of Main Link lanes
+	 * 0x01 = 1 lane, 0x02 = 2 lanes, 0x04 = 4 lanes
+	 */
+	retval = rockchip_edp_read_byte_from_dpcd(
+			edp, DP_MAX_LANE_COUNT, &data);
+	if (retval < 0)
+		*lane_count = 0;
+	else
+		*lane_count = DPCD_MAX_LANE_COUNT(data);
+
+	return retval;
+}
+
+static int rockchip_edp_init_training(struct rockchip_edp_device *edp)
+{
+	int retval;
+
+	/*
+	 * MACRO_RST must be applied after the PLL_LOCK to avoid
+	 * the DP inter pair skew issue for at least 10 us
+	 */
+	rockchip_edp_reset_macro(edp);
+
+	retval = rockchip_edp_get_max_rx_bandwidth(
+				edp, &edp->link_train.link_rate);
+	retval = rockchip_edp_get_max_rx_lane_count(
+				edp, &edp->link_train.lane_count);
+	dev_dbg(edp->dev, "max link rate:%d.%dGps max number of lanes:%d\n",
+		edp->link_train.link_rate * 27 / 100,
+		edp->link_train.link_rate * 27 % 100,
+		edp->link_train.lane_count);
+
+	if ((edp->link_train.link_rate != DP_LINK_BW_1_62) &&
+	    (edp->link_train.link_rate != DP_LINK_BW_2_7)) {
+		dev_warn(edp->dev, "Rx Max Link Rate is abnormal :%x !\n"
+			 "use default link rate:%d.%dGps\n",
+			 edp->link_train.link_rate,
+			 edp->video_info.link_rate * 27 / 100,
+			 edp->video_info.link_rate * 27 % 100);
+			 edp->link_train.link_rate = edp->video_info.link_rate;
+	}
+
+	if (edp->link_train.lane_count == 0) {
+		dev_err(edp->dev, "Rx Max Lane count is abnormal :%x !\n"
+			"use default lanes:%d\n",
+			edp->link_train.lane_count,
+			edp->video_info.lane_count);
+		edp->link_train.lane_count = edp->video_info.lane_count;
+	}
+
+	rockchip_edp_analog_power_ctr(edp, 1);
+
+	return 0;
+}
+
+static int rockchip_edp_hw_link_training(struct rockchip_edp_device *edp)
+{
+	u32 cnt = 50;
+	u32 val;
+
+	/* Set link rate and count as you want to establish*/
+	rockchip_edp_set_link_bandwidth(edp, edp->link_train.link_rate);
+	rockchip_edp_set_lane_count(edp, edp->link_train.lane_count);
+	rockchip_edp_hw_link_training_en(edp);
+	val = rockchip_edp_wait_hw_lt_done(edp);
+	while (val) {
+		if (cnt-- <= 0) {
+			dev_err(edp->dev, "hw lt timeout");
+			return -ETIMEDOUT;
+		}
+		mdelay(1);
+		val = rockchip_edp_wait_hw_lt_done(edp);
+	}
+
+	val = rockchip_edp_get_hw_lt_status(edp);
+	if (val)
+		dev_err(edp->dev, "hw lt err:%d\n", val);
+
+	return val;
+}
+
+static int rockchip_edp_set_link_train(struct rockchip_edp_device *edp)
+{
+	int retval;
+
+	rockchip_edp_init_training(edp);
+
+	retval = rockchip_edp_hw_link_training(edp);
+	if (retval < 0)
+		dev_err(edp->dev, "DP hw LT failed!\n");
+
+	return retval;
+}
+
+static int rockchip_edp_config_video(struct rockchip_edp_device *edp,
+				     struct video_info *video_info)
+{
+	int retval = 0;
+	int timeout_loop = 0;
+	int done_count = 0;
+
+	rockchip_edp_config_video_slave_mode(edp, video_info);
+
+	rockchip_edp_set_video_color_format(edp, video_info->color_depth,
+					    video_info->color_space,
+					    video_info->dynamic_range,
+					    video_info->ycbcr_coeff);
+
+	if (rockchip_edp_get_pll_lock_status(edp) == DP_PLL_UNLOCKED) {
+		dev_err(edp->dev, "PLL is not locked yet.\n");
+		return -EINVAL;
+	}
+
+	for (;;) {
+		timeout_loop++;
+		if (rockchip_edp_is_slave_video_stream_clock_on(edp) == 0)
+			break;
+
+		if (DP_TIMEOUT_LOOP_CNT < timeout_loop) {
+			dev_err(edp->dev, "Timeout of video streamclk ok\n");
+			return -ETIMEDOUT;
+		}
+
+		udelay(1);
+	}
+
+	/* Set to use the register calculated M/N video */
+	rockchip_edp_set_video_cr_mn(edp, CALCULATED_M, 0, 0);
+
+	/* Disable video mute */
+	rockchip_edp_enable_video_mute(edp, 0);
+
+	/* Configure video slave mode */
+	rockchip_edp_enable_video_master(edp, 0);
+
+	/* Enable video */
+	rockchip_edp_start_video(edp);
+
+	timeout_loop = 0;
+
+	for (;;) {
+		timeout_loop++;
+		if (rockchip_edp_is_video_stream_on(edp) == 0) {
+			done_count++;
+			if (done_count > 10)
+				break;
+		} else if (done_count) {
+			done_count = 0;
+		}
+		if (DP_TIMEOUT_LOOP_CNT < timeout_loop) {
+			dev_err(edp->dev, "Timeout of video streamclk ok\n");
+			return -ETIMEDOUT;
+		}
+
+		mdelay(1);
+	}
+
+	if (retval != 0)
+		dev_err(edp->dev, "Video stream is not detected!\n");
+
+	return retval;
+}
+
+static irqreturn_t rockchip_edp_isr(int irq, void *arg)
+{
+	struct rockchip_edp_device *edp = arg;
+	enum dp_irq_type irq_type;
+
+	irq_type = rockchip_edp_get_irq_type(edp);
+	switch (irq_type) {
+	case DP_IRQ_TYPE_HP_CABLE_IN:
+		dev_dbg(edp->dev, "Received irq - cable in\n");
+		rockchip_edp_clear_hotplug_interrupts(edp);
+		break;
+	case DP_IRQ_TYPE_HP_CABLE_OUT:
+		dev_dbg(edp->dev, "Received irq - cable out\n");
+		rockchip_edp_clear_hotplug_interrupts(edp);
+		break;
+	case DP_IRQ_TYPE_HP_CHANGE:
+		/*
+		 * We get these change notifications once in a while, but there
+		 * is nothing we can do with them. Just ignore it for now and
+		 * only handle cable changes.
+		 */
+		dev_dbg(edp->dev, "Received irq - hotplug change; ignoring.\n");
+		rockchip_edp_clear_hotplug_interrupts(edp);
+		break;
+	default:
+		dev_err(edp->dev, "Received irq - unknown type[%x]!\n",
+			irq_type);
+		rockchip_edp_clear_hotplug_interrupts(edp);
+		break;
+	}
+
+	return IRQ_HANDLED;
+}
+
+static void rockchip_edp_commit(struct drm_encoder *encoder)
+{
+	struct rockchip_edp_device *edp = encoder_to_edp(encoder);
+	int ret;
+
+	ret = rockchip_edp_set_link_train(edp);
+	if (ret)
+		dev_err(edp->dev, "link train failed!\n");
+	else
+		dev_dbg(edp->dev, "link training success.\n");
+
+	rockchip_edp_set_lane_count(edp, edp->link_train.lane_count);
+	rockchip_edp_set_link_bandwidth(edp, edp->link_train.link_rate);
+	rockchip_edp_init_video(edp);
+
+	ret = rockchip_edp_config_video(edp, &edp->video_info);
+	if (ret)
+		dev_err(edp->dev, "unable to config video\n");
+}
+
+static void rockchip_edp_poweron(struct drm_encoder *encoder)
+{
+	struct rockchip_edp_device *edp = encoder_to_edp(encoder);
+	int ret;
+
+	if (edp->dpms_mode == DRM_MODE_DPMS_ON)
+		return;
+
+	if (edp->panel)
+		edp->panel->funcs->enable(edp->panel);
+
+	ret = rockchip_edp_clk_enable(edp);
+	if (ret < 0) {
+		dev_err(edp->dev, "cannot enable edp clk %d\n", ret);
+		return;
+	}
+
+	ret = rockchip_edp_pre_init(edp);
+	if (ret < 0) {
+		dev_err(edp->dev, "edp pre init fail %d\n", ret);
+		return;
+	}
+
+	ret = rockchip_edp_init_edp(edp);
+	if (ret < 0) {
+		dev_err(edp->dev, "edp init fail %d\n", ret);
+		return;
+	}
+
+	enable_irq(edp->irq);
+	rockchip_edp_commit(encoder);
+}
+
+static void rockchip_edp_poweroff(struct drm_encoder *encoder)
+{
+	struct rockchip_edp_device *edp = encoder_to_edp(encoder);
+
+	if (edp->dpms_mode == DRM_MODE_DPMS_OFF)
+		return;
+
+	disable_irq(edp->irq);
+	rockchip_edp_reset(edp);
+	rockchip_edp_analog_power_ctr(edp, 0);
+	rockchip_edp_clk_disable(edp);
+	if (edp->panel)
+		edp->panel->funcs->disable(edp->panel);
+}
+
+static enum drm_connector_status
+rockchip_connector_detect(struct drm_connector *connector, bool force)
+{
+	return connector_status_connected;
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
+	.detect = rockchip_connector_detect,
+	.fill_modes = drm_helper_probe_single_connector_modes,
+	.destroy = rockchip_connector_destroy,
+};
+
+static int rockchip_connector_get_modes(struct drm_connector *connector)
+{
+	struct rockchip_edp_device *edp = connector_to_edp(connector);
+	struct drm_panel *panel = edp->panel;
+
+	return panel->funcs->get_modes(panel);
+}
+
+static struct drm_encoder *
+	rockchip_connector_best_encoder(struct drm_connector *connector)
+{
+	struct rockchip_edp_device *edp = connector_to_edp(connector);
+
+	return &edp->encoder;
+}
+
+static enum drm_mode_status rockchip_connector_mode_valid(
+		struct drm_connector *connector,
+		struct drm_display_mode *mode)
+{
+	/* TODO(rk): verify that the mode is really valid */
+	return MODE_OK;
+}
+
+static struct drm_connector_helper_funcs rockchip_connector_helper_funcs = {
+	.get_modes = rockchip_connector_get_modes,
+	.mode_valid = rockchip_connector_mode_valid,
+	.best_encoder = rockchip_connector_best_encoder,
+};
+
+static void rockchip_drm_encoder_dpms(struct drm_encoder *encoder, int mode)
+{
+	struct rockchip_edp_device *edp = encoder_to_edp(encoder);
+
+	if (edp->dpms_mode == mode)
+		return;
+
+	switch (mode) {
+	case DRM_MODE_DPMS_ON:
+		rockchip_edp_poweron(encoder);
+		break;
+	case DRM_MODE_DPMS_STANDBY:
+	case DRM_MODE_DPMS_SUSPEND:
+	case DRM_MODE_DPMS_OFF:
+		rockchip_edp_poweroff(encoder);
+		break;
+	default:
+		break;
+	}
+
+	edp->dpms_mode = mode;
+}
+
+static bool
+rockchip_drm_encoder_mode_fixup(struct drm_encoder *encoder,
+				const struct drm_display_mode *mode,
+				struct drm_display_mode *adjusted_mode)
+{
+	if (!adjusted_mode->private) {
+		struct rockchip_display_mode *priv_mode;
+
+		priv_mode = kzalloc(sizeof(*priv_mode), GFP_KERNEL);
+		priv_mode->out_type = ROCKCHIP_DISPLAY_TYPE_EDP;
+		adjusted_mode->private = (int *)priv_mode;
+	}
+
+	return true;
+}
+
+static void rockchip_drm_encoder_mode_set(struct drm_encoder *encoder,
+					  struct drm_display_mode *mode,
+					  struct drm_display_mode *adjusted)
+{
+	struct rockchip_edp_device *edp = encoder_to_edp(encoder);
+	u32 val;
+	int ret;
+
+	ret = rockchip_drm_encoder_get_mux_id(edp->dev->of_node, encoder);
+	if (ret < 0)
+		return;
+
+	if (ret == ROCKCHIP_CRTC_VOPL)
+		val = EDP_SEL_VOP_LIT | (EDP_SEL_VOP_LIT << 16);
+	else
+		val = EDP_SEL_VOP_LIT << 16;
+
+	dev_info(edp->dev, "vop %s output to edp\n",
+		 (ret == ROCKCHIP_CRTC_VOPL) ? "LIT" : "BIG");
+	ret = regmap_write(edp->grf, edp->soc_data->grf_soc_con6, val);
+	if (ret != 0) {
+		dev_err(edp->dev, "Could not write to GRF: %d\n", ret);
+		return;
+	}
+
+	memcpy(&edp->mode, adjusted, sizeof(*mode));
+}
+
+static void rockchip_drm_encoder_prepare(struct drm_encoder *encoder)
+{
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
+static struct drm_encoder_helper_funcs rockchip_encoder_helper_funcs = {
+	.dpms = rockchip_drm_encoder_dpms,
+	.mode_fixup = rockchip_drm_encoder_mode_fixup,
+	.mode_set = rockchip_drm_encoder_mode_set,
+	.prepare = rockchip_drm_encoder_prepare,
+	.commit = rockchip_drm_encoder_commit,
+	.disable = rockchip_drm_encoder_disable,
+};
+
+static void rockchip_drm_encoder_destroy(struct drm_encoder *encoder)
+{
+	drm_encoder_cleanup(encoder);
+}
+
+static struct drm_encoder_funcs rockchip_encoder_funcs = {
+	.destroy = rockchip_drm_encoder_destroy,
+};
+
+static int rockchip_edp_init(struct rockchip_edp_device *edp)
+{
+	struct device *dev = edp->dev;
+	struct device_node *np = dev->of_node;
+	struct platform_device *pdev = to_platform_device(dev);
+	struct resource *res;
+	const struct of_device_id *match;
+	int ret;
+
+	if (!np) {
+		dev_err(dev, "Missing device tree node.\n");
+		return -EINVAL;
+	}
+
+	match = of_match_node(rockchip_edp_dt_ids, np);
+	edp->soc_data = (struct rockchip_edp_soc_data *)match->data;
+	/*
+	 * The control bit is located in the GRF register space.
+	 */
+	if (edp->soc_data->grf_soc_con6 >= 0) {
+		edp->grf = syscon_regmap_lookup_by_phandle(np, "rockchip,grf");
+		if (IS_ERR(edp->grf)) {
+			dev_err(dev,
+				"rk3288-edp needs rockchip,grf property\n");
+			return PTR_ERR(edp->grf);
+		}
+	}
+
+	edp->video_info.h_sync_polarity = 0;
+	edp->video_info.v_sync_polarity = 0;
+	edp->video_info.interlaced = 0;
+	edp->video_info.color_space = CS_RGB;
+	edp->video_info.dynamic_range = VESA;
+	edp->video_info.ycbcr_coeff = COLOR_YCBCR601;
+	edp->video_info.color_depth = COLOR_8;
+
+	edp->video_info.link_rate = DP_LINK_BW_1_62;
+	edp->video_info.lane_count = LANE_CNT4;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	edp->regs = devm_ioremap_resource(dev, res);
+	if (IS_ERR(edp->regs)) {
+		dev_err(dev, "ioremap reg failed\n");
+		return PTR_ERR(edp->regs);
+	}
+
+	edp->clk_edp = devm_clk_get(dev, "clk_edp");
+	if (IS_ERR(edp->clk_edp)) {
+		dev_err(dev, "cannot get clk_edp\n");
+		return PTR_ERR(edp->clk_edp);
+	}
+
+	edp->clk_24m = devm_clk_get(dev, "clk_edp_24m");
+	if (IS_ERR(edp->clk_24m)) {
+		dev_err(dev, "cannot get clk_edp_24m\n");
+		return PTR_ERR(edp->clk_24m);
+	}
+
+	edp->pclk = devm_clk_get(dev, "pclk_edp");
+	if (IS_ERR(edp->pclk)) {
+		dev_err(dev, "cannot get pclk\n");
+		return PTR_ERR(edp->pclk);
+	}
+
+	edp->rst = devm_reset_control_get(dev, "edp");
+	if (IS_ERR(edp->rst)) {
+		dev_err(dev, "failed to get reset\n");
+		return PTR_ERR(edp->rst);
+	}
+
+	ret = rockchip_edp_clk_enable(edp);
+	if (ret < 0) {
+		dev_err(edp->dev, "cannot enable edp clk %d\n", ret);
+		return ret;
+	}
+
+	ret = rockchip_edp_pre_init(edp);
+	if (ret < 0) {
+		dev_err(edp->dev, "failed to pre init %d\n", ret);
+		return ret;
+	}
+
+	edp->irq = platform_get_irq(pdev, 0);
+	if (edp->irq < 0) {
+		dev_err(dev, "cannot find IRQ\n");
+		return edp->irq;
+	}
+
+	ret = devm_request_irq(dev, edp->irq, rockchip_edp_isr, 0,
+			       dev_name(dev), edp);
+	if (ret) {
+		dev_err(dev, "cannot claim IRQ %d\n", edp->irq);
+		return ret;
+	}
+
+	disable_irq_nosync(edp->irq);
+
+	edp->dpms_mode = DRM_MODE_DPMS_OFF;
+
+	dev_set_name(edp->dev, "rockchip-edp");
+
+	return 0;
+}
+
+static int rockchip_edp_bind(struct device *dev, struct device *master,
+			     void *data)
+{
+	struct rockchip_edp_device *edp = dev_get_drvdata(dev);
+	struct drm_encoder *encoder;
+	struct drm_connector *connector;
+	struct drm_device *drm_dev = data;
+	int ret;
+
+	ret = rockchip_edp_init(edp);
+	if (ret < 0)
+		return ret;
+
+	edp->drm_dev = drm_dev;
+
+	encoder = &edp->encoder;
+
+	encoder->possible_crtcs = drm_of_find_possible_crtcs(drm_dev,
+							     dev->of_node);
+	DRM_DEBUG_KMS("possible_crtcs = 0x%x\n", encoder->possible_crtcs);
+
+	ret = drm_encoder_init(drm_dev, encoder, &rockchip_encoder_funcs,
+			       DRM_MODE_ENCODER_LVDS);
+	if (ret) {
+		DRM_ERROR("failed to initialize encoder with drm\n");
+		return ret;
+	}
+
+	drm_encoder_helper_add(encoder, &rockchip_encoder_helper_funcs);
+
+	connector = &edp->connector;
+	connector->polled = DRM_CONNECTOR_POLL_HPD;
+	connector->dpms = DRM_MODE_DPMS_OFF;
+
+	ret = drm_connector_init(drm_dev, connector,
+				 &rockchip_connector_funcs,
+				 DRM_MODE_CONNECTOR_eDP);
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
+	ret = drm_panel_attach(edp->panel, connector);
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
+static void rockchip_edp_unbind(struct device *dev, struct device *master,
+				void *data)
+{
+	struct rockchip_edp_device *edp = dev_get_drvdata(dev);
+	struct drm_encoder *encoder;
+
+	encoder = &edp->encoder;
+
+	if (edp->panel)
+		drm_panel_detach(edp->panel);
+
+	rockchip_drm_encoder_dpms(encoder, DRM_MODE_DPMS_OFF);
+	encoder->funcs->destroy(encoder);
+	drm_sysfs_connector_remove(&edp->connector);
+	drm_connector_cleanup(&edp->connector);
+	drm_encoder_cleanup(encoder);
+}
+
+static const struct component_ops rockchip_edp_component_ops = {
+	.bind = rockchip_edp_bind,
+	.unbind = rockchip_edp_unbind,
+};
+
+static int rockchip_edp_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct drm_panel *panel;
+	struct device_node *panel_node;
+	struct rockchip_edp_device *edp;
+
+	if (!dev->of_node) {
+		dev_err(dev, "can't find eDP devices\n");
+		return -ENODEV;
+	}
+
+	panel_node = of_parse_phandle(dev->of_node, "rockchip,panel", 0);
+	if (!panel_node) {
+		DRM_ERROR("failed to find diaplay panel\n");
+		return -ENODEV;
+	}
+
+	panel = of_drm_find_panel(panel_node);
+	if (!panel) {
+		DRM_ERROR("failed to find diaplay panel\n");
+		of_node_put(panel_node);
+		return -EPROBE_DEFER;
+	}
+
+	of_node_put(panel_node);
+
+	edp = devm_kzalloc(dev, sizeof(*edp), GFP_KERNEL);
+	if (!edp)
+		return -ENOMEM;
+	edp->dev = dev;
+	edp->panel = panel;
+	platform_set_drvdata(pdev, edp);
+
+	return component_add(dev, &rockchip_edp_component_ops);
+}
+
+static int rockchip_edp_remove(struct platform_device *pdev)
+{
+	component_del(&pdev->dev, &rockchip_edp_component_ops);
+
+	return 0;
+}
+
+static struct platform_driver rockchip_edp_driver = {
+	.probe = rockchip_edp_probe,
+	.remove = rockchip_edp_remove,
+	.driver = {
+		   .name = "rockchip-edp",
+		   .owner = THIS_MODULE,
+		   .of_match_table = of_match_ptr(rockchip_edp_dt_ids),
+	},
+};
+
+module_platform_driver(rockchip_edp_driver);
+
+MODULE_AUTHOR("Jeff chen <jeff.chen-TNX95d0MmH7DzftRWevZcw@public.gmane.org>");
+MODULE_DESCRIPTION("ROCKCHIP EDP Driver");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/gpu/drm/rockchip/rockchip_edp_core.h b/drivers/gpu/drm/rockchip/rockchip_edp_core.h
new file mode 100644
index 0000000..c13325f
--- /dev/null
+++ b/drivers/gpu/drm/rockchip/rockchip_edp_core.h
@@ -0,0 +1,309 @@
+/*
+* Copyright (C) Fuzhou Rockchip Electronics Co.Ltd
+* Author:
+*      Andy yan <andy.yan-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
+*      Jeff chen <jeff.chen-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
+*
+* based on exynos_dp_core.h
+*
+* This program is free software; you can redistribute it and/or modify it
+* under the terms of the GNU General Public License as published by the
+* Free Software Foundation; either version 2 of the License, or (at your
+* option) any later version.
+*/
+
+#ifndef _ROCKCHIP_EDP_CORE_H
+#define _ROCKCHIP_EDP_CORE_H
+
+#include <drm/drmP.h>
+#include <drm/drm_crtc_helper.h>
+#include <drm/drm_dp_helper.h>
+#include <drm/drm_panel.h>
+#include "rockchip_drm_drv.h"
+
+#define DP_TIMEOUT_LOOP_CNT 100
+#define MAX_CR_LOOP 5
+#define MAX_EQ_LOOP 5
+
+#define GRF_EDP_REF_CLK_SEL_INTER		(1 << 4)
+#define GRF_EDP_HDCP_EN				(1 << 15)
+#define GRF_EDP_BIST_EN				(1 << 14)
+#define GRF_EDP_MEM_CTL_BY_EDP			(1 << 13)
+#define GRF_EDP_SECURE_EN			(1 << 3)
+#define EDP_SEL_VOP_LIT				(1 << 5)
+
+enum link_lane_count_type {
+	LANE_CNT1 = 1,
+	LANE_CNT2 = 2,
+	LANE_CNT4 = 4
+};
+
+enum link_training_state {
+	LT_START,
+	LT_CLK_RECOVERY,
+	LT_EQ_TRAINING,
+	FINISHED,
+	FAILED
+};
+
+enum voltage_swing_level {
+	VOLTAGE_LEVEL_0,
+	VOLTAGE_LEVEL_1,
+	VOLTAGE_LEVEL_2,
+	VOLTAGE_LEVEL_3,
+};
+
+enum pre_emphasis_level {
+	PRE_EMPHASIS_LEVEL_0,
+	PRE_EMPHASIS_LEVEL_1,
+	PRE_EMPHASIS_LEVEL_2,
+	PRE_EMPHASIS_LEVEL_3,
+};
+
+enum pattern_set {
+	PRBS7,
+	D10_2,
+	TRAINING_PTN1,
+	TRAINING_PTN2,
+	DP_NONE
+};
+
+enum color_space {
+	CS_RGB,
+	CS_YCBCR422,
+	CS_YCBCR444
+};
+
+enum color_depth {
+	COLOR_6,
+	COLOR_8,
+	COLOR_10,
+	COLOR_12
+};
+
+enum color_coefficient {
+	COLOR_YCBCR601,
+	COLOR_YCBCR709
+};
+
+enum dynamic_range {
+	VESA,
+	CEA
+};
+
+enum pll_status {
+	DP_PLL_UNLOCKED,
+	DP_PLL_LOCKED
+};
+
+enum clock_recovery_m_value_type {
+	CALCULATED_M,
+	REGISTER_M
+};
+
+enum video_timing_recognition_type {
+	VIDEO_TIMING_FROM_CAPTURE,
+	VIDEO_TIMING_FROM_REGISTER
+};
+
+enum analog_power_block {
+	AUX_BLOCK,
+	CH0_BLOCK,
+	CH1_BLOCK,
+	CH2_BLOCK,
+	CH3_BLOCK,
+	ANALOG_TOTAL,
+	POWER_ALL
+};
+
+enum dp_irq_type {
+	DP_IRQ_TYPE_HP_CABLE_IN,
+	DP_IRQ_TYPE_HP_CABLE_OUT,
+	DP_IRQ_TYPE_HP_CHANGE,
+	DP_IRQ_TYPE_UNKNOWN,
+};
+
+struct video_info {
+	char *name;
+
+	bool h_sync_polarity;
+	bool v_sync_polarity;
+	bool interlaced;
+
+	enum color_space color_space;
+	enum dynamic_range dynamic_range;
+	enum color_coefficient ycbcr_coeff;
+	enum color_depth color_depth;
+
+	u8 link_rate;
+	enum link_lane_count_type lane_count;
+};
+
+struct link_train {
+	int eq_loop;
+	int cr_loop[4];
+
+	u8 link_rate;
+	u8 lane_count;
+	u8 training_lane[4];
+
+	enum link_training_state lt_state;
+};
+
+/*
+ * @grf_offset: offset inside the grf regmap for setting the rk3288 lvds
+ */
+struct rockchip_edp_soc_data {
+	int grf_soc_con6;
+	int grf_soc_con12;
+};
+
+struct rockchip_edp_device {
+	struct device *dev;
+	struct drm_device *drm_dev;
+	struct drm_panel *panel;
+	struct drm_connector connector;
+	struct drm_encoder encoder;
+	struct drm_display_mode mode;
+
+	struct rockchip_edp_soc_data *soc_data;
+
+	void __iomem *regs;
+	struct regmap *grf;
+	unsigned int irq;
+	struct clk *clk_edp;
+	struct clk *clk_24m_parent;
+	struct clk *clk_24m;
+	struct clk *pclk;
+	struct reset_control *rst;
+	struct link_train link_train;
+	struct video_info video_info;
+	bool clk_on;
+
+	int dpms_mode;
+};
+
+void rockchip_edp_enable_video_mute(struct rockchip_edp_device *edp,
+				    bool enable);
+void rockchip_edp_stop_video(struct rockchip_edp_device *edp);
+void rockchip_edp_lane_swap(struct rockchip_edp_device *edp, bool enable);
+void rockchip_edp_init_refclk(struct rockchip_edp_device *edp);
+void rockchip_edp_init_interrupt(struct rockchip_edp_device *edp);
+void rockchip_edp_reset(struct rockchip_edp_device *edp);
+void rockchip_edp_config_interrupt(struct rockchip_edp_device *edp);
+u32 rockchip_edp_get_pll_lock_status(struct rockchip_edp_device *edp);
+void rockchip_edp_analog_power_ctr(struct rockchip_edp_device *edp,
+				   bool enable);
+void rockchip_edp_init_analog_func(struct rockchip_edp_device *edp);
+void rockchip_edp_init_hpd(struct rockchip_edp_device *edp);
+void rockchip_edp_reset_aux(struct rockchip_edp_device *edp);
+void rockchip_edp_init_aux(struct rockchip_edp_device *edp);
+int rockchip_edp_get_plug_in_status(struct rockchip_edp_device *edp);
+void rockchip_edp_enable_sw_function(struct rockchip_edp_device *edp);
+int rockchip_edp_start_aux_transaction(struct rockchip_edp_device *edp);
+int rockchip_edp_write_byte_to_dpcd(struct rockchip_edp_device *edp,
+				    unsigned int reg_addr,
+				    unsigned char data);
+int rockchip_edp_read_byte_from_dpcd(struct rockchip_edp_device *edp,
+				     unsigned int reg_addr,
+				     unsigned char *data);
+int rockchip_edp_write_bytes_to_dpcd(struct rockchip_edp_device *edp,
+				     unsigned int reg_addr,
+				     unsigned int count,
+				     unsigned char data[]);
+int rockchip_edp_read_bytes_from_dpcd(struct rockchip_edp_device *edp,
+				      unsigned int reg_addr,
+				      unsigned int count,
+				      unsigned char data[]);
+int rockchip_edp_select_i2c_device(struct rockchip_edp_device *edp,
+				   unsigned int device_addr,
+				   unsigned int reg_addr);
+int rockchip_edp_read_byte_from_i2c(struct rockchip_edp_device *edp,
+				    unsigned int device_addr,
+				    unsigned int reg_addr,
+				    unsigned int *data);
+int rockchip_edp_read_bytes_from_i2c(struct rockchip_edp_device *edp,
+				     unsigned int device_addr,
+				     unsigned int reg_addr,
+				     unsigned int count,
+				     unsigned char edid[]);
+void rockchip_edp_set_link_bandwidth(struct rockchip_edp_device *edp,
+				     u32 bwtype);
+void rockchip_edp_get_link_bandwidth(struct rockchip_edp_device *edp,
+				     u32 *bwtype);
+void rockchip_edp_set_lane_count(struct rockchip_edp_device *edp,
+				 u32 count);
+void rockchip_edp_get_lane_count(struct rockchip_edp_device *edp,
+				 u32 *count);
+void rockchip_edp_enable_enhanced_mode(struct rockchip_edp_device *edp,
+				       bool enable);
+void rockchip_edp_set_training_pattern(struct rockchip_edp_device *edp,
+				       enum pattern_set pattern);
+void rockchip_edp_set_lane0_pre_emphasis(struct rockchip_edp_device *edp,
+					 u32 level);
+void rockchip_edp_set_lane1_pre_emphasis(struct rockchip_edp_device *edp,
+					 u32 level);
+void rockchip_edp_set_lane2_pre_emphasis(struct rockchip_edp_device *edp,
+					 u32 level);
+void rockchip_edp_set_lane3_pre_emphasis(struct rockchip_edp_device *edp,
+					 u32 level);
+void rockchip_edp_set_lane0_link_training(struct rockchip_edp_device *edp,
+					  u32 training_lane);
+void rockchip_edp_set_lane1_link_training(struct rockchip_edp_device *edp,
+					  u32 training_lane);
+void rockchip_edp_set_lane2_link_training(struct rockchip_edp_device *edp,
+					  u32 training_lane);
+void rockchip_edp_set_lane3_link_training(struct rockchip_edp_device *edp,
+					  u32 training_lane);
+u32 rockchip_edp_get_lane0_link_training(struct rockchip_edp_device *edp);
+u32 rockchip_edp_get_lane1_link_training(struct rockchip_edp_device *edp);
+u32 rockchip_edp_get_lane2_link_training(struct rockchip_edp_device *edp);
+u32 rockchip_edp_get_lane3_link_training(struct rockchip_edp_device *edp);
+void rockchip_edp_reset_macro(struct rockchip_edp_device *edp);
+int rockchip_edp_init_video(struct rockchip_edp_device *edp);
+
+void rockchip_edp_set_video_color_format(struct rockchip_edp_device *edp,
+					 u32 color_depth,
+					 u32 color_space,
+					 u32 dynamic_range,
+					 u32 coeff);
+int
+rockchip_edp_is_slave_video_stream_clock_on(struct rockchip_edp_device *edp);
+void rockchip_edp_set_video_cr_mn(struct rockchip_edp_device *edp,
+				  enum clock_recovery_m_value_type type,
+				  u32 m_value,
+				  u32 n_value);
+void rockchip_edp_set_video_timing_mode(struct rockchip_edp_device *edp,
+					u32 type);
+void rockchip_edp_enable_video_master(struct rockchip_edp_device *edp,
+				      bool enable);
+void rockchip_edp_start_video(struct rockchip_edp_device *edp);
+int rockchip_edp_is_video_stream_on(struct rockchip_edp_device *edp);
+void rockchip_edp_config_video_slave_mode(struct rockchip_edp_device *edp,
+					  struct video_info *video_info);
+void rockchip_edp_enable_scrambling(struct rockchip_edp_device *edp);
+void rockchip_edp_disable_scrambling(struct rockchip_edp_device *edp);
+void rockchip_edp_hw_link_training_en(struct rockchip_edp_device *edp);
+int rockchip_edp_get_hw_lt_status(struct rockchip_edp_device *edp);
+int rockchip_edp_wait_hw_lt_done(struct rockchip_edp_device *edp);
+enum dp_irq_type rockchip_edp_get_irq_type(struct rockchip_edp_device *edp);
+void rockchip_edp_clear_hotplug_interrupts(struct rockchip_edp_device *edp);
+
+/* I2C EDID Chip ID, Slave Address */
+#define I2C_EDID_DEVICE_ADDR			0x50
+#define I2C_E_EDID_DEVICE_ADDR			0x30
+
+/* DPCD_ADDR_MAX_LANE_COUNT */
+#define DPCD_ENHANCED_FRAME_CAP(x)		(((x) >> 7) & 0x1)
+#define DPCD_MAX_LANE_COUNT(x)			((x) & 0x1f)
+
+/* DPCD_ADDR_LANE_COUNT_SET */
+#define DPCD_LANE_COUNT_SET(x)			((x) & 0x1f)
+
+/* DPCD_ADDR_TRAINING_LANE0_SET */
+#define DPCD_PRE_EMPHASIS_SET(x)		(((x) & 0x3) << 3)
+#define DPCD_PRE_EMPHASIS_GET(x)		(((x) >> 3) & 0x3)
+#define DPCD_VOLTAGE_SWING_SET(x)		(((x) & 0x3) << 0)
+#define DPCD_VOLTAGE_SWING_GET(x)		(((x) >> 0) & 0x3)
+
+#endif  /* _ROCKCHIP_EDP_CORE_H */
diff --git a/drivers/gpu/drm/rockchip/rockchip_edp_reg.c b/drivers/gpu/drm/rockchip/rockchip_edp_reg.c
new file mode 100644
index 0000000..f6d641c
--- /dev/null
+++ b/drivers/gpu/drm/rockchip/rockchip_edp_reg.c
@@ -0,0 +1,1202 @@
+/*
+* Copyright (C) Fuzhou Rockchip Electronics Co.Ltd
+* Author:
+*      Andy yan <andy.yan-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
+*      Jeff chen <jeff.chen-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
+*
+* based on exynos_dp_reg.c
+*
+* This program is free software; you can redistribute it and/or modify it
+* under the terms of the GNU General Public License as published by the
+* Free Software Foundation; either version 2 of the License, or (at your
+* option) any later version.
+*/
+
+#include <linux/device.h>
+#include <linux/delay.h>
+#include <linux/io.h>
+
+#include "rockchip_edp_core.h"
+#include "rockchip_edp_reg.h"
+
+void rockchip_edp_enable_video_mute(struct rockchip_edp_device *edp,
+				    bool enable)
+{
+	u32 val;
+
+	if (enable) {
+		val = readl(edp->regs + VIDEO_CTL_1);
+		val |= VIDEO_MUTE;
+		writel(val, edp->regs + VIDEO_CTL_1);
+	} else {
+		val = readl(edp->regs + VIDEO_CTL_1);
+		val &= ~VIDEO_MUTE;
+		writel(val, edp->regs + VIDEO_CTL_1);
+	}
+}
+
+void rockchip_edp_stop_video(struct rockchip_edp_device *edp)
+{
+	u32 val;
+
+	val = readl(edp->regs + VIDEO_CTL_1);
+	val &= ~VIDEO_EN;
+	writel(val, edp->regs + VIDEO_CTL_1);
+}
+
+void rockchip_edp_lane_swap(struct rockchip_edp_device *edp, bool enable)
+{
+	u32 val;
+
+	if (enable)
+		val = LANE3_MAP_LOGIC_LANE_0 | LANE2_MAP_LOGIC_LANE_1 |
+			LANE1_MAP_LOGIC_LANE_2 | LANE0_MAP_LOGIC_LANE_3;
+	else
+		val = LANE3_MAP_LOGIC_LANE_3 | LANE2_MAP_LOGIC_LANE_2 |
+			LANE1_MAP_LOGIC_LANE_1 | LANE0_MAP_LOGIC_LANE_0;
+
+	writel(val, edp->regs + LANE_MAP);
+}
+
+void rockchip_edp_init_refclk(struct rockchip_edp_device *edp)
+{
+	writel(SEL_24M, edp->regs + ANALOG_CTL_2);
+	writel(REF_CLK_24M, edp->regs + PLL_REG_1);
+
+	writel(0x95, edp->regs + PLL_REG_2);
+	writel(0x40, edp->regs + PLL_REG_3);
+	writel(0x58, edp->regs + PLL_REG_4);
+	writel(0x22, edp->regs + PLL_REG_5);
+	writel(0x19, edp->regs + SSC_REG);
+	writel(0x87, edp->regs + TX_REG_COMMON);
+	writel(0x03, edp->regs + DP_AUX);
+	writel(0x46, edp->regs + DP_BIAS);
+	writel(0x55, edp->regs + DP_RESERVE2);
+}
+
+void rockchip_edp_init_interrupt(struct rockchip_edp_device *edp)
+{
+	/* Set interrupt pin assertion polarity as high */
+	writel(INT_POL, edp->regs + INT_CTL);
+
+	/* Clear pending valisers */
+	writel(0xff, edp->regs + COMMON_INT_STA_1);
+	writel(0x4f, edp->regs + COMMON_INT_STA_2);
+	writel(0xff, edp->regs + COMMON_INT_STA_3);
+	writel(0x27, edp->regs + COMMON_INT_STA_4);
+
+	writel(0x7f, edp->regs + DP_INT_STA);
+
+	/* 0:mask,1: unmask */
+	writel(0x00, edp->regs + COMMON_INT_MASK_1);
+	writel(0x00, edp->regs + COMMON_INT_MASK_2);
+	writel(0x00, edp->regs + COMMON_INT_MASK_3);
+	writel(0x00, edp->regs + COMMON_INT_MASK_4);
+	writel(0x00, edp->regs + DP_INT_STA_MASK);
+}
+
+void rockchip_edp_reset(struct rockchip_edp_device *edp)
+{
+	u32 val;
+
+	rockchip_edp_stop_video(edp);
+	rockchip_edp_enable_video_mute(edp, 0);
+
+	val = VID_CAP_FUNC_EN_N | AUD_FIFO_FUNC_EN_N |
+		AUD_FUNC_EN_N | HDCP_FUNC_EN_N | SW_FUNC_EN_N;
+	writel(val, edp->regs + FUNC_EN_1);
+
+	val = SSC_FUNC_EN_N | AUX_FUNC_EN_N |
+		SERDES_FIFO_FUNC_EN_N |
+		LS_CLK_DOMAIN_FUNC_EN_N;
+	writel(val, edp->regs + FUNC_EN_2);
+
+	usleep_range(20, 30);
+
+	rockchip_edp_lane_swap(edp, 0);
+
+	writel(0x0, edp->regs + SYS_CTL_1);
+	writel(0x40, edp->regs + SYS_CTL_2);
+	writel(0x0, edp->regs + SYS_CTL_3);
+	writel(0x0, edp->regs + SYS_CTL_4);
+
+	writel(0x0, edp->regs + PKT_SEND_CTL);
+	writel(0x0, edp->regs + HDCP_CTL);
+
+	writel(0x5e, edp->regs + HPD_DEGLITCH_L);
+	writel(0x1a, edp->regs + HPD_DEGLITCH_H);
+
+	writel(0x10, edp->regs + LINK_DEBUG_CTL);
+
+	writel(0x0, edp->regs + VIDEO_FIFO_THRD);
+	writel(0x20, edp->regs + AUDIO_MARGIN);
+
+	writel(0x4, edp->regs + M_VID_GEN_FILTER_TH);
+	writel(0x2, edp->regs + M_AUD_GEN_FILTER_TH);
+
+	writel(0x0, edp->regs + SOC_GENERAL_CTL);
+}
+
+void rockchip_edp_config_interrupt(struct rockchip_edp_device *edp)
+{
+	u32 val;
+
+	/* 0: mask, 1: unmask */
+	val = 0;
+	writel(val, edp->regs + COMMON_INT_MASK_1);
+
+	writel(val, edp->regs + COMMON_INT_MASK_2);
+
+	writel(val, edp->regs + COMMON_INT_MASK_3);
+
+	writel(val, edp->regs + COMMON_INT_MASK_4);
+
+	writel(val, edp->regs + DP_INT_STA_MASK);
+}
+
+u32 rockchip_edp_get_pll_lock_status(struct rockchip_edp_device *edp)
+{
+	u32 val;
+
+	val = readl(edp->regs + DEBUG_CTL);
+
+	return (val & PLL_LOCK) ? DP_PLL_LOCKED : DP_PLL_UNLOCKED;
+}
+
+void rockchip_edp_analog_power_ctr(struct rockchip_edp_device *edp,
+				   bool enable)
+{
+	u32 val;
+
+	if (enable) {
+		val = PD_EXP_BG | PD_AUX | PD_PLL |
+			PD_CH3 | PD_CH2 | PD_CH1 | PD_CH0;
+		writel(val, edp->regs + DP_PWRDN);
+		usleep_range(10, 20);
+		writel(0x0, edp->regs + DP_PWRDN);
+	} else {
+		val = PD_EXP_BG | PD_AUX | PD_PLL |
+			PD_CH3 | PD_CH2 | PD_CH1 | PD_CH0;
+		writel(val, edp->regs + DP_PWRDN);
+	}
+}
+
+void rockchip_edp_init_analog_func(struct rockchip_edp_device *edp)
+{
+	u32 val;
+	int wt = 0;
+
+	rockchip_edp_analog_power_ctr(edp, 1);
+
+	val = PLL_LOCK_CHG;
+	writel(val, edp->regs + COMMON_INT_STA_1);
+
+	val = readl(edp->regs + DEBUG_CTL);
+	val &= ~(F_PLL_LOCK | PLL_LOCK_CTRL);
+	writel(val, edp->regs + DEBUG_CTL);
+
+	/* Power up PLL */
+	while (wt < 100) {
+		if (rockchip_edp_get_pll_lock_status(edp) == DP_PLL_LOCKED) {
+			dev_dbg(edp->dev, "edp pll locked\n");
+			break;
+		}
+		wt++;
+		udelay(5);
+	}
+
+	/* Enable Serdes FIFO function and Link symbol clock domain module */
+	val = readl(edp->regs + FUNC_EN_2);
+	val &= ~(SERDES_FIFO_FUNC_EN_N | LS_CLK_DOMAIN_FUNC_EN_N
+		| AUX_FUNC_EN_N | SSC_FUNC_EN_N);
+	writel(val, edp->regs + FUNC_EN_2);
+}
+
+void rockchip_edp_init_hpd(struct rockchip_edp_device *edp)
+{
+	u32 val;
+
+	val = HOTPLUG_CHG | HPD_LOST | PLUG;
+	writel(val, edp->regs + COMMON_INT_STA_4);
+
+	val = INT_HPD;
+	writel(val, edp->regs + DP_INT_STA);
+
+	val = readl(edp->regs + SYS_CTL_3);
+	val |= (F_HPD | HPD_CTRL);
+	writel(val, edp->regs + SYS_CTL_3);
+}
+
+void rockchip_edp_reset_aux(struct rockchip_edp_device *edp)
+{
+	u32 val;
+
+	/* Disable AUX channel module */
+	val = readl(edp->regs + FUNC_EN_2);
+	val |= AUX_FUNC_EN_N;
+	writel(val, edp->regs + FUNC_EN_2);
+}
+
+void rockchip_edp_init_aux(struct rockchip_edp_device *edp)
+{
+	u32 val;
+
+	/* Clear inerrupts related to AUX channel */
+	val = RPLY_RECEIV | AUX_ERR;
+	writel(val, edp->regs + DP_INT_STA);
+
+	rockchip_edp_reset_aux(edp);
+
+	/* Receive AUX Channel DEFER commands equal to DEFFER_COUNT*64 */
+	val = DEFER_CTRL_EN | DEFER_COUNT(1);
+	writel(val, edp->regs + AUX_CH_DEFER_CTL);
+
+	/* Enable AUX channel module */
+	val = readl(edp->regs + FUNC_EN_2);
+	val &= ~AUX_FUNC_EN_N;
+	writel(val, edp->regs + FUNC_EN_2);
+}
+
+int rockchip_edp_get_plug_in_status(struct rockchip_edp_device *edp)
+{
+	u32 val;
+
+	val = readl(edp->regs + SYS_CTL_3);
+	if (val & HPD_STATUS)
+		return 0;
+
+	return -EINVAL;
+}
+
+void rockchip_edp_enable_sw_function(struct rockchip_edp_device *edp)
+{
+	u32 val;
+
+	val = readl(edp->regs + FUNC_EN_1);
+	val &= ~SW_FUNC_EN_N;
+	writel(val, edp->regs + FUNC_EN_1);
+}
+
+int rockchip_edp_start_aux_transaction(struct rockchip_edp_device *edp)
+{
+	int val;
+	int retval = 0;
+	int timeout_loop = 0;
+	int aux_timeout = 0;
+
+	/* Enable AUX CH operation */
+	val = readl(edp->regs + AUX_CH_CTL_2);
+	val |= AUX_EN;
+	writel(val, edp->regs + AUX_CH_CTL_2);
+
+	/* Is AUX CH operation enabled? */
+	val = readl(edp->regs + AUX_CH_CTL_2);
+	while (val & AUX_EN) {
+		aux_timeout++;
+		if ((DP_TIMEOUT_LOOP_CNT * 10) < aux_timeout) {
+			dev_err(edp->dev, "AUX CH enable timeout!\n");
+			return -ETIMEDOUT;
+		}
+		val = readl(edp->regs + AUX_CH_CTL_2);
+		usleep_range(1000, 2000);
+	}
+
+	/* Is AUX CH command redply received? */
+	val = readl(edp->regs + DP_INT_STA);
+	while (!(val & RPLY_RECEIV)) {
+		timeout_loop++;
+		if (DP_TIMEOUT_LOOP_CNT < timeout_loop) {
+			dev_err(edp->dev, "AUX CH command redply failed!\n");
+			return -ETIMEDOUT;
+		}
+		val = readl(edp->regs + DP_INT_STA);
+		usleep_range(10, 20);
+	}
+
+	/* Clear interrupt source for AUX CH command redply */
+	writel(RPLY_RECEIV, edp->regs + DP_INT_STA);
+
+	/* Clear interrupt source for AUX CH access error */
+	val = readl(edp->regs + DP_INT_STA);
+	if (val & AUX_ERR) {
+		writel(AUX_ERR, edp->regs + DP_INT_STA);
+		return -EREMOTEIO;
+	}
+
+	/* Check AUX CH error access status */
+	val = readl(edp->regs + AUX_CH_STA);
+	if ((val & AUX_STATUS_MASK) != 0) {
+		dev_err(edp->dev, "AUX CH error happens: %d\n\n",
+			val & AUX_STATUS_MASK);
+		return -EREMOTEIO;
+	}
+
+	return retval;
+}
+
+int rockchip_edp_write_byte_to_dpcd(struct rockchip_edp_device *edp,
+				    unsigned int val_addr,
+				    unsigned char data)
+{
+	u32 val;
+	int i;
+	int retval;
+
+	for (i = 0; i < 3; i++) {
+		/* Clear AUX CH data buffer */
+		val = BUF_CLR;
+		writel(val, edp->regs + BUFFER_DATA_CTL);
+
+		/* Select DPCD device address */
+		val = AUX_ADDR_7_0(val_addr);
+		writel(val, edp->regs + DP_AUX_ADDR_7_0);
+		val = AUX_ADDR_15_8(val_addr);
+		writel(val, edp->regs + DP_AUX_ADDR_15_8);
+		val = AUX_ADDR_19_16(val_addr);
+		writel(val, edp->regs + DP_AUX_ADDR_19_16);
+
+		/* Write data buffer */
+		val = (unsigned int)data;
+		writel(val, edp->regs + BUF_DATA_0);
+
+		/*
+		 * Set DisplayPort transaction and write 1 byte
+		 * If bit 3 is 1, DisplayPort transaction.
+		 * If Bit 3 is 0, I2C transaction.
+		 */
+		val = AUX_TX_COMM_DP_TRANSACTION | AUX_TX_COMM_WRITE;
+		writel(val, edp->regs + AUX_CH_CTL_1);
+
+		/* Start AUX transaction */
+		retval = rockchip_edp_start_aux_transaction(edp);
+		if (retval == 0)
+			break;
+
+		dev_dbg(edp->dev, "Aux Transaction fail!\n");
+	}
+
+	return retval;
+}
+
+int rockchip_edp_read_byte_from_dpcd(struct rockchip_edp_device *edp,
+				     unsigned int val_addr,
+				     unsigned char *data)
+{
+	u32 val;
+	int i;
+	int retval;
+
+	for (i = 0; i < 10; i++) {
+		/* Clear AUX CH data buffer */
+		val = BUF_CLR;
+		writel(val, edp->regs + BUFFER_DATA_CTL);
+
+		/* Select DPCD device address */
+		val = AUX_ADDR_7_0(val_addr);
+		writel(val, edp->regs + DP_AUX_ADDR_7_0);
+		val = AUX_ADDR_15_8(val_addr);
+		writel(val, edp->regs + DP_AUX_ADDR_15_8);
+		val = AUX_ADDR_19_16(val_addr);
+		writel(val, edp->regs + DP_AUX_ADDR_19_16);
+
+		/*
+		 * Set DisplayPort transaction and read 1 byte
+		 * If bit 3 is 1, DisplayPort transaction.
+		 * If Bit 3 is 0, I2C transaction.
+		 */
+		val = AUX_TX_COMM_DP_TRANSACTION | AUX_TX_COMM_READ;
+		writel(val, edp->regs + AUX_CH_CTL_1);
+
+		/* Start AUX transaction */
+		retval = rockchip_edp_start_aux_transaction(edp);
+		if (retval == 0)
+			break;
+
+		dev_dbg(edp->dev, "Aux Transaction fail!\n");
+	}
+
+	/* Read data buffer */
+	val = readl(edp->regs + BUF_DATA_0);
+	*data = (unsigned char)(val & 0xff);
+
+	return retval;
+}
+
+int rockchip_edp_write_bytes_to_dpcd(struct rockchip_edp_device *edp,
+				     unsigned int val_addr,
+				     unsigned int count,
+				     unsigned char data[])
+{
+	u32 val;
+	unsigned int start_offset;
+	unsigned int cur_data_count;
+	unsigned int cur_data_idx;
+	int i;
+	int retval = 0;
+
+	/* Clear AUX CH data buffer */
+	val = BUF_CLR;
+	writel(val, edp->regs + BUFFER_DATA_CTL);
+
+	start_offset = 0;
+	while (start_offset < count) {
+		/* Buffer size of AUX CH is 16 * 4bytes */
+		if ((count - start_offset) > 16)
+			cur_data_count = 16;
+		else
+			cur_data_count = count - start_offset;
+
+		for (i = 0; i < 10; i++) {
+			/* Select DPCD device address */
+			val = AUX_ADDR_7_0(val_addr + start_offset);
+			writel(val, edp->regs + DP_AUX_ADDR_7_0);
+			val = AUX_ADDR_15_8(val_addr + start_offset);
+			writel(val, edp->regs + DP_AUX_ADDR_15_8);
+			val = AUX_ADDR_19_16(val_addr + start_offset);
+			writel(val, edp->regs + DP_AUX_ADDR_19_16);
+
+			for (cur_data_idx = 0; cur_data_idx < cur_data_count;
+			     cur_data_idx++) {
+				val = data[start_offset + cur_data_idx];
+				writel(val, edp->regs + BUF_DATA_0
+							  + 4 * cur_data_idx);
+			}
+
+			/*
+			 * Set DisplayPort transaction and write
+			 * If bit 3 is 1, DisplayPort transaction.
+			 * If Bit 3 is 0, I2C transaction.
+			 */
+			val = AUX_LENGTH(cur_data_count) |
+				AUX_TX_COMM_DP_TRANSACTION | AUX_TX_COMM_WRITE;
+			writel(val, edp->regs + AUX_CH_CTL_1);
+
+			/* Start AUX transaction */
+			retval = rockchip_edp_start_aux_transaction(edp);
+			if (retval == 0)
+				break;
+
+			dev_dbg(edp->dev, "Aux Transaction fail!\n");
+		}
+
+		start_offset += cur_data_count;
+	}
+
+	return retval;
+}
+
+int rockchip_edp_read_bytes_from_dpcd(struct rockchip_edp_device *edp,
+				      unsigned int val_addr,
+				      unsigned int count,
+				      unsigned char data[])
+{
+	u32 val;
+	unsigned int start_offset;
+	unsigned int cur_data_count;
+	unsigned int cur_data_idx;
+	int i;
+	int retval = 0;
+
+	/* Clear AUX CH data buffer */
+	val = BUF_CLR;
+	writel(val, edp->regs + BUFFER_DATA_CTL);
+
+	start_offset = 0;
+	while (start_offset < count) {
+		/* Buffer size of AUX CH is 16 * 4bytes */
+		if ((count - start_offset) > 16)
+			cur_data_count = 16;
+		else
+			cur_data_count = count - start_offset;
+
+		/* AUX CH Request Transaction process */
+		for (i = 0; i < 10; i++) {
+			/* Select DPCD device address */
+			val = AUX_ADDR_7_0(val_addr + start_offset);
+			writel(val, edp->regs + DP_AUX_ADDR_7_0);
+			val = AUX_ADDR_15_8(val_addr + start_offset);
+			writel(val, edp->regs + DP_AUX_ADDR_15_8);
+			val = AUX_ADDR_19_16(val_addr + start_offset);
+			writel(val, edp->regs + DP_AUX_ADDR_19_16);
+
+			/*
+			 * Set DisplayPort transaction and read
+			 * If bit 3 is 1, DisplayPort transaction.
+			 * If Bit 3 is 0, I2C transaction.
+			 */
+			val = AUX_LENGTH(cur_data_count) |
+				AUX_TX_COMM_DP_TRANSACTION | AUX_TX_COMM_READ;
+			writel(val, edp->regs + AUX_CH_CTL_1);
+
+			/* Start AUX transaction */
+			retval = rockchip_edp_start_aux_transaction(edp);
+			if (retval == 0)
+				break;
+
+			dev_dbg(edp->dev, "Aux Transaction fail!\n");
+		}
+
+		for (cur_data_idx = 0; cur_data_idx < cur_data_count;
+		    cur_data_idx++) {
+			val = readl(edp->regs + BUF_DATA_0
+						 + 4 * cur_data_idx);
+			data[start_offset + cur_data_idx] =
+				(unsigned char)val;
+		}
+
+		start_offset += cur_data_count;
+	}
+
+	return retval;
+}
+
+int rockchip_edp_select_i2c_device(struct rockchip_edp_device *edp,
+				   unsigned int device_addr,
+				   unsigned int val_addr)
+{
+	u32 val;
+	int retval;
+
+	/* Set EDID device address */
+	val = device_addr;
+	writel(val, edp->regs + DP_AUX_ADDR_7_0);
+	writel(0x0, edp->regs + DP_AUX_ADDR_15_8);
+	writel(0x0, edp->regs + DP_AUX_ADDR_19_16);
+
+	/* Set offset from base address of EDID device */
+	writel(val_addr, edp->regs + BUF_DATA_0);
+
+	/*
+	 * Set I2C transaction and write address
+	 * If bit 3 is 1, DisplayPort transaction.
+	 * If Bit 3 is 0, I2C transaction.
+	 */
+	val = AUX_TX_COMM_I2C_TRANSACTION | AUX_TX_COMM_MOT |
+		AUX_TX_COMM_WRITE;
+	writel(val, edp->regs + AUX_CH_CTL_1);
+
+	/* Start AUX transaction */
+	retval = rockchip_edp_start_aux_transaction(edp);
+	if (retval != 0)
+		dev_dbg(edp->dev, "Aux Transaction fail!\n");
+
+	return retval;
+}
+
+int rockchip_edp_read_byte_from_i2c(struct rockchip_edp_device *edp,
+				    unsigned int device_addr,
+				    unsigned int val_addr,
+				    unsigned int *data)
+{
+	u32 val;
+	int i;
+	int retval;
+
+	for (i = 0; i < 10; i++) {
+		/* Clear AUX CH data buffer */
+		val = BUF_CLR;
+		writel(val, edp->regs + BUFFER_DATA_CTL);
+
+		/* Select EDID device */
+		retval = rockchip_edp_select_i2c_device(edp,
+							device_addr,
+							val_addr);
+		if (retval != 0) {
+			dev_err(edp->dev, "Select EDID device fail!\n");
+			continue;
+		}
+
+		/*
+		 * Set I2C transaction and read data
+		 * If bit 3 is 1, DisplayPort transaction.
+		 * If Bit 3 is 0, I2C transaction.
+		 */
+		val = AUX_TX_COMM_I2C_TRANSACTION | AUX_TX_COMM_READ;
+		writel(val, edp->regs + AUX_CH_CTL_1);
+
+		/* Start AUX transaction */
+		retval = rockchip_edp_start_aux_transaction(edp);
+		if (retval == 0)
+			break;
+
+		dev_dbg(edp->dev, "Aux Transaction fail!\n");
+	}
+
+	/* Read data */
+	if (retval == 0)
+		*data = readl(edp->regs + BUF_DATA_0);
+
+	return retval;
+}
+
+int rockchip_edp_read_bytes_from_i2c(struct rockchip_edp_device *edp,
+				     unsigned int device_addr,
+				     unsigned int val_addr,
+				     unsigned int count,
+				     unsigned char edid[])
+{
+	u32 val;
+	unsigned int i, j;
+	unsigned int cur_data_idx;
+	unsigned int defer = 0;
+	int retval = 0;
+
+	for (i = 0; i < count; i += 16) {
+		for (j = 0; j < 100; j++) {
+			/* Clear AUX CH data buffer */
+			val = BUF_CLR;
+			writel(val, edp->regs + BUFFER_DATA_CTL);
+
+			/* Set normal AUX CH command */
+			val = readl(edp->regs + AUX_CH_CTL_2);
+			val &= ~ADDR_ONLY;
+			writel(val, edp->regs + AUX_CH_CTL_2);
+
+			/*
+			 * If Rx sends defer, Tx sends only reads
+			 * request without sending addres
+			 */
+			if (!defer)
+				retval = rockchip_edp_select_i2c_device(
+						edp, device_addr, val_addr + i);
+			else
+				defer = 0;
+
+			/*
+			 * Set I2C transaction and write data
+			 * If bit 3 is 1, DisplayPort transaction.
+			 * If Bit 3 is 0, I2C transaction.
+			 */
+			val = AUX_LENGTH(16) | AUX_TX_COMM_I2C_TRANSACTION |
+				AUX_TX_COMM_READ;
+			writel(val, edp->regs + AUX_CH_CTL_1);
+
+			/* Start AUX transaction */
+			retval = rockchip_edp_start_aux_transaction(edp);
+			if (retval == 0)
+				break;
+
+			dev_dbg(edp->dev, "Aux Transaction fail!\n");
+
+			/* Check if Rx sends defer */
+			val = readl(edp->regs + AUX_RX_COMM);
+			if (val == AUX_RX_COMM_AUX_DEFER ||
+			    val == AUX_RX_COMM_I2C_DEFER) {
+				dev_err(edp->dev, "Defer: %d\n\n", val);
+				defer = 1;
+			}
+		}
+
+		for (cur_data_idx = 0; cur_data_idx < 16; cur_data_idx++) {
+			val = readl(edp->regs + BUF_DATA_0 + 4 * cur_data_idx);
+			edid[i + cur_data_idx] = (unsigned char)val;
+		}
+	}
+
+	return retval;
+}
+
+void rockchip_edp_set_link_bandwidth(struct rockchip_edp_device *edp,
+				     u32 bwtype)
+{
+	u32 val;
+
+	val = bwtype;
+	if ((bwtype == DP_LINK_BW_2_7) || (bwtype == DP_LINK_BW_1_62))
+		writel(val, edp->regs + LINK_BW_SET);
+}
+
+void rockchip_edp_get_link_bandwidth(struct rockchip_edp_device *edp,
+				     u32 *bwtype)
+{
+	u32 val;
+
+	val = readl(edp->regs + LINK_BW_SET);
+	*bwtype = val;
+}
+
+void rockchip_edp_hw_link_training_en(struct rockchip_edp_device *edp)
+{
+	u32 val;
+
+	val = HW_LT_EN;
+	writel(val, edp->regs + HW_LT_CTL);
+}
+
+int rockchip_edp_wait_hw_lt_done(struct rockchip_edp_device *edp)
+{
+	u32 val;
+
+	val = readl(edp->regs + DP_INT_STA);
+	if (val&HW_LT_DONE) {
+		writel(val, edp->regs + DP_INT_STA);
+		return 0;
+	}
+
+	return 1;
+}
+
+int rockchip_edp_get_hw_lt_status(struct rockchip_edp_device *edp)
+{
+	u32 val;
+
+	val = readl(edp->regs + HW_LT_CTL);
+
+	return (val & HW_LT_ERR_CODE_MASK) >> 4;
+}
+
+void rockchip_edp_set_lane_count(struct rockchip_edp_device *edp, u32 count)
+{
+	u32 val;
+
+	val = count;
+	writel(val, edp->regs + LANE_CNT_SET);
+}
+
+void rockchip_edp_get_lane_count(struct rockchip_edp_device *edp, u32 *count)
+{
+	u32 val;
+
+	val = readl(edp->regs + LANE_CNT_SET);
+	*count = val;
+}
+
+void rockchip_edp_enable_enhanced_mode(struct rockchip_edp_device *edp,
+				       bool enable)
+{
+	u32 val;
+
+	if (enable) {
+		val = readl(edp->regs + SYS_CTL_4);
+		val |= ENHANCED;
+		writel(val, edp->regs + SYS_CTL_4);
+	} else {
+		val = readl(edp->regs + SYS_CTL_4);
+		val &= ~ENHANCED;
+		writel(val, edp->regs + SYS_CTL_4);
+	}
+}
+
+void rockchip_edp_set_training_pattern(struct rockchip_edp_device *edp,
+				       enum pattern_set pattern)
+{
+	u32 val;
+
+	switch (pattern) {
+	case PRBS7:
+		val = SCRAMBLING_ENABLE | LINK_QUAL_PATTERN_SET_PRBS7;
+		writel(val, edp->regs + TRAINING_PTN_SET);
+		break;
+	case D10_2:
+		val = SCRAMBLING_ENABLE | LINK_QUAL_PATTERN_SET_D10_2;
+		writel(val, edp->regs + TRAINING_PTN_SET);
+		break;
+	case TRAINING_PTN1:
+		val = SCRAMBLING_DISABLE | SW_TRAINING_PATTERN_SET_PTN1;
+		writel(val, edp->regs + TRAINING_PTN_SET);
+		break;
+	case TRAINING_PTN2:
+		val = SCRAMBLING_DISABLE | SW_TRAINING_PATTERN_SET_PTN2;
+		writel(val, edp->regs + TRAINING_PTN_SET);
+		break;
+	case DP_NONE:
+		val = SCRAMBLING_ENABLE |
+			LINK_QUAL_PATTERN_SET_DISABLE |
+			SW_TRAINING_PATTERN_SET_DISABLE;
+		writel(val, edp->regs + TRAINING_PTN_SET);
+		break;
+	default:
+		break;
+	}
+}
+
+void rockchip_edp_set_lane0_pre_emphasis(struct rockchip_edp_device *edp,
+					 u32 level)
+{
+	u32 val;
+
+	val = level << PRE_EMPHASIS_SET_SHIFT;
+	writel(val, edp->regs + LN0_LINK_TRAINING_CTL);
+}
+
+void rockchip_edp_set_lane1_pre_emphasis(struct rockchip_edp_device *edp,
+					 u32 level)
+{
+	u32 val;
+
+	val = level << PRE_EMPHASIS_SET_SHIFT;
+	writel(val, edp->regs + LN1_LINK_TRAINING_CTL);
+}
+
+void rockchip_edp_set_lane2_pre_emphasis(struct rockchip_edp_device *edp,
+					 u32 level)
+{
+	u32 val;
+
+	val = level << PRE_EMPHASIS_SET_SHIFT;
+	writel(val, edp->regs + LN2_LINK_TRAINING_CTL);
+}
+
+void rockchip_edp_set_lane3_pre_emphasis(struct rockchip_edp_device *edp,
+					 u32 level)
+{
+	u32 val;
+
+	val = level << PRE_EMPHASIS_SET_SHIFT;
+	writel(val, edp->regs + LN3_LINK_TRAINING_CTL);
+}
+
+void rockchip_edp_set_lane0_link_training(struct rockchip_edp_device *edp,
+					  u32 training_lane)
+{
+	u32 val;
+
+	val = training_lane;
+	writel(val, edp->regs + LN0_LINK_TRAINING_CTL);
+}
+
+void rockchip_edp_set_lane1_link_training(struct rockchip_edp_device *edp,
+					  u32 training_lane)
+{
+	u32 val;
+
+	val = training_lane;
+	writel(val, edp->regs + LN1_LINK_TRAINING_CTL);
+}
+
+void rockchip_edp_set_lane2_link_training(struct rockchip_edp_device *edp,
+					  u32 training_lane)
+{
+	u32 val;
+
+	val = training_lane;
+	writel(val, edp->regs + LN2_LINK_TRAINING_CTL);
+}
+
+void rockchip_edp_set_lane3_link_training(struct rockchip_edp_device *edp,
+					  u32 training_lane)
+{
+	u32 val;
+
+	val = training_lane;
+	writel(val, edp->regs + LN3_LINK_TRAINING_CTL);
+}
+
+u32 rockchip_edp_get_lane0_link_training(struct rockchip_edp_device *edp)
+{
+	u32 val;
+
+	val = readl(edp->regs + LN0_LINK_TRAINING_CTL);
+	return val;
+}
+
+u32 rockchip_edp_get_lane1_link_training(struct rockchip_edp_device *edp)
+{
+	u32 val;
+
+	val = readl(edp->regs + LN1_LINK_TRAINING_CTL);
+	return val;
+}
+
+u32 rockchip_edp_get_lane2_link_training(struct rockchip_edp_device *edp)
+{
+	u32 val;
+
+	val = readl(edp->regs + LN2_LINK_TRAINING_CTL);
+	return val;
+}
+
+u32 rockchip_edp_get_lane3_link_training(struct rockchip_edp_device *edp)
+{
+	u32 val;
+
+	val = readl(edp->regs + LN3_LINK_TRAINING_CTL);
+	return val;
+}
+
+void rockchip_edp_reset_macro(struct rockchip_edp_device *edp)
+{
+}
+
+int rockchip_edp_init_video(struct rockchip_edp_device *edp)
+{
+	u32 val;
+
+	val = VSYNC_DET | VID_FORMAT_CHG | VID_CLK_CHG;
+	writel(val, edp->regs + COMMON_INT_STA_1);
+
+	val = 0x0;
+	writel(val, edp->regs + SYS_CTL_1);
+
+	val = CHA_CRI(4) | CHA_CTRL;
+	writel(val, edp->regs + SYS_CTL_2);
+
+	val = VID_HRES_TH(2) | VID_VRES_TH(0);
+	writel(val, edp->regs + VIDEO_CTL_8);
+
+	return 0;
+}
+
+void rockchip_edp_set_video_color_format(struct rockchip_edp_device *edp,
+					 u32 color_dedpth,
+					 u32 color_space,
+					 u32 dynamic_range,
+					 u32 coeff)
+{
+	u32 val;
+
+	/* Configure the input color dedpth, color space, dynamic range */
+	val = (dynamic_range << IN_D_RANGE_SHIFT) |
+		(color_dedpth << IN_BPC_SHIFT) |
+		(color_space << IN_COLOR_F_SHIFT);
+	writel(val, edp->regs + VIDEO_CTL_2);
+
+	/* Set Input Color YCbCr Coefficients to ITU601 or ITU709 */
+	val = readl(edp->regs + VIDEO_CTL_3);
+	val &= ~IN_YC_COEFFI_MASK;
+	if (coeff)
+		val |= IN_YC_COEFFI_ITU709;
+	else
+		val |= IN_YC_COEFFI_ITU601;
+	writel(val, edp->regs + VIDEO_CTL_3);
+}
+
+int rockchip_edp_is_slave_video_stream_clock_on(struct rockchip_edp_device *edp)
+{
+	u32 val;
+
+	val = readl(edp->regs + SYS_CTL_1);
+	writel(val, edp->regs + SYS_CTL_1);
+
+	val = readl(edp->regs + SYS_CTL_1);
+
+	if (!(val & DET_STA)) {
+		dev_dbg(edp->dev, "Input stream clock not detected.\n");
+		return -EINVAL;
+	}
+
+	val = readl(edp->regs + SYS_CTL_2);
+	writel(val, edp->regs + SYS_CTL_2);
+
+	val = readl(edp->regs + SYS_CTL_2);
+	if (val & CHA_STA) {
+		dev_dbg(edp->dev, "Input stream clk is changing\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+void rockchip_edp_set_video_cr_mn(struct rockchip_edp_device *edp,
+				  enum clock_recovery_m_value_type type,
+				  u32 m_value,
+				  u32 n_value)
+{
+	u32 val;
+
+	if (type == REGISTER_M) {
+		val = readl(edp->regs + SYS_CTL_4);
+		val |= FIX_M_VID;
+		writel(val, edp->regs + SYS_CTL_4);
+		val = m_value & 0xff;
+		writel(val, edp->regs + M_VID_0);
+		val = (m_value >> 8) & 0xff;
+		writel(val, edp->regs + M_VID_1);
+		val = (m_value >> 16) & 0xff;
+		writel(val, edp->regs + M_VID_2);
+
+		val = n_value & 0xff;
+		writel(val, edp->regs + N_VID_0);
+		val = (n_value >> 8) & 0xff;
+		writel(val, edp->regs + N_VID_1);
+		val = (n_value >> 16) & 0xff;
+		writel(val, edp->regs + N_VID_2);
+	} else  {
+		val = readl(edp->regs + SYS_CTL_4);
+		val &= ~FIX_M_VID;
+		writel(val, edp->regs + SYS_CTL_4);
+
+		writel(0x00, edp->regs + N_VID_0);
+		writel(0x80, edp->regs + N_VID_1);
+		writel(0x00, edp->regs + N_VID_2);
+	}
+}
+
+void rockchip_edp_set_video_timing_mode(struct rockchip_edp_device *edp,
+					u32 type)
+{
+	u32 val;
+
+	if (type == VIDEO_TIMING_FROM_CAPTURE) {
+		val = readl(edp->regs + VIDEO_CTL_10);
+		val &= ~F_SEL;
+		writel(val, edp->regs + VIDEO_CTL_10);
+	} else {
+		val = readl(edp->regs + VIDEO_CTL_10);
+		val |= F_SEL;
+		writel(val, edp->regs + VIDEO_CTL_10);
+	}
+}
+
+int rockchip_edp_bist_cfg(struct rockchip_edp_device *edp)
+{
+	struct video_info *video_info = &edp->video_info;
+	struct drm_display_mode *mode = &edp->mode;
+	u16 x_total, y_total, x_act;
+	u32 val;
+
+	x_total = mode->htotal;
+	y_total = mode->vtotal;
+	x_act = mode->hdisplay;
+
+	rockchip_edp_set_video_cr_mn(edp, CALCULATED_M, 0, 0);
+	rockchip_edp_set_video_color_format(edp, video_info->color_depth,
+					    video_info->color_space,
+					    video_info->dynamic_range,
+					    video_info->ycbcr_coeff);
+
+	val = y_total & 0xff;
+	writel(val, edp->regs + TOTAL_LINE_CFG_L);
+	val = (y_total >> 8);
+	writel(val, edp->regs + TOTAL_LINE_CFG_H);
+	val = (mode->vdisplay & 0xff);
+	writel(val, edp->regs + ATV_LINE_CFG_L);
+	val = (mode->vdisplay >> 8);
+	writel(val, edp->regs + ATV_LINE_CFG_H);
+	val = (mode->vsync_start - mode->vdisplay);
+	writel(val, edp->regs + VF_PORCH_REG);
+	val = (mode->vsync_end - mode->vsync_start);
+	writel(val, edp->regs + VSYNC_CFG_REG);
+	val = (mode->vtotal - mode->vsync_end);
+	writel(val, edp->regs + VB_PORCH_REG);
+	val = x_total & 0xff;
+	writel(val, edp->regs + TOTAL_PIXELL_REG);
+	val = x_total >> 8;
+	writel(val, edp->regs + TOTAL_PIXELH_REG);
+	val = (x_act & 0xff);
+	writel(val, edp->regs + ATV_PIXELL_REG);
+	val = (x_act >> 8);
+	writel(val, edp->regs + ATV_PIXELH_REG);
+	val = (mode->hsync_start - mode->hdisplay) & 0xff;
+	writel(val, edp->regs + HF_PORCHL_REG);
+	val = (mode->hsync_start - mode->hdisplay) >> 8;
+	writel(val, edp->regs + HF_PORCHH_REG);
+	val = (mode->hsync_end - mode->hsync_start) & 0xff;
+	writel(val, edp->regs + HSYNC_CFGL_REG);
+	val = (mode->hsync_end - mode->hsync_start) >> 8;
+	writel(val, edp->regs + HSYNC_CFGH_REG);
+	val = (mode->htotal - mode->hsync_end) & 0xff;
+	writel(val, edp->regs + HB_PORCHL_REG);
+	val = (mode->htotal - mode->hsync_end)  >> 8;
+	writel(val, edp->regs + HB_PORCHH_REG);
+
+	val = BIST_EN | BIST_WH_64 | BIST_TYPE_COLR_BAR;
+	writel(val, edp->regs + VIDEO_CTL_4);
+
+	val = readl(edp->regs + VIDEO_CTL_10);
+	val &= ~F_SEL;
+	writel(val, edp->regs + VIDEO_CTL_10);
+	return 0;
+}
+
+void rockchip_edp_enable_video_master(struct rockchip_edp_device *edp,
+				      bool enable)
+{
+}
+
+void rockchip_edp_start_video(struct rockchip_edp_device *edp)
+{
+	u32 val;
+
+	val = readl(edp->regs + VIDEO_CTL_1);
+	val |= VIDEO_EN;
+	writel(val, edp->regs + VIDEO_CTL_1);
+}
+
+int rockchip_edp_is_video_stream_on(struct rockchip_edp_device *edp)
+{
+	u32 val;
+
+	val = readl(edp->regs + SYS_CTL_3);
+	writel(val, edp->regs + SYS_CTL_3);
+
+	val = readl(edp->regs + SYS_CTL_3);
+	if (!(val & STRM_VALID)) {
+		dev_dbg(edp->dev, "Input video stream is not detected.\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+void rockchip_edp_config_video_slave_mode(struct rockchip_edp_device *edp,
+					  struct video_info *video_info)
+{
+	u32 val;
+
+	val = readl(edp->regs + FUNC_EN_1);
+	val &= ~(VID_FIFO_FUNC_EN_N | VID_CAP_FUNC_EN_N);
+	writel(val, edp->regs + FUNC_EN_1);
+
+	val = readl(edp->regs + VIDEO_CTL_10);
+	val &= ~INTERACE_SCAN_CFG;
+	val |= (video_info->interlaced << 2);
+	writel(val, edp->regs + VIDEO_CTL_10);
+
+	val = readl(edp->regs + VIDEO_CTL_10);
+	val &= ~VSYNC_POLARITY_CFG;
+	val |= (video_info->v_sync_polarity << 1);
+	writel(val, edp->regs + VIDEO_CTL_10);
+
+	val = readl(edp->regs + VIDEO_CTL_10);
+	val &= ~HSYNC_POLARITY_CFG;
+	val |= (video_info->h_sync_polarity << 0);
+	writel(val, edp->regs + VIDEO_CTL_10);
+}
+
+void rockchip_edp_enable_scrambling(struct rockchip_edp_device *edp)
+{
+	u32 val;
+
+	val = readl(edp->regs + TRAINING_PTN_SET);
+	val &= ~SCRAMBLING_DISABLE;
+	writel(val, edp->regs + TRAINING_PTN_SET);
+}
+
+void rockchip_edp_disable_scrambling(struct rockchip_edp_device *edp)
+{
+	u32 val;
+
+	val = readl(edp->regs + TRAINING_PTN_SET);
+	val |= SCRAMBLING_DISABLE;
+	writel(val, edp->regs + TRAINING_PTN_SET);
+}
+
+enum dp_irq_type rockchip_edp_get_irq_type(struct rockchip_edp_device *edp)
+{
+	u32 val;
+
+	/* Parse hotplug interrupt status register */
+	val = readl(edp->regs + COMMON_INT_STA_4);
+	if (val & PLUG)
+		return DP_IRQ_TYPE_HP_CABLE_IN;
+
+	if (val & HPD_LOST)
+		return DP_IRQ_TYPE_HP_CABLE_OUT;
+
+	if (val & HOTPLUG_CHG)
+		return DP_IRQ_TYPE_HP_CHANGE;
+
+	return DP_IRQ_TYPE_UNKNOWN;
+}
+
+void rockchip_edp_clear_hotplug_interrupts(struct rockchip_edp_device *edp)
+{
+	u32 val;
+
+	val = HOTPLUG_CHG | HPD_LOST | PLUG;
+	writel(val, edp->regs + COMMON_INT_STA_4);
+
+	val = INT_HPD;
+	writel(val, edp->regs + DP_INT_STA);
+}
diff --git a/drivers/gpu/drm/rockchip/rockchip_edp_reg.h b/drivers/gpu/drm/rockchip/rockchip_edp_reg.h
new file mode 100644
index 0000000..b50dd47
--- /dev/null
+++ b/drivers/gpu/drm/rockchip/rockchip_edp_reg.h
@@ -0,0 +1,345 @@
+/*
+* Copyright (C) Fuzhou Rockchip Electronics Co.Ltd
+* Author:
+*      Andy yan <andy.yan-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
+*      Jeff chen <jeff.chen-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
+*
+* based on exynos_dp_reg.h
+*
+* This program is free software; you can redistribute it and/or modify it
+* under the terms of the GNU General Public License as published by the
+* Free Software Foundation; either version 2 of the License, or (at your
+* option) any later version.
+*/
+
+#ifndef _ROCKCHIP_EDP_REG_H
+#define _ROCKCHIP_EDP_REG_H
+
+#include <linux/bitops.h>
+
+#define TX_SW_RST				0x14
+#define FUNC_EN_1				0x18
+#define FUNC_EN_2				0x1C
+#define VIDEO_CTL_1				0x20
+#define VIDEO_CTL_2				0x24
+#define VIDEO_CTL_3				0x28
+#define VIDEO_CTL_4				0x2c
+#define VIDEO_CTL_8				0x3C
+#define VIDEO_CTL_10				0x44
+#define TOTAL_LINE_CFG_L			0x48
+#define TOTAL_LINE_CFG_H			0x4c
+#define ATV_LINE_CFG_L				0x50
+#define ATV_LINE_CFG_H				0x54
+#define VF_PORCH_REG				0x58
+#define VSYNC_CFG_REG				0x5c
+#define VB_PORCH_REG				0x60
+#define TOTAL_PIXELL_REG			0x64
+#define TOTAL_PIXELH_REG			0x68
+#define ATV_PIXELL_REG				0x6c
+#define ATV_PIXELH_REG				0x70
+#define HF_PORCHL_REG				0x74
+#define HF_PORCHH_REG				0x78
+#define HSYNC_CFGL_REG				0x7c
+#define HSYNC_CFGH_REG				0x80
+#define HB_PORCHL_REG				0x84
+#define HB_PORCHH_REG				0x88
+#define PLL_REG_1				0xfc
+
+#define SSC_REG					0x104
+#define TX_REG_COMMON				0x114
+#define DP_AUX					0x120
+#define DP_BIAS					0x124
+#define DP_PWRDN				0x12c
+#define DP_RESERVE2				0x134
+
+#define LANE_MAP				0x35C
+#define ANALOG_CTL_2				0x374
+#define AUX_HW_RETRY_CTL			0x390
+#define COMMON_INT_STA_1			0x3C4
+#define COMMON_INT_STA_2			0x3C8
+#define COMMON_INT_STA_3			0x3CC
+#define COMMON_INT_STA_4			0x3D0
+#define DP_INT_STA				0x3DC
+#define COMMON_INT_MASK_1			0x3E0
+#define COMMON_INT_MASK_2			0x3E4
+#define COMMON_INT_MASK_3			0x3E8
+#define COMMON_INT_MASK_4			0x3EC
+#define DP_INT_STA_MASK				0x3F8
+
+#define SYS_CTL_1				0x600
+#define SYS_CTL_2				0x604
+#define SYS_CTL_3				0x608
+#define SYS_CTL_4				0x60C
+#define PKT_SEND_CTL				0x640
+#define HDCP_CTL				0x648
+#define LINK_BW_SET				0x680
+#define LANE_CNT_SET				0x684
+#define TRAINING_PTN_SET			0x688
+#define LN0_LINK_TRAINING_CTL			0x68C
+#define LN1_LINK_TRAINING_CTL			0x690
+#define LN2_LINK_TRAINING_CTL			0x694
+#define LN3_LINK_TRAINING_CTL			0x698
+#define HW_LT_CTL				0x6a0
+#define DEBUG_CTL				0x6C0
+#define HPD_DEGLITCH_L				0x6C4
+#define HPD_DEGLITCH_H				0x6C8
+#define LINK_DEBUG_CTL				0x6E0
+#define M_VID_0					0x700
+#define M_VID_1					0x704
+#define M_VID_2					0x708
+#define N_VID_0					0x70C
+#define N_VID_1					0x710
+#define N_VID_2					0x714
+#define VIDEO_FIFO_THRD				0x730
+#define AUDIO_MARGIN				0x73C
+#define M_VID_GEN_FILTER_TH			0x764
+#define M_AUD_GEN_FILTER_TH			0x778
+#define AUX_CH_STA				0x780
+#define AUX_CH_DEFER_CTL			0x788
+#define AUX_RX_COMM				0x78C
+#define BUFFER_DATA_CTL				0x790
+#define AUX_CH_CTL_1				0x794
+#define DP_AUX_ADDR_7_0				0x798
+#define DP_AUX_ADDR_15_8			0x79C
+#define DP_AUX_ADDR_19_16			0x7A0
+#define AUX_CH_CTL_2				0x7A4
+#define BUF_DATA_0				0x7C0
+#define SOC_GENERAL_CTL				0x800
+#define PLL_REG_2				0x9e4
+#define PLL_REG_3				0x9e8
+#define PLL_REG_4				0x9ec
+#define PLL_REG_5				0xa00
+
+/* ROCKCHIP_EDP_FUNC_EN_1 */
+#define VID_CAP_FUNC_EN_N			BIT(6)
+#define VID_FIFO_FUNC_EN_N			BIT(5)
+#define AUD_FIFO_FUNC_EN_N			BIT(4)
+#define AUD_FUNC_EN_N				BIT(3)
+#define HDCP_FUNC_EN_N				BIT(2)
+#define SW_FUNC_EN_N				BIT(0)
+
+/* ROCKCHIP_EDP_FUNC_EN_2 */
+#define SSC_FUNC_EN_N				BIT(7)
+#define AUX_FUNC_EN_N				BIT(2)
+#define SERDES_FIFO_FUNC_EN_N			BIT(1)
+#define LS_CLK_DOMAIN_FUNC_EN_N			BIT(0)
+
+/* ROCKCHIP_EDP_VIDEO_CTL_1 */
+#define VIDEO_EN				BIT(7)
+#define VIDEO_MUTE				BIT(6)
+
+/* ROCKCHIP_EDP_VIDEO_CTL_1 */
+#define IN_D_RANGE_MASK				(0x1 << 7)
+#define IN_D_RANGE_SHIFT			(7)
+#define IN_D_RANGE_CEA				(0x1 << 7)
+#define IN_D_RANGE_VESA				(0x0 << 7)
+#define IN_BPC_MASK				(0x7 << 4)
+#define IN_BPC_SHIFT				(4)
+#define IN_BPC_12_BITS				(0x3 << 4)
+#define IN_BPC_10_BITS				(0x2 << 4)
+#define IN_BPC_8_BITS				(0x1 << 4)
+#define IN_BPC_6_BITS				(0x0 << 4)
+#define IN_COLOR_F_MASK				(0x3 << 0)
+#define IN_COLOR_F_SHIFT			(0)
+#define IN_COLOR_F_YCBCR444			(0x2 << 0)
+#define IN_COLOR_F_YCBCR422			(0x1 << 0)
+#define IN_COLOR_F_RGB				(0x0 << 0)
+
+/* ROCKCHIP_EDP_VIDEO_CTL_3 */
+#define IN_YC_COEFFI_MASK			(0x1 << 7)
+#define IN_YC_COEFFI_SHIFT			(7)
+#define IN_YC_COEFFI_ITU709			(0x1 << 7)
+#define IN_YC_COEFFI_ITU601			(0x0 << 7)
+#define VID_CHK_UPDATE_TYPE_MASK		(0x1 << 4)
+#define VID_CHK_UPDATE_TYPE_SHIFT		(4)
+#define VID_CHK_UPDATE_TYPE_1			(0x1 << 4)
+#define VID_CHK_UPDATE_TYPE_0			(0x0 << 4)
+
+/* ROCKCHIP_EDP_VIDEO_CTL_4 */
+#define BIST_EN					(0x1 << 3)
+#define BIST_WH_64				(0x1 << 2)
+#define BIST_WH_32				(0x0 << 2)
+#define BIST_TYPE_COLR_BAR			(0x0 << 0)
+#define BIST_TYPE_GRAY_BAR			(0x1 << 0)
+#define BIST_TYPE_MOBILE_BAR			(0x2 << 0)
+
+/* ROCKCHIP_EDP_VIDEO_CTL_8 */
+#define VID_HRES_TH(x)				(((x) & 0xf) << 4)
+#define VID_VRES_TH(x)				(((x) & 0xf) << 0)
+
+/* ROCKCHIP_EDP_VIDEO_CTL_10 */
+#define F_SEL					(0x1 << 4)
+#define INTERACE_SCAN_CFG			(0x1 << 2)
+#define VSYNC_POLARITY_CFG			(0x1 << 1)
+#define HSYNC_POLARITY_CFG			(0x1 << 0)
+
+/* ROCKCHIP_EDP_PLL_REG_1 */
+#define REF_CLK_24M				(0x1 << 1)
+#define REF_CLK_27M				(0x0 << 1)
+
+/* ROCKCHIP_EDP_DP_PWRDN */
+#define PD_INC_BG				BIT(7)
+#define PD_EXP_BG				BIT(6)
+#define PD_AUX					BIT(5)
+#define PD_PLL					BIT(4)
+#define PD_CH3					BIT(3)
+#define PD_CH2					BIT(2)
+#define PD_CH1					BIT(1)
+#define PD_CH0					BIT(0)
+
+/* ROCKCHIP_EDP_LANE_MAP */
+#define LANE3_MAP_LOGIC_LANE_0			(0x0 << 6)
+#define LANE3_MAP_LOGIC_LANE_1			(0x1 << 6)
+#define LANE3_MAP_LOGIC_LANE_2			(0x2 << 6)
+#define LANE3_MAP_LOGIC_LANE_3			(0x3 << 6)
+#define LANE2_MAP_LOGIC_LANE_0			(0x0 << 4)
+#define LANE2_MAP_LOGIC_LANE_1			(0x1 << 4)
+#define LANE2_MAP_LOGIC_LANE_2			(0x2 << 4)
+#define LANE2_MAP_LOGIC_LANE_3			(0x3 << 4)
+#define LANE1_MAP_LOGIC_LANE_0			(0x0 << 2)
+#define LANE1_MAP_LOGIC_LANE_1			(0x1 << 2)
+#define LANE1_MAP_LOGIC_LANE_2			(0x2 << 2)
+#define LANE1_MAP_LOGIC_LANE_3			(0x3 << 2)
+#define LANE0_MAP_LOGIC_LANE_0			(0x0 << 0)
+#define LANE0_MAP_LOGIC_LANE_1			(0x1 << 0)
+#define LANE0_MAP_LOGIC_LANE_2			(0x2 << 0)
+#define LANE0_MAP_LOGIC_LANE_3			(0x3 << 0)
+
+/* ROCKCHIP_EDP_ANALOG_CTL_2 */
+#define SEL_24M					(0x1 << 3)
+
+/* ROCKCHIP_EDP_COMMON_INT_STA_1 */
+#define VSYNC_DET				BIT(7)
+#define PLL_LOCK_CHG				BIT(6)
+#define SPDIF_ERR				BIT(5)
+#define SPDIF_UNSTBL				BIT(4)
+#define VID_FORMAT_CHG				BIT(3)
+#define AUD_CLK_CHG				BIT(2)
+#define VID_CLK_CHG				BIT(1)
+#define SW_INT					BIT(0)
+
+/* ROCKCHIP_EDP_COMMON_INT_STA_2 */
+#define ENC_EN_CHG				BIT(6)
+#define HW_BKSV_RDY				BIT(3)
+#define HW_SHA_DONE				BIT(2)
+#define HW_AUTH_STATE_CHG			BIT(1)
+#define HW_AUTH_DONE				BIT(0)
+
+/* ROCKCHIP_EDP_COMMON_INT_STA_3 */
+#define AFIFO_UNDER				BIT(7)
+#define AFIFO_OVER				BIT(6)
+#define R0_CHK_FLAG				BIT(5)
+
+/* ROCKCHIP_EDP_COMMON_INT_STA_4 */
+#define PSR_ACTIVE				BIT(7)
+#define PSR_INACTIVE				BIT(6)
+#define SPDIF_BI_PHASE_ERR			BIT(5)
+#define HOTPLUG_CHG				BIT(2)
+#define HPD_LOST				BIT(1)
+#define PLUG					BIT(0)
+
+/* ROCKCHIP_EDP_INT_STA */
+#define INT_HPD					BIT(6)
+#define HW_LT_DONE				BIT(5)
+#define SINK_LOST				BIT(3)
+#define LINK_LOST				BIT(2)
+#define RPLY_RECEIV				BIT(1)
+#define AUX_ERR					BIT(0)
+
+/* ROCKCHIP_EDP_INT_CTL */
+#define INT_CTL					0x3FC
+#define SOFT_INT_CTRL				BIT(2)
+#define INT_POL					BIT(0)
+
+/* ROCKCHIP_EDP_SYS_CTL_1 */
+#define DET_STA					BIT(2)
+#define FORCE_DET				BIT(1)
+#define DET_CTRL				BIT(0)
+
+/* ROCKCHIP_EDP_SYS_CTL_2 */
+#define CHA_CRI(x)				(((x) & 0xf) << 4)
+#define CHA_STA					BIT(2)
+#define FORCE_CHA				BIT(1)
+#define CHA_CTRL				BIT(0)
+
+/* ROCKCHIP_EDP_SYS_CTL_3 */
+#define HPD_STATUS				BIT(6)
+#define F_HPD					BIT(5)
+#define HPD_CTRL				BIT(4)
+#define HDCP_RDY				BIT(3)
+#define STRM_VALID				BIT(2)
+#define F_VALID					BIT(1)
+#define VALID_CTRL				BIT(0)
+
+/* ROCKCHIP_EDP_SYS_CTL_4 */
+#define FIX_M_AUD				BIT(4)
+#define ENHANCED				BIT(3)
+#define FIX_M_VID				BIT(2)
+#define M_VID_UPDATE_CTRL			BIT(0)
+
+/* ROCKCHIP_EDP_TRAINING_PTN_SET */
+#define SCRAMBLING_DISABLE			(0x1 << 5)
+#define SCRAMBLING_ENABLE			(0x0 << 5)
+#define LINK_QUAL_PATTERN_SET_MASK		(0x7 << 2)
+#define LINK_QUAL_PATTERN_SET_PRBS7		(0x3 << 2)
+#define LINK_QUAL_PATTERN_SET_D10_2		(0x1 << 2)
+#define LINK_QUAL_PATTERN_SET_DISABLE		(0x0 << 2)
+#define SW_TRAINING_PATTERN_SET_MASK		(0x3 << 0)
+#define SW_TRAINING_PATTERN_SET_PTN2		(0x2 << 0)
+#define SW_TRAINING_PATTERN_SET_PTN1		(0x1 << 0)
+#define SW_TRAINING_PATTERN_SET_DISABLE		(0x0 << 0)
+
+/* ROCKCHIP_EDP_HW_LT_CTL */
+#define HW_LT_ERR_CODE_MASK			0x70
+#define HW_LT_EN				BIT(0)
+
+/* ROCKCHIP_EDP_LN0_LINK_TRAINING_CTL */
+#define PRE_EMPHASIS_SET_MASK			(0x3 << 3)
+#define PRE_EMPHASIS_SET_SHIFT			(3)
+
+/* ROCKCHIP_EDP_DEBUG_CTL */
+#define PLL_LOCK				BIT(4)
+#define F_PLL_LOCK				BIT(3)
+#define PLL_LOCK_CTRL				BIT(2)
+#define POLL_EN					BIT(1)
+#define PN_INV					BIT(0)
+
+/* ROCKCHIP_EDP_AUX_CH_STA */
+#define AUX_BUSY				(0x1 << 4)
+#define AUX_STATUS_MASK				(0xf << 0)
+
+/* ROCKCHIP_EDP_AUX_CH_DEFER_CTL */
+#define DEFER_CTRL_EN				(0x1 << 7)
+#define DEFER_COUNT(x)				(((x) & 0x7f) << 0)
+
+/* ROCKCHIP_EDP_AUX_RX_COMM */
+#define AUX_RX_COMM_I2C_DEFER			(0x2 << 2)
+#define AUX_RX_COMM_AUX_DEFER			(0x2 << 0)
+
+/* ROCKCHIP_EDP_BUFFER_DATA_CTL */
+#define BUF_CLR					(0x1 << 7)
+#define BUF_DATA_COUNT(x)			(((x) & 0xf) << 0)
+
+/* ROCKCHIP_EDP_AUX_CH_CTL_1 */
+#define AUX_LENGTH(x)				(((x - 1) & 0xf) << 4)
+#define AUX_TX_COMM_MASK			(0xf << 0)
+#define AUX_TX_COMM_DP_TRANSACTION		(0x1 << 3)
+#define AUX_TX_COMM_I2C_TRANSACTION		(0x0 << 3)
+#define AUX_TX_COMM_MOT				(0x1 << 2)
+#define AUX_TX_COMM_WRITE			(0x0 << 0)
+#define AUX_TX_COMM_READ			(0x1 << 0)
+
+/* OCKCHIP_EDP_AUX_ADDR_7_0 */
+#define AUX_ADDR_7_0(x)			(((x) >> 0) & 0xff)
+
+/* ROCKCHIP_EDP_AUX_ADDR_15_8 */
+#define AUX_ADDR_15_8(x)		(((x) >> 8) & 0xff)
+
+/* ROCKCHIP_EDP_AUX_ADDR_19_16 */
+#define AUX_ADDR_19_16(x)		(((x) >> 16) & 0x0f)
+
+/* ROCKCHIP_EDP_AUX_CH_CTL_2 */
+#define ADDR_ONLY				BIT(1)
+#define AUX_EN					BIT(0)
+
+#endif /* _ROCKCHIP_EDP_REG_H */
-- 
1.7.9.5
