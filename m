From: Peter =?iso-8859-15?q?H=FCwe?= <PeterHuewe-Mmb7MZpHnFY@public.gmane.org>
Subject: Re: [PATCH v9 7/8] tpm: TPM 2.0 CRB Interface
Date: Thu, 4 Dec 2014 23:55:14 +0100
Message-ID: <201412042355.15131.PeterHuewe@gmx.de>
References: <1417672518-4530-1-git-send-email-jarkko.sakkinen@linux.intel.com> <1417672518-4530-8-git-send-email-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1417672518-4530-8-git-send-email-jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Ashley Lai <ashley-fm2HMyfA2y6tG0bUXCXiUA@public.gmane.org>, Marcel Selhorst <tpmdd-yWjUBOtONefk1uMJSBkQmQ@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, josh.triplett-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, jason.gunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, trousers-tech-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-api@vger.kernel.org

Am Donnerstag, 4. Dezember 2014, 06:55:17 schrieb Jarkko Sakkinen:
> tpm_crb is a driver for TPM 2.0 Command Response Buffer (CRB) Interface
> as defined in PC Client Platform TPM Profile (PTP) Specification.
> 
> Only polling and single locality is supported as these are the limitations
> of the available hardware, Platform Trust Techonlogy (PTT) in Haswell
> CPUs.
> 
> The driver always applies CRB with ACPI start because PTT reports using
> only ACPI start as start method but as a result of my testing it requires
> also CRB start.
> 
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> ---
>  drivers/char/tpm/Kconfig   |   9 ++
>  drivers/char/tpm/Makefile  |   1 +
>  drivers/char/tpm/tpm_crb.c | 356
> +++++++++++++++++++++++++++++++++++++++++++++ 3 files changed, 366
> insertions(+)
>  create mode 100644 drivers/char/tpm/tpm_crb.c
> 
> diff --git a/drivers/char/tpm/Kconfig b/drivers/char/tpm/Kconfig
> index 3d0873b..9d4e375 100644
> --- a/drivers/char/tpm/Kconfig
> +++ b/drivers/char/tpm/Kconfig
> @@ -122,4 +122,13 @@ config TCG_XEN
>  	  To compile this driver as a module, choose M here; the module
>  	  will be called xen-tpmfront.
> 
> +config TCG_CRB
> +	tristate "TPM 2.0 CRB Interface"
> +	depends on X86 && ACPI
> +	---help---
> +	  If you have a TPM security chip that is compliant with the
> +	  TCG CRB 2.0 TPM specification say Yes and it will be accessible
> +	  from within Linux.  To compile this driver as a module, choose
> +	  M here; the module will be called tpm_crb.
> +
>  endif # TCG_TPM
> diff --git a/drivers/char/tpm/Makefile b/drivers/char/tpm/Makefile
> index 88848ed..990cf18 100644
> --- a/drivers/char/tpm/Makefile
> +++ b/drivers/char/tpm/Makefile
> @@ -22,3 +22,4 @@ obj-$(CONFIG_TCG_INFINEON) += tpm_infineon.o
>  obj-$(CONFIG_TCG_IBMVTPM) += tpm_ibmvtpm.o
>  obj-$(CONFIG_TCG_TIS_I2C_ST33) += tpm_i2c_stm_st33.o
>  obj-$(CONFIG_TCG_XEN) += xen-tpmfront.o
> +obj-$(CONFIG_TCG_CRB) += tpm_crb.o
> diff --git a/drivers/char/tpm/tpm_crb.c b/drivers/char/tpm/tpm_crb.c
> new file mode 100644
> index 0000000..eb78f93
> --- /dev/null
> +++ b/drivers/char/tpm/tpm_crb.c
> @@ -0,0 +1,356 @@
> +/*
> + * Copyright (C) 2014 Intel Corporation
> + *
> + * Authors:
> + * Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> + *
> + * Maintained by: <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
> + *
> + * This device driver implements the TPM interface as defined in
> + * the TCG CRB 2.0 TPM specification.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * as published by the Free Software Foundation; version 2
> + * of the License.
> + */
> +
> +#include <linux/acpi.h>
> +#include <linux/highmem.h>
> +#include <linux/rculist.h>
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +#include "tpm.h"
> +
> +#define ACPI_SIG_TPM2 "TPM2"
> +
> +static const u8 CRB_ACPI_START_UUID[] = {
> +	/* 0000 */ 0xAB, 0x6C, 0xBF, 0x6B, 0x63, 0x54, 0x14, 0x47,
> +	/* 0008 */ 0xB7, 0xCD, 0xF0, 0x20, 0x3C, 0x03, 0x68, 0xD4
> +};
> +
> +enum crb_defaults {
> +	CRB_ACPI_START_REVISION_ID = 1,
> +	CRB_ACPI_START_INDEX = 1,
> +};
> +
> +enum crb_start_method {
> +	CRB_SM_ACPI_START = 2,
> +	CRB_SM_CRB = 7,
> +	CRB_SM_CRB_WITH_ACPI_START = 8,
> +};
> +
> +struct acpi_tpm2 {
> +	struct acpi_table_header hdr;
> +	u16 platform_class;
> +	u16 reserved;
> +	u64 control_area_pa;
> +	u32 start_method;
> +} __packed;
> +
> +enum crb_ca_request {
> +	CRB_CA_REQ_GO_IDLE	= BIT(0),
> +	CRB_CA_REQ_CMD_READY	= BIT(1),
> +};
> +
> +enum crb_ca_status {
> +	CRB_CA_STS_ERROR	= BIT(0),
> +	CRB_CA_STS_TPM_IDLE	= BIT(1),
> +};
> +
> +enum crb_start {
> +	CRB_START_INVOKE	= BIT(0),
> +};
> +
> +enum crb_cancel {
> +	CRB_CANCEL_INVOKE	= BIT(0),
> +};
> +
> +struct crb_control_area {
> +	u32 req;
> +	u32 sts;
> +	u32 cancel;
> +	u32 start;
> +	u32 int_enable;
> +	u32 int_sts;
> +	u32 cmd_size;
> +	u64 cmd_pa;
> +	u32 rsp_size;
> +	u64 rsp_pa;
> +} __packed;
> +
> +enum crb_status {
> +	CRB_STS_COMPLETE	= BIT(0),
> +};
> +
> +enum crb_flags {
> +	CRB_FL_ACPI_START	= BIT(0),
> +	CRB_FL_CRB_START	= BIT(1),
> +};
> +
> +struct crb_priv {
> +	unsigned int flags;
> +	struct crb_control_area *cca;
> +	u8 *cmd;
> +	u8 *rsp;
> +};
> +
> +#ifdef CONFIG_PM_SLEEP
> +int crb_suspend(struct device *dev)
> +{
> +	return 0;
> +}
> +
> +static int crb_resume(struct device *dev)
> +{
> +	struct tpm_chip *chip = dev_get_drvdata(dev);
> +
> +	(void) tpm2_do_selftest(chip);
     ^^^^^ ??????? What's this?
> +
> +	return 0;
> +}
> +#endif

Peter
