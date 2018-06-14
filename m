From: Wu Hao <hao.wu@intel.com>
Subject: Re: [PATCH v6 18/29] fpga: dfl: add fpga manager platform driver for
 FME
Date: Thu, 14 Jun 2018 21:50:47 +0800
Message-ID: <20180614135047.GA17266@hao-dev>
References: <1528798243-2029-1-git-send-email-hao.wu@intel.com>
 <1528798243-2029-19-git-send-email-hao.wu@intel.com>
 <20180614011642.scearqx5glmffuwc@derp-derp.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180614011642.scearqx5glmffuwc@derp-derp.local>
Sender: linux-kernel-owner@vger.kernel.org
To: Moritz Fischer <mdf@kernel.org>
Cc: atull@kernel.org, linux-fpga@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, luwei.kang@intel.com, yi.z.zhang@intel.com, Tim Whisonant <tim.whisonant@intel.com>, Enno Luebbers <enno.luebbers@intel.com>, Shiva Rao <shiva.rao@intel.com>, Christopher Rauer <christopher.rauer@intel.com>, Xiao Guangrong <guangrong.xiao@linux.intel.com>
List-Id: linux-api@vger.kernel.org

On Wed, Jun 13, 2018 at 08:16:42PM -0500, Moritz Fischer wrote:
> Hi Hao,
> 
> small nit below, looks good otherwise.
> 
> On Tue, Jun 12, 2018 at 06:10:32PM +0800, Wu Hao wrote:
> > This patch adds fpga manager driver for FPGA Management Engine (FME). It
> > implements fpga_manager_ops for FPGA Partial Reconfiguration function.
> > 
> > Signed-off-by: Tim Whisonant <tim.whisonant@intel.com>
> > Signed-off-by: Enno Luebbers <enno.luebbers@intel.com>
> > Signed-off-by: Shiva Rao <shiva.rao@intel.com>
> > Signed-off-by: Christopher Rauer <christopher.rauer@intel.com>
> > Signed-off-by: Kang Luwei <luwei.kang@intel.com>
> > Signed-off-by: Xiao Guangrong <guangrong.xiao@linux.intel.com>
> > Signed-off-by: Wu Hao <hao.wu@intel.com>
> > Acked-by: Alan Tull <atull@kernel.org>
> > ---
> > v3: rename driver to dfl-fpga-fme-mgr
> >     implemented status callback for fpga manager
> >     rebased due to fpga api changes
> > v4: rename to dfl-fme-mgr, and fix SPDX license issue
> >     add pr_credit comments and improve dev_err message
> >     remove interface_id sysfs interface
> >     include dfl-fme-pr.h instead of dfl.h
> > v5: move related register definition from dfl-fme-pr.h to dfl-fme-mgr.c
> >     use mapped ioaddr passed via pdata for register access.
> >     rebase due to fpga manager API changes.
> >     include header file for readq/writeq.
> > v6: rebase, fix copyright time and add Acked-by from Alan.
> > ---
> >  drivers/fpga/Kconfig       |   6 +
> >  drivers/fpga/Makefile      |   1 +
> >  drivers/fpga/dfl-fme-mgr.c | 334 +++++++++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 341 insertions(+)
> >  create mode 100644 drivers/fpga/dfl-fme-mgr.c
> > 
> > diff --git a/drivers/fpga/Kconfig b/drivers/fpga/Kconfig
> > index 45e9220..ca97f3c 100644
> > --- a/drivers/fpga/Kconfig
> > +++ b/drivers/fpga/Kconfig
> > @@ -156,6 +156,12 @@ config FPGA_DFL_FME
> >  	  FPGA platform level management features. There shall be 1 FME
> >  	  per DFL based FPGA device.
> >  
> > +config FPGA_DFL_FME_MGR
> > +	tristate "FPGA DFL FME Manager Driver"
> > +	depends on FPGA_DFL_FME
> > +	help
> > +	  Say Y to enable FPGA Manager driver for FPGA Management Engine.
> > +
> >  config FPGA_DFL_PCI
> >  	tristate "FPGA DFL PCIe Device Driver"
> >  	depends on PCI && FPGA_DFL
> > diff --git a/drivers/fpga/Makefile b/drivers/fpga/Makefile
> > index fd334d40..23f41b0 100644
> > --- a/drivers/fpga/Makefile
> > +++ b/drivers/fpga/Makefile
> > @@ -32,6 +32,7 @@ obj-$(CONFIG_OF_FPGA_REGION)		+= of-fpga-region.o
> >  # FPGA Device Feature List Support
> >  obj-$(CONFIG_FPGA_DFL)			+= dfl.o
> >  obj-$(CONFIG_FPGA_DFL_FME)		+= dfl-fme.o
> > +obj-$(CONFIG_FPGA_DFL_FME_MGR)		+= dfl-fme-mgr.o
> >  
> >  dfl-fme-objs := dfl-fme-main.o dfl-fme-pr.o
> >  
> > diff --git a/drivers/fpga/dfl-fme-mgr.c b/drivers/fpga/dfl-fme-mgr.c
> > new file mode 100644
> > index 0000000..be0060a
> > --- /dev/null
> > +++ b/drivers/fpga/dfl-fme-mgr.c
> > @@ -0,0 +1,334 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * FPGA Manager Driver for FPGA Management Engine (FME)
> > + *
> > + * Copyright (C) 2017-2018 Intel Corporation, Inc.
> > + *
> > + * Authors:
> > + *   Kang Luwei <luwei.kang@intel.com>
> > + *   Xiao Guangrong <guangrong.xiao@linux.intel.com>
> > + *   Wu Hao <hao.wu@intel.com>
> > + *   Joseph Grecco <joe.grecco@intel.com>
> > + *   Enno Luebbers <enno.luebbers@intel.com>
> > + *   Tim Whisonant <tim.whisonant@intel.com>
> > + *   Ananda Ravuri <ananda.ravuri@intel.com>
> > + *   Christopher Rauer <christopher.rauer@intel.com>
> > + *   Henry Mitchel <henry.mitchel@intel.com>
> > + */
> > +
> > +#include <linux/bitfield.h>
> > +#include <linux/module.h>
> > +#include <linux/iopoll.h>
> > +#include <linux/io-64-nonatomic-lo-hi.h>
> > +#include <linux/fpga/fpga-mgr.h>
> > +
> > +#include "dfl-fme-pr.h"
> > +
> > +/* FME Partial Reconfiguration Sub Feature Register Set */
> > +#define FME_PR_DFH		0x0
> > +#define FME_PR_CTRL		0x8
> > +#define FME_PR_STS		0x10
> > +#define FME_PR_DATA		0x18
> > +#define FME_PR_ERR		0x20
> > +#define FME_PR_INTFC_ID_H	0xA8
> > +#define FME_PR_INTFC_ID_L	0xB0
> > +
> > +/* FME PR Control Register Bitfield */
> > +#define FME_PR_CTRL_PR_RST	BIT_ULL(0)  /* Reset PR engine */
> > +#define FME_PR_CTRL_PR_RSTACK	BIT_ULL(4)  /* Ack for PR engine reset */
> > +#define FME_PR_CTRL_PR_RGN_ID	GENMASK_ULL(9, 7)       /* PR Region ID */
> > +#define FME_PR_CTRL_PR_START	BIT_ULL(12) /* Start to request PR service */
> > +#define FME_PR_CTRL_PR_COMPLETE	BIT_ULL(13) /* PR data push completion */
> > +
> > +/* FME PR Status Register Bitfield */
> > +/* Number of available entries in HW queue inside the PR engine. */
> > +#define FME_PR_STS_PR_CREDIT	GENMASK_ULL(8, 0)
> > +#define FME_PR_STS_PR_STS	BIT_ULL(16) /* PR operation status */
> > +#define FME_PR_STS_PR_STS_IDLE	0
> > +#define FME_PR_STS_PR_CTRLR_STS	GENMASK_ULL(22, 20)     /* Controller status */
> > +#define FME_PR_STS_PR_HOST_STS	GENMASK_ULL(27, 24)     /* PR host status */
> > +
> > +/* FME PR Data Register Bitfield */
> > +/* PR data from the raw-binary file. */
> > +#define FME_PR_DATA_PR_DATA_RAW	GENMASK_ULL(32, 0)
> > +
> > +/* FME PR Error Register */
> > +/* PR Operation errors detected. */
> > +#define FME_PR_ERR_OPERATION_ERR	BIT_ULL(0)
> > +/* CRC error detected. */
> > +#define FME_PR_ERR_CRC_ERR		BIT_ULL(1)
> > +/* Incompatible PR bitstream detected. */
> > +#define FME_PR_ERR_INCOMPATIBLE_BS	BIT_ULL(2)
> > +/* PR data push protocol violated. */
> > +#define FME_PR_ERR_PROTOCOL_ERR		BIT_ULL(3)
> > +/* PR data fifo overflow error detected */
> > +#define FME_PR_ERR_FIFO_OVERFLOW	BIT_ULL(4)
> > +
> > +#define PR_WAIT_TIMEOUT   8000000
> > +#define PR_HOST_STATUS_IDLE	0
> > +
> > +struct fme_mgr_priv {
> > +	void __iomem *ioaddr;
> > +	u64 pr_error;
> > +};
> > +
> > +static u64 pr_error_to_mgr_status(u64 err)
> > +{
> > +	u64 status = 0;
> > +
> > +	if (err & FME_PR_ERR_OPERATION_ERR)
> > +		status |= FPGA_MGR_STATUS_OPERATION_ERR;
> > +	if (err & FME_PR_ERR_CRC_ERR)
> > +		status |= FPGA_MGR_STATUS_CRC_ERR;
> > +	if (err & FME_PR_ERR_INCOMPATIBLE_BS)
> > +		status |= FPGA_MGR_STATUS_INCOMPATIBLE_IMAGE_ERR;
> > +	if (err & FME_PR_ERR_PROTOCOL_ERR)
> > +		status |= FPGA_MGR_STATUS_IP_PROTOCOL_ERR;
> > +	if (err & FME_PR_ERR_FIFO_OVERFLOW)
> > +		status |= FPGA_MGR_STATUS_FIFO_OVERFLOW_ERR;
> > +
> > +	return status;
> > +}
> > +
> > +static u64 fme_mgr_pr_error_handle(void __iomem *fme_pr)
> > +{
> > +	u64 pr_status, pr_error;
> > +
> > +	pr_status = readq(fme_pr + FME_PR_STS);
> > +	if (!(pr_status & FME_PR_STS_PR_STS))
> > +		return 0;
> > +
> > +	pr_error = readq(fme_pr + FME_PR_ERR);
> > +	writeq(pr_error, fme_pr + FME_PR_ERR);
> > +
> > +	return pr_error;
> > +}
> > +
> > +static int fme_mgr_write_init(struct fpga_manager *mgr,
> > +			      struct fpga_image_info *info,
> > +			      const char *buf, size_t count)
> > +{
> > +	struct device *dev = &mgr->dev;
> > +	struct fme_mgr_priv *priv = mgr->priv;
> > +	void __iomem *fme_pr = priv->ioaddr;
> > +	u64 pr_ctrl, pr_status;
> > +
> > +	if (!(info->flags & FPGA_MGR_PARTIAL_RECONFIG)) {
> > +		dev_err(dev, "only supports partial reconfiguration.\n");
> > +		return -EINVAL;
> > +	}
> > +
> > +	dev_dbg(dev, "resetting PR before initiated PR\n");
> > +
> > +	pr_ctrl = readq(fme_pr + FME_PR_CTRL);
> > +	pr_ctrl |= FME_PR_CTRL_PR_RST;
> > +	writeq(pr_ctrl, fme_pr + FME_PR_CTRL);
> > +
> > +	if (readq_poll_timeout(fme_pr + FME_PR_CTRL, pr_ctrl,
> > +			       pr_ctrl & FME_PR_CTRL_PR_RSTACK, 1,
> > +			       PR_WAIT_TIMEOUT)) {
> > +		dev_err(dev, "PR Reset ACK timeout\n");
> > +		return -ETIMEDOUT;
> > +	}
> > +
> > +	pr_ctrl = readq(fme_pr + FME_PR_CTRL);
> > +	pr_ctrl &= ~FME_PR_CTRL_PR_RST;
> > +	writeq(pr_ctrl, fme_pr + FME_PR_CTRL);
> > +
> > +	dev_dbg(dev,
> > +		"waiting for PR resource in HW to be initialized and ready\n");
> > +
> > +	if (readq_poll_timeout(fme_pr + FME_PR_STS, pr_status,
> > +			       (pr_status & FME_PR_STS_PR_STS) ==
> > +			       FME_PR_STS_PR_STS_IDLE, 1, PR_WAIT_TIMEOUT)) {
> > +		dev_err(dev, "PR Status timeout\n");
> > +		priv->pr_error = fme_mgr_pr_error_handle(fme_pr);
> > +		return -ETIMEDOUT;
> > +	}
> > +
> > +	dev_dbg(dev, "check and clear previous PR error\n");
> > +	priv->pr_error = fme_mgr_pr_error_handle(fme_pr);
> > +	if (priv->pr_error)
> > +		dev_dbg(dev, "previous PR error detected %llx\n",
> > +			(unsigned long long)priv->pr_error);
> > +
> > +	dev_dbg(dev, "set PR port ID\n");
> > +
> > +	pr_ctrl = readq(fme_pr + FME_PR_CTRL);
> > +	pr_ctrl &= ~FME_PR_CTRL_PR_RGN_ID;
> > +	pr_ctrl |= FIELD_PREP(FME_PR_CTRL_PR_RGN_ID, info->region_id);
> > +	writeq(pr_ctrl, fme_pr + FME_PR_CTRL);
> > +
> > +	return 0;
> > +}
> > +
> > +static int fme_mgr_write(struct fpga_manager *mgr,
> > +			 const char *buf, size_t count)
> > +{
> > +	struct device *dev = &mgr->dev;
> > +	struct fme_mgr_priv *priv = mgr->priv;
> > +	void __iomem *fme_pr = priv->ioaddr;
> > +	u64 pr_ctrl, pr_status, pr_data;
> > +	int delay = 0, pr_credit, i = 0;
> > +
> > +	dev_dbg(dev, "start request\n");
> > +
> > +	pr_ctrl = readq(fme_pr + FME_PR_CTRL);
> > +	pr_ctrl |= FME_PR_CTRL_PR_START;
> > +	writeq(pr_ctrl, fme_pr + FME_PR_CTRL);
> > +
> > +	dev_dbg(dev, "pushing data from bitstream to HW\n");
> > +
> > +	/*
> > +	 * driver can push data to PR hardware using PR_DATA register once HW
> > +	 * has enough pr_credit (> 1), pr_credit reduces one for every 32bit
> > +	 * pr data write to PR_DATA register. If pr_credit <= 1, driver needs
> > +	 * to wait for enough pr_credit from hardware by polling.
> > +	 */
> > +	pr_status = readq(fme_pr + FME_PR_STS);
> > +	pr_credit = FIELD_GET(FME_PR_STS_PR_CREDIT, pr_status);
> > +
> > +	while (count > 0) {
> > +		while (pr_credit <= 1) {
> > +			if (delay++ > PR_WAIT_TIMEOUT) {
> > +				dev_err(dev, "PR_CREDIT timeout\n");
> > +				return -ETIMEDOUT;
> > +			}
> > +			udelay(1);
> > +
> > +			pr_status = readq(fme_pr + FME_PR_STS);
> > +			pr_credit = FIELD_GET(FME_PR_STS_PR_CREDIT, pr_status);
> > +		}
> > +
> > +		if (count < 4) {
> > +			WARN_ON(1);
> Maybe an error message instead of WARN_ON()? How about "Invalid PR
> bitstream size" ?

Sure, will change this in the next version.

Hao


> Thanks,
> 
> Moritz
