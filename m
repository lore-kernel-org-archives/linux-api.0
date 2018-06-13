From: Wu Hao <hao.wu@intel.com>
Subject: Re: [PATCH v6 12/29] fpga: add FPGA DFL PCIe device driver
Date: Thu, 14 Jun 2018 00:34:11 +0800
Message-ID: <20180613163411.GA12639@hao-dev>
References: <1528798243-2029-1-git-send-email-hao.wu@intel.com>
 <1528798243-2029-13-git-send-email-hao.wu@intel.com>
 <20180613135420.GB3866@archbook>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180613135420.GB3866@archbook>
Sender: linux-kernel-owner@vger.kernel.org
To: Moritz Fischer <mdf@kernel.org>
Cc: atull@kernel.org, linux-fpga@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, luwei.kang@intel.com, yi.z.zhang@intel.com, Tim Whisonant <tim.whisonant@intel.com>, Enno Luebbers <enno.luebbers@intel.com>, Shiva Rao <shiva.rao@intel.com>, Christopher Rauer <christopher.rauer@intel.com>, Xiao Guangrong <guangrong.xiao@linux.intel.com>
List-Id: linux-api@vger.kernel.org

On Wed, Jun 13, 2018 at 06:54:20AM -0700, Moritz Fischer wrote:
> On Tue, Jun 12, 2018 at 06:10:26PM +0800, Wu Hao wrote:
> > From: Zhang Yi <yi.z.zhang@intel.com>
> > 
> > This patch implements the basic framework of the driver for FPGA PCIe
> > device which implements the Device Feature List (DFL) in its MMIO space.
> > This driver is verified on Intel(R) PCIe based FPGA DFL devices, including
> > both integrated (e.g Intel Server Platform with In-package FPGA) and
> > discrete (e.g Intel FPGA PCIe Acceleration Cards) solutions.
> > 
> > Signed-off-by: Tim Whisonant <tim.whisonant@intel.com>
> > Signed-off-by: Enno Luebbers <enno.luebbers@intel.com>
> > Signed-off-by: Shiva Rao <shiva.rao@intel.com>
> > Signed-off-by: Christopher Rauer <christopher.rauer@intel.com>
> > Signed-off-by: Zhang Yi <yi.z.zhang@intel.com>
> > Signed-off-by: Xiao Guangrong <guangrong.xiao@linux.intel.com>
> > Signed-off-by: Wu Hao <hao.wu@intel.com>
> > Acked-by: Alan Tull <atull@kernel.org>
> > Acked-by: Moritz Fischer <mdf@kernel.org>
> > ---
> > v2: move the code to drivers/fpga folder as suggested by Alan Tull.
> >     switch to GPLv2 license.
> >     fix comments from Moritz Fischer.
> > v3: switch to pci_set_dma_mask/consistent_dma_mask() function.
> >     remove pci_save_state() in probe function.
> >     rename driver to INTEL_FPGA_DFL_PCI and intel-dfl-pci.c to indicate
> >     this driver supports Intel FPGA PCI devices which implement DFL.
> >     improve Kconfig description for INTEL_FPGA_DFL_PCI
> > v4: rename to FPGA_DFL_PCI (dfl-pci.c) for better reuse.
> >     fix SPDX license issue.
> > v5: use module_pci_driver() instead.
> >     add Acked-by from Alan and Moritz.
> > v6: rebase and unify naming in Kconfig
> > ---
> >  drivers/fpga/Kconfig   |  15 +++++++
> >  drivers/fpga/Makefile  |   3 ++
> >  drivers/fpga/dfl-pci.c | 114 +++++++++++++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 132 insertions(+)
> >  create mode 100644 drivers/fpga/dfl-pci.c
> > 
> > diff --git a/drivers/fpga/Kconfig b/drivers/fpga/Kconfig
> > index 4052532..5faab48 100644
> > --- a/drivers/fpga/Kconfig
> > +++ b/drivers/fpga/Kconfig
> > @@ -146,4 +146,19 @@ config FPGA_DFL
> >  	  Gate Array (FPGA) solutions which implement Device Feature List.
> >  	  It provides enumeration APIs, and feature device infrastructure.
> >  
> > +config FPGA_DFL_PCI
> > +	tristate "FPGA DFL PCIe Device Driver"
> > +	depends on PCI && FPGA_DFL
> > +	help
> > +	  Select this option to enable PCIe driver for PCIe based
> > +	  Field-Programmable Gate Array (FPGA) solutions which implemented
> > +	  the Device Feature List (DFL). This driver provides interfaces
> > +	  for userspace applications to configure, enumerate, open and access
> > +	  FPGA accelerators on the FPGA DFL devices, enables system level
> > +	  management functions such as FPGA partial reconfiguration, power
> > +	  management, and virtualization with DFL framework and DFL feature
> > +	  device drivers.
> > +
> > +	  To compile this as a module, choose M here.
> > +
> >  endif # FPGA
> > diff --git a/drivers/fpga/Makefile b/drivers/fpga/Makefile
> > index 7a7a117..02e0253 100644
> > --- a/drivers/fpga/Makefile
> > +++ b/drivers/fpga/Makefile
> > @@ -31,3 +31,6 @@ obj-$(CONFIG_OF_FPGA_REGION)		+= of-fpga-region.o
> >  
> >  # FPGA Device Feature List Support
> >  obj-$(CONFIG_FPGA_DFL)			+= dfl.o
> > +
> > +# Drivers for FPGAs which implement DFL
> > +obj-$(CONFIG_FPGA_DFL_PCI)		+= dfl-pci.o
> > diff --git a/drivers/fpga/dfl-pci.c b/drivers/fpga/dfl-pci.c
> > new file mode 100644
> > index 0000000..5824c5e
> > --- /dev/null
> > +++ b/drivers/fpga/dfl-pci.c
> > @@ -0,0 +1,114 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * Driver for FPGA Device Feature List (DFL) PCIe device
> > + *
> > + * Copyright (C) 2017-2018 Intel Corporation, Inc.
> > + *
> > + * Authors:
> > + *   Zhang Yi <Yi.Z.Zhang@intel.com>
> > + *   Xiao Guangrong <guangrong.xiao@linux.intel.com>
> > + *   Joseph Grecco <joe.grecco@intel.com>
> > + *   Enno Luebbers <enno.luebbers@intel.com>
> > + *   Tim Whisonant <tim.whisonant@intel.com>
> > + *   Ananda Ravuri <ananda.ravuri@intel.com>
> > + *   Henry Mitchel <henry.mitchel@intel.com>
> > + */
> > +
> > +#include <linux/pci.h>
> > +#include <linux/types.h>
> > +#include <linux/kernel.h>
> > +#include <linux/module.h>
> > +#include <linux/stddef.h>
> > +#include <linux/errno.h>
> > +#include <linux/aer.h>
> > +
> > +#define DRV_VERSION	"0.8"
> > +#define DRV_NAME	"dfl-pci"
> > +
> > +/* PCI Device ID */
> > +#define PCIE_DEVICE_ID_PF_INT_5_X	0xBCBD
> > +#define PCIE_DEVICE_ID_PF_INT_6_X	0xBCC0
> > +#define PCIE_DEVICE_ID_PF_DSC_1_X	0x09C4
> > +/* VF Device */
> > +#define PCIE_DEVICE_ID_VF_INT_5_X	0xBCBF
> > +#define PCIE_DEVICE_ID_VF_INT_6_X	0xBCC1
> > +#define PCIE_DEVICE_ID_VF_DSC_1_X	0x09C5
> > +
> > +static struct pci_device_id cci_pcie_id_tbl[] = {
> > +	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCIE_DEVICE_ID_PF_INT_5_X),},
> > +	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCIE_DEVICE_ID_VF_INT_5_X),},
> > +	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCIE_DEVICE_ID_PF_INT_6_X),},
> > +	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCIE_DEVICE_ID_VF_INT_6_X),},
> > +	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCIE_DEVICE_ID_PF_DSC_1_X),},
> > +	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCIE_DEVICE_ID_VF_DSC_1_X),},
> > +	{0,}
> > +};
> > +MODULE_DEVICE_TABLE(pci, cci_pcie_id_tbl);
> > +
> > +static
> > +int cci_pci_probe(struct pci_dev *pcidev, const struct pci_device_id *pcidevid)
> > +{
> > +	int ret;
> > +
> > +	ret = pci_enable_device(pcidev);
> 
> Any reason we cannot use pcim_enable_device() here?

Hi Moritz

Thanks for the comments, pcim_enable_device() saves code for sure, will switch
to it in the next version.

Thanks
Hao
