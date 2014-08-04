From: mark yao <yzq-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
Subject: [PATCH 9/9] drm: add Rockchip Soc rk3288 edp connector
Date: Mon,  4 Aug 2014 12:57:25 +0800
Message-ID: <1407128245-1969-1-git-send-email-yzq@rock-chips.com>
References: <1407127274-1356-1-git-send-email-mark.yao@rock-chips.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1407127274-1356-1-git-send-email-mark.yao-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: heiko-4mtYJXux2i+zQB+pC5nmwQ@public.gmane.org, Rob Clark <robdclark-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, David Airlie <airlied-cv59FeDIM0c@public.gmane.org>, Grant Likely <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Rom Lemarchand <romlem-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, olof-nZhT3qVonbNeoWH0uzbU5w@public.gmane.org, djkurtz-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, xjq-TNX95d0MmH7DzftRWevZcw@public.gmane.org, kfx-TNX95d0MmH7DzftRWevZcw@public.gmane.org, cym-TNX95d0MmH7DzftRWevZcw@public.gmane.org, cf-TNX95d0MmH7DzftRWevZcw@public.gmane.org, zyw-TNX95d0MmH7DzftRWevZcw@public.gmane.org, zwl-TNX95d0MmH7DzftRWevZcw@public.gmane.org, xxm-TNX95d0MmH7DzftRWevZcw@public.gmane.org, huangtao-TNX95d0MmH7DzftRWevZcw@public.gmane.org, kever.yang-TNX95d0MmH7DzftRWevZcw@public.gmane.org, zhangqing-TNX95d0MmH7DzftRWevZcw@public.gmane.org, yxj-TNX95d0MmH7DzftRWevZcw@public.gmane.org, wxt-TNX95d0MmH7DzftRWevZcw@public.gmane.org, xw-TNX95d0MmH7DzftRWevZcw@public.gmane.org, mark yao <yzq-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Signed-off-by: mark yao <yzq-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
---
 drivers/gpu/drm/rockchip/connector/Kconfig         |    9 +
 drivers/gpu/drm/rockchip/connector/Makefile        |    1 +
 .../gpu/drm/rockchip/connector/rk3288_dp_core.c    |  586 ++++++++++
 .../gpu/drm/rockchip/connector/rk3288_dp_core.h    |  355 ++++++
 drivers/gpu/drm/rockchip/connector/rk3288_dp_reg.c | 1192 ++++++++++++++++++++
 drivers/gpu/drm/rockchip/connector/rk3288_dp_reg.h |  378 +++++++
 drivers/gpu/drm/rockchip/rockchip_drm_drv.c        |   13 +
 drivers/gpu/drm/rockchip/rockchip_drm_drv.h        |    3 +
 8 files changed, 2537 insertions(+)
 create mode 100644 drivers/gpu/drm/rockchip/connector/rk3288_dp_core.c
 create mode 100644 drivers/gpu/drm/rockchip/connector/rk3288_dp_core.h
 create mode 100644 drivers/gpu/drm/rockchip/connector/rk3288_dp_reg.c
 create mode 100644 drivers/gpu/drm/rockchip/connector/rk3288_dp_reg.h

diff --git a/drivers/gpu/drm/rockchip/connector/Kconfig b/drivers/gpu/drm/rockchip/connector/Kconfig
index 248942f..caffc5b 100644
--- a/drivers/gpu/drm/rockchip/connector/Kconfig
+++ b/drivers/gpu/drm/rockchip/connector/Kconfig
@@ -6,3 +6,12 @@ config RK3288_LVDS
 	  rk3288 lvds transmitter support ttl rgb, lvds and dual lvds
 	  mode, dual lvds mode is support for the plane which need dual
 	  lvds channels.
+
+config RK3288_DP
+	bool "RK3288 edp connector support"
+	depends on DRM_ROCKCHIP_CONNECTOR
+	help
+	  Choose this option if you have a rk32xx eDP connector.
+	  Rockchip rk3288 SoC has eDP TX Controller can be used.
+	  If you have an Embedded DisplayPort Panel, say Y to enable its
+	  driver.
diff --git a/drivers/gpu/drm/rockchip/connector/Makefile b/drivers/gpu/drm/rockchip/connector/Makefile
index dcfbdef..4be77ea 100644
--- a/drivers/gpu/drm/rockchip/connector/Makefile
+++ b/drivers/gpu/drm/rockchip/connector/Makefile
@@ -2,3 +2,4 @@
 # Makefile for display connector like lvds edp mipi
 #
 obj-$(CONFIG_RK3288_LVDS)	+= rk3288_lvds.o
