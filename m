From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v3 01/11] coresight-etm4x: Adding CoreSight ETM4x driver
Date: Sun, 10 May 2015 15:37:10 +0200
Message-ID: <20150510133710.GA6237@kroah.com>
References: <1430926047-9125-1-git-send-email-mathieu.poirier@linaro.org>
 <1430926047-9125-2-git-send-email-mathieu.poirier@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1430926047-9125-2-git-send-email-mathieu.poirier@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, kaixu.xia@linaro.org, zhang.chunyan@linaro.org
List-Id: linux-api@vger.kernel.org

On Wed, May 06, 2015 at 09:27:17AM -0600, Mathieu Poirier wrote:
> From: Pratik Patel <pratikp@codeaurora.org>
> 
> This driver manages the CoreSight ETMv4 (Embedded Trace Macrocell) IP block
> to support HW assisted tracing on ARMv7 and ARMv8 architectures.
> 
> Signed-off-by: Pratik Patel <pratikp@codeaurora.org>
> Signed-off-by: Kaixu Xia <xiakaixu@huawei.com>
> Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
> ---
>  .../ABI/testing/sysfs-bus-coresight-devices-etm4x  |  28 +
>  drivers/hwtracing/coresight/Kconfig                |  11 +
>  drivers/hwtracing/coresight/Makefile               |   1 +
>  drivers/hwtracing/coresight/coresight-etm4x.c      | 825 +++++++++++++++++++++
>  drivers/hwtracing/coresight/coresight-etm4x.h      | 391 ++++++++++
>  5 files changed, 1256 insertions(+)
>  create mode 100644 Documentation/ABI/testing/sysfs-bus-coresight-devices-etm4x
>  create mode 100644 drivers/hwtracing/coresight/coresight-etm4x.c
>  create mode 100644 drivers/hwtracing/coresight/coresight-etm4x.h
> 
> diff --git a/Documentation/ABI/testing/sysfs-bus-coresight-devices-etm4x b/Documentation/ABI/testing/sysfs-bus-coresight-devices-etm4x
> new file mode 100644
> index 000000000000..a4b623871ca0
> --- /dev/null
> +++ b/Documentation/ABI/testing/sysfs-bus-coresight-devices-etm4x
> @@ -0,0 +1,28 @@
> +What:		/sys/bus/coresight/devices/<memory_map>.etm/enable_source
> +Date:		April 2015
> +KernelVersion:  4.01
> +Contact:        Mathieu Poirier <mathieu.poirier@linaro.org>
> +Description:	(RW) Enable/disable tracing on this specific trace entiry.
> +		Enabling a source implies the source has been configured
> +		properly and a sink has been identidifed for it.  The path
> +		of coresight components linking the source to the sink is
> +		configured and managed automatically by the coresight framework.
> +
> +What:		/sys/bus/coresight/devices/<memory_map>.etm/status
> +Date:		April 2015
> +KernelVersion:	4.01
> +Contact:	Mathieu Poirier <mathieu.poirier@linaro.org>
> +Description:	(R) List various control and status registers.  The specific
> +		layout and content is driver specific.
> +
> +What:		/sys/bus/coresight/devices/<memory_map>.etm/mgmt
> +Date:		April 2015
> +KernelVersion:	4.01
> +Contact:	Mathieu Poirier <mathieu.poirier@linaro.org>
> +Description:	(R) Provides the current value of all the management registers.
> +
> +What:		/sys/bus/coresight/devices/<memory_map>.etm/trcidr
> +Date:		April 2015
> +KernelVersion:	4.01
> +Contact:	Mathieu Poirier <mathieu.poirier@linaro.org>
> +Description:	(R) Provides value of all the ID registers (TRCIDRx).
> diff --git a/drivers/hwtracing/coresight/Kconfig b/drivers/hwtracing/coresight/Kconfig
> index fc1f1ae7a49d..8fac01eedee7 100644
> --- a/drivers/hwtracing/coresight/Kconfig
> +++ b/drivers/hwtracing/coresight/Kconfig
> @@ -58,4 +58,15 @@ config CORESIGHT_SOURCE_ETM3X
>  	  which allows tracing the instructions that a processor is executing
>  	  This is primarily useful for instruction level tracing.  Depending
>  	  the ETM version data tracing may also be available.
> +
> +config CORESIGHT_SOURCE_ETM4X
> +	bool "CoreSight Embedded Trace Macrocell 4.x driver"
> +	depends on ARM64
> +	select CORESIGHT_LINKS_AND_SINKS
> +	help
> +	  This driver provides support for the ETM4.x tracer module, tracing the
> +	  instructions that a processor is executing. This is primarily useful
> +	  for instruction level tracing. Depending on the implemented version
> +	  data tracing may also be available.
> +
>  endif
> diff --git a/drivers/hwtracing/coresight/Makefile b/drivers/hwtracing/coresight/Makefile
> index 4b4bec890ef5..0af28d43465c 100644
> --- a/drivers/hwtracing/coresight/Makefile
> +++ b/drivers/hwtracing/coresight/Makefile
> @@ -9,3 +9,4 @@ obj-$(CONFIG_CORESIGHT_SINK_ETBV10) += coresight-etb10.o
>  obj-$(CONFIG_CORESIGHT_LINKS_AND_SINKS) += coresight-funnel.o \
>  					   coresight-replicator.o
>  obj-$(CONFIG_CORESIGHT_SOURCE_ETM3X) += coresight-etm3x.o coresight-etm-cp14.o
> +obj-$(CONFIG_CORESIGHT_SOURCE_ETM4X) += coresight-etm4x.o
> diff --git a/drivers/hwtracing/coresight/coresight-etm4x.c b/drivers/hwtracing/coresight/coresight-etm4x.c
> new file mode 100644
> index 000000000000..db0bea4d4661
> --- /dev/null
> +++ b/drivers/hwtracing/coresight/coresight-etm4x.c
> @@ -0,0 +1,825 @@
> +/* Copyright (c) 2014, The Linux Foundation. All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 and
> + * only version 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/moduleparam.h>
> +#include <linux/init.h>
> +#include <linux/types.h>
> +#include <linux/device.h>
> +#include <linux/io.h>
> +#include <linux/err.h>
> +#include <linux/fs.h>
> +#include <linux/slab.h>
> +#include <linux/delay.h>
> +#include <linux/smp.h>
> +#include <linux/sysfs.h>
> +#include <linux/stat.h>
> +#include <linux/clk.h>
> +#include <linux/cpu.h>
> +#include <linux/coresight.h>
> +#include <linux/pm_wakeup.h>
> +#include <linux/amba/bus.h>
> +#include <linux/seq_file.h>
> +#include <linux/uaccess.h>
> +#include <linux/pm_runtime.h>
> +#include <asm/sections.h>
> +
> +#include "coresight-etm4x.h"
> +
> +static int boot_enable;
> +module_param_named(boot_enable, boot_enable, int, S_IRUGO);
> +
> +/* The number of ETMv4 currently registered */
> +static int etm4_count;
> +static struct etmv4_drvdata *etmdrvdata[NR_CPUS];
> +
> +static void etm4_os_unlock(void *info)
> +{
> +	struct etmv4_drvdata *drvdata = (struct etmv4_drvdata *)info;
> +
> +	/* Writing any value to ETMOSLAR unlocks the trace registers */
> +	writel_relaxed(0x0, drvdata->base + TRCOSLAR);
> +	isb();
> +}
> +
> +static bool etm4_arch_supported(u8 arch)
> +{
> +	switch (arch) {
> +	case ETM_ARCH_V4:
> +		break;
> +	default:
> +		return false;
> +	}
> +	return true;
> +}
> +
> +static int etm4_trace_id(struct coresight_device *csdev)
> +{
> +	struct etmv4_drvdata *drvdata = dev_get_drvdata(csdev->dev.parent);
> +	unsigned long flags;
> +	int trace_id = -1;
> +
> +	if (!drvdata->enable)
> +		return drvdata->trcid;
> +
> +	pm_runtime_get_sync(drvdata->dev);
> +	spin_lock_irqsave(&drvdata->spinlock, flags);
> +
> +	CS_UNLOCK(drvdata->base);
> +	trace_id = readl_relaxed(drvdata->base + TRCTRACEIDR);
> +	trace_id &= ETM_TRACEID_MASK;
> +	CS_LOCK(drvdata->base);
> +
> +	spin_unlock_irqrestore(&drvdata->spinlock, flags);
> +	pm_runtime_put(drvdata->dev);
> +
> +	return trace_id;
> +}
> +
> +static void etm4_enable_hw(void *info)
> +{
> +	int i;
> +	struct etmv4_drvdata *drvdata = info;
> +
> +	CS_UNLOCK(drvdata->base);
> +
> +	etm4_os_unlock(drvdata);
> +
> +	/* Disable the trace unit before programming trace registers */
> +	writel_relaxed(0, drvdata->base + TRCPRGCTLR);
> +
> +	/* wait for TRCSTATR.IDLE to go up */
> +	if (coresight_timeout(drvdata->base, TRCSTATR, TRCSTATR_IDLE_BIT, 1))
> +		dev_err(drvdata->dev,
> +			"timeout observed when probing at offset %#x\n",
> +			TRCSTATR);
> +
> +	writel_relaxed(drvdata->pe_sel, drvdata->base + TRCPROCSELR);
> +	writel_relaxed(drvdata->cfg, drvdata->base + TRCCONFIGR);
> +	/* nothing specific implemented */
> +	writel_relaxed(0x0, drvdata->base + TRCAUXCTLR);
> +	writel_relaxed(drvdata->eventctrl0, drvdata->base + TRCEVENTCTL0R);
> +	writel_relaxed(drvdata->eventctrl1, drvdata->base + TRCEVENTCTL1R);
> +	writel_relaxed(drvdata->stall_ctrl, drvdata->base + TRCSTALLCTLR);
> +	writel_relaxed(drvdata->ts_ctrl, drvdata->base + TRCTSCTLR);
> +	writel_relaxed(drvdata->syncfreq, drvdata->base + TRCSYNCPR);
> +	writel_relaxed(drvdata->ccctlr, drvdata->base + TRCCCCTLR);
> +	writel_relaxed(drvdata->bb_ctrl, drvdata->base + TRCBBCTLR);
> +	writel_relaxed(drvdata->trcid, drvdata->base + TRCTRACEIDR);
> +	writel_relaxed(drvdata->vinst_ctrl, drvdata->base + TRCVICTLR);
> +	writel_relaxed(drvdata->viiectlr, drvdata->base + TRCVIIECTLR);
> +	writel_relaxed(drvdata->vissctlr,
> +		       drvdata->base + TRCVISSCTLR);
> +	writel_relaxed(drvdata->vipcssctlr,
> +		       drvdata->base + TRCVIPCSSCTLR);
> +	for (i = 0; i < drvdata->nrseqstate - 1; i++)
> +		writel_relaxed(drvdata->seq_ctrl[i],
> +			       drvdata->base + TRCSEQEVRn(i));
> +	writel_relaxed(drvdata->seq_rst, drvdata->base + TRCSEQRSTEVR);
> +	writel_relaxed(drvdata->seq_state, drvdata->base + TRCSEQSTR);
> +	writel_relaxed(drvdata->ext_inp, drvdata->base + TRCEXTINSELR);
> +	for (i = 0; i < drvdata->nr_cntr; i++) {
> +		writel_relaxed(drvdata->cntrldvr[i],
> +			       drvdata->base + TRCCNTRLDVRn(i));
> +		writel_relaxed(drvdata->cntr_ctrl[i],
> +			       drvdata->base + TRCCNTCTLRn(i));
> +		writel_relaxed(drvdata->cntr_val[i],
> +			       drvdata->base + TRCCNTVRn(i));
> +	}
> +	for (i = 0; i < drvdata->nr_resource; i++)
> +		writel_relaxed(drvdata->res_ctrl[i],
> +			       drvdata->base + TRCRSCTLRn(i));
> +
> +	for (i = 0; i < drvdata->nr_ss_cmp; i++) {
> +		writel_relaxed(drvdata->ss_ctrl[i],
> +			       drvdata->base + TRCSSCCRn(i));
> +		writel_relaxed(drvdata->ss_status[i],
> +			       drvdata->base + TRCSSCSRn(i));
> +		writel_relaxed(drvdata->ss_pe_cmp[i],
> +			       drvdata->base + TRCSSPCICRn(i));
> +	}
> +	for (i = 0; i < drvdata->nr_addr_cmp; i++) {
> +		writeq_relaxed(drvdata->addr_val[i],
> +			       drvdata->base + TRCACVRn(i));
> +		writeq_relaxed(drvdata->addr_acc[i],
> +			       drvdata->base + TRCACATRn(i));
> +	}
> +	for (i = 0; i < drvdata->numcidc; i++)
> +		writeq_relaxed(drvdata->ctxid_val[i],
> +			       drvdata->base + TRCCIDCVRn(i));
> +	writel_relaxed(drvdata->ctxid_mask0, drvdata->base + TRCCIDCCTLR0);
> +	writel_relaxed(drvdata->ctxid_mask1, drvdata->base + TRCCIDCCTLR1);
> +
> +	for (i = 0; i < drvdata->numvmidc; i++)
> +		writeq_relaxed(drvdata->vmid_val[i],
> +			       drvdata->base + TRCVMIDCVRn(i));
> +	writel_relaxed(drvdata->vmid_mask0, drvdata->base + TRCVMIDCCTLR0);
> +	writel_relaxed(drvdata->vmid_mask1, drvdata->base + TRCVMIDCCTLR1);
> +
> +	/* Enable the trace unit */
> +	writel_relaxed(1, drvdata->base + TRCPRGCTLR);
> +
> +	/* wait for TRCSTATR.IDLE to go back down to '0' */
> +	if (coresight_timeout(drvdata->base, TRCSTATR, TRCSTATR_IDLE_BIT, 0))
> +		dev_err(drvdata->dev,
> +			"timeout observed when probing at offset %#x\n",
> +			TRCSTATR);
> +
> +	CS_LOCK(drvdata->base);
> +
> +	dev_dbg(drvdata->dev, "cpu: %d enable smp call done\n", drvdata->cpu);
> +}
> +
> +static int etm4_enable(struct coresight_device *csdev)
> +{
> +	struct etmv4_drvdata *drvdata = dev_get_drvdata(csdev->dev.parent);
> +	int ret;
> +
> +	pm_runtime_get_sync(drvdata->dev);
> +	spin_lock(&drvdata->spinlock);
> +
> +	/*
> +	 * Executing etm4_enable_hw on the cpu whose ETM is being enabled
> +	 * ensures that register writes occur when cpu is powered.
> +	 */
> +	ret = smp_call_function_single(drvdata->cpu,
> +				       etm4_enable_hw, drvdata, 1);
> +	if (ret)
> +		goto err;
> +	drvdata->enable = true;
> +	drvdata->sticky_enable = true;
> +
> +	spin_unlock(&drvdata->spinlock);
> +
> +	dev_info(drvdata->dev, "ETM tracing enabled\n");
> +	return 0;
> +err:
> +	spin_unlock(&drvdata->spinlock);
> +	pm_runtime_put(drvdata->dev);
> +	return ret;
> +}
> +
> +static void etm4_disable_hw(void *info)
> +{
> +	u32 control;
> +	struct etmv4_drvdata *drvdata = info;
> +
> +	CS_UNLOCK(drvdata->base);
> +
> +	control = readl_relaxed(drvdata->base + TRCPRGCTLR);
> +
> +	/* EN, bit[0] Trace unit enable bit */
> +	control &= ~0x1;
> +
> +	/* make sure everything completes before disabling */
> +	mb();
> +	isb();
> +	writel_relaxed(control, drvdata->base + TRCPRGCTLR);
> +
> +	CS_LOCK(drvdata->base);
> +
> +	dev_dbg(drvdata->dev, "cpu: %d disable smp call done\n", drvdata->cpu);
> +}
> +
> +static void etm4_disable(struct coresight_device *csdev)
> +{
> +	struct etmv4_drvdata *drvdata = dev_get_drvdata(csdev->dev.parent);
> +
> +	/*
> +	 * Taking hotplug lock here protects from clocks getting disabled
> +	 * with tracing being left on (crash scenario) if user disable occurs
> +	 * after cpu online mask indicates the cpu is offline but before the
> +	 * DYING hotplug callback is serviced by the ETM driver.
> +	 */
> +	get_online_cpus();
> +	spin_lock(&drvdata->spinlock);
> +
> +	/*
> +	 * Executing etm4_disable_hw on the cpu whose ETM is being disabled
> +	 * ensures that register writes occur when cpu is powered.
> +	 */
> +	smp_call_function_single(drvdata->cpu, etm4_disable_hw, drvdata, 1);
> +	drvdata->enable = false;
> +
> +	spin_unlock(&drvdata->spinlock);
> +	put_online_cpus();
> +
> +	pm_runtime_put(drvdata->dev);
> +
> +	dev_info(drvdata->dev, "ETM tracing disabled\n");
> +}
> +
> +static const struct coresight_ops_source etm4_source_ops = {
> +	.trace_id	= etm4_trace_id,
> +	.enable		= etm4_enable,
> +	.disable	= etm4_disable,
> +};
> +
> +static const struct coresight_ops etm4_cs_ops = {
> +	.source_ops	= &etm4_source_ops,
> +};
> +
> +static ssize_t status_show(struct device *dev,
> +			   struct device_attribute *attr, char *buf)
> +{
> +	int ret;
> +	unsigned long flags;
> +	struct etmv4_drvdata *drvdata = dev_get_drvdata(dev->parent);
> +
> +	pm_runtime_get_sync(drvdata->dev);
> +
> +	spin_lock_irqsave(&drvdata->spinlock, flags);
> +	CS_UNLOCK(drvdata->base);
> +	ret = sprintf(buf,
> +		      "TRCCONFIGR:\t0x%08x\n"
> +		      "TRCEVENTCTL0R:\t0x%08x\n"
> +		      "TRCEVENTCTL1R:\t0x%08x\n"
> +		      "TRCSTALLCTLR:\t0x%08x\n"
> +		      "TRCSYNCPR:\t0x%08x\n"
> +		      "TRCTRACEIDR:\t0x%08x\n"
> +		      "TRCTSCTLR:\t0x%08x\n"
> +		      "TRCVDARCCTLR:\t0x%08x\n"
> +		      "TRCVDCTLR:\t0x%08x\n"
> +		      "TRCVDSACCTLR:\t0x%08x\n"
> +		      "TRCVICTLR:\t0x%08x\n"
> +		      "TRCVIIECTLR:\t0x%08x\n"
> +		      "TRCVISSCTLR:\t0x%08x\n"
> +		      "TRCPRGCTLR:\t0x%08x\n"
> +		      "CPU affinity:\t%d\n",

That is not one-value-per-file, as is the rules for sysfs.  Sorry,
please fix up.
