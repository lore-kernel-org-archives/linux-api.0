From: Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: [PATCH] coresight: moving to new "hwtracing" directory
Date: Thu, 19 Mar 2015 16:02:02 -0600
Message-ID: <1426802522-25743-1-git-send-email-mathieu.poirier@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux@arm.linux.org.uk, catalin.marinas@arm.com
Cc: will.deacon@arm.com, gregkh@linuxfoundation.org, alexander.shishkin@linux.intel.com, linux-kernel@vger.kernel.org, peter.lachner@intel.com, norbert.schulz@intel.com, keven.boell@intel.com, yann.fouassier@intel.com, laurent.fert@intel.com, linux-api@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kaixu.xia@linaro.org, zhang.chunyan@linaro.org, mathieu.poirier@linaro.org
List-Id: linux-api@vger.kernel.org

Keeping drivers related to HW tracing on ARM, i.e coresight,
under "drivers/coresight" doesn't make sense when other
architectures start rolling out technologies of the same
nature.

As such creating a new "drivers/hwtracing" directory where all
drivers of the same kind can reside, reducing namespace
pollution under "drivers/".

Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 MAINTAINERS                                        |    2 +-
 arch/arm/Kconfig.debug                             |    2 +-
 arch/arm64/Kconfig.debug                           |    2 +-
 drivers/Makefile                                   |    2 +-
 drivers/coresight/Kconfig                          |   61 -
 drivers/coresight/Makefile                         |   11 -
 drivers/coresight/coresight-etb10.c                |  527 ------
 drivers/coresight/coresight-etm-cp14.c             |  591 ------
 drivers/coresight/coresight-etm.h                  |  251 ---
 drivers/coresight/coresight-etm3x.c                | 1932 --------------------
 drivers/coresight/coresight-funnel.c               |  258 ---
 drivers/coresight/coresight-priv.h                 |   63 -
 drivers/coresight/coresight-replicator.c           |  137 --
 drivers/coresight/coresight-tmc.c                  |  822 ---------
 drivers/coresight/coresight-tpiu.c                 |  207 ---
 drivers/coresight/coresight.c                      |  720 --------
 drivers/coresight/of_coresight.c                   |  200 --
 drivers/hwtracing/coresight/Kconfig                |   61 +
 drivers/hwtracing/coresight/Makefile               |   11 +
 drivers/hwtracing/coresight/coresight-etb10.c      |  527 ++++++
 drivers/hwtracing/coresight/coresight-etm-cp14.c   |  591 ++++++
 drivers/hwtracing/coresight/coresight-etm.h        |  251 +++
 drivers/hwtracing/coresight/coresight-etm3x.c      | 1932 ++++++++++++++++++++
 drivers/hwtracing/coresight/coresight-funnel.c     |  258 +++
 drivers/hwtracing/coresight/coresight-priv.h       |   63 +
 drivers/hwtracing/coresight/coresight-replicator.c |  137 ++
 drivers/hwtracing/coresight/coresight-tmc.c        |  822 +++++++++
 drivers/hwtracing/coresight/coresight-tpiu.c       |  207 +++
 drivers/hwtracing/coresight/coresight.c            |  720 ++++++++
 drivers/hwtracing/coresight/of_coresight.c         |  200 ++
 30 files changed, 5784 insertions(+), 5784 deletions(-)
 delete mode 100644 drivers/coresight/Kconfig
 delete mode 100644 drivers/coresight/Makefile
 delete mode 100644 drivers/coresight/coresight-etb10.c
 delete mode 100644 drivers/coresight/coresight-etm-cp14.c
 delete mode 100644 drivers/coresight/coresight-etm.h
 delete mode 100644 drivers/coresight/coresight-etm3x.c
 delete mode 100644 drivers/coresight/coresight-funnel.c
 delete mode 100644 drivers/coresight/coresight-priv.h
 delete mode 100644 drivers/coresight/coresight-replicator.c
 delete mode 100644 drivers/coresight/coresight-tmc.c
 delete mode 100644 drivers/coresight/coresight-tpiu.c
 delete mode 100644 drivers/coresight/coresight.c
 delete mode 100644 drivers/coresight/of_coresight.c
 create mode 100644 drivers/hwtracing/coresight/Kconfig
 create mode 100644 drivers/hwtracing/coresight/Makefile
 create mode 100644 drivers/hwtracing/coresight/coresight-etb10.c
 create mode 100644 drivers/hwtracing/coresight/coresight-etm-cp14.c
 create mode 100644 drivers/hwtracing/coresight/coresight-etm.h
 create mode 100644 drivers/hwtracing/coresight/coresight-etm3x.c
 create mode 100644 drivers/hwtracing/coresight/coresight-funnel.c
 create mode 100644 drivers/hwtracing/coresight/coresight-priv.h
 create mode 100644 drivers/hwtracing/coresight/coresight-replicator.c
 create mode 100644 drivers/hwtracing/coresight/coresight-tmc.c
 create mode 100644 drivers/hwtracing/coresight/coresight-tpiu.c
 create mode 100644 drivers/hwtracing/coresight/coresight.c
 create mode 100644 drivers/hwtracing/coresight/of_coresight.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 0e1abe8cc684..bc5d53ba1197 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -953,7 +953,7 @@ ARM/CORESIGHT FRAMEWORK AND DRIVERS
 M:	Mathieu Poirier <mathieu.poirier@linaro.org>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
-F:	drivers/coresight/*
+F:	drivers/hwtracing/coresight/*
 F:	Documentation/trace/coresight.txt
 F:	Documentation/devicetree/bindings/arm/coresight.txt
 F:	Documentation/ABI/testing/sysfs-bus-coresight-devices-*
diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
index 8d14ad4e1db0..8b0183a9a300 100644
--- a/arch/arm/Kconfig.debug
+++ b/arch/arm/Kconfig.debug
@@ -1610,6 +1610,6 @@ config DEBUG_SET_MODULE_RONX
 	  against certain classes of kernel exploits.
 	  If in doubt, say "N".
 
-source "drivers/coresight/Kconfig"
+source "drivers/hwtracing/coresight/Kconfig"
 
 endmenu
diff --git a/arch/arm64/Kconfig.debug b/arch/arm64/Kconfig.debug
index 5b2ffd8e6cdb..d6285ef9b5f9 100644
--- a/arch/arm64/Kconfig.debug
+++ b/arch/arm64/Kconfig.debug
@@ -89,6 +89,6 @@ config DEBUG_ALIGN_RODATA
 
 	  If in doubt, say N
 
-source "drivers/coresight/Kconfig"
+source "drivers/hwtracing/coresight/Kconfig"
 
 endmenu
diff --git a/drivers/Makefile b/drivers/Makefile
index 527a6da8d539..46d2554be404 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -163,5 +163,5 @@ obj-$(CONFIG_POWERCAP)		+= powercap/
 obj-$(CONFIG_MCB)		+= mcb/
 obj-$(CONFIG_RAS)		+= ras/
 obj-$(CONFIG_THUNDERBOLT)	+= thunderbolt/
-obj-$(CONFIG_CORESIGHT)		+= coresight/
+obj-$(CONFIG_CORESIGHT)		+= hwtracing/coresight/
 obj-$(CONFIG_ANDROID)		+= android/
diff --git a/drivers/coresight/Kconfig b/drivers/coresight/Kconfig
deleted file mode 100644
index fc1f1ae7a49d..000000000000
--- a/drivers/coresight/Kconfig
+++ /dev/null
@@ -1,61 +0,0 @@
-#
-# Coresight configuration
-#
-menuconfig CORESIGHT
-	bool "CoreSight Tracing Support"
-	select ARM_AMBA
-	help
-	  This framework provides a kernel interface for the CoreSight debug
-	  and trace drivers to register themselves with. It's intended to build
-	  a topological view of the CoreSight components based on a DT
-	  specification and configure the right serie of components when a
-	  trace source gets enabled.
-
-if CORESIGHT
-config CORESIGHT_LINKS_AND_SINKS
-	bool "CoreSight Link and Sink drivers"
-	help
-	  This enables support for CoreSight link and sink drivers that are
-	  responsible for transporting and collecting the trace data
-	  respectively.  Link and sinks are dynamically aggregated with a trace
-	  entity at run time to form a complete trace path.
-
-config CORESIGHT_LINK_AND_SINK_TMC
-	bool "Coresight generic TMC driver"
-	depends on CORESIGHT_LINKS_AND_SINKS
-	help
-	  This enables support for the Trace Memory Controller driver.
-	  Depending on its configuration the device can act as a link (embedded
-	  trace router - ETR) or sink (embedded trace FIFO).  The driver
-	  complies with the generic implementation of the component without
-	  special enhancement or added features.
-
-config CORESIGHT_SINK_TPIU
-	bool "Coresight generic TPIU driver"
-	depends on CORESIGHT_LINKS_AND_SINKS
-	help
-	  This enables support for the Trace Port Interface Unit driver,
-	  responsible for bridging the gap between the on-chip coresight
-	  components and a trace for bridging the gap between the on-chip
-	  coresight components and a trace port collection engine, typically
-	  connected to an external host for use case capturing more traces than
-	  the on-board coresight memory can handle.
-
-config CORESIGHT_SINK_ETBV10
-	bool "Coresight ETBv1.0 driver"
-	depends on CORESIGHT_LINKS_AND_SINKS
-	help
-	  This enables support for the Embedded Trace Buffer version 1.0 driver
-	  that complies with the generic implementation of the component without
-	  special enhancement or added features.
-
-config CORESIGHT_SOURCE_ETM3X
-	bool "CoreSight Embedded Trace Macrocell 3.x driver"
-	depends on !ARM64
-	select CORESIGHT_LINKS_AND_SINKS
-	help
-	  This driver provides support for processor ETM3.x and PTM1.x modules,
-	  which allows tracing the instructions that a processor is executing
-	  This is primarily useful for instruction level tracing.  Depending
-	  the ETM version data tracing may also be available.
-endif
diff --git a/drivers/coresight/Makefile b/drivers/coresight/Makefile
deleted file mode 100644
index 4b4bec890ef5..000000000000
--- a/drivers/coresight/Makefile
+++ /dev/null
@@ -1,11 +0,0 @@
-#
-# Makefile for CoreSight drivers.
-#
-obj-$(CONFIG_CORESIGHT) += coresight.o
-obj-$(CONFIG_OF) += of_coresight.o
-obj-$(CONFIG_CORESIGHT_LINK_AND_SINK_TMC) += coresight-tmc.o
-obj-$(CONFIG_CORESIGHT_SINK_TPIU) += coresight-tpiu.o
-obj-$(CONFIG_CORESIGHT_SINK_ETBV10) += coresight-etb10.o
-obj-$(CONFIG_CORESIGHT_LINKS_AND_SINKS) += coresight-funnel.o \
-					   coresight-replicator.o
-obj-$(CONFIG_CORESIGHT_SOURCE_ETM3X) += coresight-etm3x.o coresight-etm-cp14.o
diff --git a/drivers/coresight/coresight-etb10.c b/drivers/coresight/coresight-etb10.c
deleted file mode 100644
index 40049869aecd..000000000000
--- a/drivers/coresight/coresight-etb10.c
+++ /dev/null
@@ -1,527 +0,0 @@
-/* Copyright (c) 2011-2012, The Linux Foundation. All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 and
- * only version 2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- */
-
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/init.h>
-#include <linux/types.h>
-#include <linux/device.h>
-#include <linux/io.h>
-#include <linux/err.h>
-#include <linux/fs.h>
-#include <linux/miscdevice.h>
-#include <linux/uaccess.h>
-#include <linux/slab.h>
-#include <linux/spinlock.h>
-#include <linux/clk.h>
-#include <linux/seq_file.h>
-#include <linux/coresight.h>
-#include <linux/amba/bus.h>
-
-#include "coresight-priv.h"
-
-#define ETB_RAM_DEPTH_REG	0x004
-#define ETB_STATUS_REG		0x00c
-#define ETB_RAM_READ_DATA_REG	0x010
-#define ETB_RAM_READ_POINTER	0x014
-#define ETB_RAM_WRITE_POINTER	0x018
-#define ETB_TRG			0x01c
-#define ETB_CTL_REG		0x020
-#define ETB_RWD_REG		0x024
-#define ETB_FFSR		0x300
-#define ETB_FFCR		0x304
-#define ETB_ITMISCOP0		0xee0
-#define ETB_ITTRFLINACK		0xee4
-#define ETB_ITTRFLIN		0xee8
-#define ETB_ITATBDATA0		0xeeC
-#define ETB_ITATBCTR2		0xef0
-#define ETB_ITATBCTR1		0xef4
-#define ETB_ITATBCTR0		0xef8
-
-/* register description */
-/* STS - 0x00C */
-#define ETB_STATUS_RAM_FULL	BIT(0)
-/* CTL - 0x020 */
-#define ETB_CTL_CAPT_EN		BIT(0)
-/* FFCR - 0x304 */
-#define ETB_FFCR_EN_FTC		BIT(0)
-#define ETB_FFCR_FON_MAN	BIT(6)
-#define ETB_FFCR_STOP_FI	BIT(12)
-#define ETB_FFCR_STOP_TRIGGER	BIT(13)
-
-#define ETB_FFCR_BIT		6
-#define ETB_FFSR_BIT		1
-#define ETB_FRAME_SIZE_WORDS	4
-
-/**
- * struct etb_drvdata - specifics associated to an ETB component
- * @base:	memory mapped base address for this component.
- * @dev:	the device entity associated to this component.
- * @csdev:	component vitals needed by the framework.
- * @miscdev:	specifics to handle "/dev/xyz.etb" entry.
- * @clk:	the clock this component is associated to.
- * @spinlock:	only one at a time pls.
- * @in_use:	synchronise user space access to etb buffer.
- * @buf:	area of memory where ETB buffer content gets sent.
- * @buffer_depth: size of @buf.
- * @enable:	this ETB is being used.
- * @trigger_cntr: amount of words to store after a trigger.
- */
-struct etb_drvdata {
-	void __iomem		*base;
-	struct device		*dev;
-	struct coresight_device	*csdev;
-	struct miscdevice	miscdev;
-	struct clk		*clk;
-	spinlock_t		spinlock;
-	atomic_t		in_use;
-	u8			*buf;
-	u32			buffer_depth;
-	bool			enable;
-	u32			trigger_cntr;
-};
-
-static unsigned int etb_get_buffer_depth(struct etb_drvdata *drvdata)
-{
-	int ret;
-	u32 depth = 0;
-
-	ret = clk_prepare_enable(drvdata->clk);
-	if (ret)
-		return ret;
-
-	/* RO registers don't need locking */
-	depth = readl_relaxed(drvdata->base + ETB_RAM_DEPTH_REG);
-
-	clk_disable_unprepare(drvdata->clk);
-	return depth;
-}
-
-static void etb_enable_hw(struct etb_drvdata *drvdata)
-{
-	int i;
-	u32 depth;
-
-	CS_UNLOCK(drvdata->base);
-
-	depth = drvdata->buffer_depth;
-	/* reset write RAM pointer address */
-	writel_relaxed(0x0, drvdata->base + ETB_RAM_WRITE_POINTER);
-	/* clear entire RAM buffer */
-	for (i = 0; i < depth; i++)
-		writel_relaxed(0x0, drvdata->base + ETB_RWD_REG);
-
-	/* reset write RAM pointer address */
-	writel_relaxed(0x0, drvdata->base + ETB_RAM_WRITE_POINTER);
-	/* reset read RAM pointer address */
-	writel_relaxed(0x0, drvdata->base + ETB_RAM_READ_POINTER);
-
-	writel_relaxed(drvdata->trigger_cntr, drvdata->base + ETB_TRG);
-	writel_relaxed(ETB_FFCR_EN_FTC | ETB_FFCR_STOP_TRIGGER,
-		       drvdata->base + ETB_FFCR);
-	/* ETB trace capture enable */
-	writel_relaxed(ETB_CTL_CAPT_EN, drvdata->base + ETB_CTL_REG);
-
-	CS_LOCK(drvdata->base);
-}
-
-static int etb_enable(struct coresight_device *csdev)
-{
-	struct etb_drvdata *drvdata = dev_get_drvdata(csdev->dev.parent);
-	int ret;
-	unsigned long flags;
-
-	ret = clk_prepare_enable(drvdata->clk);
-	if (ret)
-		return ret;
-
-	spin_lock_irqsave(&drvdata->spinlock, flags);
-	etb_enable_hw(drvdata);
-	drvdata->enable = true;
-	spin_unlock_irqrestore(&drvdata->spinlock, flags);
-
-	dev_info(drvdata->dev, "ETB enabled\n");
-	return 0;
-}
-
-static void etb_disable_hw(struct etb_drvdata *drvdata)
-{
-	u32 ffcr;
-
-	CS_UNLOCK(drvdata->base);
-
-	ffcr = readl_relaxed(drvdata->base + ETB_FFCR);
-	/* stop formatter when a stop has completed */
-	ffcr |= ETB_FFCR_STOP_FI;
-	writel_relaxed(ffcr, drvdata->base + ETB_FFCR);
-	/* manually generate a flush of the system */
-	ffcr |= ETB_FFCR_FON_MAN;
-	writel_relaxed(ffcr, drvdata->base + ETB_FFCR);
-
-	if (coresight_timeout(drvdata->base, ETB_FFCR, ETB_FFCR_BIT, 0)) {
-		dev_err(drvdata->dev,
-			"timeout observed when probing at offset %#x\n",
-			ETB_FFCR);
-	}
-
-	/* disable trace capture */
-	writel_relaxed(0x0, drvdata->base + ETB_CTL_REG);
-
-	if (coresight_timeout(drvdata->base, ETB_FFSR, ETB_FFSR_BIT, 1)) {
-		dev_err(drvdata->dev,
-			"timeout observed when probing at offset %#x\n",
-			ETB_FFCR);
-	}
-
-	CS_LOCK(drvdata->base);
-}
-
-static void etb_dump_hw(struct etb_drvdata *drvdata)
-{
-	int i;
-	u8 *buf_ptr;
-	u32 read_data, depth;
-	u32 read_ptr, write_ptr;
-	u32 frame_off, frame_endoff;
-
-	CS_UNLOCK(drvdata->base);
-
-	read_ptr = readl_relaxed(drvdata->base + ETB_RAM_READ_POINTER);
-	write_ptr = readl_relaxed(drvdata->base + ETB_RAM_WRITE_POINTER);
-
-	frame_off = write_ptr % ETB_FRAME_SIZE_WORDS;
-	frame_endoff = ETB_FRAME_SIZE_WORDS - frame_off;
-	if (frame_off) {
-		dev_err(drvdata->dev,
-			"write_ptr: %lu not aligned to formatter frame size\n",
-			(unsigned long)write_ptr);
-		dev_err(drvdata->dev, "frameoff: %lu, frame_endoff: %lu\n",
-			(unsigned long)frame_off, (unsigned long)frame_endoff);
-		write_ptr += frame_endoff;
-	}
-
-	if ((readl_relaxed(drvdata->base + ETB_STATUS_REG)
-		      & ETB_STATUS_RAM_FULL) == 0)
-		writel_relaxed(0x0, drvdata->base + ETB_RAM_READ_POINTER);
-	else
-		writel_relaxed(write_ptr, drvdata->base + ETB_RAM_READ_POINTER);
-
-	depth = drvdata->buffer_depth;
-	buf_ptr = drvdata->buf;
-	for (i = 0; i < depth; i++) {
-		read_data = readl_relaxed(drvdata->base +
-					  ETB_RAM_READ_DATA_REG);
-		*buf_ptr++ = read_data >> 0;
-		*buf_ptr++ = read_data >> 8;
-		*buf_ptr++ = read_data >> 16;
-		*buf_ptr++ = read_data >> 24;
-	}
-
-	if (frame_off) {
-		buf_ptr -= (frame_endoff * 4);
-		for (i = 0; i < frame_endoff; i++) {
-			*buf_ptr++ = 0x0;
-			*buf_ptr++ = 0x0;
-			*buf_ptr++ = 0x0;
-			*buf_ptr++ = 0x0;
-		}
-	}
-
-	writel_relaxed(read_ptr, drvdata->base + ETB_RAM_READ_POINTER);
-
-	CS_LOCK(drvdata->base);
-}
-
-static void etb_disable(struct coresight_device *csdev)
-{
-	struct etb_drvdata *drvdata = dev_get_drvdata(csdev->dev.parent);
-	unsigned long flags;
-
-	spin_lock_irqsave(&drvdata->spinlock, flags);
-	etb_disable_hw(drvdata);
-	etb_dump_hw(drvdata);
-	drvdata->enable = false;
-	spin_unlock_irqrestore(&drvdata->spinlock, flags);
-
-	clk_disable_unprepare(drvdata->clk);
-
-	dev_info(drvdata->dev, "ETB disabled\n");
-}
-
-static const struct coresight_ops_sink etb_sink_ops = {
-	.enable		= etb_enable,
-	.disable	= etb_disable,
-};
-
-static const struct coresight_ops etb_cs_ops = {
-	.sink_ops	= &etb_sink_ops,
-};
-
-static void etb_dump(struct etb_drvdata *drvdata)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&drvdata->spinlock, flags);
-	if (drvdata->enable) {
-		etb_disable_hw(drvdata);
-		etb_dump_hw(drvdata);
-		etb_enable_hw(drvdata);
-	}
-	spin_unlock_irqrestore(&drvdata->spinlock, flags);
-
-	dev_info(drvdata->dev, "ETB dumped\n");
-}
-
-static int etb_open(struct inode *inode, struct file *file)
-{
-	struct etb_drvdata *drvdata = container_of(file->private_data,
-						   struct etb_drvdata, miscdev);
-
-	if (atomic_cmpxchg(&drvdata->in_use, 0, 1))
-		return -EBUSY;
-
-	dev_dbg(drvdata->dev, "%s: successfully opened\n", __func__);
-	return 0;
-}
-
-static ssize_t etb_read(struct file *file, char __user *data,
-				size_t len, loff_t *ppos)
-{
-	u32 depth;
-	struct etb_drvdata *drvdata = container_of(file->private_data,
-						   struct etb_drvdata, miscdev);
-
-	etb_dump(drvdata);
-
-	depth = drvdata->buffer_depth;
-	if (*ppos + len > depth * 4)
-		len = depth * 4 - *ppos;
-
-	if (copy_to_user(data, drvdata->buf + *ppos, len)) {
-		dev_dbg(drvdata->dev, "%s: copy_to_user failed\n", __func__);
-		return -EFAULT;
-	}
-
-	*ppos += len;
-
-	dev_dbg(drvdata->dev, "%s: %zu bytes copied, %d bytes left\n",
-		__func__, len, (int)(depth * 4 - *ppos));
-	return len;
-}
-
-static int etb_release(struct inode *inode, struct file *file)
-{
-	struct etb_drvdata *drvdata = container_of(file->private_data,
-						   struct etb_drvdata, miscdev);
-	atomic_set(&drvdata->in_use, 0);
-
-	dev_dbg(drvdata->dev, "%s: released\n", __func__);
-	return 0;
-}
-
-static const struct file_operations etb_fops = {
-	.owner		= THIS_MODULE,
-	.open		= etb_open,
-	.read		= etb_read,
-	.release	= etb_release,
-	.llseek		= no_llseek,
-};
-
-static ssize_t status_show(struct device *dev,
-			   struct device_attribute *attr, char *buf)
-{
-	int ret;
-	unsigned long flags;
-	u32 etb_rdr, etb_sr, etb_rrp, etb_rwp;
-	u32 etb_trg, etb_cr, etb_ffsr, etb_ffcr;
-	struct etb_drvdata *drvdata = dev_get_drvdata(dev->parent);
-
-	ret = clk_prepare_enable(drvdata->clk);
-	if (ret)
-		goto out;
-
-	spin_lock_irqsave(&drvdata->spinlock, flags);
-	CS_UNLOCK(drvdata->base);
-
-	etb_rdr = readl_relaxed(drvdata->base + ETB_RAM_DEPTH_REG);
-	etb_sr = readl_relaxed(drvdata->base + ETB_STATUS_REG);
-	etb_rrp = readl_relaxed(drvdata->base + ETB_RAM_READ_POINTER);
-	etb_rwp = readl_relaxed(drvdata->base + ETB_RAM_WRITE_POINTER);
-	etb_trg = readl_relaxed(drvdata->base + ETB_TRG);
-	etb_cr = readl_relaxed(drvdata->base + ETB_CTL_REG);
-	etb_ffsr = readl_relaxed(drvdata->base + ETB_FFSR);
-	etb_ffcr = readl_relaxed(drvdata->base + ETB_FFCR);
-
-	CS_LOCK(drvdata->base);
-	spin_unlock_irqrestore(&drvdata->spinlock, flags);
-
-	clk_disable_unprepare(drvdata->clk);
-
-	return sprintf(buf,
-		       "Depth:\t\t0x%x\n"
-		       "Status:\t\t0x%x\n"
-		       "RAM read ptr:\t0x%x\n"
-		       "RAM wrt ptr:\t0x%x\n"
-		       "Trigger cnt:\t0x%x\n"
-		       "Control:\t0x%x\n"
-		       "Flush status:\t0x%x\n"
-		       "Flush ctrl:\t0x%x\n",
-		       etb_rdr, etb_sr, etb_rrp, etb_rwp,
-		       etb_trg, etb_cr, etb_ffsr, etb_ffcr);
-out:
-	return -EINVAL;
-}
-static DEVICE_ATTR_RO(status);
-
-static ssize_t trigger_cntr_show(struct device *dev,
-			    struct device_attribute *attr, char *buf)
-{
-	struct etb_drvdata *drvdata = dev_get_drvdata(dev->parent);
-	unsigned long val = drvdata->trigger_cntr;
-
-	return sprintf(buf, "%#lx\n", val);
-}
-
-static ssize_t trigger_cntr_store(struct device *dev,
-			     struct device_attribute *attr,
-			     const char *buf, size_t size)
-{
-	int ret;
-	unsigned long val;
-	struct etb_drvdata *drvdata = dev_get_drvdata(dev->parent);
-
-	ret = kstrtoul(buf, 16, &val);
-	if (ret)
-		return ret;
-
-	drvdata->trigger_cntr = val;
-	return size;
-}
-static DEVICE_ATTR_RW(trigger_cntr);
-
-static struct attribute *coresight_etb_attrs[] = {
-	&dev_attr_trigger_cntr.attr,
-	&dev_attr_status.attr,
-	NULL,
-};
-ATTRIBUTE_GROUPS(coresight_etb);
-
-static int etb_probe(struct amba_device *adev, const struct amba_id *id)
-{
-	int ret;
-	void __iomem *base;
-	struct device *dev = &adev->dev;
-	struct coresight_platform_data *pdata = NULL;
-	struct etb_drvdata *drvdata;
-	struct resource *res = &adev->res;
-	struct coresight_desc *desc;
-	struct device_node *np = adev->dev.of_node;
-
-	if (np) {
-		pdata = of_get_coresight_platform_data(dev, np);
-		if (IS_ERR(pdata))
-			return PTR_ERR(pdata);
-		adev->dev.platform_data = pdata;
-	}
-
-	drvdata = devm_kzalloc(dev, sizeof(*drvdata), GFP_KERNEL);
-	if (!drvdata)
-		return -ENOMEM;
-
-	drvdata->dev = &adev->dev;
-	dev_set_drvdata(dev, drvdata);
-
-	/* validity for the resource is already checked by the AMBA core */
-	base = devm_ioremap_resource(dev, res);
-	if (IS_ERR(base))
-		return PTR_ERR(base);
-
-	drvdata->base = base;
-
-	spin_lock_init(&drvdata->spinlock);
-
-	drvdata->clk = adev->pclk;
-	ret = clk_prepare_enable(drvdata->clk);
-	if (ret)
-		return ret;
-
-	drvdata->buffer_depth = etb_get_buffer_depth(drvdata);
-	clk_disable_unprepare(drvdata->clk);
-
-	if (drvdata->buffer_depth < 0)
-		return -EINVAL;
-
-	drvdata->buf = devm_kzalloc(dev,
-				    drvdata->buffer_depth * 4, GFP_KERNEL);
-	if (!drvdata->buf)
-		return -ENOMEM;
-
-	desc = devm_kzalloc(dev, sizeof(*desc), GFP_KERNEL);
-	if (!desc)
-		return -ENOMEM;
-
-	desc->type = CORESIGHT_DEV_TYPE_SINK;
-	desc->subtype.sink_subtype = CORESIGHT_DEV_SUBTYPE_SINK_BUFFER;
-	desc->ops = &etb_cs_ops;
-	desc->pdata = pdata;
-	desc->dev = dev;
-	desc->groups = coresight_etb_groups;
-	drvdata->csdev = coresight_register(desc);
-	if (IS_ERR(drvdata->csdev))
-		return PTR_ERR(drvdata->csdev);
-
-	drvdata->miscdev.name = pdata->name;
-	drvdata->miscdev.minor = MISC_DYNAMIC_MINOR;
-	drvdata->miscdev.fops = &etb_fops;
-	ret = misc_register(&drvdata->miscdev);
-	if (ret)
-		goto err_misc_register;
-
-	dev_info(dev, "ETB initialized\n");
-	return 0;
-
-err_misc_register:
-	coresight_unregister(drvdata->csdev);
-	return ret;
-}
-
-static int etb_remove(struct amba_device *adev)
-{
-	struct etb_drvdata *drvdata = amba_get_drvdata(adev);
-
-	misc_deregister(&drvdata->miscdev);
-	coresight_unregister(drvdata->csdev);
-	return 0;
-}
-
-static struct amba_id etb_ids[] = {
-	{
-		.id	= 0x0003b907,
-		.mask	= 0x0003ffff,
-	},
-	{ 0, 0},
-};
-
-static struct amba_driver etb_driver = {
-	.drv = {
-		.name	= "coresight-etb10",
-		.owner	= THIS_MODULE,
-	},
-	.probe		= etb_probe,
-	.remove		= etb_remove,
-	.id_table	= etb_ids,
-};
-
-module_amba_driver(etb_driver);
-
-MODULE_LICENSE("GPL v2");
-MODULE_DESCRIPTION("CoreSight Embedded Trace Buffer driver");
diff --git a/drivers/coresight/coresight-etm-cp14.c b/drivers/coresight/coresight-etm-cp14.c
deleted file mode 100644
index 12a220682117..000000000000
--- a/drivers/coresight/coresight-etm-cp14.c
+++ /dev/null
@@ -1,591 +0,0 @@
-/* Copyright (c) 2012, The Linux Foundation. All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 and
- * only version 2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- */
-
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-
-#include <linux/kernel.h>
-#include <linux/types.h>
-#include <linux/bug.h>
-#include <asm/hardware/cp14.h>
-
-#include "coresight-etm.h"
-
-int etm_readl_cp14(u32 reg, unsigned int *val)
-{
-	switch (reg) {
-	case ETMCR:
-		*val = etm_read(ETMCR);
-		return 0;
-	case ETMCCR:
-		*val = etm_read(ETMCCR);
-		return 0;
-	case ETMTRIGGER:
-		*val = etm_read(ETMTRIGGER);
-		return 0;
-	case ETMSR:
-		*val = etm_read(ETMSR);
-		return 0;
-	case ETMSCR:
-		*val = etm_read(ETMSCR);
-		return 0;
-	case ETMTSSCR:
-		*val = etm_read(ETMTSSCR);
-		return 0;
-	case ETMTEEVR:
-		*val = etm_read(ETMTEEVR);
-		return 0;
-	case ETMTECR1:
-		*val = etm_read(ETMTECR1);
-		return 0;
-	case ETMFFLR:
-		*val = etm_read(ETMFFLR);
-		return 0;
-	case ETMACVRn(0):
-		*val = etm_read(ETMACVR0);
-		return 0;
-	case ETMACVRn(1):
-		*val = etm_read(ETMACVR1);
-		return 0;
-	case ETMACVRn(2):
-		*val = etm_read(ETMACVR2);
-		return 0;
-	case ETMACVRn(3):
-		*val = etm_read(ETMACVR3);
-		return 0;
-	case ETMACVRn(4):
-		*val = etm_read(ETMACVR4);
-		return 0;
-	case ETMACVRn(5):
-		*val = etm_read(ETMACVR5);
-		return 0;
-	case ETMACVRn(6):
-		*val = etm_read(ETMACVR6);
-		return 0;
-	case ETMACVRn(7):
-		*val = etm_read(ETMACVR7);
-		return 0;
-	case ETMACVRn(8):
-		*val = etm_read(ETMACVR8);
-		return 0;
-	case ETMACVRn(9):
-		*val = etm_read(ETMACVR9);
-		return 0;
-	case ETMACVRn(10):
-		*val = etm_read(ETMACVR10);
-		return 0;
-	case ETMACVRn(11):
-		*val = etm_read(ETMACVR11);
-		return 0;
-	case ETMACVRn(12):
-		*val = etm_read(ETMACVR12);
-		return 0;
-	case ETMACVRn(13):
-		*val = etm_read(ETMACVR13);
-		return 0;
-	case ETMACVRn(14):
-		*val = etm_read(ETMACVR14);
-		return 0;
-	case ETMACVRn(15):
-		*val = etm_read(ETMACVR15);
-		return 0;
-	case ETMACTRn(0):
-		*val = etm_read(ETMACTR0);
-		return 0;
-	case ETMACTRn(1):
-		*val = etm_read(ETMACTR1);
-		return 0;
-	case ETMACTRn(2):
-		*val = etm_read(ETMACTR2);
-		return 0;
-	case ETMACTRn(3):
-		*val = etm_read(ETMACTR3);
-		return 0;
-	case ETMACTRn(4):
-		*val = etm_read(ETMACTR4);
-		return 0;
-	case ETMACTRn(5):
-		*val = etm_read(ETMACTR5);
-		return 0;
-	case ETMACTRn(6):
-		*val = etm_read(ETMACTR6);
-		return 0;
-	case ETMACTRn(7):
-		*val = etm_read(ETMACTR7);
-		return 0;
-	case ETMACTRn(8):
-		*val = etm_read(ETMACTR8);
-		return 0;
-	case ETMACTRn(9):
-		*val = etm_read(ETMACTR9);
-		return 0;
-	case ETMACTRn(10):
-		*val = etm_read(ETMACTR10);
-		return 0;
-	case ETMACTRn(11):
-		*val = etm_read(ETMACTR11);
-		return 0;
-	case ETMACTRn(12):
-		*val = etm_read(ETMACTR12);
-		return 0;
-	case ETMACTRn(13):
-		*val = etm_read(ETMACTR13);
-		return 0;
-	case ETMACTRn(14):
-		*val = etm_read(ETMACTR14);
-		return 0;
-	case ETMACTRn(15):
-		*val = etm_read(ETMACTR15);
-		return 0;
-	case ETMCNTRLDVRn(0):
-		*val = etm_read(ETMCNTRLDVR0);
-		return 0;
-	case ETMCNTRLDVRn(1):
-		*val = etm_read(ETMCNTRLDVR1);
-		return 0;
-	case ETMCNTRLDVRn(2):
-		*val = etm_read(ETMCNTRLDVR2);
-		return 0;
-	case ETMCNTRLDVRn(3):
-		*val = etm_read(ETMCNTRLDVR3);
-		return 0;
-	case ETMCNTENRn(0):
-		*val = etm_read(ETMCNTENR0);
-		return 0;
-	case ETMCNTENRn(1):
-		*val = etm_read(ETMCNTENR1);
-		return 0;
-	case ETMCNTENRn(2):
-		*val = etm_read(ETMCNTENR2);
-		return 0;
-	case ETMCNTENRn(3):
-		*val = etm_read(ETMCNTENR3);
-		return 0;
-	case ETMCNTRLDEVRn(0):
-		*val = etm_read(ETMCNTRLDEVR0);
-		return 0;
-	case ETMCNTRLDEVRn(1):
-		*val = etm_read(ETMCNTRLDEVR1);
-		return 0;
-	case ETMCNTRLDEVRn(2):
-		*val = etm_read(ETMCNTRLDEVR2);
-		return 0;
-	case ETMCNTRLDEVRn(3):
-		*val = etm_read(ETMCNTRLDEVR3);
-		return 0;
-	case ETMCNTVRn(0):
-		*val = etm_read(ETMCNTVR0);
-		return 0;
-	case ETMCNTVRn(1):
-		*val = etm_read(ETMCNTVR1);
-		return 0;
-	case ETMCNTVRn(2):
-		*val = etm_read(ETMCNTVR2);
-		return 0;
-	case ETMCNTVRn(3):
-		*val = etm_read(ETMCNTVR3);
-		return 0;
-	case ETMSQ12EVR:
-		*val = etm_read(ETMSQ12EVR);
-		return 0;
-	case ETMSQ21EVR:
-		*val = etm_read(ETMSQ21EVR);
-		return 0;
-	case ETMSQ23EVR:
-		*val = etm_read(ETMSQ23EVR);
-		return 0;
-	case ETMSQ31EVR:
-		*val = etm_read(ETMSQ31EVR);
-		return 0;
-	case ETMSQ32EVR:
-		*val = etm_read(ETMSQ32EVR);
-		return 0;
-	case ETMSQ13EVR:
-		*val = etm_read(ETMSQ13EVR);
-		return 0;
-	case ETMSQR:
-		*val = etm_read(ETMSQR);
-		return 0;
-	case ETMEXTOUTEVRn(0):
-		*val = etm_read(ETMEXTOUTEVR0);
-		return 0;
-	case ETMEXTOUTEVRn(1):
-		*val = etm_read(ETMEXTOUTEVR1);
-		return 0;
-	case ETMEXTOUTEVRn(2):
-		*val = etm_read(ETMEXTOUTEVR2);
-		return 0;
-	case ETMEXTOUTEVRn(3):
-		*val = etm_read(ETMEXTOUTEVR3);
-		return 0;
-	case ETMCIDCVRn(0):
-		*val = etm_read(ETMCIDCVR0);
-		return 0;
-	case ETMCIDCVRn(1):
-		*val = etm_read(ETMCIDCVR1);
-		return 0;
-	case ETMCIDCVRn(2):
-		*val = etm_read(ETMCIDCVR2);
-		return 0;
-	case ETMCIDCMR:
-		*val = etm_read(ETMCIDCMR);
-		return 0;
-	case ETMIMPSPEC0:
-		*val = etm_read(ETMIMPSPEC0);
-		return 0;
-	case ETMIMPSPEC1:
-		*val = etm_read(ETMIMPSPEC1);
-		return 0;
-	case ETMIMPSPEC2:
-		*val = etm_read(ETMIMPSPEC2);
-		return 0;
-	case ETMIMPSPEC3:
-		*val = etm_read(ETMIMPSPEC3);
-		return 0;
-	case ETMIMPSPEC4:
-		*val = etm_read(ETMIMPSPEC4);
-		return 0;
-	case ETMIMPSPEC5:
-		*val = etm_read(ETMIMPSPEC5);
-		return 0;
-	case ETMIMPSPEC6:
-		*val = etm_read(ETMIMPSPEC6);
-		return 0;
-	case ETMIMPSPEC7:
-		*val = etm_read(ETMIMPSPEC7);
-		return 0;
-	case ETMSYNCFR:
-		*val = etm_read(ETMSYNCFR);
-		return 0;
-	case ETMIDR:
-		*val = etm_read(ETMIDR);
-		return 0;
-	case ETMCCER:
-		*val = etm_read(ETMCCER);
-		return 0;
-	case ETMEXTINSELR:
-		*val = etm_read(ETMEXTINSELR);
-		return 0;
-	case ETMTESSEICR:
-		*val = etm_read(ETMTESSEICR);
-		return 0;
-	case ETMEIBCR:
-		*val = etm_read(ETMEIBCR);
-		return 0;
-	case ETMTSEVR:
-		*val = etm_read(ETMTSEVR);
-		return 0;
-	case ETMAUXCR:
-		*val = etm_read(ETMAUXCR);
-		return 0;
-	case ETMTRACEIDR:
-		*val = etm_read(ETMTRACEIDR);
-		return 0;
-	case ETMVMIDCVR:
-		*val = etm_read(ETMVMIDCVR);
-		return 0;
-	case ETMOSLSR:
-		*val = etm_read(ETMOSLSR);
-		return 0;
-	case ETMOSSRR:
-		*val = etm_read(ETMOSSRR);
-		return 0;
-	case ETMPDCR:
-		*val = etm_read(ETMPDCR);
-		return 0;
-	case ETMPDSR:
-		*val = etm_read(ETMPDSR);
-		return 0;
-	default:
-		*val = 0;
-		return -EINVAL;
-	}
-}
-
-int etm_writel_cp14(u32 reg, u32 val)
-{
-	switch (reg) {
-	case ETMCR:
-		etm_write(val, ETMCR);
-		break;
-	case ETMTRIGGER:
-		etm_write(val, ETMTRIGGER);
-		break;
-	case ETMSR:
-		etm_write(val, ETMSR);
-		break;
-	case ETMTSSCR:
-		etm_write(val, ETMTSSCR);
-		break;
-	case ETMTEEVR:
-		etm_write(val, ETMTEEVR);
-		break;
-	case ETMTECR1:
-		etm_write(val, ETMTECR1);
-		break;
-	case ETMFFLR:
-		etm_write(val, ETMFFLR);
-		break;
-	case ETMACVRn(0):
-		etm_write(val, ETMACVR0);
-		break;
-	case ETMACVRn(1):
-		etm_write(val, ETMACVR1);
-		break;
-	case ETMACVRn(2):
-		etm_write(val, ETMACVR2);
-		break;
-	case ETMACVRn(3):
-		etm_write(val, ETMACVR3);
-		break;
-	case ETMACVRn(4):
-		etm_write(val, ETMACVR4);
-		break;
-	case ETMACVRn(5):
-		etm_write(val, ETMACVR5);
-		break;
-	case ETMACVRn(6):
-		etm_write(val, ETMACVR6);
-		break;
-	case ETMACVRn(7):
-		etm_write(val, ETMACVR7);
-		break;
-	case ETMACVRn(8):
-		etm_write(val, ETMACVR8);
-		break;
-	case ETMACVRn(9):
-		etm_write(val, ETMACVR9);
-		break;
-	case ETMACVRn(10):
-		etm_write(val, ETMACVR10);
-		break;
-	case ETMACVRn(11):
-		etm_write(val, ETMACVR11);
-		break;
-	case ETMACVRn(12):
-		etm_write(val, ETMACVR12);
-		break;
-	case ETMACVRn(13):
-		etm_write(val, ETMACVR13);
-		break;
-	case ETMACVRn(14):
-		etm_write(val, ETMACVR14);
-		break;
-	case ETMACVRn(15):
-		etm_write(val, ETMACVR15);
-		break;
-	case ETMACTRn(0):
-		etm_write(val, ETMACTR0);
-		break;
-	case ETMACTRn(1):
-		etm_write(val, ETMACTR1);
-		break;
-	case ETMACTRn(2):
-		etm_write(val, ETMACTR2);
-		break;
-	case ETMACTRn(3):
-		etm_write(val, ETMACTR3);
-		break;
-	case ETMACTRn(4):
-		etm_write(val, ETMACTR4);
-		break;
-	case ETMACTRn(5):
-		etm_write(val, ETMACTR5);
-		break;
-	case ETMACTRn(6):
-		etm_write(val, ETMACTR6);
-		break;
-	case ETMACTRn(7):
-		etm_write(val, ETMACTR7);
-		break;
-	case ETMACTRn(8):
-		etm_write(val, ETMACTR8);
-		break;
-	case ETMACTRn(9):
-		etm_write(val, ETMACTR9);
-		break;
-	case ETMACTRn(10):
-		etm_write(val, ETMACTR10);
-		break;
-	case ETMACTRn(11):
-		etm_write(val, ETMACTR11);
-		break;
-	case ETMACTRn(12):
-		etm_write(val, ETMACTR12);
-		break;
-	case ETMACTRn(13):
-		etm_write(val, ETMACTR13);
-		break;
-	case ETMACTRn(14):
-		etm_write(val, ETMACTR14);
-		break;
-	case ETMACTRn(15):
-		etm_write(val, ETMACTR15);
-		break;
-	case ETMCNTRLDVRn(0):
-		etm_write(val, ETMCNTRLDVR0);
-		break;
-	case ETMCNTRLDVRn(1):
-		etm_write(val, ETMCNTRLDVR1);
-		break;
-	case ETMCNTRLDVRn(2):
-		etm_write(val, ETMCNTRLDVR2);
-		break;
-	case ETMCNTRLDVRn(3):
-		etm_write(val, ETMCNTRLDVR3);
-		break;
-	case ETMCNTENRn(0):
-		etm_write(val, ETMCNTENR0);
-		break;
-	case ETMCNTENRn(1):
-		etm_write(val, ETMCNTENR1);
-		break;
-	case ETMCNTENRn(2):
-		etm_write(val, ETMCNTENR2);
-		break;
-	case ETMCNTENRn(3):
-		etm_write(val, ETMCNTENR3);
-		break;
-	case ETMCNTRLDEVRn(0):
-		etm_write(val, ETMCNTRLDEVR0);
-		break;
-	case ETMCNTRLDEVRn(1):
-		etm_write(val, ETMCNTRLDEVR1);
-		break;
-	case ETMCNTRLDEVRn(2):
-		etm_write(val, ETMCNTRLDEVR2);
-		break;
-	case ETMCNTRLDEVRn(3):
-		etm_write(val, ETMCNTRLDEVR3);
-		break;
-	case ETMCNTVRn(0):
-		etm_write(val, ETMCNTVR0);
-		break;
-	case ETMCNTVRn(1):
-		etm_write(val, ETMCNTVR1);
-		break;
-	case ETMCNTVRn(2):
-		etm_write(val, ETMCNTVR2);
-		break;
-	case ETMCNTVRn(3):
-		etm_write(val, ETMCNTVR3);
-		break;
-	case ETMSQ12EVR:
-		etm_write(val, ETMSQ12EVR);
-		break;
-	case ETMSQ21EVR:
-		etm_write(val, ETMSQ21EVR);
-		break;
-	case ETMSQ23EVR:
-		etm_write(val, ETMSQ23EVR);
-		break;
-	case ETMSQ31EVR:
-		etm_write(val, ETMSQ31EVR);
-		break;
-	case ETMSQ32EVR:
-		etm_write(val, ETMSQ32EVR);
-		break;
-	case ETMSQ13EVR:
-		etm_write(val, ETMSQ13EVR);
-		break;
-	case ETMSQR:
-		etm_write(val, ETMSQR);
-		break;
-	case ETMEXTOUTEVRn(0):
-		etm_write(val, ETMEXTOUTEVR0);
-		break;
-	case ETMEXTOUTEVRn(1):
-		etm_write(val, ETMEXTOUTEVR1);
-		break;
-	case ETMEXTOUTEVRn(2):
-		etm_write(val, ETMEXTOUTEVR2);
-		break;
-	case ETMEXTOUTEVRn(3):
-		etm_write(val, ETMEXTOUTEVR3);
-		break;
-	case ETMCIDCVRn(0):
-		etm_write(val, ETMCIDCVR0);
-		break;
-	case ETMCIDCVRn(1):
-		etm_write(val, ETMCIDCVR1);
-		break;
-	case ETMCIDCVRn(2):
-		etm_write(val, ETMCIDCVR2);
-		break;
-	case ETMCIDCMR:
-		etm_write(val, ETMCIDCMR);
-		break;
-	case ETMIMPSPEC0:
-		etm_write(val, ETMIMPSPEC0);
-		break;
-	case ETMIMPSPEC1:
-		etm_write(val, ETMIMPSPEC1);
-		break;
-	case ETMIMPSPEC2:
-		etm_write(val, ETMIMPSPEC2);
-		break;
-	case ETMIMPSPEC3:
-		etm_write(val, ETMIMPSPEC3);
-		break;
-	case ETMIMPSPEC4:
-		etm_write(val, ETMIMPSPEC4);
-		break;
-	case ETMIMPSPEC5:
-		etm_write(val, ETMIMPSPEC5);
-		break;
-	case ETMIMPSPEC6:
-		etm_write(val, ETMIMPSPEC6);
-		break;
-	case ETMIMPSPEC7:
-		etm_write(val, ETMIMPSPEC7);
-		break;
-	case ETMSYNCFR:
-		etm_write(val, ETMSYNCFR);
-		break;
-	case ETMEXTINSELR:
-		etm_write(val, ETMEXTINSELR);
-		break;
-	case ETMTESSEICR:
-		etm_write(val, ETMTESSEICR);
-		break;
-	case ETMEIBCR:
-		etm_write(val, ETMEIBCR);
-		break;
-	case ETMTSEVR:
-		etm_write(val, ETMTSEVR);
-		break;
-	case ETMAUXCR:
-		etm_write(val, ETMAUXCR);
-		break;
-	case ETMTRACEIDR:
-		etm_write(val, ETMTRACEIDR);
-		break;
-	case ETMVMIDCVR:
-		etm_write(val, ETMVMIDCVR);
-		break;
-	case ETMOSLAR:
-		etm_write(val, ETMOSLAR);
-		break;
-	case ETMOSSRR:
-		etm_write(val, ETMOSSRR);
-		break;
-	case ETMPDCR:
-		etm_write(val, ETMPDCR);
-		break;
-	case ETMPDSR:
-		etm_write(val, ETMPDSR);
-		break;
-	default:
-		return -EINVAL;
-	}
-
-	return 0;
-}
diff --git a/drivers/coresight/coresight-etm.h b/drivers/coresight/coresight-etm.h
deleted file mode 100644
index 501c5fac8a45..000000000000
--- a/drivers/coresight/coresight-etm.h
+++ /dev/null
@@ -1,251 +0,0 @@
-/* Copyright (c) 2014-2015, The Linux Foundation. All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 and
- * only version 2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- */
-
-#ifndef _CORESIGHT_CORESIGHT_ETM_H
-#define _CORESIGHT_CORESIGHT_ETM_H
-
-#include <linux/spinlock.h>
-#include "coresight-priv.h"
-
-/*
- * Device registers:
- * 0x000 - 0x2FC: Trace         registers
- * 0x300 - 0x314: Management    registers
- * 0x318 - 0xEFC: Trace         registers
- *
- * Coresight registers
- * 0xF00 - 0xF9C: Management    registers
- * 0xFA0 - 0xFA4: Management    registers in PFTv1.0
- *                Trace         registers in PFTv1.1
- * 0xFA8 - 0xFFC: Management    registers
- */
-
-/* Trace registers (0x000-0x2FC) */
-#define ETMCR			0x000
-#define ETMCCR			0x004
-#define ETMTRIGGER		0x008
-#define ETMSR			0x010
-#define ETMSCR			0x014
-#define ETMTSSCR		0x018
-#define ETMTECR2		0x01c
-#define ETMTEEVR		0x020
-#define ETMTECR1		0x024
-#define ETMFFLR			0x02c
-#define ETMACVRn(n)		(0x040 + (n * 4))
-#define ETMACTRn(n)		(0x080 + (n * 4))
-#define ETMCNTRLDVRn(n)		(0x140 + (n * 4))
-#define ETMCNTENRn(n)		(0x150 + (n * 4))
-#define ETMCNTRLDEVRn(n)	(0x160 + (n * 4))
-#define ETMCNTVRn(n)		(0x170 + (n * 4))
-#define ETMSQ12EVR		0x180
-#define ETMSQ21EVR		0x184
-#define ETMSQ23EVR		0x188
-#define ETMSQ31EVR		0x18c
-#define ETMSQ32EVR		0x190
-#define ETMSQ13EVR		0x194
-#define ETMSQR			0x19c
-#define ETMEXTOUTEVRn(n)	(0x1a0 + (n * 4))
-#define ETMCIDCVRn(n)		(0x1b0 + (n * 4))
-#define ETMCIDCMR		0x1bc
-#define ETMIMPSPEC0		0x1c0
-#define ETMIMPSPEC1		0x1c4
-#define ETMIMPSPEC2		0x1c8
-#define ETMIMPSPEC3		0x1cc
-#define ETMIMPSPEC4		0x1d0
-#define ETMIMPSPEC5		0x1d4
-#define ETMIMPSPEC6		0x1d8
-#define ETMIMPSPEC7		0x1dc
-#define ETMSYNCFR		0x1e0
-#define ETMIDR			0x1e4
-#define ETMCCER			0x1e8
-#define ETMEXTINSELR		0x1ec
-#define ETMTESSEICR		0x1f0
-#define ETMEIBCR		0x1f4
-#define ETMTSEVR		0x1f8
-#define ETMAUXCR		0x1fc
-#define ETMTRACEIDR		0x200
-#define ETMVMIDCVR		0x240
-/* Management registers (0x300-0x314) */
-#define ETMOSLAR		0x300
-#define ETMOSLSR		0x304
-#define ETMOSSRR		0x308
-#define ETMPDCR			0x310
-#define ETMPDSR			0x314
-#define ETM_MAX_ADDR_CMP	16
-#define ETM_MAX_CNTR		4
-#define ETM_MAX_CTXID_CMP	3
-
-/* Register definition */
-/* ETMCR - 0x00 */
-#define ETMCR_PWD_DWN		BIT(0)
-#define ETMCR_STALL_MODE	BIT(7)
-#define ETMCR_ETM_PRG		BIT(10)
-#define ETMCR_ETM_EN		BIT(11)
-#define ETMCR_CYC_ACC		BIT(12)
-#define ETMCR_CTXID_SIZE	(BIT(14)|BIT(15))
-#define ETMCR_TIMESTAMP_EN	BIT(28)
-/* ETMCCR - 0x04 */
-#define ETMCCR_FIFOFULL		BIT(23)
-/* ETMPDCR - 0x310 */
-#define ETMPDCR_PWD_UP		BIT(3)
-/* ETMTECR1 - 0x024 */
-#define ETMTECR1_ADDR_COMP_1	BIT(0)
-#define ETMTECR1_INC_EXC	BIT(24)
-#define ETMTECR1_START_STOP	BIT(25)
-/* ETMCCER - 0x1E8 */
-#define ETMCCER_TIMESTAMP	BIT(22)
-
-#define ETM_MODE_EXCLUDE	BIT(0)
-#define ETM_MODE_CYCACC		BIT(1)
-#define ETM_MODE_STALL		BIT(2)
-#define ETM_MODE_TIMESTAMP	BIT(3)
-#define ETM_MODE_CTXID		BIT(4)
-#define ETM_MODE_ALL		0x1f
-
-#define ETM_SQR_MASK		0x3
-#define ETM_TRACEID_MASK	0x3f
-#define ETM_EVENT_MASK		0x1ffff
-#define ETM_SYNC_MASK		0xfff
-#define ETM_ALL_MASK		0xffffffff
-
-#define ETMSR_PROG_BIT		1
-#define ETM_SEQ_STATE_MAX_VAL	(0x2)
-#define PORT_SIZE_MASK		(GENMASK(21, 21) | GENMASK(6, 4))
-
-#define ETM_HARD_WIRE_RES_A	/* Hard wired, always true */	\
-				((0x0f << 0)	|		\
-				/* Resource index A */		\
-				(0x06 << 4))
-
-#define ETM_ADD_COMP_0		/* Single addr comparator 1 */	\
-				((0x00 << 7)	|		\
-				/* Resource index B */		\
-				(0x00 << 11))
-
-#define ETM_EVENT_NOT_A		BIT(14) /* NOT(A) */
-
-#define ETM_DEFAULT_EVENT_VAL	(ETM_HARD_WIRE_RES_A	|	\
-				 ETM_ADD_COMP_0		|	\
-				 ETM_EVENT_NOT_A)
-/**
- * struct etm_drvdata - specifics associated to an ETM component
- * @base:	memory mapped base address for this component.
- * @dev:	the device entity associated to this component.
- * @csdev:	component vitals needed by the framework.
- * @clk:	the clock this component is associated to.
- * @spinlock:	only one at a time pls.
- * @cpu:	the cpu this component is affined to.
- * @port_size:	port size as reported by ETMCR bit 4-6 and 21.
- * @arch:	ETM/PTM version number.
- * @use_cpu14:	true if management registers need to be accessed via CP14.
- * @enable:	is this ETM/PTM currently tracing.
- * @sticky_enable: true if ETM base configuration has been done.
- * @boot_enable:true if we should start tracing at boot time.
- * @os_unlock:	true if access to management registers is allowed.
- * @nr_addr_cmp:Number of pairs of address comparators as found in ETMCCR.
- * @nr_cntr:	Number of counters as found in ETMCCR bit 13-15.
- * @nr_ext_inp:	Number of external input as found in ETMCCR bit 17-19.
- * @nr_ext_out:	Number of external output as found in ETMCCR bit 20-22.
- * @nr_ctxid_cmp: Number of contextID comparators as found in ETMCCR bit 24-25.
- * @etmccr:	value of register ETMCCR.
- * @etmccer:	value of register ETMCCER.
- * @traceid:	value of the current ID for this component.
- * @mode:	controls various modes supported by this ETM/PTM.
- * @ctrl:	used in conjunction with @mode.
- * @trigger_event: setting for register ETMTRIGGER.
- * @startstop_ctrl: setting for register ETMTSSCR.
- * @enable_event: setting for register ETMTEEVR.
- * @enable_ctrl1: setting for register ETMTECR1.
- * @fifofull_level: setting for register ETMFFLR.
- * @addr_idx:	index for the address comparator selection.
- * @addr_val:	value for address comparator register.
- * @addr_acctype: access type for address comparator register.
- * @addr_type:	current status of the comparator register.
- * @cntr_idx:	index for the counter register selection.
- * @cntr_rld_val: reload value of a counter register.
- * @cntr_event:	control for counter enable register.
- * @cntr_rld_event: value for counter reload event register.
- * @cntr_val:	counter value register.
- * @seq_12_event: event causing the transition from 1 to 2.
- * @seq_21_event: event causing the transition from 2 to 1.
- * @seq_23_event: event causing the transition from 2 to 3.
- * @seq_31_event: event causing the transition from 3 to 1.
- * @seq_32_event: event causing the transition from 3 to 2.
- * @seq_13_event: event causing the transition from 1 to 3.
- * @seq_curr_state: current value of the sequencer register.
- * @ctxid_idx: index for the context ID registers.
- * @ctxid_val: value for the context ID to trigger on.
- * @ctxid_mask: mask applicable to all the context IDs.
- * @sync_freq:	Synchronisation frequency.
- * @timestamp_event: Defines an event that requests the insertion
-		     of a timestamp into the trace stream.
- */
-struct etm_drvdata {
-	void __iomem			*base;
-	struct device			*dev;
-	struct coresight_device		*csdev;
-	struct clk			*clk;
-	spinlock_t			spinlock;
-	int				cpu;
-	int				port_size;
-	u8				arch;
-	bool				use_cp14;
-	bool				enable;
-	bool				sticky_enable;
-	bool				boot_enable;
-	bool				os_unlock;
-	u8				nr_addr_cmp;
-	u8				nr_cntr;
-	u8				nr_ext_inp;
-	u8				nr_ext_out;
-	u8				nr_ctxid_cmp;
-	u32				etmccr;
-	u32				etmccer;
-	u32				traceid;
-	u32				mode;
-	u32				ctrl;
-	u32				trigger_event;
-	u32				startstop_ctrl;
-	u32				enable_event;
-	u32				enable_ctrl1;
-	u32				fifofull_level;
-	u8				addr_idx;
-	u32				addr_val[ETM_MAX_ADDR_CMP];
-	u32				addr_acctype[ETM_MAX_ADDR_CMP];
-	u32				addr_type[ETM_MAX_ADDR_CMP];
-	u8				cntr_idx;
-	u32				cntr_rld_val[ETM_MAX_CNTR];
-	u32				cntr_event[ETM_MAX_CNTR];
-	u32				cntr_rld_event[ETM_MAX_CNTR];
-	u32				cntr_val[ETM_MAX_CNTR];
-	u32				seq_12_event;
-	u32				seq_21_event;
-	u32				seq_23_event;
-	u32				seq_31_event;
-	u32				seq_32_event;
-	u32				seq_13_event;
-	u32				seq_curr_state;
-	u8				ctxid_idx;
-	u32				ctxid_val[ETM_MAX_CTXID_CMP];
-	u32				ctxid_mask;
-	u32				sync_freq;
-	u32				timestamp_event;
-};
-
-enum etm_addr_type {
-	ETM_ADDR_TYPE_NONE,
-	ETM_ADDR_TYPE_SINGLE,
-	ETM_ADDR_TYPE_RANGE,
-	ETM_ADDR_TYPE_START,
-	ETM_ADDR_TYPE_STOP,
-};
-#endif
diff --git a/drivers/coresight/coresight-etm3x.c b/drivers/coresight/coresight-etm3x.c
deleted file mode 100644
index c965f5724abd..000000000000
--- a/drivers/coresight/coresight-etm3x.c
+++ /dev/null
@@ -1,1932 +0,0 @@
-/* Copyright (c) 2011-2012, The Linux Foundation. All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 and
- * only version 2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- */
-
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/init.h>
-#include <linux/types.h>
-#include <linux/device.h>
-#include <linux/io.h>
-#include <linux/err.h>
-#include <linux/fs.h>
-#include <linux/slab.h>
-#include <linux/delay.h>
-#include <linux/smp.h>
-#include <linux/sysfs.h>
-#include <linux/stat.h>
-#include <linux/clk.h>
-#include <linux/cpu.h>
-#include <linux/of.h>
-#include <linux/coresight.h>
-#include <linux/amba/bus.h>
-#include <linux/seq_file.h>
-#include <linux/uaccess.h>
-#include <asm/sections.h>
-
-#include "coresight-etm.h"
-
-static int boot_enable;
-module_param_named(boot_enable, boot_enable, int, S_IRUGO);
-
-/* The number of ETM/PTM currently registered */
-static int etm_count;
-static struct etm_drvdata *etmdrvdata[NR_CPUS];
-
-static inline void etm_writel(struct etm_drvdata *drvdata,
-			      u32 val, u32 off)
-{
-	if (drvdata->use_cp14) {
-		if (etm_writel_cp14(off, val)) {
-			dev_err(drvdata->dev,
-				"invalid CP14 access to ETM reg: %#x", off);
-		}
-	} else {
-		writel_relaxed(val, drvdata->base + off);
-	}
-}
-
-static inline unsigned int etm_readl(struct etm_drvdata *drvdata, u32 off)
-{
-	u32 val;
-
-	if (drvdata->use_cp14) {
-		if (etm_readl_cp14(off, &val)) {
-			dev_err(drvdata->dev,
-				"invalid CP14 access to ETM reg: %#x", off);
-		}
-	} else {
-		val = readl_relaxed(drvdata->base + off);
-	}
-
-	return val;
-}
-
-/*
- * Memory mapped writes to clear os lock are not supported on some processors
- * and OS lock must be unlocked before any memory mapped access on such
- * processors, otherwise memory mapped reads/writes will be invalid.
- */
-static void etm_os_unlock(void *info)
-{
-	struct etm_drvdata *drvdata = (struct etm_drvdata *)info;
-	/* Writing any value to ETMOSLAR unlocks the trace registers */
-	etm_writel(drvdata, 0x0, ETMOSLAR);
-	isb();
-}
-
-static void etm_set_pwrdwn(struct etm_drvdata *drvdata)
-{
-	u32 etmcr;
-
-	/* Ensure pending cp14 accesses complete before setting pwrdwn */
-	mb();
-	isb();
-	etmcr = etm_readl(drvdata, ETMCR);
-	etmcr |= ETMCR_PWD_DWN;
-	etm_writel(drvdata, etmcr, ETMCR);
-}
-
-static void etm_clr_pwrdwn(struct etm_drvdata *drvdata)
-{
-	u32 etmcr;
-
-	etmcr = etm_readl(drvdata, ETMCR);
-	etmcr &= ~ETMCR_PWD_DWN;
-	etm_writel(drvdata, etmcr, ETMCR);
-	/* Ensure pwrup completes before subsequent cp14 accesses */
-	mb();
-	isb();
-}
-
-static void etm_set_pwrup(struct etm_drvdata *drvdata)
-{
-	u32 etmpdcr;
-
-	etmpdcr = readl_relaxed(drvdata->base + ETMPDCR);
-	etmpdcr |= ETMPDCR_PWD_UP;
-	writel_relaxed(etmpdcr, drvdata->base + ETMPDCR);
-	/* Ensure pwrup completes before subsequent cp14 accesses */
-	mb();
-	isb();
-}
-
-static void etm_clr_pwrup(struct etm_drvdata *drvdata)
-{
-	u32 etmpdcr;
-
-	/* Ensure pending cp14 accesses complete before clearing pwrup */
-	mb();
-	isb();
-	etmpdcr = readl_relaxed(drvdata->base + ETMPDCR);
-	etmpdcr &= ~ETMPDCR_PWD_UP;
-	writel_relaxed(etmpdcr, drvdata->base + ETMPDCR);
-}
-
-/**
- * coresight_timeout_etm - loop until a bit has changed to a specific state.
- * @drvdata: etm's private data structure.
- * @offset: address of a register, starting from @addr.
- * @position: the position of the bit of interest.
- * @value: the value the bit should have.
- *
- * Basically the same as @coresight_timeout except for the register access
- * method where we have to account for CP14 configurations.
-
- * Return: 0 as soon as the bit has taken the desired state or -EAGAIN if
- * TIMEOUT_US has elapsed, which ever happens first.
- */
-
-static int coresight_timeout_etm(struct etm_drvdata *drvdata, u32 offset,
-				  int position, int value)
-{
-	int i;
-	u32 val;
-
-	for (i = TIMEOUT_US; i > 0; i--) {
-		val = etm_readl(drvdata, offset);
-		/* Waiting on the bit to go from 0 to 1 */
-		if (value) {
-			if (val & BIT(position))
-				return 0;
-		/* Waiting on the bit to go from 1 to 0 */
-		} else {
-			if (!(val & BIT(position)))
-				return 0;
-		}
-
-		/*
-		 * Delay is arbitrary - the specification doesn't say how long
-		 * we are expected to wait.  Extra check required to make sure
-		 * we don't wait needlessly on the last iteration.
-		 */
-		if (i - 1)
-			udelay(1);
-	}
-
-	return -EAGAIN;
-}
-
-
-static void etm_set_prog(struct etm_drvdata *drvdata)
-{
-	u32 etmcr;
-
-	etmcr = etm_readl(drvdata, ETMCR);
-	etmcr |= ETMCR_ETM_PRG;
-	etm_writel(drvdata, etmcr, ETMCR);
-	/*
-	 * Recommended by spec for cp14 accesses to ensure etmcr write is
-	 * complete before polling etmsr
-	 */
-	isb();
-	if (coresight_timeout_etm(drvdata, ETMSR, ETMSR_PROG_BIT, 1)) {
-		dev_err(drvdata->dev,
-			"timeout observed when probing at offset %#x\n", ETMSR);
-	}
-}
-
-static void etm_clr_prog(struct etm_drvdata *drvdata)
-{
-	u32 etmcr;
-
-	etmcr = etm_readl(drvdata, ETMCR);
-	etmcr &= ~ETMCR_ETM_PRG;
-	etm_writel(drvdata, etmcr, ETMCR);
-	/*
-	 * Recommended by spec for cp14 accesses to ensure etmcr write is
-	 * complete before polling etmsr
-	 */
-	isb();
-	if (coresight_timeout_etm(drvdata, ETMSR, ETMSR_PROG_BIT, 0)) {
-		dev_err(drvdata->dev,
-			"timeout observed when probing at offset %#x\n", ETMSR);
-	}
-}
-
-static void etm_set_default(struct etm_drvdata *drvdata)
-{
-	int i;
-
-	drvdata->trigger_event = ETM_DEFAULT_EVENT_VAL;
-	drvdata->enable_event = ETM_HARD_WIRE_RES_A;
-
-	drvdata->seq_12_event = ETM_DEFAULT_EVENT_VAL;
-	drvdata->seq_21_event = ETM_DEFAULT_EVENT_VAL;
-	drvdata->seq_23_event = ETM_DEFAULT_EVENT_VAL;
-	drvdata->seq_31_event = ETM_DEFAULT_EVENT_VAL;
-	drvdata->seq_32_event = ETM_DEFAULT_EVENT_VAL;
-	drvdata->seq_13_event = ETM_DEFAULT_EVENT_VAL;
-	drvdata->timestamp_event = ETM_DEFAULT_EVENT_VAL;
-
-	for (i = 0; i < drvdata->nr_cntr; i++) {
-		drvdata->cntr_rld_val[i] = 0x0;
-		drvdata->cntr_event[i] = ETM_DEFAULT_EVENT_VAL;
-		drvdata->cntr_rld_event[i] = ETM_DEFAULT_EVENT_VAL;
-		drvdata->cntr_val[i] = 0x0;
-	}
-
-	drvdata->seq_curr_state = 0x0;
-	drvdata->ctxid_idx = 0x0;
-	for (i = 0; i < drvdata->nr_ctxid_cmp; i++)
-		drvdata->ctxid_val[i] = 0x0;
-	drvdata->ctxid_mask = 0x0;
-}
-
-static void etm_enable_hw(void *info)
-{
-	int i;
-	u32 etmcr;
-	struct etm_drvdata *drvdata = info;
-
-	CS_UNLOCK(drvdata->base);
-
-	/* Turn engine on */
-	etm_clr_pwrdwn(drvdata);
-	/* Apply power to trace registers */
-	etm_set_pwrup(drvdata);
-	/* Make sure all registers are accessible */
-	etm_os_unlock(drvdata);
-
-	etm_set_prog(drvdata);
-
-	etmcr = etm_readl(drvdata, ETMCR);
-	etmcr &= (ETMCR_PWD_DWN | ETMCR_ETM_PRG);
-	etmcr |= drvdata->port_size;
-	etm_writel(drvdata, drvdata->ctrl | etmcr, ETMCR);
-	etm_writel(drvdata, drvdata->trigger_event, ETMTRIGGER);
-	etm_writel(drvdata, drvdata->startstop_ctrl, ETMTSSCR);
-	etm_writel(drvdata, drvdata->enable_event, ETMTEEVR);
-	etm_writel(drvdata, drvdata->enable_ctrl1, ETMTECR1);
-	etm_writel(drvdata, drvdata->fifofull_level, ETMFFLR);
-	for (i = 0; i < drvdata->nr_addr_cmp; i++) {
-		etm_writel(drvdata, drvdata->addr_val[i], ETMACVRn(i));
-		etm_writel(drvdata, drvdata->addr_acctype[i], ETMACTRn(i));
-	}
-	for (i = 0; i < drvdata->nr_cntr; i++) {
-		etm_writel(drvdata, drvdata->cntr_rld_val[i], ETMCNTRLDVRn(i));
-		etm_writel(drvdata, drvdata->cntr_event[i], ETMCNTENRn(i));
-		etm_writel(drvdata, drvdata->cntr_rld_event[i],
-			   ETMCNTRLDEVRn(i));
-		etm_writel(drvdata, drvdata->cntr_val[i], ETMCNTVRn(i));
-	}
-	etm_writel(drvdata, drvdata->seq_12_event, ETMSQ12EVR);
-	etm_writel(drvdata, drvdata->seq_21_event, ETMSQ21EVR);
-	etm_writel(drvdata, drvdata->seq_23_event, ETMSQ23EVR);
-	etm_writel(drvdata, drvdata->seq_31_event, ETMSQ31EVR);
-	etm_writel(drvdata, drvdata->seq_32_event, ETMSQ32EVR);
-	etm_writel(drvdata, drvdata->seq_13_event, ETMSQ13EVR);
-	etm_writel(drvdata, drvdata->seq_curr_state, ETMSQR);
-	for (i = 0; i < drvdata->nr_ext_out; i++)
-		etm_writel(drvdata, ETM_DEFAULT_EVENT_VAL, ETMEXTOUTEVRn(i));
-	for (i = 0; i < drvdata->nr_ctxid_cmp; i++)
-		etm_writel(drvdata, drvdata->ctxid_val[i], ETMCIDCVRn(i));
-	etm_writel(drvdata, drvdata->ctxid_mask, ETMCIDCMR);
-	etm_writel(drvdata, drvdata->sync_freq, ETMSYNCFR);
-	/* No external input selected */
-	etm_writel(drvdata, 0x0, ETMEXTINSELR);
-	etm_writel(drvdata, drvdata->timestamp_event, ETMTSEVR);
-	/* No auxiliary control selected */
-	etm_writel(drvdata, 0x0, ETMAUXCR);
-	etm_writel(drvdata, drvdata->traceid, ETMTRACEIDR);
-	/* No VMID comparator value selected */
-	etm_writel(drvdata, 0x0, ETMVMIDCVR);
-
-	/* Ensures trace output is enabled from this ETM */
-	etm_writel(drvdata, drvdata->ctrl | ETMCR_ETM_EN | etmcr, ETMCR);
-
-	etm_clr_prog(drvdata);
-	CS_LOCK(drvdata->base);
-
-	dev_dbg(drvdata->dev, "cpu: %d enable smp call done\n", drvdata->cpu);
-}
-
-static int etm_trace_id_simple(struct etm_drvdata *drvdata)
-{
-	if (!drvdata->enable)
-		return drvdata->traceid;
-
-	return (etm_readl(drvdata, ETMTRACEIDR) & ETM_TRACEID_MASK);
-}
-
-static int etm_trace_id(struct coresight_device *csdev)
-{
-	struct etm_drvdata *drvdata = dev_get_drvdata(csdev->dev.parent);
-	unsigned long flags;
-	int trace_id = -1;
-
-	if (!drvdata->enable)
-		return drvdata->traceid;
-
-	if (clk_prepare_enable(drvdata->clk))
-		goto out;
-
-	spin_lock_irqsave(&drvdata->spinlock, flags);
-
-	CS_UNLOCK(drvdata->base);
-	trace_id = (etm_readl(drvdata, ETMTRACEIDR) & ETM_TRACEID_MASK);
-	CS_LOCK(drvdata->base);
-
-	spin_unlock_irqrestore(&drvdata->spinlock, flags);
-	clk_disable_unprepare(drvdata->clk);
-out:
-	return trace_id;
-}
-
-static int etm_enable(struct coresight_device *csdev)
-{
-	struct etm_drvdata *drvdata = dev_get_drvdata(csdev->dev.parent);
-	int ret;
-
-	ret = clk_prepare_enable(drvdata->clk);
-	if (ret)
-		goto err_clk;
-
-	spin_lock(&drvdata->spinlock);
-
-	/*
-	 * Configure the ETM only if the CPU is online.  If it isn't online
-	 * hw configuration will take place when 'CPU_STARTING' is received
-	 * in @etm_cpu_callback.
-	 */
-	if (cpu_online(drvdata->cpu)) {
-		ret = smp_call_function_single(drvdata->cpu,
-					       etm_enable_hw, drvdata, 1);
-		if (ret)
-			goto err;
-	}
-
-	drvdata->enable = true;
-	drvdata->sticky_enable = true;
-
-	spin_unlock(&drvdata->spinlock);
-
-	dev_info(drvdata->dev, "ETM tracing enabled\n");
-	return 0;
-err:
-	spin_unlock(&drvdata->spinlock);
-	clk_disable_unprepare(drvdata->clk);
-err_clk:
-	return ret;
-}
-
-static void etm_disable_hw(void *info)
-{
-	int i;
-	struct etm_drvdata *drvdata = info;
-
-	CS_UNLOCK(drvdata->base);
-	etm_set_prog(drvdata);
-
-	/* Program trace enable to low by using always false event */
-	etm_writel(drvdata, ETM_HARD_WIRE_RES_A | ETM_EVENT_NOT_A, ETMTEEVR);
-
-	/* Read back sequencer and counters for post trace analysis */
-	drvdata->seq_curr_state = (etm_readl(drvdata, ETMSQR) & ETM_SQR_MASK);
-
-	for (i = 0; i < drvdata->nr_cntr; i++)
-		drvdata->cntr_val[i] = etm_readl(drvdata, ETMCNTVRn(i));
-
-	etm_set_pwrdwn(drvdata);
-	CS_LOCK(drvdata->base);
-
-	dev_dbg(drvdata->dev, "cpu: %d disable smp call done\n", drvdata->cpu);
-}
-
-static void etm_disable(struct coresight_device *csdev)
-{
-	struct etm_drvdata *drvdata = dev_get_drvdata(csdev->dev.parent);
-
-	/*
-	 * Taking hotplug lock here protects from clocks getting disabled
-	 * with tracing being left on (crash scenario) if user disable occurs
-	 * after cpu online mask indicates the cpu is offline but before the
-	 * DYING hotplug callback is serviced by the ETM driver.
-	 */
-	get_online_cpus();
-	spin_lock(&drvdata->spinlock);
-
-	/*
-	 * Executing etm_disable_hw on the cpu whose ETM is being disabled
-	 * ensures that register writes occur when cpu is powered.
-	 */
-	smp_call_function_single(drvdata->cpu, etm_disable_hw, drvdata, 1);
-	drvdata->enable = false;
-
-	spin_unlock(&drvdata->spinlock);
-	put_online_cpus();
-
-	clk_disable_unprepare(drvdata->clk);
-
-	dev_info(drvdata->dev, "ETM tracing disabled\n");
-}
-
-static const struct coresight_ops_source etm_source_ops = {
-	.trace_id	= etm_trace_id,
-	.enable		= etm_enable,
-	.disable	= etm_disable,
-};
-
-static const struct coresight_ops etm_cs_ops = {
-	.source_ops	= &etm_source_ops,
-};
-
-static ssize_t nr_addr_cmp_show(struct device *dev,
-				struct device_attribute *attr, char *buf)
-{
-	unsigned long val;
-	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
-
-	val = drvdata->nr_addr_cmp;
-	return sprintf(buf, "%#lx\n", val);
-}
-static DEVICE_ATTR_RO(nr_addr_cmp);
-
-static ssize_t nr_cntr_show(struct device *dev,
-			    struct device_attribute *attr, char *buf)
-{	unsigned long val;
-	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
-
-	val = drvdata->nr_cntr;
-	return sprintf(buf, "%#lx\n", val);
-}
-static DEVICE_ATTR_RO(nr_cntr);
-
-static ssize_t nr_ctxid_cmp_show(struct device *dev,
-				 struct device_attribute *attr, char *buf)
-{
-	unsigned long val;
-	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
-
-	val = drvdata->nr_ctxid_cmp;
-	return sprintf(buf, "%#lx\n", val);
-}
-static DEVICE_ATTR_RO(nr_ctxid_cmp);
-
-static ssize_t etmsr_show(struct device *dev,
-			  struct device_attribute *attr, char *buf)
-{
-	int ret;
-	unsigned long flags, val;
-	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
-
-	ret = clk_prepare_enable(drvdata->clk);
-	if (ret)
-		return ret;
-
-	spin_lock_irqsave(&drvdata->spinlock, flags);
-	CS_UNLOCK(drvdata->base);
-
-	val = etm_readl(drvdata, ETMSR);
-
-	CS_LOCK(drvdata->base);
-	spin_unlock_irqrestore(&drvdata->spinlock, flags);
-	clk_disable_unprepare(drvdata->clk);
-
-	return sprintf(buf, "%#lx\n", val);
-}
-static DEVICE_ATTR_RO(etmsr);
-
-static ssize_t reset_store(struct device *dev,
-			   struct device_attribute *attr,
-			   const char *buf, size_t size)
-{
-	int i, ret;
-	unsigned long val;
-	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
-
-	ret = kstrtoul(buf, 16, &val);
-	if (ret)
-		return ret;
-
-	if (val) {
-		spin_lock(&drvdata->spinlock);
-		drvdata->mode = ETM_MODE_EXCLUDE;
-		drvdata->ctrl = 0x0;
-		drvdata->trigger_event = ETM_DEFAULT_EVENT_VAL;
-		drvdata->startstop_ctrl = 0x0;
-		drvdata->addr_idx = 0x0;
-		for (i = 0; i < drvdata->nr_addr_cmp; i++) {
-			drvdata->addr_val[i] = 0x0;
-			drvdata->addr_acctype[i] = 0x0;
-			drvdata->addr_type[i] = ETM_ADDR_TYPE_NONE;
-		}
-		drvdata->cntr_idx = 0x0;
-
-		etm_set_default(drvdata);
-		spin_unlock(&drvdata->spinlock);
-	}
-
-	return size;
-}
-static DEVICE_ATTR_WO(reset);
-
-static ssize_t mode_show(struct device *dev,
-			 struct device_attribute *attr, char *buf)
-{
-	unsigned long val;
-	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
-
-	val = drvdata->mode;
-	return sprintf(buf, "%#lx\n", val);
-}
-
-static ssize_t mode_store(struct device *dev,
-			  struct device_attribute *attr,
-			  const char *buf, size_t size)
-{
-	int ret;
-	unsigned long val;
-	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
-
-	ret = kstrtoul(buf, 16, &val);
-	if (ret)
-		return ret;
-
-	spin_lock(&drvdata->spinlock);
-	drvdata->mode = val & ETM_MODE_ALL;
-
-	if (drvdata->mode & ETM_MODE_EXCLUDE)
-		drvdata->enable_ctrl1 |= ETMTECR1_INC_EXC;
-	else
-		drvdata->enable_ctrl1 &= ~ETMTECR1_INC_EXC;
-
-	if (drvdata->mode & ETM_MODE_CYCACC)
-		drvdata->ctrl |= ETMCR_CYC_ACC;
-	else
-		drvdata->ctrl &= ~ETMCR_CYC_ACC;
-
-	if (drvdata->mode & ETM_MODE_STALL) {
-		if (!(drvdata->etmccr & ETMCCR_FIFOFULL)) {
-			dev_warn(drvdata->dev, "stall mode not supported\n");
-			ret = -EINVAL;
-			goto err_unlock;
-		}
-		drvdata->ctrl |= ETMCR_STALL_MODE;
-	 } else
-		drvdata->ctrl &= ~ETMCR_STALL_MODE;
-
-	if (drvdata->mode & ETM_MODE_TIMESTAMP) {
-		if (!(drvdata->etmccer & ETMCCER_TIMESTAMP)) {
-			dev_warn(drvdata->dev, "timestamp not supported\n");
-			ret = -EINVAL;
-			goto err_unlock;
-		}
-		drvdata->ctrl |= ETMCR_TIMESTAMP_EN;
-	} else
-		drvdata->ctrl &= ~ETMCR_TIMESTAMP_EN;
-
-	if (drvdata->mode & ETM_MODE_CTXID)
-		drvdata->ctrl |= ETMCR_CTXID_SIZE;
-	else
-		drvdata->ctrl &= ~ETMCR_CTXID_SIZE;
-	spin_unlock(&drvdata->spinlock);
-
-	return size;
-
-err_unlock:
-	spin_unlock(&drvdata->spinlock);
-	return ret;
-}
-static DEVICE_ATTR_RW(mode);
-
-static ssize_t trigger_event_show(struct device *dev,
-				  struct device_attribute *attr, char *buf)
-{
-	unsigned long val;
-	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
-
-	val = drvdata->trigger_event;
-	return sprintf(buf, "%#lx\n", val);
-}
-
-static ssize_t trigger_event_store(struct device *dev,
-				   struct device_attribute *attr,
-				   const char *buf, size_t size)
-{
-	int ret;
-	unsigned long val;
-	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
-
-	ret = kstrtoul(buf, 16, &val);
-	if (ret)
-		return ret;
-
-	drvdata->trigger_event = val & ETM_EVENT_MASK;
-
-	return size;
-}
-static DEVICE_ATTR_RW(trigger_event);
-
-static ssize_t enable_event_show(struct device *dev,
-				 struct device_attribute *attr, char *buf)
-{
-	unsigned long val;
-	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
-
-	val = drvdata->enable_event;
-	return sprintf(buf, "%#lx\n", val);
-}
-
-static ssize_t enable_event_store(struct device *dev,
-				  struct device_attribute *attr,
-				  const char *buf, size_t size)
-{
-	int ret;
-	unsigned long val;
-	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
-
-	ret = kstrtoul(buf, 16, &val);
-	if (ret)
-		return ret;
-
-	drvdata->enable_event = val & ETM_EVENT_MASK;
-
-	return size;
-}
-static DEVICE_ATTR_RW(enable_event);
-
-static ssize_t fifofull_level_show(struct device *dev,
-				   struct device_attribute *attr, char *buf)
-{
-	unsigned long val;
-	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
-
-	val = drvdata->fifofull_level;
-	return sprintf(buf, "%#lx\n", val);
-}
-
-static ssize_t fifofull_level_store(struct device *dev,
-				    struct device_attribute *attr,
-				    const char *buf, size_t size)
-{
-	int ret;
-	unsigned long val;
-	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
-
-	ret = kstrtoul(buf, 16, &val);
-	if (ret)
-		return ret;
-
-	drvdata->fifofull_level = val;
-
-	return size;
-}
-static DEVICE_ATTR_RW(fifofull_level);
-
-static ssize_t addr_idx_show(struct device *dev,
-			     struct device_attribute *attr, char *buf)
-{
-	unsigned long val;
-	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
-
-	val = drvdata->addr_idx;
-	return sprintf(buf, "%#lx\n", val);
-}
-
-static ssize_t addr_idx_store(struct device *dev,
-			      struct device_attribute *attr,
-			      const char *buf, size_t size)
-{
-	int ret;
-	unsigned long val;
-	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
-
-	ret = kstrtoul(buf, 16, &val);
-	if (ret)
-		return ret;
-
-	if (val >= drvdata->nr_addr_cmp)
-		return -EINVAL;
-
-	/*
-	 * Use spinlock to ensure index doesn't change while it gets
-	 * dereferenced multiple times within a spinlock block elsewhere.
-	 */
-	spin_lock(&drvdata->spinlock);
-	drvdata->addr_idx = val;
-	spin_unlock(&drvdata->spinlock);
-
-	return size;
-}
-static DEVICE_ATTR_RW(addr_idx);
-
-static ssize_t addr_single_show(struct device *dev,
-				struct device_attribute *attr, char *buf)
-{
-	u8 idx;
-	unsigned long val;
-	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
-
-	spin_lock(&drvdata->spinlock);
-	idx = drvdata->addr_idx;
-	if (!(drvdata->addr_type[idx] == ETM_ADDR_TYPE_NONE ||
-	      drvdata->addr_type[idx] == ETM_ADDR_TYPE_SINGLE)) {
-		spin_unlock(&drvdata->spinlock);
-		return -EINVAL;
-	}
-
-	val = drvdata->addr_val[idx];
-	spin_unlock(&drvdata->spinlock);
-
-	return sprintf(buf, "%#lx\n", val);
-}
-
-static ssize_t addr_single_store(struct device *dev,
-				 struct device_attribute *attr,
-				 const char *buf, size_t size)
-{
-	u8 idx;
-	int ret;
-	unsigned long val;
-	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
-
-	ret = kstrtoul(buf, 16, &val);
-	if (ret)
-		return ret;
-
-	spin_lock(&drvdata->spinlock);
-	idx = drvdata->addr_idx;
-	if (!(drvdata->addr_type[idx] == ETM_ADDR_TYPE_NONE ||
-	      drvdata->addr_type[idx] == ETM_ADDR_TYPE_SINGLE)) {
-		spin_unlock(&drvdata->spinlock);
-		return -EINVAL;
-	}
-
-	drvdata->addr_val[idx] = val;
-	drvdata->addr_type[idx] = ETM_ADDR_TYPE_SINGLE;
-	spin_unlock(&drvdata->spinlock);
-
-	return size;
-}
-static DEVICE_ATTR_RW(addr_single);
-
-static ssize_t addr_range_show(struct device *dev,
-			       struct device_attribute *attr, char *buf)
-{
-	u8 idx;
-	unsigned long val1, val2;
-	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
-
-	spin_lock(&drvdata->spinlock);
-	idx = drvdata->addr_idx;
-	if (idx % 2 != 0) {
-		spin_unlock(&drvdata->spinlock);
-		return -EPERM;
-	}
-	if (!((drvdata->addr_type[idx] == ETM_ADDR_TYPE_NONE &&
-	       drvdata->addr_type[idx + 1] == ETM_ADDR_TYPE_NONE) ||
-	      (drvdata->addr_type[idx] == ETM_ADDR_TYPE_RANGE &&
-	       drvdata->addr_type[idx + 1] == ETM_ADDR_TYPE_RANGE))) {
-		spin_unlock(&drvdata->spinlock);
-		return -EPERM;
-	}
-
-	val1 = drvdata->addr_val[idx];
-	val2 = drvdata->addr_val[idx + 1];
-	spin_unlock(&drvdata->spinlock);
-
-	return sprintf(buf, "%#lx %#lx\n", val1, val2);
-}
-
-static ssize_t addr_range_store(struct device *dev,
-			      struct device_attribute *attr,
-			      const char *buf, size_t size)
-{
-	u8 idx;
-	unsigned long val1, val2;
-	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
-
-	if (sscanf(buf, "%lx %lx", &val1, &val2) != 2)
-		return -EINVAL;
-	/* Lower address comparator cannot have a higher address value */
-	if (val1 > val2)
-		return -EINVAL;
-
-	spin_lock(&drvdata->spinlock);
-	idx = drvdata->addr_idx;
-	if (idx % 2 != 0) {
-		spin_unlock(&drvdata->spinlock);
-		return -EPERM;
-	}
-	if (!((drvdata->addr_type[idx] == ETM_ADDR_TYPE_NONE &&
-	       drvdata->addr_type[idx + 1] == ETM_ADDR_TYPE_NONE) ||
-	      (drvdata->addr_type[idx] == ETM_ADDR_TYPE_RANGE &&
-	       drvdata->addr_type[idx + 1] == ETM_ADDR_TYPE_RANGE))) {
-		spin_unlock(&drvdata->spinlock);
-		return -EPERM;
-	}
-
-	drvdata->addr_val[idx] = val1;
-	drvdata->addr_type[idx] = ETM_ADDR_TYPE_RANGE;
-	drvdata->addr_val[idx + 1] = val2;
-	drvdata->addr_type[idx + 1] = ETM_ADDR_TYPE_RANGE;
-	drvdata->enable_ctrl1 |= (1 << (idx/2));
-	spin_unlock(&drvdata->spinlock);
-
-	return size;
-}
-static DEVICE_ATTR_RW(addr_range);
-
-static ssize_t addr_start_show(struct device *dev,
-			       struct device_attribute *attr, char *buf)
-{
-	u8 idx;
-	unsigned long val;
-	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
-
-	spin_lock(&drvdata->spinlock);
-	idx = drvdata->addr_idx;
-	if (!(drvdata->addr_type[idx] == ETM_ADDR_TYPE_NONE ||
-	      drvdata->addr_type[idx] == ETM_ADDR_TYPE_START)) {
-		spin_unlock(&drvdata->spinlock);
-		return -EPERM;
-	}
-
-	val = drvdata->addr_val[idx];
-	spin_unlock(&drvdata->spinlock);
-
-	return sprintf(buf, "%#lx\n", val);
-}
-
-static ssize_t addr_start_store(struct device *dev,
-				struct device_attribute *attr,
-				const char *buf, size_t size)
-{
-	u8 idx;
-	int ret;
-	unsigned long val;
-	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
-
-	ret = kstrtoul(buf, 16, &val);
-	if (ret)
-		return ret;
-
-	spin_lock(&drvdata->spinlock);
-	idx = drvdata->addr_idx;
-	if (!(drvdata->addr_type[idx] == ETM_ADDR_TYPE_NONE ||
-	      drvdata->addr_type[idx] == ETM_ADDR_TYPE_START)) {
-		spin_unlock(&drvdata->spinlock);
-		return -EPERM;
-	}
-
-	drvdata->addr_val[idx] = val;
-	drvdata->addr_type[idx] = ETM_ADDR_TYPE_START;
-	drvdata->startstop_ctrl |= (1 << idx);
-	drvdata->enable_ctrl1 |= BIT(25);
-	spin_unlock(&drvdata->spinlock);
-
-	return size;
-}
-static DEVICE_ATTR_RW(addr_start);
-
-static ssize_t addr_stop_show(struct device *dev,
-			      struct device_attribute *attr, char *buf)
-{
-	u8 idx;
-	unsigned long val;
-	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
-
-	spin_lock(&drvdata->spinlock);
-	idx = drvdata->addr_idx;
-	if (!(drvdata->addr_type[idx] == ETM_ADDR_TYPE_NONE ||
-	      drvdata->addr_type[idx] == ETM_ADDR_TYPE_STOP)) {
-		spin_unlock(&drvdata->spinlock);
-		return -EPERM;
-	}
-
-	val = drvdata->addr_val[idx];
-	spin_unlock(&drvdata->spinlock);
-
-	return sprintf(buf, "%#lx\n", val);
-}
-
-static ssize_t addr_stop_store(struct device *dev,
-			       struct device_attribute *attr,
-			       const char *buf, size_t size)
-{
-	u8 idx;
-	int ret;
-	unsigned long val;
-	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
-
-	ret = kstrtoul(buf, 16, &val);
-	if (ret)
-		return ret;
-
-	spin_lock(&drvdata->spinlock);
-	idx = drvdata->addr_idx;
-	if (!(drvdata->addr_type[idx] == ETM_ADDR_TYPE_NONE ||
-	      drvdata->addr_type[idx] == ETM_ADDR_TYPE_STOP)) {
-		spin_unlock(&drvdata->spinlock);
-		return -EPERM;
-	}
-
-	drvdata->addr_val[idx] = val;
-	drvdata->addr_type[idx] = ETM_ADDR_TYPE_STOP;
-	drvdata->startstop_ctrl |= (1 << (idx + 16));
-	drvdata->enable_ctrl1 |= ETMTECR1_START_STOP;
-	spin_unlock(&drvdata->spinlock);
-
-	return size;
-}
-static DEVICE_ATTR_RW(addr_stop);
-
-static ssize_t addr_acctype_show(struct device *dev,
-				 struct device_attribute *attr, char *buf)
-{
-	unsigned long val;
-	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
-
-	spin_lock(&drvdata->spinlock);
-	val = drvdata->addr_acctype[drvdata->addr_idx];
-	spin_unlock(&drvdata->spinlock);
-
-	return sprintf(buf, "%#lx\n", val);
-}
-
-static ssize_t addr_acctype_store(struct device *dev,
-				  struct device_attribute *attr,
-				  const char *buf, size_t size)
-{
-	int ret;
-	unsigned long val;
-	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
-
-	ret = kstrtoul(buf, 16, &val);
-	if (ret)
-		return ret;
-
-	spin_lock(&drvdata->spinlock);
-	drvdata->addr_acctype[drvdata->addr_idx] = val;
-	spin_unlock(&drvdata->spinlock);
-
-	return size;
-}
-static DEVICE_ATTR_RW(addr_acctype);
-
-static ssize_t cntr_idx_show(struct device *dev,
-			     struct device_attribute *attr, char *buf)
-{
-	unsigned long val;
-	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
-
-	val = drvdata->cntr_idx;
-	return sprintf(buf, "%#lx\n", val);
-}
-
-static ssize_t cntr_idx_store(struct device *dev,
-			      struct device_attribute *attr,
-			      const char *buf, size_t size)
-{
-	int ret;
-	unsigned long val;
-	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
-
-	ret = kstrtoul(buf, 16, &val);
-	if (ret)
-		return ret;
-
-	if (val >= drvdata->nr_cntr)
-		return -EINVAL;
-	/*
-	 * Use spinlock to ensure index doesn't change while it gets
-	 * dereferenced multiple times within a spinlock block elsewhere.
-	 */
-	spin_lock(&drvdata->spinlock);
-	drvdata->cntr_idx = val;
-	spin_unlock(&drvdata->spinlock);
-
-	return size;
-}
-static DEVICE_ATTR_RW(cntr_idx);
-
-static ssize_t cntr_rld_val_show(struct device *dev,
-				 struct device_attribute *attr, char *buf)
-{
-	unsigned long val;
-	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
-
-	spin_lock(&drvdata->spinlock);
-	val = drvdata->cntr_rld_val[drvdata->cntr_idx];
-	spin_unlock(&drvdata->spinlock);
-
-	return sprintf(buf, "%#lx\n", val);
-}
-
-static ssize_t cntr_rld_val_store(struct device *dev,
-				  struct device_attribute *attr,
-				  const char *buf, size_t size)
-{
-	int ret;
-	unsigned long val;
-	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
-
-	ret = kstrtoul(buf, 16, &val);
-	if (ret)
-		return ret;
-
-	spin_lock(&drvdata->spinlock);
-	drvdata->cntr_rld_val[drvdata->cntr_idx] = val;
-	spin_unlock(&drvdata->spinlock);
-
-	return size;
-}
-static DEVICE_ATTR_RW(cntr_rld_val);
-
-static ssize_t cntr_event_show(struct device *dev,
-			       struct device_attribute *attr, char *buf)
-{
-	unsigned long val;
-	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
-
-	spin_lock(&drvdata->spinlock);
-	val = drvdata->cntr_event[drvdata->cntr_idx];
-	spin_unlock(&drvdata->spinlock);
-
-	return sprintf(buf, "%#lx\n", val);
-}
-
-static ssize_t cntr_event_store(struct device *dev,
-				struct device_attribute *attr,
-				const char *buf, size_t size)
-{
-	int ret;
-	unsigned long val;
-	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
-
-	ret = kstrtoul(buf, 16, &val);
-	if (ret)
-		return ret;
-
-	spin_lock(&drvdata->spinlock);
-	drvdata->cntr_event[drvdata->cntr_idx] = val & ETM_EVENT_MASK;
-	spin_unlock(&drvdata->spinlock);
-
-	return size;
-}
-static DEVICE_ATTR_RW(cntr_event);
-
-static ssize_t cntr_rld_event_show(struct device *dev,
-				   struct device_attribute *attr, char *buf)
-{
-	unsigned long val;
-	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
-
-	spin_lock(&drvdata->spinlock);
-	val = drvdata->cntr_rld_event[drvdata->cntr_idx];
-	spin_unlock(&drvdata->spinlock);
-
-	return sprintf(buf, "%#lx\n", val);
-}
-
-static ssize_t cntr_rld_event_store(struct device *dev,
-				    struct device_attribute *attr,
-				    const char *buf, size_t size)
-{
-	int ret;
-	unsigned long val;
-	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
-
-	ret = kstrtoul(buf, 16, &val);
-	if (ret)
-		return ret;
-
-	spin_lock(&drvdata->spinlock);
-	drvdata->cntr_rld_event[drvdata->cntr_idx] = val & ETM_EVENT_MASK;
-	spin_unlock(&drvdata->spinlock);
-
-	return size;
-}
-static DEVICE_ATTR_RW(cntr_rld_event);
-
-static ssize_t cntr_val_show(struct device *dev,
-			     struct device_attribute *attr, char *buf)
-{
-	int i, ret = 0;
-	u32 val;
-	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
-
-	if (!drvdata->enable) {
-		spin_lock(&drvdata->spinlock);
-		for (i = 0; i < drvdata->nr_cntr; i++)
-			ret += sprintf(buf, "counter %d: %x\n",
-				       i, drvdata->cntr_val[i]);
-		spin_unlock(&drvdata->spinlock);
-		return ret;
-	}
-
-	for (i = 0; i < drvdata->nr_cntr; i++) {
-		val = etm_readl(drvdata, ETMCNTVRn(i));
-		ret += sprintf(buf, "counter %d: %x\n", i, val);
-	}
-
-	return ret;
-}
-
-static ssize_t cntr_val_store(struct device *dev,
-			      struct device_attribute *attr,
-			      const char *buf, size_t size)
-{
-	int ret;
-	unsigned long val;
-	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
-
-	ret = kstrtoul(buf, 16, &val);
-	if (ret)
-		return ret;
-
-	spin_lock(&drvdata->spinlock);
-	drvdata->cntr_val[drvdata->cntr_idx] = val;
-	spin_unlock(&drvdata->spinlock);
-
-	return size;
-}
-static DEVICE_ATTR_RW(cntr_val);
-
-static ssize_t seq_12_event_show(struct device *dev,
-				 struct device_attribute *attr, char *buf)
-{
-	unsigned long val;
-	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
-
-	val = drvdata->seq_12_event;
-	return sprintf(buf, "%#lx\n", val);
-}
-
-static ssize_t seq_12_event_store(struct device *dev,
-				  struct device_attribute *attr,
-				  const char *buf, size_t size)
-{
-	int ret;
-	unsigned long val;
-	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
-
-	ret = kstrtoul(buf, 16, &val);
-	if (ret)
-		return ret;
-
-	drvdata->seq_12_event = val & ETM_EVENT_MASK;
-	return size;
-}
-static DEVICE_ATTR_RW(seq_12_event);
-
-static ssize_t seq_21_event_show(struct device *dev,
-				 struct device_attribute *attr, char *buf)
-{
-	unsigned long val;
-	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
-
-	val = drvdata->seq_21_event;
-	return sprintf(buf, "%#lx\n", val);
-}
-
-static ssize_t seq_21_event_store(struct device *dev,
-				  struct device_attribute *attr,
-				  const char *buf, size_t size)
-{
-	int ret;
-	unsigned long val;
-	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
-
-	ret = kstrtoul(buf, 16, &val);
-	if (ret)
-		return ret;
-
-	drvdata->seq_21_event = val & ETM_EVENT_MASK;
-	return size;
-}
-static DEVICE_ATTR_RW(seq_21_event);
-
-static ssize_t seq_23_event_show(struct device *dev,
-				 struct device_attribute *attr, char *buf)
-{
-	unsigned long val;
-	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
-
-	val = drvdata->seq_23_event;
-	return sprintf(buf, "%#lx\n", val);
-}
-
-static ssize_t seq_23_event_store(struct device *dev,
-				  struct device_attribute *attr,
-				  const char *buf, size_t size)
-{
-	int ret;
-	unsigned long val;
-	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
-
-	ret = kstrtoul(buf, 16, &val);
-	if (ret)
-		return ret;
-
-	drvdata->seq_23_event = val & ETM_EVENT_MASK;
-	return size;
-}
-static DEVICE_ATTR_RW(seq_23_event);
-
-static ssize_t seq_31_event_show(struct device *dev,
-				 struct device_attribute *attr, char *buf)
-{
-	unsigned long val;
-	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
-
-	val = drvdata->seq_31_event;
-	return sprintf(buf, "%#lx\n", val);
-}
-
-static ssize_t seq_31_event_store(struct device *dev,
-				  struct device_attribute *attr,
-				  const char *buf, size_t size)
-{
-	int ret;
-	unsigned long val;
-	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
-
-	ret = kstrtoul(buf, 16, &val);
-	if (ret)
-		return ret;
-
-	drvdata->seq_31_event = val & ETM_EVENT_MASK;
-	return size;
-}
-static DEVICE_ATTR_RW(seq_31_event);
-
-static ssize_t seq_32_event_show(struct device *dev,
-				 struct device_attribute *attr, char *buf)
-{
-	unsigned long val;
-	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
-
-	val = drvdata->seq_32_event;
-	return sprintf(buf, "%#lx\n", val);
-}
-
-static ssize_t seq_32_event_store(struct device *dev,
-				  struct device_attribute *attr,
-				  const char *buf, size_t size)
-{
-	int ret;
-	unsigned long val;
-	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
-
-	ret = kstrtoul(buf, 16, &val);
-	if (ret)
-		return ret;
-
-	drvdata->seq_32_event = val & ETM_EVENT_MASK;
-	return size;
-}
-static DEVICE_ATTR_RW(seq_32_event);
-
-static ssize_t seq_13_event_show(struct device *dev,
-				 struct device_attribute *attr, char *buf)
-{
-	unsigned long val;
-	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
-
-	val = drvdata->seq_13_event;
-	return sprintf(buf, "%#lx\n", val);
-}
-
-static ssize_t seq_13_event_store(struct device *dev,
-				  struct device_attribute *attr,
-				  const char *buf, size_t size)
-{
-	int ret;
-	unsigned long val;
-	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
-
-	ret = kstrtoul(buf, 16, &val);
-	if (ret)
-		return ret;
-
-	drvdata->seq_13_event = val & ETM_EVENT_MASK;
-	return size;
-}
-static DEVICE_ATTR_RW(seq_13_event);
-
-static ssize_t seq_curr_state_show(struct device *dev,
-				   struct device_attribute *attr, char *buf)
-{
-	int ret;
-	unsigned long val, flags;
-	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
-
-	if (!drvdata->enable) {
-		val = drvdata->seq_curr_state;
-		goto out;
-	}
-
-	ret = clk_prepare_enable(drvdata->clk);
-	if (ret)
-		return ret;
-
-	spin_lock_irqsave(&drvdata->spinlock, flags);
-
-	CS_UNLOCK(drvdata->base);
-	val = (etm_readl(drvdata, ETMSQR) & ETM_SQR_MASK);
-	CS_LOCK(drvdata->base);
-
-	spin_unlock_irqrestore(&drvdata->spinlock, flags);
-	clk_disable_unprepare(drvdata->clk);
-out:
-	return sprintf(buf, "%#lx\n", val);
-}
-
-static ssize_t seq_curr_state_store(struct device *dev,
-				    struct device_attribute *attr,
-				    const char *buf, size_t size)
-{
-	int ret;
-	unsigned long val;
-	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
-
-	ret = kstrtoul(buf, 16, &val);
-	if (ret)
-		return ret;
-
-	if (val > ETM_SEQ_STATE_MAX_VAL)
-		return -EINVAL;
-
-	drvdata->seq_curr_state = val;
-
-	return size;
-}
-static DEVICE_ATTR_RW(seq_curr_state);
-
-static ssize_t ctxid_idx_show(struct device *dev,
-			      struct device_attribute *attr, char *buf)
-{
-	unsigned long val;
-	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
-
-	val = drvdata->ctxid_idx;
-	return sprintf(buf, "%#lx\n", val);
-}
-
-static ssize_t ctxid_idx_store(struct device *dev,
-				struct device_attribute *attr,
-				const char *buf, size_t size)
-{
-	int ret;
-	unsigned long val;
-	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
-
-	ret = kstrtoul(buf, 16, &val);
-	if (ret)
-		return ret;
-
-	if (val >= drvdata->nr_ctxid_cmp)
-		return -EINVAL;
-
-	/*
-	 * Use spinlock to ensure index doesn't change while it gets
-	 * dereferenced multiple times within a spinlock block elsewhere.
-	 */
-	spin_lock(&drvdata->spinlock);
-	drvdata->ctxid_idx = val;
-	spin_unlock(&drvdata->spinlock);
-
-	return size;
-}
-static DEVICE_ATTR_RW(ctxid_idx);
-
-static ssize_t ctxid_val_show(struct device *dev,
-			      struct device_attribute *attr, char *buf)
-{
-	unsigned long val;
-	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
-
-	spin_lock(&drvdata->spinlock);
-	val = drvdata->ctxid_val[drvdata->ctxid_idx];
-	spin_unlock(&drvdata->spinlock);
-
-	return sprintf(buf, "%#lx\n", val);
-}
-
-static ssize_t ctxid_val_store(struct device *dev,
-			       struct device_attribute *attr,
-			       const char *buf, size_t size)
-{
-	int ret;
-	unsigned long val;
-	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
-
-	ret = kstrtoul(buf, 16, &val);
-	if (ret)
-		return ret;
-
-	spin_lock(&drvdata->spinlock);
-	drvdata->ctxid_val[drvdata->ctxid_idx] = val;
-	spin_unlock(&drvdata->spinlock);
-
-	return size;
-}
-static DEVICE_ATTR_RW(ctxid_val);
-
-static ssize_t ctxid_mask_show(struct device *dev,
-			       struct device_attribute *attr, char *buf)
-{
-	unsigned long val;
-	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
-
-	val = drvdata->ctxid_mask;
-	return sprintf(buf, "%#lx\n", val);
-}
-
-static ssize_t ctxid_mask_store(struct device *dev,
-				struct device_attribute *attr,
-				const char *buf, size_t size)
-{
-	int ret;
-	unsigned long val;
-	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
-
-	ret = kstrtoul(buf, 16, &val);
-	if (ret)
-		return ret;
-
-	drvdata->ctxid_mask = val;
-	return size;
-}
-static DEVICE_ATTR_RW(ctxid_mask);
-
-static ssize_t sync_freq_show(struct device *dev,
-			      struct device_attribute *attr, char *buf)
-{
-	unsigned long val;
-	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
-
-	val = drvdata->sync_freq;
-	return sprintf(buf, "%#lx\n", val);
-}
-
-static ssize_t sync_freq_store(struct device *dev,
-			       struct device_attribute *attr,
-			       const char *buf, size_t size)
-{
-	int ret;
-	unsigned long val;
-	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
-
-	ret = kstrtoul(buf, 16, &val);
-	if (ret)
-		return ret;
-
-	drvdata->sync_freq = val & ETM_SYNC_MASK;
-	return size;
-}
-static DEVICE_ATTR_RW(sync_freq);
-
-static ssize_t timestamp_event_show(struct device *dev,
-				    struct device_attribute *attr, char *buf)
-{
-	unsigned long val;
-	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
-
-	val = drvdata->timestamp_event;
-	return sprintf(buf, "%#lx\n", val);
-}
-
-static ssize_t timestamp_event_store(struct device *dev,
-				     struct device_attribute *attr,
-				     const char *buf, size_t size)
-{
-	int ret;
-	unsigned long val;
-	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
-
-	ret = kstrtoul(buf, 16, &val);
-	if (ret)
-		return ret;
-
-	drvdata->timestamp_event = val & ETM_EVENT_MASK;
-	return size;
-}
-static DEVICE_ATTR_RW(timestamp_event);
-
-static ssize_t status_show(struct device *dev,
-			   struct device_attribute *attr, char *buf)
-{
-	int ret;
-	unsigned long flags;
-	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
-
-	ret = clk_prepare_enable(drvdata->clk);
-	if (ret)
-		return ret;
-
-	spin_lock_irqsave(&drvdata->spinlock, flags);
-
-	CS_UNLOCK(drvdata->base);
-	ret = sprintf(buf,
-		      "ETMCCR: 0x%08x\n"
-		      "ETMCCER: 0x%08x\n"
-		      "ETMSCR: 0x%08x\n"
-		      "ETMIDR: 0x%08x\n"
-		      "ETMCR: 0x%08x\n"
-		      "ETMTRACEIDR: 0x%08x\n"
-		      "Enable event: 0x%08x\n"
-		      "Enable start/stop: 0x%08x\n"
-		      "Enable control: CR1 0x%08x CR2 0x%08x\n"
-		      "CPU affinity: %d\n",
-		      drvdata->etmccr, drvdata->etmccer,
-		      etm_readl(drvdata, ETMSCR), etm_readl(drvdata, ETMIDR),
-		      etm_readl(drvdata, ETMCR), etm_trace_id_simple(drvdata),
-		      etm_readl(drvdata, ETMTEEVR),
-		      etm_readl(drvdata, ETMTSSCR),
-		      etm_readl(drvdata, ETMTECR1),
-		      etm_readl(drvdata, ETMTECR2),
-		      drvdata->cpu);
-	CS_LOCK(drvdata->base);
-
-	spin_unlock_irqrestore(&drvdata->spinlock, flags);
-	clk_disable_unprepare(drvdata->clk);
-
-	return ret;
-}
-static DEVICE_ATTR_RO(status);
-
-static ssize_t traceid_show(struct device *dev,
-			    struct device_attribute *attr, char *buf)
-{
-	int ret;
-	unsigned long val, flags;
-	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
-
-	if (!drvdata->enable) {
-		val = drvdata->traceid;
-		goto out;
-	}
-
-	ret = clk_prepare_enable(drvdata->clk);
-	if (ret)
-		return ret;
-
-	spin_lock_irqsave(&drvdata->spinlock, flags);
-	CS_UNLOCK(drvdata->base);
-
-	val = (etm_readl(drvdata, ETMTRACEIDR) & ETM_TRACEID_MASK);
-
-	CS_LOCK(drvdata->base);
-	spin_unlock_irqrestore(&drvdata->spinlock, flags);
-	clk_disable_unprepare(drvdata->clk);
-out:
-	return sprintf(buf, "%#lx\n", val);
-}
-
-static ssize_t traceid_store(struct device *dev,
-			     struct device_attribute *attr,
-			     const char *buf, size_t size)
-{
-	int ret;
-	unsigned long val;
-	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
-
-	ret = kstrtoul(buf, 16, &val);
-	if (ret)
-		return ret;
-
-	drvdata->traceid = val & ETM_TRACEID_MASK;
-	return size;
-}
-static DEVICE_ATTR_RW(traceid);
-
-static struct attribute *coresight_etm_attrs[] = {
-	&dev_attr_nr_addr_cmp.attr,
-	&dev_attr_nr_cntr.attr,
-	&dev_attr_nr_ctxid_cmp.attr,
-	&dev_attr_etmsr.attr,
-	&dev_attr_reset.attr,
-	&dev_attr_mode.attr,
-	&dev_attr_trigger_event.attr,
-	&dev_attr_enable_event.attr,
-	&dev_attr_fifofull_level.attr,
-	&dev_attr_addr_idx.attr,
-	&dev_attr_addr_single.attr,
-	&dev_attr_addr_range.attr,
-	&dev_attr_addr_start.attr,
-	&dev_attr_addr_stop.attr,
-	&dev_attr_addr_acctype.attr,
-	&dev_attr_cntr_idx.attr,
-	&dev_attr_cntr_rld_val.attr,
-	&dev_attr_cntr_event.attr,
-	&dev_attr_cntr_rld_event.attr,
-	&dev_attr_cntr_val.attr,
-	&dev_attr_seq_12_event.attr,
-	&dev_attr_seq_21_event.attr,
-	&dev_attr_seq_23_event.attr,
-	&dev_attr_seq_31_event.attr,
-	&dev_attr_seq_32_event.attr,
-	&dev_attr_seq_13_event.attr,
-	&dev_attr_seq_curr_state.attr,
-	&dev_attr_ctxid_idx.attr,
-	&dev_attr_ctxid_val.attr,
-	&dev_attr_ctxid_mask.attr,
-	&dev_attr_sync_freq.attr,
-	&dev_attr_timestamp_event.attr,
-	&dev_attr_status.attr,
-	&dev_attr_traceid.attr,
-	NULL,
-};
-ATTRIBUTE_GROUPS(coresight_etm);
-
-static int etm_cpu_callback(struct notifier_block *nfb, unsigned long action,
-			    void *hcpu)
-{
-	unsigned int cpu = (unsigned long)hcpu;
-
-	if (!etmdrvdata[cpu])
-		goto out;
-
-	switch (action & (~CPU_TASKS_FROZEN)) {
-	case CPU_STARTING:
-		spin_lock(&etmdrvdata[cpu]->spinlock);
-		if (!etmdrvdata[cpu]->os_unlock) {
-			etm_os_unlock(etmdrvdata[cpu]);
-			etmdrvdata[cpu]->os_unlock = true;
-		}
-
-		if (etmdrvdata[cpu]->enable)
-			etm_enable_hw(etmdrvdata[cpu]);
-		spin_unlock(&etmdrvdata[cpu]->spinlock);
-		break;
-
-	case CPU_ONLINE:
-		if (etmdrvdata[cpu]->boot_enable &&
-		    !etmdrvdata[cpu]->sticky_enable)
-			coresight_enable(etmdrvdata[cpu]->csdev);
-		break;
-
-	case CPU_DYING:
-		spin_lock(&etmdrvdata[cpu]->spinlock);
-		if (etmdrvdata[cpu]->enable)
-			etm_disable_hw(etmdrvdata[cpu]);
-		spin_unlock(&etmdrvdata[cpu]->spinlock);
-		break;
-	}
-out:
-	return NOTIFY_OK;
-}
-
-static struct notifier_block etm_cpu_notifier = {
-	.notifier_call = etm_cpu_callback,
-};
-
-static bool etm_arch_supported(u8 arch)
-{
-	switch (arch) {
-	case ETM_ARCH_V3_3:
-		break;
-	case ETM_ARCH_V3_5:
-		break;
-	case PFT_ARCH_V1_0:
-		break;
-	case PFT_ARCH_V1_1:
-		break;
-	default:
-		return false;
-	}
-	return true;
-}
-
-static void etm_init_arch_data(void *info)
-{
-	u32 etmidr;
-	u32 etmccr;
-	struct etm_drvdata *drvdata = info;
-
-	CS_UNLOCK(drvdata->base);
-
-	/* First dummy read */
-	(void)etm_readl(drvdata, ETMPDSR);
-	/* Provide power to ETM: ETMPDCR[3] == 1 */
-	etm_set_pwrup(drvdata);
-	/*
-	 * Clear power down bit since when this bit is set writes to
-	 * certain registers might be ignored.
-	 */
-	etm_clr_pwrdwn(drvdata);
-	/*
-	 * Set prog bit. It will be set from reset but this is included to
-	 * ensure it is set
-	 */
-	etm_set_prog(drvdata);
-
-	/* Find all capabilities */
-	etmidr = etm_readl(drvdata, ETMIDR);
-	drvdata->arch = BMVAL(etmidr, 4, 11);
-	drvdata->port_size = etm_readl(drvdata, ETMCR) & PORT_SIZE_MASK;
-
-	drvdata->etmccer = etm_readl(drvdata, ETMCCER);
-	etmccr = etm_readl(drvdata, ETMCCR);
-	drvdata->etmccr = etmccr;
-	drvdata->nr_addr_cmp = BMVAL(etmccr, 0, 3) * 2;
-	drvdata->nr_cntr = BMVAL(etmccr, 13, 15);
-	drvdata->nr_ext_inp = BMVAL(etmccr, 17, 19);
-	drvdata->nr_ext_out = BMVAL(etmccr, 20, 22);
-	drvdata->nr_ctxid_cmp = BMVAL(etmccr, 24, 25);
-
-	etm_set_pwrdwn(drvdata);
-	etm_clr_pwrup(drvdata);
-	CS_LOCK(drvdata->base);
-}
-
-static void etm_init_default_data(struct etm_drvdata *drvdata)
-{
-	/*
-	 * A trace ID of value 0 is invalid, so let's start at some
-	 * random value that fits in 7 bits and will be just as good.
-	 */
-	static int etm3x_traceid = 0x10;
-
-	u32 flags = (1 << 0 | /* instruction execute*/
-		     3 << 3 | /* ARM instruction */
-		     0 << 5 | /* No data value comparison */
-		     0 << 7 | /* No exact mach */
-		     0 << 8 | /* Ignore context ID */
-		     0 << 10); /* Security ignored */
-
-	/*
-	 * Initial configuration only - guarantees sources handled by
-	 * this driver have a unique ID at startup time but not between
-	 * all other types of sources.  For that we lean on the core
-	 * framework.
-	 */
-	drvdata->traceid = etm3x_traceid++;
-	drvdata->ctrl = (ETMCR_CYC_ACC | ETMCR_TIMESTAMP_EN);
-	drvdata->enable_ctrl1 = ETMTECR1_ADDR_COMP_1;
-	if (drvdata->nr_addr_cmp >= 2) {
-		drvdata->addr_val[0] = (u32) _stext;
-		drvdata->addr_val[1] = (u32) _etext;
-		drvdata->addr_acctype[0] = flags;
-		drvdata->addr_acctype[1] = flags;
-		drvdata->addr_type[0] = ETM_ADDR_TYPE_RANGE;
-		drvdata->addr_type[1] = ETM_ADDR_TYPE_RANGE;
-	}
-
-	etm_set_default(drvdata);
-}
-
-static int etm_probe(struct amba_device *adev, const struct amba_id *id)
-{
-	int ret;
-	void __iomem *base;
-	struct device *dev = &adev->dev;
-	struct coresight_platform_data *pdata = NULL;
-	struct etm_drvdata *drvdata;
-	struct resource *res = &adev->res;
-	struct coresight_desc *desc;
-	struct device_node *np = adev->dev.of_node;
-
-	desc = devm_kzalloc(dev, sizeof(*desc), GFP_KERNEL);
-	if (!desc)
-		return -ENOMEM;
-
-	drvdata = devm_kzalloc(dev, sizeof(*drvdata), GFP_KERNEL);
-	if (!drvdata)
-		return -ENOMEM;
-
-	if (np) {
-		pdata = of_get_coresight_platform_data(dev, np);
-		if (IS_ERR(pdata))
-			return PTR_ERR(pdata);
-
-		adev->dev.platform_data = pdata;
-		drvdata->use_cp14 = of_property_read_bool(np, "arm,cp14");
-	}
-
-	drvdata->dev = &adev->dev;
-	dev_set_drvdata(dev, drvdata);
-
-	/* Validity for the resource is already checked by the AMBA core */
-	base = devm_ioremap_resource(dev, res);
-	if (IS_ERR(base))
-		return PTR_ERR(base);
-
-	drvdata->base = base;
-
-	spin_lock_init(&drvdata->spinlock);
-
-	drvdata->clk = adev->pclk;
-	ret = clk_prepare_enable(drvdata->clk);
-	if (ret)
-		return ret;
-
-	drvdata->cpu = pdata ? pdata->cpu : 0;
-
-	get_online_cpus();
-	etmdrvdata[drvdata->cpu] = drvdata;
-
-	if (!smp_call_function_single(drvdata->cpu, etm_os_unlock, drvdata, 1))
-		drvdata->os_unlock = true;
-
-	if (smp_call_function_single(drvdata->cpu,
-				     etm_init_arch_data,  drvdata, 1))
-		dev_err(dev, "ETM arch init failed\n");
-
-	if (!etm_count++)
-		register_hotcpu_notifier(&etm_cpu_notifier);
-
-	put_online_cpus();
-
-	if (etm_arch_supported(drvdata->arch) == false) {
-		ret = -EINVAL;
-		goto err_arch_supported;
-	}
-	etm_init_default_data(drvdata);
-
-	clk_disable_unprepare(drvdata->clk);
-
-	desc->type = CORESIGHT_DEV_TYPE_SOURCE;
-	desc->subtype.source_subtype = CORESIGHT_DEV_SUBTYPE_SOURCE_PROC;
-	desc->ops = &etm_cs_ops;
-	desc->pdata = pdata;
-	desc->dev = dev;
-	desc->groups = coresight_etm_groups;
-	drvdata->csdev = coresight_register(desc);
-	if (IS_ERR(drvdata->csdev)) {
-		ret = PTR_ERR(drvdata->csdev);
-		goto err_arch_supported;
-	}
-
-	dev_info(dev, "ETM initialized\n");
-
-	if (boot_enable) {
-		coresight_enable(drvdata->csdev);
-		drvdata->boot_enable = true;
-	}
-
-	return 0;
-
-err_arch_supported:
-	clk_disable_unprepare(drvdata->clk);
-	if (--etm_count == 0)
-		unregister_hotcpu_notifier(&etm_cpu_notifier);
-	return ret;
-}
-
-static int etm_remove(struct amba_device *adev)
-{
-	struct etm_drvdata *drvdata = amba_get_drvdata(adev);
-
-	coresight_unregister(drvdata->csdev);
-	if (--etm_count == 0)
-		unregister_hotcpu_notifier(&etm_cpu_notifier);
-
-	return 0;
-}
-
-static struct amba_id etm_ids[] = {
-	{	/* ETM 3.3 */
-		.id	= 0x0003b921,
-		.mask	= 0x0003ffff,
-	},
-	{	/* ETM 3.5 */
-		.id	= 0x0003b956,
-		.mask	= 0x0003ffff,
-	},
-	{	/* PTM 1.0 */
-		.id	= 0x0003b950,
-		.mask	= 0x0003ffff,
-	},
-	{	/* PTM 1.1 */
-		.id	= 0x0003b95f,
-		.mask	= 0x0003ffff,
-	},
-	{ 0, 0},
-};
-
-static struct amba_driver etm_driver = {
-	.drv = {
-		.name	= "coresight-etm3x",
-		.owner	= THIS_MODULE,
-	},
-	.probe		= etm_probe,
-	.remove		= etm_remove,
-	.id_table	= etm_ids,
-};
-
-int __init etm_init(void)
-{
-	return amba_driver_register(&etm_driver);
-}
-module_init(etm_init);
-
-void __exit etm_exit(void)
-{
-	amba_driver_unregister(&etm_driver);
-}
-module_exit(etm_exit);
-
-MODULE_LICENSE("GPL v2");
-MODULE_DESCRIPTION("CoreSight Program Flow Trace driver");
diff --git a/drivers/coresight/coresight-funnel.c b/drivers/coresight/coresight-funnel.c
deleted file mode 100644
index 3db36f70b666..000000000000
--- a/drivers/coresight/coresight-funnel.c
+++ /dev/null
@@ -1,258 +0,0 @@
-/* Copyright (c) 2011-2012, The Linux Foundation. All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 and
- * only version 2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- */
-
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/init.h>
-#include <linux/types.h>
-#include <linux/device.h>
-#include <linux/err.h>
-#include <linux/fs.h>
-#include <linux/slab.h>
-#include <linux/clk.h>
-#include <linux/coresight.h>
-#include <linux/amba/bus.h>
-
-#include "coresight-priv.h"
-
-#define FUNNEL_FUNCTL		0x000
-#define FUNNEL_PRICTL		0x004
-
-#define FUNNEL_HOLDTIME_MASK	0xf00
-#define FUNNEL_HOLDTIME_SHFT	0x8
-#define FUNNEL_HOLDTIME		(0x7 << FUNNEL_HOLDTIME_SHFT)
-
-/**
- * struct funnel_drvdata - specifics associated to a funnel component
- * @base:	memory mapped base address for this component.
- * @dev:	the device entity associated to this component.
- * @csdev:	component vitals needed by the framework.
- * @clk:	the clock this component is associated to.
- * @priority:	port selection order.
- */
-struct funnel_drvdata {
-	void __iomem		*base;
-	struct device		*dev;
-	struct coresight_device	*csdev;
-	struct clk		*clk;
-	unsigned long		priority;
-};
-
-static void funnel_enable_hw(struct funnel_drvdata *drvdata, int port)
-{
-	u32 functl;
-
-	CS_UNLOCK(drvdata->base);
-
-	functl = readl_relaxed(drvdata->base + FUNNEL_FUNCTL);
-	functl &= ~FUNNEL_HOLDTIME_MASK;
-	functl |= FUNNEL_HOLDTIME;
-	functl |= (1 << port);
-	writel_relaxed(functl, drvdata->base + FUNNEL_FUNCTL);
-	writel_relaxed(drvdata->priority, drvdata->base + FUNNEL_PRICTL);
-
-	CS_LOCK(drvdata->base);
-}
-
-static int funnel_enable(struct coresight_device *csdev, int inport,
-			 int outport)
-{
-	struct funnel_drvdata *drvdata = dev_get_drvdata(csdev->dev.parent);
-	int ret;
-
-	ret = clk_prepare_enable(drvdata->clk);
-	if (ret)
-		return ret;
-
-	funnel_enable_hw(drvdata, inport);
-
-	dev_info(drvdata->dev, "FUNNEL inport %d enabled\n", inport);
-	return 0;
-}
-
-static void funnel_disable_hw(struct funnel_drvdata *drvdata, int inport)
-{
-	u32 functl;
-
-	CS_UNLOCK(drvdata->base);
-
-	functl = readl_relaxed(drvdata->base + FUNNEL_FUNCTL);
-	functl &= ~(1 << inport);
-	writel_relaxed(functl, drvdata->base + FUNNEL_FUNCTL);
-
-	CS_LOCK(drvdata->base);
-}
-
-static void funnel_disable(struct coresight_device *csdev, int inport,
-			   int outport)
-{
-	struct funnel_drvdata *drvdata = dev_get_drvdata(csdev->dev.parent);
-
-	funnel_disable_hw(drvdata, inport);
-
-	clk_disable_unprepare(drvdata->clk);
-
-	dev_info(drvdata->dev, "FUNNEL inport %d disabled\n", inport);
-}
-
-static const struct coresight_ops_link funnel_link_ops = {
-	.enable		= funnel_enable,
-	.disable	= funnel_disable,
-};
-
-static const struct coresight_ops funnel_cs_ops = {
-	.link_ops	= &funnel_link_ops,
-};
-
-static ssize_t priority_show(struct device *dev,
-			     struct device_attribute *attr, char *buf)
-{
-	struct funnel_drvdata *drvdata = dev_get_drvdata(dev->parent);
-	unsigned long val = drvdata->priority;
-
-	return sprintf(buf, "%#lx\n", val);
-}
-
-static ssize_t priority_store(struct device *dev,
-			      struct device_attribute *attr,
-			      const char *buf, size_t size)
-{
-	int ret;
-	unsigned long val;
-	struct funnel_drvdata *drvdata = dev_get_drvdata(dev->parent);
-
-	ret = kstrtoul(buf, 16, &val);
-	if (ret)
-		return ret;
-
-	drvdata->priority = val;
-	return size;
-}
-static DEVICE_ATTR_RW(priority);
-
-static u32 get_funnel_ctrl_hw(struct funnel_drvdata *drvdata)
-{
-	u32 functl;
-
-	CS_UNLOCK(drvdata->base);
-	functl = readl_relaxed(drvdata->base + FUNNEL_FUNCTL);
-	CS_LOCK(drvdata->base);
-
-	return functl;
-}
-
-static ssize_t funnel_ctrl_show(struct device *dev,
-			     struct device_attribute *attr, char *buf)
-{
-	int ret;
-	u32 val;
-	struct funnel_drvdata *drvdata = dev_get_drvdata(dev->parent);
-
-	ret = clk_prepare_enable(drvdata->clk);
-	if (ret)
-		return ret;
-
-	val = get_funnel_ctrl_hw(drvdata);
-	clk_disable_unprepare(drvdata->clk);
-
-	return sprintf(buf, "%#x\n", val);
-}
-static DEVICE_ATTR_RO(funnel_ctrl);
-
-static struct attribute *coresight_funnel_attrs[] = {
-	&dev_attr_funnel_ctrl.attr,
-	&dev_attr_priority.attr,
-	NULL,
-};
-ATTRIBUTE_GROUPS(coresight_funnel);
-
-static int funnel_probe(struct amba_device *adev, const struct amba_id *id)
-{
-	void __iomem *base;
-	struct device *dev = &adev->dev;
-	struct coresight_platform_data *pdata = NULL;
-	struct funnel_drvdata *drvdata;
-	struct resource *res = &adev->res;
-	struct coresight_desc *desc;
-	struct device_node *np = adev->dev.of_node;
-
-	if (np) {
-		pdata = of_get_coresight_platform_data(dev, np);
-		if (IS_ERR(pdata))
-			return PTR_ERR(pdata);
-		adev->dev.platform_data = pdata;
-	}
-
-	drvdata = devm_kzalloc(dev, sizeof(*drvdata), GFP_KERNEL);
-	if (!drvdata)
-		return -ENOMEM;
-
-	drvdata->dev = &adev->dev;
-	dev_set_drvdata(dev, drvdata);
-
-	/* Validity for the resource is already checked by the AMBA core */
-	base = devm_ioremap_resource(dev, res);
-	if (IS_ERR(base))
-		return PTR_ERR(base);
-
-	drvdata->base = base;
-
-	drvdata->clk = adev->pclk;
-
-	desc = devm_kzalloc(dev, sizeof(*desc), GFP_KERNEL);
-	if (!desc)
-		return -ENOMEM;
-
-	desc->type = CORESIGHT_DEV_TYPE_LINK;
-	desc->subtype.link_subtype = CORESIGHT_DEV_SUBTYPE_LINK_MERG;
-	desc->ops = &funnel_cs_ops;
-	desc->pdata = pdata;
-	desc->dev = dev;
-	desc->groups = coresight_funnel_groups;
-	drvdata->csdev = coresight_register(desc);
-	if (IS_ERR(drvdata->csdev))
-		return PTR_ERR(drvdata->csdev);
-
-	dev_info(dev, "FUNNEL initialized\n");
-	return 0;
-}
-
-static int funnel_remove(struct amba_device *adev)
-{
-	struct funnel_drvdata *drvdata = amba_get_drvdata(adev);
-
-	coresight_unregister(drvdata->csdev);
-	return 0;
-}
-
-static struct amba_id funnel_ids[] = {
-	{
-		.id     = 0x0003b908,
-		.mask   = 0x0003ffff,
-	},
-	{ 0, 0},
-};
-
-static struct amba_driver funnel_driver = {
-	.drv = {
-		.name	= "coresight-funnel",
-		.owner	= THIS_MODULE,
-	},
-	.probe		= funnel_probe,
-	.remove		= funnel_remove,
-	.id_table	= funnel_ids,
-};
-
-module_amba_driver(funnel_driver);
-
-MODULE_LICENSE("GPL v2");
-MODULE_DESCRIPTION("CoreSight Funnel driver");
diff --git a/drivers/coresight/coresight-priv.h b/drivers/coresight/coresight-priv.h
deleted file mode 100644
index 62fcd98cc7cf..000000000000
--- a/drivers/coresight/coresight-priv.h
+++ /dev/null
@@ -1,63 +0,0 @@
-/* Copyright (c) 2011-2012, The Linux Foundation. All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 and
- * only version 2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- */
-
-#ifndef _CORESIGHT_PRIV_H
-#define _CORESIGHT_PRIV_H
-
-#include <linux/bitops.h>
-#include <linux/io.h>
-#include <linux/coresight.h>
-
-/*
- * Coresight management registers (0xf00-0xfcc)
- * 0xfa0 - 0xfa4: Management	registers in PFTv1.0
- *		  Trace		registers in PFTv1.1
- */
-#define CORESIGHT_ITCTRL	0xf00
-#define CORESIGHT_CLAIMSET	0xfa0
-#define CORESIGHT_CLAIMCLR	0xfa4
-#define CORESIGHT_LAR		0xfb0
-#define CORESIGHT_LSR		0xfb4
-#define CORESIGHT_AUTHSTATUS	0xfb8
-#define CORESIGHT_DEVID		0xfc8
-#define CORESIGHT_DEVTYPE	0xfcc
-
-#define TIMEOUT_US		100
-#define BMVAL(val, lsb, msb)	((val & GENMASK(msb, lsb)) >> lsb)
-
-static inline void CS_LOCK(void __iomem *addr)
-{
-	do {
-		/* Wait for things to settle */
-		mb();
-		writel_relaxed(0x0, addr + CORESIGHT_LAR);
-	} while (0);
-}
-
-static inline void CS_UNLOCK(void __iomem *addr)
-{
-	do {
-		writel_relaxed(CORESIGHT_UNLOCK, addr + CORESIGHT_LAR);
-		/* Make sure everyone has seen this */
-		mb();
-	} while (0);
-}
-
-#ifdef CONFIG_CORESIGHT_SOURCE_ETM3X
-extern int etm_readl_cp14(u32 off, unsigned int *val);
-extern int etm_writel_cp14(u32 off, u32 val);
-#else
-static inline int etm_readl_cp14(u32 off, unsigned int *val) { return 0; }
-static inline int etm_writel_cp14(u32 off, u32 val) { return 0; }
-#endif
-
-#endif
diff --git a/drivers/coresight/coresight-replicator.c b/drivers/coresight/coresight-replicator.c
deleted file mode 100644
index cdf05537d574..000000000000
--- a/drivers/coresight/coresight-replicator.c
+++ /dev/null
@@ -1,137 +0,0 @@
-/* Copyright (c) 2011-2012, The Linux Foundation. All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 and
- * only version 2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- */
-
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/init.h>
-#include <linux/device.h>
-#include <linux/platform_device.h>
-#include <linux/io.h>
-#include <linux/err.h>
-#include <linux/slab.h>
-#include <linux/clk.h>
-#include <linux/of.h>
-#include <linux/coresight.h>
-
-#include "coresight-priv.h"
-
-/**
- * struct replicator_drvdata - specifics associated to a replicator component
- * @dev:	the device entity associated with this component
- * @csdev:	component vitals needed by the framework
- */
-struct replicator_drvdata {
-	struct device		*dev;
-	struct coresight_device	*csdev;
-};
-
-static int replicator_enable(struct coresight_device *csdev, int inport,
-			     int outport)
-{
-	struct replicator_drvdata *drvdata = dev_get_drvdata(csdev->dev.parent);
-
-	dev_info(drvdata->dev, "REPLICATOR enabled\n");
-	return 0;
-}
-
-static void replicator_disable(struct coresight_device *csdev, int inport,
-			       int outport)
-{
-	struct replicator_drvdata *drvdata = dev_get_drvdata(csdev->dev.parent);
-
-	dev_info(drvdata->dev, "REPLICATOR disabled\n");
-}
-
-static const struct coresight_ops_link replicator_link_ops = {
-	.enable		= replicator_enable,
-	.disable	= replicator_disable,
-};
-
-static const struct coresight_ops replicator_cs_ops = {
-	.link_ops	= &replicator_link_ops,
-};
-
-static int replicator_probe(struct platform_device *pdev)
-{
-	struct device *dev = &pdev->dev;
-	struct coresight_platform_data *pdata = NULL;
-	struct replicator_drvdata *drvdata;
-	struct coresight_desc *desc;
-	struct device_node *np = pdev->dev.of_node;
-
-	if (np) {
-		pdata = of_get_coresight_platform_data(dev, np);
-		if (IS_ERR(pdata))
-			return PTR_ERR(pdata);
-		pdev->dev.platform_data = pdata;
-	}
-
-	drvdata = devm_kzalloc(dev, sizeof(*drvdata), GFP_KERNEL);
-	if (!drvdata)
-		return -ENOMEM;
-
-	drvdata->dev = &pdev->dev;
-	platform_set_drvdata(pdev, drvdata);
-
-	desc = devm_kzalloc(dev, sizeof(*desc), GFP_KERNEL);
-	if (!desc)
-		return -ENOMEM;
-
-	desc->type = CORESIGHT_DEV_TYPE_LINK;
-	desc->subtype.link_subtype = CORESIGHT_DEV_SUBTYPE_LINK_SPLIT;
-	desc->ops = &replicator_cs_ops;
-	desc->pdata = pdev->dev.platform_data;
-	desc->dev = &pdev->dev;
-	drvdata->csdev = coresight_register(desc);
-	if (IS_ERR(drvdata->csdev))
-		return PTR_ERR(drvdata->csdev);
-
-	dev_info(dev, "REPLICATOR initialized\n");
-	return 0;
-}
-
-static int replicator_remove(struct platform_device *pdev)
-{
-	struct replicator_drvdata *drvdata = platform_get_drvdata(pdev);
-
-	coresight_unregister(drvdata->csdev);
-	return 0;
-}
-
-static struct of_device_id replicator_match[] = {
-	{.compatible = "arm,coresight-replicator"},
-	{}
-};
-
-static struct platform_driver replicator_driver = {
-	.probe          = replicator_probe,
-	.remove         = replicator_remove,
-	.driver         = {
-		.name   = "coresight-replicator",
-		.of_match_table = replicator_match,
-	},
-};
-
-static int __init replicator_init(void)
-{
-	return platform_driver_register(&replicator_driver);
-}
-module_init(replicator_init);
-
-static void __exit replicator_exit(void)
-{
-	platform_driver_unregister(&replicator_driver);
-}
-module_exit(replicator_exit);
-
-MODULE_LICENSE("GPL v2");
-MODULE_DESCRIPTION("CoreSight Replicator driver");
diff --git a/drivers/coresight/coresight-tmc.c b/drivers/coresight/coresight-tmc.c
deleted file mode 100644
index 7147f3dd363c..000000000000
--- a/drivers/coresight/coresight-tmc.c
+++ /dev/null
@@ -1,822 +0,0 @@
-/* Copyright (c) 2012, The Linux Foundation. All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 and
- * only version 2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- */
-
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/init.h>
-#include <linux/types.h>
-#include <linux/device.h>
-#include <linux/io.h>
-#include <linux/err.h>
-#include <linux/fs.h>
-#include <linux/miscdevice.h>
-#include <linux/uaccess.h>
-#include <linux/slab.h>
-#include <linux/dma-mapping.h>
-#include <linux/spinlock.h>
-#include <linux/clk.h>
-#include <linux/of.h>
-#include <linux/coresight.h>
-#include <linux/amba/bus.h>
-
-#include "coresight-priv.h"
-
-#define TMC_RSZ			0x004
-#define TMC_STS			0x00c
-#define TMC_RRD			0x010
-#define TMC_RRP			0x014
-#define TMC_RWP			0x018
-#define TMC_TRG			0x01c
-#define TMC_CTL			0x020
-#define TMC_RWD			0x024
-#define TMC_MODE		0x028
-#define TMC_LBUFLEVEL		0x02c
-#define TMC_CBUFLEVEL		0x030
-#define TMC_BUFWM		0x034
-#define TMC_RRPHI		0x038
-#define TMC_RWPHI		0x03c
-#define TMC_AXICTL		0x110
-#define TMC_DBALO		0x118
-#define TMC_DBAHI		0x11c
-#define TMC_FFSR		0x300
-#define TMC_FFCR		0x304
-#define TMC_PSCR		0x308
-#define TMC_ITMISCOP0		0xee0
-#define TMC_ITTRFLIN		0xee8
-#define TMC_ITATBDATA0		0xeec
-#define TMC_ITATBCTR2		0xef0
-#define TMC_ITATBCTR1		0xef4
-#define TMC_ITATBCTR0		0xef8
-
-/* register description */
-/* TMC_CTL - 0x020 */
-#define TMC_CTL_CAPT_EN		BIT(0)
-/* TMC_STS - 0x00C */
-#define TMC_STS_TRIGGERED	BIT(1)
-/* TMC_AXICTL - 0x110 */
-#define TMC_AXICTL_PROT_CTL_B0	BIT(0)
-#define TMC_AXICTL_PROT_CTL_B1	BIT(1)
-#define TMC_AXICTL_SCT_GAT_MODE	BIT(7)
-#define TMC_AXICTL_WR_BURST_LEN 0xF00
-/* TMC_FFCR - 0x304 */
-#define TMC_FFCR_EN_FMT		BIT(0)
-#define TMC_FFCR_EN_TI		BIT(1)
-#define TMC_FFCR_FON_FLIN	BIT(4)
-#define TMC_FFCR_FON_TRIG_EVT	BIT(5)
-#define TMC_FFCR_FLUSHMAN	BIT(6)
-#define TMC_FFCR_TRIGON_TRIGIN	BIT(8)
-#define TMC_FFCR_STOP_ON_FLUSH	BIT(12)
-
-#define TMC_STS_TRIGGERED_BIT	2
-#define TMC_FFCR_FLUSHMAN_BIT	6
-
-enum tmc_config_type {
-	TMC_CONFIG_TYPE_ETB,
-	TMC_CONFIG_TYPE_ETR,
-	TMC_CONFIG_TYPE_ETF,
-};
-
-enum tmc_mode {
-	TMC_MODE_CIRCULAR_BUFFER,
-	TMC_MODE_SOFTWARE_FIFO,
-	TMC_MODE_HARDWARE_FIFO,
-};
-
-enum tmc_mem_intf_width {
-	TMC_MEM_INTF_WIDTH_32BITS	= 0x2,
-	TMC_MEM_INTF_WIDTH_64BITS	= 0x3,
-	TMC_MEM_INTF_WIDTH_128BITS	= 0x4,
-	TMC_MEM_INTF_WIDTH_256BITS	= 0x5,
-};
-
-/**
- * struct tmc_drvdata - specifics associated to an TMC component
- * @base:	memory mapped base address for this component.
- * @dev:	the device entity associated to this component.
- * @csdev:	component vitals needed by the framework.
- * @miscdev:	specifics to handle "/dev/xyz.tmc" entry.
- * @clk:	the clock this component is associated to.
- * @spinlock:	only one at a time pls.
- * @read_count:	manages preparation of buffer for reading.
- * @buf:	area of memory where trace data get sent.
- * @paddr:	DMA start location in RAM.
- * @vaddr:	virtual representation of @paddr.
- * @size:	@buf size.
- * @enable:	this TMC is being used.
- * @config_type: TMC variant, must be of type @tmc_config_type.
- * @trigger_cntr: amount of words to store after a trigger.
- */
-struct tmc_drvdata {
-	void __iomem		*base;
-	struct device		*dev;
-	struct coresight_device	*csdev;
-	struct miscdevice	miscdev;
-	struct clk		*clk;
-	spinlock_t		spinlock;
-	int			read_count;
-	bool			reading;
-	char			*buf;
-	dma_addr_t		paddr;
-	void __iomem		*vaddr;
-	u32			size;
-	bool			enable;
-	enum tmc_config_type	config_type;
-	u32			trigger_cntr;
-};
-
-static void tmc_wait_for_ready(struct tmc_drvdata *drvdata)
-{
-	/* Ensure formatter, unformatter and hardware fifo are empty */
-	if (coresight_timeout(drvdata->base,
-			      TMC_STS, TMC_STS_TRIGGERED_BIT, 1)) {
-		dev_err(drvdata->dev,
-			"timeout observed when probing at offset %#x\n",
-			TMC_STS);
-	}
-}
-
-static void tmc_flush_and_stop(struct tmc_drvdata *drvdata)
-{
-	u32 ffcr;
-
-	ffcr = readl_relaxed(drvdata->base + TMC_FFCR);
-	ffcr |= TMC_FFCR_STOP_ON_FLUSH;
-	writel_relaxed(ffcr, drvdata->base + TMC_FFCR);
-	ffcr |= TMC_FFCR_FLUSHMAN;
-	writel_relaxed(ffcr, drvdata->base + TMC_FFCR);
-	/* Ensure flush completes */
-	if (coresight_timeout(drvdata->base,
-			      TMC_FFCR, TMC_FFCR_FLUSHMAN_BIT, 0)) {
-		dev_err(drvdata->dev,
-			"timeout observed when probing at offset %#x\n",
-			TMC_FFCR);
-	}
-
-	tmc_wait_for_ready(drvdata);
-}
-
-static void tmc_enable_hw(struct tmc_drvdata *drvdata)
-{
-	writel_relaxed(TMC_CTL_CAPT_EN, drvdata->base + TMC_CTL);
-}
-
-static void tmc_disable_hw(struct tmc_drvdata *drvdata)
-{
-	writel_relaxed(0x0, drvdata->base + TMC_CTL);
-}
-
-static void tmc_etb_enable_hw(struct tmc_drvdata *drvdata)
-{
-	/* Zero out the memory to help with debug */
-	memset(drvdata->buf, 0, drvdata->size);
-
-	CS_UNLOCK(drvdata->base);
-
-	writel_relaxed(TMC_MODE_CIRCULAR_BUFFER, drvdata->base + TMC_MODE);
-	writel_relaxed(TMC_FFCR_EN_FMT | TMC_FFCR_EN_TI |
-		       TMC_FFCR_FON_FLIN | TMC_FFCR_FON_TRIG_EVT |
-		       TMC_FFCR_TRIGON_TRIGIN,
-		       drvdata->base + TMC_FFCR);
-
-	writel_relaxed(drvdata->trigger_cntr, drvdata->base + TMC_TRG);
-	tmc_enable_hw(drvdata);
-
-	CS_LOCK(drvdata->base);
-}
-
-static void tmc_etr_enable_hw(struct tmc_drvdata *drvdata)
-{
-	u32 axictl;
-
-	/* Zero out the memory to help with debug */
-	memset(drvdata->vaddr, 0, drvdata->size);
-
-	CS_UNLOCK(drvdata->base);
-
-	writel_relaxed(drvdata->size / 4, drvdata->base + TMC_RSZ);
-	writel_relaxed(TMC_MODE_CIRCULAR_BUFFER, drvdata->base + TMC_MODE);
-
-	axictl = readl_relaxed(drvdata->base + TMC_AXICTL);
-	axictl |= TMC_AXICTL_WR_BURST_LEN;
-	writel_relaxed(axictl, drvdata->base + TMC_AXICTL);
-	axictl &= ~TMC_AXICTL_SCT_GAT_MODE;
-	writel_relaxed(axictl, drvdata->base + TMC_AXICTL);
-	axictl = (axictl &
-		  ~(TMC_AXICTL_PROT_CTL_B0 | TMC_AXICTL_PROT_CTL_B1)) |
-		  TMC_AXICTL_PROT_CTL_B1;
-	writel_relaxed(axictl, drvdata->base + TMC_AXICTL);
-
-	writel_relaxed(drvdata->paddr, drvdata->base + TMC_DBALO);
-	writel_relaxed(0x0, drvdata->base + TMC_DBAHI);
-	writel_relaxed(TMC_FFCR_EN_FMT | TMC_FFCR_EN_TI |
-		       TMC_FFCR_FON_FLIN | TMC_FFCR_FON_TRIG_EVT |
-		       TMC_FFCR_TRIGON_TRIGIN,
-		       drvdata->base + TMC_FFCR);
-	writel_relaxed(drvdata->trigger_cntr, drvdata->base + TMC_TRG);
-	tmc_enable_hw(drvdata);
-
-	CS_LOCK(drvdata->base);
-}
-
-static void tmc_etf_enable_hw(struct tmc_drvdata *drvdata)
-{
-	CS_UNLOCK(drvdata->base);
-
-	writel_relaxed(TMC_MODE_HARDWARE_FIFO, drvdata->base + TMC_MODE);
-	writel_relaxed(TMC_FFCR_EN_FMT | TMC_FFCR_EN_TI,
-		       drvdata->base + TMC_FFCR);
-	writel_relaxed(0x0, drvdata->base + TMC_BUFWM);
-	tmc_enable_hw(drvdata);
-
-	CS_LOCK(drvdata->base);
-}
-
-static int tmc_enable(struct tmc_drvdata *drvdata, enum tmc_mode mode)
-{
-	int ret;
-	unsigned long flags;
-
-	ret = clk_prepare_enable(drvdata->clk);
-	if (ret)
-		return ret;
-
-	spin_lock_irqsave(&drvdata->spinlock, flags);
-	if (drvdata->reading) {
-		spin_unlock_irqrestore(&drvdata->spinlock, flags);
-		clk_disable_unprepare(drvdata->clk);
-		return -EBUSY;
-	}
-
-	if (drvdata->config_type == TMC_CONFIG_TYPE_ETB) {
-		tmc_etb_enable_hw(drvdata);
-	} else if (drvdata->config_type == TMC_CONFIG_TYPE_ETR) {
-		tmc_etr_enable_hw(drvdata);
-	} else {
-		if (mode == TMC_MODE_CIRCULAR_BUFFER)
-			tmc_etb_enable_hw(drvdata);
-		else
-			tmc_etf_enable_hw(drvdata);
-	}
-	drvdata->enable = true;
-	spin_unlock_irqrestore(&drvdata->spinlock, flags);
-
-	dev_info(drvdata->dev, "TMC enabled\n");
-	return 0;
-}
-
-static int tmc_enable_sink(struct coresight_device *csdev)
-{
-	struct tmc_drvdata *drvdata = dev_get_drvdata(csdev->dev.parent);
-
-	return tmc_enable(drvdata, TMC_MODE_CIRCULAR_BUFFER);
-}
-
-static int tmc_enable_link(struct coresight_device *csdev, int inport,
-			   int outport)
-{
-	struct tmc_drvdata *drvdata = dev_get_drvdata(csdev->dev.parent);
-
-	return tmc_enable(drvdata, TMC_MODE_HARDWARE_FIFO);
-}
-
-static void tmc_etb_dump_hw(struct tmc_drvdata *drvdata)
-{
-	enum tmc_mem_intf_width memwidth;
-	u8 memwords;
-	char *bufp;
-	u32 read_data;
-	int i;
-
-	memwidth = BMVAL(readl_relaxed(drvdata->base + CORESIGHT_DEVID), 8, 10);
-	if (memwidth == TMC_MEM_INTF_WIDTH_32BITS)
-		memwords = 1;
-	else if (memwidth == TMC_MEM_INTF_WIDTH_64BITS)
-		memwords = 2;
-	else if (memwidth == TMC_MEM_INTF_WIDTH_128BITS)
-		memwords = 4;
-	else
-		memwords = 8;
-
-	bufp = drvdata->buf;
-	while (1) {
-		for (i = 0; i < memwords; i++) {
-			read_data = readl_relaxed(drvdata->base + TMC_RRD);
-			if (read_data == 0xFFFFFFFF)
-				return;
-			memcpy(bufp, &read_data, 4);
-			bufp += 4;
-		}
-	}
-}
-
-static void tmc_etb_disable_hw(struct tmc_drvdata *drvdata)
-{
-	CS_UNLOCK(drvdata->base);
-
-	tmc_flush_and_stop(drvdata);
-	tmc_etb_dump_hw(drvdata);
-	tmc_disable_hw(drvdata);
-
-	CS_LOCK(drvdata->base);
-}
-
-static void tmc_etr_dump_hw(struct tmc_drvdata *drvdata)
-{
-	u32 rwp, val;
-
-	rwp = readl_relaxed(drvdata->base + TMC_RWP);
-	val = readl_relaxed(drvdata->base + TMC_STS);
-
-	/* How much memory do we still have */
-	if (val & BIT(0))
-		drvdata->buf = drvdata->vaddr + rwp - drvdata->paddr;
-	else
-		drvdata->buf = drvdata->vaddr;
-}
-
-static void tmc_etr_disable_hw(struct tmc_drvdata *drvdata)
-{
-	CS_UNLOCK(drvdata->base);
-
-	tmc_flush_and_stop(drvdata);
-	tmc_etr_dump_hw(drvdata);
-	tmc_disable_hw(drvdata);
-
-	CS_LOCK(drvdata->base);
-}
-
-static void tmc_etf_disable_hw(struct tmc_drvdata *drvdata)
-{
-	CS_UNLOCK(drvdata->base);
-
-	tmc_flush_and_stop(drvdata);
-	tmc_disable_hw(drvdata);
-
-	CS_LOCK(drvdata->base);
-}
-
-static void tmc_disable(struct tmc_drvdata *drvdata, enum tmc_mode mode)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&drvdata->spinlock, flags);
-	if (drvdata->reading)
-		goto out;
-
-	if (drvdata->config_type == TMC_CONFIG_TYPE_ETB) {
-		tmc_etb_disable_hw(drvdata);
-	} else if (drvdata->config_type == TMC_CONFIG_TYPE_ETR) {
-		tmc_etr_disable_hw(drvdata);
-	} else {
-		if (mode == TMC_MODE_CIRCULAR_BUFFER)
-			tmc_etb_disable_hw(drvdata);
-		else
-			tmc_etf_disable_hw(drvdata);
-	}
-out:
-	drvdata->enable = false;
-	spin_unlock_irqrestore(&drvdata->spinlock, flags);
-
-	clk_disable_unprepare(drvdata->clk);
-
-	dev_info(drvdata->dev, "TMC disabled\n");
-}
-
-static void tmc_disable_sink(struct coresight_device *csdev)
-{
-	struct tmc_drvdata *drvdata = dev_get_drvdata(csdev->dev.parent);
-
-	tmc_disable(drvdata, TMC_MODE_CIRCULAR_BUFFER);
-}
-
-static void tmc_disable_link(struct coresight_device *csdev, int inport,
-			     int outport)
-{
-	struct tmc_drvdata *drvdata = dev_get_drvdata(csdev->dev.parent);
-
-	tmc_disable(drvdata, TMC_MODE_HARDWARE_FIFO);
-}
-
-static const struct coresight_ops_sink tmc_sink_ops = {
-	.enable		= tmc_enable_sink,
-	.disable	= tmc_disable_sink,
-};
-
-static const struct coresight_ops_link tmc_link_ops = {
-	.enable		= tmc_enable_link,
-	.disable	= tmc_disable_link,
-};
-
-static const struct coresight_ops tmc_etb_cs_ops = {
-	.sink_ops	= &tmc_sink_ops,
-};
-
-static const struct coresight_ops tmc_etr_cs_ops = {
-	.sink_ops	= &tmc_sink_ops,
-};
-
-static const struct coresight_ops tmc_etf_cs_ops = {
-	.sink_ops	= &tmc_sink_ops,
-	.link_ops	= &tmc_link_ops,
-};
-
-static int tmc_read_prepare(struct tmc_drvdata *drvdata)
-{
-	int ret;
-	unsigned long flags;
-	enum tmc_mode mode;
-
-	spin_lock_irqsave(&drvdata->spinlock, flags);
-	if (!drvdata->enable)
-		goto out;
-
-	if (drvdata->config_type == TMC_CONFIG_TYPE_ETB) {
-		tmc_etb_disable_hw(drvdata);
-	} else if (drvdata->config_type == TMC_CONFIG_TYPE_ETR) {
-		tmc_etr_disable_hw(drvdata);
-	} else {
-		mode = readl_relaxed(drvdata->base + TMC_MODE);
-		if (mode == TMC_MODE_CIRCULAR_BUFFER) {
-			tmc_etb_disable_hw(drvdata);
-		} else {
-			ret = -ENODEV;
-			goto err;
-		}
-	}
-out:
-	drvdata->reading = true;
-	spin_unlock_irqrestore(&drvdata->spinlock, flags);
-
-	dev_info(drvdata->dev, "TMC read start\n");
-	return 0;
-err:
-	spin_unlock_irqrestore(&drvdata->spinlock, flags);
-	return ret;
-}
-
-static void tmc_read_unprepare(struct tmc_drvdata *drvdata)
-{
-	unsigned long flags;
-	enum tmc_mode mode;
-
-	spin_lock_irqsave(&drvdata->spinlock, flags);
-	if (!drvdata->enable)
-		goto out;
-
-	if (drvdata->config_type == TMC_CONFIG_TYPE_ETB) {
-		tmc_etb_enable_hw(drvdata);
-	} else if (drvdata->config_type == TMC_CONFIG_TYPE_ETR) {
-		tmc_etr_enable_hw(drvdata);
-	} else {
-		mode = readl_relaxed(drvdata->base + TMC_MODE);
-		if (mode == TMC_MODE_CIRCULAR_BUFFER)
-			tmc_etb_enable_hw(drvdata);
-	}
-out:
-	drvdata->reading = false;
-	spin_unlock_irqrestore(&drvdata->spinlock, flags);
-
-	dev_info(drvdata->dev, "TMC read end\n");
-}
-
-static int tmc_open(struct inode *inode, struct file *file)
-{
-	struct tmc_drvdata *drvdata = container_of(file->private_data,
-						   struct tmc_drvdata, miscdev);
-	int ret = 0;
-
-	if (drvdata->read_count++)
-		goto out;
-
-	ret = tmc_read_prepare(drvdata);
-	if (ret)
-		return ret;
-out:
-	nonseekable_open(inode, file);
-
-	dev_dbg(drvdata->dev, "%s: successfully opened\n", __func__);
-	return 0;
-}
-
-static ssize_t tmc_read(struct file *file, char __user *data, size_t len,
-			loff_t *ppos)
-{
-	struct tmc_drvdata *drvdata = container_of(file->private_data,
-						   struct tmc_drvdata, miscdev);
-	char *bufp = drvdata->buf + *ppos;
-
-	if (*ppos + len > drvdata->size)
-		len = drvdata->size - *ppos;
-
-	if (drvdata->config_type == TMC_CONFIG_TYPE_ETR) {
-		if (bufp == (char *)(drvdata->vaddr + drvdata->size))
-			bufp = drvdata->vaddr;
-		else if (bufp > (char *)(drvdata->vaddr + drvdata->size))
-			bufp -= drvdata->size;
-		if ((bufp + len) > (char *)(drvdata->vaddr + drvdata->size))
-			len = (char *)(drvdata->vaddr + drvdata->size) - bufp;
-	}
-
-	if (copy_to_user(data, bufp, len)) {
-		dev_dbg(drvdata->dev, "%s: copy_to_user failed\n", __func__);
-		return -EFAULT;
-	}
-
-	*ppos += len;
-
-	dev_dbg(drvdata->dev, "%s: %zu bytes copied, %d bytes left\n",
-		__func__, len, (int)(drvdata->size - *ppos));
-	return len;
-}
-
-static int tmc_release(struct inode *inode, struct file *file)
-{
-	struct tmc_drvdata *drvdata = container_of(file->private_data,
-						   struct tmc_drvdata, miscdev);
-
-	if (--drvdata->read_count) {
-		if (drvdata->read_count < 0) {
-			dev_err(drvdata->dev, "mismatched close\n");
-			drvdata->read_count = 0;
-		}
-		goto out;
-	}
-
-	tmc_read_unprepare(drvdata);
-out:
-	dev_dbg(drvdata->dev, "%s: released\n", __func__);
-	return 0;
-}
-
-static const struct file_operations tmc_fops = {
-	.owner		= THIS_MODULE,
-	.open		= tmc_open,
-	.read		= tmc_read,
-	.release	= tmc_release,
-	.llseek		= no_llseek,
-};
-
-static ssize_t status_show(struct device *dev,
-			   struct device_attribute *attr, char *buf)
-{
-	int ret;
-	unsigned long flags;
-	u32 tmc_rsz, tmc_sts, tmc_rrp, tmc_rwp, tmc_trg;
-	u32 tmc_ctl, tmc_ffsr, tmc_ffcr, tmc_mode, tmc_pscr;
-	u32 devid;
-	struct tmc_drvdata *drvdata = dev_get_drvdata(dev->parent);
-
-	ret = clk_prepare_enable(drvdata->clk);
-	if (ret)
-		goto out;
-
-	spin_lock_irqsave(&drvdata->spinlock, flags);
-	CS_UNLOCK(drvdata->base);
-
-	tmc_rsz = readl_relaxed(drvdata->base + TMC_RSZ);
-	tmc_sts = readl_relaxed(drvdata->base + TMC_STS);
-	tmc_rrp = readl_relaxed(drvdata->base + TMC_RRP);
-	tmc_rwp = readl_relaxed(drvdata->base + TMC_RWP);
-	tmc_trg = readl_relaxed(drvdata->base + TMC_TRG);
-	tmc_ctl = readl_relaxed(drvdata->base + TMC_CTL);
-	tmc_ffsr = readl_relaxed(drvdata->base + TMC_FFSR);
-	tmc_ffcr = readl_relaxed(drvdata->base + TMC_FFCR);
-	tmc_mode = readl_relaxed(drvdata->base + TMC_MODE);
-	tmc_pscr = readl_relaxed(drvdata->base + TMC_PSCR);
-	devid = readl_relaxed(drvdata->base + CORESIGHT_DEVID);
-
-	CS_LOCK(drvdata->base);
-	spin_unlock_irqrestore(&drvdata->spinlock, flags);
-
-	clk_disable_unprepare(drvdata->clk);
-
-	return sprintf(buf,
-		       "Depth:\t\t0x%x\n"
-		       "Status:\t\t0x%x\n"
-		       "RAM read ptr:\t0x%x\n"
-		       "RAM wrt ptr:\t0x%x\n"
-		       "Trigger cnt:\t0x%x\n"
-		       "Control:\t0x%x\n"
-		       "Flush status:\t0x%x\n"
-		       "Flush ctrl:\t0x%x\n"
-		       "Mode:\t\t0x%x\n"
-		       "PSRC:\t\t0x%x\n"
-		       "DEVID:\t\t0x%x\n",
-			tmc_rsz, tmc_sts, tmc_rrp, tmc_rwp, tmc_trg,
-			tmc_ctl, tmc_ffsr, tmc_ffcr, tmc_mode, tmc_pscr, devid);
-out:
-	return -EINVAL;
-}
-static DEVICE_ATTR_RO(status);
-
-static ssize_t trigger_cntr_show(struct device *dev,
-			    struct device_attribute *attr, char *buf)
-{
-	struct tmc_drvdata *drvdata = dev_get_drvdata(dev->parent);
-	unsigned long val = drvdata->trigger_cntr;
-
-	return sprintf(buf, "%#lx\n", val);
-}
-
-static ssize_t trigger_cntr_store(struct device *dev,
-			     struct device_attribute *attr,
-			     const char *buf, size_t size)
-{
-	int ret;
-	unsigned long val;
-	struct tmc_drvdata *drvdata = dev_get_drvdata(dev->parent);
-
-	ret = kstrtoul(buf, 16, &val);
-	if (ret)
-		return ret;
-
-	drvdata->trigger_cntr = val;
-	return size;
-}
-static DEVICE_ATTR_RW(trigger_cntr);
-
-static struct attribute *coresight_etb_attrs[] = {
-	&dev_attr_trigger_cntr.attr,
-	&dev_attr_status.attr,
-	NULL,
-};
-ATTRIBUTE_GROUPS(coresight_etb);
-
-static struct attribute *coresight_etr_attrs[] = {
-	&dev_attr_trigger_cntr.attr,
-	&dev_attr_status.attr,
-	NULL,
-};
-ATTRIBUTE_GROUPS(coresight_etr);
-
-static struct attribute *coresight_etf_attrs[] = {
-	&dev_attr_trigger_cntr.attr,
-	&dev_attr_status.attr,
-	NULL,
-};
-ATTRIBUTE_GROUPS(coresight_etf);
-
-static int tmc_probe(struct amba_device *adev, const struct amba_id *id)
-{
-	int ret = 0;
-	u32 devid;
-	void __iomem *base;
-	struct device *dev = &adev->dev;
-	struct coresight_platform_data *pdata = NULL;
-	struct tmc_drvdata *drvdata;
-	struct resource *res = &adev->res;
-	struct coresight_desc *desc;
-	struct device_node *np = adev->dev.of_node;
-
-	if (np) {
-		pdata = of_get_coresight_platform_data(dev, np);
-		if (IS_ERR(pdata))
-			return PTR_ERR(pdata);
-		adev->dev.platform_data = pdata;
-	}
-
-	drvdata = devm_kzalloc(dev, sizeof(*drvdata), GFP_KERNEL);
-	if (!drvdata)
-		return -ENOMEM;
-
-	drvdata->dev = &adev->dev;
-	dev_set_drvdata(dev, drvdata);
-
-	/* Validity for the resource is already checked by the AMBA core */
-	base = devm_ioremap_resource(dev, res);
-	if (IS_ERR(base))
-		return PTR_ERR(base);
-
-	drvdata->base = base;
-
-	spin_lock_init(&drvdata->spinlock);
-
-	drvdata->clk = adev->pclk;
-	ret = clk_prepare_enable(drvdata->clk);
-	if (ret)
-		return ret;
-
-	devid = readl_relaxed(drvdata->base + CORESIGHT_DEVID);
-	drvdata->config_type = BMVAL(devid, 6, 7);
-
-	if (drvdata->config_type == TMC_CONFIG_TYPE_ETR) {
-		if (np)
-			ret = of_property_read_u32(np,
-						   "arm,buffer-size",
-						   &drvdata->size);
-		if (ret)
-			drvdata->size = SZ_1M;
-	} else {
-		drvdata->size = readl_relaxed(drvdata->base + TMC_RSZ) * 4;
-	}
-
-	clk_disable_unprepare(drvdata->clk);
-
-	if (drvdata->config_type == TMC_CONFIG_TYPE_ETR) {
-		drvdata->vaddr = dma_alloc_coherent(dev, drvdata->size,
-						&drvdata->paddr, GFP_KERNEL);
-		if (!drvdata->vaddr)
-			return -ENOMEM;
-
-		memset(drvdata->vaddr, 0, drvdata->size);
-		drvdata->buf = drvdata->vaddr;
-	} else {
-		drvdata->buf = devm_kzalloc(dev, drvdata->size, GFP_KERNEL);
-		if (!drvdata->buf)
-			return -ENOMEM;
-	}
-
-	desc = devm_kzalloc(dev, sizeof(*desc), GFP_KERNEL);
-	if (!desc) {
-		ret = -ENOMEM;
-		goto err_devm_kzalloc;
-	}
-
-	desc->pdata = pdata;
-	desc->dev = dev;
-	desc->subtype.sink_subtype = CORESIGHT_DEV_SUBTYPE_SINK_BUFFER;
-
-	if (drvdata->config_type == TMC_CONFIG_TYPE_ETB) {
-		desc->type = CORESIGHT_DEV_TYPE_SINK;
-		desc->ops = &tmc_etb_cs_ops;
-		desc->groups = coresight_etb_groups;
-	} else if (drvdata->config_type == TMC_CONFIG_TYPE_ETR) {
-		desc->type = CORESIGHT_DEV_TYPE_SINK;
-		desc->ops = &tmc_etr_cs_ops;
-		desc->groups = coresight_etr_groups;
-	} else {
-		desc->type = CORESIGHT_DEV_TYPE_LINKSINK;
-		desc->subtype.link_subtype = CORESIGHT_DEV_SUBTYPE_LINK_FIFO;
-		desc->ops = &tmc_etf_cs_ops;
-		desc->groups = coresight_etf_groups;
-	}
-
-	drvdata->csdev = coresight_register(desc);
-	if (IS_ERR(drvdata->csdev)) {
-		ret = PTR_ERR(drvdata->csdev);
-		goto err_devm_kzalloc;
-	}
-
-	drvdata->miscdev.name = pdata->name;
-	drvdata->miscdev.minor = MISC_DYNAMIC_MINOR;
-	drvdata->miscdev.fops = &tmc_fops;
-	ret = misc_register(&drvdata->miscdev);
-	if (ret)
-		goto err_misc_register;
-
-	dev_info(dev, "TMC initialized\n");
-	return 0;
-
-err_misc_register:
-	coresight_unregister(drvdata->csdev);
-err_devm_kzalloc:
-	if (drvdata->config_type == TMC_CONFIG_TYPE_ETR)
-		dma_free_coherent(dev, drvdata->size,
-				&drvdata->paddr, GFP_KERNEL);
-	return ret;
-}
-
-static int tmc_remove(struct amba_device *adev)
-{
-	struct tmc_drvdata *drvdata = amba_get_drvdata(adev);
-
-	misc_deregister(&drvdata->miscdev);
-	coresight_unregister(drvdata->csdev);
-	if (drvdata->config_type == TMC_CONFIG_TYPE_ETR)
-		dma_free_coherent(drvdata->dev, drvdata->size,
-				  &drvdata->paddr, GFP_KERNEL);
-
-	return 0;
-}
-
-static struct amba_id tmc_ids[] = {
-	{
-		.id     = 0x0003b961,
-		.mask   = 0x0003ffff,
-	},
-	{ 0, 0},
-};
-
-static struct amba_driver tmc_driver = {
-	.drv = {
-		.name   = "coresight-tmc",
-		.owner  = THIS_MODULE,
-	},
-	.probe		= tmc_probe,
-	.remove		= tmc_remove,
-	.id_table	= tmc_ids,
-};
-
-module_amba_driver(tmc_driver);
-
-MODULE_LICENSE("GPL v2");
-MODULE_DESCRIPTION("CoreSight Trace Memory Controller driver");
diff --git a/drivers/coresight/coresight-tpiu.c b/drivers/coresight/coresight-tpiu.c
deleted file mode 100644
index 3b33af2416bb..000000000000
--- a/drivers/coresight/coresight-tpiu.c
+++ /dev/null
@@ -1,207 +0,0 @@
-/* Copyright (c) 2011-2012, The Linux Foundation. All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 and
- * only version 2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- */
-
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/init.h>
-#include <linux/device.h>
-#include <linux/io.h>
-#include <linux/err.h>
-#include <linux/slab.h>
-#include <linux/clk.h>
-#include <linux/coresight.h>
-#include <linux/amba/bus.h>
-
-#include "coresight-priv.h"
-
-#define TPIU_SUPP_PORTSZ	0x000
-#define TPIU_CURR_PORTSZ	0x004
-#define TPIU_SUPP_TRIGMODES	0x100
-#define TPIU_TRIG_CNTRVAL	0x104
-#define TPIU_TRIG_MULT		0x108
-#define TPIU_SUPP_TESTPATM	0x200
-#define TPIU_CURR_TESTPATM	0x204
-#define TPIU_TEST_PATREPCNTR	0x208
-#define TPIU_FFSR		0x300
-#define TPIU_FFCR		0x304
-#define TPIU_FSYNC_CNTR		0x308
-#define TPIU_EXTCTL_INPORT	0x400
-#define TPIU_EXTCTL_OUTPORT	0x404
-#define TPIU_ITTRFLINACK	0xee4
-#define TPIU_ITTRFLIN		0xee8
-#define TPIU_ITATBDATA0		0xeec
-#define TPIU_ITATBCTR2		0xef0
-#define TPIU_ITATBCTR1		0xef4
-#define TPIU_ITATBCTR0		0xef8
-
-/** register definition **/
-/* FFCR - 0x304 */
-#define FFCR_FON_MAN		BIT(6)
-
-/**
- * @base:	memory mapped base address for this component.
- * @dev:	the device entity associated to this component.
- * @csdev:	component vitals needed by the framework.
- * @clk:	the clock this component is associated to.
- */
-struct tpiu_drvdata {
-	void __iomem		*base;
-	struct device		*dev;
-	struct coresight_device	*csdev;
-	struct clk		*clk;
-};
-
-static void tpiu_enable_hw(struct tpiu_drvdata *drvdata)
-{
-	CS_UNLOCK(drvdata->base);
-
-	/* TODO: fill this up */
-
-	CS_LOCK(drvdata->base);
-}
-
-static int tpiu_enable(struct coresight_device *csdev)
-{
-	struct tpiu_drvdata *drvdata = dev_get_drvdata(csdev->dev.parent);
-	int ret;
-
-	ret = clk_prepare_enable(drvdata->clk);
-	if (ret)
-		return ret;
-
-	tpiu_enable_hw(drvdata);
-
-	dev_info(drvdata->dev, "TPIU enabled\n");
-	return 0;
-}
-
-static void tpiu_disable_hw(struct tpiu_drvdata *drvdata)
-{
-	CS_UNLOCK(drvdata->base);
-
-	/* Clear formatter controle reg. */
-	writel_relaxed(0x0, drvdata->base + TPIU_FFCR);
-	/* Generate manual flush */
-	writel_relaxed(FFCR_FON_MAN, drvdata->base + TPIU_FFCR);
-
-	CS_LOCK(drvdata->base);
-}
-
-static void tpiu_disable(struct coresight_device *csdev)
-{
-	struct tpiu_drvdata *drvdata = dev_get_drvdata(csdev->dev.parent);
-
-	tpiu_disable_hw(drvdata);
-
-	clk_disable_unprepare(drvdata->clk);
-
-	dev_info(drvdata->dev, "TPIU disabled\n");
-}
-
-static const struct coresight_ops_sink tpiu_sink_ops = {
-	.enable		= tpiu_enable,
-	.disable	= tpiu_disable,
-};
-
-static const struct coresight_ops tpiu_cs_ops = {
-	.sink_ops	= &tpiu_sink_ops,
-};
-
-static int tpiu_probe(struct amba_device *adev, const struct amba_id *id)
-{
-	int ret;
-	void __iomem *base;
-	struct device *dev = &adev->dev;
-	struct coresight_platform_data *pdata = NULL;
-	struct tpiu_drvdata *drvdata;
-	struct resource *res = &adev->res;
-	struct coresight_desc *desc;
-	struct device_node *np = adev->dev.of_node;
-
-	if (np) {
-		pdata = of_get_coresight_platform_data(dev, np);
-		if (IS_ERR(pdata))
-			return PTR_ERR(pdata);
-		adev->dev.platform_data = pdata;
-	}
-
-	drvdata = devm_kzalloc(dev, sizeof(*drvdata), GFP_KERNEL);
-	if (!drvdata)
-		return -ENOMEM;
-
-	drvdata->dev = &adev->dev;
-	dev_set_drvdata(dev, drvdata);
-
-	/* Validity for the resource is already checked by the AMBA core */
-	base = devm_ioremap_resource(dev, res);
-	if (IS_ERR(base))
-		return PTR_ERR(base);
-
-	drvdata->base = base;
-
-	drvdata->clk = adev->pclk;
-	ret = clk_prepare_enable(drvdata->clk);
-	if (ret)
-		return ret;
-
-	/* Disable tpiu to support older devices */
-	tpiu_disable_hw(drvdata);
-
-	clk_disable_unprepare(drvdata->clk);
-
-	desc = devm_kzalloc(dev, sizeof(*desc), GFP_KERNEL);
-	if (!desc)
-		return -ENOMEM;
-
-	desc->type = CORESIGHT_DEV_TYPE_SINK;
-	desc->subtype.sink_subtype = CORESIGHT_DEV_SUBTYPE_SINK_PORT;
-	desc->ops = &tpiu_cs_ops;
-	desc->pdata = pdata;
-	desc->dev = dev;
-	drvdata->csdev = coresight_register(desc);
-	if (IS_ERR(drvdata->csdev))
-		return PTR_ERR(drvdata->csdev);
-
-	dev_info(dev, "TPIU initialized\n");
-	return 0;
-}
-
-static int tpiu_remove(struct amba_device *adev)
-{
-	struct tpiu_drvdata *drvdata = amba_get_drvdata(adev);
-
-	coresight_unregister(drvdata->csdev);
-	return 0;
-}
-
-static struct amba_id tpiu_ids[] = {
-	{
-		.id	= 0x0003b912,
-		.mask	= 0x0003ffff,
-	},
-	{ 0, 0},
-};
-
-static struct amba_driver tpiu_driver = {
-	.drv = {
-		.name	= "coresight-tpiu",
-		.owner	= THIS_MODULE,
-	},
-	.probe		= tpiu_probe,
-	.remove		= tpiu_remove,
-	.id_table	= tpiu_ids,
-};
-
-module_amba_driver(tpiu_driver);
-
-MODULE_LICENSE("GPL v2");
-MODULE_DESCRIPTION("CoreSight Trace Port Interface Unit driver");
diff --git a/drivers/coresight/coresight.c b/drivers/coresight/coresight.c
deleted file mode 100644
index 894531d315b8..000000000000
--- a/drivers/coresight/coresight.c
+++ /dev/null
@@ -1,720 +0,0 @@
-/* Copyright (c) 2012, The Linux Foundation. All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 and
- * only version 2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- */
-
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/init.h>
-#include <linux/types.h>
-#include <linux/device.h>
-#include <linux/io.h>
-#include <linux/err.h>
-#include <linux/export.h>
-#include <linux/slab.h>
-#include <linux/mutex.h>
-#include <linux/clk.h>
-#include <linux/coresight.h>
-#include <linux/of_platform.h>
-#include <linux/delay.h>
-
-#include "coresight-priv.h"
-
-static DEFINE_MUTEX(coresight_mutex);
-
-static int coresight_id_match(struct device *dev, void *data)
-{
-	int trace_id, i_trace_id;
-	struct coresight_device *csdev, *i_csdev;
-
-	csdev = data;
-	i_csdev = to_coresight_device(dev);
-
-	/*
-	 * No need to care about oneself and components that are not
-	 * sources or not enabled
-	 */
-	if (i_csdev == csdev || !i_csdev->enable ||
-	    i_csdev->type != CORESIGHT_DEV_TYPE_SOURCE)
-		return 0;
-
-	/* Get the source ID for both compoment */
-	trace_id = source_ops(csdev)->trace_id(csdev);
-	i_trace_id = source_ops(i_csdev)->trace_id(i_csdev);
-
-	/* All you need is one */
-	if (trace_id == i_trace_id)
-		return 1;
-
-	return 0;
-}
-
-static int coresight_source_is_unique(struct coresight_device *csdev)
-{
-	int trace_id = source_ops(csdev)->trace_id(csdev);
-
-	/* this shouldn't happen */
-	if (trace_id < 0)
-		return 0;
-
-	return !bus_for_each_dev(&coresight_bustype, NULL,
-				 csdev, coresight_id_match);
-}
-
-static int coresight_find_link_inport(struct coresight_device *csdev)
-{
-	int i;
-	struct coresight_device *parent;
-	struct coresight_connection *conn;
-
-	parent = container_of(csdev->path_link.next,
-			      struct coresight_device, path_link);
-
-	for (i = 0; i < parent->nr_outport; i++) {
-		conn = &parent->conns[i];
-		if (conn->child_dev == csdev)
-			return conn->child_port;
-	}
-
-	dev_err(&csdev->dev, "couldn't find inport, parent: %s, child: %s\n",
-		dev_name(&parent->dev), dev_name(&csdev->dev));
-
-	return 0;
-}
-
-static int coresight_find_link_outport(struct coresight_device *csdev)
-{
-	int i;
-	struct coresight_device *child;
-	struct coresight_connection *conn;
-
-	child = container_of(csdev->path_link.prev,
-			     struct coresight_device, path_link);
-
-	for (i = 0; i < csdev->nr_outport; i++) {
-		conn = &csdev->conns[i];
-		if (conn->child_dev == child)
-			return conn->outport;
-	}
-
-	dev_err(&csdev->dev, "couldn't find outport, parent: %s, child: %s\n",
-		dev_name(&csdev->dev), dev_name(&child->dev));
-
-	return 0;
-}
-
-static int coresight_enable_sink(struct coresight_device *csdev)
-{
-	int ret;
-
-	if (!csdev->enable) {
-		if (sink_ops(csdev)->enable) {
-			ret = sink_ops(csdev)->enable(csdev);
-			if (ret)
-				return ret;
-		}
-		csdev->enable = true;
-	}
-
-	atomic_inc(csdev->refcnt);
-
-	return 0;
-}
-
-static void coresight_disable_sink(struct coresight_device *csdev)
-{
-	if (atomic_dec_return(csdev->refcnt) == 0) {
-		if (sink_ops(csdev)->disable) {
-			sink_ops(csdev)->disable(csdev);
-			csdev->enable = false;
-		}
-	}
-}
-
-static int coresight_enable_link(struct coresight_device *csdev)
-{
-	int ret;
-	int link_subtype;
-	int refport, inport, outport;
-
-	inport = coresight_find_link_inport(csdev);
-	outport = coresight_find_link_outport(csdev);
-	link_subtype = csdev->subtype.link_subtype;
-
-	if (link_subtype == CORESIGHT_DEV_SUBTYPE_LINK_MERG)
-		refport = inport;
-	else if (link_subtype == CORESIGHT_DEV_SUBTYPE_LINK_SPLIT)
-		refport = outport;
-	else
-		refport = 0;
-
-	if (atomic_inc_return(&csdev->refcnt[refport]) == 1) {
-		if (link_ops(csdev)->enable) {
-			ret = link_ops(csdev)->enable(csdev, inport, outport);
-			if (ret)
-				return ret;
-		}
-	}
-
-	csdev->enable = true;
-
-	return 0;
-}
-
-static void coresight_disable_link(struct coresight_device *csdev)
-{
-	int i, nr_conns;
-	int link_subtype;
-	int refport, inport, outport;
-
-	inport = coresight_find_link_inport(csdev);
-	outport = coresight_find_link_outport(csdev);
-	link_subtype = csdev->subtype.link_subtype;
-
-	if (link_subtype == CORESIGHT_DEV_SUBTYPE_LINK_MERG) {
-		refport = inport;
-		nr_conns = csdev->nr_inport;
-	} else if (link_subtype == CORESIGHT_DEV_SUBTYPE_LINK_SPLIT) {
-		refport = outport;
-		nr_conns = csdev->nr_outport;
-	} else {
-		refport = 0;
-		nr_conns = 1;
-	}
-
-	if (atomic_dec_return(&csdev->refcnt[refport]) == 0) {
-		if (link_ops(csdev)->disable)
-			link_ops(csdev)->disable(csdev, inport, outport);
-	}
-
-	for (i = 0; i < nr_conns; i++)
-		if (atomic_read(&csdev->refcnt[i]) != 0)
-			return;
-
-	csdev->enable = false;
-}
-
-static int coresight_enable_source(struct coresight_device *csdev)
-{
-	int ret;
-
-	if (!coresight_source_is_unique(csdev)) {
-		dev_warn(&csdev->dev, "traceID %d not unique\n",
-			 source_ops(csdev)->trace_id(csdev));
-		return -EINVAL;
-	}
-
-	if (!csdev->enable) {
-		if (source_ops(csdev)->enable) {
-			ret = source_ops(csdev)->enable(csdev);
-			if (ret)
-				return ret;
-		}
-		csdev->enable = true;
-	}
-
-	atomic_inc(csdev->refcnt);
-
-	return 0;
-}
-
-static void coresight_disable_source(struct coresight_device *csdev)
-{
-	if (atomic_dec_return(csdev->refcnt) == 0) {
-		if (source_ops(csdev)->disable) {
-			source_ops(csdev)->disable(csdev);
-			csdev->enable = false;
-		}
-	}
-}
-
-static int coresight_enable_path(struct list_head *path)
-{
-	int ret = 0;
-	struct coresight_device *cd;
-
-	list_for_each_entry(cd, path, path_link) {
-		if (cd == list_first_entry(path, struct coresight_device,
-					   path_link)) {
-			ret = coresight_enable_sink(cd);
-		} else if (list_is_last(&cd->path_link, path)) {
-			/*
-			 * Don't enable the source just yet - this needs to
-			 * happen at the very end when all links and sink
-			 * along the path have been configured properly.
-			 */
-			;
-		} else {
-			ret = coresight_enable_link(cd);
-		}
-		if (ret)
-			goto err;
-	}
-
-	return 0;
-err:
-	list_for_each_entry_continue_reverse(cd, path, path_link) {
-		if (cd == list_first_entry(path, struct coresight_device,
-					   path_link)) {
-			coresight_disable_sink(cd);
-		} else if (list_is_last(&cd->path_link, path)) {
-			;
-		} else {
-			coresight_disable_link(cd);
-		}
-	}
-
-	return ret;
-}
-
-static int coresight_disable_path(struct list_head *path)
-{
-	struct coresight_device *cd;
-
-	list_for_each_entry_reverse(cd, path, path_link) {
-		if (cd == list_first_entry(path, struct coresight_device,
-					   path_link)) {
-			coresight_disable_sink(cd);
-		} else if (list_is_last(&cd->path_link, path)) {
-			/*
-			 * The source has already been stopped, no need
-			 * to do it again here.
-			 */
-			;
-		} else {
-			coresight_disable_link(cd);
-		}
-	}
-
-	return 0;
-}
-
-static int coresight_build_paths(struct coresight_device *csdev,
-				 struct list_head *path,
-				 bool enable)
-{
-	int i, ret = -EINVAL;
-	struct coresight_connection *conn;
-
-	list_add(&csdev->path_link, path);
-
-	if ((csdev->type == CORESIGHT_DEV_TYPE_SINK ||
-	    csdev->type == CORESIGHT_DEV_TYPE_LINKSINK) &&
-	    csdev->activated) {
-		if (enable)
-			ret = coresight_enable_path(path);
-		else
-			ret = coresight_disable_path(path);
-	} else {
-		for (i = 0; i < csdev->nr_outport; i++) {
-			conn = &csdev->conns[i];
-			if (coresight_build_paths(conn->child_dev,
-						    path, enable) == 0)
-				ret = 0;
-		}
-	}
-
-	if (list_first_entry(path, struct coresight_device, path_link) != csdev)
-		dev_err(&csdev->dev, "wrong device in %s\n", __func__);
-
-	list_del(&csdev->path_link);
-
-	return ret;
-}
-
-int coresight_enable(struct coresight_device *csdev)
-{
-	int ret = 0;
-	LIST_HEAD(path);
-
-	mutex_lock(&coresight_mutex);
-	if (csdev->type != CORESIGHT_DEV_TYPE_SOURCE) {
-		ret = -EINVAL;
-		dev_err(&csdev->dev, "wrong device type in %s\n", __func__);
-		goto out;
-	}
-	if (csdev->enable)
-		goto out;
-
-	if (coresight_build_paths(csdev, &path, true)) {
-		dev_err(&csdev->dev, "building path(s) failed\n");
-		goto out;
-	}
-
-	if (coresight_enable_source(csdev))
-		dev_err(&csdev->dev, "source enable failed\n");
-out:
-	mutex_unlock(&coresight_mutex);
-	return ret;
-}
-EXPORT_SYMBOL_GPL(coresight_enable);
-
-void coresight_disable(struct coresight_device *csdev)
-{
-	LIST_HEAD(path);
-
-	mutex_lock(&coresight_mutex);
-	if (csdev->type != CORESIGHT_DEV_TYPE_SOURCE) {
-		dev_err(&csdev->dev, "wrong device type in %s\n", __func__);
-		goto out;
-	}
-	if (!csdev->enable)
-		goto out;
-
-	coresight_disable_source(csdev);
-	if (coresight_build_paths(csdev, &path, false))
-		dev_err(&csdev->dev, "releasing path(s) failed\n");
-
-out:
-	mutex_unlock(&coresight_mutex);
-}
-EXPORT_SYMBOL_GPL(coresight_disable);
-
-static ssize_t enable_sink_show(struct device *dev,
-				struct device_attribute *attr, char *buf)
-{
-	struct coresight_device *csdev = to_coresight_device(dev);
-
-	return scnprintf(buf, PAGE_SIZE, "%u\n", (unsigned)csdev->activated);
-}
-
-static ssize_t enable_sink_store(struct device *dev,
-				 struct device_attribute *attr,
-				 const char *buf, size_t size)
-{
-	int ret;
-	unsigned long val;
-	struct coresight_device *csdev = to_coresight_device(dev);
-
-	ret = kstrtoul(buf, 10, &val);
-	if (ret)
-		return ret;
-
-	if (val)
-		csdev->activated = true;
-	else
-		csdev->activated = false;
-
-	return size;
-
-}
-static DEVICE_ATTR_RW(enable_sink);
-
-static ssize_t enable_source_show(struct device *dev,
-				  struct device_attribute *attr, char *buf)
-{
-	struct coresight_device *csdev = to_coresight_device(dev);
-
-	return scnprintf(buf, PAGE_SIZE, "%u\n", (unsigned)csdev->enable);
-}
-
-static ssize_t enable_source_store(struct device *dev,
-				   struct device_attribute *attr,
-				   const char *buf, size_t size)
-{
-	int ret = 0;
-	unsigned long val;
-	struct coresight_device *csdev = to_coresight_device(dev);
-
-	ret = kstrtoul(buf, 10, &val);
-	if (ret)
-		return ret;
-
-	if (val) {
-		ret = coresight_enable(csdev);
-		if (ret)
-			return ret;
-	} else {
-		coresight_disable(csdev);
-	}
-
-	return size;
-}
-static DEVICE_ATTR_RW(enable_source);
-
-static struct attribute *coresight_sink_attrs[] = {
-	&dev_attr_enable_sink.attr,
-	NULL,
-};
-ATTRIBUTE_GROUPS(coresight_sink);
-
-static struct attribute *coresight_source_attrs[] = {
-	&dev_attr_enable_source.attr,
-	NULL,
-};
-ATTRIBUTE_GROUPS(coresight_source);
-
-static struct device_type coresight_dev_type[] = {
-	{
-		.name = "none",
-	},
-	{
-		.name = "sink",
-		.groups = coresight_sink_groups,
-	},
-	{
-		.name = "link",
-	},
-	{
-		.name = "linksink",
-		.groups = coresight_sink_groups,
-	},
-	{
-		.name = "source",
-		.groups = coresight_source_groups,
-	},
-};
-
-static void coresight_device_release(struct device *dev)
-{
-	struct coresight_device *csdev = to_coresight_device(dev);
-
-	kfree(csdev);
-}
-
-static int coresight_orphan_match(struct device *dev, void *data)
-{
-	int i;
-	bool still_orphan = false;
-	struct coresight_device *csdev, *i_csdev;
-	struct coresight_connection *conn;
-
-	csdev = data;
-	i_csdev = to_coresight_device(dev);
-
-	/* No need to check oneself */
-	if (csdev == i_csdev)
-		return 0;
-
-	/* Move on to another component if no connection is orphan */
-	if (!i_csdev->orphan)
-		return 0;
-	/*
-	 * Circle throuch all the connection of that component.  If we find
-	 * an orphan connection whose name matches @csdev, link it.
-	 */
-	for (i = 0; i < i_csdev->nr_outport; i++) {
-		conn = &i_csdev->conns[i];
-
-		/* We have found at least one orphan connection */
-		if (conn->child_dev == NULL) {
-			/* Does it match this newly added device? */
-			if (!strcmp(dev_name(&csdev->dev), conn->child_name)) {
-				conn->child_dev = csdev;
-			} else {
-				/* This component still has an orphan */
-				still_orphan = true;
-			}
-		}
-	}
-
-	i_csdev->orphan = still_orphan;
-
-	/*
-	 * Returning '0' ensures that all known component on the
-	 * bus will be checked.
-	 */
-	return 0;
-}
-
-static void coresight_fixup_orphan_conns(struct coresight_device *csdev)
-{
-	/*
-	 * No need to check for a return value as orphan connection(s)
-	 * are hooked-up with each newly added component.
-	 */
-	bus_for_each_dev(&coresight_bustype, NULL,
-				 csdev, coresight_orphan_match);
-}
-
-
-static int coresight_name_match(struct device *dev, void *data)
-{
-	char *to_match;
-	struct coresight_device *i_csdev;
-
-	to_match = data;
-	i_csdev = to_coresight_device(dev);
-
-	if (!strcmp(to_match, dev_name(&i_csdev->dev)))
-		return 1;
-
-	return 0;
-}
-
-static void coresight_fixup_device_conns(struct coresight_device *csdev)
-{
-	int i;
-	struct device *dev = NULL;
-	struct coresight_connection *conn;
-
-	for (i = 0; i < csdev->nr_outport; i++) {
-		conn = &csdev->conns[i];
-		dev = bus_find_device(&coresight_bustype, NULL,
-				      (void *)conn->child_name,
-				      coresight_name_match);
-
-		if (dev) {
-			conn->child_dev = to_coresight_device(dev);
-		} else {
-			csdev->orphan = true;
-			conn->child_dev = NULL;
-		}
-	}
-}
-
-/**
- * coresight_timeout - loop until a bit has changed to a specific state.
- * @addr: base address of the area of interest.
- * @offset: address of a register, starting from @addr.
- * @position: the position of the bit of interest.
- * @value: the value the bit should have.
- *
- * Return: 0 as soon as the bit has taken the desired state or -EAGAIN if
- * TIMEOUT_US has elapsed, which ever happens first.
- */
-
-int coresight_timeout(void __iomem *addr, u32 offset, int position, int value)
-{
-	int i;
-	u32 val;
-
-	for (i = TIMEOUT_US; i > 0; i--) {
-		val = __raw_readl(addr + offset);
-		/* waiting on the bit to go from 0 to 1 */
-		if (value) {
-			if (val & BIT(position))
-				return 0;
-		/* waiting on the bit to go from 1 to 0 */
-		} else {
-			if (!(val & BIT(position)))
-				return 0;
-		}
-
-		/*
-		 * Delay is arbitrary - the specification doesn't say how long
-		 * we are expected to wait.  Extra check required to make sure
-		 * we don't wait needlessly on the last iteration.
-		 */
-		if (i - 1)
-			udelay(1);
-	}
-
-	return -EAGAIN;
-}
-
-struct bus_type coresight_bustype = {
-	.name	= "coresight",
-};
-
-static int __init coresight_init(void)
-{
-	return bus_register(&coresight_bustype);
-}
-postcore_initcall(coresight_init);
-
-struct coresight_device *coresight_register(struct coresight_desc *desc)
-{
-	int i;
-	int ret;
-	int link_subtype;
-	int nr_refcnts = 1;
-	atomic_t *refcnts = NULL;
-	struct coresight_device *csdev;
-	struct coresight_connection *conns;
-
-	csdev = kzalloc(sizeof(*csdev), GFP_KERNEL);
-	if (!csdev) {
-		ret = -ENOMEM;
-		goto err_kzalloc_csdev;
-	}
-
-	if (desc->type == CORESIGHT_DEV_TYPE_LINK ||
-	    desc->type == CORESIGHT_DEV_TYPE_LINKSINK) {
-		link_subtype = desc->subtype.link_subtype;
-
-		if (link_subtype == CORESIGHT_DEV_SUBTYPE_LINK_MERG)
-			nr_refcnts = desc->pdata->nr_inport;
-		else if (link_subtype == CORESIGHT_DEV_SUBTYPE_LINK_SPLIT)
-			nr_refcnts = desc->pdata->nr_outport;
-	}
-
-	refcnts = kcalloc(nr_refcnts, sizeof(*refcnts), GFP_KERNEL);
-	if (!refcnts) {
-		ret = -ENOMEM;
-		goto err_kzalloc_refcnts;
-	}
-
-	csdev->refcnt = refcnts;
-
-	csdev->nr_inport = desc->pdata->nr_inport;
-	csdev->nr_outport = desc->pdata->nr_outport;
-	conns = kcalloc(csdev->nr_outport, sizeof(*conns), GFP_KERNEL);
-	if (!conns) {
-		ret = -ENOMEM;
-		goto err_kzalloc_conns;
-	}
-
-	for (i = 0; i < csdev->nr_outport; i++) {
-		conns[i].outport = desc->pdata->outports[i];
-		conns[i].child_name = desc->pdata->child_names[i];
-		conns[i].child_port = desc->pdata->child_ports[i];
-	}
-
-	csdev->conns = conns;
-
-	csdev->type = desc->type;
-	csdev->subtype = desc->subtype;
-	csdev->ops = desc->ops;
-	csdev->orphan = false;
-
-	csdev->dev.type = &coresight_dev_type[desc->type];
-	csdev->dev.groups = desc->groups;
-	csdev->dev.parent = desc->dev;
-	csdev->dev.release = coresight_device_release;
-	csdev->dev.bus = &coresight_bustype;
-	dev_set_name(&csdev->dev, "%s", desc->pdata->name);
-
-	ret = device_register(&csdev->dev);
-	if (ret)
-		goto err_device_register;
-
-	mutex_lock(&coresight_mutex);
-
-	coresight_fixup_device_conns(csdev);
-	coresight_fixup_orphan_conns(csdev);
-
-	mutex_unlock(&coresight_mutex);
-
-	return csdev;
-
-err_device_register:
-	kfree(conns);
-err_kzalloc_conns:
-	kfree(refcnts);
-err_kzalloc_refcnts:
-	kfree(csdev);
-err_kzalloc_csdev:
-	return ERR_PTR(ret);
-}
-EXPORT_SYMBOL_GPL(coresight_register);
-
-void coresight_unregister(struct coresight_device *csdev)
-{
-	mutex_lock(&coresight_mutex);
-
-	kfree(csdev->conns);
-	device_unregister(&csdev->dev);
-
-	mutex_unlock(&coresight_mutex);
-}
-EXPORT_SYMBOL_GPL(coresight_unregister);
-
-MODULE_LICENSE("GPL v2");
diff --git a/drivers/coresight/of_coresight.c b/drivers/coresight/of_coresight.c
deleted file mode 100644
index f3cc8e97a0f8..000000000000
--- a/drivers/coresight/of_coresight.c
+++ /dev/null
@@ -1,200 +0,0 @@
-/* Copyright (c) 2012, The Linux Foundation. All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 and
- * only version 2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- */
-
-#include <linux/module.h>
-#include <linux/types.h>
-#include <linux/err.h>
-#include <linux/slab.h>
-#include <linux/clk.h>
-#include <linux/of.h>
-#include <linux/of_address.h>
-#include <linux/of_graph.h>
-#include <linux/of_platform.h>
-#include <linux/platform_device.h>
-#include <linux/amba/bus.h>
-#include <linux/coresight.h>
-#include <linux/cpumask.h>
-#include <asm/smp_plat.h>
-
-
-static int of_dev_node_match(struct device *dev, void *data)
-{
-	return dev->of_node == data;
-}
-
-static struct device *
-of_coresight_get_endpoint_device(struct device_node *endpoint)
-{
-	struct device *dev = NULL;
-
-	/*
-	 * If we have a non-configuable replicator, it will be found on the
-	 * platform bus.
-	 */
-	dev = bus_find_device(&platform_bus_type, NULL,
-			      endpoint, of_dev_node_match);
-	if (dev)
-		return dev;
-
-	/*
-	 * We have a configurable component - circle through the AMBA bus
-	 * looking for the device that matches the endpoint node.
-	 */
-	return bus_find_device(&amba_bustype, NULL,
-			       endpoint, of_dev_node_match);
-}
-
-static struct device_node *of_get_coresight_endpoint(
-		const struct device_node *parent, struct device_node *prev)
-{
-	struct device_node *node = of_graph_get_next_endpoint(parent, prev);
-
-	of_node_put(prev);
-	return node;
-}
-
-static void of_coresight_get_ports(struct device_node *node,
-				   int *nr_inport, int *nr_outport)
-{
-	struct device_node *ep = NULL;
-	int in = 0, out = 0;
-
-	do {
-		ep = of_get_coresight_endpoint(node, ep);
-		if (!ep)
-			break;
-
-		if (of_property_read_bool(ep, "slave-mode"))
-			in++;
-		else
-			out++;
-
-	} while (ep);
-
-	*nr_inport = in;
-	*nr_outport = out;
-}
-
-static int of_coresight_alloc_memory(struct device *dev,
-			struct coresight_platform_data *pdata)
-{
-	/* List of output port on this component */
-	pdata->outports = devm_kzalloc(dev, pdata->nr_outport *
-				       sizeof(*pdata->outports),
-				       GFP_KERNEL);
-	if (!pdata->outports)
-		return -ENOMEM;
-
-	/* Children connected to this component via @outports */
-	 pdata->child_names = devm_kzalloc(dev, pdata->nr_outport *
-					  sizeof(*pdata->child_names),
-					  GFP_KERNEL);
-	if (!pdata->child_names)
-		return -ENOMEM;
-
-	/* Port number on the child this component is connected to */
-	pdata->child_ports = devm_kzalloc(dev, pdata->nr_outport *
-					  sizeof(*pdata->child_ports),
-					  GFP_KERNEL);
-	if (!pdata->child_ports)
-		return -ENOMEM;
-
-	return 0;
-}
-
-struct coresight_platform_data *of_get_coresight_platform_data(
-				struct device *dev, struct device_node *node)
-{
-	int i = 0, ret = 0, cpu;
-	struct coresight_platform_data *pdata;
-	struct of_endpoint endpoint, rendpoint;
-	struct device *rdev;
-	struct device_node *dn;
-	struct device_node *ep = NULL;
-	struct device_node *rparent = NULL;
-	struct device_node *rport = NULL;
-
-	pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
-	if (!pdata)
-		return ERR_PTR(-ENOMEM);
-
-	/* Use device name as sysfs handle */
-	pdata->name = dev_name(dev);
-
-	/* Get the number of input and output port for this component */
-	of_coresight_get_ports(node, &pdata->nr_inport, &pdata->nr_outport);
-
-	if (pdata->nr_outport) {
-		ret = of_coresight_alloc_memory(dev, pdata);
-		if (ret)
-			return ERR_PTR(ret);
-
-		/* Iterate through each port to discover topology */
-		do {
-			/* Get a handle on a port */
-			ep = of_get_coresight_endpoint(node, ep);
-			if (!ep)
-				break;
-
-			/*
-			 * No need to deal with input ports, processing for as
-			 * processing for output ports will deal with them.
-			 */
-			if (of_find_property(ep, "slave-mode", NULL))
-				continue;
-
-			/* Get a handle on the local endpoint */
-			ret = of_graph_parse_endpoint(ep, &endpoint);
-
-			if (ret)
-				continue;
-
-			/* The local out port number */
-			pdata->outports[i] = endpoint.id;
-
-			/*
-			 * Get a handle on the remote port and parent
-			 * attached to it.
-			 */
-			rparent = of_graph_get_remote_port_parent(ep);
-			rport = of_graph_get_remote_port(ep);
-
-			if (!rparent || !rport)
-				continue;
-
-			if (of_graph_parse_endpoint(rport, &rendpoint))
-				continue;
-
-			rdev = of_coresight_get_endpoint_device(rparent);
-			if (!rdev)
-				continue;
-
-			pdata->child_names[i] = dev_name(rdev);
-			pdata->child_ports[i] = rendpoint.id;
-
-			i++;
-		} while (ep);
-	}
-
-	/* Affinity defaults to CPU0 */
-	pdata->cpu = 0;
-	dn = of_parse_phandle(node, "cpu", 0);
-	for (cpu = 0; dn && cpu < nr_cpu_ids; cpu++) {
-		if (dn == of_get_cpu_node(cpu, NULL)) {
-			pdata->cpu = cpu;
-			break;
-		}
-	}
-
-	return pdata;
-}
-EXPORT_SYMBOL_GPL(of_get_coresight_platform_data);
diff --git a/drivers/hwtracing/coresight/Kconfig b/drivers/hwtracing/coresight/Kconfig
new file mode 100644
index 000000000000..fc1f1ae7a49d
--- /dev/null
+++ b/drivers/hwtracing/coresight/Kconfig
@@ -0,0 +1,61 @@
+#
+# Coresight configuration
+#
+menuconfig CORESIGHT
+	bool "CoreSight Tracing Support"
+	select ARM_AMBA
+	help
+	  This framework provides a kernel interface for the CoreSight debug
+	  and trace drivers to register themselves with. It's intended to build
+	  a topological view of the CoreSight components based on a DT
+	  specification and configure the right serie of components when a
+	  trace source gets enabled.
+
+if CORESIGHT
+config CORESIGHT_LINKS_AND_SINKS
+	bool "CoreSight Link and Sink drivers"
+	help
+	  This enables support for CoreSight link and sink drivers that are
+	  responsible for transporting and collecting the trace data
+	  respectively.  Link and sinks are dynamically aggregated with a trace
+	  entity at run time to form a complete trace path.
+
+config CORESIGHT_LINK_AND_SINK_TMC
+	bool "Coresight generic TMC driver"
+	depends on CORESIGHT_LINKS_AND_SINKS
+	help
+	  This enables support for the Trace Memory Controller driver.
+	  Depending on its configuration the device can act as a link (embedded
+	  trace router - ETR) or sink (embedded trace FIFO).  The driver
+	  complies with the generic implementation of the component without
+	  special enhancement or added features.
+
+config CORESIGHT_SINK_TPIU
+	bool "Coresight generic TPIU driver"
+	depends on CORESIGHT_LINKS_AND_SINKS
+	help
+	  This enables support for the Trace Port Interface Unit driver,
+	  responsible for bridging the gap between the on-chip coresight
+	  components and a trace for bridging the gap between the on-chip
+	  coresight components and a trace port collection engine, typically
+	  connected to an external host for use case capturing more traces than
+	  the on-board coresight memory can handle.
+
+config CORESIGHT_SINK_ETBV10
+	bool "Coresight ETBv1.0 driver"
+	depends on CORESIGHT_LINKS_AND_SINKS
+	help
+	  This enables support for the Embedded Trace Buffer version 1.0 driver
+	  that complies with the generic implementation of the component without
+	  special enhancement or added features.
+
+config CORESIGHT_SOURCE_ETM3X
+	bool "CoreSight Embedded Trace Macrocell 3.x driver"
+	depends on !ARM64
+	select CORESIGHT_LINKS_AND_SINKS
+	help
+	  This driver provides support for processor ETM3.x and PTM1.x modules,
+	  which allows tracing the instructions that a processor is executing
+	  This is primarily useful for instruction level tracing.  Depending
+	  the ETM version data tracing may also be available.
+endif
diff --git a/drivers/hwtracing/coresight/Makefile b/drivers/hwtracing/coresight/Makefile
new file mode 100644
index 000000000000..4b4bec890ef5
--- /dev/null
+++ b/drivers/hwtracing/coresight/Makefile
@@ -0,0 +1,11 @@
+#
+# Makefile for CoreSight drivers.
+#
+obj-$(CONFIG_CORESIGHT) += coresight.o
+obj-$(CONFIG_OF) += of_coresight.o
+obj-$(CONFIG_CORESIGHT_LINK_AND_SINK_TMC) += coresight-tmc.o
+obj-$(CONFIG_CORESIGHT_SINK_TPIU) += coresight-tpiu.o
+obj-$(CONFIG_CORESIGHT_SINK_ETBV10) += coresight-etb10.o
+obj-$(CONFIG_CORESIGHT_LINKS_AND_SINKS) += coresight-funnel.o \
+					   coresight-replicator.o
+obj-$(CONFIG_CORESIGHT_SOURCE_ETM3X) += coresight-etm3x.o coresight-etm-cp14.o
diff --git a/drivers/hwtracing/coresight/coresight-etb10.c b/drivers/hwtracing/coresight/coresight-etb10.c
new file mode 100644
index 000000000000..40049869aecd
--- /dev/null
+++ b/drivers/hwtracing/coresight/coresight-etb10.c
@@ -0,0 +1,527 @@
+/* Copyright (c) 2011-2012, The Linux Foundation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/types.h>
+#include <linux/device.h>
+#include <linux/io.h>
+#include <linux/err.h>
+#include <linux/fs.h>
+#include <linux/miscdevice.h>
+#include <linux/uaccess.h>
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+#include <linux/clk.h>
+#include <linux/seq_file.h>
+#include <linux/coresight.h>
+#include <linux/amba/bus.h>
+
+#include "coresight-priv.h"
+
+#define ETB_RAM_DEPTH_REG	0x004
+#define ETB_STATUS_REG		0x00c
+#define ETB_RAM_READ_DATA_REG	0x010
+#define ETB_RAM_READ_POINTER	0x014
+#define ETB_RAM_WRITE_POINTER	0x018
+#define ETB_TRG			0x01c
+#define ETB_CTL_REG		0x020
+#define ETB_RWD_REG		0x024
+#define ETB_FFSR		0x300
+#define ETB_FFCR		0x304
+#define ETB_ITMISCOP0		0xee0
+#define ETB_ITTRFLINACK		0xee4
+#define ETB_ITTRFLIN		0xee8
+#define ETB_ITATBDATA0		0xeeC
+#define ETB_ITATBCTR2		0xef0
+#define ETB_ITATBCTR1		0xef4
+#define ETB_ITATBCTR0		0xef8
+
+/* register description */
+/* STS - 0x00C */
+#define ETB_STATUS_RAM_FULL	BIT(0)
+/* CTL - 0x020 */
+#define ETB_CTL_CAPT_EN		BIT(0)
+/* FFCR - 0x304 */
+#define ETB_FFCR_EN_FTC		BIT(0)
+#define ETB_FFCR_FON_MAN	BIT(6)
+#define ETB_FFCR_STOP_FI	BIT(12)
+#define ETB_FFCR_STOP_TRIGGER	BIT(13)
+
+#define ETB_FFCR_BIT		6
+#define ETB_FFSR_BIT		1
+#define ETB_FRAME_SIZE_WORDS	4
+
+/**
+ * struct etb_drvdata - specifics associated to an ETB component
+ * @base:	memory mapped base address for this component.
+ * @dev:	the device entity associated to this component.
+ * @csdev:	component vitals needed by the framework.
+ * @miscdev:	specifics to handle "/dev/xyz.etb" entry.
+ * @clk:	the clock this component is associated to.
+ * @spinlock:	only one at a time pls.
+ * @in_use:	synchronise user space access to etb buffer.
+ * @buf:	area of memory where ETB buffer content gets sent.
+ * @buffer_depth: size of @buf.
+ * @enable:	this ETB is being used.
+ * @trigger_cntr: amount of words to store after a trigger.
+ */
+struct etb_drvdata {
+	void __iomem		*base;
+	struct device		*dev;
+	struct coresight_device	*csdev;
+	struct miscdevice	miscdev;
+	struct clk		*clk;
+	spinlock_t		spinlock;
+	atomic_t		in_use;
+	u8			*buf;
+	u32			buffer_depth;
+	bool			enable;
+	u32			trigger_cntr;
+};
+
+static unsigned int etb_get_buffer_depth(struct etb_drvdata *drvdata)
+{
+	int ret;
+	u32 depth = 0;
+
+	ret = clk_prepare_enable(drvdata->clk);
+	if (ret)
+		return ret;
+
+	/* RO registers don't need locking */
+	depth = readl_relaxed(drvdata->base + ETB_RAM_DEPTH_REG);
+
+	clk_disable_unprepare(drvdata->clk);
+	return depth;
+}
+
+static void etb_enable_hw(struct etb_drvdata *drvdata)
+{
+	int i;
+	u32 depth;
+
+	CS_UNLOCK(drvdata->base);
+
+	depth = drvdata->buffer_depth;
+	/* reset write RAM pointer address */
+	writel_relaxed(0x0, drvdata->base + ETB_RAM_WRITE_POINTER);
+	/* clear entire RAM buffer */
+	for (i = 0; i < depth; i++)
+		writel_relaxed(0x0, drvdata->base + ETB_RWD_REG);
+
+	/* reset write RAM pointer address */
+	writel_relaxed(0x0, drvdata->base + ETB_RAM_WRITE_POINTER);
+	/* reset read RAM pointer address */
+	writel_relaxed(0x0, drvdata->base + ETB_RAM_READ_POINTER);
+
+	writel_relaxed(drvdata->trigger_cntr, drvdata->base + ETB_TRG);
+	writel_relaxed(ETB_FFCR_EN_FTC | ETB_FFCR_STOP_TRIGGER,
+		       drvdata->base + ETB_FFCR);
+	/* ETB trace capture enable */
+	writel_relaxed(ETB_CTL_CAPT_EN, drvdata->base + ETB_CTL_REG);
+
+	CS_LOCK(drvdata->base);
+}
+
+static int etb_enable(struct coresight_device *csdev)
+{
+	struct etb_drvdata *drvdata = dev_get_drvdata(csdev->dev.parent);
+	int ret;
+	unsigned long flags;
+
+	ret = clk_prepare_enable(drvdata->clk);
+	if (ret)
+		return ret;
+
+	spin_lock_irqsave(&drvdata->spinlock, flags);
+	etb_enable_hw(drvdata);
+	drvdata->enable = true;
+	spin_unlock_irqrestore(&drvdata->spinlock, flags);
+
+	dev_info(drvdata->dev, "ETB enabled\n");
+	return 0;
+}
+
+static void etb_disable_hw(struct etb_drvdata *drvdata)
+{
+	u32 ffcr;
+
+	CS_UNLOCK(drvdata->base);
+
+	ffcr = readl_relaxed(drvdata->base + ETB_FFCR);
+	/* stop formatter when a stop has completed */
+	ffcr |= ETB_FFCR_STOP_FI;
+	writel_relaxed(ffcr, drvdata->base + ETB_FFCR);
+	/* manually generate a flush of the system */
+	ffcr |= ETB_FFCR_FON_MAN;
+	writel_relaxed(ffcr, drvdata->base + ETB_FFCR);
+
+	if (coresight_timeout(drvdata->base, ETB_FFCR, ETB_FFCR_BIT, 0)) {
+		dev_err(drvdata->dev,
+			"timeout observed when probing at offset %#x\n",
+			ETB_FFCR);
+	}
+
+	/* disable trace capture */
+	writel_relaxed(0x0, drvdata->base + ETB_CTL_REG);
+
+	if (coresight_timeout(drvdata->base, ETB_FFSR, ETB_FFSR_BIT, 1)) {
+		dev_err(drvdata->dev,
+			"timeout observed when probing at offset %#x\n",
+			ETB_FFCR);
+	}
+
+	CS_LOCK(drvdata->base);
+}
+
+static void etb_dump_hw(struct etb_drvdata *drvdata)
+{
+	int i;
+	u8 *buf_ptr;
+	u32 read_data, depth;
+	u32 read_ptr, write_ptr;
+	u32 frame_off, frame_endoff;
+
+	CS_UNLOCK(drvdata->base);
+
+	read_ptr = readl_relaxed(drvdata->base + ETB_RAM_READ_POINTER);
+	write_ptr = readl_relaxed(drvdata->base + ETB_RAM_WRITE_POINTER);
+
+	frame_off = write_ptr % ETB_FRAME_SIZE_WORDS;
+	frame_endoff = ETB_FRAME_SIZE_WORDS - frame_off;
+	if (frame_off) {
+		dev_err(drvdata->dev,
+			"write_ptr: %lu not aligned to formatter frame size\n",
+			(unsigned long)write_ptr);
+		dev_err(drvdata->dev, "frameoff: %lu, frame_endoff: %lu\n",
+			(unsigned long)frame_off, (unsigned long)frame_endoff);
+		write_ptr += frame_endoff;
+	}
+
+	if ((readl_relaxed(drvdata->base + ETB_STATUS_REG)
+		      & ETB_STATUS_RAM_FULL) == 0)
+		writel_relaxed(0x0, drvdata->base + ETB_RAM_READ_POINTER);
+	else
+		writel_relaxed(write_ptr, drvdata->base + ETB_RAM_READ_POINTER);
+
+	depth = drvdata->buffer_depth;
+	buf_ptr = drvdata->buf;
+	for (i = 0; i < depth; i++) {
+		read_data = readl_relaxed(drvdata->base +
+					  ETB_RAM_READ_DATA_REG);
+		*buf_ptr++ = read_data >> 0;
+		*buf_ptr++ = read_data >> 8;
+		*buf_ptr++ = read_data >> 16;
+		*buf_ptr++ = read_data >> 24;
+	}
+
+	if (frame_off) {
+		buf_ptr -= (frame_endoff * 4);
+		for (i = 0; i < frame_endoff; i++) {
+			*buf_ptr++ = 0x0;
+			*buf_ptr++ = 0x0;
+			*buf_ptr++ = 0x0;
+			*buf_ptr++ = 0x0;
+		}
+	}
+
+	writel_relaxed(read_ptr, drvdata->base + ETB_RAM_READ_POINTER);
+
+	CS_LOCK(drvdata->base);
+}
+
+static void etb_disable(struct coresight_device *csdev)
+{
+	struct etb_drvdata *drvdata = dev_get_drvdata(csdev->dev.parent);
+	unsigned long flags;
+
+	spin_lock_irqsave(&drvdata->spinlock, flags);
+	etb_disable_hw(drvdata);
+	etb_dump_hw(drvdata);
+	drvdata->enable = false;
+	spin_unlock_irqrestore(&drvdata->spinlock, flags);
+
+	clk_disable_unprepare(drvdata->clk);
+
+	dev_info(drvdata->dev, "ETB disabled\n");
+}
+
+static const struct coresight_ops_sink etb_sink_ops = {
+	.enable		= etb_enable,
+	.disable	= etb_disable,
+};
+
+static const struct coresight_ops etb_cs_ops = {
+	.sink_ops	= &etb_sink_ops,
+};
+
+static void etb_dump(struct etb_drvdata *drvdata)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&drvdata->spinlock, flags);
+	if (drvdata->enable) {
+		etb_disable_hw(drvdata);
+		etb_dump_hw(drvdata);
+		etb_enable_hw(drvdata);
+	}
+	spin_unlock_irqrestore(&drvdata->spinlock, flags);
+
+	dev_info(drvdata->dev, "ETB dumped\n");
+}
+
+static int etb_open(struct inode *inode, struct file *file)
+{
+	struct etb_drvdata *drvdata = container_of(file->private_data,
+						   struct etb_drvdata, miscdev);
+
+	if (atomic_cmpxchg(&drvdata->in_use, 0, 1))
+		return -EBUSY;
+
+	dev_dbg(drvdata->dev, "%s: successfully opened\n", __func__);
+	return 0;
+}
+
+static ssize_t etb_read(struct file *file, char __user *data,
+				size_t len, loff_t *ppos)
+{
+	u32 depth;
+	struct etb_drvdata *drvdata = container_of(file->private_data,
+						   struct etb_drvdata, miscdev);
+
+	etb_dump(drvdata);
+
+	depth = drvdata->buffer_depth;
+	if (*ppos + len > depth * 4)
+		len = depth * 4 - *ppos;
+
+	if (copy_to_user(data, drvdata->buf + *ppos, len)) {
+		dev_dbg(drvdata->dev, "%s: copy_to_user failed\n", __func__);
+		return -EFAULT;
+	}
+
+	*ppos += len;
+
+	dev_dbg(drvdata->dev, "%s: %zu bytes copied, %d bytes left\n",
+		__func__, len, (int)(depth * 4 - *ppos));
+	return len;
+}
+
+static int etb_release(struct inode *inode, struct file *file)
+{
+	struct etb_drvdata *drvdata = container_of(file->private_data,
+						   struct etb_drvdata, miscdev);
+	atomic_set(&drvdata->in_use, 0);
+
+	dev_dbg(drvdata->dev, "%s: released\n", __func__);
+	return 0;
+}
+
+static const struct file_operations etb_fops = {
+	.owner		= THIS_MODULE,
+	.open		= etb_open,
+	.read		= etb_read,
+	.release	= etb_release,
+	.llseek		= no_llseek,
+};
+
+static ssize_t status_show(struct device *dev,
+			   struct device_attribute *attr, char *buf)
+{
+	int ret;
+	unsigned long flags;
+	u32 etb_rdr, etb_sr, etb_rrp, etb_rwp;
+	u32 etb_trg, etb_cr, etb_ffsr, etb_ffcr;
+	struct etb_drvdata *drvdata = dev_get_drvdata(dev->parent);
+
+	ret = clk_prepare_enable(drvdata->clk);
+	if (ret)
+		goto out;
+
+	spin_lock_irqsave(&drvdata->spinlock, flags);
+	CS_UNLOCK(drvdata->base);
+
+	etb_rdr = readl_relaxed(drvdata->base + ETB_RAM_DEPTH_REG);
+	etb_sr = readl_relaxed(drvdata->base + ETB_STATUS_REG);
+	etb_rrp = readl_relaxed(drvdata->base + ETB_RAM_READ_POINTER);
+	etb_rwp = readl_relaxed(drvdata->base + ETB_RAM_WRITE_POINTER);
+	etb_trg = readl_relaxed(drvdata->base + ETB_TRG);
+	etb_cr = readl_relaxed(drvdata->base + ETB_CTL_REG);
+	etb_ffsr = readl_relaxed(drvdata->base + ETB_FFSR);
+	etb_ffcr = readl_relaxed(drvdata->base + ETB_FFCR);
+
+	CS_LOCK(drvdata->base);
+	spin_unlock_irqrestore(&drvdata->spinlock, flags);
+
+	clk_disable_unprepare(drvdata->clk);
+
+	return sprintf(buf,
+		       "Depth:\t\t0x%x\n"
+		       "Status:\t\t0x%x\n"
+		       "RAM read ptr:\t0x%x\n"
+		       "RAM wrt ptr:\t0x%x\n"
+		       "Trigger cnt:\t0x%x\n"
+		       "Control:\t0x%x\n"
+		       "Flush status:\t0x%x\n"
+		       "Flush ctrl:\t0x%x\n",
+		       etb_rdr, etb_sr, etb_rrp, etb_rwp,
+		       etb_trg, etb_cr, etb_ffsr, etb_ffcr);
+out:
+	return -EINVAL;
+}
+static DEVICE_ATTR_RO(status);
+
+static ssize_t trigger_cntr_show(struct device *dev,
+			    struct device_attribute *attr, char *buf)
+{
+	struct etb_drvdata *drvdata = dev_get_drvdata(dev->parent);
+	unsigned long val = drvdata->trigger_cntr;
+
+	return sprintf(buf, "%#lx\n", val);
+}
+
+static ssize_t trigger_cntr_store(struct device *dev,
+			     struct device_attribute *attr,
+			     const char *buf, size_t size)
+{
+	int ret;
+	unsigned long val;
+	struct etb_drvdata *drvdata = dev_get_drvdata(dev->parent);
+
+	ret = kstrtoul(buf, 16, &val);
+	if (ret)
+		return ret;
+
+	drvdata->trigger_cntr = val;
+	return size;
+}
+static DEVICE_ATTR_RW(trigger_cntr);
+
+static struct attribute *coresight_etb_attrs[] = {
+	&dev_attr_trigger_cntr.attr,
+	&dev_attr_status.attr,
+	NULL,
+};
+ATTRIBUTE_GROUPS(coresight_etb);
+
+static int etb_probe(struct amba_device *adev, const struct amba_id *id)
+{
+	int ret;
+	void __iomem *base;
+	struct device *dev = &adev->dev;
+	struct coresight_platform_data *pdata = NULL;
+	struct etb_drvdata *drvdata;
+	struct resource *res = &adev->res;
+	struct coresight_desc *desc;
+	struct device_node *np = adev->dev.of_node;
+
+	if (np) {
+		pdata = of_get_coresight_platform_data(dev, np);
+		if (IS_ERR(pdata))
+			return PTR_ERR(pdata);
+		adev->dev.platform_data = pdata;
+	}
+
+	drvdata = devm_kzalloc(dev, sizeof(*drvdata), GFP_KERNEL);
+	if (!drvdata)
+		return -ENOMEM;
+
+	drvdata->dev = &adev->dev;
+	dev_set_drvdata(dev, drvdata);
+
+	/* validity for the resource is already checked by the AMBA core */
+	base = devm_ioremap_resource(dev, res);
+	if (IS_ERR(base))
+		return PTR_ERR(base);
+
+	drvdata->base = base;
+
+	spin_lock_init(&drvdata->spinlock);
+
+	drvdata->clk = adev->pclk;
+	ret = clk_prepare_enable(drvdata->clk);
+	if (ret)
+		return ret;
+
+	drvdata->buffer_depth = etb_get_buffer_depth(drvdata);
+	clk_disable_unprepare(drvdata->clk);
+
+	if (drvdata->buffer_depth < 0)
+		return -EINVAL;
+
+	drvdata->buf = devm_kzalloc(dev,
+				    drvdata->buffer_depth * 4, GFP_KERNEL);
+	if (!drvdata->buf)
+		return -ENOMEM;
+
+	desc = devm_kzalloc(dev, sizeof(*desc), GFP_KERNEL);
+	if (!desc)
+		return -ENOMEM;
+
+	desc->type = CORESIGHT_DEV_TYPE_SINK;
+	desc->subtype.sink_subtype = CORESIGHT_DEV_SUBTYPE_SINK_BUFFER;
+	desc->ops = &etb_cs_ops;
+	desc->pdata = pdata;
+	desc->dev = dev;
+	desc->groups = coresight_etb_groups;
+	drvdata->csdev = coresight_register(desc);
+	if (IS_ERR(drvdata->csdev))
+		return PTR_ERR(drvdata->csdev);
+
+	drvdata->miscdev.name = pdata->name;
+	drvdata->miscdev.minor = MISC_DYNAMIC_MINOR;
+	drvdata->miscdev.fops = &etb_fops;
+	ret = misc_register(&drvdata->miscdev);
+	if (ret)
+		goto err_misc_register;
+
+	dev_info(dev, "ETB initialized\n");
+	return 0;
+
+err_misc_register:
+	coresight_unregister(drvdata->csdev);
+	return ret;
+}
+
+static int etb_remove(struct amba_device *adev)
+{
+	struct etb_drvdata *drvdata = amba_get_drvdata(adev);
+
+	misc_deregister(&drvdata->miscdev);
+	coresight_unregister(drvdata->csdev);
+	return 0;
+}
+
+static struct amba_id etb_ids[] = {
+	{
+		.id	= 0x0003b907,
+		.mask	= 0x0003ffff,
+	},
+	{ 0, 0},
+};
+
+static struct amba_driver etb_driver = {
+	.drv = {
+		.name	= "coresight-etb10",
+		.owner	= THIS_MODULE,
+	},
+	.probe		= etb_probe,
+	.remove		= etb_remove,
+	.id_table	= etb_ids,
+};
+
+module_amba_driver(etb_driver);
+
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("CoreSight Embedded Trace Buffer driver");
diff --git a/drivers/hwtracing/coresight/coresight-etm-cp14.c b/drivers/hwtracing/coresight/coresight-etm-cp14.c
new file mode 100644
index 000000000000..12a220682117
--- /dev/null
+++ b/drivers/hwtracing/coresight/coresight-etm-cp14.c
@@ -0,0 +1,591 @@
+/* Copyright (c) 2012, The Linux Foundation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/kernel.h>
+#include <linux/types.h>
+#include <linux/bug.h>
+#include <asm/hardware/cp14.h>
+
+#include "coresight-etm.h"
+
+int etm_readl_cp14(u32 reg, unsigned int *val)
+{
+	switch (reg) {
+	case ETMCR:
+		*val = etm_read(ETMCR);
+		return 0;
+	case ETMCCR:
+		*val = etm_read(ETMCCR);
+		return 0;
+	case ETMTRIGGER:
+		*val = etm_read(ETMTRIGGER);
+		return 0;
+	case ETMSR:
+		*val = etm_read(ETMSR);
+		return 0;
+	case ETMSCR:
+		*val = etm_read(ETMSCR);
+		return 0;
+	case ETMTSSCR:
+		*val = etm_read(ETMTSSCR);
+		return 0;
+	case ETMTEEVR:
+		*val = etm_read(ETMTEEVR);
+		return 0;
+	case ETMTECR1:
+		*val = etm_read(ETMTECR1);
+		return 0;
+	case ETMFFLR:
+		*val = etm_read(ETMFFLR);
+		return 0;
+	case ETMACVRn(0):
+		*val = etm_read(ETMACVR0);
+		return 0;
+	case ETMACVRn(1):
+		*val = etm_read(ETMACVR1);
+		return 0;
+	case ETMACVRn(2):
+		*val = etm_read(ETMACVR2);
+		return 0;
+	case ETMACVRn(3):
+		*val = etm_read(ETMACVR3);
+		return 0;
+	case ETMACVRn(4):
+		*val = etm_read(ETMACVR4);
+		return 0;
+	case ETMACVRn(5):
+		*val = etm_read(ETMACVR5);
+		return 0;
+	case ETMACVRn(6):
+		*val = etm_read(ETMACVR6);
+		return 0;
+	case ETMACVRn(7):
+		*val = etm_read(ETMACVR7);
+		return 0;
+	case ETMACVRn(8):
+		*val = etm_read(ETMACVR8);
+		return 0;
+	case ETMACVRn(9):
+		*val = etm_read(ETMACVR9);
+		return 0;
+	case ETMACVRn(10):
+		*val = etm_read(ETMACVR10);
+		return 0;
+	case ETMACVRn(11):
+		*val = etm_read(ETMACVR11);
+		return 0;
+	case ETMACVRn(12):
+		*val = etm_read(ETMACVR12);
+		return 0;
+	case ETMACVRn(13):
+		*val = etm_read(ETMACVR13);
+		return 0;
+	case ETMACVRn(14):
+		*val = etm_read(ETMACVR14);
+		return 0;
+	case ETMACVRn(15):
+		*val = etm_read(ETMACVR15);
+		return 0;
+	case ETMACTRn(0):
+		*val = etm_read(ETMACTR0);
+		return 0;
+	case ETMACTRn(1):
+		*val = etm_read(ETMACTR1);
+		return 0;
+	case ETMACTRn(2):
+		*val = etm_read(ETMACTR2);
+		return 0;
+	case ETMACTRn(3):
+		*val = etm_read(ETMACTR3);
+		return 0;
+	case ETMACTRn(4):
+		*val = etm_read(ETMACTR4);
+		return 0;
+	case ETMACTRn(5):
+		*val = etm_read(ETMACTR5);
+		return 0;
+	case ETMACTRn(6):
+		*val = etm_read(ETMACTR6);
+		return 0;
+	case ETMACTRn(7):
+		*val = etm_read(ETMACTR7);
+		return 0;
+	case ETMACTRn(8):
+		*val = etm_read(ETMACTR8);
+		return 0;
+	case ETMACTRn(9):
+		*val = etm_read(ETMACTR9);
+		return 0;
+	case ETMACTRn(10):
+		*val = etm_read(ETMACTR10);
+		return 0;
+	case ETMACTRn(11):
+		*val = etm_read(ETMACTR11);
+		return 0;
+	case ETMACTRn(12):
+		*val = etm_read(ETMACTR12);
+		return 0;
+	case ETMACTRn(13):
+		*val = etm_read(ETMACTR13);
+		return 0;
+	case ETMACTRn(14):
+		*val = etm_read(ETMACTR14);
+		return 0;
+	case ETMACTRn(15):
+		*val = etm_read(ETMACTR15);
+		return 0;
+	case ETMCNTRLDVRn(0):
+		*val = etm_read(ETMCNTRLDVR0);
+		return 0;
+	case ETMCNTRLDVRn(1):
+		*val = etm_read(ETMCNTRLDVR1);
+		return 0;
+	case ETMCNTRLDVRn(2):
+		*val = etm_read(ETMCNTRLDVR2);
+		return 0;
+	case ETMCNTRLDVRn(3):
+		*val = etm_read(ETMCNTRLDVR3);
+		return 0;
+	case ETMCNTENRn(0):
+		*val = etm_read(ETMCNTENR0);
+		return 0;
+	case ETMCNTENRn(1):
+		*val = etm_read(ETMCNTENR1);
+		return 0;
+	case ETMCNTENRn(2):
+		*val = etm_read(ETMCNTENR2);
+		return 0;
+	case ETMCNTENRn(3):
+		*val = etm_read(ETMCNTENR3);
+		return 0;
+	case ETMCNTRLDEVRn(0):
+		*val = etm_read(ETMCNTRLDEVR0);
+		return 0;
+	case ETMCNTRLDEVRn(1):
+		*val = etm_read(ETMCNTRLDEVR1);
+		return 0;
+	case ETMCNTRLDEVRn(2):
+		*val = etm_read(ETMCNTRLDEVR2);
+		return 0;
+	case ETMCNTRLDEVRn(3):
+		*val = etm_read(ETMCNTRLDEVR3);
+		return 0;
+	case ETMCNTVRn(0):
+		*val = etm_read(ETMCNTVR0);
+		return 0;
+	case ETMCNTVRn(1):
+		*val = etm_read(ETMCNTVR1);
+		return 0;
+	case ETMCNTVRn(2):
+		*val = etm_read(ETMCNTVR2);
+		return 0;
+	case ETMCNTVRn(3):
+		*val = etm_read(ETMCNTVR3);
+		return 0;
+	case ETMSQ12EVR:
+		*val = etm_read(ETMSQ12EVR);
+		return 0;
+	case ETMSQ21EVR:
+		*val = etm_read(ETMSQ21EVR);
+		return 0;
+	case ETMSQ23EVR:
+		*val = etm_read(ETMSQ23EVR);
+		return 0;
+	case ETMSQ31EVR:
+		*val = etm_read(ETMSQ31EVR);
+		return 0;
+	case ETMSQ32EVR:
+		*val = etm_read(ETMSQ32EVR);
+		return 0;
+	case ETMSQ13EVR:
+		*val = etm_read(ETMSQ13EVR);
+		return 0;
+	case ETMSQR:
+		*val = etm_read(ETMSQR);
+		return 0;
+	case ETMEXTOUTEVRn(0):
+		*val = etm_read(ETMEXTOUTEVR0);
+		return 0;
+	case ETMEXTOUTEVRn(1):
+		*val = etm_read(ETMEXTOUTEVR1);
+		return 0;
+	case ETMEXTOUTEVRn(2):
+		*val = etm_read(ETMEXTOUTEVR2);
+		return 0;
+	case ETMEXTOUTEVRn(3):
+		*val = etm_read(ETMEXTOUTEVR3);
+		return 0;
+	case ETMCIDCVRn(0):
+		*val = etm_read(ETMCIDCVR0);
+		return 0;
+	case ETMCIDCVRn(1):
+		*val = etm_read(ETMCIDCVR1);
+		return 0;
+	case ETMCIDCVRn(2):
+		*val = etm_read(ETMCIDCVR2);
+		return 0;
+	case ETMCIDCMR:
+		*val = etm_read(ETMCIDCMR);
+		return 0;
+	case ETMIMPSPEC0:
+		*val = etm_read(ETMIMPSPEC0);
+		return 0;
+	case ETMIMPSPEC1:
+		*val = etm_read(ETMIMPSPEC1);
+		return 0;
+	case ETMIMPSPEC2:
+		*val = etm_read(ETMIMPSPEC2);
+		return 0;
+	case ETMIMPSPEC3:
+		*val = etm_read(ETMIMPSPEC3);
+		return 0;
+	case ETMIMPSPEC4:
+		*val = etm_read(ETMIMPSPEC4);
+		return 0;
+	case ETMIMPSPEC5:
+		*val = etm_read(ETMIMPSPEC5);
+		return 0;
+	case ETMIMPSPEC6:
+		*val = etm_read(ETMIMPSPEC6);
+		return 0;
+	case ETMIMPSPEC7:
+		*val = etm_read(ETMIMPSPEC7);
+		return 0;
+	case ETMSYNCFR:
+		*val = etm_read(ETMSYNCFR);
+		return 0;
+	case ETMIDR:
+		*val = etm_read(ETMIDR);
+		return 0;
+	case ETMCCER:
+		*val = etm_read(ETMCCER);
+		return 0;
+	case ETMEXTINSELR:
+		*val = etm_read(ETMEXTINSELR);
+		return 0;
+	case ETMTESSEICR:
+		*val = etm_read(ETMTESSEICR);
+		return 0;
+	case ETMEIBCR:
+		*val = etm_read(ETMEIBCR);
+		return 0;
+	case ETMTSEVR:
+		*val = etm_read(ETMTSEVR);
+		return 0;
+	case ETMAUXCR:
+		*val = etm_read(ETMAUXCR);
+		return 0;
+	case ETMTRACEIDR:
+		*val = etm_read(ETMTRACEIDR);
+		return 0;
+	case ETMVMIDCVR:
+		*val = etm_read(ETMVMIDCVR);
+		return 0;
+	case ETMOSLSR:
+		*val = etm_read(ETMOSLSR);
+		return 0;
+	case ETMOSSRR:
+		*val = etm_read(ETMOSSRR);
+		return 0;
+	case ETMPDCR:
+		*val = etm_read(ETMPDCR);
+		return 0;
+	case ETMPDSR:
+		*val = etm_read(ETMPDSR);
+		return 0;
+	default:
+		*val = 0;
+		return -EINVAL;
+	}
+}
+
+int etm_writel_cp14(u32 reg, u32 val)
+{
+	switch (reg) {
+	case ETMCR:
+		etm_write(val, ETMCR);
+		break;
+	case ETMTRIGGER:
+		etm_write(val, ETMTRIGGER);
+		break;
+	case ETMSR:
+		etm_write(val, ETMSR);
+		break;
+	case ETMTSSCR:
+		etm_write(val, ETMTSSCR);
+		break;
+	case ETMTEEVR:
+		etm_write(val, ETMTEEVR);
+		break;
+	case ETMTECR1:
+		etm_write(val, ETMTECR1);
+		break;
+	case ETMFFLR:
+		etm_write(val, ETMFFLR);
+		break;
+	case ETMACVRn(0):
+		etm_write(val, ETMACVR0);
+		break;
+	case ETMACVRn(1):
+		etm_write(val, ETMACVR1);
+		break;
+	case ETMACVRn(2):
+		etm_write(val, ETMACVR2);
+		break;
+	case ETMACVRn(3):
+		etm_write(val, ETMACVR3);
+		break;
+	case ETMACVRn(4):
+		etm_write(val, ETMACVR4);
+		break;
+	case ETMACVRn(5):
+		etm_write(val, ETMACVR5);
+		break;
+	case ETMACVRn(6):
+		etm_write(val, ETMACVR6);
+		break;
+	case ETMACVRn(7):
+		etm_write(val, ETMACVR7);
+		break;
+	case ETMACVRn(8):
+		etm_write(val, ETMACVR8);
+		break;
+	case ETMACVRn(9):
+		etm_write(val, ETMACVR9);
+		break;
+	case ETMACVRn(10):
+		etm_write(val, ETMACVR10);
+		break;
+	case ETMACVRn(11):
+		etm_write(val, ETMACVR11);
+		break;
+	case ETMACVRn(12):
+		etm_write(val, ETMACVR12);
+		break;
+	case ETMACVRn(13):
+		etm_write(val, ETMACVR13);
+		break;
+	case ETMACVRn(14):
+		etm_write(val, ETMACVR14);
+		break;
+	case ETMACVRn(15):
+		etm_write(val, ETMACVR15);
+		break;
+	case ETMACTRn(0):
+		etm_write(val, ETMACTR0);
+		break;
+	case ETMACTRn(1):
+		etm_write(val, ETMACTR1);
+		break;
+	case ETMACTRn(2):
+		etm_write(val, ETMACTR2);
+		break;
+	case ETMACTRn(3):
+		etm_write(val, ETMACTR3);
+		break;
+	case ETMACTRn(4):
+		etm_write(val, ETMACTR4);
+		break;
+	case ETMACTRn(5):
+		etm_write(val, ETMACTR5);
+		break;
+	case ETMACTRn(6):
+		etm_write(val, ETMACTR6);
+		break;
+	case ETMACTRn(7):
+		etm_write(val, ETMACTR7);
+		break;
+	case ETMACTRn(8):
+		etm_write(val, ETMACTR8);
+		break;
+	case ETMACTRn(9):
+		etm_write(val, ETMACTR9);
+		break;
+	case ETMACTRn(10):
+		etm_write(val, ETMACTR10);
+		break;
+	case ETMACTRn(11):
+		etm_write(val, ETMACTR11);
+		break;
+	case ETMACTRn(12):
+		etm_write(val, ETMACTR12);
+		break;
+	case ETMACTRn(13):
+		etm_write(val, ETMACTR13);
+		break;
+	case ETMACTRn(14):
+		etm_write(val, ETMACTR14);
+		break;
+	case ETMACTRn(15):
+		etm_write(val, ETMACTR15);
+		break;
+	case ETMCNTRLDVRn(0):
+		etm_write(val, ETMCNTRLDVR0);
+		break;
+	case ETMCNTRLDVRn(1):
+		etm_write(val, ETMCNTRLDVR1);
+		break;
+	case ETMCNTRLDVRn(2):
+		etm_write(val, ETMCNTRLDVR2);
+		break;
+	case ETMCNTRLDVRn(3):
+		etm_write(val, ETMCNTRLDVR3);
+		break;
+	case ETMCNTENRn(0):
+		etm_write(val, ETMCNTENR0);
+		break;
+	case ETMCNTENRn(1):
+		etm_write(val, ETMCNTENR1);
+		break;
+	case ETMCNTENRn(2):
+		etm_write(val, ETMCNTENR2);
+		break;
+	case ETMCNTENRn(3):
+		etm_write(val, ETMCNTENR3);
+		break;
+	case ETMCNTRLDEVRn(0):
+		etm_write(val, ETMCNTRLDEVR0);
+		break;
+	case ETMCNTRLDEVRn(1):
+		etm_write(val, ETMCNTRLDEVR1);
+		break;
+	case ETMCNTRLDEVRn(2):
+		etm_write(val, ETMCNTRLDEVR2);
+		break;
+	case ETMCNTRLDEVRn(3):
+		etm_write(val, ETMCNTRLDEVR3);
+		break;
+	case ETMCNTVRn(0):
+		etm_write(val, ETMCNTVR0);
+		break;
+	case ETMCNTVRn(1):
+		etm_write(val, ETMCNTVR1);
+		break;
+	case ETMCNTVRn(2):
+		etm_write(val, ETMCNTVR2);
+		break;
+	case ETMCNTVRn(3):
+		etm_write(val, ETMCNTVR3);
+		break;
+	case ETMSQ12EVR:
+		etm_write(val, ETMSQ12EVR);
+		break;
+	case ETMSQ21EVR:
+		etm_write(val, ETMSQ21EVR);
+		break;
+	case ETMSQ23EVR:
+		etm_write(val, ETMSQ23EVR);
+		break;
+	case ETMSQ31EVR:
+		etm_write(val, ETMSQ31EVR);
+		break;
+	case ETMSQ32EVR:
+		etm_write(val, ETMSQ32EVR);
+		break;
+	case ETMSQ13EVR:
+		etm_write(val, ETMSQ13EVR);
+		break;
+	case ETMSQR:
+		etm_write(val, ETMSQR);
+		break;
+	case ETMEXTOUTEVRn(0):
+		etm_write(val, ETMEXTOUTEVR0);
+		break;
+	case ETMEXTOUTEVRn(1):
+		etm_write(val, ETMEXTOUTEVR1);
+		break;
+	case ETMEXTOUTEVRn(2):
+		etm_write(val, ETMEXTOUTEVR2);
+		break;
+	case ETMEXTOUTEVRn(3):
+		etm_write(val, ETMEXTOUTEVR3);
+		break;
+	case ETMCIDCVRn(0):
+		etm_write(val, ETMCIDCVR0);
+		break;
+	case ETMCIDCVRn(1):
+		etm_write(val, ETMCIDCVR1);
+		break;
+	case ETMCIDCVRn(2):
+		etm_write(val, ETMCIDCVR2);
+		break;
+	case ETMCIDCMR:
+		etm_write(val, ETMCIDCMR);
+		break;
+	case ETMIMPSPEC0:
+		etm_write(val, ETMIMPSPEC0);
+		break;
+	case ETMIMPSPEC1:
+		etm_write(val, ETMIMPSPEC1);
+		break;
+	case ETMIMPSPEC2:
+		etm_write(val, ETMIMPSPEC2);
+		break;
+	case ETMIMPSPEC3:
+		etm_write(val, ETMIMPSPEC3);
+		break;
+	case ETMIMPSPEC4:
+		etm_write(val, ETMIMPSPEC4);
+		break;
+	case ETMIMPSPEC5:
+		etm_write(val, ETMIMPSPEC5);
+		break;
+	case ETMIMPSPEC6:
+		etm_write(val, ETMIMPSPEC6);
+		break;
+	case ETMIMPSPEC7:
+		etm_write(val, ETMIMPSPEC7);
+		break;
+	case ETMSYNCFR:
+		etm_write(val, ETMSYNCFR);
+		break;
+	case ETMEXTINSELR:
+		etm_write(val, ETMEXTINSELR);
+		break;
+	case ETMTESSEICR:
+		etm_write(val, ETMTESSEICR);
+		break;
+	case ETMEIBCR:
+		etm_write(val, ETMEIBCR);
+		break;
+	case ETMTSEVR:
+		etm_write(val, ETMTSEVR);
+		break;
+	case ETMAUXCR:
+		etm_write(val, ETMAUXCR);
+		break;
+	case ETMTRACEIDR:
+		etm_write(val, ETMTRACEIDR);
+		break;
+	case ETMVMIDCVR:
+		etm_write(val, ETMVMIDCVR);
+		break;
+	case ETMOSLAR:
+		etm_write(val, ETMOSLAR);
+		break;
+	case ETMOSSRR:
+		etm_write(val, ETMOSSRR);
+		break;
+	case ETMPDCR:
+		etm_write(val, ETMPDCR);
+		break;
+	case ETMPDSR:
+		etm_write(val, ETMPDSR);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
diff --git a/drivers/hwtracing/coresight/coresight-etm.h b/drivers/hwtracing/coresight/coresight-etm.h
new file mode 100644
index 000000000000..501c5fac8a45
--- /dev/null
+++ b/drivers/hwtracing/coresight/coresight-etm.h
@@ -0,0 +1,251 @@
+/* Copyright (c) 2014-2015, The Linux Foundation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef _CORESIGHT_CORESIGHT_ETM_H
+#define _CORESIGHT_CORESIGHT_ETM_H
+
+#include <linux/spinlock.h>
+#include "coresight-priv.h"
+
+/*
+ * Device registers:
+ * 0x000 - 0x2FC: Trace         registers
+ * 0x300 - 0x314: Management    registers
+ * 0x318 - 0xEFC: Trace         registers
+ *
+ * Coresight registers
+ * 0xF00 - 0xF9C: Management    registers
+ * 0xFA0 - 0xFA4: Management    registers in PFTv1.0
+ *                Trace         registers in PFTv1.1
+ * 0xFA8 - 0xFFC: Management    registers
+ */
+
+/* Trace registers (0x000-0x2FC) */
+#define ETMCR			0x000
+#define ETMCCR			0x004
+#define ETMTRIGGER		0x008
+#define ETMSR			0x010
+#define ETMSCR			0x014
+#define ETMTSSCR		0x018
+#define ETMTECR2		0x01c
+#define ETMTEEVR		0x020
+#define ETMTECR1		0x024
+#define ETMFFLR			0x02c
+#define ETMACVRn(n)		(0x040 + (n * 4))
+#define ETMACTRn(n)		(0x080 + (n * 4))
+#define ETMCNTRLDVRn(n)		(0x140 + (n * 4))
+#define ETMCNTENRn(n)		(0x150 + (n * 4))
+#define ETMCNTRLDEVRn(n)	(0x160 + (n * 4))
+#define ETMCNTVRn(n)		(0x170 + (n * 4))
+#define ETMSQ12EVR		0x180
+#define ETMSQ21EVR		0x184
+#define ETMSQ23EVR		0x188
+#define ETMSQ31EVR		0x18c
+#define ETMSQ32EVR		0x190
+#define ETMSQ13EVR		0x194
+#define ETMSQR			0x19c
+#define ETMEXTOUTEVRn(n)	(0x1a0 + (n * 4))
+#define ETMCIDCVRn(n)		(0x1b0 + (n * 4))
+#define ETMCIDCMR		0x1bc
+#define ETMIMPSPEC0		0x1c0
+#define ETMIMPSPEC1		0x1c4
+#define ETMIMPSPEC2		0x1c8
+#define ETMIMPSPEC3		0x1cc
+#define ETMIMPSPEC4		0x1d0
+#define ETMIMPSPEC5		0x1d4
+#define ETMIMPSPEC6		0x1d8
+#define ETMIMPSPEC7		0x1dc
+#define ETMSYNCFR		0x1e0
+#define ETMIDR			0x1e4
+#define ETMCCER			0x1e8
+#define ETMEXTINSELR		0x1ec
+#define ETMTESSEICR		0x1f0
+#define ETMEIBCR		0x1f4
+#define ETMTSEVR		0x1f8
+#define ETMAUXCR		0x1fc
+#define ETMTRACEIDR		0x200
+#define ETMVMIDCVR		0x240
+/* Management registers (0x300-0x314) */
+#define ETMOSLAR		0x300
+#define ETMOSLSR		0x304
+#define ETMOSSRR		0x308
+#define ETMPDCR			0x310
+#define ETMPDSR			0x314
+#define ETM_MAX_ADDR_CMP	16
+#define ETM_MAX_CNTR		4
+#define ETM_MAX_CTXID_CMP	3
+
+/* Register definition */
+/* ETMCR - 0x00 */
+#define ETMCR_PWD_DWN		BIT(0)
+#define ETMCR_STALL_MODE	BIT(7)
+#define ETMCR_ETM_PRG		BIT(10)
+#define ETMCR_ETM_EN		BIT(11)
+#define ETMCR_CYC_ACC		BIT(12)
+#define ETMCR_CTXID_SIZE	(BIT(14)|BIT(15))
+#define ETMCR_TIMESTAMP_EN	BIT(28)
+/* ETMCCR - 0x04 */
+#define ETMCCR_FIFOFULL		BIT(23)
+/* ETMPDCR - 0x310 */
+#define ETMPDCR_PWD_UP		BIT(3)
+/* ETMTECR1 - 0x024 */
+#define ETMTECR1_ADDR_COMP_1	BIT(0)
+#define ETMTECR1_INC_EXC	BIT(24)
+#define ETMTECR1_START_STOP	BIT(25)
+/* ETMCCER - 0x1E8 */
+#define ETMCCER_TIMESTAMP	BIT(22)
+
+#define ETM_MODE_EXCLUDE	BIT(0)
+#define ETM_MODE_CYCACC		BIT(1)
+#define ETM_MODE_STALL		BIT(2)
+#define ETM_MODE_TIMESTAMP	BIT(3)
+#define ETM_MODE_CTXID		BIT(4)
+#define ETM_MODE_ALL		0x1f
+
+#define ETM_SQR_MASK		0x3
+#define ETM_TRACEID_MASK	0x3f
+#define ETM_EVENT_MASK		0x1ffff
+#define ETM_SYNC_MASK		0xfff
+#define ETM_ALL_MASK		0xffffffff
+
+#define ETMSR_PROG_BIT		1
+#define ETM_SEQ_STATE_MAX_VAL	(0x2)
+#define PORT_SIZE_MASK		(GENMASK(21, 21) | GENMASK(6, 4))
+
+#define ETM_HARD_WIRE_RES_A	/* Hard wired, always true */	\
+				((0x0f << 0)	|		\
+				/* Resource index A */		\
+				(0x06 << 4))
+
+#define ETM_ADD_COMP_0		/* Single addr comparator 1 */	\
+				((0x00 << 7)	|		\
+				/* Resource index B */		\
+				(0x00 << 11))
+
+#define ETM_EVENT_NOT_A		BIT(14) /* NOT(A) */
+
+#define ETM_DEFAULT_EVENT_VAL	(ETM_HARD_WIRE_RES_A	|	\
+				 ETM_ADD_COMP_0		|	\
+				 ETM_EVENT_NOT_A)
+/**
+ * struct etm_drvdata - specifics associated to an ETM component
+ * @base:	memory mapped base address for this component.
+ * @dev:	the device entity associated to this component.
+ * @csdev:	component vitals needed by the framework.
+ * @clk:	the clock this component is associated to.
+ * @spinlock:	only one at a time pls.
+ * @cpu:	the cpu this component is affined to.
+ * @port_size:	port size as reported by ETMCR bit 4-6 and 21.
+ * @arch:	ETM/PTM version number.
+ * @use_cpu14:	true if management registers need to be accessed via CP14.
+ * @enable:	is this ETM/PTM currently tracing.
+ * @sticky_enable: true if ETM base configuration has been done.
+ * @boot_enable:true if we should start tracing at boot time.
+ * @os_unlock:	true if access to management registers is allowed.
+ * @nr_addr_cmp:Number of pairs of address comparators as found in ETMCCR.
+ * @nr_cntr:	Number of counters as found in ETMCCR bit 13-15.
+ * @nr_ext_inp:	Number of external input as found in ETMCCR bit 17-19.
+ * @nr_ext_out:	Number of external output as found in ETMCCR bit 20-22.
+ * @nr_ctxid_cmp: Number of contextID comparators as found in ETMCCR bit 24-25.
+ * @etmccr:	value of register ETMCCR.
+ * @etmccer:	value of register ETMCCER.
+ * @traceid:	value of the current ID for this component.
+ * @mode:	controls various modes supported by this ETM/PTM.
+ * @ctrl:	used in conjunction with @mode.
+ * @trigger_event: setting for register ETMTRIGGER.
+ * @startstop_ctrl: setting for register ETMTSSCR.
+ * @enable_event: setting for register ETMTEEVR.
+ * @enable_ctrl1: setting for register ETMTECR1.
+ * @fifofull_level: setting for register ETMFFLR.
+ * @addr_idx:	index for the address comparator selection.
+ * @addr_val:	value for address comparator register.
+ * @addr_acctype: access type for address comparator register.
+ * @addr_type:	current status of the comparator register.
+ * @cntr_idx:	index for the counter register selection.
+ * @cntr_rld_val: reload value of a counter register.
+ * @cntr_event:	control for counter enable register.
+ * @cntr_rld_event: value for counter reload event register.
+ * @cntr_val:	counter value register.
+ * @seq_12_event: event causing the transition from 1 to 2.
+ * @seq_21_event: event causing the transition from 2 to 1.
+ * @seq_23_event: event causing the transition from 2 to 3.
+ * @seq_31_event: event causing the transition from 3 to 1.
+ * @seq_32_event: event causing the transition from 3 to 2.
+ * @seq_13_event: event causing the transition from 1 to 3.
+ * @seq_curr_state: current value of the sequencer register.
+ * @ctxid_idx: index for the context ID registers.
+ * @ctxid_val: value for the context ID to trigger on.
+ * @ctxid_mask: mask applicable to all the context IDs.
+ * @sync_freq:	Synchronisation frequency.
+ * @timestamp_event: Defines an event that requests the insertion
+		     of a timestamp into the trace stream.
+ */
+struct etm_drvdata {
+	void __iomem			*base;
+	struct device			*dev;
+	struct coresight_device		*csdev;
+	struct clk			*clk;
+	spinlock_t			spinlock;
+	int				cpu;
+	int				port_size;
+	u8				arch;
+	bool				use_cp14;
+	bool				enable;
+	bool				sticky_enable;
+	bool				boot_enable;
+	bool				os_unlock;
+	u8				nr_addr_cmp;
+	u8				nr_cntr;
+	u8				nr_ext_inp;
+	u8				nr_ext_out;
+	u8				nr_ctxid_cmp;
+	u32				etmccr;
+	u32				etmccer;
+	u32				traceid;
+	u32				mode;
+	u32				ctrl;
+	u32				trigger_event;
+	u32				startstop_ctrl;
+	u32				enable_event;
+	u32				enable_ctrl1;
+	u32				fifofull_level;
+	u8				addr_idx;
+	u32				addr_val[ETM_MAX_ADDR_CMP];
+	u32				addr_acctype[ETM_MAX_ADDR_CMP];
+	u32				addr_type[ETM_MAX_ADDR_CMP];
+	u8				cntr_idx;
+	u32				cntr_rld_val[ETM_MAX_CNTR];
+	u32				cntr_event[ETM_MAX_CNTR];
+	u32				cntr_rld_event[ETM_MAX_CNTR];
+	u32				cntr_val[ETM_MAX_CNTR];
+	u32				seq_12_event;
+	u32				seq_21_event;
+	u32				seq_23_event;
+	u32				seq_31_event;
+	u32				seq_32_event;
+	u32				seq_13_event;
+	u32				seq_curr_state;
+	u8				ctxid_idx;
+	u32				ctxid_val[ETM_MAX_CTXID_CMP];
+	u32				ctxid_mask;
+	u32				sync_freq;
+	u32				timestamp_event;
+};
+
+enum etm_addr_type {
+	ETM_ADDR_TYPE_NONE,
+	ETM_ADDR_TYPE_SINGLE,
+	ETM_ADDR_TYPE_RANGE,
+	ETM_ADDR_TYPE_START,
+	ETM_ADDR_TYPE_STOP,
+};
+#endif
diff --git a/drivers/hwtracing/coresight/coresight-etm3x.c b/drivers/hwtracing/coresight/coresight-etm3x.c
new file mode 100644
index 000000000000..c965f5724abd
--- /dev/null
+++ b/drivers/hwtracing/coresight/coresight-etm3x.c
@@ -0,0 +1,1932 @@
+/* Copyright (c) 2011-2012, The Linux Foundation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/types.h>
+#include <linux/device.h>
+#include <linux/io.h>
+#include <linux/err.h>
+#include <linux/fs.h>
+#include <linux/slab.h>
+#include <linux/delay.h>
+#include <linux/smp.h>
+#include <linux/sysfs.h>
+#include <linux/stat.h>
+#include <linux/clk.h>
+#include <linux/cpu.h>
+#include <linux/of.h>
+#include <linux/coresight.h>
+#include <linux/amba/bus.h>
+#include <linux/seq_file.h>
+#include <linux/uaccess.h>
+#include <asm/sections.h>
+
+#include "coresight-etm.h"
+
+static int boot_enable;
+module_param_named(boot_enable, boot_enable, int, S_IRUGO);
+
+/* The number of ETM/PTM currently registered */
+static int etm_count;
+static struct etm_drvdata *etmdrvdata[NR_CPUS];
+
+static inline void etm_writel(struct etm_drvdata *drvdata,
+			      u32 val, u32 off)
+{
+	if (drvdata->use_cp14) {
+		if (etm_writel_cp14(off, val)) {
+			dev_err(drvdata->dev,
+				"invalid CP14 access to ETM reg: %#x", off);
+		}
+	} else {
+		writel_relaxed(val, drvdata->base + off);
+	}
+}
+
+static inline unsigned int etm_readl(struct etm_drvdata *drvdata, u32 off)
+{
+	u32 val;
+
+	if (drvdata->use_cp14) {
+		if (etm_readl_cp14(off, &val)) {
+			dev_err(drvdata->dev,
+				"invalid CP14 access to ETM reg: %#x", off);
+		}
+	} else {
+		val = readl_relaxed(drvdata->base + off);
+	}
+
+	return val;
+}
+
+/*
+ * Memory mapped writes to clear os lock are not supported on some processors
+ * and OS lock must be unlocked before any memory mapped access on such
+ * processors, otherwise memory mapped reads/writes will be invalid.
+ */
+static void etm_os_unlock(void *info)
+{
+	struct etm_drvdata *drvdata = (struct etm_drvdata *)info;
+	/* Writing any value to ETMOSLAR unlocks the trace registers */
+	etm_writel(drvdata, 0x0, ETMOSLAR);
+	isb();
+}
+
+static void etm_set_pwrdwn(struct etm_drvdata *drvdata)
+{
+	u32 etmcr;
+
+	/* Ensure pending cp14 accesses complete before setting pwrdwn */
+	mb();
+	isb();
+	etmcr = etm_readl(drvdata, ETMCR);
+	etmcr |= ETMCR_PWD_DWN;
+	etm_writel(drvdata, etmcr, ETMCR);
+}
+
+static void etm_clr_pwrdwn(struct etm_drvdata *drvdata)
+{
+	u32 etmcr;
+
+	etmcr = etm_readl(drvdata, ETMCR);
+	etmcr &= ~ETMCR_PWD_DWN;
+	etm_writel(drvdata, etmcr, ETMCR);
+	/* Ensure pwrup completes before subsequent cp14 accesses */
+	mb();
+	isb();
+}
+
+static void etm_set_pwrup(struct etm_drvdata *drvdata)
+{
+	u32 etmpdcr;
+
+	etmpdcr = readl_relaxed(drvdata->base + ETMPDCR);
+	etmpdcr |= ETMPDCR_PWD_UP;
+	writel_relaxed(etmpdcr, drvdata->base + ETMPDCR);
+	/* Ensure pwrup completes before subsequent cp14 accesses */
+	mb();
+	isb();
+}
+
+static void etm_clr_pwrup(struct etm_drvdata *drvdata)
+{
+	u32 etmpdcr;
+
+	/* Ensure pending cp14 accesses complete before clearing pwrup */
+	mb();
+	isb();
+	etmpdcr = readl_relaxed(drvdata->base + ETMPDCR);
+	etmpdcr &= ~ETMPDCR_PWD_UP;
+	writel_relaxed(etmpdcr, drvdata->base + ETMPDCR);
+}
+
+/**
+ * coresight_timeout_etm - loop until a bit has changed to a specific state.
+ * @drvdata: etm's private data structure.
+ * @offset: address of a register, starting from @addr.
+ * @position: the position of the bit of interest.
+ * @value: the value the bit should have.
+ *
+ * Basically the same as @coresight_timeout except for the register access
+ * method where we have to account for CP14 configurations.
+
+ * Return: 0 as soon as the bit has taken the desired state or -EAGAIN if
+ * TIMEOUT_US has elapsed, which ever happens first.
+ */
+
+static int coresight_timeout_etm(struct etm_drvdata *drvdata, u32 offset,
+				  int position, int value)
+{
+	int i;
+	u32 val;
+
+	for (i = TIMEOUT_US; i > 0; i--) {
+		val = etm_readl(drvdata, offset);
+		/* Waiting on the bit to go from 0 to 1 */
+		if (value) {
+			if (val & BIT(position))
+				return 0;
+		/* Waiting on the bit to go from 1 to 0 */
+		} else {
+			if (!(val & BIT(position)))
+				return 0;
+		}
+
+		/*
+		 * Delay is arbitrary - the specification doesn't say how long
+		 * we are expected to wait.  Extra check required to make sure
+		 * we don't wait needlessly on the last iteration.
+		 */
+		if (i - 1)
+			udelay(1);
+	}
+
+	return -EAGAIN;
+}
+
+
+static void etm_set_prog(struct etm_drvdata *drvdata)
+{
+	u32 etmcr;
+
+	etmcr = etm_readl(drvdata, ETMCR);
+	etmcr |= ETMCR_ETM_PRG;
+	etm_writel(drvdata, etmcr, ETMCR);
+	/*
+	 * Recommended by spec for cp14 accesses to ensure etmcr write is
+	 * complete before polling etmsr
+	 */
+	isb();
+	if (coresight_timeout_etm(drvdata, ETMSR, ETMSR_PROG_BIT, 1)) {
+		dev_err(drvdata->dev,
+			"timeout observed when probing at offset %#x\n", ETMSR);
+	}
+}
+
+static void etm_clr_prog(struct etm_drvdata *drvdata)
+{
+	u32 etmcr;
+
+	etmcr = etm_readl(drvdata, ETMCR);
+	etmcr &= ~ETMCR_ETM_PRG;
+	etm_writel(drvdata, etmcr, ETMCR);
+	/*
+	 * Recommended by spec for cp14 accesses to ensure etmcr write is
+	 * complete before polling etmsr
+	 */
+	isb();
+	if (coresight_timeout_etm(drvdata, ETMSR, ETMSR_PROG_BIT, 0)) {
+		dev_err(drvdata->dev,
+			"timeout observed when probing at offset %#x\n", ETMSR);
+	}
+}
+
+static void etm_set_default(struct etm_drvdata *drvdata)
+{
+	int i;
+
+	drvdata->trigger_event = ETM_DEFAULT_EVENT_VAL;
+	drvdata->enable_event = ETM_HARD_WIRE_RES_A;
+
+	drvdata->seq_12_event = ETM_DEFAULT_EVENT_VAL;
+	drvdata->seq_21_event = ETM_DEFAULT_EVENT_VAL;
+	drvdata->seq_23_event = ETM_DEFAULT_EVENT_VAL;
+	drvdata->seq_31_event = ETM_DEFAULT_EVENT_VAL;
+	drvdata->seq_32_event = ETM_DEFAULT_EVENT_VAL;
+	drvdata->seq_13_event = ETM_DEFAULT_EVENT_VAL;
+	drvdata->timestamp_event = ETM_DEFAULT_EVENT_VAL;
+
+	for (i = 0; i < drvdata->nr_cntr; i++) {
+		drvdata->cntr_rld_val[i] = 0x0;
+		drvdata->cntr_event[i] = ETM_DEFAULT_EVENT_VAL;
+		drvdata->cntr_rld_event[i] = ETM_DEFAULT_EVENT_VAL;
+		drvdata->cntr_val[i] = 0x0;
+	}
+
+	drvdata->seq_curr_state = 0x0;
+	drvdata->ctxid_idx = 0x0;
+	for (i = 0; i < drvdata->nr_ctxid_cmp; i++)
+		drvdata->ctxid_val[i] = 0x0;
+	drvdata->ctxid_mask = 0x0;
+}
+
+static void etm_enable_hw(void *info)
+{
+	int i;
+	u32 etmcr;
+	struct etm_drvdata *drvdata = info;
+
+	CS_UNLOCK(drvdata->base);
+
+	/* Turn engine on */
+	etm_clr_pwrdwn(drvdata);
+	/* Apply power to trace registers */
+	etm_set_pwrup(drvdata);
+	/* Make sure all registers are accessible */
+	etm_os_unlock(drvdata);
+
+	etm_set_prog(drvdata);
+
+	etmcr = etm_readl(drvdata, ETMCR);
+	etmcr &= (ETMCR_PWD_DWN | ETMCR_ETM_PRG);
+	etmcr |= drvdata->port_size;
+	etm_writel(drvdata, drvdata->ctrl | etmcr, ETMCR);
+	etm_writel(drvdata, drvdata->trigger_event, ETMTRIGGER);
+	etm_writel(drvdata, drvdata->startstop_ctrl, ETMTSSCR);
+	etm_writel(drvdata, drvdata->enable_event, ETMTEEVR);
+	etm_writel(drvdata, drvdata->enable_ctrl1, ETMTECR1);
+	etm_writel(drvdata, drvdata->fifofull_level, ETMFFLR);
+	for (i = 0; i < drvdata->nr_addr_cmp; i++) {
+		etm_writel(drvdata, drvdata->addr_val[i], ETMACVRn(i));
+		etm_writel(drvdata, drvdata->addr_acctype[i], ETMACTRn(i));
+	}
+	for (i = 0; i < drvdata->nr_cntr; i++) {
+		etm_writel(drvdata, drvdata->cntr_rld_val[i], ETMCNTRLDVRn(i));
+		etm_writel(drvdata, drvdata->cntr_event[i], ETMCNTENRn(i));
+		etm_writel(drvdata, drvdata->cntr_rld_event[i],
+			   ETMCNTRLDEVRn(i));
+		etm_writel(drvdata, drvdata->cntr_val[i], ETMCNTVRn(i));
+	}
+	etm_writel(drvdata, drvdata->seq_12_event, ETMSQ12EVR);
+	etm_writel(drvdata, drvdata->seq_21_event, ETMSQ21EVR);
+	etm_writel(drvdata, drvdata->seq_23_event, ETMSQ23EVR);
+	etm_writel(drvdata, drvdata->seq_31_event, ETMSQ31EVR);
+	etm_writel(drvdata, drvdata->seq_32_event, ETMSQ32EVR);
+	etm_writel(drvdata, drvdata->seq_13_event, ETMSQ13EVR);
+	etm_writel(drvdata, drvdata->seq_curr_state, ETMSQR);
+	for (i = 0; i < drvdata->nr_ext_out; i++)
+		etm_writel(drvdata, ETM_DEFAULT_EVENT_VAL, ETMEXTOUTEVRn(i));
+	for (i = 0; i < drvdata->nr_ctxid_cmp; i++)
+		etm_writel(drvdata, drvdata->ctxid_val[i], ETMCIDCVRn(i));
+	etm_writel(drvdata, drvdata->ctxid_mask, ETMCIDCMR);
+	etm_writel(drvdata, drvdata->sync_freq, ETMSYNCFR);
+	/* No external input selected */
+	etm_writel(drvdata, 0x0, ETMEXTINSELR);
+	etm_writel(drvdata, drvdata->timestamp_event, ETMTSEVR);
+	/* No auxiliary control selected */
+	etm_writel(drvdata, 0x0, ETMAUXCR);
+	etm_writel(drvdata, drvdata->traceid, ETMTRACEIDR);
+	/* No VMID comparator value selected */
+	etm_writel(drvdata, 0x0, ETMVMIDCVR);
+
+	/* Ensures trace output is enabled from this ETM */
+	etm_writel(drvdata, drvdata->ctrl | ETMCR_ETM_EN | etmcr, ETMCR);
+
+	etm_clr_prog(drvdata);
+	CS_LOCK(drvdata->base);
+
+	dev_dbg(drvdata->dev, "cpu: %d enable smp call done\n", drvdata->cpu);
+}
+
+static int etm_trace_id_simple(struct etm_drvdata *drvdata)
+{
+	if (!drvdata->enable)
+		return drvdata->traceid;
+
+	return (etm_readl(drvdata, ETMTRACEIDR) & ETM_TRACEID_MASK);
+}
+
+static int etm_trace_id(struct coresight_device *csdev)
+{
+	struct etm_drvdata *drvdata = dev_get_drvdata(csdev->dev.parent);
+	unsigned long flags;
+	int trace_id = -1;
+
+	if (!drvdata->enable)
+		return drvdata->traceid;
+
+	if (clk_prepare_enable(drvdata->clk))
+		goto out;
+
+	spin_lock_irqsave(&drvdata->spinlock, flags);
+
+	CS_UNLOCK(drvdata->base);
+	trace_id = (etm_readl(drvdata, ETMTRACEIDR) & ETM_TRACEID_MASK);
+	CS_LOCK(drvdata->base);
+
+	spin_unlock_irqrestore(&drvdata->spinlock, flags);
+	clk_disable_unprepare(drvdata->clk);
+out:
+	return trace_id;
+}
+
+static int etm_enable(struct coresight_device *csdev)
+{
+	struct etm_drvdata *drvdata = dev_get_drvdata(csdev->dev.parent);
+	int ret;
+
+	ret = clk_prepare_enable(drvdata->clk);
+	if (ret)
+		goto err_clk;
+
+	spin_lock(&drvdata->spinlock);
+
+	/*
+	 * Configure the ETM only if the CPU is online.  If it isn't online
+	 * hw configuration will take place when 'CPU_STARTING' is received
+	 * in @etm_cpu_callback.
+	 */
+	if (cpu_online(drvdata->cpu)) {
+		ret = smp_call_function_single(drvdata->cpu,
+					       etm_enable_hw, drvdata, 1);
+		if (ret)
+			goto err;
+	}
+
+	drvdata->enable = true;
+	drvdata->sticky_enable = true;
+
+	spin_unlock(&drvdata->spinlock);
+
+	dev_info(drvdata->dev, "ETM tracing enabled\n");
+	return 0;
+err:
+	spin_unlock(&drvdata->spinlock);
+	clk_disable_unprepare(drvdata->clk);
+err_clk:
+	return ret;
+}
+
+static void etm_disable_hw(void *info)
+{
+	int i;
+	struct etm_drvdata *drvdata = info;
+
+	CS_UNLOCK(drvdata->base);
+	etm_set_prog(drvdata);
+
+	/* Program trace enable to low by using always false event */
+	etm_writel(drvdata, ETM_HARD_WIRE_RES_A | ETM_EVENT_NOT_A, ETMTEEVR);
+
+	/* Read back sequencer and counters for post trace analysis */
+	drvdata->seq_curr_state = (etm_readl(drvdata, ETMSQR) & ETM_SQR_MASK);
+
+	for (i = 0; i < drvdata->nr_cntr; i++)
+		drvdata->cntr_val[i] = etm_readl(drvdata, ETMCNTVRn(i));
+
+	etm_set_pwrdwn(drvdata);
+	CS_LOCK(drvdata->base);
+
+	dev_dbg(drvdata->dev, "cpu: %d disable smp call done\n", drvdata->cpu);
+}
+
+static void etm_disable(struct coresight_device *csdev)
+{
+	struct etm_drvdata *drvdata = dev_get_drvdata(csdev->dev.parent);
+
+	/*
+	 * Taking hotplug lock here protects from clocks getting disabled
+	 * with tracing being left on (crash scenario) if user disable occurs
+	 * after cpu online mask indicates the cpu is offline but before the
+	 * DYING hotplug callback is serviced by the ETM driver.
+	 */
+	get_online_cpus();
+	spin_lock(&drvdata->spinlock);
+
+	/*
+	 * Executing etm_disable_hw on the cpu whose ETM is being disabled
+	 * ensures that register writes occur when cpu is powered.
+	 */
+	smp_call_function_single(drvdata->cpu, etm_disable_hw, drvdata, 1);
+	drvdata->enable = false;
+
+	spin_unlock(&drvdata->spinlock);
+	put_online_cpus();
+
+	clk_disable_unprepare(drvdata->clk);
+
+	dev_info(drvdata->dev, "ETM tracing disabled\n");
+}
+
+static const struct coresight_ops_source etm_source_ops = {
+	.trace_id	= etm_trace_id,
+	.enable		= etm_enable,
+	.disable	= etm_disable,
+};
+
+static const struct coresight_ops etm_cs_ops = {
+	.source_ops	= &etm_source_ops,
+};
+
+static ssize_t nr_addr_cmp_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	unsigned long val;
+	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
+
+	val = drvdata->nr_addr_cmp;
+	return sprintf(buf, "%#lx\n", val);
+}
+static DEVICE_ATTR_RO(nr_addr_cmp);
+
+static ssize_t nr_cntr_show(struct device *dev,
+			    struct device_attribute *attr, char *buf)
+{	unsigned long val;
+	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
+
+	val = drvdata->nr_cntr;
+	return sprintf(buf, "%#lx\n", val);
+}
+static DEVICE_ATTR_RO(nr_cntr);
+
+static ssize_t nr_ctxid_cmp_show(struct device *dev,
+				 struct device_attribute *attr, char *buf)
+{
+	unsigned long val;
+	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
+
+	val = drvdata->nr_ctxid_cmp;
+	return sprintf(buf, "%#lx\n", val);
+}
+static DEVICE_ATTR_RO(nr_ctxid_cmp);
+
+static ssize_t etmsr_show(struct device *dev,
+			  struct device_attribute *attr, char *buf)
+{
+	int ret;
+	unsigned long flags, val;
+	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
+
+	ret = clk_prepare_enable(drvdata->clk);
+	if (ret)
+		return ret;
+
+	spin_lock_irqsave(&drvdata->spinlock, flags);
+	CS_UNLOCK(drvdata->base);
+
+	val = etm_readl(drvdata, ETMSR);
+
+	CS_LOCK(drvdata->base);
+	spin_unlock_irqrestore(&drvdata->spinlock, flags);
+	clk_disable_unprepare(drvdata->clk);
+
+	return sprintf(buf, "%#lx\n", val);
+}
+static DEVICE_ATTR_RO(etmsr);
+
+static ssize_t reset_store(struct device *dev,
+			   struct device_attribute *attr,
+			   const char *buf, size_t size)
+{
+	int i, ret;
+	unsigned long val;
+	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
+
+	ret = kstrtoul(buf, 16, &val);
+	if (ret)
+		return ret;
+
+	if (val) {
+		spin_lock(&drvdata->spinlock);
+		drvdata->mode = ETM_MODE_EXCLUDE;
+		drvdata->ctrl = 0x0;
+		drvdata->trigger_event = ETM_DEFAULT_EVENT_VAL;
+		drvdata->startstop_ctrl = 0x0;
+		drvdata->addr_idx = 0x0;
+		for (i = 0; i < drvdata->nr_addr_cmp; i++) {
+			drvdata->addr_val[i] = 0x0;
+			drvdata->addr_acctype[i] = 0x0;
+			drvdata->addr_type[i] = ETM_ADDR_TYPE_NONE;
+		}
+		drvdata->cntr_idx = 0x0;
+
+		etm_set_default(drvdata);
+		spin_unlock(&drvdata->spinlock);
+	}
+
+	return size;
+}
+static DEVICE_ATTR_WO(reset);
+
+static ssize_t mode_show(struct device *dev,
+			 struct device_attribute *attr, char *buf)
+{
+	unsigned long val;
+	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
+
+	val = drvdata->mode;
+	return sprintf(buf, "%#lx\n", val);
+}
+
+static ssize_t mode_store(struct device *dev,
+			  struct device_attribute *attr,
+			  const char *buf, size_t size)
+{
+	int ret;
+	unsigned long val;
+	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
+
+	ret = kstrtoul(buf, 16, &val);
+	if (ret)
+		return ret;
+
+	spin_lock(&drvdata->spinlock);
+	drvdata->mode = val & ETM_MODE_ALL;
+
+	if (drvdata->mode & ETM_MODE_EXCLUDE)
+		drvdata->enable_ctrl1 |= ETMTECR1_INC_EXC;
+	else
+		drvdata->enable_ctrl1 &= ~ETMTECR1_INC_EXC;
+
+	if (drvdata->mode & ETM_MODE_CYCACC)
+		drvdata->ctrl |= ETMCR_CYC_ACC;
+	else
+		drvdata->ctrl &= ~ETMCR_CYC_ACC;
+
+	if (drvdata->mode & ETM_MODE_STALL) {
+		if (!(drvdata->etmccr & ETMCCR_FIFOFULL)) {
+			dev_warn(drvdata->dev, "stall mode not supported\n");
+			ret = -EINVAL;
+			goto err_unlock;
+		}
+		drvdata->ctrl |= ETMCR_STALL_MODE;
+	 } else
+		drvdata->ctrl &= ~ETMCR_STALL_MODE;
+
+	if (drvdata->mode & ETM_MODE_TIMESTAMP) {
+		if (!(drvdata->etmccer & ETMCCER_TIMESTAMP)) {
+			dev_warn(drvdata->dev, "timestamp not supported\n");
+			ret = -EINVAL;
+			goto err_unlock;
+		}
+		drvdata->ctrl |= ETMCR_TIMESTAMP_EN;
+	} else
+		drvdata->ctrl &= ~ETMCR_TIMESTAMP_EN;
+
+	if (drvdata->mode & ETM_MODE_CTXID)
+		drvdata->ctrl |= ETMCR_CTXID_SIZE;
+	else
+		drvdata->ctrl &= ~ETMCR_CTXID_SIZE;
+	spin_unlock(&drvdata->spinlock);
+
+	return size;
+
+err_unlock:
+	spin_unlock(&drvdata->spinlock);
+	return ret;
+}
+static DEVICE_ATTR_RW(mode);
+
+static ssize_t trigger_event_show(struct device *dev,
+				  struct device_attribute *attr, char *buf)
+{
+	unsigned long val;
+	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
+
+	val = drvdata->trigger_event;
+	return sprintf(buf, "%#lx\n", val);
+}
+
+static ssize_t trigger_event_store(struct device *dev,
+				   struct device_attribute *attr,
+				   const char *buf, size_t size)
+{
+	int ret;
+	unsigned long val;
+	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
+
+	ret = kstrtoul(buf, 16, &val);
+	if (ret)
+		return ret;
+
+	drvdata->trigger_event = val & ETM_EVENT_MASK;
+
+	return size;
+}
+static DEVICE_ATTR_RW(trigger_event);
+
+static ssize_t enable_event_show(struct device *dev,
+				 struct device_attribute *attr, char *buf)
+{
+	unsigned long val;
+	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
+
+	val = drvdata->enable_event;
+	return sprintf(buf, "%#lx\n", val);
+}
+
+static ssize_t enable_event_store(struct device *dev,
+				  struct device_attribute *attr,
+				  const char *buf, size_t size)
+{
+	int ret;
+	unsigned long val;
+	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
+
+	ret = kstrtoul(buf, 16, &val);
+	if (ret)
+		return ret;
+
+	drvdata->enable_event = val & ETM_EVENT_MASK;
+
+	return size;
+}
+static DEVICE_ATTR_RW(enable_event);
+
+static ssize_t fifofull_level_show(struct device *dev,
+				   struct device_attribute *attr, char *buf)
+{
+	unsigned long val;
+	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
+
+	val = drvdata->fifofull_level;
+	return sprintf(buf, "%#lx\n", val);
+}
+
+static ssize_t fifofull_level_store(struct device *dev,
+				    struct device_attribute *attr,
+				    const char *buf, size_t size)
+{
+	int ret;
+	unsigned long val;
+	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
+
+	ret = kstrtoul(buf, 16, &val);
+	if (ret)
+		return ret;
+
+	drvdata->fifofull_level = val;
+
+	return size;
+}
+static DEVICE_ATTR_RW(fifofull_level);
+
+static ssize_t addr_idx_show(struct device *dev,
+			     struct device_attribute *attr, char *buf)
+{
+	unsigned long val;
+	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
+
+	val = drvdata->addr_idx;
+	return sprintf(buf, "%#lx\n", val);
+}
+
+static ssize_t addr_idx_store(struct device *dev,
+			      struct device_attribute *attr,
+			      const char *buf, size_t size)
+{
+	int ret;
+	unsigned long val;
+	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
+
+	ret = kstrtoul(buf, 16, &val);
+	if (ret)
+		return ret;
+
+	if (val >= drvdata->nr_addr_cmp)
+		return -EINVAL;
+
+	/*
+	 * Use spinlock to ensure index doesn't change while it gets
+	 * dereferenced multiple times within a spinlock block elsewhere.
+	 */
+	spin_lock(&drvdata->spinlock);
+	drvdata->addr_idx = val;
+	spin_unlock(&drvdata->spinlock);
+
+	return size;
+}
+static DEVICE_ATTR_RW(addr_idx);
+
+static ssize_t addr_single_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	u8 idx;
+	unsigned long val;
+	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
+
+	spin_lock(&drvdata->spinlock);
+	idx = drvdata->addr_idx;
+	if (!(drvdata->addr_type[idx] == ETM_ADDR_TYPE_NONE ||
+	      drvdata->addr_type[idx] == ETM_ADDR_TYPE_SINGLE)) {
+		spin_unlock(&drvdata->spinlock);
+		return -EINVAL;
+	}
+
+	val = drvdata->addr_val[idx];
+	spin_unlock(&drvdata->spinlock);
+
+	return sprintf(buf, "%#lx\n", val);
+}
+
+static ssize_t addr_single_store(struct device *dev,
+				 struct device_attribute *attr,
+				 const char *buf, size_t size)
+{
+	u8 idx;
+	int ret;
+	unsigned long val;
+	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
+
+	ret = kstrtoul(buf, 16, &val);
+	if (ret)
+		return ret;
+
+	spin_lock(&drvdata->spinlock);
+	idx = drvdata->addr_idx;
+	if (!(drvdata->addr_type[idx] == ETM_ADDR_TYPE_NONE ||
+	      drvdata->addr_type[idx] == ETM_ADDR_TYPE_SINGLE)) {
+		spin_unlock(&drvdata->spinlock);
+		return -EINVAL;
+	}
+
+	drvdata->addr_val[idx] = val;
+	drvdata->addr_type[idx] = ETM_ADDR_TYPE_SINGLE;
+	spin_unlock(&drvdata->spinlock);
+
+	return size;
+}
+static DEVICE_ATTR_RW(addr_single);
+
+static ssize_t addr_range_show(struct device *dev,
+			       struct device_attribute *attr, char *buf)
+{
+	u8 idx;
+	unsigned long val1, val2;
+	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
+
+	spin_lock(&drvdata->spinlock);
+	idx = drvdata->addr_idx;
+	if (idx % 2 != 0) {
+		spin_unlock(&drvdata->spinlock);
+		return -EPERM;
+	}
+	if (!((drvdata->addr_type[idx] == ETM_ADDR_TYPE_NONE &&
+	       drvdata->addr_type[idx + 1] == ETM_ADDR_TYPE_NONE) ||
+	      (drvdata->addr_type[idx] == ETM_ADDR_TYPE_RANGE &&
+	       drvdata->addr_type[idx + 1] == ETM_ADDR_TYPE_RANGE))) {
+		spin_unlock(&drvdata->spinlock);
+		return -EPERM;
+	}
+
+	val1 = drvdata->addr_val[idx];
+	val2 = drvdata->addr_val[idx + 1];
+	spin_unlock(&drvdata->spinlock);
+
+	return sprintf(buf, "%#lx %#lx\n", val1, val2);
+}
+
+static ssize_t addr_range_store(struct device *dev,
+			      struct device_attribute *attr,
+			      const char *buf, size_t size)
+{
+	u8 idx;
+	unsigned long val1, val2;
+	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
+
+	if (sscanf(buf, "%lx %lx", &val1, &val2) != 2)
+		return -EINVAL;
+	/* Lower address comparator cannot have a higher address value */
+	if (val1 > val2)
+		return -EINVAL;
+
+	spin_lock(&drvdata->spinlock);
+	idx = drvdata->addr_idx;
+	if (idx % 2 != 0) {
+		spin_unlock(&drvdata->spinlock);
+		return -EPERM;
+	}
+	if (!((drvdata->addr_type[idx] == ETM_ADDR_TYPE_NONE &&
+	       drvdata->addr_type[idx + 1] == ETM_ADDR_TYPE_NONE) ||
+	      (drvdata->addr_type[idx] == ETM_ADDR_TYPE_RANGE &&
+	       drvdata->addr_type[idx + 1] == ETM_ADDR_TYPE_RANGE))) {
+		spin_unlock(&drvdata->spinlock);
+		return -EPERM;
+	}
+
+	drvdata->addr_val[idx] = val1;
+	drvdata->addr_type[idx] = ETM_ADDR_TYPE_RANGE;
+	drvdata->addr_val[idx + 1] = val2;
+	drvdata->addr_type[idx + 1] = ETM_ADDR_TYPE_RANGE;
+	drvdata->enable_ctrl1 |= (1 << (idx/2));
+	spin_unlock(&drvdata->spinlock);
+
+	return size;
+}
+static DEVICE_ATTR_RW(addr_range);
+
+static ssize_t addr_start_show(struct device *dev,
+			       struct device_attribute *attr, char *buf)
+{
+	u8 idx;
+	unsigned long val;
+	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
+
+	spin_lock(&drvdata->spinlock);
+	idx = drvdata->addr_idx;
+	if (!(drvdata->addr_type[idx] == ETM_ADDR_TYPE_NONE ||
+	      drvdata->addr_type[idx] == ETM_ADDR_TYPE_START)) {
+		spin_unlock(&drvdata->spinlock);
+		return -EPERM;
+	}
+
+	val = drvdata->addr_val[idx];
+	spin_unlock(&drvdata->spinlock);
+
+	return sprintf(buf, "%#lx\n", val);
+}
+
+static ssize_t addr_start_store(struct device *dev,
+				struct device_attribute *attr,
+				const char *buf, size_t size)
+{
+	u8 idx;
+	int ret;
+	unsigned long val;
+	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
+
+	ret = kstrtoul(buf, 16, &val);
+	if (ret)
+		return ret;
+
+	spin_lock(&drvdata->spinlock);
+	idx = drvdata->addr_idx;
+	if (!(drvdata->addr_type[idx] == ETM_ADDR_TYPE_NONE ||
+	      drvdata->addr_type[idx] == ETM_ADDR_TYPE_START)) {
+		spin_unlock(&drvdata->spinlock);
+		return -EPERM;
+	}
+
+	drvdata->addr_val[idx] = val;
+	drvdata->addr_type[idx] = ETM_ADDR_TYPE_START;
+	drvdata->startstop_ctrl |= (1 << idx);
+	drvdata->enable_ctrl1 |= BIT(25);
+	spin_unlock(&drvdata->spinlock);
+
+	return size;
+}
+static DEVICE_ATTR_RW(addr_start);
+
+static ssize_t addr_stop_show(struct device *dev,
+			      struct device_attribute *attr, char *buf)
+{
+	u8 idx;
+	unsigned long val;
+	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
+
+	spin_lock(&drvdata->spinlock);
+	idx = drvdata->addr_idx;
+	if (!(drvdata->addr_type[idx] == ETM_ADDR_TYPE_NONE ||
+	      drvdata->addr_type[idx] == ETM_ADDR_TYPE_STOP)) {
+		spin_unlock(&drvdata->spinlock);
+		return -EPERM;
+	}
+
+	val = drvdata->addr_val[idx];
+	spin_unlock(&drvdata->spinlock);
+
+	return sprintf(buf, "%#lx\n", val);
+}
+
+static ssize_t addr_stop_store(struct device *dev,
+			       struct device_attribute *attr,
+			       const char *buf, size_t size)
+{
+	u8 idx;
+	int ret;
+	unsigned long val;
+	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
+
+	ret = kstrtoul(buf, 16, &val);
+	if (ret)
+		return ret;
+
+	spin_lock(&drvdata->spinlock);
+	idx = drvdata->addr_idx;
+	if (!(drvdata->addr_type[idx] == ETM_ADDR_TYPE_NONE ||
+	      drvdata->addr_type[idx] == ETM_ADDR_TYPE_STOP)) {
+		spin_unlock(&drvdata->spinlock);
+		return -EPERM;
+	}
+
+	drvdata->addr_val[idx] = val;
+	drvdata->addr_type[idx] = ETM_ADDR_TYPE_STOP;
+	drvdata->startstop_ctrl |= (1 << (idx + 16));
+	drvdata->enable_ctrl1 |= ETMTECR1_START_STOP;
+	spin_unlock(&drvdata->spinlock);
+
+	return size;
+}
+static DEVICE_ATTR_RW(addr_stop);
+
+static ssize_t addr_acctype_show(struct device *dev,
+				 struct device_attribute *attr, char *buf)
+{
+	unsigned long val;
+	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
+
+	spin_lock(&drvdata->spinlock);
+	val = drvdata->addr_acctype[drvdata->addr_idx];
+	spin_unlock(&drvdata->spinlock);
+
+	return sprintf(buf, "%#lx\n", val);
+}
+
+static ssize_t addr_acctype_store(struct device *dev,
+				  struct device_attribute *attr,
+				  const char *buf, size_t size)
+{
+	int ret;
+	unsigned long val;
+	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
+
+	ret = kstrtoul(buf, 16, &val);
+	if (ret)
+		return ret;
+
+	spin_lock(&drvdata->spinlock);
+	drvdata->addr_acctype[drvdata->addr_idx] = val;
+	spin_unlock(&drvdata->spinlock);
+
+	return size;
+}
+static DEVICE_ATTR_RW(addr_acctype);
+
+static ssize_t cntr_idx_show(struct device *dev,
+			     struct device_attribute *attr, char *buf)
+{
+	unsigned long val;
+	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
+
+	val = drvdata->cntr_idx;
+	return sprintf(buf, "%#lx\n", val);
+}
+
+static ssize_t cntr_idx_store(struct device *dev,
+			      struct device_attribute *attr,
+			      const char *buf, size_t size)
+{
+	int ret;
+	unsigned long val;
+	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
+
+	ret = kstrtoul(buf, 16, &val);
+	if (ret)
+		return ret;
+
+	if (val >= drvdata->nr_cntr)
+		return -EINVAL;
+	/*
+	 * Use spinlock to ensure index doesn't change while it gets
+	 * dereferenced multiple times within a spinlock block elsewhere.
+	 */
+	spin_lock(&drvdata->spinlock);
+	drvdata->cntr_idx = val;
+	spin_unlock(&drvdata->spinlock);
+
+	return size;
+}
+static DEVICE_ATTR_RW(cntr_idx);
+
+static ssize_t cntr_rld_val_show(struct device *dev,
+				 struct device_attribute *attr, char *buf)
+{
+	unsigned long val;
+	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
+
+	spin_lock(&drvdata->spinlock);
+	val = drvdata->cntr_rld_val[drvdata->cntr_idx];
+	spin_unlock(&drvdata->spinlock);
+
+	return sprintf(buf, "%#lx\n", val);
+}
+
+static ssize_t cntr_rld_val_store(struct device *dev,
+				  struct device_attribute *attr,
+				  const char *buf, size_t size)
+{
+	int ret;
+	unsigned long val;
+	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
+
+	ret = kstrtoul(buf, 16, &val);
+	if (ret)
+		return ret;
+
+	spin_lock(&drvdata->spinlock);
+	drvdata->cntr_rld_val[drvdata->cntr_idx] = val;
+	spin_unlock(&drvdata->spinlock);
+
+	return size;
+}
+static DEVICE_ATTR_RW(cntr_rld_val);
+
+static ssize_t cntr_event_show(struct device *dev,
+			       struct device_attribute *attr, char *buf)
+{
+	unsigned long val;
+	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
+
+	spin_lock(&drvdata->spinlock);
+	val = drvdata->cntr_event[drvdata->cntr_idx];
+	spin_unlock(&drvdata->spinlock);
+
+	return sprintf(buf, "%#lx\n", val);
+}
+
+static ssize_t cntr_event_store(struct device *dev,
+				struct device_attribute *attr,
+				const char *buf, size_t size)
+{
+	int ret;
+	unsigned long val;
+	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
+
+	ret = kstrtoul(buf, 16, &val);
+	if (ret)
+		return ret;
+
+	spin_lock(&drvdata->spinlock);
+	drvdata->cntr_event[drvdata->cntr_idx] = val & ETM_EVENT_MASK;
+	spin_unlock(&drvdata->spinlock);
+
+	return size;
+}
+static DEVICE_ATTR_RW(cntr_event);
+
+static ssize_t cntr_rld_event_show(struct device *dev,
+				   struct device_attribute *attr, char *buf)
+{
+	unsigned long val;
+	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
+
+	spin_lock(&drvdata->spinlock);
+	val = drvdata->cntr_rld_event[drvdata->cntr_idx];
+	spin_unlock(&drvdata->spinlock);
+
+	return sprintf(buf, "%#lx\n", val);
+}
+
+static ssize_t cntr_rld_event_store(struct device *dev,
+				    struct device_attribute *attr,
+				    const char *buf, size_t size)
+{
+	int ret;
+	unsigned long val;
+	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
+
+	ret = kstrtoul(buf, 16, &val);
+	if (ret)
+		return ret;
+
+	spin_lock(&drvdata->spinlock);
+	drvdata->cntr_rld_event[drvdata->cntr_idx] = val & ETM_EVENT_MASK;
+	spin_unlock(&drvdata->spinlock);
+
+	return size;
+}
+static DEVICE_ATTR_RW(cntr_rld_event);
+
+static ssize_t cntr_val_show(struct device *dev,
+			     struct device_attribute *attr, char *buf)
+{
+	int i, ret = 0;
+	u32 val;
+	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
+
+	if (!drvdata->enable) {
+		spin_lock(&drvdata->spinlock);
+		for (i = 0; i < drvdata->nr_cntr; i++)
+			ret += sprintf(buf, "counter %d: %x\n",
+				       i, drvdata->cntr_val[i]);
+		spin_unlock(&drvdata->spinlock);
+		return ret;
+	}
+
+	for (i = 0; i < drvdata->nr_cntr; i++) {
+		val = etm_readl(drvdata, ETMCNTVRn(i));
+		ret += sprintf(buf, "counter %d: %x\n", i, val);
+	}
+
+	return ret;
+}
+
+static ssize_t cntr_val_store(struct device *dev,
+			      struct device_attribute *attr,
+			      const char *buf, size_t size)
+{
+	int ret;
+	unsigned long val;
+	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
+
+	ret = kstrtoul(buf, 16, &val);
+	if (ret)
+		return ret;
+
+	spin_lock(&drvdata->spinlock);
+	drvdata->cntr_val[drvdata->cntr_idx] = val;
+	spin_unlock(&drvdata->spinlock);
+
+	return size;
+}
+static DEVICE_ATTR_RW(cntr_val);
+
+static ssize_t seq_12_event_show(struct device *dev,
+				 struct device_attribute *attr, char *buf)
+{
+	unsigned long val;
+	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
+
+	val = drvdata->seq_12_event;
+	return sprintf(buf, "%#lx\n", val);
+}
+
+static ssize_t seq_12_event_store(struct device *dev,
+				  struct device_attribute *attr,
+				  const char *buf, size_t size)
+{
+	int ret;
+	unsigned long val;
+	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
+
+	ret = kstrtoul(buf, 16, &val);
+	if (ret)
+		return ret;
+
+	drvdata->seq_12_event = val & ETM_EVENT_MASK;
+	return size;
+}
+static DEVICE_ATTR_RW(seq_12_event);
+
+static ssize_t seq_21_event_show(struct device *dev,
+				 struct device_attribute *attr, char *buf)
+{
+	unsigned long val;
+	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
+
+	val = drvdata->seq_21_event;
+	return sprintf(buf, "%#lx\n", val);
+}
+
+static ssize_t seq_21_event_store(struct device *dev,
+				  struct device_attribute *attr,
+				  const char *buf, size_t size)
+{
+	int ret;
+	unsigned long val;
+	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
+
+	ret = kstrtoul(buf, 16, &val);
+	if (ret)
+		return ret;
+
+	drvdata->seq_21_event = val & ETM_EVENT_MASK;
+	return size;
+}
+static DEVICE_ATTR_RW(seq_21_event);
+
+static ssize_t seq_23_event_show(struct device *dev,
+				 struct device_attribute *attr, char *buf)
+{
+	unsigned long val;
+	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
+
+	val = drvdata->seq_23_event;
+	return sprintf(buf, "%#lx\n", val);
+}
+
+static ssize_t seq_23_event_store(struct device *dev,
+				  struct device_attribute *attr,
+				  const char *buf, size_t size)
+{
+	int ret;
+	unsigned long val;
+	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
+
+	ret = kstrtoul(buf, 16, &val);
+	if (ret)
+		return ret;
+
+	drvdata->seq_23_event = val & ETM_EVENT_MASK;
+	return size;
+}
+static DEVICE_ATTR_RW(seq_23_event);
+
+static ssize_t seq_31_event_show(struct device *dev,
+				 struct device_attribute *attr, char *buf)
+{
+	unsigned long val;
+	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
+
+	val = drvdata->seq_31_event;
+	return sprintf(buf, "%#lx\n", val);
+}
+
+static ssize_t seq_31_event_store(struct device *dev,
+				  struct device_attribute *attr,
+				  const char *buf, size_t size)
+{
+	int ret;
+	unsigned long val;
+	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
+
+	ret = kstrtoul(buf, 16, &val);
+	if (ret)
+		return ret;
+
+	drvdata->seq_31_event = val & ETM_EVENT_MASK;
+	return size;
+}
+static DEVICE_ATTR_RW(seq_31_event);
+
+static ssize_t seq_32_event_show(struct device *dev,
+				 struct device_attribute *attr, char *buf)
+{
+	unsigned long val;
+	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
+
+	val = drvdata->seq_32_event;
+	return sprintf(buf, "%#lx\n", val);
+}
+
+static ssize_t seq_32_event_store(struct device *dev,
+				  struct device_attribute *attr,
+				  const char *buf, size_t size)
+{
+	int ret;
+	unsigned long val;
+	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
+
+	ret = kstrtoul(buf, 16, &val);
+	if (ret)
+		return ret;
+
+	drvdata->seq_32_event = val & ETM_EVENT_MASK;
+	return size;
+}
+static DEVICE_ATTR_RW(seq_32_event);
+
+static ssize_t seq_13_event_show(struct device *dev,
+				 struct device_attribute *attr, char *buf)
+{
+	unsigned long val;
+	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
+
+	val = drvdata->seq_13_event;
+	return sprintf(buf, "%#lx\n", val);
+}
+
+static ssize_t seq_13_event_store(struct device *dev,
+				  struct device_attribute *attr,
+				  const char *buf, size_t size)
+{
+	int ret;
+	unsigned long val;
+	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
+
+	ret = kstrtoul(buf, 16, &val);
+	if (ret)
+		return ret;
+
+	drvdata->seq_13_event = val & ETM_EVENT_MASK;
+	return size;
+}
+static DEVICE_ATTR_RW(seq_13_event);
+
+static ssize_t seq_curr_state_show(struct device *dev,
+				   struct device_attribute *attr, char *buf)
+{
+	int ret;
+	unsigned long val, flags;
+	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
+
+	if (!drvdata->enable) {
+		val = drvdata->seq_curr_state;
+		goto out;
+	}
+
+	ret = clk_prepare_enable(drvdata->clk);
+	if (ret)
+		return ret;
+
+	spin_lock_irqsave(&drvdata->spinlock, flags);
+
+	CS_UNLOCK(drvdata->base);
+	val = (etm_readl(drvdata, ETMSQR) & ETM_SQR_MASK);
+	CS_LOCK(drvdata->base);
+
+	spin_unlock_irqrestore(&drvdata->spinlock, flags);
+	clk_disable_unprepare(drvdata->clk);
+out:
+	return sprintf(buf, "%#lx\n", val);
+}
+
+static ssize_t seq_curr_state_store(struct device *dev,
+				    struct device_attribute *attr,
+				    const char *buf, size_t size)
+{
+	int ret;
+	unsigned long val;
+	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
+
+	ret = kstrtoul(buf, 16, &val);
+	if (ret)
+		return ret;
+
+	if (val > ETM_SEQ_STATE_MAX_VAL)
+		return -EINVAL;
+
+	drvdata->seq_curr_state = val;
+
+	return size;
+}
+static DEVICE_ATTR_RW(seq_curr_state);
+
+static ssize_t ctxid_idx_show(struct device *dev,
+			      struct device_attribute *attr, char *buf)
+{
+	unsigned long val;
+	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
+
+	val = drvdata->ctxid_idx;
+	return sprintf(buf, "%#lx\n", val);
+}
+
+static ssize_t ctxid_idx_store(struct device *dev,
+				struct device_attribute *attr,
+				const char *buf, size_t size)
+{
+	int ret;
+	unsigned long val;
+	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
+
+	ret = kstrtoul(buf, 16, &val);
+	if (ret)
+		return ret;
+
+	if (val >= drvdata->nr_ctxid_cmp)
+		return -EINVAL;
+
+	/*
+	 * Use spinlock to ensure index doesn't change while it gets
+	 * dereferenced multiple times within a spinlock block elsewhere.
+	 */
+	spin_lock(&drvdata->spinlock);
+	drvdata->ctxid_idx = val;
+	spin_unlock(&drvdata->spinlock);
+
+	return size;
+}
+static DEVICE_ATTR_RW(ctxid_idx);
+
+static ssize_t ctxid_val_show(struct device *dev,
+			      struct device_attribute *attr, char *buf)
+{
+	unsigned long val;
+	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
+
+	spin_lock(&drvdata->spinlock);
+	val = drvdata->ctxid_val[drvdata->ctxid_idx];
+	spin_unlock(&drvdata->spinlock);
+
+	return sprintf(buf, "%#lx\n", val);
+}
+
+static ssize_t ctxid_val_store(struct device *dev,
+			       struct device_attribute *attr,
+			       const char *buf, size_t size)
+{
+	int ret;
+	unsigned long val;
+	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
+
+	ret = kstrtoul(buf, 16, &val);
+	if (ret)
+		return ret;
+
+	spin_lock(&drvdata->spinlock);
+	drvdata->ctxid_val[drvdata->ctxid_idx] = val;
+	spin_unlock(&drvdata->spinlock);
+
+	return size;
+}
+static DEVICE_ATTR_RW(ctxid_val);
+
+static ssize_t ctxid_mask_show(struct device *dev,
+			       struct device_attribute *attr, char *buf)
+{
+	unsigned long val;
+	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
+
+	val = drvdata->ctxid_mask;
+	return sprintf(buf, "%#lx\n", val);
+}
+
+static ssize_t ctxid_mask_store(struct device *dev,
+				struct device_attribute *attr,
+				const char *buf, size_t size)
+{
+	int ret;
+	unsigned long val;
+	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
+
+	ret = kstrtoul(buf, 16, &val);
+	if (ret)
+		return ret;
+
+	drvdata->ctxid_mask = val;
+	return size;
+}
+static DEVICE_ATTR_RW(ctxid_mask);
+
+static ssize_t sync_freq_show(struct device *dev,
+			      struct device_attribute *attr, char *buf)
+{
+	unsigned long val;
+	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
+
+	val = drvdata->sync_freq;
+	return sprintf(buf, "%#lx\n", val);
+}
+
+static ssize_t sync_freq_store(struct device *dev,
+			       struct device_attribute *attr,
+			       const char *buf, size_t size)
+{
+	int ret;
+	unsigned long val;
+	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
+
+	ret = kstrtoul(buf, 16, &val);
+	if (ret)
+		return ret;
+
+	drvdata->sync_freq = val & ETM_SYNC_MASK;
+	return size;
+}
+static DEVICE_ATTR_RW(sync_freq);
+
+static ssize_t timestamp_event_show(struct device *dev,
+				    struct device_attribute *attr, char *buf)
+{
+	unsigned long val;
+	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
+
+	val = drvdata->timestamp_event;
+	return sprintf(buf, "%#lx\n", val);
+}
+
+static ssize_t timestamp_event_store(struct device *dev,
+				     struct device_attribute *attr,
+				     const char *buf, size_t size)
+{
+	int ret;
+	unsigned long val;
+	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
+
+	ret = kstrtoul(buf, 16, &val);
+	if (ret)
+		return ret;
+
+	drvdata->timestamp_event = val & ETM_EVENT_MASK;
+	return size;
+}
+static DEVICE_ATTR_RW(timestamp_event);
+
+static ssize_t status_show(struct device *dev,
+			   struct device_attribute *attr, char *buf)
+{
+	int ret;
+	unsigned long flags;
+	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
+
+	ret = clk_prepare_enable(drvdata->clk);
+	if (ret)
+		return ret;
+
+	spin_lock_irqsave(&drvdata->spinlock, flags);
+
+	CS_UNLOCK(drvdata->base);
+	ret = sprintf(buf,
+		      "ETMCCR: 0x%08x\n"
+		      "ETMCCER: 0x%08x\n"
+		      "ETMSCR: 0x%08x\n"
+		      "ETMIDR: 0x%08x\n"
+		      "ETMCR: 0x%08x\n"
+		      "ETMTRACEIDR: 0x%08x\n"
+		      "Enable event: 0x%08x\n"
+		      "Enable start/stop: 0x%08x\n"
+		      "Enable control: CR1 0x%08x CR2 0x%08x\n"
+		      "CPU affinity: %d\n",
+		      drvdata->etmccr, drvdata->etmccer,
+		      etm_readl(drvdata, ETMSCR), etm_readl(drvdata, ETMIDR),
+		      etm_readl(drvdata, ETMCR), etm_trace_id_simple(drvdata),
+		      etm_readl(drvdata, ETMTEEVR),
+		      etm_readl(drvdata, ETMTSSCR),
+		      etm_readl(drvdata, ETMTECR1),
+		      etm_readl(drvdata, ETMTECR2),
+		      drvdata->cpu);
+	CS_LOCK(drvdata->base);
+
+	spin_unlock_irqrestore(&drvdata->spinlock, flags);
+	clk_disable_unprepare(drvdata->clk);
+
+	return ret;
+}
+static DEVICE_ATTR_RO(status);
+
+static ssize_t traceid_show(struct device *dev,
+			    struct device_attribute *attr, char *buf)
+{
+	int ret;
+	unsigned long val, flags;
+	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
+
+	if (!drvdata->enable) {
+		val = drvdata->traceid;
+		goto out;
+	}
+
+	ret = clk_prepare_enable(drvdata->clk);
+	if (ret)
+		return ret;
+
+	spin_lock_irqsave(&drvdata->spinlock, flags);
+	CS_UNLOCK(drvdata->base);
+
+	val = (etm_readl(drvdata, ETMTRACEIDR) & ETM_TRACEID_MASK);
+
+	CS_LOCK(drvdata->base);
+	spin_unlock_irqrestore(&drvdata->spinlock, flags);
+	clk_disable_unprepare(drvdata->clk);
+out:
+	return sprintf(buf, "%#lx\n", val);
+}
+
+static ssize_t traceid_store(struct device *dev,
+			     struct device_attribute *attr,
+			     const char *buf, size_t size)
+{
+	int ret;
+	unsigned long val;
+	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
+
+	ret = kstrtoul(buf, 16, &val);
+	if (ret)
+		return ret;
+
+	drvdata->traceid = val & ETM_TRACEID_MASK;
+	return size;
+}
+static DEVICE_ATTR_RW(traceid);
+
+static struct attribute *coresight_etm_attrs[] = {
+	&dev_attr_nr_addr_cmp.attr,
+	&dev_attr_nr_cntr.attr,
+	&dev_attr_nr_ctxid_cmp.attr,
+	&dev_attr_etmsr.attr,
+	&dev_attr_reset.attr,
+	&dev_attr_mode.attr,
+	&dev_attr_trigger_event.attr,
+	&dev_attr_enable_event.attr,
+	&dev_attr_fifofull_level.attr,
+	&dev_attr_addr_idx.attr,
+	&dev_attr_addr_single.attr,
+	&dev_attr_addr_range.attr,
+	&dev_attr_addr_start.attr,
+	&dev_attr_addr_stop.attr,
+	&dev_attr_addr_acctype.attr,
+	&dev_attr_cntr_idx.attr,
+	&dev_attr_cntr_rld_val.attr,
+	&dev_attr_cntr_event.attr,
+	&dev_attr_cntr_rld_event.attr,
+	&dev_attr_cntr_val.attr,
+	&dev_attr_seq_12_event.attr,
+	&dev_attr_seq_21_event.attr,
+	&dev_attr_seq_23_event.attr,
+	&dev_attr_seq_31_event.attr,
+	&dev_attr_seq_32_event.attr,
+	&dev_attr_seq_13_event.attr,
+	&dev_attr_seq_curr_state.attr,
+	&dev_attr_ctxid_idx.attr,
+	&dev_attr_ctxid_val.attr,
+	&dev_attr_ctxid_mask.attr,
+	&dev_attr_sync_freq.attr,
+	&dev_attr_timestamp_event.attr,
+	&dev_attr_status.attr,
+	&dev_attr_traceid.attr,
+	NULL,
+};
+ATTRIBUTE_GROUPS(coresight_etm);
+
+static int etm_cpu_callback(struct notifier_block *nfb, unsigned long action,
+			    void *hcpu)
+{
+	unsigned int cpu = (unsigned long)hcpu;
+
+	if (!etmdrvdata[cpu])
+		goto out;
+
+	switch (action & (~CPU_TASKS_FROZEN)) {
+	case CPU_STARTING:
+		spin_lock(&etmdrvdata[cpu]->spinlock);
+		if (!etmdrvdata[cpu]->os_unlock) {
+			etm_os_unlock(etmdrvdata[cpu]);
+			etmdrvdata[cpu]->os_unlock = true;
+		}
+
+		if (etmdrvdata[cpu]->enable)
+			etm_enable_hw(etmdrvdata[cpu]);
+		spin_unlock(&etmdrvdata[cpu]->spinlock);
+		break;
+
+	case CPU_ONLINE:
+		if (etmdrvdata[cpu]->boot_enable &&
+		    !etmdrvdata[cpu]->sticky_enable)
+			coresight_enable(etmdrvdata[cpu]->csdev);
+		break;
+
+	case CPU_DYING:
+		spin_lock(&etmdrvdata[cpu]->spinlock);
+		if (etmdrvdata[cpu]->enable)
+			etm_disable_hw(etmdrvdata[cpu]);
+		spin_unlock(&etmdrvdata[cpu]->spinlock);
+		break;
+	}
+out:
+	return NOTIFY_OK;
+}
+
+static struct notifier_block etm_cpu_notifier = {
+	.notifier_call = etm_cpu_callback,
+};
+
+static bool etm_arch_supported(u8 arch)
+{
+	switch (arch) {
+	case ETM_ARCH_V3_3:
+		break;
+	case ETM_ARCH_V3_5:
+		break;
+	case PFT_ARCH_V1_0:
+		break;
+	case PFT_ARCH_V1_1:
+		break;
+	default:
+		return false;
+	}
+	return true;
+}
+
+static void etm_init_arch_data(void *info)
+{
+	u32 etmidr;
+	u32 etmccr;
+	struct etm_drvdata *drvdata = info;
+
+	CS_UNLOCK(drvdata->base);
+
+	/* First dummy read */
+	(void)etm_readl(drvdata, ETMPDSR);
+	/* Provide power to ETM: ETMPDCR[3] == 1 */
+	etm_set_pwrup(drvdata);
+	/*
+	 * Clear power down bit since when this bit is set writes to
+	 * certain registers might be ignored.
+	 */
+	etm_clr_pwrdwn(drvdata);
+	/*
+	 * Set prog bit. It will be set from reset but this is included to
+	 * ensure it is set
+	 */
+	etm_set_prog(drvdata);
+
+	/* Find all capabilities */
+	etmidr = etm_readl(drvdata, ETMIDR);
+	drvdata->arch = BMVAL(etmidr, 4, 11);
+	drvdata->port_size = etm_readl(drvdata, ETMCR) & PORT_SIZE_MASK;
+
+	drvdata->etmccer = etm_readl(drvdata, ETMCCER);
+	etmccr = etm_readl(drvdata, ETMCCR);
+	drvdata->etmccr = etmccr;
+	drvdata->nr_addr_cmp = BMVAL(etmccr, 0, 3) * 2;
+	drvdata->nr_cntr = BMVAL(etmccr, 13, 15);
+	drvdata->nr_ext_inp = BMVAL(etmccr, 17, 19);
+	drvdata->nr_ext_out = BMVAL(etmccr, 20, 22);
+	drvdata->nr_ctxid_cmp = BMVAL(etmccr, 24, 25);
+
+	etm_set_pwrdwn(drvdata);
+	etm_clr_pwrup(drvdata);
+	CS_LOCK(drvdata->base);
+}
+
+static void etm_init_default_data(struct etm_drvdata *drvdata)
+{
+	/*
+	 * A trace ID of value 0 is invalid, so let's start at some
+	 * random value that fits in 7 bits and will be just as good.
+	 */
+	static int etm3x_traceid = 0x10;
+
+	u32 flags = (1 << 0 | /* instruction execute*/
+		     3 << 3 | /* ARM instruction */
+		     0 << 5 | /* No data value comparison */
+		     0 << 7 | /* No exact mach */
+		     0 << 8 | /* Ignore context ID */
+		     0 << 10); /* Security ignored */
+
+	/*
+	 * Initial configuration only - guarantees sources handled by
+	 * this driver have a unique ID at startup time but not between
+	 * all other types of sources.  For that we lean on the core
+	 * framework.
+	 */
+	drvdata->traceid = etm3x_traceid++;
+	drvdata->ctrl = (ETMCR_CYC_ACC | ETMCR_TIMESTAMP_EN);
+	drvdata->enable_ctrl1 = ETMTECR1_ADDR_COMP_1;
+	if (drvdata->nr_addr_cmp >= 2) {
+		drvdata->addr_val[0] = (u32) _stext;
+		drvdata->addr_val[1] = (u32) _etext;
+		drvdata->addr_acctype[0] = flags;
+		drvdata->addr_acctype[1] = flags;
+		drvdata->addr_type[0] = ETM_ADDR_TYPE_RANGE;
+		drvdata->addr_type[1] = ETM_ADDR_TYPE_RANGE;
+	}
+
+	etm_set_default(drvdata);
+}
+
+static int etm_probe(struct amba_device *adev, const struct amba_id *id)
+{
+	int ret;
+	void __iomem *base;
+	struct device *dev = &adev->dev;
+	struct coresight_platform_data *pdata = NULL;
+	struct etm_drvdata *drvdata;
+	struct resource *res = &adev->res;
+	struct coresight_desc *desc;
+	struct device_node *np = adev->dev.of_node;
+
+	desc = devm_kzalloc(dev, sizeof(*desc), GFP_KERNEL);
+	if (!desc)
+		return -ENOMEM;
+
+	drvdata = devm_kzalloc(dev, sizeof(*drvdata), GFP_KERNEL);
+	if (!drvdata)
+		return -ENOMEM;
+
+	if (np) {
+		pdata = of_get_coresight_platform_data(dev, np);
+		if (IS_ERR(pdata))
+			return PTR_ERR(pdata);
+
+		adev->dev.platform_data = pdata;
+		drvdata->use_cp14 = of_property_read_bool(np, "arm,cp14");
+	}
+
+	drvdata->dev = &adev->dev;
+	dev_set_drvdata(dev, drvdata);
+
+	/* Validity for the resource is already checked by the AMBA core */
+	base = devm_ioremap_resource(dev, res);
+	if (IS_ERR(base))
+		return PTR_ERR(base);
+
+	drvdata->base = base;
+
+	spin_lock_init(&drvdata->spinlock);
+
+	drvdata->clk = adev->pclk;
+	ret = clk_prepare_enable(drvdata->clk);
+	if (ret)
+		return ret;
+
+	drvdata->cpu = pdata ? pdata->cpu : 0;
+
+	get_online_cpus();
+	etmdrvdata[drvdata->cpu] = drvdata;
+
+	if (!smp_call_function_single(drvdata->cpu, etm_os_unlock, drvdata, 1))
+		drvdata->os_unlock = true;
+
+	if (smp_call_function_single(drvdata->cpu,
+				     etm_init_arch_data,  drvdata, 1))
+		dev_err(dev, "ETM arch init failed\n");
+
+	if (!etm_count++)
+		register_hotcpu_notifier(&etm_cpu_notifier);
+
+	put_online_cpus();
+
+	if (etm_arch_supported(drvdata->arch) == false) {
+		ret = -EINVAL;
+		goto err_arch_supported;
+	}
+	etm_init_default_data(drvdata);
+
+	clk_disable_unprepare(drvdata->clk);
+
+	desc->type = CORESIGHT_DEV_TYPE_SOURCE;
+	desc->subtype.source_subtype = CORESIGHT_DEV_SUBTYPE_SOURCE_PROC;
+	desc->ops = &etm_cs_ops;
+	desc->pdata = pdata;
+	desc->dev = dev;
+	desc->groups = coresight_etm_groups;
+	drvdata->csdev = coresight_register(desc);
+	if (IS_ERR(drvdata->csdev)) {
+		ret = PTR_ERR(drvdata->csdev);
+		goto err_arch_supported;
+	}
+
+	dev_info(dev, "ETM initialized\n");
+
+	if (boot_enable) {
+		coresight_enable(drvdata->csdev);
+		drvdata->boot_enable = true;
+	}
+
+	return 0;
+
+err_arch_supported:
+	clk_disable_unprepare(drvdata->clk);
+	if (--etm_count == 0)
+		unregister_hotcpu_notifier(&etm_cpu_notifier);
+	return ret;
+}
+
+static int etm_remove(struct amba_device *adev)
+{
+	struct etm_drvdata *drvdata = amba_get_drvdata(adev);
+
+	coresight_unregister(drvdata->csdev);
+	if (--etm_count == 0)
+		unregister_hotcpu_notifier(&etm_cpu_notifier);
+
+	return 0;
+}
+
+static struct amba_id etm_ids[] = {
+	{	/* ETM 3.3 */
+		.id	= 0x0003b921,
+		.mask	= 0x0003ffff,
+	},
+	{	/* ETM 3.5 */
+		.id	= 0x0003b956,
+		.mask	= 0x0003ffff,
+	},
+	{	/* PTM 1.0 */
+		.id	= 0x0003b950,
+		.mask	= 0x0003ffff,
+	},
+	{	/* PTM 1.1 */
+		.id	= 0x0003b95f,
+		.mask	= 0x0003ffff,
+	},
+	{ 0, 0},
+};
+
+static struct amba_driver etm_driver = {
+	.drv = {
+		.name	= "coresight-etm3x",
+		.owner	= THIS_MODULE,
+	},
+	.probe		= etm_probe,
+	.remove		= etm_remove,
+	.id_table	= etm_ids,
+};
+
+int __init etm_init(void)
+{
+	return amba_driver_register(&etm_driver);
+}
+module_init(etm_init);
+
+void __exit etm_exit(void)
+{
+	amba_driver_unregister(&etm_driver);
+}
+module_exit(etm_exit);
+
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("CoreSight Program Flow Trace driver");
diff --git a/drivers/hwtracing/coresight/coresight-funnel.c b/drivers/hwtracing/coresight/coresight-funnel.c
new file mode 100644
index 000000000000..3db36f70b666
--- /dev/null
+++ b/drivers/hwtracing/coresight/coresight-funnel.c
@@ -0,0 +1,258 @@
+/* Copyright (c) 2011-2012, The Linux Foundation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/types.h>
+#include <linux/device.h>
+#include <linux/err.h>
+#include <linux/fs.h>
+#include <linux/slab.h>
+#include <linux/clk.h>
+#include <linux/coresight.h>
+#include <linux/amba/bus.h>
+
+#include "coresight-priv.h"
+
+#define FUNNEL_FUNCTL		0x000
+#define FUNNEL_PRICTL		0x004
+
+#define FUNNEL_HOLDTIME_MASK	0xf00
+#define FUNNEL_HOLDTIME_SHFT	0x8
+#define FUNNEL_HOLDTIME		(0x7 << FUNNEL_HOLDTIME_SHFT)
+
+/**
+ * struct funnel_drvdata - specifics associated to a funnel component
+ * @base:	memory mapped base address for this component.
+ * @dev:	the device entity associated to this component.
+ * @csdev:	component vitals needed by the framework.
+ * @clk:	the clock this component is associated to.
+ * @priority:	port selection order.
+ */
+struct funnel_drvdata {
+	void __iomem		*base;
+	struct device		*dev;
+	struct coresight_device	*csdev;
+	struct clk		*clk;
+	unsigned long		priority;
+};
+
+static void funnel_enable_hw(struct funnel_drvdata *drvdata, int port)
+{
+	u32 functl;
+
+	CS_UNLOCK(drvdata->base);
+
+	functl = readl_relaxed(drvdata->base + FUNNEL_FUNCTL);
+	functl &= ~FUNNEL_HOLDTIME_MASK;
+	functl |= FUNNEL_HOLDTIME;
+	functl |= (1 << port);
+	writel_relaxed(functl, drvdata->base + FUNNEL_FUNCTL);
+	writel_relaxed(drvdata->priority, drvdata->base + FUNNEL_PRICTL);
+
+	CS_LOCK(drvdata->base);
+}
+
+static int funnel_enable(struct coresight_device *csdev, int inport,
+			 int outport)
+{
+	struct funnel_drvdata *drvdata = dev_get_drvdata(csdev->dev.parent);
+	int ret;
+
+	ret = clk_prepare_enable(drvdata->clk);
+	if (ret)
+		return ret;
+
+	funnel_enable_hw(drvdata, inport);
+
+	dev_info(drvdata->dev, "FUNNEL inport %d enabled\n", inport);
+	return 0;
+}
+
+static void funnel_disable_hw(struct funnel_drvdata *drvdata, int inport)
+{
+	u32 functl;
+
+	CS_UNLOCK(drvdata->base);
+
+	functl = readl_relaxed(drvdata->base + FUNNEL_FUNCTL);
+	functl &= ~(1 << inport);
+	writel_relaxed(functl, drvdata->base + FUNNEL_FUNCTL);
+
+	CS_LOCK(drvdata->base);
+}
+
+static void funnel_disable(struct coresight_device *csdev, int inport,
+			   int outport)
+{
+	struct funnel_drvdata *drvdata = dev_get_drvdata(csdev->dev.parent);
+
+	funnel_disable_hw(drvdata, inport);
+
+	clk_disable_unprepare(drvdata->clk);
+
+	dev_info(drvdata->dev, "FUNNEL inport %d disabled\n", inport);
+}
+
+static const struct coresight_ops_link funnel_link_ops = {
+	.enable		= funnel_enable,
+	.disable	= funnel_disable,
+};
+
+static const struct coresight_ops funnel_cs_ops = {
+	.link_ops	= &funnel_link_ops,
+};
+
+static ssize_t priority_show(struct device *dev,
+			     struct device_attribute *attr, char *buf)
+{
+	struct funnel_drvdata *drvdata = dev_get_drvdata(dev->parent);
+	unsigned long val = drvdata->priority;
+
+	return sprintf(buf, "%#lx\n", val);
+}
+
+static ssize_t priority_store(struct device *dev,
+			      struct device_attribute *attr,
+			      const char *buf, size_t size)
+{
+	int ret;
+	unsigned long val;
+	struct funnel_drvdata *drvdata = dev_get_drvdata(dev->parent);
+
+	ret = kstrtoul(buf, 16, &val);
+	if (ret)
+		return ret;
+
+	drvdata->priority = val;
+	return size;
+}
+static DEVICE_ATTR_RW(priority);
+
+static u32 get_funnel_ctrl_hw(struct funnel_drvdata *drvdata)
+{
+	u32 functl;
+
+	CS_UNLOCK(drvdata->base);
+	functl = readl_relaxed(drvdata->base + FUNNEL_FUNCTL);
+	CS_LOCK(drvdata->base);
+
+	return functl;
+}
+
+static ssize_t funnel_ctrl_show(struct device *dev,
+			     struct device_attribute *attr, char *buf)
+{
+	int ret;
+	u32 val;
+	struct funnel_drvdata *drvdata = dev_get_drvdata(dev->parent);
+
+	ret = clk_prepare_enable(drvdata->clk);
+	if (ret)
+		return ret;
+
+	val = get_funnel_ctrl_hw(drvdata);
+	clk_disable_unprepare(drvdata->clk);
+
+	return sprintf(buf, "%#x\n", val);
+}
+static DEVICE_ATTR_RO(funnel_ctrl);
+
+static struct attribute *coresight_funnel_attrs[] = {
+	&dev_attr_funnel_ctrl.attr,
+	&dev_attr_priority.attr,
+	NULL,
+};
+ATTRIBUTE_GROUPS(coresight_funnel);
+
+static int funnel_probe(struct amba_device *adev, const struct amba_id *id)
+{
+	void __iomem *base;
+	struct device *dev = &adev->dev;
+	struct coresight_platform_data *pdata = NULL;
+	struct funnel_drvdata *drvdata;
+	struct resource *res = &adev->res;
+	struct coresight_desc *desc;
+	struct device_node *np = adev->dev.of_node;
+
+	if (np) {
+		pdata = of_get_coresight_platform_data(dev, np);
+		if (IS_ERR(pdata))
+			return PTR_ERR(pdata);
+		adev->dev.platform_data = pdata;
+	}
+
+	drvdata = devm_kzalloc(dev, sizeof(*drvdata), GFP_KERNEL);
+	if (!drvdata)
+		return -ENOMEM;
+
+	drvdata->dev = &adev->dev;
+	dev_set_drvdata(dev, drvdata);
+
+	/* Validity for the resource is already checked by the AMBA core */
+	base = devm_ioremap_resource(dev, res);
+	if (IS_ERR(base))
+		return PTR_ERR(base);
+
+	drvdata->base = base;
+
+	drvdata->clk = adev->pclk;
+
+	desc = devm_kzalloc(dev, sizeof(*desc), GFP_KERNEL);
+	if (!desc)
+		return -ENOMEM;
+
+	desc->type = CORESIGHT_DEV_TYPE_LINK;
+	desc->subtype.link_subtype = CORESIGHT_DEV_SUBTYPE_LINK_MERG;
+	desc->ops = &funnel_cs_ops;
+	desc->pdata = pdata;
+	desc->dev = dev;
+	desc->groups = coresight_funnel_groups;
+	drvdata->csdev = coresight_register(desc);
+	if (IS_ERR(drvdata->csdev))
+		return PTR_ERR(drvdata->csdev);
+
+	dev_info(dev, "FUNNEL initialized\n");
+	return 0;
+}
+
+static int funnel_remove(struct amba_device *adev)
+{
+	struct funnel_drvdata *drvdata = amba_get_drvdata(adev);
+
+	coresight_unregister(drvdata->csdev);
+	return 0;
+}
+
+static struct amba_id funnel_ids[] = {
+	{
+		.id     = 0x0003b908,
+		.mask   = 0x0003ffff,
+	},
+	{ 0, 0},
+};
+
+static struct amba_driver funnel_driver = {
+	.drv = {
+		.name	= "coresight-funnel",
+		.owner	= THIS_MODULE,
+	},
+	.probe		= funnel_probe,
+	.remove		= funnel_remove,
+	.id_table	= funnel_ids,
+};
+
+module_amba_driver(funnel_driver);
+
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("CoreSight Funnel driver");
diff --git a/drivers/hwtracing/coresight/coresight-priv.h b/drivers/hwtracing/coresight/coresight-priv.h
new file mode 100644
index 000000000000..62fcd98cc7cf
--- /dev/null
+++ b/drivers/hwtracing/coresight/coresight-priv.h
@@ -0,0 +1,63 @@
+/* Copyright (c) 2011-2012, The Linux Foundation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef _CORESIGHT_PRIV_H
+#define _CORESIGHT_PRIV_H
+
+#include <linux/bitops.h>
+#include <linux/io.h>
+#include <linux/coresight.h>
+
+/*
+ * Coresight management registers (0xf00-0xfcc)
+ * 0xfa0 - 0xfa4: Management	registers in PFTv1.0
+ *		  Trace		registers in PFTv1.1
+ */
+#define CORESIGHT_ITCTRL	0xf00
+#define CORESIGHT_CLAIMSET	0xfa0
+#define CORESIGHT_CLAIMCLR	0xfa4
+#define CORESIGHT_LAR		0xfb0
+#define CORESIGHT_LSR		0xfb4
+#define CORESIGHT_AUTHSTATUS	0xfb8
+#define CORESIGHT_DEVID		0xfc8
+#define CORESIGHT_DEVTYPE	0xfcc
+
+#define TIMEOUT_US		100
+#define BMVAL(val, lsb, msb)	((val & GENMASK(msb, lsb)) >> lsb)
+
+static inline void CS_LOCK(void __iomem *addr)
+{
+	do {
+		/* Wait for things to settle */
+		mb();
+		writel_relaxed(0x0, addr + CORESIGHT_LAR);
+	} while (0);
+}
+
+static inline void CS_UNLOCK(void __iomem *addr)
+{
+	do {
+		writel_relaxed(CORESIGHT_UNLOCK, addr + CORESIGHT_LAR);
+		/* Make sure everyone has seen this */
+		mb();
+	} while (0);
+}
+
+#ifdef CONFIG_CORESIGHT_SOURCE_ETM3X
+extern int etm_readl_cp14(u32 off, unsigned int *val);
+extern int etm_writel_cp14(u32 off, u32 val);
+#else
+static inline int etm_readl_cp14(u32 off, unsigned int *val) { return 0; }
+static inline int etm_writel_cp14(u32 off, u32 val) { return 0; }
+#endif
+
+#endif
diff --git a/drivers/hwtracing/coresight/coresight-replicator.c b/drivers/hwtracing/coresight/coresight-replicator.c
new file mode 100644
index 000000000000..75b9abd804e6
--- /dev/null
+++ b/drivers/hwtracing/coresight/coresight-replicator.c
@@ -0,0 +1,137 @@
+/* Copyright (c) 2011-2012, The Linux Foundation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/device.h>
+#include <linux/platform_device.h>
+#include <linux/io.h>
+#include <linux/err.h>
+#include <linux/slab.h>
+#include <linux/clk.h>
+#include <linux/of.h>
+#include <linux/coresight.h>
+
+#include "coresight-priv.h"
+
+/**
+ * struct replicator_drvdata - specifics associated to a replicator component
+ * @dev:	the device entity associated with this component
+ * @csdev:	component vitals needed by the framework
+ */
+struct replicator_drvdata {
+	struct device		*dev;
+	struct coresight_device	*csdev;
+};
+
+static int replicator_enable(struct coresight_device *csdev, int inport,
+			     int outport)
+{
+	struct replicator_drvdata *drvdata = dev_get_drvdata(csdev->dev.parent);
+
+	dev_info(drvdata->dev, "REPLICATOR enabled\n");
+	return 0;
+}
+
+static void replicator_disable(struct coresight_device *csdev, int inport,
+			       int outport)
+{
+	struct replicator_drvdata *drvdata = dev_get_drvdata(csdev->dev.parent);
+
+	dev_info(drvdata->dev, "REPLICATOR disabled\n");
+}
+
+static const struct coresight_ops_link replicator_link_ops = {
+	.enable		= replicator_enable,
+	.disable	= replicator_disable,
+};
+
+static const struct coresight_ops replicator_cs_ops = {
+	.link_ops	= &replicator_link_ops,
+};
+
+static int replicator_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct coresight_platform_data *pdata = NULL;
+	struct replicator_drvdata *drvdata;
+	struct coresight_desc *desc;
+	struct device_node *np = pdev->dev.of_node;
+
+	if (np) {
+		pdata = of_get_coresight_platform_data(dev, np);
+		if (IS_ERR(pdata))
+			return PTR_ERR(pdata);
+		pdev->dev.platform_data = pdata;
+	}
+
+	drvdata = devm_kzalloc(dev, sizeof(*drvdata), GFP_KERNEL);
+	if (!drvdata)
+		return -ENOMEM;
+
+	drvdata->dev = &pdev->dev;
+	platform_set_drvdata(pdev, drvdata);
+
+	desc = devm_kzalloc(dev, sizeof(*desc), GFP_KERNEL);
+	if (!desc)
+		return -ENOMEM;
+
+	desc->type = CORESIGHT_DEV_TYPE_LINK;
+	desc->subtype.link_subtype = CORESIGHT_DEV_SUBTYPE_LINK_SPLIT;
+	desc->ops = &replicator_cs_ops;
+	desc->pdata = pdev->dev.platform_data;
+	desc->dev = &pdev->dev;
+	drvdata->csdev = coresight_register(desc);
+	if (IS_ERR(drvdata->csdev))
+		return PTR_ERR(drvdata->csdev);
+
+	dev_info(dev, "REPLICATOR initialized\n");
+	return 0;
+}
+
+static int replicator_remove(struct platform_device *pdev)
+{
+	struct replicator_drvdata *drvdata = platform_get_drvdata(pdev);
+
+	coresight_unregister(drvdata->csdev);
+	return 0;
+}
+
+static const struct of_device_id replicator_match[] = {
+	{.compatible = "arm,coresight-replicator"},
+	{}
+};
+
+static struct platform_driver replicator_driver = {
+	.probe          = replicator_probe,
+	.remove         = replicator_remove,
+	.driver         = {
+		.name   = "coresight-replicator",
+		.of_match_table = replicator_match,
+	},
+};
+
+static int __init replicator_init(void)
+{
+	return platform_driver_register(&replicator_driver);
+}
+module_init(replicator_init);
+
+static void __exit replicator_exit(void)
+{
+	platform_driver_unregister(&replicator_driver);
+}
+module_exit(replicator_exit);
+
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("CoreSight Replicator driver");
diff --git a/drivers/hwtracing/coresight/coresight-tmc.c b/drivers/hwtracing/coresight/coresight-tmc.c
new file mode 100644
index 000000000000..7147f3dd363c
--- /dev/null
+++ b/drivers/hwtracing/coresight/coresight-tmc.c
@@ -0,0 +1,822 @@
+/* Copyright (c) 2012, The Linux Foundation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/types.h>
+#include <linux/device.h>
+#include <linux/io.h>
+#include <linux/err.h>
+#include <linux/fs.h>
+#include <linux/miscdevice.h>
+#include <linux/uaccess.h>
+#include <linux/slab.h>
+#include <linux/dma-mapping.h>
+#include <linux/spinlock.h>
+#include <linux/clk.h>
+#include <linux/of.h>
+#include <linux/coresight.h>
+#include <linux/amba/bus.h>
+
+#include "coresight-priv.h"
+
+#define TMC_RSZ			0x004
+#define TMC_STS			0x00c
+#define TMC_RRD			0x010
+#define TMC_RRP			0x014
+#define TMC_RWP			0x018
+#define TMC_TRG			0x01c
+#define TMC_CTL			0x020
+#define TMC_RWD			0x024
+#define TMC_MODE		0x028
+#define TMC_LBUFLEVEL		0x02c
+#define TMC_CBUFLEVEL		0x030
+#define TMC_BUFWM		0x034
+#define TMC_RRPHI		0x038
+#define TMC_RWPHI		0x03c
+#define TMC_AXICTL		0x110
+#define TMC_DBALO		0x118
+#define TMC_DBAHI		0x11c
+#define TMC_FFSR		0x300
+#define TMC_FFCR		0x304
+#define TMC_PSCR		0x308
+#define TMC_ITMISCOP0		0xee0
+#define TMC_ITTRFLIN		0xee8
+#define TMC_ITATBDATA0		0xeec
+#define TMC_ITATBCTR2		0xef0
+#define TMC_ITATBCTR1		0xef4
+#define TMC_ITATBCTR0		0xef8
+
+/* register description */
+/* TMC_CTL - 0x020 */
+#define TMC_CTL_CAPT_EN		BIT(0)
+/* TMC_STS - 0x00C */
+#define TMC_STS_TRIGGERED	BIT(1)
+/* TMC_AXICTL - 0x110 */
+#define TMC_AXICTL_PROT_CTL_B0	BIT(0)
+#define TMC_AXICTL_PROT_CTL_B1	BIT(1)
+#define TMC_AXICTL_SCT_GAT_MODE	BIT(7)
+#define TMC_AXICTL_WR_BURST_LEN 0xF00
+/* TMC_FFCR - 0x304 */
+#define TMC_FFCR_EN_FMT		BIT(0)
+#define TMC_FFCR_EN_TI		BIT(1)
+#define TMC_FFCR_FON_FLIN	BIT(4)
+#define TMC_FFCR_FON_TRIG_EVT	BIT(5)
+#define TMC_FFCR_FLUSHMAN	BIT(6)
+#define TMC_FFCR_TRIGON_TRIGIN	BIT(8)
+#define TMC_FFCR_STOP_ON_FLUSH	BIT(12)
+
+#define TMC_STS_TRIGGERED_BIT	2
+#define TMC_FFCR_FLUSHMAN_BIT	6
+
+enum tmc_config_type {
+	TMC_CONFIG_TYPE_ETB,
+	TMC_CONFIG_TYPE_ETR,
+	TMC_CONFIG_TYPE_ETF,
+};
+
+enum tmc_mode {
+	TMC_MODE_CIRCULAR_BUFFER,
+	TMC_MODE_SOFTWARE_FIFO,
+	TMC_MODE_HARDWARE_FIFO,
+};
+
+enum tmc_mem_intf_width {
+	TMC_MEM_INTF_WIDTH_32BITS	= 0x2,
+	TMC_MEM_INTF_WIDTH_64BITS	= 0x3,
+	TMC_MEM_INTF_WIDTH_128BITS	= 0x4,
+	TMC_MEM_INTF_WIDTH_256BITS	= 0x5,
+};
+
+/**
+ * struct tmc_drvdata - specifics associated to an TMC component
+ * @base:	memory mapped base address for this component.
+ * @dev:	the device entity associated to this component.
+ * @csdev:	component vitals needed by the framework.
+ * @miscdev:	specifics to handle "/dev/xyz.tmc" entry.
+ * @clk:	the clock this component is associated to.
+ * @spinlock:	only one at a time pls.
+ * @read_count:	manages preparation of buffer for reading.
+ * @buf:	area of memory where trace data get sent.
+ * @paddr:	DMA start location in RAM.
+ * @vaddr:	virtual representation of @paddr.
+ * @size:	@buf size.
+ * @enable:	this TMC is being used.
+ * @config_type: TMC variant, must be of type @tmc_config_type.
+ * @trigger_cntr: amount of words to store after a trigger.
+ */
+struct tmc_drvdata {
+	void __iomem		*base;
+	struct device		*dev;
+	struct coresight_device	*csdev;
+	struct miscdevice	miscdev;
+	struct clk		*clk;
+	spinlock_t		spinlock;
+	int			read_count;
+	bool			reading;
+	char			*buf;
+	dma_addr_t		paddr;
+	void __iomem		*vaddr;
+	u32			size;
+	bool			enable;
+	enum tmc_config_type	config_type;
+	u32			trigger_cntr;
+};
+
+static void tmc_wait_for_ready(struct tmc_drvdata *drvdata)
+{
+	/* Ensure formatter, unformatter and hardware fifo are empty */
+	if (coresight_timeout(drvdata->base,
+			      TMC_STS, TMC_STS_TRIGGERED_BIT, 1)) {
+		dev_err(drvdata->dev,
+			"timeout observed when probing at offset %#x\n",
+			TMC_STS);
+	}
+}
+
+static void tmc_flush_and_stop(struct tmc_drvdata *drvdata)
+{
+	u32 ffcr;
+
+	ffcr = readl_relaxed(drvdata->base + TMC_FFCR);
+	ffcr |= TMC_FFCR_STOP_ON_FLUSH;
+	writel_relaxed(ffcr, drvdata->base + TMC_FFCR);
+	ffcr |= TMC_FFCR_FLUSHMAN;
+	writel_relaxed(ffcr, drvdata->base + TMC_FFCR);
+	/* Ensure flush completes */
+	if (coresight_timeout(drvdata->base,
+			      TMC_FFCR, TMC_FFCR_FLUSHMAN_BIT, 0)) {
+		dev_err(drvdata->dev,
+			"timeout observed when probing at offset %#x\n",
+			TMC_FFCR);
+	}
+
+	tmc_wait_for_ready(drvdata);
+}
+
+static void tmc_enable_hw(struct tmc_drvdata *drvdata)
+{
+	writel_relaxed(TMC_CTL_CAPT_EN, drvdata->base + TMC_CTL);
+}
+
+static void tmc_disable_hw(struct tmc_drvdata *drvdata)
+{
+	writel_relaxed(0x0, drvdata->base + TMC_CTL);
+}
+
+static void tmc_etb_enable_hw(struct tmc_drvdata *drvdata)
+{
+	/* Zero out the memory to help with debug */
+	memset(drvdata->buf, 0, drvdata->size);
+
+	CS_UNLOCK(drvdata->base);
+
+	writel_relaxed(TMC_MODE_CIRCULAR_BUFFER, drvdata->base + TMC_MODE);
+	writel_relaxed(TMC_FFCR_EN_FMT | TMC_FFCR_EN_TI |
+		       TMC_FFCR_FON_FLIN | TMC_FFCR_FON_TRIG_EVT |
+		       TMC_FFCR_TRIGON_TRIGIN,
+		       drvdata->base + TMC_FFCR);
+
+	writel_relaxed(drvdata->trigger_cntr, drvdata->base + TMC_TRG);
+	tmc_enable_hw(drvdata);
+
+	CS_LOCK(drvdata->base);
+}
+
+static void tmc_etr_enable_hw(struct tmc_drvdata *drvdata)
+{
+	u32 axictl;
+
+	/* Zero out the memory to help with debug */
+	memset(drvdata->vaddr, 0, drvdata->size);
+
+	CS_UNLOCK(drvdata->base);
+
+	writel_relaxed(drvdata->size / 4, drvdata->base + TMC_RSZ);
+	writel_relaxed(TMC_MODE_CIRCULAR_BUFFER, drvdata->base + TMC_MODE);
+
+	axictl = readl_relaxed(drvdata->base + TMC_AXICTL);
+	axictl |= TMC_AXICTL_WR_BURST_LEN;
+	writel_relaxed(axictl, drvdata->base + TMC_AXICTL);
+	axictl &= ~TMC_AXICTL_SCT_GAT_MODE;
+	writel_relaxed(axictl, drvdata->base + TMC_AXICTL);
+	axictl = (axictl &
+		  ~(TMC_AXICTL_PROT_CTL_B0 | TMC_AXICTL_PROT_CTL_B1)) |
+		  TMC_AXICTL_PROT_CTL_B1;
+	writel_relaxed(axictl, drvdata->base + TMC_AXICTL);
+
+	writel_relaxed(drvdata->paddr, drvdata->base + TMC_DBALO);
+	writel_relaxed(0x0, drvdata->base + TMC_DBAHI);
+	writel_relaxed(TMC_FFCR_EN_FMT | TMC_FFCR_EN_TI |
+		       TMC_FFCR_FON_FLIN | TMC_FFCR_FON_TRIG_EVT |
+		       TMC_FFCR_TRIGON_TRIGIN,
+		       drvdata->base + TMC_FFCR);
+	writel_relaxed(drvdata->trigger_cntr, drvdata->base + TMC_TRG);
+	tmc_enable_hw(drvdata);
+
+	CS_LOCK(drvdata->base);
+}
+
+static void tmc_etf_enable_hw(struct tmc_drvdata *drvdata)
+{
+	CS_UNLOCK(drvdata->base);
+
+	writel_relaxed(TMC_MODE_HARDWARE_FIFO, drvdata->base + TMC_MODE);
+	writel_relaxed(TMC_FFCR_EN_FMT | TMC_FFCR_EN_TI,
+		       drvdata->base + TMC_FFCR);
+	writel_relaxed(0x0, drvdata->base + TMC_BUFWM);
+	tmc_enable_hw(drvdata);
+
+	CS_LOCK(drvdata->base);
+}
+
+static int tmc_enable(struct tmc_drvdata *drvdata, enum tmc_mode mode)
+{
+	int ret;
+	unsigned long flags;
+
+	ret = clk_prepare_enable(drvdata->clk);
+	if (ret)
+		return ret;
+
+	spin_lock_irqsave(&drvdata->spinlock, flags);
+	if (drvdata->reading) {
+		spin_unlock_irqrestore(&drvdata->spinlock, flags);
+		clk_disable_unprepare(drvdata->clk);
+		return -EBUSY;
+	}
+
+	if (drvdata->config_type == TMC_CONFIG_TYPE_ETB) {
+		tmc_etb_enable_hw(drvdata);
+	} else if (drvdata->config_type == TMC_CONFIG_TYPE_ETR) {
+		tmc_etr_enable_hw(drvdata);
+	} else {
+		if (mode == TMC_MODE_CIRCULAR_BUFFER)
+			tmc_etb_enable_hw(drvdata);
+		else
+			tmc_etf_enable_hw(drvdata);
+	}
+	drvdata->enable = true;
+	spin_unlock_irqrestore(&drvdata->spinlock, flags);
+
+	dev_info(drvdata->dev, "TMC enabled\n");
+	return 0;
+}
+
+static int tmc_enable_sink(struct coresight_device *csdev)
+{
+	struct tmc_drvdata *drvdata = dev_get_drvdata(csdev->dev.parent);
+
+	return tmc_enable(drvdata, TMC_MODE_CIRCULAR_BUFFER);
+}
+
+static int tmc_enable_link(struct coresight_device *csdev, int inport,
+			   int outport)
+{
+	struct tmc_drvdata *drvdata = dev_get_drvdata(csdev->dev.parent);
+
+	return tmc_enable(drvdata, TMC_MODE_HARDWARE_FIFO);
+}
+
+static void tmc_etb_dump_hw(struct tmc_drvdata *drvdata)
+{
+	enum tmc_mem_intf_width memwidth;
+	u8 memwords;
+	char *bufp;
+	u32 read_data;
+	int i;
+
+	memwidth = BMVAL(readl_relaxed(drvdata->base + CORESIGHT_DEVID), 8, 10);
+	if (memwidth == TMC_MEM_INTF_WIDTH_32BITS)
+		memwords = 1;
+	else if (memwidth == TMC_MEM_INTF_WIDTH_64BITS)
+		memwords = 2;
+	else if (memwidth == TMC_MEM_INTF_WIDTH_128BITS)
+		memwords = 4;
+	else
+		memwords = 8;
+
+	bufp = drvdata->buf;
+	while (1) {
+		for (i = 0; i < memwords; i++) {
+			read_data = readl_relaxed(drvdata->base + TMC_RRD);
+			if (read_data == 0xFFFFFFFF)
+				return;
+			memcpy(bufp, &read_data, 4);
+			bufp += 4;
+		}
+	}
+}
+
+static void tmc_etb_disable_hw(struct tmc_drvdata *drvdata)
+{
+	CS_UNLOCK(drvdata->base);
+
+	tmc_flush_and_stop(drvdata);
+	tmc_etb_dump_hw(drvdata);
+	tmc_disable_hw(drvdata);
+
+	CS_LOCK(drvdata->base);
+}
+
+static void tmc_etr_dump_hw(struct tmc_drvdata *drvdata)
+{
+	u32 rwp, val;
+
+	rwp = readl_relaxed(drvdata->base + TMC_RWP);
+	val = readl_relaxed(drvdata->base + TMC_STS);
+
+	/* How much memory do we still have */
+	if (val & BIT(0))
+		drvdata->buf = drvdata->vaddr + rwp - drvdata->paddr;
+	else
+		drvdata->buf = drvdata->vaddr;
+}
+
+static void tmc_etr_disable_hw(struct tmc_drvdata *drvdata)
+{
+	CS_UNLOCK(drvdata->base);
+
+	tmc_flush_and_stop(drvdata);
+	tmc_etr_dump_hw(drvdata);
+	tmc_disable_hw(drvdata);
+
+	CS_LOCK(drvdata->base);
+}
+
+static void tmc_etf_disable_hw(struct tmc_drvdata *drvdata)
+{
+	CS_UNLOCK(drvdata->base);
+
+	tmc_flush_and_stop(drvdata);
+	tmc_disable_hw(drvdata);
+
+	CS_LOCK(drvdata->base);
+}
+
+static void tmc_disable(struct tmc_drvdata *drvdata, enum tmc_mode mode)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&drvdata->spinlock, flags);
+	if (drvdata->reading)
+		goto out;
+
+	if (drvdata->config_type == TMC_CONFIG_TYPE_ETB) {
+		tmc_etb_disable_hw(drvdata);
+	} else if (drvdata->config_type == TMC_CONFIG_TYPE_ETR) {
+		tmc_etr_disable_hw(drvdata);
+	} else {
+		if (mode == TMC_MODE_CIRCULAR_BUFFER)
+			tmc_etb_disable_hw(drvdata);
+		else
+			tmc_etf_disable_hw(drvdata);
+	}
+out:
+	drvdata->enable = false;
+	spin_unlock_irqrestore(&drvdata->spinlock, flags);
+
+	clk_disable_unprepare(drvdata->clk);
+
+	dev_info(drvdata->dev, "TMC disabled\n");
+}
+
+static void tmc_disable_sink(struct coresight_device *csdev)
+{
+	struct tmc_drvdata *drvdata = dev_get_drvdata(csdev->dev.parent);
+
+	tmc_disable(drvdata, TMC_MODE_CIRCULAR_BUFFER);
+}
+
+static void tmc_disable_link(struct coresight_device *csdev, int inport,
+			     int outport)
+{
+	struct tmc_drvdata *drvdata = dev_get_drvdata(csdev->dev.parent);
+
+	tmc_disable(drvdata, TMC_MODE_HARDWARE_FIFO);
+}
+
+static const struct coresight_ops_sink tmc_sink_ops = {
+	.enable		= tmc_enable_sink,
+	.disable	= tmc_disable_sink,
+};
+
+static const struct coresight_ops_link tmc_link_ops = {
+	.enable		= tmc_enable_link,
+	.disable	= tmc_disable_link,
+};
+
+static const struct coresight_ops tmc_etb_cs_ops = {
+	.sink_ops	= &tmc_sink_ops,
+};
+
+static const struct coresight_ops tmc_etr_cs_ops = {
+	.sink_ops	= &tmc_sink_ops,
+};
+
+static const struct coresight_ops tmc_etf_cs_ops = {
+	.sink_ops	= &tmc_sink_ops,
+	.link_ops	= &tmc_link_ops,
+};
+
+static int tmc_read_prepare(struct tmc_drvdata *drvdata)
+{
+	int ret;
+	unsigned long flags;
+	enum tmc_mode mode;
+
+	spin_lock_irqsave(&drvdata->spinlock, flags);
+	if (!drvdata->enable)
+		goto out;
+
+	if (drvdata->config_type == TMC_CONFIG_TYPE_ETB) {
+		tmc_etb_disable_hw(drvdata);
+	} else if (drvdata->config_type == TMC_CONFIG_TYPE_ETR) {
+		tmc_etr_disable_hw(drvdata);
+	} else {
+		mode = readl_relaxed(drvdata->base + TMC_MODE);
+		if (mode == TMC_MODE_CIRCULAR_BUFFER) {
+			tmc_etb_disable_hw(drvdata);
+		} else {
+			ret = -ENODEV;
+			goto err;
+		}
+	}
+out:
+	drvdata->reading = true;
+	spin_unlock_irqrestore(&drvdata->spinlock, flags);
+
+	dev_info(drvdata->dev, "TMC read start\n");
+	return 0;
+err:
+	spin_unlock_irqrestore(&drvdata->spinlock, flags);
+	return ret;
+}
+
+static void tmc_read_unprepare(struct tmc_drvdata *drvdata)
+{
+	unsigned long flags;
+	enum tmc_mode mode;
+
+	spin_lock_irqsave(&drvdata->spinlock, flags);
+	if (!drvdata->enable)
+		goto out;
+
+	if (drvdata->config_type == TMC_CONFIG_TYPE_ETB) {
+		tmc_etb_enable_hw(drvdata);
+	} else if (drvdata->config_type == TMC_CONFIG_TYPE_ETR) {
+		tmc_etr_enable_hw(drvdata);
+	} else {
+		mode = readl_relaxed(drvdata->base + TMC_MODE);
+		if (mode == TMC_MODE_CIRCULAR_BUFFER)
+			tmc_etb_enable_hw(drvdata);
+	}
+out:
+	drvdata->reading = false;
+	spin_unlock_irqrestore(&drvdata->spinlock, flags);
+
+	dev_info(drvdata->dev, "TMC read end\n");
+}
+
+static int tmc_open(struct inode *inode, struct file *file)
+{
+	struct tmc_drvdata *drvdata = container_of(file->private_data,
+						   struct tmc_drvdata, miscdev);
+	int ret = 0;
+
+	if (drvdata->read_count++)
+		goto out;
+
+	ret = tmc_read_prepare(drvdata);
+	if (ret)
+		return ret;
+out:
+	nonseekable_open(inode, file);
+
+	dev_dbg(drvdata->dev, "%s: successfully opened\n", __func__);
+	return 0;
+}
+
+static ssize_t tmc_read(struct file *file, char __user *data, size_t len,
+			loff_t *ppos)
+{
+	struct tmc_drvdata *drvdata = container_of(file->private_data,
+						   struct tmc_drvdata, miscdev);
+	char *bufp = drvdata->buf + *ppos;
+
+	if (*ppos + len > drvdata->size)
+		len = drvdata->size - *ppos;
+
+	if (drvdata->config_type == TMC_CONFIG_TYPE_ETR) {
+		if (bufp == (char *)(drvdata->vaddr + drvdata->size))
+			bufp = drvdata->vaddr;
+		else if (bufp > (char *)(drvdata->vaddr + drvdata->size))
+			bufp -= drvdata->size;
+		if ((bufp + len) > (char *)(drvdata->vaddr + drvdata->size))
+			len = (char *)(drvdata->vaddr + drvdata->size) - bufp;
+	}
+
+	if (copy_to_user(data, bufp, len)) {
+		dev_dbg(drvdata->dev, "%s: copy_to_user failed\n", __func__);
+		return -EFAULT;
+	}
+
+	*ppos += len;
+
+	dev_dbg(drvdata->dev, "%s: %zu bytes copied, %d bytes left\n",
+		__func__, len, (int)(drvdata->size - *ppos));
+	return len;
+}
+
+static int tmc_release(struct inode *inode, struct file *file)
+{
+	struct tmc_drvdata *drvdata = container_of(file->private_data,
+						   struct tmc_drvdata, miscdev);
+
+	if (--drvdata->read_count) {
+		if (drvdata->read_count < 0) {
+			dev_err(drvdata->dev, "mismatched close\n");
+			drvdata->read_count = 0;
+		}
+		goto out;
+	}
+
+	tmc_read_unprepare(drvdata);
+out:
+	dev_dbg(drvdata->dev, "%s: released\n", __func__);
+	return 0;
+}
+
+static const struct file_operations tmc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= tmc_open,
+	.read		= tmc_read,
+	.release	= tmc_release,
+	.llseek		= no_llseek,
+};
+
+static ssize_t status_show(struct device *dev,
+			   struct device_attribute *attr, char *buf)
+{
+	int ret;
+	unsigned long flags;
+	u32 tmc_rsz, tmc_sts, tmc_rrp, tmc_rwp, tmc_trg;
+	u32 tmc_ctl, tmc_ffsr, tmc_ffcr, tmc_mode, tmc_pscr;
+	u32 devid;
+	struct tmc_drvdata *drvdata = dev_get_drvdata(dev->parent);
+
+	ret = clk_prepare_enable(drvdata->clk);
+	if (ret)
+		goto out;
+
+	spin_lock_irqsave(&drvdata->spinlock, flags);
+	CS_UNLOCK(drvdata->base);
+
+	tmc_rsz = readl_relaxed(drvdata->base + TMC_RSZ);
+	tmc_sts = readl_relaxed(drvdata->base + TMC_STS);
+	tmc_rrp = readl_relaxed(drvdata->base + TMC_RRP);
+	tmc_rwp = readl_relaxed(drvdata->base + TMC_RWP);
+	tmc_trg = readl_relaxed(drvdata->base + TMC_TRG);
+	tmc_ctl = readl_relaxed(drvdata->base + TMC_CTL);
+	tmc_ffsr = readl_relaxed(drvdata->base + TMC_FFSR);
+	tmc_ffcr = readl_relaxed(drvdata->base + TMC_FFCR);
+	tmc_mode = readl_relaxed(drvdata->base + TMC_MODE);
+	tmc_pscr = readl_relaxed(drvdata->base + TMC_PSCR);
+	devid = readl_relaxed(drvdata->base + CORESIGHT_DEVID);
+
+	CS_LOCK(drvdata->base);
+	spin_unlock_irqrestore(&drvdata->spinlock, flags);
+
+	clk_disable_unprepare(drvdata->clk);
+
+	return sprintf(buf,
+		       "Depth:\t\t0x%x\n"
+		       "Status:\t\t0x%x\n"
+		       "RAM read ptr:\t0x%x\n"
+		       "RAM wrt ptr:\t0x%x\n"
+		       "Trigger cnt:\t0x%x\n"
+		       "Control:\t0x%x\n"
+		       "Flush status:\t0x%x\n"
+		       "Flush ctrl:\t0x%x\n"
+		       "Mode:\t\t0x%x\n"
+		       "PSRC:\t\t0x%x\n"
+		       "DEVID:\t\t0x%x\n",
+			tmc_rsz, tmc_sts, tmc_rrp, tmc_rwp, tmc_trg,
+			tmc_ctl, tmc_ffsr, tmc_ffcr, tmc_mode, tmc_pscr, devid);
+out:
+	return -EINVAL;
+}
+static DEVICE_ATTR_RO(status);
+
+static ssize_t trigger_cntr_show(struct device *dev,
+			    struct device_attribute *attr, char *buf)
+{
+	struct tmc_drvdata *drvdata = dev_get_drvdata(dev->parent);
+	unsigned long val = drvdata->trigger_cntr;
+
+	return sprintf(buf, "%#lx\n", val);
+}
+
+static ssize_t trigger_cntr_store(struct device *dev,
+			     struct device_attribute *attr,
+			     const char *buf, size_t size)
+{
+	int ret;
+	unsigned long val;
+	struct tmc_drvdata *drvdata = dev_get_drvdata(dev->parent);
+
+	ret = kstrtoul(buf, 16, &val);
+	if (ret)
+		return ret;
+
+	drvdata->trigger_cntr = val;
+	return size;
+}
+static DEVICE_ATTR_RW(trigger_cntr);
+
+static struct attribute *coresight_etb_attrs[] = {
+	&dev_attr_trigger_cntr.attr,
+	&dev_attr_status.attr,
+	NULL,
+};
+ATTRIBUTE_GROUPS(coresight_etb);
+
+static struct attribute *coresight_etr_attrs[] = {
+	&dev_attr_trigger_cntr.attr,
+	&dev_attr_status.attr,
+	NULL,
+};
+ATTRIBUTE_GROUPS(coresight_etr);
+
+static struct attribute *coresight_etf_attrs[] = {
+	&dev_attr_trigger_cntr.attr,
+	&dev_attr_status.attr,
+	NULL,
+};
+ATTRIBUTE_GROUPS(coresight_etf);
+
+static int tmc_probe(struct amba_device *adev, const struct amba_id *id)
+{
+	int ret = 0;
+	u32 devid;
+	void __iomem *base;
+	struct device *dev = &adev->dev;
+	struct coresight_platform_data *pdata = NULL;
+	struct tmc_drvdata *drvdata;
+	struct resource *res = &adev->res;
+	struct coresight_desc *desc;
+	struct device_node *np = adev->dev.of_node;
+
+	if (np) {
+		pdata = of_get_coresight_platform_data(dev, np);
+		if (IS_ERR(pdata))
+			return PTR_ERR(pdata);
+		adev->dev.platform_data = pdata;
+	}
+
+	drvdata = devm_kzalloc(dev, sizeof(*drvdata), GFP_KERNEL);
+	if (!drvdata)
+		return -ENOMEM;
+
+	drvdata->dev = &adev->dev;
+	dev_set_drvdata(dev, drvdata);
+
+	/* Validity for the resource is already checked by the AMBA core */
+	base = devm_ioremap_resource(dev, res);
+	if (IS_ERR(base))
+		return PTR_ERR(base);
+
+	drvdata->base = base;
+
+	spin_lock_init(&drvdata->spinlock);
+
+	drvdata->clk = adev->pclk;
+	ret = clk_prepare_enable(drvdata->clk);
+	if (ret)
+		return ret;
+
+	devid = readl_relaxed(drvdata->base + CORESIGHT_DEVID);
+	drvdata->config_type = BMVAL(devid, 6, 7);
+
+	if (drvdata->config_type == TMC_CONFIG_TYPE_ETR) {
+		if (np)
+			ret = of_property_read_u32(np,
+						   "arm,buffer-size",
+						   &drvdata->size);
+		if (ret)
+			drvdata->size = SZ_1M;
+	} else {
+		drvdata->size = readl_relaxed(drvdata->base + TMC_RSZ) * 4;
+	}
+
+	clk_disable_unprepare(drvdata->clk);
+
+	if (drvdata->config_type == TMC_CONFIG_TYPE_ETR) {
+		drvdata->vaddr = dma_alloc_coherent(dev, drvdata->size,
+						&drvdata->paddr, GFP_KERNEL);
+		if (!drvdata->vaddr)
+			return -ENOMEM;
+
+		memset(drvdata->vaddr, 0, drvdata->size);
+		drvdata->buf = drvdata->vaddr;
+	} else {
+		drvdata->buf = devm_kzalloc(dev, drvdata->size, GFP_KERNEL);
+		if (!drvdata->buf)
+			return -ENOMEM;
+	}
+
+	desc = devm_kzalloc(dev, sizeof(*desc), GFP_KERNEL);
+	if (!desc) {
+		ret = -ENOMEM;
+		goto err_devm_kzalloc;
+	}
+
+	desc->pdata = pdata;
+	desc->dev = dev;
+	desc->subtype.sink_subtype = CORESIGHT_DEV_SUBTYPE_SINK_BUFFER;
+
+	if (drvdata->config_type == TMC_CONFIG_TYPE_ETB) {
+		desc->type = CORESIGHT_DEV_TYPE_SINK;
+		desc->ops = &tmc_etb_cs_ops;
+		desc->groups = coresight_etb_groups;
+	} else if (drvdata->config_type == TMC_CONFIG_TYPE_ETR) {
+		desc->type = CORESIGHT_DEV_TYPE_SINK;
+		desc->ops = &tmc_etr_cs_ops;
+		desc->groups = coresight_etr_groups;
+	} else {
+		desc->type = CORESIGHT_DEV_TYPE_LINKSINK;
+		desc->subtype.link_subtype = CORESIGHT_DEV_SUBTYPE_LINK_FIFO;
+		desc->ops = &tmc_etf_cs_ops;
+		desc->groups = coresight_etf_groups;
+	}
+
+	drvdata->csdev = coresight_register(desc);
+	if (IS_ERR(drvdata->csdev)) {
+		ret = PTR_ERR(drvdata->csdev);
+		goto err_devm_kzalloc;
+	}
+
+	drvdata->miscdev.name = pdata->name;
+	drvdata->miscdev.minor = MISC_DYNAMIC_MINOR;
+	drvdata->miscdev.fops = &tmc_fops;
+	ret = misc_register(&drvdata->miscdev);
+	if (ret)
+		goto err_misc_register;
+
+	dev_info(dev, "TMC initialized\n");
+	return 0;
+
+err_misc_register:
+	coresight_unregister(drvdata->csdev);
+err_devm_kzalloc:
+	if (drvdata->config_type == TMC_CONFIG_TYPE_ETR)
+		dma_free_coherent(dev, drvdata->size,
+				&drvdata->paddr, GFP_KERNEL);
+	return ret;
+}
+
+static int tmc_remove(struct amba_device *adev)
+{
+	struct tmc_drvdata *drvdata = amba_get_drvdata(adev);
+
+	misc_deregister(&drvdata->miscdev);
+	coresight_unregister(drvdata->csdev);
+	if (drvdata->config_type == TMC_CONFIG_TYPE_ETR)
+		dma_free_coherent(drvdata->dev, drvdata->size,
+				  &drvdata->paddr, GFP_KERNEL);
+
+	return 0;
+}
+
+static struct amba_id tmc_ids[] = {
+	{
+		.id     = 0x0003b961,
+		.mask   = 0x0003ffff,
+	},
+	{ 0, 0},
+};
+
+static struct amba_driver tmc_driver = {
+	.drv = {
+		.name   = "coresight-tmc",
+		.owner  = THIS_MODULE,
+	},
+	.probe		= tmc_probe,
+	.remove		= tmc_remove,
+	.id_table	= tmc_ids,
+};
+
+module_amba_driver(tmc_driver);
+
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("CoreSight Trace Memory Controller driver");
diff --git a/drivers/hwtracing/coresight/coresight-tpiu.c b/drivers/hwtracing/coresight/coresight-tpiu.c
new file mode 100644
index 000000000000..3b33af2416bb
--- /dev/null
+++ b/drivers/hwtracing/coresight/coresight-tpiu.c
@@ -0,0 +1,207 @@
+/* Copyright (c) 2011-2012, The Linux Foundation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/device.h>
+#include <linux/io.h>
+#include <linux/err.h>
+#include <linux/slab.h>
+#include <linux/clk.h>
+#include <linux/coresight.h>
+#include <linux/amba/bus.h>
+
+#include "coresight-priv.h"
+
+#define TPIU_SUPP_PORTSZ	0x000
+#define TPIU_CURR_PORTSZ	0x004
+#define TPIU_SUPP_TRIGMODES	0x100
+#define TPIU_TRIG_CNTRVAL	0x104
+#define TPIU_TRIG_MULT		0x108
+#define TPIU_SUPP_TESTPATM	0x200
+#define TPIU_CURR_TESTPATM	0x204
+#define TPIU_TEST_PATREPCNTR	0x208
+#define TPIU_FFSR		0x300
+#define TPIU_FFCR		0x304
+#define TPIU_FSYNC_CNTR		0x308
+#define TPIU_EXTCTL_INPORT	0x400
+#define TPIU_EXTCTL_OUTPORT	0x404
+#define TPIU_ITTRFLINACK	0xee4
+#define TPIU_ITTRFLIN		0xee8
+#define TPIU_ITATBDATA0		0xeec
+#define TPIU_ITATBCTR2		0xef0
+#define TPIU_ITATBCTR1		0xef4
+#define TPIU_ITATBCTR0		0xef8
+
+/** register definition **/
+/* FFCR - 0x304 */
+#define FFCR_FON_MAN		BIT(6)
+
+/**
+ * @base:	memory mapped base address for this component.
+ * @dev:	the device entity associated to this component.
+ * @csdev:	component vitals needed by the framework.
+ * @clk:	the clock this component is associated to.
+ */
+struct tpiu_drvdata {
+	void __iomem		*base;
+	struct device		*dev;
+	struct coresight_device	*csdev;
+	struct clk		*clk;
+};
+
+static void tpiu_enable_hw(struct tpiu_drvdata *drvdata)
+{
+	CS_UNLOCK(drvdata->base);
+
+	/* TODO: fill this up */
+
+	CS_LOCK(drvdata->base);
+}
+
+static int tpiu_enable(struct coresight_device *csdev)
+{
+	struct tpiu_drvdata *drvdata = dev_get_drvdata(csdev->dev.parent);
+	int ret;
+
+	ret = clk_prepare_enable(drvdata->clk);
+	if (ret)
+		return ret;
+
+	tpiu_enable_hw(drvdata);
+
+	dev_info(drvdata->dev, "TPIU enabled\n");
+	return 0;
+}
+
+static void tpiu_disable_hw(struct tpiu_drvdata *drvdata)
+{
+	CS_UNLOCK(drvdata->base);
+
+	/* Clear formatter controle reg. */
+	writel_relaxed(0x0, drvdata->base + TPIU_FFCR);
+	/* Generate manual flush */
+	writel_relaxed(FFCR_FON_MAN, drvdata->base + TPIU_FFCR);
+
+	CS_LOCK(drvdata->base);
+}
+
+static void tpiu_disable(struct coresight_device *csdev)
+{
+	struct tpiu_drvdata *drvdata = dev_get_drvdata(csdev->dev.parent);
+
+	tpiu_disable_hw(drvdata);
+
+	clk_disable_unprepare(drvdata->clk);
+
+	dev_info(drvdata->dev, "TPIU disabled\n");
+}
+
+static const struct coresight_ops_sink tpiu_sink_ops = {
+	.enable		= tpiu_enable,
+	.disable	= tpiu_disable,
+};
+
+static const struct coresight_ops tpiu_cs_ops = {
+	.sink_ops	= &tpiu_sink_ops,
+};
+
+static int tpiu_probe(struct amba_device *adev, const struct amba_id *id)
+{
+	int ret;
+	void __iomem *base;
+	struct device *dev = &adev->dev;
+	struct coresight_platform_data *pdata = NULL;
+	struct tpiu_drvdata *drvdata;
+	struct resource *res = &adev->res;
+	struct coresight_desc *desc;
+	struct device_node *np = adev->dev.of_node;
+
+	if (np) {
+		pdata = of_get_coresight_platform_data(dev, np);
+		if (IS_ERR(pdata))
+			return PTR_ERR(pdata);
+		adev->dev.platform_data = pdata;
+	}
+
+	drvdata = devm_kzalloc(dev, sizeof(*drvdata), GFP_KERNEL);
+	if (!drvdata)
+		return -ENOMEM;
+
+	drvdata->dev = &adev->dev;
+	dev_set_drvdata(dev, drvdata);
+
+	/* Validity for the resource is already checked by the AMBA core */
+	base = devm_ioremap_resource(dev, res);
+	if (IS_ERR(base))
+		return PTR_ERR(base);
+
+	drvdata->base = base;
+
+	drvdata->clk = adev->pclk;
+	ret = clk_prepare_enable(drvdata->clk);
+	if (ret)
+		return ret;
+
+	/* Disable tpiu to support older devices */
+	tpiu_disable_hw(drvdata);
+
+	clk_disable_unprepare(drvdata->clk);
+
+	desc = devm_kzalloc(dev, sizeof(*desc), GFP_KERNEL);
+	if (!desc)
+		return -ENOMEM;
+
+	desc->type = CORESIGHT_DEV_TYPE_SINK;
+	desc->subtype.sink_subtype = CORESIGHT_DEV_SUBTYPE_SINK_PORT;
+	desc->ops = &tpiu_cs_ops;
+	desc->pdata = pdata;
+	desc->dev = dev;
+	drvdata->csdev = coresight_register(desc);
+	if (IS_ERR(drvdata->csdev))
+		return PTR_ERR(drvdata->csdev);
+
+	dev_info(dev, "TPIU initialized\n");
+	return 0;
+}
+
+static int tpiu_remove(struct amba_device *adev)
+{
+	struct tpiu_drvdata *drvdata = amba_get_drvdata(adev);
+
+	coresight_unregister(drvdata->csdev);
+	return 0;
+}
+
+static struct amba_id tpiu_ids[] = {
+	{
+		.id	= 0x0003b912,
+		.mask	= 0x0003ffff,
+	},
+	{ 0, 0},
+};
+
+static struct amba_driver tpiu_driver = {
+	.drv = {
+		.name	= "coresight-tpiu",
+		.owner	= THIS_MODULE,
+	},
+	.probe		= tpiu_probe,
+	.remove		= tpiu_remove,
+	.id_table	= tpiu_ids,
+};
+
+module_amba_driver(tpiu_driver);
+
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("CoreSight Trace Port Interface Unit driver");
diff --git a/drivers/hwtracing/coresight/coresight.c b/drivers/hwtracing/coresight/coresight.c
new file mode 100644
index 000000000000..894531d315b8
--- /dev/null
+++ b/drivers/hwtracing/coresight/coresight.c
@@ -0,0 +1,720 @@
+/* Copyright (c) 2012, The Linux Foundation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/types.h>
+#include <linux/device.h>
+#include <linux/io.h>
+#include <linux/err.h>
+#include <linux/export.h>
+#include <linux/slab.h>
+#include <linux/mutex.h>
+#include <linux/clk.h>
+#include <linux/coresight.h>
+#include <linux/of_platform.h>
+#include <linux/delay.h>
+
+#include "coresight-priv.h"
+
+static DEFINE_MUTEX(coresight_mutex);
+
+static int coresight_id_match(struct device *dev, void *data)
+{
+	int trace_id, i_trace_id;
+	struct coresight_device *csdev, *i_csdev;
+
+	csdev = data;
+	i_csdev = to_coresight_device(dev);
+
+	/*
+	 * No need to care about oneself and components that are not
+	 * sources or not enabled
+	 */
+	if (i_csdev == csdev || !i_csdev->enable ||
+	    i_csdev->type != CORESIGHT_DEV_TYPE_SOURCE)
+		return 0;
+
+	/* Get the source ID for both compoment */
+	trace_id = source_ops(csdev)->trace_id(csdev);
+	i_trace_id = source_ops(i_csdev)->trace_id(i_csdev);
+
+	/* All you need is one */
+	if (trace_id == i_trace_id)
+		return 1;
+
+	return 0;
+}
+
+static int coresight_source_is_unique(struct coresight_device *csdev)
+{
+	int trace_id = source_ops(csdev)->trace_id(csdev);
+
+	/* this shouldn't happen */
+	if (trace_id < 0)
+		return 0;
+
+	return !bus_for_each_dev(&coresight_bustype, NULL,
+				 csdev, coresight_id_match);
+}
+
+static int coresight_find_link_inport(struct coresight_device *csdev)
+{
+	int i;
+	struct coresight_device *parent;
+	struct coresight_connection *conn;
+
+	parent = container_of(csdev->path_link.next,
+			      struct coresight_device, path_link);
+
+	for (i = 0; i < parent->nr_outport; i++) {
+		conn = &parent->conns[i];
+		if (conn->child_dev == csdev)
+			return conn->child_port;
+	}
+
+	dev_err(&csdev->dev, "couldn't find inport, parent: %s, child: %s\n",
+		dev_name(&parent->dev), dev_name(&csdev->dev));
+
+	return 0;
+}
+
+static int coresight_find_link_outport(struct coresight_device *csdev)
+{
+	int i;
+	struct coresight_device *child;
+	struct coresight_connection *conn;
+
+	child = container_of(csdev->path_link.prev,
+			     struct coresight_device, path_link);
+
+	for (i = 0; i < csdev->nr_outport; i++) {
+		conn = &csdev->conns[i];
+		if (conn->child_dev == child)
+			return conn->outport;
+	}
+
+	dev_err(&csdev->dev, "couldn't find outport, parent: %s, child: %s\n",
+		dev_name(&csdev->dev), dev_name(&child->dev));
+
+	return 0;
+}
+
+static int coresight_enable_sink(struct coresight_device *csdev)
+{
+	int ret;
+
+	if (!csdev->enable) {
+		if (sink_ops(csdev)->enable) {
+			ret = sink_ops(csdev)->enable(csdev);
+			if (ret)
+				return ret;
+		}
+		csdev->enable = true;
+	}
+
+	atomic_inc(csdev->refcnt);
+
+	return 0;
+}
+
+static void coresight_disable_sink(struct coresight_device *csdev)
+{
+	if (atomic_dec_return(csdev->refcnt) == 0) {
+		if (sink_ops(csdev)->disable) {
+			sink_ops(csdev)->disable(csdev);
+			csdev->enable = false;
+		}
+	}
+}
+
+static int coresight_enable_link(struct coresight_device *csdev)
+{
+	int ret;
+	int link_subtype;
+	int refport, inport, outport;
+
+	inport = coresight_find_link_inport(csdev);
+	outport = coresight_find_link_outport(csdev);
+	link_subtype = csdev->subtype.link_subtype;
+
+	if (link_subtype == CORESIGHT_DEV_SUBTYPE_LINK_MERG)
+		refport = inport;
+	else if (link_subtype == CORESIGHT_DEV_SUBTYPE_LINK_SPLIT)
+		refport = outport;
+	else
+		refport = 0;
+
+	if (atomic_inc_return(&csdev->refcnt[refport]) == 1) {
+		if (link_ops(csdev)->enable) {
+			ret = link_ops(csdev)->enable(csdev, inport, outport);
+			if (ret)
+				return ret;
+		}
+	}
+
+	csdev->enable = true;
+
+	return 0;
+}
+
+static void coresight_disable_link(struct coresight_device *csdev)
+{
+	int i, nr_conns;
+	int link_subtype;
+	int refport, inport, outport;
+
+	inport = coresight_find_link_inport(csdev);
+	outport = coresight_find_link_outport(csdev);
+	link_subtype = csdev->subtype.link_subtype;
+
+	if (link_subtype == CORESIGHT_DEV_SUBTYPE_LINK_MERG) {
+		refport = inport;
+		nr_conns = csdev->nr_inport;
+	} else if (link_subtype == CORESIGHT_DEV_SUBTYPE_LINK_SPLIT) {
+		refport = outport;
+		nr_conns = csdev->nr_outport;
+	} else {
+		refport = 0;
+		nr_conns = 1;
+	}
+
+	if (atomic_dec_return(&csdev->refcnt[refport]) == 0) {
+		if (link_ops(csdev)->disable)
+			link_ops(csdev)->disable(csdev, inport, outport);
+	}
+
+	for (i = 0; i < nr_conns; i++)
+		if (atomic_read(&csdev->refcnt[i]) != 0)
+			return;
+
+	csdev->enable = false;
+}
+
+static int coresight_enable_source(struct coresight_device *csdev)
+{
+	int ret;
+
+	if (!coresight_source_is_unique(csdev)) {
+		dev_warn(&csdev->dev, "traceID %d not unique\n",
+			 source_ops(csdev)->trace_id(csdev));
+		return -EINVAL;
+	}
+
+	if (!csdev->enable) {
+		if (source_ops(csdev)->enable) {
+			ret = source_ops(csdev)->enable(csdev);
+			if (ret)
+				return ret;
+		}
+		csdev->enable = true;
+	}
+
+	atomic_inc(csdev->refcnt);
+
+	return 0;
+}
+
+static void coresight_disable_source(struct coresight_device *csdev)
+{
+	if (atomic_dec_return(csdev->refcnt) == 0) {
+		if (source_ops(csdev)->disable) {
+			source_ops(csdev)->disable(csdev);
+			csdev->enable = false;
+		}
+	}
+}
+
+static int coresight_enable_path(struct list_head *path)
+{
+	int ret = 0;
+	struct coresight_device *cd;
+
+	list_for_each_entry(cd, path, path_link) {
+		if (cd == list_first_entry(path, struct coresight_device,
+					   path_link)) {
+			ret = coresight_enable_sink(cd);
+		} else if (list_is_last(&cd->path_link, path)) {
+			/*
+			 * Don't enable the source just yet - this needs to
+			 * happen at the very end when all links and sink
+			 * along the path have been configured properly.
+			 */
+			;
+		} else {
+			ret = coresight_enable_link(cd);
+		}
+		if (ret)
+			goto err;
+	}
+
+	return 0;
+err:
+	list_for_each_entry_continue_reverse(cd, path, path_link) {
+		if (cd == list_first_entry(path, struct coresight_device,
+					   path_link)) {
+			coresight_disable_sink(cd);
+		} else if (list_is_last(&cd->path_link, path)) {
+			;
+		} else {
+			coresight_disable_link(cd);
+		}
+	}
+
+	return ret;
+}
+
+static int coresight_disable_path(struct list_head *path)
+{
+	struct coresight_device *cd;
+
+	list_for_each_entry_reverse(cd, path, path_link) {
+		if (cd == list_first_entry(path, struct coresight_device,
+					   path_link)) {
+			coresight_disable_sink(cd);
+		} else if (list_is_last(&cd->path_link, path)) {
+			/*
+			 * The source has already been stopped, no need
+			 * to do it again here.
+			 */
+			;
+		} else {
+			coresight_disable_link(cd);
+		}
+	}
+
+	return 0;
+}
+
+static int coresight_build_paths(struct coresight_device *csdev,
+				 struct list_head *path,
+				 bool enable)
+{
+	int i, ret = -EINVAL;
+	struct coresight_connection *conn;
+
+	list_add(&csdev->path_link, path);
+
+	if ((csdev->type == CORESIGHT_DEV_TYPE_SINK ||
+	    csdev->type == CORESIGHT_DEV_TYPE_LINKSINK) &&
+	    csdev->activated) {
+		if (enable)
+			ret = coresight_enable_path(path);
+		else
+			ret = coresight_disable_path(path);
+	} else {
+		for (i = 0; i < csdev->nr_outport; i++) {
+			conn = &csdev->conns[i];
+			if (coresight_build_paths(conn->child_dev,
+						    path, enable) == 0)
+				ret = 0;
+		}
+	}
+
+	if (list_first_entry(path, struct coresight_device, path_link) != csdev)
+		dev_err(&csdev->dev, "wrong device in %s\n", __func__);
+
+	list_del(&csdev->path_link);
+
+	return ret;
+}
+
+int coresight_enable(struct coresight_device *csdev)
+{
+	int ret = 0;
+	LIST_HEAD(path);
+
+	mutex_lock(&coresight_mutex);
+	if (csdev->type != CORESIGHT_DEV_TYPE_SOURCE) {
+		ret = -EINVAL;
+		dev_err(&csdev->dev, "wrong device type in %s\n", __func__);
+		goto out;
+	}
+	if (csdev->enable)
+		goto out;
+
+	if (coresight_build_paths(csdev, &path, true)) {
+		dev_err(&csdev->dev, "building path(s) failed\n");
+		goto out;
+	}
+
+	if (coresight_enable_source(csdev))
+		dev_err(&csdev->dev, "source enable failed\n");
+out:
+	mutex_unlock(&coresight_mutex);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(coresight_enable);
+
+void coresight_disable(struct coresight_device *csdev)
+{
+	LIST_HEAD(path);
+
+	mutex_lock(&coresight_mutex);
+	if (csdev->type != CORESIGHT_DEV_TYPE_SOURCE) {
+		dev_err(&csdev->dev, "wrong device type in %s\n", __func__);
+		goto out;
+	}
+	if (!csdev->enable)
+		goto out;
+
+	coresight_disable_source(csdev);
+	if (coresight_build_paths(csdev, &path, false))
+		dev_err(&csdev->dev, "releasing path(s) failed\n");
+
+out:
+	mutex_unlock(&coresight_mutex);
+}
+EXPORT_SYMBOL_GPL(coresight_disable);
+
+static ssize_t enable_sink_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct coresight_device *csdev = to_coresight_device(dev);
+
+	return scnprintf(buf, PAGE_SIZE, "%u\n", (unsigned)csdev->activated);
+}
+
+static ssize_t enable_sink_store(struct device *dev,
+				 struct device_attribute *attr,
+				 const char *buf, size_t size)
+{
+	int ret;
+	unsigned long val;
+	struct coresight_device *csdev = to_coresight_device(dev);
+
+	ret = kstrtoul(buf, 10, &val);
+	if (ret)
+		return ret;
+
+	if (val)
+		csdev->activated = true;
+	else
+		csdev->activated = false;
+
+	return size;
+
+}
+static DEVICE_ATTR_RW(enable_sink);
+
+static ssize_t enable_source_show(struct device *dev,
+				  struct device_attribute *attr, char *buf)
+{
+	struct coresight_device *csdev = to_coresight_device(dev);
+
+	return scnprintf(buf, PAGE_SIZE, "%u\n", (unsigned)csdev->enable);
+}
+
+static ssize_t enable_source_store(struct device *dev,
+				   struct device_attribute *attr,
+				   const char *buf, size_t size)
+{
+	int ret = 0;
+	unsigned long val;
+	struct coresight_device *csdev = to_coresight_device(dev);
+
+	ret = kstrtoul(buf, 10, &val);
+	if (ret)
+		return ret;
+
+	if (val) {
+		ret = coresight_enable(csdev);
+		if (ret)
+			return ret;
+	} else {
+		coresight_disable(csdev);
+	}
+
+	return size;
+}
+static DEVICE_ATTR_RW(enable_source);
+
+static struct attribute *coresight_sink_attrs[] = {
+	&dev_attr_enable_sink.attr,
+	NULL,
+};
+ATTRIBUTE_GROUPS(coresight_sink);
+
+static struct attribute *coresight_source_attrs[] = {
+	&dev_attr_enable_source.attr,
+	NULL,
+};
+ATTRIBUTE_GROUPS(coresight_source);
+
+static struct device_type coresight_dev_type[] = {
+	{
+		.name = "none",
+	},
+	{
+		.name = "sink",
+		.groups = coresight_sink_groups,
+	},
+	{
+		.name = "link",
+	},
+	{
+		.name = "linksink",
+		.groups = coresight_sink_groups,
+	},
+	{
+		.name = "source",
+		.groups = coresight_source_groups,
+	},
+};
+
+static void coresight_device_release(struct device *dev)
+{
+	struct coresight_device *csdev = to_coresight_device(dev);
+
+	kfree(csdev);
+}
+
+static int coresight_orphan_match(struct device *dev, void *data)
+{
+	int i;
+	bool still_orphan = false;
+	struct coresight_device *csdev, *i_csdev;
+	struct coresight_connection *conn;
+
+	csdev = data;
+	i_csdev = to_coresight_device(dev);
+
+	/* No need to check oneself */
+	if (csdev == i_csdev)
+		return 0;
+
+	/* Move on to another component if no connection is orphan */
+	if (!i_csdev->orphan)
+		return 0;
+	/*
+	 * Circle throuch all the connection of that component.  If we find
+	 * an orphan connection whose name matches @csdev, link it.
+	 */
+	for (i = 0; i < i_csdev->nr_outport; i++) {
+		conn = &i_csdev->conns[i];
+
+		/* We have found at least one orphan connection */
+		if (conn->child_dev == NULL) {
+			/* Does it match this newly added device? */
+			if (!strcmp(dev_name(&csdev->dev), conn->child_name)) {
+				conn->child_dev = csdev;
+			} else {
+				/* This component still has an orphan */
+				still_orphan = true;
+			}
+		}
+	}
+
+	i_csdev->orphan = still_orphan;
+
+	/*
+	 * Returning '0' ensures that all known component on the
+	 * bus will be checked.
+	 */
+	return 0;
+}
+
+static void coresight_fixup_orphan_conns(struct coresight_device *csdev)
+{
+	/*
+	 * No need to check for a return value as orphan connection(s)
+	 * are hooked-up with each newly added component.
+	 */
+	bus_for_each_dev(&coresight_bustype, NULL,
+				 csdev, coresight_orphan_match);
+}
+
+
+static int coresight_name_match(struct device *dev, void *data)
+{
+	char *to_match;
+	struct coresight_device *i_csdev;
+
+	to_match = data;
+	i_csdev = to_coresight_device(dev);
+
+	if (!strcmp(to_match, dev_name(&i_csdev->dev)))
+		return 1;
+
+	return 0;
+}
+
+static void coresight_fixup_device_conns(struct coresight_device *csdev)
+{
+	int i;
+	struct device *dev = NULL;
+	struct coresight_connection *conn;
+
+	for (i = 0; i < csdev->nr_outport; i++) {
+		conn = &csdev->conns[i];
+		dev = bus_find_device(&coresight_bustype, NULL,
+				      (void *)conn->child_name,
+				      coresight_name_match);
+
+		if (dev) {
+			conn->child_dev = to_coresight_device(dev);
+		} else {
+			csdev->orphan = true;
+			conn->child_dev = NULL;
+		}
+	}
+}
+
+/**
+ * coresight_timeout - loop until a bit has changed to a specific state.
+ * @addr: base address of the area of interest.
+ * @offset: address of a register, starting from @addr.
+ * @position: the position of the bit of interest.
+ * @value: the value the bit should have.
+ *
+ * Return: 0 as soon as the bit has taken the desired state or -EAGAIN if
+ * TIMEOUT_US has elapsed, which ever happens first.
+ */
+
+int coresight_timeout(void __iomem *addr, u32 offset, int position, int value)
+{
+	int i;
+	u32 val;
+
+	for (i = TIMEOUT_US; i > 0; i--) {
+		val = __raw_readl(addr + offset);
+		/* waiting on the bit to go from 0 to 1 */
+		if (value) {
+			if (val & BIT(position))
+				return 0;
+		/* waiting on the bit to go from 1 to 0 */
+		} else {
+			if (!(val & BIT(position)))
+				return 0;
+		}
+
+		/*
+		 * Delay is arbitrary - the specification doesn't say how long
+		 * we are expected to wait.  Extra check required to make sure
+		 * we don't wait needlessly on the last iteration.
+		 */
+		if (i - 1)
+			udelay(1);
+	}
+
+	return -EAGAIN;
+}
+
+struct bus_type coresight_bustype = {
+	.name	= "coresight",
+};
+
+static int __init coresight_init(void)
+{
+	return bus_register(&coresight_bustype);
+}
+postcore_initcall(coresight_init);
+
+struct coresight_device *coresight_register(struct coresight_desc *desc)
+{
+	int i;
+	int ret;
+	int link_subtype;
+	int nr_refcnts = 1;
+	atomic_t *refcnts = NULL;
+	struct coresight_device *csdev;
+	struct coresight_connection *conns;
+
+	csdev = kzalloc(sizeof(*csdev), GFP_KERNEL);
+	if (!csdev) {
+		ret = -ENOMEM;
+		goto err_kzalloc_csdev;
+	}
+
+	if (desc->type == CORESIGHT_DEV_TYPE_LINK ||
+	    desc->type == CORESIGHT_DEV_TYPE_LINKSINK) {
+		link_subtype = desc->subtype.link_subtype;
+
+		if (link_subtype == CORESIGHT_DEV_SUBTYPE_LINK_MERG)
+			nr_refcnts = desc->pdata->nr_inport;
+		else if (link_subtype == CORESIGHT_DEV_SUBTYPE_LINK_SPLIT)
+			nr_refcnts = desc->pdata->nr_outport;
+	}
+
+	refcnts = kcalloc(nr_refcnts, sizeof(*refcnts), GFP_KERNEL);
+	if (!refcnts) {
+		ret = -ENOMEM;
+		goto err_kzalloc_refcnts;
+	}
+
+	csdev->refcnt = refcnts;
+
+	csdev->nr_inport = desc->pdata->nr_inport;
+	csdev->nr_outport = desc->pdata->nr_outport;
+	conns = kcalloc(csdev->nr_outport, sizeof(*conns), GFP_KERNEL);
+	if (!conns) {
+		ret = -ENOMEM;
+		goto err_kzalloc_conns;
+	}
+
+	for (i = 0; i < csdev->nr_outport; i++) {
+		conns[i].outport = desc->pdata->outports[i];
+		conns[i].child_name = desc->pdata->child_names[i];
+		conns[i].child_port = desc->pdata->child_ports[i];
+	}
+
+	csdev->conns = conns;
+
+	csdev->type = desc->type;
+	csdev->subtype = desc->subtype;
+	csdev->ops = desc->ops;
+	csdev->orphan = false;
+
+	csdev->dev.type = &coresight_dev_type[desc->type];
+	csdev->dev.groups = desc->groups;
+	csdev->dev.parent = desc->dev;
+	csdev->dev.release = coresight_device_release;
+	csdev->dev.bus = &coresight_bustype;
+	dev_set_name(&csdev->dev, "%s", desc->pdata->name);
+
+	ret = device_register(&csdev->dev);
+	if (ret)
+		goto err_device_register;
+
+	mutex_lock(&coresight_mutex);
+
+	coresight_fixup_device_conns(csdev);
+	coresight_fixup_orphan_conns(csdev);
+
+	mutex_unlock(&coresight_mutex);
+
+	return csdev;
+
+err_device_register:
+	kfree(conns);
+err_kzalloc_conns:
+	kfree(refcnts);
+err_kzalloc_refcnts:
+	kfree(csdev);
+err_kzalloc_csdev:
+	return ERR_PTR(ret);
+}
+EXPORT_SYMBOL_GPL(coresight_register);
+
+void coresight_unregister(struct coresight_device *csdev)
+{
+	mutex_lock(&coresight_mutex);
+
+	kfree(csdev->conns);
+	device_unregister(&csdev->dev);
+
+	mutex_unlock(&coresight_mutex);
+}
+EXPORT_SYMBOL_GPL(coresight_unregister);
+
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/hwtracing/coresight/of_coresight.c b/drivers/hwtracing/coresight/of_coresight.c
new file mode 100644
index 000000000000..f3cc8e97a0f8
--- /dev/null
+++ b/drivers/hwtracing/coresight/of_coresight.c
@@ -0,0 +1,200 @@
+/* Copyright (c) 2012, The Linux Foundation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/err.h>
+#include <linux/slab.h>
+#include <linux/clk.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/of_graph.h>
+#include <linux/of_platform.h>
+#include <linux/platform_device.h>
+#include <linux/amba/bus.h>
+#include <linux/coresight.h>
+#include <linux/cpumask.h>
+#include <asm/smp_plat.h>
+
+
+static int of_dev_node_match(struct device *dev, void *data)
+{
+	return dev->of_node == data;
+}
+
+static struct device *
+of_coresight_get_endpoint_device(struct device_node *endpoint)
+{
+	struct device *dev = NULL;
+
+	/*
+	 * If we have a non-configuable replicator, it will be found on the
+	 * platform bus.
+	 */
+	dev = bus_find_device(&platform_bus_type, NULL,
+			      endpoint, of_dev_node_match);
+	if (dev)
+		return dev;
+
+	/*
+	 * We have a configurable component - circle through the AMBA bus
+	 * looking for the device that matches the endpoint node.
+	 */
+	return bus_find_device(&amba_bustype, NULL,
+			       endpoint, of_dev_node_match);
+}
+
+static struct device_node *of_get_coresight_endpoint(
+		const struct device_node *parent, struct device_node *prev)
+{
+	struct device_node *node = of_graph_get_next_endpoint(parent, prev);
+
+	of_node_put(prev);
+	return node;
+}
+
+static void of_coresight_get_ports(struct device_node *node,
+				   int *nr_inport, int *nr_outport)
+{
+	struct device_node *ep = NULL;
+	int in = 0, out = 0;
+
+	do {
+		ep = of_get_coresight_endpoint(node, ep);
+		if (!ep)
+			break;
+
+		if (of_property_read_bool(ep, "slave-mode"))
+			in++;
+		else
+			out++;
+
+	} while (ep);
+
+	*nr_inport = in;
+	*nr_outport = out;
+}
+
+static int of_coresight_alloc_memory(struct device *dev,
+			struct coresight_platform_data *pdata)
+{
+	/* List of output port on this component */
+	pdata->outports = devm_kzalloc(dev, pdata->nr_outport *
+				       sizeof(*pdata->outports),
+				       GFP_KERNEL);
+	if (!pdata->outports)
+		return -ENOMEM;
+
+	/* Children connected to this component via @outports */
+	 pdata->child_names = devm_kzalloc(dev, pdata->nr_outport *
+					  sizeof(*pdata->child_names),
+					  GFP_KERNEL);
+	if (!pdata->child_names)
+		return -ENOMEM;
+
+	/* Port number on the child this component is connected to */
+	pdata->child_ports = devm_kzalloc(dev, pdata->nr_outport *
+					  sizeof(*pdata->child_ports),
+					  GFP_KERNEL);
+	if (!pdata->child_ports)
+		return -ENOMEM;
+
+	return 0;
+}
+
+struct coresight_platform_data *of_get_coresight_platform_data(
+				struct device *dev, struct device_node *node)
+{
+	int i = 0, ret = 0, cpu;
+	struct coresight_platform_data *pdata;
+	struct of_endpoint endpoint, rendpoint;
+	struct device *rdev;
+	struct device_node *dn;
+	struct device_node *ep = NULL;
+	struct device_node *rparent = NULL;
+	struct device_node *rport = NULL;
+
+	pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
+	if (!pdata)
+		return ERR_PTR(-ENOMEM);
+
+	/* Use device name as sysfs handle */
+	pdata->name = dev_name(dev);
+
+	/* Get the number of input and output port for this component */
+	of_coresight_get_ports(node, &pdata->nr_inport, &pdata->nr_outport);
+
+	if (pdata->nr_outport) {
+		ret = of_coresight_alloc_memory(dev, pdata);
+		if (ret)
+			return ERR_PTR(ret);
+
+		/* Iterate through each port to discover topology */
+		do {
+			/* Get a handle on a port */
+			ep = of_get_coresight_endpoint(node, ep);
+			if (!ep)
+				break;
+
+			/*
+			 * No need to deal with input ports, processing for as
+			 * processing for output ports will deal with them.
+			 */
+			if (of_find_property(ep, "slave-mode", NULL))
+				continue;
+
+			/* Get a handle on the local endpoint */
+			ret = of_graph_parse_endpoint(ep, &endpoint);
+
+			if (ret)
+				continue;
+
+			/* The local out port number */
+			pdata->outports[i] = endpoint.id;
+
+			/*
+			 * Get a handle on the remote port and parent
+			 * attached to it.
+			 */
+			rparent = of_graph_get_remote_port_parent(ep);
+			rport = of_graph_get_remote_port(ep);
+
+			if (!rparent || !rport)
+				continue;
+
+			if (of_graph_parse_endpoint(rport, &rendpoint))
+				continue;
+
+			rdev = of_coresight_get_endpoint_device(rparent);
+			if (!rdev)
+				continue;
+
+			pdata->child_names[i] = dev_name(rdev);
+			pdata->child_ports[i] = rendpoint.id;
+
+			i++;
+		} while (ep);
+	}
+
+	/* Affinity defaults to CPU0 */
+	pdata->cpu = 0;
+	dn = of_parse_phandle(node, "cpu", 0);
+	for (cpu = 0; dn && cpu < nr_cpu_ids; cpu++) {
+		if (dn == of_get_cpu_node(cpu, NULL)) {
+			pdata->cpu = cpu;
+			break;
+		}
+	}
+
+	return pdata;
+}
+EXPORT_SYMBOL_GPL(of_get_coresight_platform_data);
-- 
1.9.1
