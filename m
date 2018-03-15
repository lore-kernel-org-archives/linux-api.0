From: Moritz Fischer <mdf@kernel.org>
Subject: Re: [PATCH v4 08/24] fpga: add FPGA DFL PCIe device driver
Date: Thu, 15 Mar 2018 11:49:56 -0700
Message-ID: <20180315184955.vaz2p4r5zzf4wspy@derp-derp.local>
References: <1518513893-4719-1-git-send-email-hao.wu@intel.com>
 <1518513893-4719-9-git-send-email-hao.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1518513893-4719-9-git-send-email-hao.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Wu Hao <hao.wu@intel.com>
Cc: atull@kernel.org, mdf@kernel.org, linux-fpga@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, luwei.kang@intel.com, yi.z.zhang@intel.com, Tim Whisonant <tim.whisonant@intel.com>, Enno Luebbers <enno.luebbers@intel.com>, Shiva Rao <shiva.rao@intel.com>, Christopher Rauer <christopher.rauer@intel.com>, Xiao Guangrong <guangrong.xiao@linux.intel.com>
List-Id: linux-api@vger.kernel.org

Hi Hao,

On Tue, Feb 13, 2018 at 05:24:37PM +0800, Wu Hao wrote:
> From: Zhang Yi <yi.z.zhang@intel.com>
> 
> This patch implements the basic framework of the driver for FPGA PCIe
> device which implements the Device Feature List (DFL) in its MMIO space.
> This driver is verified on Intel(R) PCIe based FPGA DFL devices, including
> both integrated (e.g Intel Server Platform with In-package FPGA) and
> discrete (e.g Intel FPGA PCIe Acceleration Cards) solutions.
> 
> Signed-off-by: Tim Whisonant <tim.whisonant@intel.com>
> Signed-off-by: Enno Luebbers <enno.luebbers@intel.com>
> Signed-off-by: Shiva Rao <shiva.rao@intel.com>
> Signed-off-by: Christopher Rauer <christopher.rauer@intel.com>
> Signed-off-by: Zhang Yi <yi.z.zhang@intel.com>
> Signed-off-by: Xiao Guangrong <guangrong.xiao@linux.intel.com>
> Signed-off-by: Wu Hao <hao.wu@intel.com>

with module_pci_driver() fix:

