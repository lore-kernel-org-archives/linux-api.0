From: Hartmut Knaack <knaack.h-Mmb7MZpHnFY@public.gmane.org>
Subject: Re: [PATCH 3/8] iio: Add support for DA9150 GPADC
Date: Sun, 12 Oct 2014 00:47:51 +0200
Message-ID: <5439B397.8060207@gmx.de>
References: <cover.1411396718.git.Adam.Thomson.Opensource@diasemi.com> <ee4c56931f326d8ee9c1313c44456bce2dec8b8c.1411396719.git.Adam.Thomson.Opensource@diasemi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <ee4c56931f326d8ee9c1313c44456bce2dec8b8c.1411396719.git.Adam.Thomson.Opensource-WBD+wuPFNBhBDgjK7y7TUQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Adam Thomson <Adam.Thomson.Opensource-WBD+wuPFNBhBDgjK7y7TUQ@public.gmane.org>, Lee Jones <lee.jones-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Samuel Ortiz <sameo-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Jonathan Cameron <jic23-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-iio-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sebastian Reichel <sre-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dmitry Eremin-Solenikov <dbaryshkov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Grant Likely <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, support.opensource-WBD+wuPFNBhBDgjK7y7TUQ@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi,
I have put a few comments inline.

Adam Thomson schrieb am 23.09.2014 12:53:
> This patch adds support for DA9150 Charger & Fuel-Gauge IC GPADC.
> 
> Signed-off-by: Adam Thomson <Adam.Thomson.Opensource-WBD+wuPFNBhBDgjK7y7TUQ@public.gmane.org>
> ---
>  drivers/iio/adc/Kconfig        |   9 +
>  drivers/iio/adc/Makefile       |   1 +
>  drivers/iio/adc/da9150-gpadc.c | 406 +++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 416 insertions(+)
>  create mode 100644 drivers/iio/adc/da9150-gpadc.c
> 
> diff --git a/drivers/iio/adc/Kconfig b/drivers/iio/adc/Kconfig
> index 11b048a..8041347 100644
> --- a/drivers/iio/adc/Kconfig
> +++ b/drivers/iio/adc/Kconfig
> @@ -127,6 +127,15 @@ config AT91_ADC
>  	help
>  	  Say yes here to build support for Atmel AT91 ADC.
> 
> +config DA9150_GPADC
> +	tristate "Dialog DA9150 GPADC driver support"
> +	depends on MFD_DA9150
> +	help
> +	  Say yes here to build support for Dialog DA9150 GPADC.
> +
> +	  This driver can also be built as a module. If chosen, the module name
> +	  will be da9150-gpadc.
> +
>  config EXYNOS_ADC
>  	tristate "Exynos ADC driver support"
>  	depends on ARCH_EXYNOS || (OF && COMPILE_TEST)
> diff --git a/drivers/iio/adc/Makefile b/drivers/iio/adc/Makefile
> index ad81b51..48413d2 100644
> --- a/drivers/iio/adc/Makefile
> +++ b/drivers/iio/adc/Makefile
> @@ -14,6 +14,7 @@ obj-$(CONFIG_AD7793) += ad7793.o
>  obj-$(CONFIG_AD7887) += ad7887.o
>  obj-$(CONFIG_AD799X) += ad799x.o
>  obj-$(CONFIG_AT91_ADC) += at91_adc.o
> +obj-$(CONFIG_DA9150_GPADC) += da9150-gpadc.o
>  obj-$(CONFIG_EXYNOS_ADC) += exynos_adc.o
>  obj-$(CONFIG_LP8788_ADC) += lp8788_adc.o
>  obj-$(CONFIG_MAX1027) += max1027.o
> diff --git a/drivers/iio/adc/da9150-gpadc.c b/drivers/iio/adc/da9150-gpadc.c
> new file mode 100644
> index 0000000..2b83ee0
> --- /dev/null
> +++ b/drivers/iio/adc/da9150-gpadc.c
> @@ -0,0 +1,406 @@
> +/*
> + * DA9150 GPADC Driver
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
> +#include <linux/slab.h>
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +#include <linux/interrupt.h>
> +#include <linux/mutex.h>
> +#include <linux/completion.h>
> +#include <linux/iio/iio.h>
> +#include <linux/iio/machine.h>
> +#include <linux/iio/driver.h>
> +#include <linux/mfd/da9150/core.h>
> +#include <linux/mfd/da9150/registers.h>
> +
> +/* Channels */
> +enum da9150_gpadc_hw_channel {
> +	DA9150_GPADC_HW_CHAN_GPIOA_2V = 0,
> +	DA9150_GPADC_HW_CHAN_GPIOA_2V_,
> +	DA9150_GPADC_HW_CHAN_GPIOB_2V,
> +	DA9150_GPADC_HW_CHAN_GPIOB_2V_,
> +	DA9150_GPADC_HW_CHAN_GPIOC_2V,
> +	DA9150_GPADC_HW_CHAN_GPIOC_2V_,
> +	DA9150_GPADC_HW_CHAN_GPIOD_2V,
> +	DA9150_GPADC_HW_CHAN_GPIOD_2V_,
> +	DA9150_GPADC_HW_CHAN_IBUS_SENSE,
> +	DA9150_GPADC_HW_CHAN_IBUS_SENSE_,
> +	DA9150_GPADC_HW_CHAN_VBUS_DIV,
> +	DA9150_GPADC_HW_CHAN_VBUS_DIV_,
> +	DA9150_GPADC_HW_CHAN_ID,
> +	DA9150_GPADC_HW_CHAN_ID_,
> +	DA9150_GPADC_HW_CHAN_VSYS,
> +	DA9150_GPADC_HW_CHAN_VSYS_,
> +	DA9150_GPADC_HW_CHAN_GPIOA_6V,
> +	DA9150_GPADC_HW_CHAN_GPIOA_6V_,
> +	DA9150_GPADC_HW_CHAN_GPIOB_6V,
> +	DA9150_GPADC_HW_CHAN_GPIOB_6V_,
> +	DA9150_GPADC_HW_CHAN_GPIOC_6V,
> +	DA9150_GPADC_HW_CHAN_GPIOC_6V_,
> +	DA9150_GPADC_HW_CHAN_GPIOD_6V,
> +	DA9150_GPADC_HW_CHAN_GPIOD_6V_,
> +	DA9150_GPADC_HW_CHAN_VBAT,
> +	DA9150_GPADC_HW_CHAN_VBAT_,
> +	DA9150_GPADC_HW_CHAN_TBAT,
> +	DA9150_GPADC_HW_CHAN_TBAT_,
> +	DA9150_GPADC_HW_CHAN_TJUNC_CORE,
> +	DA9150_GPADC_HW_CHAN_TJUNC_CORE_,
> +	DA9150_GPADC_HW_CHAN_TJUNC_OVP,
> +	DA9150_GPADC_HW_CHAN_TJUNC_OVP_,
> +};
> +
> +enum da9150_gpadc_channel {
> +	DA9150_GPADC_CHAN_GPIOA = 0,
> +	DA9150_GPADC_CHAN_GPIOB,
> +	DA9150_GPADC_CHAN_GPIOC,
> +	DA9150_GPADC_CHAN_GPIOD,
> +	DA9150_GPADC_CHAN_IBUS,
> +	DA9150_GPADC_CHAN_VBUS,
> +	DA9150_GPADC_CHAN_ID,
> +	DA9150_GPADC_CHAN_VSYS,
> +	DA9150_GPADC_CHAN_VBAT,
> +	DA9150_GPADC_CHAN_TBAT,
> +	DA9150_GPADC_CHAN_TJUNC_CORE,
> +	DA9150_GPADC_CHAN_TJUNC_OVP,
> +};
> +
> +/* Private data */
> +struct da9150_gpadc {
> +	struct da9150 *da9150;
> +	struct device *dev;
> +
> +	struct mutex lock;
> +	struct completion complete;
> +};
> +
> +
> +static irqreturn_t da9150_gpadc_irq(int irq, void *data)
> +{
> +
> +	struct da9150_gpadc *gpadc = data;
> +
> +	complete(&gpadc->complete);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static int da9150_gpadc_read_adc(struct da9150_gpadc *gpadc, int hw_chan)
> +{
> +	u8 result_regs[2];
> +	int result;
> +
> +	mutex_lock(&gpadc->lock);
> +
> +	/* Set channel & enable measurement */
> +	da9150_reg_write(gpadc->da9150, DA9150_GPADC_MAN,
> +			 (DA9150_GPADC_EN_MASK |
> +			  hw_chan << DA9150_GPADC_MUX_SHIFT));
> +
> +	/* Consume left-over completion from a previous timeout */
> +	try_wait_for_completion(&gpadc->complete);
> +
> +	/* Check for actual completion */
> +	wait_for_completion_timeout(&gpadc->complete, msecs_to_jiffies(5));
> +
> +	/* Read result and status from device */
> +	da9150_bulk_read(gpadc->da9150, DA9150_GPADC_RES_A, 2, result_regs);
> +
> +	mutex_unlock(&gpadc->lock);
> +
> +	/* Check to make sure device really has completed reading */
> +	if (result_regs[1] & DA9150_GPADC_RUN_MASK) {
> +		dev_err(gpadc->dev, "Timeout on channel %d of GPADC\n",
> +			hw_chan);
> +		return -ETIMEDOUT;
> +	}
> +
> +	/* LSBs - 2 bits */
> +	result = (result_regs[1] & DA9150_GPADC_RES_L_MASK) >>
> +		 DA9150_GPADC_RES_L_SHIFT;
> +	/* MSBs - 8 bits */
> +	result |= result_regs[0] << DA9150_GPADC_RES_L_BITS;
> +
> +	return result;
> +}
> +
> +static inline int da9150_gpadc_gpio_6v_voltage_now(int raw_val)
> +{
> +	/* Convert to mV */
> +	return (6 * ((raw_val * 1000) + 500)) / 1024;
> +}
> +
> +static inline int da9150_gpadc_ibus_current_avg(int raw_val)
> +{
> +	/* Convert to mA */
> +	return (4 * ((raw_val * 1000) + 500)) / 2048;
> +}
> +
> +static inline int da9150_gpadc_vbus_21v_voltage_now(int raw_val)
> +{
> +	/* Convert to mV */
> +	return (21 * ((raw_val * 1000) + 500)) / 1024;
> +}
> +
> +static inline int da9150_gpadc_vsys_6v_voltage_now(int raw_val)
> +{
> +	/* Convert to mV */
> +	return (3 * ((raw_val * 1000) + 500)) / 512;
> +}
> +
> +static int da9150_gpadc_read_processed(struct da9150_gpadc *gpadc, int channel,
> +				       int hw_chan, int *val)
> +{
> +	int raw_val;
> +
> +	raw_val = da9150_gpadc_read_adc(gpadc, hw_chan);
> +	if (raw_val < 0)
> +		return raw_val;
> +
> +	switch (channel) {
> +	case DA9150_GPADC_CHAN_GPIOA:
> +	case DA9150_GPADC_CHAN_GPIOB:
> +	case DA9150_GPADC_CHAN_GPIOC:
> +	case DA9150_GPADC_CHAN_GPIOD:
> +		*val = da9150_gpadc_gpio_6v_voltage_now(raw_val);
> +		break;
> +	case DA9150_GPADC_CHAN_IBUS:
> +		*val = da9150_gpadc_ibus_current_avg(raw_val);
> +		break;
> +	case DA9150_GPADC_CHAN_VBUS:
> +		*val = da9150_gpadc_vbus_21v_voltage_now(raw_val);
> +		break;
> +	case DA9150_GPADC_CHAN_VSYS:
> +		*val = da9150_gpadc_vsys_6v_voltage_now(raw_val);
> +		break;
> +	default:
> +		/* No processing for other channels so return raw value */
> +		*val = raw_val;
> +		break;
> +	}
> +
> +	return IIO_VAL_INT;
> +}
> +
> +static int da9150_gpadc_read_scale(int channel, int *val, int *val2)
> +{
> +	switch (channel) {
> +	case DA9150_GPADC_CHAN_VBAT:
> +		*val = 2932;
> +		*val2 = 1000;
> +		return IIO_VAL_FRACTIONAL;
> +	case DA9150_GPADC_CHAN_TJUNC_CORE:
> +	case DA9150_GPADC_CHAN_TJUNC_OVP:
> +		*val = 1000000;
> +		*val2 = 4420;
> +		return IIO_VAL_FRACTIONAL;
> +	default:
> +		return -EINVAL;
> +	}
> +}
> +
> +static int da9150_gpadc_read_offset(int channel, int *val)
> +{
> +	switch (channel) {
> +	case DA9150_GPADC_CHAN_VBAT:
> +		*val = 1500000 / 2932;
> +		return IIO_VAL_INT;
> +	case DA9150_GPADC_CHAN_TJUNC_CORE:
> +	case DA9150_GPADC_CHAN_TJUNC_OVP:
> +		*val = -144;
> +		return IIO_VAL_INT;
> +	default:
> +		return -EINVAL;
> +	}
> +}
> +
> +static int da9150_gpadc_read_raw(struct iio_dev *indio_dev,
> +				 struct iio_chan_spec const *chan,
> +				 int *val, int *val2, long mask)
> +{
> +	struct da9150_gpadc *gpadc = iio_priv(indio_dev);
> +
> +	if ((chan->channel < DA9150_GPADC_CHAN_GPIOA) ||
> +	    (chan->channel > DA9150_GPADC_CHAN_TJUNC_OVP))
> +		return -EINVAL;
> +
> +	switch (mask) {
> +	case IIO_CHAN_INFO_RAW:
> +	case IIO_CHAN_INFO_PROCESSED:
> +		return da9150_gpadc_read_processed(gpadc, chan->channel,
> +						   chan->address, val);
> +	case IIO_CHAN_INFO_SCALE:
> +		return da9150_gpadc_read_scale(chan->channel, val, val2);
> +	case IIO_CHAN_INFO_OFFSET:
> +		return da9150_gpadc_read_offset(chan->channel, val);
> +	default:
> +		return -EINVAL;
> +	}
> +}
> +
> +static const struct iio_info da9150_gpadc_info = {
> +	.read_raw = &da9150_gpadc_read_raw,
> +	.driver_module = THIS_MODULE,
> +};
> +
> +#define DA9150_GPADC_CHANNEL(_id, _hw_id, _type, chan_info,	\
> +			     _ext_name) {			\
> +	.type = _type,						\
> +	.indexed = 1,						\
> +	.channel = DA9150_GPADC_CHAN_##_id,			\
> +	.address = DA9150_GPADC_HW_CHAN_##_hw_id,		\
> +	.info_mask_separate = chan_info,			\
> +	.extend_name = _ext_name,				\
> +	.datasheet_name = #_id,					\
> +}
> +
> +#define DA9150_GPADC_CHANNEL_RAW(_id, _hw_id, _type, _ext_name)	\
> +	DA9150_GPADC_CHANNEL(_id, _hw_id, _type,		\
> +			     BIT(IIO_CHAN_INFO_RAW), _ext_name)
> +
> +#define DA9150_GPADC_CHANNEL_SCALED(_id, _hw_id, _type, _ext_name)	\
> +	DA9150_GPADC_CHANNEL(_id, _hw_id, _type,			\
> +			     BIT(IIO_CHAN_INFO_RAW) |			\
> +			     BIT(IIO_CHAN_INFO_SCALE) |			\
> +			     BIT(IIO_CHAN_INFO_OFFSET),			\
> +			     _ext_name)
> +
> +#define DA9150_GPADC_CHANNEL_PROCESSED(_id, _hw_id, _type, _ext_name)	\
> +	DA9150_GPADC_CHANNEL(_id, _hw_id, _type,			\
> +			     BIT(IIO_CHAN_INFO_PROCESSED), _ext_name)
> +
> +/* Supported channels */
> +static const struct iio_chan_spec da9150_gpadc_channels[] = {
> +	DA9150_GPADC_CHANNEL_PROCESSED(GPIOA, GPIOA_6V, IIO_VOLTAGE, "GPIOA"),
> +	DA9150_GPADC_CHANNEL_PROCESSED(GPIOB, GPIOB_6V, IIO_VOLTAGE, "GPIOB"),
> +	DA9150_GPADC_CHANNEL_PROCESSED(GPIOC, GPIOC_6V, IIO_VOLTAGE, "GPIOC"),
> +	DA9150_GPADC_CHANNEL_PROCESSED(GPIOD, GPIOD_6V, IIO_VOLTAGE, "GPIOD"),
> +	DA9150_GPADC_CHANNEL_PROCESSED(IBUS, IBUS_SENSE, IIO_CURRENT, "IBUS"),
> +	DA9150_GPADC_CHANNEL_PROCESSED(VBUS, VBUS_DIV_, IIO_VOLTAGE, "VBUS"),
> +	DA9150_GPADC_CHANNEL_RAW(ID, ID, IIO_VOLTAGE, "ID"),
> +	DA9150_GPADC_CHANNEL_PROCESSED(VSYS, VSYS, IIO_VOLTAGE, "VSYS"),
> +	DA9150_GPADC_CHANNEL_SCALED(VBAT, VBAT, IIO_VOLTAGE, "VBAT"),
> +	DA9150_GPADC_CHANNEL_RAW(TBAT, TBAT, IIO_VOLTAGE, "TBAT"),
> +	DA9150_GPADC_CHANNEL_SCALED(TJUNC_CORE, TJUNC_CORE, IIO_TEMP,
> +				    "TJUNC_CORE"),
> +	DA9150_GPADC_CHANNEL_SCALED(TJUNC_OVP, TJUNC_OVP, IIO_TEMP,
> +				    "TJUNC_OVP"),
> +};
> +
> +/* Default maps used by da9150-charger */
> +static struct iio_map da9150_gpadc_default_maps[] = {
> +	{
> +		.consumer_dev_name = "da9150-charger",
> +		.consumer_channel = "CHAN_IBUS",
> +		.adc_channel_label = "IBUS",
> +	},
> +	{
> +		.consumer_dev_name = "da9150-charger",
> +		.consumer_channel = "CHAN_VBUS",
> +		.adc_channel_label = "VBUS",
> +	},
> +	{
> +		.consumer_dev_name = "da9150-charger",
> +		.consumer_channel = "CHAN_TJUNC",
> +		.adc_channel_label = "TJUNC_CORE",
> +	},
> +	{
> +		.consumer_dev_name = "da9150-charger",
> +		.consumer_channel = "CHAN_VBAT",
> +		.adc_channel_label = "VBAT",
> +	},
> +	{},
> +};
> +
> +static int da9150_gpadc_probe(struct platform_device *pdev)
> +{
> +	struct device *dev = &pdev->dev;
> +	struct da9150 *da9150 = dev_get_drvdata(dev->parent);
Maybe you could find a slightly different name for the instance of this da9150 than its type name.
> +	struct da9150_gpadc *gpadc;
> +	struct iio_dev *indio_dev;
> +	int irq, ret;
> +
> +	indio_dev = devm_iio_device_alloc(&pdev->dev,
> +					  sizeof(struct da9150_gpadc));
> +	if (!indio_dev) {
> +		dev_err(&pdev->dev, "Failed to allocate IIO device\n");
> +		return -ENOMEM;
> +	}
> +	gpadc = iio_priv(indio_dev);
> +
> +	platform_set_drvdata(pdev, indio_dev);
> +	gpadc->da9150 = da9150;
> +	gpadc->dev = dev;
> +
> +	ret = iio_map_array_register(indio_dev, da9150_gpadc_default_maps);
> +	if (ret) {
> +		dev_err(dev, "Failed to register IIO maps: %d\n", ret);
> +		return ret;
> +	}
> +
> +	mutex_init(&gpadc->lock);
> +	init_completion(&gpadc->complete);
> +
> +	irq = platform_get_irq_byname(pdev, "GPADC");
Shouldn't you check irq for possible error codes? devm_request_threaded_irq() expects irq to be unsigned.
> +	ret = devm_request_threaded_irq(dev, irq, NULL, da9150_gpadc_irq,
> +					IRQF_ONESHOT, "GPADC", gpadc);
> +	if (ret) {
> +		dev_err(dev, "Failed to request IRQ %d: %d\n", irq, ret);
> +		goto iio_map_unreg;
> +	}
> +
> +	indio_dev->name = dev_name(dev);
> +	indio_dev->dev.parent = dev;
> +	indio_dev->dev.of_node = pdev->dev.of_node;
> +	indio_dev->info = &da9150_gpadc_info;
> +	indio_dev->modes = INDIO_DIRECT_MODE;
> +	indio_dev->channels = da9150_gpadc_channels;
> +	indio_dev->num_channels = ARRAY_SIZE(da9150_gpadc_channels);
> +
> +	ret = iio_device_register(indio_dev);
> +	if (ret) {
> +		dev_err(dev, "Failed to register IIO device: %d\n", ret);
> +		goto iio_map_unreg;
> +	}
> +
> +	return 0;
> +
> +iio_map_unreg:
> +	iio_map_array_unregister(indio_dev);
> +
> +	return ret;
> +}
> +
> +static int da9150_gpadc_remove(struct platform_device *pdev)
> +{
> +	struct iio_dev *indio_dev = platform_get_drvdata(pdev);
> +
> +	iio_map_array_unregister(indio_dev);
> +	iio_device_unregister(indio_dev);
Not sure if that was the intention of Jonathans comment, but these unregister calls should be switched to be in proper reverse order.
> +
> +	return 0;
> +}
> +
> +static struct platform_driver da9150_gpadc_driver = {
> +	.driver = {
> +		.name = "da9150-gpadc",
> +	},
> +	.probe = da9150_gpadc_probe,
> +	.remove = da9150_gpadc_remove,
> +};
> +
> +module_platform_driver(da9150_gpadc_driver);
> +
> +MODULE_DESCRIPTION("GPADC Driver for DA9150");
> +MODULE_AUTHOR("Adam Thomson <Adam.Thomson.Opensource-WBD+wuPFNBhBDgjK7y7TUQ@public.gmane.org");
You are missing a > at the end of your email-address.
> +MODULE_LICENSE("GPL");
> --
> 1.9.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-iio" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
