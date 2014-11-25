From: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [tpmdd-devel] [PATCH v7 10/10] tpm: TPM 2.0 sysfs attributes
Date: Tue, 25 Nov 2014 18:55:38 -0500
Message-ID: <547516FA.6060304@linux.vnet.ibm.com>
References: <1415713513-16524-1-git-send-email-jarkko.sakkinen@linux.intel.com> <1415713513-16524-11-git-send-email-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1415713513-16524-11-git-send-email-jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>, Ashley Lai <ashley-fm2HMyfA2y6tG0bUXCXiUA@public.gmane.org>, Marcel Selhorst <tpmdd-yWjUBOtONefk1uMJSBkQmQ@public.gmane.org>
Cc: christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, josh.triplett-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, jason.gunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, trousers-tech-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 11/11/2014 08:45 AM, Jarkko Sakkinen wrote:
> Manadatory sysfs attributes for TPM 2.0 devices so that it is easy
> to check whether storage hierarchies are enabled and use PPI
> interface.
>
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> ---
>   Documentation/ABI/stable/sysfs-class-tpm2 |  57 +++++++++++
>   drivers/char/tpm/Makefile                 |   2 +-
>   drivers/char/tpm/tpm-chip.c               |  21 +++--
>   drivers/char/tpm/tpm.h                    |  19 ++++
>   drivers/char/tpm/tpm2-sysfs.c             | 152 ++++++++++++++++++++++++++++++
>   5 files changed, 241 insertions(+), 10 deletions(-)
>   create mode 100644 Documentation/ABI/stable/sysfs-class-tpm2
>   create mode 100644 drivers/char/tpm/tpm2-sysfs.c
>
> diff --git a/Documentation/ABI/stable/sysfs-class-tpm2 b/Documentation/ABI/stable/sysfs-class-tpm2
> new file mode 100644
> index 0000000..301ab2e
> --- /dev/null
> +++ b/Documentation/ABI/stable/sysfs-class-tpm2
> @@ -0,0 +1,57 @@
> +What:		/sys/class/misc/tpmX/device/
> +Date:		October 2014
> +KernelVersion:	3.19
> +Contact:	tpmdd-devel-TtF/mJH4Jtrk1uMJSBkQmQ@public.gmane.org
> +Description:	The device/ directory under a specific TPM instance exposes
> +		the properties of that TPM chip.
> +
> +What:		/sys/class/misc/tpmX/device/family
> +Date:		October 2014
> +KernelVersion:	3.19
> +Contact:	tpmdd-devel-TtF/mJH4Jtrk1uMJSBkQmQ@public.gmane.org
> +Description:	The protocol family in the major.minor format.
> +

What protocol ? The TPM protocol family .. ?

> +What:		/sys/class/misc/tpmX/device/sh_enabled
> +Date:		October 2014
> +KernelVersion:	3.19
> +Contact:	tpmdd-devel-TtF/mJH4Jtrk1uMJSBkQmQ@public.gmane.org
> +Description:	The "sh_enabled" property prints a '1' if the Storage Hierarchy
> +		is enabled, i.e. if PM_PT_STARTUP_CLEAR.shEnable is set.

Why capital letters for storage hierarchy?

> +
> +What:		/sys/class/misc/tpmX/device/sh_owned
> +Date:		October 2014
> +KernelVersion:	3.19
> +Contact:	tpmdd-devel-TtF/mJH4Jtrk1uMJSBkQmQ@public.gmane.org
> +Description:	The "sh_owned" property prints a '1' if the ownership of the
> +		Storage Hierarchy has been taken, i.e. if
> +		TPM_PT_PERMANENT.ownerAuthSet is set.
> +

Same her

> +What:		/sys/class/misc/tpmX/device/eh_enabled
> +Date:		October 2014
> +KernelVersion:	3.19
> +Contact:	tpmdd-devel-TtF/mJH4Jtrk1uMJSBkQmQ@public.gmane.org
> +Description:	The "eh_enabled" property prints a '1' if the Endorsement
> +		Hierarchy is enabled, i.e if PM_PT_STARTUP_CLEAR.ehEnable is
> +		set.