Acked-by: Moritz Fischer <mdf@kernel.org>
> ---
> v2: move the code to drivers/fpga folder as suggested by Alan Tull.
>     switch to GPLv2 license.
>     fix comments from Moritz Fischer.
> v3: switch to pci_set_dma_mask/consistent_dma_mask() function.
>     remove pci_save_state() in probe function.
>     rename driver to INTEL_FPGA_DFL_PCI and intel-dfl-pci.c to indicate
>     this driver supports Intel FPGA PCI devices which implement DFL.
>     improve Kconfig description for INTEL_FPGA_DFL_PCI
> v4: rename to FPGA_DFL_PCI (dfl-pci.c) for better reuse.
>     fix SPDX license issue.
> ---
>  drivers/fpga/Kconfig   |  15 ++++++
>  drivers/fpga/Makefile  |   3 ++
>  drivers/fpga/dfl-pci.c | 127 +++++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 145 insertions(+)
>  create mode 100644 drivers/fpga/dfl-pci.c
> 
> diff --git a/drivers/fpga/Kconfig b/drivers/fpga/Kconfig
> index 01ad31f..87f3d44 100644
> --- a/drivers/fpga/Kconfig
> +++ b/drivers/fpga/Kconfig
> @@ -140,4 +140,19 @@ config FPGA_DFL
>  	  Gate Array (FPGA) solutions which implement Device Feature List.
>  	  It provides enumeration APIs, and feature device infrastructure.
>  
> +config FPGA_DFL_PCI
> +	tristate "FPGA Device Feature List (DFL) PCIe Device Driver"
> +	depends on PCI && FPGA_DFL
> +	help
> +	  Select this option to enable PCIe driver for PCIe based
> +	  Field-Programmable Gate Array (FPGA) solutions which implemented
> +	  the Device Feature List (DFL). This driver provides interfaces
> +	  for userspace applications to configure, enumerate, open and access
> +	  FPGA accelerators on the FPGA DFL devices, enables system level
> +	  management functions such as FPGA partial reconfiguration, power
> +	  management, and virtualization with DFL framework and DFL feature
> +	  device drivers.
> +
> +	  To compile this as a module, choose M here.
> +
>  endif # FPGA
> diff --git a/drivers/fpga/Makefile b/drivers/fpga/Makefile
> index c4c62b9..4375630 100644
> --- a/drivers/fpga/Makefile
> +++ b/drivers/fpga/Makefile
> @@ -30,3 +30,6 @@ obj-$(CONFIG_OF_FPGA_REGION)		+= of-fpga-region.o
>  
>  # FPGA Device Feature List Support
>  obj-$(CONFIG_FPGA_DFL)			+= dfl.o
> +
> +# Drivers for FPGAs which implement DFL
> +obj-$(CONFIG_FPGA_DFL_PCI)		+= dfl-pci.o
> diff --git a/drivers/fpga/dfl-pci.c b/drivers/fpga/dfl-pci.c
> new file mode 100644
> index 0000000..d91ea42
> --- /dev/null
> +++ b/drivers/fpga/dfl-pci.c
> @@ -0,0 +1,127 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Driver for FPGA Device Feature List (DFL) PCIe device
> + *
> + * Copyright (C) 2017 Intel Corporation, Inc.
> + *
> + * Authors:
> + *   Zhang Yi <Yi.Z.Zhang@intel.com>
> + *   Xiao Guangrong <guangrong.xiao@linux.intel.com>
> + *   Joseph Grecco <joe.grecco@intel.com>
> + *   Enno Luebbers <enno.luebbers@intel.com>
> + *   Tim Whisonant <tim.whisonant@intel.com>
> + *   Ananda Ravuri <ananda.ravuri@intel.com>
> + *   Henry Mitchel <henry.mitchel@intel.com>
> + */
> +
> +#include <linux/pci.h>
> +#include <linux/types.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/stddef.h>
> +#include <linux/errno.h>
> +#include <linux/aer.h>
> +
> +#define DRV_VERSION	"0.8"
> +#define DRV_NAME	"dfl-pci"
> +
> +/* PCI Device ID */
> +#define PCIE_DEVICE_ID_PF_INT_5_X	0xBCBD
> +#define PCIE_DEVICE_ID_PF_INT_6_X	0xBCC0
> +#define PCIE_DEVICE_ID_PF_DSC_1_X	0x09C4
> +/* VF Device */
> +#define PCIE_DEVICE_ID_VF_INT_5_X	0xBCBF
> +#define PCIE_DEVICE_ID_VF_INT_6_X	0xBCC1
> +#define PCIE_DEVICE_ID_VF_DSC_1_X	0x09C5
> +
> +static struct pci_device_id cci_pcie_id_tbl[] = {
> +	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCIE_DEVICE_ID_PF_INT_5_X),},
> +	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCIE_DEVICE_ID_VF_INT_5_X),},
> +	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCIE_DEVICE_ID_PF_INT_6_X),},
> +	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCIE_DEVICE_ID_VF_INT_6_X),},
> +	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCIE_DEVICE_ID_PF_DSC_1_X),},
> +	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCIE_DEVICE_ID_VF_DSC_1_X),},
> +	{0,}
> +};
> +MODULE_DEVICE_TABLE(pci, cci_pcie_id_tbl);
> +
> +static
> +int cci_pci_probe(struct pci_dev *pcidev, const struct pci_device_id *pcidevid)
> +{
> +	int ret;
> +
> +	ret = pci_enable_device(pcidev);
> +	if (ret < 0) {
> +		dev_err(&pcidev->dev, "Failed to enable device %d.\n", ret);
> +		return ret;
> +	}
> +
> +	ret = pci_enable_pcie_error_reporting(pcidev);
> +	if (ret && ret != -EINVAL)
> +		dev_info(&pcidev->dev, "PCIE AER unavailable %d.\n", ret);
> +
> +	ret = pci_request_regions(pcidev, DRV_NAME);
> +	if (ret) {
> +		dev_err(&pcidev->dev, "Failed to request regions.\n");
> +		goto disable_error_report_exit;
> +	}
> +
> +	pci_set_master(pcidev);
> +
> +	if (!pci_set_dma_mask(pcidev, DMA_BIT_MASK(64))) {
> +		ret = pci_set_consistent_dma_mask(pcidev, DMA_BIT_MASK(64));
> +		if (ret)
> +			goto release_region_exit;
> +	} else if (!pci_set_dma_mask(pcidev, DMA_BIT_MASK(32))) {
> +		ret = pci_set_consistent_dma_mask(pcidev, DMA_BIT_MASK(32));
> +		if (ret)
> +			goto release_region_exit;
> +	} else {
> +		ret = -EIO;
> +		dev_err(&pcidev->dev, "No suitable DMA support available.\n");
> +		goto release_region_exit;
> +	}
> +
> +	/* TODO: create and add the platform device per feature list */
> +	return 0;
> +
> +release_region_exit:
> +	pci_release_regions(pcidev);
> +disable_error_report_exit:
> +	pci_disable_pcie_error_reporting(pcidev);
> +	pci_disable_device(pcidev);
> +	return ret;
> +}
> +
> +static void cci_pci_remove(struct pci_dev *pcidev)
> +{
> +	pci_release_regions(pcidev);
> +	pci_disable_pcie_error_reporting(pcidev);
> +	pci_disable_device(pcidev);
> +}
> +
> +static struct pci_driver cci_pci_driver = {
> +	.name = DRV_NAME,
> +	.id_table = cci_pcie_id_tbl,
> +	.probe = cci_pci_probe,
> +	.remove = cci_pci_remove,
> +};
> +
> +static int __init ccidrv_init(void)
> +{
> +	pr_info("FPGA DFL PCIe Driver: Version %s\n", DRV_VERSION);

Not a fan of the additional output. Can you make it module_pci_driver?
> +
> +	return pci_register_driver(&cci_pci_driver);
> +}
> +
> +static void __exit ccidrv_exit(void)
> +{
> +	pci_unregister_driver(&cci_pci_driver);
> +}
> +
> +module_init(ccidrv_init);
> +module_exit(ccidrv_exit);
> +
> +MODULE_DESCRIPTION("FPGA DFL PCIe Device Driver");
> +MODULE_AUTHOR("Intel Corporation");
> +MODULE_LICENSE("GPL v2");
> -- 
> 2.7.4
> 