+obj-$(CONFIG_RK3288_DP)		+= rk3288_dp_core.o rk3288_dp_reg.o
diff --git a/drivers/gpu/drm/rockchip/connector/rk3288_dp_core.c b/drivers/gpu/drm/rockchip/connector/rk3288_dp_core.c
new file mode 100644
index 0000000..3756383
--- /dev/null
+++ b/drivers/gpu/drm/rockchip/connector/rk3288_dp_core.c
@@ -0,0 +1,586 @@
+/*
+* Copyright (C) Fuzhou Rockchip Electronics Co.Ltd
+* Author:
+*      yxj <yxj-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
+*      cym <cym-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
+*
+* based on exynos_dp_core.c
+*
+* This program is free software; you can redistribute it and/or modify it
+* under the terms of the GNU General Public License as published by the
+* Free Software Foundation; either version 2 of the License, or (at your
+* option) any later version.
+*/
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/errno.h>
+#include <linux/string.h>
+#include <linux/slab.h>
+#include <linux/delay.h>
+#include <linux/interrupt.h>
+#include <linux/clk.h>
+#include <linux/platform_device.h>
+#include <linux/uaccess.h>
+#include <linux/mfd/syscon.h>
+#include <linux/regmap.h>
+#include <linux/reset.h>
+#include <linux/of.h>
+
+#include "rk3288_dp_core.h"
+
+static int rk3288_edp_clk_enable(struct rk3288_edp *edp)
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
+		ret = clk_set_parent(edp->clk_24m, edp->clk_24m_parent);
+		if (ret < 0) {
+			dev_err(edp->dev, "cannot set edp clk_24m parent %d\n",
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
+static int rk3288_edp_clk_disable(struct rk3288_edp *edp)
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
+static int rk3288_edp_pre_init(struct rk3288_edp *edp)
+{
+	u32 val;
+	int ret = 0;
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
+static int rk3288_edp_init_edp(struct rk3288_edp *edp)
+{
+	int lcdc_id = 1;
+	u32 val = 0;
+	int ret = 0;
+
+	/* select lcdc */
+	if (lcdc_id == 1)
+		val = EDP_SEL_VOP_LIT | (EDP_SEL_VOP_LIT << 16);
+	else
+		val = EDP_SEL_VOP_LIT << 16;
+	ret = regmap_write(edp->grf, edp->soc_data->grf_soc_con6, val);
+	if (ret != 0) {
+		dev_err(edp->dev, "Could not write to GRF: %d\n", ret);
+		return ret;
+	}
+
+	rk3288_edp_reset(edp);
+	rk3288_edp_init_refclk(edp);
+	rk3288_edp_init_interrupt(edp);
+	rk3288_edp_enable_sw_function(edp);
+	rk3288_edp_init_analog_func(edp);
+	rk3288_edp_init_hpd(edp);
+	rk3288_edp_init_aux(edp);
+
+	return 0;
+}
+
+static int rk3288_edp_get_max_rx_bandwidth(
+					struct rk3288_edp *edp,
+					u8 *bandwidth)
+{
+	u8 data;
+	int retval = 0;
+
+	/*
+	 * For DP rev.1.1, Maximum link rate of Main Link lanes
+	 * 0x06 = 1.62 Gbps, 0x0a = 2.7 Gbps
+	 */
+	retval = rk3288_edp_read_byte_from_dpcd(
+			edp, DPCD_ADDR_MAX_LINK_RATE, &data);
+	if (retval < 0)
+		*bandwidth = 0;
+	else
+		*bandwidth = data;
+
+	return retval;
+}
+
+static int rk3288_edp_get_max_rx_lane_count(struct rk3288_edp *edp,
+					    u8 *lane_count)
+{
+	u8 data;
+	int retval;
+
+	/*
+	 * For DP rev.1.1, Maximum number of Main Link lanes
+	 * 0x01 = 1 lane, 0x02 = 2 lanes, 0x04 = 4 lanes
+	 */
+	retval = rk3288_edp_read_byte_from_dpcd(
+			edp, DPCD_ADDR_MAX_LANE_COUNT, &data);
+	if (retval < 0)
+		*lane_count = 0;
+	else
+		*lane_count = DPCD_MAX_LANE_COUNT(data);
+
+	return retval;
+}
+
+static int rk3288_edp_init_training(struct rk3288_edp *edp)
+{
+	int retval;
+
+	/*
+	 * MACRO_RST must be applied after the PLL_LOCK to avoid
+	 * the DP inter pair skew issue for at least 10 us
+	 */
+	rk3288_edp_reset_macro(edp);
+
+	retval = rk3288_edp_get_max_rx_bandwidth(
+				edp, &edp->link_train.link_rate);
+	retval = rk3288_edp_get_max_rx_lane_count(
+				edp, &edp->link_train.lane_count);
+	dev_dbg(edp->dev, "max link rate:%d.%dGps max number of lanes:%d\n",
+		edp->link_train.link_rate * 27/100,
+		edp->link_train.link_rate*27%100,
+		edp->link_train.lane_count);
+
+	if ((edp->link_train.link_rate != LINK_RATE_1_62GBPS) &&
+	    (edp->link_train.link_rate != LINK_RATE_2_70GBPS)) {
+		dev_warn(edp->dev, "Rx Max Link Rate is abnormal :%x !\n"
+			 "use default link rate:%d.%dGps\n",
+			 edp->link_train.link_rate,
+			 edp->video_info.link_rate*27/100,
+			 edp->video_info.link_rate*27%100);
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
+	rk3288_edp_analog_power_ctr(edp, 1);
+
+	return 0;
+}
+
+static int rk3288_edp_hw_link_training(struct rk3288_edp *edp)
+{
+	u32 cnt = 50;
+	u32 val;
+
+	/* Set link rate and count as you want to establish*/
+	rk3288_edp_set_link_bandwidth(edp, edp->link_train.link_rate);
+	rk3288_edp_set_lane_count(edp, edp->link_train.lane_count);
+	rk3288_edp_hw_link_training_en(edp);
+	val = rk3288_edp_wait_hw_lt_done(edp);
+	while (val) {
+		if (cnt-- <= 0) {
+			dev_err(edp->dev, "hw lt timeout");
+			return -ETIMEDOUT;
+		}
+		mdelay(1);
+		val = rk3288_edp_wait_hw_lt_done(edp);
+	}
+
+	val = rk3288_edp_get_hw_lt_status(edp);
+	if (val)
+		dev_err(edp->dev, "hw lt err:%d\n", val);
+
+	return val;
+}
+
+static int rk3288_edp_set_link_train(struct rk3288_edp *edp)
+{
+	int retval;
+
+	rk3288_edp_init_training(edp);
+
+	retval = rk3288_edp_hw_link_training(edp);
+	if (retval < 0)
+		dev_err(edp->dev, "DP hw LT failed!\n");
+
+	return retval;
+}
+
+static int rk3288_edp_config_video(struct rk3288_edp *edp,
+				   struct video_info *video_info)
+{
+	int retval = 0;
+	int timeout_loop = 0;
+	int done_count = 0;
+
+	rk3288_edp_config_video_slave_mode(edp, video_info);
+
+	rk3288_edp_set_video_color_format(edp, video_info->color_depth,
+					  video_info->color_space,
+					  video_info->dynamic_range,
+					  video_info->ycbcr_coeff);
+
+	if (rk3288_edp_get_pll_lock_status(edp) == DP_PLL_UNLOCKED) {
+		dev_err(edp->dev, "PLL is not locked yet.\n");
+		return -EINVAL;
+	}
+
+	for (;;) {
+		timeout_loop++;
+		if (rk3288_edp_is_slave_video_stream_clock_on(edp) == 0)
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
+	rk3288_edp_set_video_cr_mn(edp, CALCULATED_M, 0, 0);
+
+	/* Disable video mute */
+	rk3288_edp_enable_video_mute(edp, 0);
+
+	/* Configure video slave mode */
+	rk3288_edp_enable_video_master(edp, 0);
+
+	/* Enable video */
+	rk3288_edp_start_video(edp);
+
+	timeout_loop = 0;
+
+	for (;;) {
+		timeout_loop++;
+		if (rk3288_edp_is_video_stream_on(edp) == 0) {
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
+static irqreturn_t rk3288_edp_isr(int irq, void *arg)
+{
+	struct rk3288_edp *edp = arg;
+	enum dp_irq_type irq_type;
+
+	irq_type = rk3288_edp_get_irq_type(edp);
+	switch (irq_type) {
+	case DP_IRQ_TYPE_HP_CABLE_IN:
+		dev_dbg(edp->dev, "Received irq - cable in\n");
+		rk3288_edp_clear_hotplug_interrupts(edp);
+		break;
+	case DP_IRQ_TYPE_HP_CABLE_OUT:
+		dev_dbg(edp->dev, "Received irq - cable out\n");
+		rk3288_edp_clear_hotplug_interrupts(edp);
+		break;
+	case DP_IRQ_TYPE_HP_CHANGE:
+		/*
+		 * We get these change notifications once in a while, but there
+		 * is nothing we can do with them. Just ignore it for now and
+		 * only handle cable changes.
+		 */
+		dev_dbg(edp->dev, "Received irq - hotplug change; ignoring.\n");
+		rk3288_edp_clear_hotplug_interrupts(edp);
+		break;
+	default:
+		dev_err(edp->dev, "Received irq - unknown type[%x]!\n",
+			irq_type);
+		rk3288_edp_clear_hotplug_interrupts(edp);
+		break;
+	}
+
+	return IRQ_HANDLED;
+}
+
+static void rk3288_edp_enable(struct rockchip_connector *conn)
+{
+	struct rk3288_edp *edp = conn->priv;
+	int ret = 0;
+
+	ret = rk3288_edp_clk_enable(edp);
+	if (ret < 0) {
+		dev_err(edp->dev, "cannot enable edp clk %d\n", ret);
+		return;
+	}
+
+	ret = rk3288_edp_pre_init(edp);
+	if (ret < 0) {
+		dev_err(edp->dev, "edp pre init fail %d\n", ret);
+		return;
+	}
+
+	ret = rk3288_edp_init_edp(edp);
+	if (ret < 0) {
+		dev_err(edp->dev, "edp init fail %d\n", ret);
+		return;
+	}
+
+	enable_irq(edp->irq);
+
+	ret = rk3288_edp_set_link_train(edp);
+	if (ret)
+		dev_err(edp->dev, "link train failed!\n");
+	else
+		dev_dbg(edp->dev, "link training success.\n");
+
+	rk3288_edp_set_lane_count(edp, edp->link_train.lane_count);
+	rk3288_edp_set_link_bandwidth(edp, edp->link_train.link_rate);
+	rk3288_edp_init_video(edp);
+
+	ret = rk3288_edp_config_video(edp, &edp->video_info);
+	if (ret)
+		dev_err(edp->dev, "unable to config video\n");
+}
+
+static void  rk3288_edp_disable(struct rockchip_connector *conn)
+{
+	struct rk3288_edp *edp = conn->priv;
+
+	disable_irq(edp->irq);
+	rk3288_edp_reset(edp);
+	rk3288_edp_analog_power_ctr(edp, 0);
+	rk3288_edp_clk_disable(edp);
+}
+
+static int rk3288_edp_setmode(struct rockchip_connector *conn,
+			      struct drm_display_mode *mode)
+{
+	struct rk3288_edp *edp = conn->priv;
+
+	memcpy(&edp->mode, mode, sizeof(*mode));
+
+	return 0;
+}
+
+static struct rockchip_connector edp_conn = {
+	.enable = rk3288_edp_enable,
+	.disable = rk3288_edp_disable,
+	.setmode = rk3288_edp_setmode,
+};
+
+static struct rk3288_edp_soc_data soc_data[2] = {
+	{.grf_soc_con6 = 0x025c,
+	 .grf_soc_con12 = 0x0274},
+	{.grf_soc_con6 = -1,
+	 .grf_soc_con12 = -1},
+};
+
+static const struct of_device_id rk3288_edp_dt_ids[] = {
+	{.compatible = "rockchip,rk3288-edp",
+	 .data = (void *)&soc_data[0]},
+	{}
+};
+MODULE_DEVICE_TABLE(of, rk3288_edp_dt_ids);
+
+static int rk3288_edp_probe(struct platform_device *pdev)
+{
+	struct rk3288_edp *edp;
+	struct resource *res;
+	struct device_node *np = pdev->dev.of_node;
+	const struct of_device_id *match;
+	int ret = 0;
+
+	if (!np) {
+		dev_err(&pdev->dev, "Missing device tree node.\n");
+		return -EINVAL;
+	}
+
+	edp = devm_kzalloc(&pdev->dev, sizeof(struct rk3288_edp), GFP_KERNEL);
+	if (!edp) {
+		dev_err(&pdev->dev, "no memory for state\n");
+		return -ENOMEM;
+	}
+
+	match = of_match_node(rk3288_edp_dt_ids, np);
+	edp->soc_data = (struct rk3288_edp_soc_data *)match->data;
+	/*
+	 * The control bit is located in the GRF register space.
+	 */
+	if (edp->soc_data->grf_soc_con6 >= 0) {
+		edp->grf = syscon_regmap_lookup_by_phandle(np, "rockchip,grf");
+		if (IS_ERR(edp->grf)) {
+			dev_err(&pdev->dev,
+				"rk3288-edp needs rockchip,grf property\n");
+			return PTR_ERR(edp->grf);
+		}
+	}
+
+	edp->dev = &pdev->dev;
+	edp->video_info.h_sync_polarity	= 0;
+	edp->video_info.v_sync_polarity	= 0;
+	edp->video_info.interlaced	= 0;
+	edp->video_info.color_space	= CS_RGB;
+	edp->video_info.dynamic_range	= VESA;
+	edp->video_info.ycbcr_coeff	= COLOR_YCBCR601;
+	edp->video_info.color_depth	= COLOR_8;
+
+	edp->video_info.link_rate	= LINK_RATE_1_62GBPS;
+	edp->video_info.lane_count	= LANE_CNT4;
+	edp_conn.type = ROCKCHIP_DISPLAY_TYPE_EDP;
+	edp_conn.priv = edp;
+	edp_conn.dev = &pdev->dev;
+
+	edp->base = rockchip_connector_register(&edp_conn);
+	if (!edp->base) {
+		dev_err(&pdev->dev, "connector register fail\n");
+		return -EINVAL;
+	}
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	edp->regs = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(edp->regs)) {
+		dev_err(&pdev->dev, "ioremap reg failed\n");
+		return PTR_ERR(edp->regs);
+	}
+
+	edp->clk_edp = devm_clk_get(&pdev->dev, "clk_edp");
+	if (IS_ERR(edp->clk_edp)) {
+		dev_err(&pdev->dev, "cannot get clk_edp\n");
+		return PTR_ERR(edp->clk_edp);
+	}
+
+	edp->clk_24m_parent = devm_clk_get(&pdev->dev, "clk_edp_24m_parent");
+	if (IS_ERR(edp->clk_24m_parent)) {
+		dev_err(&pdev->dev, "cannot get clk_edp_24m_parent\n");
+		return PTR_ERR(edp->clk_24m_parent);
+	}
+
+	edp->clk_24m = devm_clk_get(&pdev->dev, "clk_edp_24m");
+	if (IS_ERR(edp->clk_24m)) {
+		dev_err(&pdev->dev, "cannot get clk_edp_24m\n");
+		return PTR_ERR(edp->clk_24m);
+	}
+
+	edp->pclk = devm_clk_get(&pdev->dev, "pclk_edp");
+	if (IS_ERR(edp->pclk)) {
+		dev_err(&pdev->dev, "cannot get pclk\n");
+		return PTR_ERR(edp->pclk);
+	}
+
+	edp->rst = devm_reset_control_get(&pdev->dev, "edp");
+	if (IS_ERR(edp->rst)) {
+		dev_err(&pdev->dev, "failed to get reset\n");
+		return PTR_ERR(edp->rst);
+	}
+
+	ret = rk3288_edp_clk_enable(edp);
+	if (ret < 0) {
+		dev_err(edp->dev, "cannot enable edp clk %d\n", ret);
+		return ret;
+	}
+
+	ret = rk3288_edp_pre_init(edp);
+	if (ret < 0) {
+		dev_err(edp->dev, "failed to pre init %d\n", ret);
+		return ret;
+	}
+
+	edp->irq = platform_get_irq(pdev, 0);
+	if (edp->irq < 0) {
+		dev_err(&pdev->dev, "cannot find IRQ\n");
+		return edp->irq;
+	}
+
+	ret = devm_request_irq(&pdev->dev, edp->irq, rk3288_edp_isr, 0,
+			       dev_name(&pdev->dev), edp);
+	if (ret) {
+		dev_err(&pdev->dev, "cannot claim IRQ %d\n", edp->irq);
+		return ret;
+	}
+
+	disable_irq_nosync(edp->irq);
+
+	edp->standby = true;
+
+	platform_set_drvdata(pdev, edp);
+	dev_set_name(edp->dev, "rk3288-edp");
+
+	dev_info(&pdev->dev, "rk3288 edp driver probe success\n");
+
+	return 0;
+}
+
+static int rk3288_edp_remove(struct platform_device *pdev)
+{
+	rk3288_edp_disable(&edp_conn);
+
+	return 0;
+}
+
+struct platform_driver rk3288_edp_driver = {
+	.probe = rk3288_edp_probe,
+	.remove = rk3288_edp_remove,
+	.driver = {
+		   .name = "rk3288-edp",
+		   .owner = THIS_MODULE,
+		   .of_match_table = of_match_ptr(rk3288_edp_dt_ids),
+	},
+};
diff --git a/drivers/gpu/drm/rockchip/connector/rk3288_dp_core.h b/drivers/gpu/drm/rockchip/connector/rk3288_dp_core.h
new file mode 100644
index 0000000..d71df70
--- /dev/null
+++ b/drivers/gpu/drm/rockchip/connector/rk3288_dp_core.h
@@ -0,0 +1,355 @@
+/*
+* Copyright (C) Fuzhou Rockchip Electronics Co.Ltd
+* Author:
+*      yxj <yxj-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
+*      cym <cym-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
+*
+* based on exynos_dp_core.h
+*
+* This program is free software; you can redistribute it and/or modify it
+* under the terms of the GNU General Public License as published by the
+* Free Software Foundation; either version 2 of the License, or (at your
+* option) any later version.
+*/
+
+#ifndef __RK3288_DP_H
+#define __RK3288_DP_H
+#include "../rockchip_drm_connector.h"
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
+enum dp_irq_type {
+	DP_IRQ_TYPE_HP_CABLE_IN,
+	DP_IRQ_TYPE_HP_CABLE_OUT,
+	DP_IRQ_TYPE_HP_CHANGE,
+	DP_IRQ_TYPE_UNKNOWN,
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
+enum link_rate_type {
+	LINK_RATE_1_62GBPS = 0x06,
+	LINK_RATE_2_70GBPS = 0x0a
+};
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
+	enum link_rate_type link_rate;
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
+struct rk3288_edp_soc_data {
+	int grf_soc_con6;
+	int grf_soc_con12;
+};
+
+struct rk3288_edp {
+	void *base;
+	struct drm_display_mode mode;
+	struct device *dev;
+	void __iomem *regs;
+	struct regmap *grf;
+	struct rk3288_edp_soc_data *soc_data;
+	unsigned int irq;
+	/* clk for edp controller */
+	struct clk *clk_edp;
+	/* clk for edp phy parent */
+	struct clk *clk_24m_parent;
+	/* clk for edp phy */
+	struct clk *clk_24m;
+	/* clk for phb bus */
+	struct clk *pclk;
+	struct reset_control *rst;
+	struct link_train link_train;
+	struct video_info video_info;
+	bool clk_on;
+	bool standby;
+};
+
+void rk3288_edp_enable_video_mute(struct rk3288_edp *edp, bool enable);
+void rk3288_edp_stop_video(struct rk3288_edp *edp);
+void rk3288_edp_lane_swap(struct rk3288_edp *edp, bool enable);
+void rk3288_edp_init_refclk(struct rk3288_edp *edp);
+void rk3288_edp_init_interrupt(struct rk3288_edp *edp);
+void rk3288_edp_reset(struct rk3288_edp *edp);
+void rk3288_edp_config_interrupt(struct rk3288_edp *edp);
+u32 rk3288_edp_get_pll_lock_status(struct rk3288_edp *edp);
+void rk3288_edp_analog_power_ctr(struct rk3288_edp *edp, bool enable);
+void rk3288_edp_init_analog_func(struct rk3288_edp *edp);
+void rk3288_edp_init_hpd(struct rk3288_edp *edp);
+void rk3288_edp_reset_aux(struct rk3288_edp *edp);
+void rk3288_edp_init_aux(struct rk3288_edp *edp);
+int rk3288_edp_get_plug_in_status(struct rk3288_edp *edp);
+void rk3288_edp_enable_sw_function(struct rk3288_edp *edp);
+int rk3288_edp_start_aux_transaction(struct rk3288_edp *edp);
+int rk3288_edp_write_byte_to_dpcd(struct rk3288_edp *edp,
+				  unsigned int reg_addr,
+				  unsigned char data);
+int rk3288_edp_read_byte_from_dpcd(struct rk3288_edp *edp,
+				   unsigned int reg_addr,
+				   unsigned char *data);
+int rk3288_edp_write_bytes_to_dpcd(struct rk3288_edp *edp,
+				   unsigned int reg_addr,
+				   unsigned int count,
+				   unsigned char data[]);
+int rk3288_edp_read_bytes_from_dpcd(struct rk3288_edp *edp,
+				    unsigned int reg_addr,
+				    unsigned int count,
+				    unsigned char data[]);
+int rk3288_edp_select_i2c_device(struct rk3288_edp *edp,
+				 unsigned int device_addr,
+				 unsigned int reg_addr);
+int rk3288_edp_read_byte_from_i2c(struct rk3288_edp *edp,
+				  unsigned int device_addr,
+				  unsigned int reg_addr,
+				  unsigned int *data);
+int rk3288_edp_read_bytes_from_i2c(struct rk3288_edp *edp,
+				   unsigned int device_addr,
+				   unsigned int reg_addr,
+				   unsigned int count,
+				   unsigned char edid[]);
+void rk3288_edp_set_link_bandwidth(struct rk3288_edp *edp, u32 bwtype);
+void rk3288_edp_get_link_bandwidth(struct rk3288_edp *edp, u32 *bwtype);
+void rk3288_edp_set_lane_count(struct rk3288_edp *edp, u32 count);
+void rk3288_edp_get_lane_count(struct rk3288_edp *edp, u32 *count);
+void rk3288_edp_enable_enhanced_mode(struct rk3288_edp *edp, bool enable);
+void rk3288_edp_set_training_pattern(struct rk3288_edp *edp,
+				     enum pattern_set pattern);
+void rk3288_edp_set_lane0_pre_emphasis(struct rk3288_edp *edp, u32 level);
+void rk3288_edp_set_lane1_pre_emphasis(struct rk3288_edp *edp, u32 level);
+void rk3288_edp_set_lane2_pre_emphasis(struct rk3288_edp *edp, u32 level);
+void rk3288_edp_set_lane3_pre_emphasis(struct rk3288_edp *edp, u32 level);
+void rk3288_edp_set_lane0_link_training(struct rk3288_edp *edp,
+					u32 training_lane);
+void rk3288_edp_set_lane1_link_training(struct rk3288_edp *edp,
+					u32 training_lane);
+void rk3288_edp_set_lane2_link_training(struct rk3288_edp *edp,
+					u32 training_lane);
+void rk3288_edp_set_lane3_link_training(struct rk3288_edp *edp,
+					u32 training_lane);
+u32 rk3288_edp_get_lane0_link_training(struct rk3288_edp *edp);
+u32 rk3288_edp_get_lane1_link_training(struct rk3288_edp *edp);
+u32 rk3288_edp_get_lane2_link_training(struct rk3288_edp *edp);
+u32 rk3288_edp_get_lane3_link_training(struct rk3288_edp *edp);
+void rk3288_edp_reset_macro(struct rk3288_edp *edp);
+int rk3288_edp_init_video(struct rk3288_edp *edp);
+
+void rk3288_edp_set_video_color_format(struct rk3288_edp *edp,
+				       u32 color_depth,
+				       u32 color_space,
+				       u32 dynamic_range,
+				       u32 coeff);
+int rk3288_edp_is_slave_video_stream_clock_on(struct rk3288_edp *edp);
+void rk3288_edp_set_video_cr_mn(
+			struct rk3288_edp *edp,
+			enum clock_recovery_m_value_type type,
+			u32 m_value,
+			u32 n_value);
+void rk3288_edp_set_video_timing_mode(struct rk3288_edp *edp, u32 type);
+void rk3288_edp_enable_video_master(struct rk3288_edp *edp, bool enable);
+void rk3288_edp_start_video(struct rk3288_edp *edp);
+int rk3288_edp_is_video_stream_on(struct rk3288_edp *edp);
+void rk3288_edp_config_video_slave_mode(struct rk3288_edp *edp,
+					struct video_info *video_info);
+void rk3288_edp_enable_scrambling(struct rk3288_edp *edp);
+void rk3288_edp_disable_scrambling(struct rk3288_edp *edp);
+void rk3288_edp_rx_control(struct rk3288_edp *edp, bool enable);
+int rk3288_edp_bist_cfg(struct rk3288_edp *edp);
+void rk3288_edp_hw_link_training_en(struct rk3288_edp *edp);
+int rk3288_edp_get_hw_lt_status(struct rk3288_edp *edp);
+int rk3288_edp_wait_hw_lt_done(struct rk3288_edp *edp);
+enum dp_irq_type rk3288_edp_get_irq_type(struct rk3288_edp *edp);
+void rk3288_edp_clear_hotplug_interrupts(struct rk3288_edp *edp);
+
+/* I2C EDID Chip ID, Slave Address */
+#define I2C_EDID_DEVICE_ADDR			0x50
+#define I2C_E_EDID_DEVICE_ADDR			0x30
+
+#define EDID_BLOCK_LENGTH			0x80
+#define EDID_HEADER_PATTERN			0x00
+#define EDID_EXTENSION_FLAG			0x7e
+#define EDID_CHECKSUM				0x7f
+
+/* Definition for DPCD Register */
+#define DPCD_ADDR_DPCD_REV			0x0000
+#define DPCD_ADDR_MAX_LINK_RATE			0x0001
+#define DPCD_ADDR_MAX_LANE_COUNT		0x0002
+#define DPCD_ADDR_LINK_BW_SET			0x0100
+#define DPCD_ADDR_LANE_COUNT_SET		0x0101
+#define DPCD_ADDR_TRAINING_PATTERN_SET		0x0102
+#define DPCD_ADDR_TRAINING_LANE0_SET		0x0103
+#define DPCD_ADDR_LANE0_1_STATUS		0x0202
+#define DPCD_ADDR_LANE_ALIGN_STATUS_UPDATED	0x0204
+#define DPCD_ADDR_ADJUST_REQUEST_LANE0_1	0x0206
+#define DPCD_ADDR_ADJUST_REQUEST_LANE2_3	0x0207
+#define DPCD_ADDR_TEST_REQUEST			0x0218
+#define DPCD_ADDR_TEST_RESPONSE			0x0260
+#define DPCD_ADDR_TEST_EDID_CHECKSUM		0x0261
+#define DPCD_ADDR_SINK_POWER_STATE		0x0600
+
+/* DPCD_ADDR_MAX_LANE_COUNT */
+#define DPCD_ENHANCED_FRAME_CAP(x)		(((x) >> 7) & 0x1)
+#define DPCD_MAX_LANE_COUNT(x)			((x) & 0x1f)
+
+/* DPCD_ADDR_LANE_COUNT_SET */
+#define DPCD_ENHANCED_FRAME_EN			(0x1 << 7)
+#define DPCD_LANE_COUNT_SET(x)			((x) & 0x1f)
+
+/* DPCD_ADDR_TRAINING_PATTERN_SET */
+#define DPCD_SCRAMBLING_DISABLED		(0x1 << 5)
+#define DPCD_SCRAMBLING_ENABLED			(0x0 << 5)
+#define DPCD_TRAINING_PATTERN_2			(0x2 << 0)
+#define DPCD_TRAINING_PATTERN_1			(0x1 << 0)
+#define DPCD_TRAINING_PATTERN_DISABLED		(0x0 << 0)
+
+/* DPCD_ADDR_TRAINING_LANE0_SET */
+#define DPCD_MAX_PRE_EMPHASIS_REACHED		(0x1 << 5)
+#define DPCD_PRE_EMPHASIS_SET(x)		(((x) & 0x3) << 3)
+#define DPCD_PRE_EMPHASIS_GET(x)		(((x) >> 3) & 0x3)
+#define DPCD_PRE_EMPHASIS_PATTERN2_LEVEL0	(0x0 << 3)
+#define DPCD_MAX_SWING_REACHED			(0x1 << 2)
+#define DPCD_VOLTAGE_SWING_SET(x)		(((x) & 0x3) << 0)
+#define DPCD_VOLTAGE_SWING_GET(x)		(((x) >> 0) & 0x3)
+#define DPCD_VOLTAGE_SWING_PATTERN1_LEVEL0	(0x0 << 0)
+
+/* DPCD_ADDR_LANE0_1_STATUS */
+#define DPCD_LANE_SYMBOL_LOCKED			(0x1 << 2)
+#define DPCD_LANE_CHANNEL_EQ_DONE		(0x1 << 1)
+#define DPCD_LANE_CR_DONE			(0x1 << 0)
+#define DPCD_CHANNEL_EQ_BITS			(DPCD_LANE_CR_DONE|	\
+						 DPCD_LANE_CHANNEL_EQ_DONE|\
+						 DPCD_LANE_SYMBOL_LOCKED)
+
+/* DPCD_ADDR_LANE_ALIGN__STATUS_UPDATED */
+#define DPCD_LINK_STATUS_UPDATED		(0x1 << 7)
+#define DPCD_DOWNSTREAM_PORT_STATUS_CHANGED	(0x1 << 6)
+#define DPCD_INTERLANE_ALIGN_DONE		(0x1 << 0)
+
+/* DPCD_ADDR_TEST_REQUEST */
+#define DPCD_TEST_EDID_READ			(0x1 << 2)
+
+/* DPCD_ADDR_TEST_RESPONSE */
+#define DPCD_TEST_EDID_CHECKSUM_WRITE		(0x1 << 2)
+
+/* DPCD_ADDR_SINK_POWER_STATE */
+#define DPCD_SET_POWER_STATE_D0			(0x1 << 0)
+#define DPCD_SET_POWER_STATE_D4			(0x2 << 0)
+
+#define DPCD_SYMBOL_ERR_CONUT_LANE0		0x210
+
+#endif
diff --git a/drivers/gpu/drm/rockchip/connector/rk3288_dp_reg.c b/drivers/gpu/drm/rockchip/connector/rk3288_dp_reg.c
new file mode 100644
index 0000000..f558cea
--- /dev/null
+++ b/drivers/gpu/drm/rockchip/connector/rk3288_dp_reg.c
@@ -0,0 +1,1192 @@
+/*
+* Copyright (C) Fuzhou Rockchip Electronics Co.Ltd
+* Author:
+*      yxj <yxj-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
+*      cym <cym-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
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
+#include "rk3288_dp_core.h"
+#include "rk3288_dp_reg.h"
+
+void rk3288_edp_enable_video_mute(struct rk3288_edp *edp, bool enable)
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
+void rk3288_edp_stop_video(struct rk3288_edp *edp)
+{
+	u32 val;
+
+	val = readl(edp->regs + VIDEO_CTL_1);
+	val &= ~VIDEO_EN;
+	writel(val, edp->regs + VIDEO_CTL_1);
+}
+
+void rk3288_edp_lane_swap(struct rk3288_edp *edp, bool enable)
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
+void rk3288_edp_init_refclk(struct rk3288_edp *edp)
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
+void rk3288_edp_init_interrupt(struct rk3288_edp *edp)
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
+void rk3288_edp_reset(struct rk3288_edp *edp)
+{
+	u32 val;
+
+	rk3288_edp_stop_video(edp);
+	rk3288_edp_enable_video_mute(edp, 0);
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
+	rk3288_edp_lane_swap(edp, 0);
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
+void rk3288_edp_config_interrupt(struct rk3288_edp *edp)
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
+u32 rk3288_edp_get_pll_lock_status(struct rk3288_edp *edp)
+{
+	u32 val;
+
+	val = readl(edp->regs + DEBUG_CTL);
+	if (val & PLL_LOCK)
+		return DP_PLL_LOCKED;
+	else
+		return DP_PLL_UNLOCKED;
+}
+
+void rk3288_edp_analog_power_ctr(struct rk3288_edp *edp, bool enable)
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
+void rk3288_edp_init_analog_func(struct rk3288_edp *edp)
+{
+	u32 val;
+	int wt = 0;
+
+	rk3288_edp_analog_power_ctr(edp, 1);
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
+		if (rk3288_edp_get_pll_lock_status(edp) == DP_PLL_LOCKED) {
+			dev_dbg(edp->dev, "edp pll locked\n");
+			break;
+		} else {
+			wt++;
+			udelay(5);
+		}
+	}
+
+	/* Enable Serdes FIFO function and Link symbol clock domain module */
+	val = readl(edp->regs + FUNC_EN_2);
+	val &= ~(SERDES_FIFO_FUNC_EN_N | LS_CLK_DOMAIN_FUNC_EN_N
+		| AUX_FUNC_EN_N | SSC_FUNC_EN_N);
+	writel(val, edp->regs + FUNC_EN_2);
+}
+
+void rk3288_edp_init_hpd(struct rk3288_edp *edp)
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
+void rk3288_edp_reset_aux(struct rk3288_edp *edp)
+{
+	u32 val;
+
+	/* Disable AUX channel module */
+	val = readl(edp->regs + FUNC_EN_2);
+	val |= AUX_FUNC_EN_N;
+	writel(val, edp->regs + FUNC_EN_2);
+}
+
+void rk3288_edp_init_aux(struct rk3288_edp *edp)
+{
+	u32 val;
+
+	/* Clear inerrupts related to AUX channel */
+	val = RPLY_RECEIV | AUX_ERR;
+	writel(val, edp->regs + DP_INT_STA);
+
+	rk3288_edp_reset_aux(edp);
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
+int rk3288_edp_get_plug_in_status(struct rk3288_edp *edp)
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
+void rk3288_edp_enable_sw_function(struct rk3288_edp *edp)
+{
+	u32 val;
+
+	val = readl(edp->regs + FUNC_EN_1);
+	val &= ~SW_FUNC_EN_N;
+	writel(val, edp->regs + FUNC_EN_1);
+}
+
+int rk3288_edp_start_aux_transaction(struct rk3288_edp *edp)
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
+		usleep_range(100, 110);
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
+int rk3288_edp_write_byte_to_dpcd(struct rk3288_edp *edp,
+				  unsigned int val_addr,
+				  unsigned char data)
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
+		retval = rk3288_edp_start_aux_transaction(edp);
+		if (retval == 0)
+			break;
+		else
+			dev_dbg(edp->dev, "Aux Transaction fail!\n");
+	}
+
+	return retval;
+}
+
+int rk3288_edp_read_byte_from_dpcd(struct rk3288_edp *edp,
+				   unsigned int val_addr,
+				   unsigned char *data)
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
+		retval = rk3288_edp_start_aux_transaction(edp);
+		if (retval == 0)
+			break;
+		else
+			dev_dbg(edp->dev, "Aux Transaction fail!\n");
+	}
+
+	/* Read data buffer */
+	val = readl(edp->regs + BUF_DATA_0);
+	*data = (unsigned char)(val & 0xff);
+
+	return retval;
+}
+
+int rk3288_edp_write_bytes_to_dpcd(struct rk3288_edp *edp,
+				   unsigned int val_addr,
+				   unsigned int count,
+				   unsigned char data[])
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
+			retval = rk3288_edp_start_aux_transaction(edp);
+			if (retval == 0)
+				break;
+			else
+				dev_dbg(edp->dev, "Aux Transaction fail!\n");
+		}
+
+		start_offset += cur_data_count;
+	}
+
+	return retval;
+}
+
+int rk3288_edp_read_bytes_from_dpcd(struct rk3288_edp *edp,
+				    unsigned int val_addr,
+				    unsigned int count,
+				    unsigned char data[])
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
+			retval = rk3288_edp_start_aux_transaction(edp);
+			if (retval == 0)
+				break;
+			else
+				dev_dbg(edp->dev, "Aux Transaction fail!\n");
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
+int rk3288_edp_select_i2c_device(struct rk3288_edp *edp,
+				 unsigned int device_addr,
+				 unsigned int val_addr)
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
+	retval = rk3288_edp_start_aux_transaction(edp);
+	if (retval != 0)
+		dev_dbg(edp->dev, "Aux Transaction fail!\n");
+
+	return retval;
+}
+
+int rk3288_edp_read_byte_from_i2c(struct rk3288_edp *edp,
+				  unsigned int device_addr,
+				  unsigned int val_addr,
+				  unsigned int *data)
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
+		retval = rk3288_edp_select_i2c_device(edp,
+						      device_addr,
+						      val_addr);
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
+		retval = rk3288_edp_start_aux_transaction(edp);
+		if (retval == 0)
+			break;
+		else
+			dev_dbg(edp->dev, "Aux Transaction fail!\n");
+	}
+
+	/* Read data */
+	if (retval == 0)
+		*data = readl(edp->regs + BUF_DATA_0);
+
+	return retval;
+}
+
+int rk3288_edp_read_bytes_from_i2c(struct rk3288_edp *edp,
+				   unsigned int device_addr,
+				   unsigned int val_addr,
+				   unsigned int count,
+				   unsigned char edid[])
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
+				retval = rk3288_edp_select_i2c_device(
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
+			retval = rk3288_edp_start_aux_transaction(edp);
+			if (retval == 0)
+				break;
+			else
+				dev_dbg(edp->dev, "Aux Transaction fail!\n");
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
+void rk3288_edp_set_link_bandwidth(struct rk3288_edp *edp, u32 bwtype)
+{
+	u32 val;
+
+	val = bwtype;
+	if ((bwtype == LINK_RATE_2_70GBPS) || (bwtype == LINK_RATE_1_62GBPS))
+		writel(val, edp->regs + LINK_BW_SET);
+}
+
+void rk3288_edp_get_link_bandwidth(struct rk3288_edp *edp, u32 *bwtype)
+{
+	u32 val;
+
+	val = readl(edp->regs + LINK_BW_SET);
+	*bwtype = val;
+}
+
+void rk3288_edp_hw_link_training_en(struct rk3288_edp *edp)
+{
+	u32 val;
+
+	val = HW_LT_EN;
+	writel(val, edp->regs + HW_LT_CTL);
+}
+
+int rk3288_edp_wait_hw_lt_done(struct rk3288_edp *edp)
+{
+	u32 val;
+
+	val = readl(edp->regs + DP_INT_STA);
+	if (val&HW_LT_DONE) {
+		writel(val, edp->regs + DP_INT_STA);
+		return 0;
+	} else {
+		return 1;
+	}
+}
+
+int rk3288_edp_get_hw_lt_status(struct rk3288_edp *edp)
+{
+	u32 val;
+
+	val = readl(edp->regs + HW_LT_CTL);
+	return (val & HW_LT_ERR_CODE_MASK) >> 4;
+}
+void rk3288_edp_set_lane_count(struct rk3288_edp *edp, u32 count)
+{
+	u32 val;
+
+	val = count;
+	writel(val, edp->regs + LANE_CNT_SET);
+}
+
+void rk3288_edp_get_lane_count(struct rk3288_edp *edp, u32 *count)
+{
+	u32 val;
+
+	val = readl(edp->regs + LANE_CNT_SET);
+	*count = val;
+}
+
+void rk3288_edp_enable_enhanced_mode(struct rk3288_edp *edp, bool enable)
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
+void rk3288_edp_set_training_pattern(struct rk3288_edp *edp,
+				     enum pattern_set pattern)
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
+void rk3288_edp_set_lane0_pre_emphasis(struct rk3288_edp *edp, u32 level)
+{
+	u32 val;
+
+	val = level << PRE_EMPHASIS_SET_SHIFT;
+	writel(val, edp->regs + LN0_LINK_TRAINING_CTL);
+}
+
+void rk3288_edp_set_lane1_pre_emphasis(struct rk3288_edp *edp, u32 level)
+{
+	u32 val;
+
+	val = level << PRE_EMPHASIS_SET_SHIFT;
+	writel(val, edp->regs + LN1_LINK_TRAINING_CTL);
+}
+
+void rk3288_edp_set_lane2_pre_emphasis(struct rk3288_edp *edp, u32 level)
+{
+	u32 val;
+
+	val = level << PRE_EMPHASIS_SET_SHIFT;
+	writel(val, edp->regs + LN2_LINK_TRAINING_CTL);
+}
+
+void rk3288_edp_set_lane3_pre_emphasis(struct rk3288_edp *edp, u32 level)
+{
+	u32 val;
+
+	val = level << PRE_EMPHASIS_SET_SHIFT;
+	writel(val, edp->regs + LN3_LINK_TRAINING_CTL);
+}
+
+void rk3288_edp_set_lane0_link_training(struct rk3288_edp *edp,
+					u32 training_lane)
+{
+	u32 val;
+
+	val = training_lane;
+	writel(val, edp->regs + LN0_LINK_TRAINING_CTL);
+}
+
+void rk3288_edp_set_lane1_link_training(struct rk3288_edp *edp,
+					u32 training_lane)
+{
+	u32 val;
+
+	val = training_lane;
+	writel(val, edp->regs + LN1_LINK_TRAINING_CTL);
+}
+
+void rk3288_edp_set_lane2_link_training(struct rk3288_edp *edp,
+					u32 training_lane)
+{
+	u32 val;
+
+	val = training_lane;
+	writel(val, edp->regs + LN2_LINK_TRAINING_CTL);
+}
+
+void rk3288_edp_set_lane3_link_training(struct rk3288_edp *edp,
+					u32 training_lane)
+{
+	u32 val;
+
+	val = training_lane;
+	writel(val, edp->regs + LN3_LINK_TRAINING_CTL);
+}
+
+u32 rk3288_edp_get_lane0_link_training(struct rk3288_edp *edp)
+{
+	u32 val;
+
+	val = readl(edp->regs + LN0_LINK_TRAINING_CTL);
+	return val;
+}
+
+u32 rk3288_edp_get_lane1_link_training(struct rk3288_edp *edp)
+{
+	u32 val;
+
+	val = readl(edp->regs + LN1_LINK_TRAINING_CTL);
+	return val;
+}
+
+u32 rk3288_edp_get_lane2_link_training(struct rk3288_edp *edp)
+{
+	u32 val;
+
+	val = readl(edp->regs + LN2_LINK_TRAINING_CTL);
+	return val;
+}
+
+u32 rk3288_edp_get_lane3_link_training(struct rk3288_edp *edp)
+{
+	u32 val;
+
+	val = readl(edp->regs + LN3_LINK_TRAINING_CTL);
+	return val;
+}
+
+void rk3288_edp_reset_macro(struct rk3288_edp *edp)
+{
+}
+
+int rk3288_edp_init_video(struct rk3288_edp *edp)
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
+void rk3288_edp_set_video_color_format(struct rk3288_edp *edp,
+				       u32 color_dedpth,
+				       u32 color_space,
+				       u32 dynamic_range,
+				       u32 coeff)
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
+int rk3288_edp_is_slave_video_stream_clock_on(struct rk3288_edp *edp)
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
+void rk3288_edp_set_video_cr_mn(struct rk3288_edp *edp,
+				enum clock_recovery_m_value_type type,
+				u32 m_value,
+				u32 n_value)
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
+void rk3288_edp_set_video_timing_mode(struct rk3288_edp *edp, u32 type)
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
+int rk3288_edp_bist_cfg(struct rk3288_edp *edp)
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
+	rk3288_edp_set_video_cr_mn(edp, CALCULATED_M, 0, 0);
+	rk3288_edp_set_video_color_format(edp, video_info->color_depth,
+					  video_info->color_space,
+					  video_info->dynamic_range,
+					  video_info->ycbcr_coeff);
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
+void rk3288_edp_enable_video_master(struct rk3288_edp *edp, bool enable)
+{
+}
+
+void rk3288_edp_start_video(struct rk3288_edp *edp)
+{
+	u32 val;
+
+	val = readl(edp->regs + VIDEO_CTL_1);
+	val |= VIDEO_EN;
+	writel(val, edp->regs + VIDEO_CTL_1);
+}
+
+int rk3288_edp_is_video_stream_on(struct rk3288_edp *edp)
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
+void rk3288_edp_config_video_slave_mode(struct rk3288_edp *edp,
+					struct video_info *video_info)
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
+void rk3288_edp_enable_scrambling(struct rk3288_edp *edp)
+{
+	u32 val;
+
+	val = readl(edp->regs + TRAINING_PTN_SET);
+	val &= ~SCRAMBLING_DISABLE;
+	writel(val, edp->regs + TRAINING_PTN_SET);
+}
+
+void rk3288_edp_disable_scrambling(struct rk3288_edp *edp)
+{
+	u32 val;
+
+	val = readl(edp->regs + TRAINING_PTN_SET);
+	val |= SCRAMBLING_DISABLE;
+	writel(val, edp->regs + TRAINING_PTN_SET);
+}
+
+enum dp_irq_type rk3288_edp_get_irq_type(struct rk3288_edp *edp)
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
+void rk3288_edp_clear_hotplug_interrupts(struct rk3288_edp *edp)
+{
+	u32 val;
+
+	val = HOTPLUG_CHG | HPD_LOST | PLUG;
+	writel(val, edp->regs + COMMON_INT_STA_4);
+
+	val = INT_HPD;
+	writel(val, edp->regs + DP_INT_STA);
+}
diff --git a/drivers/gpu/drm/rockchip/connector/rk3288_dp_reg.h b/drivers/gpu/drm/rockchip/connector/rk3288_dp_reg.h
new file mode 100644
index 0000000..baf8d90
--- /dev/null
+++ b/drivers/gpu/drm/rockchip/connector/rk3288_dp_reg.h
@@ -0,0 +1,378 @@
+/*
+* Copyright (C) Fuzhou Rockchip Electronics Co.Ltd
+* Author:
+*      yxj <yxj-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
+*      cym <cym-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
+*
+* based on exynos_dp_reg.h
+*
+* This program is free software; you can redistribute it and/or modify it
+* under the terms of the GNU General Public License as published by the
+* Free Software Foundation; either version 2 of the License, or (at your
+* option) any later version.
+*/
+
+#ifndef _RK32XX_DP_REG_H
+#define _RK32XX_DP_REG_H
+
+#define DP_VERSION				0x10
+
+#define TX_SW_RST				0x14
+
+#define FUNC_EN_1				0x18
+#define VID_CAP_FUNC_EN_N			BIT(6)
+#define VID_FIFO_FUNC_EN_N			BIT(5)
+#define AUD_FIFO_FUNC_EN_N			BIT(4)
+#define AUD_FUNC_EN_N				BIT(3)
+#define HDCP_FUNC_EN_N				BIT(2)
+#define SW_FUNC_EN_N				BIT(0)
+
+#define FUNC_EN_2				0x1C
+#define SSC_FUNC_EN_N				BIT(7)
+#define AUX_FUNC_EN_N				BIT(2)
+#define SERDES_FIFO_FUNC_EN_N			BIT(1)
+#define LS_CLK_DOMAIN_FUNC_EN_N			BIT(0)
+
+#define VIDEO_CTL_1				0x20
+#define VIDEO_EN				BIT(7)
+#define VIDEO_MUTE				BIT(6)
+
+#define VIDEO_CTL_2				0x24
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
+#define VIDEO_CTL_3				0x28
+#define IN_YC_COEFFI_MASK			(0x1 << 7)
+#define IN_YC_COEFFI_SHIFT			(7)
+#define IN_YC_COEFFI_ITU709			(0x1 << 7)
+#define IN_YC_COEFFI_ITU601			(0x0 << 7)
+#define VID_CHK_UPDATE_TYPE_MASK		(0x1 << 4)
+#define VID_CHK_UPDATE_TYPE_SHIFT		(4)
+#define VID_CHK_UPDATE_TYPE_1			(0x1 << 4)
+#define VID_CHK_UPDATE_TYPE_0			(0x0 << 4)
+
+#define VIDEO_CTL_4				0x2c
+#define BIST_EN					(0x1 << 3)
+#define BIST_WH_64				(0x1 << 2)
+#define BIST_WH_32				(0x0 << 2)
+#define BIST_TYPE_COLR_BAR			(0x0 << 0)
+#define BIST_TYPE_GRAY_BAR			(0x1 << 0)
+#define BIST_TYPE_MOBILE_BAR			(0x2 << 0)
+
+#define VIDEO_CTL_8				0x3C
+#define VID_HRES_TH(x)				(((x) & 0xf) << 4)
+#define VID_VRES_TH(x)				(((x) & 0xf) << 0)
+
+#define VIDEO_CTL_10				0x44
+#define F_SEL					(0x1 << 4)
+#define INTERACE_SCAN_CFG			(0x1 << 2)
+#define VSYNC_POLARITY_CFG			(0x1 << 1)
+#define HSYNC_POLARITY_CFG			(0x1 << 0)
+
+#define TOTAL_LINE_CFG_L			0x48
+#define TOTAL_LINE_CFG_H			0x4c
+#define ATV_LINE_CFG_L			0x50
+#define ATV_LINE_CFG_H			0x54
+#define VF_PORCH_REG			0x58
+#define VSYNC_CFG_REG			0x5c
+#define VB_PORCH_REG			0x60
+#define TOTAL_PIXELL_REG		0x64
+#define TOTAL_PIXELH_REG		0x68
+#define ATV_PIXELL_REG			0x6c
+#define ATV_PIXELH_REG			0x70
+#define HF_PORCHL_REG			0x74
+#define HF_PORCHH_REG			0x78
+#define HSYNC_CFGL_REG			0x7c
+#define HSYNC_CFGH_REG			0x80
+#define HB_PORCHL_REG			0x84
+#define HB_PORCHH_REG			0x88
+
+
+#define SSC_REG					0x104
+#define TX_REG_COMMON				0x114
+#define DP_AUX					0x120
+#define DP_BIAS					0x124
+
+#define PLL_REG_1				0xfc
+#define REF_CLK_24M				(0x1 << 1)
+#define REF_CLK_27M				(0x0 << 1)
+
+#define PLL_REG_2				0x9e4
+#define PLL_REG_3				0x9e8
+#define PLL_REG_4				0x9ec
+#define PLL_REG_5				0xa00
+#define DP_PWRDN				0x12c
+#define PD_INC_BG				BIT(7)
+#define PD_EXP_BG				BIT(6)
+#define PD_AUX					BIT(5)
+#define PD_PLL					BIT(4)
+#define PD_CH3					BIT(3)
+#define PD_CH2					BIT(2)
+#define PD_CH1					BIT(1)
+#define PD_CH0					BIT(0)
+
+#define DP_RESERVE2				0x134
+
+#define LANE_MAP				0x35C
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
+#define ANALOG_CTL_2				0x374
+#define SEL_24M					(0x1 << 3)
+
+#define AUX_HW_RETRY_CTL			0x390
+
+#define INT_STA					0x3c0
+
+#define COMMON_INT_STA_1			0x3C4
+#define VSYNC_DET				BIT(7)
+#define PLL_LOCK_CHG				BIT(6)
+#define SPDIF_ERR				BIT(5)
+#define SPDIF_UNSTBL				BIT(4)
+#define VID_FORMAT_CHG				BIT(3)
+#define AUD_CLK_CHG				BIT(2)
+#define VID_CLK_CHG				BIT(1)
+#define SW_INT					BIT(0)
+
+#define COMMON_INT_STA_2			0x3C8
+#define ENC_EN_CHG				BIT(6)
+#define HW_BKSV_RDY				BIT(3)
+#define HW_SHA_DONE				BIT(2)
+#define HW_AUTH_STATE_CHG			BIT(1)
+#define HW_AUTH_DONE				BIT(0)
+
+#define COMMON_INT_STA_3			0x3CC
+#define AFIFO_UNDER				BIT(7)
+#define AFIFO_OVER				BIT(6)
+#define R0_CHK_FLAG				BIT(5)
+
+#define COMMON_INT_STA_4			0x3D0
+#define PSR_ACTIVE				BIT(7)
+#define PSR_INACTIVE				BIT(6)
+#define SPDIF_BI_PHASE_ERR			BIT(5)
+#define HOTPLUG_CHG				BIT(2)
+#define HPD_LOST				BIT(1)
+#define PLUG					BIT(0)
+
+#define DP_INT_STA				0x3DC
+#define INT_HPD					BIT(6)
+#define HW_LT_DONE				BIT(5)
+#define SINK_LOST				BIT(3)
+#define LINK_LOST				BIT(2)
+#define RPLY_RECEIV				BIT(1)
+#define AUX_ERR					BIT(0)
+
+#define COMMON_INT_MASK_1			0x3E0
+#define COMMON_INT_MASK_2			0x3E4
+#define COMMON_INT_MASK_3			0x3E8
+#define COMMON_INT_MASK_4			0x3EC
+#define DP_INT_STA_MASK				0x3F8
+
+#define INT_CTL					0x3FC
+#define SOFT_INT_CTRL				BIT(2)
+#define INT_POL					BIT(0)
+
+#define SYS_CTL_1				0x600
+#define DET_STA					BIT(2)
+#define FORCE_DET				BIT(1)
+#define DET_CTRL				BIT(0)
+
+#define SYS_CTL_2				0x604
+#define CHA_CRI(x)				(((x) & 0xf) << 4)
+#define CHA_STA					BIT(2)
+#define FORCE_CHA				BIT(1)
+#define CHA_CTRL				BIT(0)
+
+#define SYS_CTL_3				0x608
+#define HPD_STATUS				BIT(6)
+#define F_HPD					BIT(5)
+#define HPD_CTRL				BIT(4)
+#define HDCP_RDY				BIT(3)
+#define STRM_VALID				BIT(2)
+#define F_VALID					BIT(1)
+#define VALID_CTRL				BIT(0)
+
+#define SYS_CTL_4				0x60C
+#define FIX_M_AUD				BIT(4)
+#define ENHANCED				BIT(3)
+#define FIX_M_VID				BIT(2)
+#define M_VID_UPDATE_CTRL			BIT(0)
+
+#define PKT_SEND_CTL				0x640
+#define HDCP_CTL				0x648
+
+#define LINK_BW_SET				0x680
+#define LANE_CNT_SET				0x684
+
+#define TRAINING_PTN_SET			0x688
+#define SCRAMBLING_DISABLE			(0x1 << 5)
+#define SCRAMBLING_ENABLE			(0x0 << 5)
+#define LINK_QUAL_PATTERN_SET_MASK		(0x7 << 2)
+#define LINK_QUAL_PATTERN_SET_HBR2		(0x5 << 2)
+#define LINK_QUAL_PATTERN_SET_80BIT		(0x4 << 2)
+#define LINK_QUAL_PATTERN_SET_PRBS7		(0x3 << 2)
+#define LINK_QUAL_PATTERN_SET_D10_2		(0x1 << 2)
+#define LINK_QUAL_PATTERN_SET_DISABLE		(0x0 << 2)
+#define SW_TRAINING_PATTERN_SET_MASK		(0x3 << 0)
+#define SW_TRAINING_PATTERN_SET_PTN2		(0x2 << 0)
+#define SW_TRAINING_PATTERN_SET_PTN1		(0x1 << 0)
+#define SW_TRAINING_PATTERN_SET_DISABLE		(0x0 << 0)
+
+#define LN0_LINK_TRAINING_CTL			0x68C
+#define LN1_LINK_TRAINING_CTL			0x690
+#define LN2_LINK_TRAINING_CTL			0x694
+#define LN3_LINK_TRAINING_CTL			0x698
+
+#define HW_LT_CTL				0x6a0
+#define HW_LT_ERR_CODE_MASK			0x70
+#define HW_LT_EN				BIT(0)
+
+#define DEBUG_CTL				0x6C0
+#define PLL_LOCK				BIT(4)
+#define F_PLL_LOCK				BIT(3)
+#define PLL_LOCK_CTRL				BIT(2)
+#define POLL_EN					BIT(1)
+#define PN_INV					BIT(0)
+
+#define HPD_DEGLITCH_L				0x6C4
+#define HPD_DEGLITCH_H				0x6C8
+#define LINK_DEBUG_CTL				0x6E0
+
+#define M_VID_0					0x700
+#define M_VID_1					0x704
+#define M_VID_2					0x708
+#define N_VID_0					0x70C
+#define N_VID_1					0x710
+#define N_VID_2					0x714
+
+#define VIDEO_FIFO_THRD				0x730
+#define AUDIO_MARGIN				0x73C
+
+#define M_VID_GEN_FILTER_TH			0x764
+#define M_AUD_GEN_FILTER_TH			0x778
+
+#define AUX_CH_STA				0x780
+#define AUX_BUSY				(0x1 << 4)
+#define AUX_STATUS_MASK				(0xf << 0)
+
+#define AUX_CH_DEFER_CTL			0x788
+#define DEFER_CTRL_EN				(0x1 << 7)
+#define DEFER_COUNT(x)				(((x) & 0x7f) << 0)
+
+#define AUX_RX_COMM_I2C_DEFER			(0x2 << 2)
+#define AUX_RX_COMM_AUX_DEFER			(0x2 << 0)
+
+#define AUX_RX_COMM				0x78C
+#define BUFFER_DATA_CTL				0x790
+#define BUF_CLR					(0x1 << 7)
+#define BUF_HAVE_DATA				(0x1 << 4)
+#define BUF_DATA_COUNT(x)			(((x) & 0xf) << 0)
+
+#define AUX_CH_CTL_1				0x794
+#define AUX_LENGTH(x)				(((x - 1) & 0xf) << 4)
+#define AUX_TX_COMM_MASK			(0xf << 0)
+#define AUX_TX_COMM_DP_TRANSACTION		(0x1 << 3)
+#define AUX_TX_COMM_I2C_TRANSACTION		(0x0 << 3)
+#define AUX_TX_COMM_MOT				(0x1 << 2)
+#define AUX_TX_COMM_WRITE			(0x0 << 0)
+#define AUX_TX_COMM_READ			(0x1 << 0)
+
+#define DP_AUX_ADDR_7_0				0x798
+#define DP_AUX_ADDR_15_8			0x79C
+#define DP_AUX_ADDR_19_16			0x7A0
+
+#define AUX_CH_CTL_2				0x7A4
+#define PD_AUX_IDLE				BIT(3)
+#define ADDR_ONLY				BIT(1)
+#define AUX_EN					BIT(0)
+
+#define BUF_DATA_0				0x7C0
+
+#define SOC_GENERAL_CTL				0x800
+
+/* TX_SW_RESET */
+#define RST_DP_TX				BIT(0)
+
+/* ANALOG_CTL_1 */
+#define TX_TERMINAL_CTRL_50_OHM			BIT(4)
+
+/* ANALOG_CTL_3 */
+#define DRIVE_DVDD_BIT_1_0625V			(0x4 << 5)
+#define VCO_BIT_600_MICRO			(0x5 << 0)
+
+/* PLL_FILTER_CTL_1 */
+#define PD_RING_OSC				(0x1 << 6)
+#define AUX_TERMINAL_CTRL_37_5_OHM		(0x0 << 4)
+#define AUX_TERMINAL_CTRL_45_OHM		(0x1 << 4)
+#define AUX_TERMINAL_CTRL_50_OHM		(0x2 << 4)
+#define AUX_TERMINAL_CTRL_65_OHM		(0x3 << 4)
+#define TX_CUR1_2X				(0x1 << 2)
+#define TX_CUR_16_MA				(0x3 << 0)
+
+/* TX_AMP_TUNING_CTL */
+#define CH3_AMP_SHIFT				(24)
+#define CH3_AMP_400_MV				(0x0 << 24)
+#define CH2_AMP_SHIFT				(16)
+#define CH2_AMP_400_MV				(0x0 << 16)
+#define CH1_AMP_SHIFT				(8)
+#define CH1_AMP_400_MV				(0x0 << 8)
+#define CH0_AMP_SHIFT				(0)
+#define CH0_AMP_400_MV				(0x0 << 0)
+
+/* AUX_HW_RETRY_CTL */
+#define AUX_BIT_PERIOD_EXPECTED_DELAY(x)	(((x) & 0x7) << 8)
+#define AUX_HW_RETRY_INTERVAL_MASK		(0x3 << 3)
+#define AUX_HW_RETRY_INTERVAL_600_MICROSECONDS	(0x0 << 3)
+#define AUX_HW_RETRY_INTERVAL_800_MICROSECONDS	(0x1 << 3)
+#define AUX_HW_RETRY_INTERVAL_1000_MICROSECONDS	(0x2 << 3)
+#define AUX_HW_RETRY_INTERVAL_1800_MICROSECONDS	(0x3 << 3)
+#define AUX_HW_RETRY_COUNT_SEL(x)		(((x) & 0x7) << 0)
+
+/* LN0_LINK_TRAINING_CTL */
+#define PRE_EMPHASIS_SET_MASK			(0x3 << 3)
+#define PRE_EMPHASIS_SET_SHIFT			(3)
+
+/* PLL_CTL */
+#define DP_PLL_PD				(0x1 << 7)
+#define DP_PLL_RESET				(0x1 << 6)
+#define DP_PLL_LOOP_BIT_DEFAULT			(0x1 << 4)
+#define DP_PLL_REF_BIT_1_1250V			(0x5 << 0)
+#define DP_PLL_REF_BIT_1_2500V			(0x7 << 0)
+
+/* PHY_TEST */
+#define MACRO_RST				BIT(5)
+#define CH1_TEST				BIT(1)
+#define CH0_TEST				BIT(0)
+
+#define AUX_ADDR_7_0(x)			(((x) >> 0) & 0xff)
+#define AUX_ADDR_15_8(x)		(((x) >> 8) & 0xff)
+#define AUX_ADDR_19_16(x)		(((x) >> 16) & 0x0f)
+
+#endif
diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_drv.c b/drivers/gpu/drm/rockchip/rockchip_drm_drv.c
index 59187aa..4f1205f 100644
--- a/drivers/gpu/drm/rockchip/rockchip_drm_drv.c
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_drv.c
@@ -564,6 +564,12 @@ static int rockchip_drm_init(void)
 		goto out_lvds;
 #endif
 
+#ifdef CONFIG_RK3288_DP
+	ret = platform_driver_register(&rk3288_edp_driver);
+	if (ret)
+		goto out_edp;
+#endif
+
 	rockchip_drm_pdev = platform_device_register_simple("rockchip-drm", -1,
 							    NULL, 0);
 	if (IS_ERR(rockchip_drm_pdev)) {
@@ -580,6 +586,10 @@ static int rockchip_drm_init(void)
 out_drm_driver:
 	platform_device_unregister(rockchip_drm_pdev);
 out_drm_pdev:
+#ifdef CONFIG_RK3288_DP
+	platform_driver_unregister(&rk3288_edp_driver);
+out_edp:
+#endif
 #ifdef CONFIG_RK3288_LVDS
 	platform_driver_unregister(&rk3288_lvds_driver);
 out_lvds:
@@ -596,6 +606,9 @@ static void rockchip_drm_exit(void)
 {
 	platform_device_unregister(rockchip_drm_pdev);
 	platform_driver_unregister(&rockchip_drm_platform_driver);
+#ifdef CONFIG_RK3288_DP
+	platform_driver_unregister(&rk3288_edp_driver);
+#endif
 #ifdef CONFIG_RK3288_LVDS
 	platform_driver_unregister(&rk3288_lvds_driver);
 #endif
diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_drv.h b/drivers/gpu/drm/rockchip/rockchip_drm_drv.h
index d28f4dc..565276e 100644
--- a/drivers/gpu/drm/rockchip/rockchip_drm_drv.h
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_drv.h
@@ -128,4 +128,7 @@ extern struct platform_driver rockchip_lcdc_platform_driver;
 #ifdef CONFIG_RK3288_LVDS
 extern struct platform_driver rk3288_lvds_driver;
 #endif
+#ifdef CONFIG_RK3288_DP
+extern struct platform_driver rk3288_edp_driver;
+#endif
 #endif /* _ROCKCHIP_DRM_DRV_H_ */
-- 
1.7.9.5