> +
> +What:		/sys/class/misc/tpmX/device/eh_owned
> +Date:		October 2014
> +KernelVersion:	3.19
> +Contact:	tpmdd-devel-TtF/mJH4Jtrk1uMJSBkQmQ@public.gmane.org
> +Description:	The "eh_owned" property prints a '1' if the ownership of the
> +		Endrosoment Hierarchy has been taken, i.e if
> +		TPM_PT_PERMANENT.endorsementAuthSet is set.
> +
> +What:		/sys/class/misc/tpmX/device/manufacturer
> +Date:		October 2014
> +KernelVersion:	3.19
> +Contact:	tpmdd-devel-TtF/mJH4Jtrk1uMJSBkQmQ@public.gmane.org
> +Description:	The "manufacturer" property prints the vendor ID of the TPM
> +		manufacturer.
> +
> +What:		/sys/class/misc/tpmX/device/firmware
> +Date:		October 2014
> +KernelVersion:	3.19
> +Contact:	tpmdd-devel-TtF/mJH4Jtrk1uMJSBkQmQ@public.gmane.org
> +Description:	The property prints the vendor-specific value indicating the
> +		version of the firmware.
> diff --git a/drivers/char/tpm/Makefile b/drivers/char/tpm/Makefile
> index e6d26dd..15e3b4c 100644
> --- a/drivers/char/tpm/Makefile
> +++ b/drivers/char/tpm/Makefile
> @@ -2,7 +2,7 @@
>   # Makefile for the kernel tpm device drivers.
>   #
>   obj-$(CONFIG_TCG_TPM) += tpm.o
> -tpm-y := tpm-interface.o tpm-dev.o tpm-sysfs.o tpm-chip.o tpm2-cmd.o
> +tpm-y := tpm-interface.o tpm-dev.o tpm-sysfs.o tpm-chip.o tpm2-cmd.o tpm2-sysfs.o
>   tpm-$(CONFIG_ACPI) += tpm_ppi.o
>
>   ifdef CONFIG_ACPI
> diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
> index 4d25b24..accd408 100644
> --- a/drivers/char/tpm/tpm-chip.c
> +++ b/drivers/char/tpm/tpm-chip.c
> @@ -30,6 +30,7 @@
>   #include "tpm_eventlog.h"
>
>   ATTRIBUTE_GROUPS(tpm_dev);
> +ATTRIBUTE_GROUPS(tpm2_dev);
>
>   static DECLARE_BITMAP(dev_mask, TPM_NUM_DEVICES);
>   static LIST_HEAD(tpm_chip_list);
> @@ -138,7 +139,10 @@ struct tpm_chip *tpmm_chip_alloc(struct device *dev,
>   	else
>   		chip->dev.devt = MKDEV(MAJOR(tpm_devt), chip->dev_num);
>
> -	chip->dev.groups = tpm_dev_groups;
> +	if (chip->flags & TPM_CHIP_FLAG_TPM2)
> +		chip->dev.groups = tpm2_dev_groups;
> +	else
> +		chip->dev.groups = tpm_dev_groups;
>
>   	dev_set_name(&chip->dev, chip->devname);
>
> @@ -213,14 +217,12 @@ int tpm_chip_register(struct tpm_chip *chip)
>   	if (rc)
>   		return rc;
>
> -	/* Populate sysfs for TPM1 devices. */
> -	if (!(chip->flags & TPM_CHIP_FLAG_TPM2)) {
> -		rc = tpm_add_ppi(chip);
> -		if (rc)
> -			goto out_err;
> +	rc = tpm_add_ppi(chip);
> +	if (rc)
> +		goto out_err;
>
> +	if (!(chip->flags & TPM_CHIP_FLAG_TPM2))
>   		chip->bios_dir = tpm_bios_log_setup(chip->devname);
> -	}
>
>   	/* Make the chip available. */
>   	spin_lock(&driver_lock);
> @@ -251,8 +253,9 @@ void tpm_chip_unregister(struct tpm_chip *chip)
>   	spin_unlock(&driver_lock);
>   	synchronize_rcu();
>
> -	/* Clean up sysfs for TPM1 devices. */
> -	if (!(chip->flags & TPM_CHIP_FLAG_TPM2)) {
> +	if (chip->flags & TPM_CHIP_FLAG_TPM2) {
> +		tpm_remove_ppi(chip);

Take the tpm_remove_ppi(chip) out of the if and else branches into a 
common path.

> +	} else {
>   		if (chip->bios_dir)
>   			tpm_bios_log_teardown(chip->bios_dir);
>   		tpm_remove_ppi(chip);
> diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
> index 8a434d2..1548182 100644
> --- a/drivers/char/tpm/tpm.h
> +++ b/drivers/char/tpm/tpm.h
> @@ -108,6 +108,24 @@ enum tpm2_capabilities {
>   	TPM2_CAP_TPM_PROPERTIES = 6,
>   };
>
> +enum tpm2_tpm_properties {
> +	TPM2_PT_MANUFACTURER		= 0x00000105,
> +	TPM2_PT_FIRMWARE_VERSION_1	= 0x0000010C,
> +	TPM2_PT_FIRMWARE_VERSION_2	= 0x0000010D,
> +	TPM2_PT_PERMANENT		= 0x00000200,
> +	TPM2_PT_STARTUP_CLEAR		= 0x00000201,
> +};
> +
> +enum tpm2_pt_startup_clear {
> +	TPM2_PT_SC_SH_ENABLE	= BIT(1),
> +	TPM2_PT_SC_EH_ENABLE	= BIT(2),
> +};
> +
> +enum tpm2_pt_permanent {
> +	TPM2_PT_PM_OWNER_AUTH_SET	= BIT(0),
> +	TPM2_PT_PM_ENDORSEMENT_AUTH_SET	= BIT(1),
> +};
> +
>   enum tpm2_startup_types {
>   	TPM2_SU_CLEAR	= 0x0000,
>   	TPM2_SU_STATE	= 0x0001,
> @@ -382,6 +400,7 @@ extern struct class *tpm_class;
>   extern dev_t tpm_devt;
>   extern const struct file_operations tpm_fops;
>   extern struct attribute *tpm_dev_attrs[];
> +extern struct attribute *tpm2_dev_attrs[];
>
>   ssize_t	tpm_getcap(struct device *, __be32, cap_t *, const char *);
>   ssize_t tpm_transmit(struct tpm_chip *chip, const char *buf,
> diff --git a/drivers/char/tpm/tpm2-sysfs.c b/drivers/char/tpm/tpm2-sysfs.c
> new file mode 100644
> index 0000000..9e5e2e3
> --- /dev/null
> +++ b/drivers/char/tpm/tpm2-sysfs.c
> @@ -0,0 +1,152 @@
> +/*
> + * Copyright (C) 2014 Intel Corporation
> + *
> + * Authors:
> + * Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> + *
> + * TPM2 sysfs attributes
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License as
> + * published by the Free Software Foundation, version 2 of the
> + * License.
> + *
> + */
> +#include <linux/device.h>
> +#include <linux/slab.h>
> +#include "tpm.h"
> +
> +static ssize_t sh_enabled_show(struct device *dev, struct device_attribute *attr,
> +		     char *buf)
> +{
> +	struct tpm_chip *chip = container_of(dev, struct tpm_chip, dev);
> +	u32 value;
> +	ssize_t rc;
> +
> +	rc = tpm2_get_tpm_pt(chip, TPM2_PT_STARTUP_CLEAR, &value,
> +			     "could not retrieve STARTUP_CLEAR property");
> +	if (rc)
> +		return 0;
> +
> +	rc = sprintf(buf, "%d\n", (value & TPM2_PT_SC_SH_ENABLE) > 0);
> +	return rc;
> +}
> +static DEVICE_ATTR_RO(sh_enabled);
> +
> +static ssize_t sh_owned_show(struct device *dev, struct device_attribute *attr,
> +			  char *buf)
> +{
> +	struct tpm_chip *chip = container_of(dev, struct tpm_chip, dev);
> +	u32 value;
> +	ssize_t rc;
> +
> +	rc = tpm2_get_tpm_pt(chip, TPM2_PT_PERMANENT, &value,
> +			     "could not retrieve PERMANENT property");
> +	if (rc)
> +		return 0;
> +
> +	rc = sprintf(buf, "%d\n", (value & TPM2_PT_PM_OWNER_AUTH_SET) > 0);
> +	return rc;
> +}
> +static DEVICE_ATTR_RO(sh_owned);
> +
> +static ssize_t eh_enabled_show(struct device *dev, struct device_attribute *attr,
> +		     char *buf)
> +{
> +	struct tpm_chip *chip = container_of(dev, struct tpm_chip, dev);
> +	u32 value;
> +	ssize_t rc;
> +
> +	rc = tpm2_get_tpm_pt(chip, TPM2_PT_STARTUP_CLEAR, &value,
> +			     "could not retrieve STARTUP_CLEAR property");
> +	if (rc)
> +		return 0;
> +
> +	rc = sprintf(buf, "%d\n", (value & TPM2_PT_SC_EH_ENABLE) > 0);
> +	return rc;
> +}
> +static DEVICE_ATTR_RO(eh_enabled);
> +
> +static ssize_t eh_owned_show(struct device *dev, struct device_attribute *attr,
> +			  char *buf)
> +{
> +	struct tpm_chip *chip = container_of(dev, struct tpm_chip, dev);
> +	u32 value;
> +	ssize_t rc;
> +
> +	rc = tpm2_get_tpm_pt(chip, TPM2_PT_PERMANENT, &value,
> +			     "could not retrieve PERMANENT property");
> +	if (rc)
> +		return 0;
> +
> +	rc = sprintf(buf, "%d\n", (value & TPM2_PT_PM_ENDORSEMENT_AUTH_SET) > 0);
> +	return rc;
> +}
> +static DEVICE_ATTR_RO(eh_owned);
> +
> +static ssize_t manufacturer_show(struct device *dev,
> +				 struct device_attribute *attr,
> +				 char *buf)
> +{
> +	struct tpm_chip *chip = container_of(dev, struct tpm_chip, dev);
> +	u32 manufacturer;
> +	ssize_t rc;
> +	char *str = buf;
> +
> +	rc = tpm2_get_tpm_pt(chip, TPM2_PT_MANUFACTURER, (u32 *) &manufacturer,

seems an unnecessary cast.

> +			     "could not retrieve MANUFACTURER property");
> +	if (rc)
> +		return 0;
> +
> +	str += sprintf(str, "0x%08x\n", be32_to_cpu(manufacturer));
> +
rc = sprintf()
return rc;

Like above?
> +	return str - buf;
> +}
> +static DEVICE_ATTR_RO(manufacturer);
> +
> +static ssize_t firmware_show(struct device *dev, struct device_attribute *attr,
> +			 char *buf)
> +{
> +	struct tpm_chip *chip = container_of(dev, struct tpm_chip, dev);
> +	u32 firmware1;
> +	u32 firmware2;
> +	ssize_t rc;
> +	char *str = buf;
> +
> +	rc = tpm2_get_tpm_pt(chip, TPM2_PT_FIRMWARE_VERSION_1, (u32 *) &firmware1,
> +			     "could not retrieve FIRMWARE_VERSION_1 property");
> +	if (rc)
> +		return 0;
> +
> +	rc = tpm2_get_tpm_pt(chip, TPM2_PT_FIRMWARE_VERSION_2, (u32 *) &firmware2,
> +			     "could not retrieve FIRMWARE_VERSION_2 property");
> +	if (rc)
> +		return 0;
> +
> +	str += sprintf(str, "0x%08x.0x%08x\n", firmware1, firmware2);
> +
> +	return str - buf;

Same for here, why not again do rc = sprintf .. return rc; ?

> +}
> +static DEVICE_ATTR_RO(firmware);
> +
> +static ssize_t family_show(struct device *dev, struct device_attribute *attr,
> +			   char *buf)
> +{
> +	char *str = buf;
> +
> +	str += sprintf(str, "2.0\n");
> +
> +	return str - buf;

return sprintf(buf, "2.0\n");

> +}
> +static DEVICE_ATTR_RO(family);
> +
> +struct attribute *tpm2_dev_attrs[] = {
> +	&dev_attr_sh_enabled.attr,
> +	&dev_attr_sh_owned.attr,
> +	&dev_attr_eh_enabled.attr,
> +	&dev_attr_eh_owned.attr,
> +	&dev_attr_manufacturer.attr,
> +	&dev_attr_firmware.attr,
> +	&dev_attr_family.attr,
> +	NULL,
> +};

     Stefan
