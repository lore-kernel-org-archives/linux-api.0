From: Jonathan Cameron <jic23-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/8] mfd: Add support for DA9150 combined charger & fuel-gauge
 device
Date: Sat, 27 Sep 2014 11:33:28 +0100
Message-ID: <54269278.6000803@kernel.org>
References: <cover.1411396718.git.Adam.Thomson.Opensource@diasemi.com> <8fd576055fd9e4f8c75cba06d6ebb13fea670920.1411396719.git.Adam.Thomson.Opensource@diasemi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <8fd576055fd9e4f8c75cba06d6ebb13fea670920.1411396719.git.Adam.Thomson.Opensource-WBD+wuPFNBhBDgjK7y7TUQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Adam Thomson <Adam.Thomson.Opensource-WBD+wuPFNBhBDgjK7y7TUQ@public.gmane.org>, Lee Jones <lee.jones-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Samuel Ortiz <sameo-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-iio-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sebastian Reichel <sre-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dmitry Eremin-Solenikov <dbaryshkov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Grant Likely <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, support.opensource-WBD+wuPFNBhBDgjK7y7TUQ@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 23/09/14 11:53, Adam Thomson wrote:
> DA9150 is a combined Charger and Fuel-Gauge IC, with additional
> GPIO and GPADC functionality.
>
> Signed-off-by: Adam Thomson <Adam.Thomson.Opensource-WBD+wuPFNBhBDgjK7y7TUQ@public.gmane.org>
A random suggestion to reduced the massive set of defines... Why
not just compute the shift from the mask where needed?
Just use ffs(MASK).

No idea if anyone else will like the suggestion though ;)
Otherwise looks fine to me.
> ---
>  drivers/mfd/Kconfig                  |   12 +
>  drivers/mfd/Makefile                 |    2 +-
>  drivers/mfd/da9150-core.c            |  413 ++++++++++++
>  include/linux/mfd/da9150/core.h      |   68 ++
>  include/linux/mfd/da9150/registers.h | 1155 ++++++++++++++++++++++++++++++++++
>  5 files changed, 1649 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/mfd/da9150-core.c
>  create mode 100644 include/linux/mfd/da9150/core.h
>  create mode 100644 include/linux/mfd/da9150/registers.h
>
> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> index de5abf2..e29fc9a 100644
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -183,6 +183,18 @@ config MFD_DA9063
>  	  Additional drivers must be enabled in order to use the functionality
>  	  of the device.
>
> +config MFD_DA9150
> +	tristate "Dialog Semiconductor DA9150 Charger Fuel-Gauge chip"
> +	depends on I2C=y
> +	select MFD_CORE
> +	select REGMAP_I2C
> +	select REGMAP_IRQ
> +	help
> +	  This adds support for the DA9150 integrated charger and fuel-gauge
> +	  chip. This driver provides common support for accessing the device.
> +	  Additional drivers must be enabled in order to use the specific
> +	  features of the device.
> +
>  config MFD_MC13XXX
>  	tristate
>  	depends on (SPI_MASTER || I2C)
> diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
> index f001487..f5484b3 100644
> --- a/drivers/mfd/Makefile
> +++ b/drivers/mfd/Makefile
> @@ -113,7 +113,7 @@ obj-$(CONFIG_MFD_DA9055)	+= da9055.o
>
>  da9063-objs			:= da9063-core.o da9063-irq.o da9063-i2c.o
>  obj-$(CONFIG_MFD_DA9063)	+= da9063.o
> -
> +obj-$(CONFIG_MFD_DA9150)	+= da9150-core.o
>  obj-$(CONFIG_MFD_MAX14577)	+= max14577.o
>  obj-$(CONFIG_MFD_MAX77686)	+= max77686.o
>  obj-$(CONFIG_MFD_MAX77693)	+= max77693.o
> diff --git a/drivers/mfd/da9150-core.c b/drivers/mfd/da9150-core.c
> new file mode 100644
> index 0000000..1de6db7
> --- /dev/null
> +++ b/drivers/mfd/da9150-core.c
> @@ -0,0 +1,413 @@
> +/*
> + * DA9150 Core MFD Driver
> + *
> + * Copyright (c) 2014 Dialog Semiconductor
> + *
> + * Author: Adam Thomson <Adam.Thomson.Opensource-WBD+wuPFNBhBDgjK7y7TUQ@public.gmane.org>
> + *
> + * This program is free software; you can redistribute  it and/or modify it
> + * under  the terms of  the GNU General  Public License as published by the
> + * Free Software Foundation;  either version 2 of the  License, or (at your
> + * option) any later version.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +#include <linux/i2c.h>
> +#include <linux/regmap.h>
> +#include <linux/slab.h>
> +#include <linux/irq.h>
> +#include <linux/interrupt.h>
> +#include <linux/mfd/core.h>
> +#include <linux/mfd/da9150/core.h>
> +#include <linux/mfd/da9150/registers.h>
> +
> +static bool da9150_volatile_reg(struct device *dev, unsigned int reg)
> +{
> +	switch (reg) {
> +	case DA9150_PAGE_CON:
> +	case DA9150_STATUS_A:
> +	case DA9150_STATUS_B:
> +	case DA9150_STATUS_C:
> +	case DA9150_STATUS_D:
> +	case DA9150_STATUS_E:
> +	case DA9150_STATUS_F:
> +	case DA9150_STATUS_G:
> +	case DA9150_STATUS_H:
> +	case DA9150_STATUS_I:
> +	case DA9150_STATUS_J:
> +	case DA9150_STATUS_K:
> +	case DA9150_STATUS_L:
> +	case DA9150_STATUS_N:
> +	case DA9150_FAULT_LOG_A:
> +	case DA9150_FAULT_LOG_B:
> +	case DA9150_EVENT_E:
> +	case DA9150_EVENT_F:
> +	case DA9150_EVENT_G:
> +	case DA9150_EVENT_H:
> +	case DA9150_CONTROL_B:
> +	case DA9150_CONTROL_C:
> +	case DA9150_GPADC_MAN:
> +	case DA9150_GPADC_RES_A:
> +	case DA9150_GPADC_RES_B:
> +	case DA9150_ADETVB_CFG_C:
> +	case DA9150_ADETD_STAT:
> +	case DA9150_ADET_CMPSTAT:
> +	case DA9150_ADET_CTRL_A:
> +	case DA9150_PPR_TCTR_B:
> +	case DA9150_COREBTLD_STAT_A:
> +	case DA9150_CORE_DATA_A:
> +	case DA9150_CORE_DATA_B:
> +	case DA9150_CORE_DATA_C:
> +	case DA9150_CORE_DATA_D:
> +	case DA9150_CORE2WIRE_STAT_A:
> +	case DA9150_FW_CTRL_C:
> +	case DA9150_FG_CTRL_B:
> +	case DA9150_FW_CTRL_B:
> +	case DA9150_GPADC_CMAN:
> +	case DA9150_GPADC_CRES_A:
> +	case DA9150_GPADC_CRES_B:
> +	case DA9150_CC_ICHG_RES_A:
> +	case DA9150_CC_ICHG_RES_B:
> +	case DA9150_CC_IAVG_RES_A:
> +	case DA9150_CC_IAVG_RES_B:
> +	case DA9150_TAUX_CTRL_A:
> +	case DA9150_TAUX_VALUE_H:
> +	case DA9150_TAUX_VALUE_L:
> +	case DA9150_TBAT_RES_A:
> +	case DA9150_TBAT_RES_B:
> +		return true;
> +	default:
> +		return false;
> +	}
> +}
> +
> +static const struct regmap_range_cfg da9150_range_cfg[] = {
> +	{
> +		.range_min = DA9150_PAGE_CON,
> +		.range_max = DA9150_TBAT_RES_B,
> +		.selector_reg = DA9150_PAGE_CON,
> +		.selector_mask = DA9150_I2C_PAGE_MASK,
> +		.selector_shift = DA9150_I2C_PAGE_SHIFT,
> +		.window_start = 0,
> +		.window_len = 256,
> +	},
> +};
> +
> +static struct regmap_config da9150_regmap_config = {
> +	.reg_bits = 8,
> +	.val_bits = 8,
> +	.ranges = da9150_range_cfg,
> +	.num_ranges = ARRAY_SIZE(da9150_range_cfg),
> +	.max_register = DA9150_TBAT_RES_B,
> +
> +	.cache_type = REGCACHE_RBTREE,
> +
> +	.volatile_reg = da9150_volatile_reg,
> +};
> +
> +u8 da9150_reg_read(struct da9150 *da9150, u16 reg)
> +{
> +	int val, ret;
> +
> +	ret = regmap_read(da9150->regmap, reg, &val);
> +	if (ret)
> +		dev_err(da9150->dev, "Failed to read from reg 0x%x: %d\n",
> +			reg, ret);
> +
> +	return (u8) val;
> +}
> +EXPORT_SYMBOL_GPL(da9150_reg_read);
> +
> +void da9150_reg_write(struct da9150 *da9150, u16 reg, u8 val)
> +{
> +	int ret;
> +
> +	ret = regmap_write(da9150->regmap, reg, val);
> +	if (ret)
> +		dev_err(da9150->dev, "Failed to write to reg 0x%x: %d\n",
> +			reg, ret);
> +}
> +EXPORT_SYMBOL_GPL(da9150_reg_write);
> +
> +void da9150_set_bits(struct da9150 *da9150, u16 reg, u8 mask, u8 val)
> +{
> +	int ret;
> +
> +	ret = regmap_update_bits(da9150->regmap, reg, mask, val);
> +	if (ret)
> +		dev_err(da9150->dev, "Failed to set bits in reg 0x%x: %d\n",
> +			reg, ret);
> +}
> +EXPORT_SYMBOL_GPL(da9150_set_bits);
> +
> +void da9150_bulk_read(struct da9150 *da9150, u16 reg, int count, u8 *buf)
> +{
> +	int ret;
> +
> +	ret = regmap_bulk_read(da9150->regmap, reg, buf, count);
> +	if (ret)
> +		dev_err(da9150->dev, "Failed to bulk read from reg 0x%x: %d\n",
> +			reg, ret);
> +}
> +EXPORT_SYMBOL_GPL(da9150_bulk_read);
> +
> +void da9150_bulk_write(struct da9150 *da9150, u16 reg, int count, const u8 *buf)
> +{
> +	int ret;
> +
> +	ret = regmap_raw_write(da9150->regmap, reg, buf, count);
> +	if (ret)
> +		dev_err(da9150->dev, "Failed to bulk write to reg 0x%x %d\n",
> +			reg, ret);
> +}
> +EXPORT_SYMBOL_GPL(da9150_bulk_write);
> +
> +static struct regmap_irq da9150_irqs[] = {
> +	[DA9150_IRQ_VBUS] = {
> +		.reg_offset = 0,
> +		.mask = DA9150_E_VBUS_MASK,
> +	},
> +	[DA9150_IRQ_CHG] = {
> +		.reg_offset = 0,
> +		.mask = DA9150_E_CHG_MASK,
> +	},
> +	[DA9150_IRQ_TCLASS] = {
> +		.reg_offset = 0,
> +		.mask = DA9150_E_TCLASS_MASK,
> +	},
> +	[DA9150_IRQ_TJUNC] = {
> +		.reg_offset = 0,
> +		.mask = DA9150_E_TJUNC_MASK,
> +	},
> +	[DA9150_IRQ_VFAULT] = {
> +		.reg_offset = 0,
> +		.mask = DA9150_E_VFAULT_MASK,
> +	},
> +	[DA9150_IRQ_CONF] = {
> +		.reg_offset = 1,
> +		.mask = DA9150_E_CONF_MASK,
> +	},
> +	[DA9150_IRQ_DAT] = {
> +		.reg_offset = 1,
> +		.mask = DA9150_E_DAT_MASK,
> +	},
> +	[DA9150_IRQ_DTYPE] = {
> +		.reg_offset = 1,
> +		.mask = DA9150_E_DTYPE_MASK,
> +	},
> +	[DA9150_IRQ_ID] = {
> +		.reg_offset = 1,
> +		.mask = DA9150_E_ID_MASK,
> +	},
> +	[DA9150_IRQ_ADP] = {
> +		.reg_offset = 1,
> +		.mask = DA9150_E_ADP_MASK,
> +	},
> +	[DA9150_IRQ_SESS_END] = {
> +		.reg_offset = 1,
> +		.mask = DA9150_E_SESS_END_MASK,
> +	},
> +	[DA9150_IRQ_SESS_VLD] = {
> +		.reg_offset = 1,
> +		.mask = DA9150_E_SESS_VLD_MASK,
> +	},
> +	[DA9150_IRQ_FG] = {
> +		.reg_offset = 2,
> +		.mask = DA9150_E_FG_MASK,
> +	},
> +	[DA9150_IRQ_GP] = {
> +		.reg_offset = 2,
> +		.mask = DA9150_E_GP_MASK,
> +	},
> +	[DA9150_IRQ_TBAT] = {
> +		.reg_offset = 2,
> +		.mask = DA9150_E_TBAT_MASK,
> +	},
> +	[DA9150_IRQ_GPIOA] = {
> +		.reg_offset = 2,
> +		.mask = DA9150_E_GPIOA_MASK,
> +	},
> +	[DA9150_IRQ_GPIOB] = {
> +		.reg_offset = 2,
> +		.mask = DA9150_E_GPIOB_MASK,
> +	},
> +	[DA9150_IRQ_GPIOC] = {
> +		.reg_offset = 2,
> +		.mask = DA9150_E_GPIOC_MASK,
> +	},
> +	[DA9150_IRQ_GPIOD] = {
> +		.reg_offset = 2,
> +		.mask = DA9150_E_GPIOD_MASK,
> +	},
> +	[DA9150_IRQ_GPADC] = {
> +		.reg_offset = 2,
> +		.mask = DA9150_E_GPADC_MASK,
> +	},
> +	[DA9150_IRQ_WKUP] = {
> +		.reg_offset = 3,
> +		.mask = DA9150_E_WKUP_MASK,
> +	},
> +};
> +
> +static struct regmap_irq_chip da9150_regmap_irq_chip = {
> +	.name = "da9150_irq",
> +	.status_base = DA9150_EVENT_E,
> +	.mask_base = DA9150_IRQ_MASK_E,
> +	.ack_base = DA9150_EVENT_E,
> +	.num_regs = DA9150_NUM_IRQ_REGS,
> +	.irqs = da9150_irqs,
> +	.num_irqs = ARRAY_SIZE(da9150_irqs),
> +};
> +
> +static struct resource da9150_gpadc_resources[] = {
> +	{
> +		.name = "GPADC",
> +		.start = DA9150_IRQ_GPADC,
> +		.end = DA9150_IRQ_GPADC,
> +		.flags = IORESOURCE_IRQ,
> +	},
> +};
> +
> +static struct resource da9150_charger_resources[] = {
> +	{
> +		.name = "CHG_STATUS",
> +		.start = DA9150_IRQ_CHG,
> +		.end = DA9150_IRQ_CHG,
> +		.flags = IORESOURCE_IRQ,
> +	},
> +	{
> +		.name = "CHG_TJUNC",
> +		.start = DA9150_IRQ_TJUNC,
> +		.end = DA9150_IRQ_TJUNC,
> +		.flags = IORESOURCE_IRQ,
> +	},
> +	{
> +		.name = "CHG_VFAULT",
> +		.start = DA9150_IRQ_VFAULT,
> +		.end = DA9150_IRQ_VFAULT,
> +		.flags = IORESOURCE_IRQ,
> +	},
> +	{
> +		.name = "CHG_VBUS",
> +		.start = DA9150_IRQ_VBUS,
> +		.end = DA9150_IRQ_VBUS,
> +		.flags = IORESOURCE_IRQ,
> +	},
> +};
> +
> +static struct mfd_cell da9150_devs[] = {
> +	{
> +		.name = "da9150-gpadc",
> +		.of_compatible = "dlg,da9150-gpadc",
> +		.resources = da9150_gpadc_resources,
> +		.num_resources = ARRAY_SIZE(da9150_gpadc_resources),
> +	},
> +	{
> +		.name = "da9150-charger",
> +		.of_compatible = "dlg,da9150-charger",
> +		.resources = da9150_charger_resources,
> +		.num_resources = ARRAY_SIZE(da9150_charger_resources),
> +	},
> +};
> +
> +static int da9150_probe(struct i2c_client *client,
> +			const struct i2c_device_id *id)
> +{
> +	struct da9150 *da9150;
> +	struct da9150_pdata *pdata = dev_get_platdata(&client->dev);
> +	int ret;
> +
> +	da9150 = devm_kzalloc(&client->dev, sizeof(*da9150), GFP_KERNEL);
> +	if (!da9150)
> +		return -ENOMEM;
> +
> +	da9150->dev = &client->dev;
> +	da9150->irq = client->irq;
> +	i2c_set_clientdata(client, da9150);
> +
> +	da9150->regmap = devm_regmap_init_i2c(client, &da9150_regmap_config);
> +	if (IS_ERR(da9150->regmap)) {
> +		ret = PTR_ERR(da9150->regmap);
> +		dev_err(da9150->dev, "Failed to allocate register map: %d\n",
> +			ret);
> +		return ret;
> +	}
> +
> +	da9150->irq_base = pdata ? pdata->irq_base : -1;
> +
> +	ret = regmap_add_irq_chip(da9150->regmap, da9150->irq,
> +				  IRQF_TRIGGER_LOW | IRQF_ONESHOT,
> +				  da9150->irq_base, &da9150_regmap_irq_chip,
> +				  &da9150->regmap_irq_data);
> +	if (ret)
> +		return ret;
> +
> +	da9150->irq_base = regmap_irq_chip_get_base(da9150->regmap_irq_data);
> +	enable_irq_wake(da9150->irq);
> +
> +	ret = mfd_add_devices(da9150->dev, -1, da9150_devs,
> +			      ARRAY_SIZE(da9150_devs), NULL,
> +			      da9150->irq_base, NULL);
> +	if (ret) {
> +		dev_err(da9150->dev, "Failed to add child devices: %d\n", ret);
> +		regmap_del_irq_chip(da9150->irq, da9150->regmap_irq_data);
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +static int da9150_remove(struct i2c_client *client)
> +{
> +	struct da9150 *da9150 = i2c_get_clientdata(client);
> +
> +	regmap_del_irq_chip(da9150->irq, da9150->regmap_irq_data);
> +	mfd_remove_devices(da9150->dev);
> +
> +	return 0;
> +}
> +
> +static void da9150_shutdown(struct i2c_client *client)
> +{
> +	struct da9150 *da9150 = i2c_get_clientdata(client);
> +
> +	/* Make sure we have a wakup source for the device */
> +	da9150_set_bits(da9150, DA9150_CONFIG_D,
> +			DA9150_WKUP_PM_EN_MASK,
> +			DA9150_WKUP_PM_EN_MASK);
> +
> +	/* Set device to DISABLED mode */
> +	da9150_set_bits(da9150, DA9150_CONTROL_C,
> +			DA9150_DISABLE_MASK, DA9150_DISABLE_MASK);
> +}
> +
> +static const struct i2c_device_id da9150_i2c_id[] = {
> +	{ "da9150", },
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(i2c, da9150_i2c_id);
> +
> +static const struct of_device_id da9150_of_match[] = {
> +	{ .compatible = "dlg,da9150", },
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(of, da9150_of_match);
> +
> +static struct i2c_driver da9150_driver = {
> +	.driver	= {
> +		.name	= "da9150",
> +		.of_match_table = of_match_ptr(da9150_of_match),
> +	},
> +	.probe		= da9150_probe,
> +	.remove		= da9150_remove,
> +	.shutdown	= da9150_shutdown,
> +	.id_table	= da9150_i2c_id,
> +};
> +
> +module_i2c_driver(da9150_driver);
> +
> +MODULE_DESCRIPTION("MFD Core Driver for DA9150");
> +MODULE_AUTHOR("Adam Thomson <Adam.Thomson.Opensource-WBD+wuPFNBhBDgjK7y7TUQ@public.gmane.org");
> +MODULE_LICENSE("GPL");
> diff --git a/include/linux/mfd/da9150/core.h b/include/linux/mfd/da9150/core.h
> new file mode 100644
> index 0000000..76e6689
> --- /dev/null
> +++ b/include/linux/mfd/da9150/core.h
> @@ -0,0 +1,68 @@
> +/*
> + * DA9150 MFD Driver - Core Data
> + *
> + * Copyright (c) 2014 Dialog Semiconductor
> + *
> + * Author: Adam Thomson <Adam.Thomson.Opensource-WBD+wuPFNBhBDgjK7y7TUQ@public.gmane.org>
> + *
> + * This program is free software; you can redistribute  it and/or modify it
> + * under  the terms of  the GNU General  Public License as published by the
> + * Free Software Foundation;  either version 2 of the  License, or (at your
> + * option) any later version.
> + */
> +
> +#ifndef __DA9150_CORE_H
> +#define __DA9150_CORE_H
> +
> +#include <linux/device.h>
> +#include <linux/interrupt.h>
> +#include <linux/regmap.h>
> +
> +/* I2C address paging */
> +#define DA9150_REG_PAGE_SHIFT	8
> +#define DA9150_REG_PAGE_MASK	0xFF
> +
> +/* IRQs */
> +#define DA9150_NUM_IRQ_REGS	4
> +#define DA9150_IRQ_VBUS		0
> +#define DA9150_IRQ_CHG		1
> +#define DA9150_IRQ_TCLASS	2
> +#define DA9150_IRQ_TJUNC	3
> +#define DA9150_IRQ_VFAULT	4
> +#define DA9150_IRQ_CONF		5
> +#define DA9150_IRQ_DAT		6
> +#define DA9150_IRQ_DTYPE	7
> +#define DA9150_IRQ_ID		8
> +#define DA9150_IRQ_ADP		9
> +#define DA9150_IRQ_SESS_END	10
> +#define DA9150_IRQ_SESS_VLD	11
> +#define DA9150_IRQ_FG		12
> +#define DA9150_IRQ_GP		13
> +#define DA9150_IRQ_TBAT		14
> +#define DA9150_IRQ_GPIOA	15
> +#define DA9150_IRQ_GPIOB	16
> +#define DA9150_IRQ_GPIOC	17
> +#define DA9150_IRQ_GPIOD	18
> +#define DA9150_IRQ_GPADC	19
> +#define DA9150_IRQ_WKUP		20
> +
> +struct da9150_pdata {
> +	int irq_base;
> +};
> +
> +struct da9150 {
> +	struct device *dev;
> +	struct regmap *regmap;
> +	struct regmap_irq_chip_data *regmap_irq_data;
> +	int irq;
> +	int irq_base;
> +};
> +
> +/* Device I/O */
> +u8 da9150_reg_read(struct da9150 *da9150, u16 reg);
> +void da9150_reg_write(struct da9150 *da9150, u16 reg, u8 val);
> +void da9150_set_bits(struct da9150 *da9150, u16 reg, u8 mask, u8 val);
> +
> +void da9150_bulk_read(struct da9150 *da9150, u16 reg, int count, u8 *buf);
> +void da9150_bulk_write(struct da9150 *da9150, u16 reg, int count, const u8 *buf);
> +#endif /* __DA9150_CORE_H */
> diff --git a/include/linux/mfd/da9150/registers.h b/include/linux/mfd/da9150/registers.h
> new file mode 100644
> index 0000000..27ca6ee
> --- /dev/null
> +++ b/include/linux/mfd/da9150/registers.h
> @@ -0,0 +1,1155 @@
> +/*
> + * DA9150 MFD Driver - Registers
> + *
> + * Copyright (c) 2014 Dialog Semiconductor
> + *
> + * Author: Adam Thomson <Adam.Thomson.Opensource-WBD+wuPFNBhBDgjK7y7TUQ@public.gmane.org>
> + *
> + * This program is free software; you can redistribute  it and/or modify it
> + * under  the terms of  the GNU General  Public License as published by the
> + * Free Software Foundation;  either version 2 of the  License, or (at your
> + * option) any later version.
> + */
> +
> +#ifndef __DA9150_REGISTERS_H
> +#define __DA9150_REGISTERS_H
> +
> +#include <linux/bitops.h>
> +
> +/* Registers */
> +#define DA9150_PAGE_CON			0x000
> +#define DA9150_STATUS_A			0x068
> +#define DA9150_STATUS_B			0x069
> +#define DA9150_STATUS_C			0x06A
> +#define DA9150_STATUS_D			0x06B
> +#define DA9150_STATUS_E			0x06C
> +#define DA9150_STATUS_F			0x06D
> +#define DA9150_STATUS_G			0x06E
> +#define DA9150_STATUS_H			0x06F
> +#define DA9150_STATUS_I			0x070
> +#define DA9150_STATUS_J			0x071
> +#define DA9150_STATUS_K			0x072
> +#define DA9150_STATUS_L			0x073
> +#define DA9150_STATUS_N			0x074
> +#define DA9150_FAULT_LOG_A		0x076
> +#define DA9150_FAULT_LOG_B		0x077
> +#define DA9150_EVENT_E			0x078
> +#define DA9150_EVENT_F			0x079
> +#define DA9150_EVENT_G			0x07A
> +#define DA9150_EVENT_H			0x07B
> +#define DA9150_IRQ_MASK_E		0x07C
> +#define DA9150_IRQ_MASK_F		0x07D
> +#define DA9150_IRQ_MASK_G		0x07E
> +#define DA9150_IRQ_MASK_H		0x07F
> +#define DA9150_PAGE_CON_1		0x080
> +#define DA9150_CONFIG_A			0x0E0
> +#define DA9150_CONFIG_B			0x0E1
> +#define DA9150_CONFIG_C			0x0E2
> +#define DA9150_CONFIG_D			0x0E3
> +#define DA9150_CONFIG_E			0x0E4
> +#define DA9150_CONTROL_A		0x0E5
> +#define DA9150_CONTROL_B		0x0E6
> +#define DA9150_CONTROL_C		0x0E7
> +#define DA9150_GPIO_A_B			0x0E8
> +#define DA9150_GPIO_C_D			0x0E9
> +#define DA9150_GPIO_MODE_CONT		0x0EA
> +#define DA9150_GPIO_CTRL_B		0x0EB
> +#define DA9150_GPIO_CTRL_A		0x0EC
> +#define DA9150_GPIO_CTRL_C		0x0ED
> +#define DA9150_GPIO_CFG_A		0x0EE
> +#define DA9150_GPIO_CFG_B		0x0EF
> +#define DA9150_GPIO_CFG_C		0x0F0
> +#define DA9150_GPADC_MAN		0x0F2
> +#define DA9150_GPADC_RES_A		0x0F4
> +#define DA9150_GPADC_RES_B		0x0F5
> +#define DA9150_PAGE_CON_2		0x100
> +#define DA9150_OTP_CONT_SHARED		0x101
> +#define DA9150_INTERFACE_SHARED		0x105
> +#define DA9150_CONFIG_A_SHARED		0x106
> +#define DA9150_CONFIG_D_SHARED		0x109
> +#define DA9150_ADETVB_CFG_C		0x150
> +#define DA9150_ADETD_STAT		0x151
> +#define DA9150_ADET_CMPSTAT		0x152
> +#define DA9150_ADET_CTRL_A		0x153
> +#define DA9150_ADETVB_CFG_B		0x154
> +#define DA9150_ADETVB_CFG_A		0x155
> +#define DA9150_ADETAC_CFG_A		0x156
> +#define DA9150_ADDETAC_CFG_B		0x157
> +#define DA9150_ADETAC_CFG_C		0x158
> +#define DA9150_ADETAC_CFG_D		0x159
> +#define DA9150_ADETVB_CFG_D		0x15A
> +#define DA9150_ADETID_CFG_A		0x15B
> +#define DA9150_ADET_RID_PT_CHG_H	0x15C
> +#define DA9150_ADET_RID_PT_CHG_L	0x15D
> +#define DA9150_PPR_TCTR_B		0x160
> +#define DA9150_PPR_BKCTRL_A		0x163
> +#define DA9150_PPR_BKCFG_A		0x164
> +#define DA9150_PPR_BKCFG_B		0x165
> +#define DA9150_PPR_CHGCTRL_A		0x166
> +#define DA9150_PPR_CHGCTRL_B		0x167
> +#define DA9150_PPR_CHGCTRL_C		0x168
> +#define DA9150_PPR_TCTR_A		0x169
> +#define DA9150_PPR_CHGCTRL_D		0x16A
> +#define DA9150_PPR_CHGCTRL_E		0x16B
> +#define DA9150_PPR_CHGCTRL_F		0x16C
> +#define DA9150_PPR_CHGCTRL_G		0x16D
> +#define DA9150_PPR_CHGCTRL_H		0x16E
> +#define DA9150_PPR_CHGCTRL_I		0x16F
> +#define DA9150_PPR_CHGCTRL_J		0x170
> +#define DA9150_PPR_CHGCTRL_K		0x171
> +#define DA9150_PPR_CHGCTRL_L		0x172
> +#define DA9150_PPR_CHGCTRL_M		0x173
> +#define DA9150_PPR_THYST_A		0x174
> +#define DA9150_PPR_THYST_B		0x175
> +#define DA9150_PPR_THYST_C		0x176
> +#define DA9150_PPR_THYST_D		0x177
> +#define DA9150_PPR_THYST_E		0x178
> +#define DA9150_PPR_THYST_F		0x179
> +#define DA9150_PPR_THYST_G		0x17A
> +#define DA9150_PAGE_CON_3		0x180
> +#define DA9150_PAGE_CON_4		0x200
> +#define DA9150_PAGE_CON_5		0x280
> +#define DA9150_PAGE_CON_6		0x300
> +#define DA9150_COREBTLD_STAT_A		0x302
> +#define DA9150_COREBTLD_CTRL_A		0x303
> +#define DA9150_CORE_CONFIG_A		0x304
> +#define DA9150_CORE_CONFIG_C		0x305
> +#define DA9150_CORE_CONFIG_B		0x306
> +#define DA9150_CORE_CFG_DATA_A		0x307
> +#define DA9150_CORE_CFG_DATA_B		0x308
> +#define DA9150_CORE_CMD_A		0x309
> +#define DA9150_CORE_DATA_A		0x30A
> +#define DA9150_CORE_DATA_B		0x30B
> +#define DA9150_CORE_DATA_C		0x30C
> +#define DA9150_CORE_DATA_D		0x30D
> +#define DA9150_CORE2WIRE_STAT_A		0x310
> +#define DA9150_CORE2WIRE_CTRL_A		0x311
> +#define DA9150_FW_CTRL_A		0x312
> +#define DA9150_FW_CTRL_C		0x313
> +#define DA9150_FW_CTRL_D		0x314
> +#define DA9150_FG_CTRL_A		0x315
> +#define DA9150_FG_CTRL_B		0x316
> +#define DA9150_FW_CTRL_E		0x317
> +#define DA9150_FW_CTRL_B		0x318
> +#define DA9150_GPADC_CMAN		0x320
> +#define DA9150_GPADC_CRES_A		0x322
> +#define DA9150_GPADC_CRES_B		0x323
> +#define DA9150_CC_CFG_A			0x328
> +#define DA9150_CC_CFG_B			0x329
> +#define DA9150_CC_ICHG_RES_A		0x32A
> +#define DA9150_CC_ICHG_RES_B		0x32B
> +#define DA9150_CC_IAVG_RES_A		0x32C
> +#define DA9150_CC_IAVG_RES_B		0x32D
> +#define DA9150_TAUX_CTRL_A		0x330
> +#define DA9150_TAUX_RELOAD_H		0x332
> +#define DA9150_TAUX_RELOAD_L		0x333
> +#define DA9150_TAUX_VALUE_H		0x334
> +#define DA9150_TAUX_VALUE_L		0x335
> +#define DA9150_AUX_DATA_0		0x338
> +#define DA9150_AUX_DATA_1		0x339
> +#define DA9150_AUX_DATA_2		0x33A
> +#define DA9150_AUX_DATA_3		0x33B
> +#define DA9150_BIF_CTRL			0x340
> +#define DA9150_TBAT_CTRL_A		0x342
> +#define DA9150_TBAT_CTRL_B		0x343
> +#define DA9150_TBAT_RES_A		0x344
> +#define DA9150_TBAT_RES_B		0x345
> +
> +/* DA9150_PAGE_CON = 0x000 */
> +#define DA9150_PAGE_SHIFT			0
You could drop all the shift values and compute it from the mask...
(just ffs(MASK) should work I think).
Just feels very clunky to have all the repitition we have in these
defines!

> +#define DA9150_PAGE_MASK			(0x3f << 0)
> +#define DA9150_I2C_PAGE_SHIFT			1
> +#define DA9150_I2C_PAGE_MASK			(0x1f << 1)
> +#define DA9150_WRITE_MODE_SHIFT			6
> +#define DA9150_WRITE_MODE_MASK			BIT(6)
> +#define DA9150_REVERT_SHIFT			7
> +#define DA9150_REVERT_MASK			BIT(7)
> +
> +/* DA9150_STATUS_A = 0x068 */
> +#define DA9150_WKUP_STAT_SHIFT			2
> +#define DA9150_WKUP_STAT_MASK			(0x0f << 2)
> +#define DA9150_SLEEP_STAT_SHIFT			6
> +#define DA9150_SLEEP_STAT_MASK			(0x03 << 6)
> +
> +/* DA9150_STATUS_B = 0x069 */
> +#define DA9150_VFAULT_STAT_SHIFT		0
> +#define DA9150_VFAULT_STAT_MASK			BIT(0)
> +#define DA9150_TFAULT_STAT_SHIFT		1
> +#define DA9150_TFAULT_STAT_MASK			BIT(1)
> +
> +/* DA9150_STATUS_C = 0x06A */
> +#define DA9150_VDD33_STAT_SHIFT			0
> +#define DA9150_VDD33_STAT_MASK			BIT(0)
> +#define DA9150_VDD33_SLEEP_SHIFT		1
> +#define DA9150_VDD33_SLEEP_MASK			BIT(1)
> +#define DA9150_LFOSC_STAT_SHIFT			7
> +#define DA9150_LFOSC_STAT_MASK			BIT(7)
> +
> +/* DA9150_STATUS_D = 0x06B */
> +#define DA9150_GPIOA_STAT_SHIFT			0
> +#define DA9150_GPIOA_STAT_MASK			BIT(0)
> +#define DA9150_GPIOB_STAT_SHIFT			1
> +#define DA9150_GPIOB_STAT_MASK			BIT(1)
> +#define DA9150_GPIOC_STAT_SHIFT			2
> +#define DA9150_GPIOC_STAT_MASK			BIT(2)
> +#define DA9150_GPIOD_STAT_SHIFT			3
> +#define DA9150_GPIOD_STAT_MASK			BIT(3)
> +
> +/* DA9150_STATUS_E = 0x06C */
> +#define DA9150_DTYPE_SHIFT			0
> +#define DA9150_DTYPE_MASK			(0x1f << 0)
> +#define DA9150_DTYPE_DT_NIL			(0x00 << 0)
> +#define DA9150_DTYPE_DT_USB_OTG			BIT(0)
> +#define DA9150_DTYPE_DT_USB_STD			(0x02 << 0)
> +#define DA9150_DTYPE_DT_USB_CHG			(0x03 << 0)
> +#define DA9150_DTYPE_DT_ACA_CHG			(0x04 << 0)
> +#define DA9150_DTYPE_DT_ACA_OTG			(0x05 << 0)
> +#define DA9150_DTYPE_DT_ACA_DOC			(0x06 << 0)
> +#define DA9150_DTYPE_DT_DED_CHG			(0x07 << 0)
> +#define DA9150_DTYPE_DT_CR5_CHG			(0x08 << 0)
> +#define DA9150_DTYPE_DT_CR4_CHG			(0x0c << 0)
> +#define DA9150_DTYPE_DT_PT_CHG			(0x11 << 0)
> +#define DA9150_DTYPE_DT_NN_ACC			(0x16 << 0)
> +#define DA9150_DTYPE_DT_NN_CHG			(0x17 << 0)
> +
> +/* DA9150_STATUS_F = 0x06D */
> +#define DA9150_SESS_VLD_SHIFT			0
> +#define DA9150_SESS_VLD_MASK			BIT(0)
> +#define DA9150_ID_ERR_SHIFT			1
> +#define DA9150_ID_ERR_MASK			BIT(1)
> +#define DA9150_PT_CHG_SHIFT			2
> +#define DA9150_PT_CHG_MASK			BIT(2)
> +
> +/* DA9150_STATUS_G = 0x06E */
> +#define DA9150_RID_SHIFT			0
> +#define DA9150_RID_MASK				(0xff << 0)
> +
> +/* DA9150_STATUS_H = 0x06F */
> +#define DA9150_VBUS_STAT_SHIFT			0
> +#define DA9150_VBUS_STAT_MASK			(0x07 << 0)
> +#define DA9150_VBUS_STAT_OFF			(0x00 << 0)
> +#define DA9150_VBUS_STAT_WAIT			BIT(0)
> +#define DA9150_VBUS_STAT_CHG			(0x02 << 0)
> +#define DA9150_VBUS_TRED_SHIFT			3
> +#define DA9150_VBUS_TRED_MASK			BIT(3)
> +#define DA9150_VBUS_DROP_STAT_SHIFT		4
> +#define DA9150_VBUS_DROP_STAT_MASK		(0x0f << 4)
> +
> +/* DA9150_STATUS_I = 0x070 */
> +#define DA9150_VBUS_ISET_STAT_SHIFT		0
> +#define DA9150_VBUS_ISET_STAT_MASK		(0x1f << 0)
> +#define DA9150_VBUS_OT_SHIFT			7
> +#define DA9150_VBUS_OT_MASK			BIT(7)
> +
> +/* DA9150_STATUS_J = 0x071 */
> +#define DA9150_CHG_STAT_SHIFT			0
> +#define DA9150_CHG_STAT_MASK			(0x0f << 0)
> +#define DA9150_CHG_STAT_OFF			(0x00 << 0)
> +#define DA9150_CHG_STAT_SUSP			BIT(0)
> +#define DA9150_CHG_STAT_ACT			(0x02 << 0)
> +#define DA9150_CHG_STAT_PRE			(0x03 << 0)
> +#define DA9150_CHG_STAT_CC			(0x04 << 0)
> +#define DA9150_CHG_STAT_CV			(0x05 << 0)
> +#define DA9150_CHG_STAT_FULL			(0x06 << 0)
> +#define DA9150_CHG_STAT_TEMP			(0x07 << 0)
> +#define DA9150_CHG_STAT_TIME			(0x08 << 0)
> +#define DA9150_CHG_STAT_BAT			(0x09 << 0)
> +#define DA9150_CHG_TEMP_SHIFT			4
> +#define DA9150_CHG_TEMP_MASK			(0x07 << 4)
> +#define DA9150_CHG_TEMP_UNDER			(0x06 << 4)
> +#define DA9150_CHG_TEMP_OVER			(0x07 << 4)
> +#define DA9150_CHG_IEND_STAT_SHIFT		7
> +#define DA9150_CHG_IEND_STAT_MASK		BIT(7)
> +
> +/* DA9150_STATUS_K = 0x072 */
> +#define DA9150_CHG_IAV_H_SHIFT			0
> +#define DA9150_CHG_IAV_H_MASK			(0xff << 0)
> +
> +/* DA9150_STATUS_L = 0x073 */
> +#define DA9150_CHG_IAV_L_SHIFT			5
> +#define DA9150_CHG_IAV_L_MASK			(0x07 << 5)
> +
> +/* DA9150_STATUS_N = 0x074 */
> +#define DA9150_CHG_TIME_SHIFT			1
> +#define DA9150_CHG_TIME_MASK			BIT(1)
> +#define DA9150_CHG_TRED_SHIFT			2
> +#define DA9150_CHG_TRED_MASK			BIT(2)
> +#define DA9150_CHG_TJUNC_CLASS_SHIFT		3
> +#define DA9150_CHG_TJUNC_CLASS_MASK		(0x07 << 3)
> +#define DA9150_CHG_TJUNC_CLASS_6		(0x06 << 3)
> +#define DA9150_EBS_STAT_SHIFT			6
> +#define DA9150_EBS_STAT_MASK			BIT(6)
> +#define DA9150_CHG_BAT_REMOVED_SHIFT		7
> +#define DA9150_CHG_BAT_REMOVED_MASK		BIT(7)
> +
> +/* DA9150_FAULT_LOG_A = 0x076 */
> +#define DA9150_TEMP_FAULT_SHIFT			0
> +#define DA9150_TEMP_FAULT_MASK			BIT(0)
> +#define DA9150_VSYS_FAULT_SHIFT			1
> +#define DA9150_VSYS_FAULT_MASK			BIT(1)
> +#define DA9150_START_FAULT_SHIFT		2
> +#define DA9150_START_FAULT_MASK			BIT(2)
> +#define DA9150_EXT_FAULT_SHIFT			3
> +#define DA9150_EXT_FAULT_MASK			BIT(3)
> +#define DA9150_POR_FAULT_SHIFT			4
> +#define DA9150_POR_FAULT_MASK			BIT(4)
> +
> +/* DA9150_FAULT_LOG_B = 0x077 */
> +#define DA9150_VBUS_FAULT_SHIFT			0
> +#define DA9150_VBUS_FAULT_MASK			BIT(0)
> +#define DA9150_OTG_FAULT_SHIFT			1
> +#define DA9150_OTG_FAULT_MASK			BIT(1)
> +
> +/* DA9150_EVENT_E = 0x078 */
> +#define DA9150_E_VBUS_SHIFT			0
> +#define DA9150_E_VBUS_MASK			BIT(0)
> +#define DA9150_E_CHG_SHIFT			1
> +#define DA9150_E_CHG_MASK			BIT(1)
> +#define DA9150_E_TCLASS_SHIFT			2
> +#define DA9150_E_TCLASS_MASK			BIT(2)
> +#define DA9150_E_TJUNC_SHIFT			3
> +#define DA9150_E_TJUNC_MASK			BIT(3)
> +#define DA9150_E_VFAULT_SHIFT			4
> +#define DA9150_E_VFAULT_MASK			BIT(4)
> +#define DA9150_EVENTS_H_SHIFT			5
> +#define DA9150_EVENTS_H_MASK			BIT(5)
> +#define DA9150_EVENTS_G_SHIFT			6
> +#define DA9150_EVENTS_G_MASK			BIT(6)
> +#define DA9150_EVENTS_F_SHIFT			7
> +#define DA9150_EVENTS_F_MASK			BIT(7)
> +
> +/* DA9150_EVENT_F = 0x079 */
> +#define DA9150_E_CONF_SHIFT			0
> +#define DA9150_E_CONF_MASK			BIT(0)
> +#define DA9150_E_DAT_SHIFT			1
> +#define DA9150_E_DAT_MASK			BIT(1)
> +#define DA9150_E_DTYPE_SHIFT			3
> +#define DA9150_E_DTYPE_MASK			BIT(3)
> +#define DA9150_E_ID_SHIFT			4
> +#define DA9150_E_ID_MASK			BIT(4)
> +#define DA9150_E_ADP_SHIFT			5
> +#define DA9150_E_ADP_MASK			BIT(5)
> +#define DA9150_E_SESS_END_SHIFT			6
> +#define DA9150_E_SESS_END_MASK			BIT(6)
> +#define DA9150_E_SESS_VLD_SHIFT			7
> +#define DA9150_E_SESS_VLD_MASK			BIT(7)
> +
> +/* DA9150_EVENT_G = 0x07A */
> +#define DA9150_E_FG_SHIFT			0
> +#define DA9150_E_FG_MASK			BIT(0)
> +#define DA9150_E_GP_SHIFT			1
> +#define DA9150_E_GP_MASK			BIT(1)
> +#define DA9150_E_TBAT_SHIFT			2
> +#define DA9150_E_TBAT_MASK			BIT(2)
> +#define DA9150_E_GPIOA_SHIFT			3
> +#define DA9150_E_GPIOA_MASK			BIT(3)
> +#define DA9150_E_GPIOB_SHIFT			4
> +#define DA9150_E_GPIOB_MASK			BIT(4)
> +#define DA9150_E_GPIOC_SHIFT			5
> +#define DA9150_E_GPIOC_MASK			BIT(5)
> +#define DA9150_E_GPIOD_SHIFT			6
> +#define DA9150_E_GPIOD_MASK			BIT(6)
> +#define DA9150_E_GPADC_SHIFT			7
> +#define DA9150_E_GPADC_MASK			BIT(7)
> +
> +/* DA9150_EVENT_H = 0x07B */
> +#define DA9150_E_WKUP_SHIFT			0
> +#define DA9150_E_WKUP_MASK			BIT(0)
> +
> +/* DA9150_IRQ_MASK_E = 0x07C */
> +#define DA9150_M_VBUS_SHIFT			0
> +#define DA9150_M_VBUS_MASK			BIT(0)
> +#define DA9150_M_CHG_SHIFT			1
> +#define DA9150_M_CHG_MASK			BIT(1)
> +#define DA9150_M_TJUNC_SHIFT			3
> +#define DA9150_M_TJUNC_MASK			BIT(3)
> +#define DA9150_M_VFAULT_SHIFT			4
> +#define DA9150_M_VFAULT_MASK			BIT(4)
> +
> +/* DA9150_IRQ_MASK_F = 0x07D */
> +#define DA9150_M_CONF_SHIFT			0
> +#define DA9150_M_CONF_MASK			BIT(0)
> +#define DA9150_M_DAT_SHIFT			1
> +#define DA9150_M_DAT_MASK			BIT(1)
> +#define DA9150_M_DTYPE_SHIFT			3
> +#define DA9150_M_DTYPE_MASK			BIT(3)
> +#define DA9150_M_ID_SHIFT			4
> +#define DA9150_M_ID_MASK			BIT(4)
> +#define DA9150_M_ADP_SHIFT			5
> +#define DA9150_M_ADP_MASK			BIT(5)
> +#define DA9150_M_SESS_END_SHIFT			6
> +#define DA9150_M_SESS_END_MASK			BIT(6)
> +#define DA9150_M_SESS_VLD_SHIFT			7
> +#define DA9150_M_SESS_VLD_MASK			BIT(7)
> +
> +/* DA9150_IRQ_MASK_G = 0x07E */
> +#define DA9150_M_FG_SHIFT			0
> +#define DA9150_M_FG_MASK			BIT(0)
> +#define DA9150_M_GP_SHIFT			1
> +#define DA9150_M_GP_MASK			BIT(1)
> +#define DA9150_M_TBAT_SHIFT			2
> +#define DA9150_M_TBAT_MASK			BIT(2)
> +#define DA9150_M_GPIOA_SHIFT			3
> +#define DA9150_M_GPIOA_MASK			BIT(3)
> +#define DA9150_M_GPIOB_SHIFT			4
> +#define DA9150_M_GPIOB_MASK			BIT(4)
> +#define DA9150_M_GPIOC_SHIFT			5
> +#define DA9150_M_GPIOC_MASK			BIT(5)
> +#define DA9150_M_GPIOD_SHIFT			6
> +#define DA9150_M_GPIOD_MASK			BIT(6)
> +#define DA9150_M_GPADC_SHIFT			7
> +#define DA9150_M_GPADC_MASK			BIT(7)
> +
> +/* DA9150_IRQ_MASK_H = 0x07F */
> +#define DA9150_M_WKUP_SHIFT			0
> +#define DA9150_M_WKUP_MASK			BIT(0)
> +
> +/* DA9150_PAGE_CON_1 = 0x080 */
> +#define DA9150_PAGE_SHIFT			0
> +#define DA9150_PAGE_MASK			(0x3f << 0)
> +#define DA9150_WRITE_MODE_SHIFT			6
> +#define DA9150_WRITE_MODE_MASK			BIT(6)
> +#define DA9150_REVERT_SHIFT			7
> +#define DA9150_REVERT_MASK			BIT(7)
> +
> +/* DA9150_CONFIG_A = 0x0E0 */
> +#define DA9150_RESET_DUR_SHIFT			0
> +#define DA9150_RESET_DUR_MASK			(0x03 << 0)
> +#define DA9150_RESET_EXT_SHIFT			2
> +#define DA9150_RESET_EXT_MASK			(0x03 << 2)
> +#define DA9150_START_MAX_SHIFT			4
> +#define DA9150_START_MAX_MASK			(0x03 << 4)
> +#define DA9150_PS_WAIT_EN_SHIFT			6
> +#define DA9150_PS_WAIT_EN_MASK			BIT(6)
> +#define DA9150_PS_DISABLE_DIRECT_SHIFT		7
> +#define DA9150_PS_DISABLE_DIRECT_MASK		BIT(7)
> +
> +/* DA9150_CONFIG_B = 0x0E1 */
> +#define DA9150_VFAULT_ADJ_SHIFT			0
> +#define DA9150_VFAULT_ADJ_MASK			(0x0f << 0)
> +#define DA9150_VFAULT_HYST_SHIFT		4
> +#define DA9150_VFAULT_HYST_MASK			(0x07 << 4)
> +#define DA9150_VFAULT_EN_SHIFT			7
> +#define DA9150_VFAULT_EN_MASK			BIT(7)
> +
> +/* DA9150_CONFIG_C = 0x0E2 */
> +#define DA9150_VSYS_MIN_SHIFT			3
> +#define DA9150_VSYS_MIN_MASK			(0x1f << 3)
> +
> +/* DA9150_CONFIG_D = 0x0E3 */
> +#define DA9150_LFOSC_EXT_SHIFT			0
> +#define DA9150_LFOSC_EXT_MASK			BIT(0)
> +#define DA9150_VDD33_DWN_SHIFT			1
> +#define DA9150_VDD33_DWN_MASK			BIT(1)
> +#define DA9150_WKUP_PM_EN_SHIFT			2
> +#define DA9150_WKUP_PM_EN_MASK			BIT(2)
> +#define DA9150_WKUP_CE_SEL_SHIFT		3
> +#define DA9150_WKUP_CE_SEL_MASK			(0x03 << 3)
> +#define DA9150_WKUP_CLK32K_EN_SHIFT		5
> +#define DA9150_WKUP_CLK32K_EN_MASK		BIT(5)
> +#define DA9150_DISABLE_DEL_SHIFT		7
> +#define DA9150_DISABLE_DEL_MASK			BIT(7)
> +
> +/* DA9150_CONFIG_E = 0x0E4 */
> +#define DA9150_PM_SPKSUP_DIS_SHIFT		0
> +#define DA9150_PM_SPKSUP_DIS_MASK		BIT(0)
> +#define DA9150_PM_MERGE_SHIFT			1
> +#define DA9150_PM_MERGE_MASK			BIT(1)
> +#define DA9150_PM_SR_OFF_SHIFT			2
> +#define DA9150_PM_SR_OFF_MASK			BIT(2)
> +#define DA9150_PM_TIMEOUT_EN_SHIFT		3
> +#define DA9150_PM_TIMEOUT_EN_MASK		BIT(3)
> +#define DA9150_PM_DLY_SEL_SHIFT			4
> +#define DA9150_PM_DLY_SEL_MASK			(0x07 << 4)
> +#define DA9150_PM_OUT_DLY_SEL_SHIFT		7
> +#define DA9150_PM_OUT_DLY_SEL_MASK		BIT(7)
> +
> +/* DA9150_CONTROL_A = 0x0E5 */
> +#define DA9150_VDD33_SL_SHIFT			0
> +#define DA9150_VDD33_SL_MASK			BIT(0)
> +#define DA9150_VDD33_LPM_SHIFT			1
> +#define DA9150_VDD33_LPM_MASK			(0x03 << 1)
> +#define DA9150_VDD33_EN_SHIFT			3
> +#define DA9150_VDD33_EN_MASK			BIT(3)
> +#define DA9150_GPI_LPM_SHIFT			6
> +#define DA9150_GPI_LPM_MASK			BIT(6)
> +#define DA9150_PM_IF_LPM_SHIFT			7
> +#define DA9150_PM_IF_LPM_MASK			BIT(7)
> +
> +/* DA9150_CONTROL_B = 0x0E6 */
> +#define DA9150_LPM_SHIFT			0
> +#define DA9150_LPM_MASK				BIT(0)
> +#define DA9150_RESET_SHIFT			1
> +#define DA9150_RESET_MASK			BIT(1)
> +#define DA9150_RESET_USRCONF_EN_SHIFT		2
> +#define DA9150_RESET_USRCONF_EN_MASK		BIT(2)
> +
> +/* DA9150_CONTROL_C = 0x0E7 */
> +#define DA9150_DISABLE_SHIFT			0
> +#define DA9150_DISABLE_MASK			BIT(0)
> +
> +/* DA9150_GPIO_A_B = 0x0E8 */
> +#define DA9150_GPIOA_PIN_SHIFT			0
> +#define DA9150_GPIOA_PIN_MASK			(0x07 << 0)
> +#define DA9150_GPIOA_PIN_GPI			(0x00 << 0)
> +#define DA9150_GPIOA_PIN_GPO_OD			BIT(0)
> +#define DA9150_GPIOA_TYPE_SHIFT			3
> +#define DA9150_GPIOA_TYPE_MASK			BIT(3)
> +#define DA9150_GPIOB_PIN_SHIFT			4
> +#define DA9150_GPIOB_PIN_MASK			(0x07 << 4)
> +#define DA9150_GPIOB_PIN_GPI			(0x00 << 4)
> +#define DA9150_GPIOB_PIN_GPO_OD			BIT(4)
> +#define DA9150_GPIOB_TYPE_SHIFT			7
> +#define DA9150_GPIOB_TYPE_MASK			BIT(7)
> +
> +/* DA9150_GPIO_C_D = 0x0E9 */
> +#define DA9150_GPIOC_PIN_SHIFT			0
> +#define DA9150_GPIOC_PIN_MASK			(0x07 << 0)
> +#define DA9150_GPIOC_PIN_GPI			(0x00 << 0)
> +#define DA9150_GPIOC_PIN_GPO_OD			BIT(0)
> +#define DA9150_GPIOC_TYPE_SHIFT			3
> +#define DA9150_GPIOC_TYPE_MASK			BIT(3)
> +#define DA9150_GPIOD_PIN_SHIFT			4
> +#define DA9150_GPIOD_PIN_MASK			(0x07 << 4)
> +#define DA9150_GPIOD_PIN_GPI			(0x00 << 4)
> +#define DA9150_GPIOD_PIN_GPO_OD			BIT(4)
> +#define DA9150_GPIOD_TYPE_SHIFT			7
> +#define DA9150_GPIOD_TYPE_MASK			BIT(7)
> +
> +/* DA9150_GPIO_MODE_CONT = 0x0EA */
> +#define DA9150_GPIOA_MODE_SHIFT			0
> +#define DA9150_GPIOA_MODE_MASK			BIT(0)
> +#define DA9150_GPIOB_MODE_SHIFT			1
> +#define DA9150_GPIOB_MODE_MASK			BIT(1)
> +#define DA9150_GPIOC_MODE_SHIFT			2
> +#define DA9150_GPIOC_MODE_MASK			BIT(2)
> +#define DA9150_GPIOD_MODE_SHIFT			3
> +#define DA9150_GPIOD_MODE_MASK			BIT(3)
> +#define DA9150_GPIOA_CONT_SHIFT			4
> +#define DA9150_GPIOA_CONT_MASK			BIT(4)
> +#define DA9150_GPIOB_CONT_SHIFT			5
> +#define DA9150_GPIOB_CONT_MASK			BIT(5)
> +#define DA9150_GPIOC_CONT_SHIFT			6
> +#define DA9150_GPIOC_CONT_MASK			BIT(6)
> +#define DA9150_GPIOD_CONT_SHIFT			7
> +#define DA9150_GPIOD_CONT_MASK			BIT(7)
> +
> +/* DA9150_GPIO_CTRL_B = 0x0EB */
> +#define DA9150_WAKE_PIN_SHIFT			0
> +#define DA9150_WAKE_PIN_MASK			(0x03 << 0)
> +#define DA9150_WAKE_MODE_SHIFT			2
> +#define DA9150_WAKE_MODE_MASK			BIT(2)
> +#define DA9150_WAKE_CONT_SHIFT			3
> +#define DA9150_WAKE_CONT_MASK			BIT(3)
> +#define DA9150_WAKE_DLY_SHIFT			4
> +#define DA9150_WAKE_DLY_MASK			BIT(4)
> +
> +/* DA9150_GPIO_CTRL_A = 0x0EC */
> +#define DA9150_GPIOA_ANAEN_SHIFT		0
> +#define DA9150_GPIOA_ANAEN_MASK			BIT(0)
> +#define DA9150_GPIOB_ANAEN_SHIFT		1
> +#define DA9150_GPIOB_ANAEN_MASK			BIT(1)
> +#define DA9150_GPIOC_ANAEN_SHIFT		2
> +#define DA9150_GPIOC_ANAEN_MASK			BIT(2)
> +#define DA9150_GPIOD_ANAEN_SHIFT		3
> +#define DA9150_GPIOD_ANAEN_MASK			BIT(3)
> +#define DA9150_GPIO_ANAEN			0x01
> +#define DA9150_GPIO_ANAEN_MASK			0x0F
> +#define DA9150_CHGLED_PIN_SHIFT			5
> +#define DA9150_CHGLED_PIN_MASK			(0x07 << 5)
> +
> +/* DA9150_GPIO_CTRL_C = 0x0ED */
> +#define DA9150_CHGBL_DUR_SHIFT			0
> +#define DA9150_CHGBL_DUR_MASK			(0x03 << 0)
> +#define DA9150_CHGBL_DBL_SHIFT			2
> +#define DA9150_CHGBL_DBL_MASK			BIT(2)
> +#define DA9150_CHGBL_FRQ_SHIFT			3
> +#define DA9150_CHGBL_FRQ_MASK			(0x03 << 3)
> +#define DA9150_CHGBL_FLKR_SHIFT			5
> +#define DA9150_CHGBL_FLKR_MASK			BIT(5)
> +
> +/* DA9150_GPIO_CFG_A = 0x0EE */
> +#define DA9150_CE_LPM_DEB_SHIFT			0
> +#define DA9150_CE_LPM_DEB_MASK			(0x07 << 0)
> +
> +/* DA9150_GPIO_CFG_B = 0x0EF */
> +#define DA9150_GPIOA_PUPD_SHIFT			0
> +#define DA9150_GPIOA_PUPD_MASK			BIT(0)
> +#define DA9150_GPIOB_PUPD_SHIFT			1
> +#define DA9150_GPIOB_PUPD_MASK			BIT(1)
> +#define DA9150_GPIOC_PUPD_SHIFT			2
> +#define DA9150_GPIOC_PUPD_MASK			BIT(2)
> +#define DA9150_GPIOD_PUPD_SHIFT			3
> +#define DA9150_GPIOD_PUPD_MASK			BIT(3)
> +#define DA9150_GPIO_PUPD_MASK			(0xF << 0)
> +#define DA9150_GPI_DEB_SHIFT			4
> +#define DA9150_GPI_DEB_MASK			(0x07 << 4)
> +#define DA9150_LPM_EN_SHIFT			7
> +#define DA9150_LPM_EN_MASK			BIT(7)
> +
> +/* DA9150_GPIO_CFG_C = 0x0F0 */
> +#define DA9150_GPI_V_SHIFT			0
> +#define DA9150_GPI_V_MASK			BIT(0)
> +#define DA9150_VDDIO_INT_SHIFT			1
> +#define DA9150_VDDIO_INT_MASK			BIT(1)
> +#define DA9150_FAULT_PIN_SHIFT			3
> +#define DA9150_FAULT_PIN_MASK			(0x07 << 3)
> +#define DA9150_FAULT_TYPE_SHIFT			6
> +#define DA9150_FAULT_TYPE_MASK			BIT(6)
> +#define DA9150_NIRQ_PUPD_SHIFT			7
> +#define DA9150_NIRQ_PUPD_MASK			BIT(7)
> +
> +/* DA9150_GPADC_MAN = 0x0F2 */
> +#define DA9150_GPADC_EN_SHIFT			0
> +#define DA9150_GPADC_EN_MASK			BIT(0)
> +#define DA9150_GPADC_MUX_SHIFT			1
> +#define DA9150_GPADC_MUX_MASK			(0x1f << 1)
> +
> +/* DA9150_GPADC_RES_A = 0x0F4 */
> +#define DA9150_GPADC_RES_H_SHIFT		0
> +#define DA9150_GPADC_RES_H_MASK			(0xff << 0)
> +
> +/* DA9150_GPADC_RES_B = 0x0F5 */
> +#define DA9150_GPADC_RUN_SHIFT			0
> +#define DA9150_GPADC_RUN_MASK			BIT(0)
> +#define DA9150_GPADC_RES_L_SHIFT		6
> +#define DA9150_GPADC_RES_L_MASK			(0x03 << 6)
> +#define DA9150_GPADC_RES_L_BITS			2
> +
> +/* DA9150_PAGE_CON_2 = 0x100 */
> +#define DA9150_PAGE_SHIFT			0
> +#define DA9150_PAGE_MASK			(0x3f << 0)
> +#define DA9150_WRITE_MODE_SHIFT			6
> +#define DA9150_WRITE_MODE_MASK			BIT(6)
> +#define DA9150_REVERT_SHIFT			7
> +#define DA9150_REVERT_MASK			BIT(7)
> +
> +/* DA9150_OTP_CONT_SHARED = 0x101 */
> +#define DA9150_PC_DONE_SHIFT			3
> +#define DA9150_PC_DONE_MASK			BIT(3)
> +
> +/* DA9150_INTERFACE_SHARED = 0x105 */
> +#define DA9150_IF_BASE_ADDR_SHIFT		4
> +#define DA9150_IF_BASE_ADDR_MASK		(0x0f << 4)
> +
> +/* DA9150_CONFIG_A_SHARED = 0x106 */
> +#define DA9150_NIRQ_VDD_SHIFT			1
> +#define DA9150_NIRQ_VDD_MASK			BIT(1)
> +#define DA9150_NIRQ_PIN_SHIFT			2
> +#define DA9150_NIRQ_PIN_MASK			BIT(2)
> +#define DA9150_NIRQ_TYPE_SHIFT			3
> +#define DA9150_NIRQ_TYPE_MASK			BIT(3)
> +#define DA9150_PM_IF_V_SHIFT			4
> +#define DA9150_PM_IF_V_MASK			BIT(4)
> +#define DA9150_PM_IF_FMP_SHIFT			5
> +#define DA9150_PM_IF_FMP_MASK			BIT(5)
> +#define DA9150_PM_IF_HSM_SHIFT			6
> +#define DA9150_PM_IF_HSM_MASK			BIT(6)
> +
> +/* DA9150_CONFIG_D_SHARED = 0x109 */
> +#define DA9150_NIRQ_MODE_SHIFT			1
> +#define DA9150_NIRQ_MODE_MASK			BIT(1)
> +
> +/* DA9150_ADETVB_CFG_C = 0x150 */
> +#define DA9150_TADP_RISE_SHIFT			0
> +#define DA9150_TADP_RISE_MASK			(0xff << 0)
> +
> +/* DA9150_ADETD_STAT = 0x151 */
> +#define DA9150_DCD_STAT_SHIFT			0
> +#define DA9150_DCD_STAT_MASK			BIT(0)
> +#define DA9150_PCD_STAT_SHIFT			1
> +#define DA9150_PCD_STAT_MASK			(0x03 << 1)
> +#define DA9150_SCD_STAT_SHIFT			3
> +#define DA9150_SCD_STAT_MASK			(0x03 << 3)
> +#define DA9150_DP_STAT_SHIFT			5
> +#define DA9150_DP_STAT_MASK			BIT(5)
> +#define DA9150_DM_STAT_SHIFT			6
> +#define DA9150_DM_STAT_MASK			BIT(6)
> +
> +/* DA9150_ADET_CMPSTAT = 0x152 */
> +#define DA9150_DP_COMP_SHIFT			1
> +#define DA9150_DP_COMP_MASK			BIT(1)
> +#define DA9150_DM_COMP_SHIFT			2
> +#define DA9150_DM_COMP_MASK			BIT(2)
> +#define DA9150_ADP_SNS_COMP_SHIFT		3
> +#define DA9150_ADP_SNS_COMP_MASK		BIT(3)
> +#define DA9150_ADP_PRB_COMP_SHIFT		4
> +#define DA9150_ADP_PRB_COMP_MASK		BIT(4)
> +#define DA9150_ID_COMP_SHIFT			5
> +#define DA9150_ID_COMP_MASK			BIT(5)
> +
> +/* DA9150_ADET_CTRL_A = 0x153 */
> +#define DA9150_AID_DAT_SHIFT			0
> +#define DA9150_AID_DAT_MASK			BIT(0)
> +#define DA9150_AID_ID_SHIFT			1
> +#define DA9150_AID_ID_MASK			BIT(1)
> +#define DA9150_AID_TRIG_SHIFT			2
> +#define DA9150_AID_TRIG_MASK			BIT(2)
> +
> +/* DA9150_ADETVB_CFG_B = 0x154 */
> +#define DA9150_VB_MODE_SHIFT			0
> +#define DA9150_VB_MODE_MASK			(0x03 << 0)
> +#define DA9150_VB_MODE_VB_SESS			BIT(0)
> +
> +#define DA9150_TADP_PRB_SHIFT			2
> +#define DA9150_TADP_PRB_MASK			BIT(2)
> +#define DA9150_DAT_RPD_EXT_SHIFT		5
> +#define DA9150_DAT_RPD_EXT_MASK			BIT(5)
> +#define DA9150_CONF_RPD_SHIFT			6
> +#define DA9150_CONF_RPD_MASK			BIT(6)
> +#define DA9150_CONF_SRP_SHIFT			7
> +#define DA9150_CONF_SRP_MASK			BIT(7)
> +
> +/* DA9150_ADETVB_CFG_A = 0x155 */
> +#define DA9150_AID_MODE_SHIFT			0
> +#define DA9150_AID_MODE_MASK			(0x03 << 0)
> +#define DA9150_AID_EXT_POL_SHIFT		2
> +#define DA9150_AID_EXT_POL_MASK			BIT(2)
> +
> +/* DA9150_ADETAC_CFG_A = 0x156 */
> +#define DA9150_ISET_CDP_SHIFT			0
> +#define DA9150_ISET_CDP_MASK			(0x1f << 0)
> +#define DA9150_CONF_DBP_SHIFT			5
> +#define DA9150_CONF_DBP_MASK			BIT(5)
> +
> +/* DA9150_ADDETAC_CFG_B = 0x157 */
> +#define DA9150_ISET_DCHG_SHIFT			0
> +#define DA9150_ISET_DCHG_MASK			(0x1f << 0)
> +#define DA9150_CONF_GPIOA_SHIFT			5
> +#define DA9150_CONF_GPIOA_MASK			BIT(5)
> +#define DA9150_CONF_GPIOB_SHIFT			6
> +#define DA9150_CONF_GPIOB_MASK			BIT(6)
> +#define DA9150_AID_VB_SHIFT			7
> +#define DA9150_AID_VB_MASK			BIT(7)
> +
> +/* DA9150_ADETAC_CFG_C = 0x158 */
> +#define DA9150_ISET_DEF_SHIFT			0
> +#define DA9150_ISET_DEF_MASK			(0x1f << 0)
> +#define DA9150_CONF_MODE_SHIFT			5
> +#define DA9150_CONF_MODE_MASK			(0x03 << 5)
> +#define DA9150_AID_CR_DIS_SHIFT			7
> +#define DA9150_AID_CR_DIS_MASK			BIT(7)
> +
> +/* DA9150_ADETAC_CFG_D = 0x159 */
> +#define DA9150_ISET_UNIT_SHIFT			0
> +#define DA9150_ISET_UNIT_MASK			(0x1f << 0)
> +#define DA9150_AID_UNCLAMP_SHIFT		5
> +#define DA9150_AID_UNCLAMP_MASK			BIT(5)
> +
> +/* DA9150_ADETVB_CFG_D = 0x15A */
> +#define DA9150_ID_MODE_SHIFT			0
> +#define DA9150_ID_MODE_MASK			(0x03 << 0)
> +#define DA9150_DAT_MODE_SHIFT			2
> +#define DA9150_DAT_MODE_MASK			(0x0f << 2)
> +#define DA9150_DAT_SWP_SHIFT			6
> +#define DA9150_DAT_SWP_MASK			BIT(6)
> +#define DA9150_DAT_CLAMP_EXT_SHIFT		7
> +#define DA9150_DAT_CLAMP_EXT_MASK		BIT(7)
> +
> +/* DA9150_ADETID_CFG_A = 0x15B */
> +#define DA9150_TID_POLL_SHIFT			0
> +#define DA9150_TID_POLL_MASK			(0x07 << 0)
> +#define DA9150_RID_CONV_SHIFT			3
> +#define DA9150_RID_CONV_MASK			BIT(3)
> +
> +/* DA9150_ADET_RID_PT_CHG_H = 0x15C */
> +#define DA9150_RID_PT_CHG_H_SHIFT		0
> +#define DA9150_RID_PT_CHG_H_MASK		(0xff << 0)
> +
> +/* DA9150_ADET_RID_PT_CHG_L = 0x15D */
> +#define DA9150_RID_PT_CHG_L_SHIFT		6
> +#define DA9150_RID_PT_CHG_L_MASK		(0x03 << 6)
> +
> +/* DA9150_PPR_TCTR_B = 0x160 */
> +#define DA9150_CHG_TCTR_VAL_SHIFT		0
> +#define DA9150_CHG_TCTR_VAL_MASK		(0xff << 0)
> +
> +/* DA9150_PPR_BKCTRL_A = 0x163 */
> +#define DA9150_VBUS_MODE_SHIFT			0
> +#define DA9150_VBUS_MODE_MASK			(0x03 << 0)
> +#define DA9150_VBUS_MODE_CHG			BIT(0)
> +#define DA9150_VBUS_MODE_OTG			(0x02 << 0)
> +#define DA9150_VBUS_LPM_SHIFT			2
> +#define DA9150_VBUS_LPM_MASK			(0x03 << 2)
> +#define DA9150_VBUS_SUSP_SHIFT			4
> +#define DA9150_VBUS_SUSP_MASK			BIT(4)
> +#define DA9150_VBUS_PWM_SHIFT			5
> +#define DA9150_VBUS_PWM_MASK			BIT(5)
> +#define DA9150_VBUS_ISO_SHIFT			6
> +#define DA9150_VBUS_ISO_MASK			BIT(6)
> +#define DA9150_VBUS_LDO_SHIFT			7
> +#define DA9150_VBUS_LDO_MASK			BIT(7)
> +
> +/* DA9150_PPR_BKCFG_A = 0x164 */
> +#define DA9150_VBUS_ISET_SHIFT			0
> +#define DA9150_VBUS_ISET_MASK			(0x1f << 0)
> +#define DA9150_VBUS_IMAX_SHIFT			5
> +#define DA9150_VBUS_IMAX_MASK			BIT(5)
> +#define DA9150_VBUS_IOTG_SHIFT			6
> +#define DA9150_VBUS_IOTG_MASK			(0x03 << 6)
> +
> +/* DA9150_PPR_BKCFG_B = 0x165 */
> +#define DA9150_VBUS_DROP_SHIFT			0
> +#define DA9150_VBUS_DROP_MASK			(0x0f << 0)
> +#define DA9150_VBUS_FAULT_DIS_SHIFT		6
> +#define DA9150_VBUS_FAULT_DIS_MASK		BIT(6)
> +#define DA9150_OTG_FAULT_DIS_SHIFT		7
> +#define DA9150_OTG_FAULT_DIS_MASK		BIT(7)
> +
> +/* DA9150_PPR_CHGCTRL_A = 0x166 */
> +#define DA9150_CHG_EN_SHIFT			0
> +#define DA9150_CHG_EN_MASK			BIT(0)
> +
> +/* DA9150_PPR_CHGCTRL_B = 0x167 */
> +#define DA9150_CHG_VBAT_SHIFT			0
> +#define DA9150_CHG_VBAT_MASK			(0x1f << 0)
> +#define DA9150_CHG_VDROP_SHIFT			6
> +#define DA9150_CHG_VDROP_MASK			(0x03 << 6)
> +
> +/* DA9150_PPR_CHGCTRL_C = 0x168 */
> +#define DA9150_CHG_VFAULT_SHIFT			0
> +#define DA9150_CHG_VFAULT_MASK			(0x0f << 0)
> +#define DA9150_CHG_IPRE_SHIFT			4
> +#define DA9150_CHG_IPRE_MASK			(0x03 << 4)
> +
> +/* DA9150_PPR_TCTR_A = 0x169 */
> +#define DA9150_CHG_TCTR_SHIFT			0
> +#define DA9150_CHG_TCTR_MASK			(0x07 << 0)
> +#define DA9150_CHG_TCTR_MODE_SHIFT		4
> +#define DA9150_CHG_TCTR_MODE_MASK		BIT(4)
> +
> +/* DA9150_PPR_CHGCTRL_D = 0x16A */
> +#define DA9150_CHG_IBAT_SHIFT			0
> +#define DA9150_CHG_IBAT_MASK			(0xff << 0)
> +
> +/* DA9150_PPR_CHGCTRL_E = 0x16B */
> +#define DA9150_CHG_IEND_SHIFT			0
> +#define DA9150_CHG_IEND_MASK			(0xff << 0)
> +
> +/* DA9150_PPR_CHGCTRL_F = 0x16C */
> +#define DA9150_CHG_VCOLD_SHIFT			0
> +#define DA9150_CHG_VCOLD_MASK			(0x1f << 0)
> +#define DA9150_TBAT_TQA_EN_SHIFT		6
> +#define DA9150_TBAT_TQA_EN_MASK			BIT(6)
> +#define DA9150_TBAT_TDP_EN_SHIFT		7
> +#define DA9150_TBAT_TDP_EN_MASK			BIT(7)
> +
> +/* DA9150_PPR_CHGCTRL_G = 0x16D */
> +#define DA9150_CHG_VWARM_SHIFT			0
> +#define DA9150_CHG_VWARM_MASK			(0x1f << 0)
> +
> +/* DA9150_PPR_CHGCTRL_H = 0x16E */
> +#define DA9150_CHG_VHOT_SHIFT			0
> +#define DA9150_CHG_VHOT_MASK			(0x1f << 0)
> +
> +/* DA9150_PPR_CHGCTRL_I = 0x16F */
> +#define DA9150_CHG_ICOLD_SHIFT			0
> +#define DA9150_CHG_ICOLD_MASK			(0xff << 0)
> +
> +/* DA9150_PPR_CHGCTRL_J = 0x170 */
> +#define DA9150_CHG_IWARM_SHIFT			0
> +#define DA9150_CHG_IWARM_MASK			(0xff << 0)
> +
> +/* DA9150_PPR_CHGCTRL_K = 0x171 */
> +#define DA9150_CHG_IHOT_SHIFT			0
> +#define DA9150_CHG_IHOT_MASK			(0xff << 0)
> +
> +/* DA9150_PPR_CHGCTRL_L = 0x172 */
> +#define DA9150_CHG_IBAT_TRED_SHIFT		0
> +#define DA9150_CHG_IBAT_TRED_MASK		(0xff << 0)
> +
> +/* DA9150_PPR_CHGCTRL_M = 0x173 */
> +#define DA9150_CHG_VFLOAT_SHIFT			0
> +#define DA9150_CHG_VFLOAT_MASK			(0x0f << 0)
> +#define DA9150_CHG_LPM_SHIFT			5
> +#define DA9150_CHG_LPM_MASK			BIT(5)
> +#define DA9150_CHG_NBLO_SHIFT			6
> +#define DA9150_CHG_NBLO_MASK			BIT(6)
> +#define DA9150_EBS_EN_SHIFT			7
> +#define DA9150_EBS_EN_MASK			BIT(7)
> +
> +/* DA9150_PPR_THYST_A = 0x174 */
> +#define DA9150_TBAT_T1_SHIFT			0
> +#define DA9150_TBAT_T1_MASK			(0xff << 0)
> +
> +/* DA9150_PPR_THYST_B = 0x175 */
> +#define DA9150_TBAT_T2_SHIFT			0
> +#define DA9150_TBAT_T2_MASK			(0xff << 0)
> +
> +/* DA9150_PPR_THYST_C = 0x176 */
> +#define DA9150_TBAT_T3_SHIFT			0
> +#define DA9150_TBAT_T3_MASK			(0xff << 0)
> +
> +/* DA9150_PPR_THYST_D = 0x177 */
> +#define DA9150_TBAT_T4_SHIFT			0
> +#define DA9150_TBAT_T4_MASK			(0xff << 0)
> +
> +/* DA9150_PPR_THYST_E = 0x178 */
> +#define DA9150_TBAT_T5_SHIFT			0
> +#define DA9150_TBAT_T5_MASK			(0xff << 0)
> +
> +/* DA9150_PPR_THYST_F = 0x179 */
> +#define DA9150_TBAT_H1_SHIFT			0
> +#define DA9150_TBAT_H1_MASK			(0xff << 0)
> +
> +/* DA9150_PPR_THYST_G = 0x17A */
> +#define DA9150_TBAT_H5_SHIFT			0
> +#define DA9150_TBAT_H5_MASK			(0xff << 0)
> +
> +/* DA9150_PAGE_CON_3 = 0x180 */
> +#define DA9150_PAGE_SHIFT			0
> +#define DA9150_PAGE_MASK			(0x3f << 0)
> +#define DA9150_WRITE_MODE_SHIFT			6
> +#define DA9150_WRITE_MODE_MASK			BIT(6)
> +#define DA9150_REVERT_SHIFT			7
> +#define DA9150_REVERT_MASK			BIT(7)
> +
> +/* DA9150_PAGE_CON_4 = 0x200 */
> +#define DA9150_PAGE_SHIFT			0
> +#define DA9150_PAGE_MASK			(0x3f << 0)
> +#define DA9150_WRITE_MODE_SHIFT			6
> +#define DA9150_WRITE_MODE_MASK			BIT(6)
> +#define DA9150_REVERT_SHIFT			7
> +#define DA9150_REVERT_MASK			BIT(7)
> +
> +/* DA9150_PAGE_CON_5 = 0x280 */
> +#define DA9150_PAGE_SHIFT			0
> +#define DA9150_PAGE_MASK			(0x3f << 0)
> +#define DA9150_WRITE_MODE_SHIFT			6
> +#define DA9150_WRITE_MODE_MASK			BIT(6)
> +#define DA9150_REVERT_SHIFT			7
> +#define DA9150_REVERT_MASK			BIT(7)
> +
> +/* DA9150_PAGE_CON_6 = 0x300 */
> +#define DA9150_PAGE_SHIFT			0
> +#define DA9150_PAGE_MASK			(0x3f << 0)
> +#define DA9150_WRITE_MODE_SHIFT			6
> +#define DA9150_WRITE_MODE_MASK			BIT(6)
> +#define DA9150_REVERT_SHIFT			7
> +#define DA9150_REVERT_MASK			BIT(7)
> +
> +/* DA9150_COREBTLD_STAT_A = 0x302 */
> +#define DA9150_BOOTLD_STAT_SHIFT		0
> +#define DA9150_BOOTLD_STAT_MASK			(0x03 << 0)
> +#define DA9150_CORE_LOCKUP_SHIFT		2
> +#define DA9150_CORE_LOCKUP_MASK			BIT(2)
> +
> +/* DA9150_COREBTLD_CTRL_A = 0x303 */
> +#define DA9150_CORE_RESET_SHIFT			0
> +#define DA9150_CORE_RESET_MASK			BIT(0)
> +#define DA9150_CORE_STOP_SHIFT			1
> +#define DA9150_CORE_STOP_MASK			BIT(1)
> +
> +/* DA9150_CORE_CONFIG_A = 0x304 */
> +#define DA9150_CORE_MEMMUX_SHIFT		0
> +#define DA9150_CORE_MEMMUX_MASK			(0x03 << 0)
> +#define DA9150_WDT_AUTO_START_SHIFT		2
> +#define DA9150_WDT_AUTO_START_MASK		BIT(2)
> +#define DA9150_WDT_AUTO_LOCK_SHIFT		3
> +#define DA9150_WDT_AUTO_LOCK_MASK		BIT(3)
> +#define DA9150_WDT_HLT_NO_CLK_SHIFT		4
> +#define DA9150_WDT_HLT_NO_CLK_MASK		BIT(4)
> +
> +/* DA9150_CORE_CONFIG_C = 0x305 */
> +#define DA9150_CORE_SW_SIZE_SHIFT		0
> +#define DA9150_CORE_SW_SIZE_MASK		(0xff << 0)
> +
> +/* DA9150_CORE_CONFIG_B = 0x306 */
> +#define DA9150_BOOTLD_EN_SHIFT			0
> +#define DA9150_BOOTLD_EN_MASK			BIT(0)
> +#define DA9150_CORE_EN_SHIFT			2
> +#define DA9150_CORE_EN_MASK			BIT(2)
> +#define DA9150_CORE_SW_SRC_SHIFT		3
> +#define DA9150_CORE_SW_SRC_MASK			(0x07 << 3)
> +#define DA9150_DEEP_SLEEP_EN_SHIFT		7
> +#define DA9150_DEEP_SLEEP_EN_MASK		BIT(7)
> +
> +/* DA9150_CORE_CFG_DATA_A = 0x307 */
> +#define DA9150_CORE_CFG_DT_A_SHIFT		0
> +#define DA9150_CORE_CFG_DT_A_MASK		(0xff << 0)
> +
> +/* DA9150_CORE_CFG_DATA_B = 0x308 */
> +#define DA9150_CORE_CFG_DT_B_SHIFT		0
> +#define DA9150_CORE_CFG_DT_B_MASK		(0xff << 0)
> +
> +/* DA9150_CORE_CMD_A = 0x309 */
> +#define DA9150_CORE_CMD_SHIFT			0
> +#define DA9150_CORE_CMD_MASK			(0xff << 0)
> +
> +/* DA9150_CORE_DATA_A = 0x30A */
> +#define DA9150_CORE_DATA_0_SHIFT		0
> +#define DA9150_CORE_DATA_0_MASK			(0xff << 0)
> +
> +/* DA9150_CORE_DATA_B = 0x30B */
> +#define DA9150_CORE_DATA_1_SHIFT		0
> +#define DA9150_CORE_DATA_1_MASK			(0xff << 0)
> +
> +/* DA9150_CORE_DATA_C = 0x30C */
> +#define DA9150_CORE_DATA_2_SHIFT		0
> +#define DA9150_CORE_DATA_2_MASK			(0xff << 0)
> +
> +/* DA9150_CORE_DATA_D = 0x30D */
> +#define DA9150_CORE_DATA_3_SHIFT		0
> +#define DA9150_CORE_DATA_3_MASK			(0xff << 0)
> +
> +/* DA9150_CORE2WIRE_STAT_A = 0x310 */
> +#define DA9150_FW_FWDL_ERR_SHIFT		7
> +#define DA9150_FW_FWDL_ERR_MASK			BIT(7)
> +
> +/* DA9150_CORE2WIRE_CTRL_A = 0x311 */
> +#define DA9150_FW_FWDL_EN_SHIFT			0
> +#define DA9150_FW_FWDL_EN_MASK			BIT(0)
> +#define DA9150_FG_QIF_EN_SHIFT			1
> +#define DA9150_FG_QIF_EN_MASK			BIT(1)
> +#define DA9150_CORE_BASE_ADDR_SHIFT		4
> +#define DA9150_CORE_BASE_ADDR_MASK		(0x0f << 4)
> +
> +/* DA9150_FW_CTRL_A = 0x312 */
> +#define DA9150_FW_SEAL_SHIFT			0
> +#define DA9150_FW_SEAL_MASK			(0xff << 0)
> +
> +/* DA9150_FW_CTRL_C = 0x313 */
> +#define DA9150_FW_FWDL_CRC_SHIFT		0
> +#define DA9150_FW_FWDL_CRC_MASK			(0xff << 0)
> +
> +/* DA9150_FW_CTRL_D = 0x314 */
> +#define DA9150_FW_FWDL_BASE_SHIFT		0
> +#define DA9150_FW_FWDL_BASE_MASK		(0x0f << 0)
> +
> +/* DA9150_FG_CTRL_A = 0x315 */
> +#define DA9150_FG_QIF_CODE_SHIFT		0
> +#define DA9150_FG_QIF_CODE_MASK			(0xff << 0)
> +
> +/* DA9150_FG_CTRL_B = 0x316 */
> +#define DA9150_FG_QIF_VALUE_SHIFT		0
> +#define DA9150_FG_QIF_VALUE_MASK		(0xff << 0)
> +
> +/* DA9150_FW_CTRL_E = 0x317 */
> +#define DA9150_FW_FWDL_SEG_SHIFT		0
> +#define DA9150_FW_FWDL_SEG_MASK			(0xff << 0)
> +
> +/* DA9150_FW_CTRL_B = 0x318 */
> +#define DA9150_FW_FWDL_VALUE_SHIFT		0
> +#define DA9150_FW_FWDL_VALUE_MASK		(0xff << 0)
> +
> +/* DA9150_GPADC_CMAN = 0x320 */
> +#define DA9150_GPADC_CEN_SHIFT			0
> +#define DA9150_GPADC_CEN_MASK			BIT(0)
> +#define DA9150_GPADC_CMUX_SHIFT			1
> +#define DA9150_GPADC_CMUX_MASK			(0x1f << 1)
> +
> +/* DA9150_GPADC_CRES_A = 0x322 */
> +#define DA9150_GPADC_CRES_H_SHIFT		0
> +#define DA9150_GPADC_CRES_H_MASK		(0xff << 0)
> +
> +/* DA9150_GPADC_CRES_B = 0x323 */
> +#define DA9150_GPADC_CRUN_SHIFT			0
> +#define DA9150_GPADC_CRUN_MASK			BIT(0)
> +#define DA9150_GPADC_CRES_L_SHIFT		6
> +#define DA9150_GPADC_CRES_L_MASK		(0x03 << 6)
> +
> +/* DA9150_CC_CFG_A = 0x328 */
> +#define DA9150_CC_EN_SHIFT			0
> +#define DA9150_CC_EN_MASK			BIT(0)
> +#define DA9150_CC_TIMEBASE_SHIFT		1
> +#define DA9150_CC_TIMEBASE_MASK			(0x03 << 1)
> +#define DA9150_CC_CFG_SHIFT			5
> +#define DA9150_CC_CFG_MASK			(0x03 << 5)
> +#define DA9150_CC_ENDLESS_MODE_SHIFT		7
> +#define DA9150_CC_ENDLESS_MODE_MASK		BIT(7)
> +
> +/* DA9150_CC_CFG_B = 0x329 */
> +#define DA9150_CC_OPT_SHIFT			0
> +#define DA9150_CC_OPT_MASK			(0x03 << 0)
> +#define DA9150_CC_PREAMP_SHIFT			2
> +#define DA9150_CC_PREAMP_MASK			(0x03 << 2)
> +
> +/* DA9150_CC_ICHG_RES_A = 0x32A */
> +#define DA9150_CC_ICHG_RES_H_SHIFT		0
> +#define DA9150_CC_ICHG_RES_H_MASK		(0xff << 0)
> +
> +/* DA9150_CC_ICHG_RES_B = 0x32B */
> +#define DA9150_CC_ICHG_RES_L_SHIFT		3
> +#define DA9150_CC_ICHG_RES_L_MASK		(0x1f << 3)
> +
> +/* DA9150_CC_IAVG_RES_A = 0x32C */
> +#define DA9150_CC_IAVG_RES_H_SHIFT		0
> +#define DA9150_CC_IAVG_RES_H_MASK		(0xff << 0)
> +
> +/* DA9150_CC_IAVG_RES_B = 0x32D */
> +#define DA9150_CC_IAVG_RES_L_SHIFT		0
> +#define DA9150_CC_IAVG_RES_L_MASK		(0xff << 0)
> +
> +/* DA9150_TAUX_CTRL_A = 0x330 */
> +#define DA9150_TAUX_EN_SHIFT			0
> +#define DA9150_TAUX_EN_MASK			BIT(0)
> +#define DA9150_TAUX_MOD_SHIFT			1
> +#define DA9150_TAUX_MOD_MASK			BIT(1)
> +#define DA9150_TAUX_UPDATE_SHIFT		2
> +#define DA9150_TAUX_UPDATE_MASK			BIT(2)
> +
> +/* DA9150_TAUX_RELOAD_H = 0x332 */
> +#define DA9150_TAUX_RLD_H_SHIFT			0
> +#define DA9150_TAUX_RLD_H_MASK			(0xff << 0)
> +
> +/* DA9150_TAUX_RELOAD_L = 0x333 */
> +#define DA9150_TAUX_RLD_L_SHIFT			3
> +#define DA9150_TAUX_RLD_L_MASK			(0x1f << 3)
> +
> +/* DA9150_TAUX_VALUE_H = 0x334 */
> +#define DA9150_TAUX_VAL_H_SHIFT			0
> +#define DA9150_TAUX_VAL_H_MASK			(0xff << 0)
> +
> +/* DA9150_TAUX_VALUE_L = 0x335 */
> +#define DA9150_TAUX_VAL_L_SHIFT			3
> +#define DA9150_TAUX_VAL_L_MASK			(0x1f << 3)
> +
> +/* DA9150_AUX_DATA_0 = 0x338 */
> +#define DA9150_AUX_DAT_0_SHIFT			0
> +#define DA9150_AUX_DAT_0_MASK			(0xff << 0)
> +
> +/* DA9150_AUX_DATA_1 = 0x339 */
> +#define DA9150_AUX_DAT_1_SHIFT			0
> +#define DA9150_AUX_DAT_1_MASK			(0xff << 0)
> +
> +/* DA9150_AUX_DATA_2 = 0x33A */
> +#define DA9150_AUX_DAT_2_SHIFT			0
> +#define DA9150_AUX_DAT_2_MASK			(0xff << 0)
> +
> +/* DA9150_AUX_DATA_3 = 0x33B */
> +#define DA9150_AUX_DAT_3_SHIFT			0
> +#define DA9150_AUX_DAT_3_MASK			(0xff << 0)
> +
> +/* DA9150_BIF_CTRL = 0x340 */
> +#define DA9150_BIF_ISRC_EN_SHIFT		0
> +#define DA9150_BIF_ISRC_EN_MASK			BIT(0)
> +
> +/* DA9150_TBAT_CTRL_A = 0x342 */
> +#define DA9150_TBAT_EN_SHIFT			0
> +#define DA9150_TBAT_EN_MASK			BIT(0)
> +#define DA9150_TBAT_SW1_SHIFT			1
> +#define DA9150_TBAT_SW1_MASK			BIT(1)
> +#define DA9150_TBAT_SW2_SHIFT			2
> +#define DA9150_TBAT_SW2_MASK			BIT(2)
> +
> +/* DA9150_TBAT_CTRL_B = 0x343 */
> +#define DA9150_TBAT_SW_FRC_SHIFT		0
> +#define DA9150_TBAT_SW_FRC_MASK			BIT(0)
> +#define DA9150_TBAT_STAT_SW1_SHIFT		1
> +#define DA9150_TBAT_STAT_SW1_MASK		BIT(1)
> +#define DA9150_TBAT_STAT_SW2_SHIFT		2
> +#define DA9150_TBAT_STAT_SW2_MASK		BIT(2)
> +#define DA9150_TBAT_HIGH_CURR_SHIFT		3
> +#define DA9150_TBAT_HIGH_CURR_MASK		BIT(3)
> +
> +/* DA9150_TBAT_RES_A = 0x344 */
> +#define DA9150_TBAT_RES_H_SHIFT			0
> +#define DA9150_TBAT_RES_H_MASK			(0xff << 0)
> +
> +/* DA9150_TBAT_RES_B = 0x345 */
> +#define DA9150_TBAT_RES_DIS_SHIFT		0
> +#define DA9150_TBAT_RES_DIS_MASK		BIT(0)
> +#define DA9150_TBAT_RES_L_SHIFT			6
> +#define DA9150_TBAT_RES_L_MASK			(0x03 << 6)
> +
> +#endif /* __DA9150_REGISTERS_H */
> --
> 1.9.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-iio" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
