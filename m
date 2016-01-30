From: Jonathan Cameron <jic23-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v4 2/4] iio: health: Add driver for the TI AFE4404 heart
 monitor
Date: Sat, 30 Jan 2016 14:59:18 +0000
Message-ID: <56ACCFC6.2000700@kernel.org>
References: <1453742941-12086-1-git-send-email-afd@ti.com>
 <1453742941-12086-3-git-send-email-afd@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1453742941-12086-3-git-send-email-afd-l0cyMroinI0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Andrew F. Davis" <afd-l0cyMroinI0@public.gmane.org>, Hartmut Knaack <knaack.h-Mmb7MZpHnFY@public.gmane.org>, Lars-Peter Clausen <lars-Qo5EllUWu/uELgA04lAiVw@public.gmane.org>, Peter Meerwald <pmeerw-jW+XmwGofnusTnJN9+BGXg@public.gmane.org>, Dan Murphy <dmurphy-l0cyMroinI0@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Cc: linux-iio-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 25/01/16 17:28, Andrew F. Davis wrote:
> Add driver for the TI AFE4404 heart rate monitor and pulse oximeter.
> This device detects reflected LED light fluctuations and presents an ADC
> value to the user space for further signal processing.
> 
> Datasheet: http://www.ti.com/product/AFE4404/datasheet
> 
> Signed-off-by: Andrew F. Davis <afd-l0cyMroinI0@public.gmane.org>
Hi Andrew,

This changed rather more than I was expecting, but fair enough.

A few bits are missing from remove.  Few other little bits inline,
though mostly those are about readability rather than what the code
is doing.

I was a little suprised to see no control over whether the trigger is
enabled or not.  I'm trying to get my head around what the result of this will
be.  I guess we'll have interrupts pinging away merilly doing nothing until
the buffer is attached then the demux will get set up to actually do
something with the data.

hmm. Might be fine, if I ususual.  Normally devices have some means of
masking the interrupt.

Jonathan

> ---
>  .../ABI/testing/sysfs-bus-iio-health-afe440x       |  54 ++
>  drivers/iio/health/Kconfig                         |  19 +-
>  drivers/iio/health/Makefile                        |   1 +
>  drivers/iio/health/afe4404.c                       | 665 +++++++++++++++++++++
>  drivers/iio/health/afe440x.h                       | 193 ++++++
>  5 files changed, 931 insertions(+), 1 deletion(-)
>  create mode 100644 Documentation/ABI/testing/sysfs-bus-iio-health-afe440x
>  create mode 100644 drivers/iio/health/afe4404.c
>  create mode 100644 drivers/iio/health/afe440x.h
> 
> diff --git a/Documentation/ABI/testing/sysfs-bus-iio-health-afe440x b/Documentation/ABI/testing/sysfs-bus-iio-health-afe440x
> new file mode 100644
> index 0000000..3740f25
> --- /dev/null
> +++ b/Documentation/ABI/testing/sysfs-bus-iio-health-afe440x
> @@ -0,0 +1,54 @@
> +What:		/sys/bus/iio/devices/iio:deviceX/tia_resistanceY
> +		/sys/bus/iio/devices/iio:deviceX/tia_capacitanceY
> +Date:		December 2015
> +KernelVersion:
> +Contact:	Andrew F. Davis <afd-l0cyMroinI0@public.gmane.org>
> +Description:
> +		Get and set the resistance and the capacitance settings for the
> +		Transimpedance Amplifier. Y is 1 for Rf1 and Cf1, Y is 2 for
> +		Rf2 and Cf2 values.
> +
> +What:		/sys/bus/iio/devices/iio:deviceX/tia_separate_en
> +Date:		December 2015
> +KernelVersion:
> +Contact:	Andrew F. Davis <afd-l0cyMroinI0@public.gmane.org>
> +Description:
> +		Enable or disable separate settings for the TransImpedance
> +		Amplifier above, when disabled both values are set by the
> +		first channel.
> +
> +What:		/sys/bus/iio/devices/iio:deviceX/in_intensity_ledY_raw
> +		/sys/bus/iio/devices/iio:deviceX/in_intensity_ledY_ambient_raw
> +Date:		December 2015
> +KernelVersion:
> +Contact:	Andrew F. Davis <afd-l0cyMroinI0@public.gmane.org>
> +Description:
> +		Get measured values from the ADC for these stages. Y is the
> +		specific LED number. The values are expressed in 24-bit twos
> +		complement.
> +
> +What:		/sys/bus/iio/devices/iio:deviceX/in_intensity_ledY-ledY_ambient_raw
> +Date:		December 2015
> +KernelVersion:
> +Contact:	Andrew F. Davis <afd-l0cyMroinI0@public.gmane.org>
> +Description:
> +		Get differential values from the ADC for these stages. Y is the
> +		specific LED number. The values are expressed in 24-bit twos
> +		complement for the specified LEDs.
> +
> +What:		/sys/bus/iio/devices/iio:deviceX/out_current_ledY_offset
> +		/sys/bus/iio/devices/iio:deviceX/out_current_ledY_ambient_offset
> +Date:		December 2015
> +KernelVersion:
> +Contact:	Andrew F. Davis <afd-l0cyMroinI0@public.gmane.org>
> +Description:
> +		Get and set the offset cancellation DAC setting for these
> +		stages. The values are expressed in 5-bit sign-magnitude.
> +
> +What:		/sys/bus/iio/devices/iio:deviceX/out_current_ledY_raw
> +Date:		December 2015
> +KernelVersion:
> +Contact:	Andrew F. Davis <afd-l0cyMroinI0@public.gmane.org>
> +Description:
> +		Get and set the LED current for the specified LED. Y is the
> +		specific LED number.
> diff --git a/drivers/iio/health/Kconfig b/drivers/iio/health/Kconfig
> index a647679..632a14b 100644
> --- a/drivers/iio/health/Kconfig
> +++ b/drivers/iio/health/Kconfig
> @@ -3,7 +3,22 @@
>  #
>  # When adding new entries keep the list in alphabetical order
>  
> -menu "Health sensors"
> +menu "Health Sensors"
> +
> +menu "Heart Rate Monitors"
> +
> +config AFE4404
> +	tristate "TI AFE4404 heart rate and pulse oximeter sensor"
> +	depends on I2C
> +	select REGMAP_I2C
> +	select IIO_BUFFER
> +	select IIO_TRIGGERED_BUFFER
> +	help
> +	  Say yes to choose the Texas Instruments AFE4404
> +	  heart rate monitor and low-cost pulse oximeter.
> +
> +	  To compile this driver as a module, choose M here: the
> +	  module will be called afe4404.
>  
>  config MAX30100
>  	tristate "MAX30100 heart rate and pulse oximeter sensor"
> @@ -19,3 +34,5 @@ config MAX30100
>  	  module will be called max30100.
>  
>  endmenu
> +
> +endmenu
> diff --git a/drivers/iio/health/Makefile b/drivers/iio/health/Makefile
> index 7c475d7..b37c0d5 100644
> --- a/drivers/iio/health/Makefile
> +++ b/drivers/iio/health/Makefile
> @@ -4,4 +4,5 @@
>  
>  # When adding new entries keep the list in alphabetical order
>  
> +obj-$(CONFIG_AFE4404)		+= afe4404.o
>  obj-$(CONFIG_MAX30100)		+= max30100.o
> diff --git a/drivers/iio/health/afe4404.c b/drivers/iio/health/afe4404.c
> new file mode 100644
> index 0000000..58f3e35
> --- /dev/null
> +++ b/drivers/iio/health/afe4404.c
> @@ -0,0 +1,665 @@
> +/*
> + * AFE4404 Heart Rate Monitors and Low-Cost Pulse Oximeters
> + *
> + * Copyright (C) 2015 Texas Instruments Incorporated - http://www.ti.com/
> + *	Andrew F. Davis <afd-l0cyMroinI0@public.gmane.org>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful, but
> + * WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * General Public License for more details.
> + */
> +
> +#include <linux/device.h>
> +#include <linux/err.h>
> +#include <linux/interrupt.h>
> +#include <linux/i2c.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/regmap.h>
> +#include <linux/sysfs.h>
> +#include <linux/regulator/consumer.h>
> +
> +#include <linux/iio/iio.h>
> +#include <linux/iio/sysfs.h>
> +#include <linux/iio/buffer.h>
> +#include <linux/iio/trigger.h>
> +#include <linux/iio/triggered_buffer.h>
> +#include <linux/iio/trigger_consumer.h>
> +
> +#include "afe440x.h"
> +
> +#define AFE4404_DRIVER_NAME		"afe4404"
> +
> +/* AFE4404 registers */
> +#define AFE4404_TIA_GAIN_SEP		0x20
> +#define AFE4404_TIA_GAIN		0x21
> +#define AFE4404_PROG_TG_STC		0x34
> +#define AFE4404_PROG_TG_ENDC		0x35
> +#define AFE4404_LED3LEDSTC		0x36
> +#define AFE4404_LED3LEDENDC		0x37
> +#define AFE4404_CLKDIV_PRF		0x39
> +#define AFE4404_OFFDAC			0x3a
> +#define AFE4404_DEC			0x3d
> +#define AFE4404_AVG_LED2_ALED2VAL	0x3f
> +#define AFE4404_AVG_LED1_ALED1VAL	0x40
> +
> +/* AFE4404 GAIN register fields */
> +#define AFE4404_TIA_GAIN_RES_MASK	GENMASK(2, 0)
> +#define AFE4404_TIA_GAIN_RES_SHIFT	0
> +#define AFE4404_TIA_GAIN_CAP_MASK	GENMASK(5, 3)
> +#define AFE4404_TIA_GAIN_CAP_SHIFT	3
> +
> +/* AFE4404 LEDCNTRL register fields */
> +#define AFE4404_LEDCNTRL_ILED1_MASK	GENMASK(5, 0)
> +#define AFE4404_LEDCNTRL_ILED1_SHIFT	0
> +#define AFE4404_LEDCNTRL_ILED2_MASK	GENMASK(11, 6)
> +#define AFE4404_LEDCNTRL_ILED2_SHIFT	6
> +#define AFE4404_LEDCNTRL_ILED3_MASK	GENMASK(17, 12)
> +#define AFE4404_LEDCNTRL_ILED3_SHIFT	12
> +
> +/* AFE4404 CONTROL2 register fields */
> +#define AFE440X_CONTROL2_ILED_2X_MASK	BIT(17)
> +#define AFE440X_CONTROL2_ILED_2X_SHIFT	17
> +
> +/* AFE4404 CONTROL3 register fields */
> +#define AFE440X_CONTROL3_OSC_ENABLE	BIT(9)
> +
> +/* AFE4404 OFFDAC register current fields */
> +#define AFE4404_OFFDAC_CURR_LED1_MASK	GENMASK(9, 5)
> +#define AFE4404_OFFDAC_CURR_LED1_SHIFT	5
> +#define AFE4404_OFFDAC_CURR_LED2_MASK	GENMASK(19, 15)
> +#define AFE4404_OFFDAC_CURR_LED2_SHIFT	15
> +#define AFE4404_OFFDAC_CURR_LED3_MASK	GENMASK(4, 0)
> +#define AFE4404_OFFDAC_CURR_LED3_SHIFT	0
> +#define AFE4404_OFFDAC_CURR_ALED1_MASK	GENMASK(14, 10)
> +#define AFE4404_OFFDAC_CURR_ALED1_SHIFT	10
> +#define AFE4404_OFFDAC_CURR_ALED2_MASK	GENMASK(4, 0)
> +#define AFE4404_OFFDAC_CURR_ALED2_SHIFT	0
> +
> +/* AFE4404 NULL fields */
> +#define NULL_MASK	0
> +#define NULL_SHIFT	0
> +
> +/* AFE4404 TIA_GAIN_CAP values */
> +#define AFE4404_TIA_GAIN_CAP_5_P	0x0
> +#define AFE4404_TIA_GAIN_CAP_2_5_P	0x1
> +#define AFE4404_TIA_GAIN_CAP_10_P	0x2
> +#define AFE4404_TIA_GAIN_CAP_7_5_P	0x3
> +#define AFE4404_TIA_GAIN_CAP_20_P	0x4
> +#define AFE4404_TIA_GAIN_CAP_17_5_P	0x5
> +#define AFE4404_TIA_GAIN_CAP_25_P	0x6
> +#define AFE4404_TIA_GAIN_CAP_22_5_P	0x7
> +
> +/* AFE4404 TIA_GAIN_RES values */
> +#define AFE4404_TIA_GAIN_RES_500_K	0x0
> +#define AFE4404_TIA_GAIN_RES_250_K	0x1
> +#define AFE4404_TIA_GAIN_RES_100_K	0x2
> +#define AFE4404_TIA_GAIN_RES_50_K	0x3
> +#define AFE4404_TIA_GAIN_RES_25_K	0x4
> +#define AFE4404_TIA_GAIN_RES_10_K	0x5
> +#define AFE4404_TIA_GAIN_RES_1_M	0x6
> +#define AFE4404_TIA_GAIN_RES_2_M	0x7
> +
> +/**
> + * struct afe4404_data
> + * @dev - Device structure
> + * @regmap - Register map of the device
> + * @regulator - Pointer to the regulator for the IC
> + * @trig - IIO trigger for this device
> + * @irq - ADC_RDY line interrupt number
> + */
> +struct afe4404_data {
> +	struct device *dev;
> +	struct regmap *regmap;
> +	struct regulator *regulator;
> +	struct iio_trigger *trig;
> +	int irq;
> +};
> +
> +enum afe4404_chan_id {
> +	LED1,
> +	ALED1,
> +	LED2,
> +	ALED2,
> +	LED3,
> +	LED1_ALED1,
> +	LED2_ALED2,
> +	ILED1,
> +	ILED2,
> +	ILED3,
> +};
> +
> +static const struct afe440x_reg_info afe4404_reg_info[] = {

As noted below, I'd find
[LED1] = AFE440X_REG_INFO(AFE440_LED1VAL...
more readable.

> +	AFE440X_REG_INFO(LED1, AFE440X_LED1VAL, AFE4404_OFFDAC, AFE4404_OFFDAC_CURR_LED1),
> +	AFE440X_REG_INFO(ALED1, AFE440X_ALED1VAL, AFE4404_OFFDAC, AFE4404_OFFDAC_CURR_ALED1),
> +	AFE440X_REG_INFO(LED2, AFE440X_LED2VAL, AFE4404_OFFDAC, AFE4404_OFFDAC_CURR_LED2),
> +	AFE440X_REG_INFO(ALED2, AFE440X_ALED2VAL, AFE4404_OFFDAC, AFE4404_OFFDAC_CURR_ALED2),
> +	AFE440X_REG_INFO(LED3, AFE440X_ALED2VAL, 0, NULL),
> +	AFE440X_REG_INFO(LED1_ALED1, AFE440X_LED1_ALED1VAL, 0, NULL),
> +	AFE440X_REG_INFO(LED2_ALED2, AFE440X_LED2_ALED2VAL, 0, NULL),
> +	AFE440X_REG_INFO(ILED1, AFE440X_LEDCNTRL, 0, AFE4404_LEDCNTRL_ILED1),
> +	AFE440X_REG_INFO(ILED2, AFE440X_LEDCNTRL, 0, AFE4404_LEDCNTRL_ILED2),
> +	AFE440X_REG_INFO(ILED3, AFE440X_LEDCNTRL, 0, AFE4404_LEDCNTRL_ILED3),
> +};
> +
> +static const struct iio_chan_spec afe4404_channels[] = {
> +	/* ADC values */
> +	AFE440X_INTENSITY_CHAN(LED1, "led1", BIT(IIO_CHAN_INFO_OFFSET)),
> +	AFE440X_INTENSITY_CHAN(ALED1, "led1_ambient", BIT(IIO_CHAN_INFO_OFFSET)),
> +	AFE440X_INTENSITY_CHAN(LED2, "led2", BIT(IIO_CHAN_INFO_OFFSET)),
> +	AFE440X_INTENSITY_CHAN(ALED2, "led2_ambient", BIT(IIO_CHAN_INFO_OFFSET)),
> +	AFE440X_INTENSITY_CHAN(LED3, "led3", BIT(IIO_CHAN_INFO_OFFSET)),
> +	AFE440X_INTENSITY_CHAN(LED1_ALED1, "led1-led1_ambient", 0),
> +	AFE440X_INTENSITY_CHAN(LED2_ALED2, "led2-led2_ambient", 0),
> +	/* LED current */
> +	AFE440X_CURRENT_CHAN(ILED1, "led1"),
> +	AFE440X_CURRENT_CHAN(ILED2, "led2"),
> +	AFE440X_CURRENT_CHAN(ILED3, "led3"),
> +};
> +
> +static const struct afe440x_val_table afe4404_res_table[] = {
> +	{ .integer = 500000, .fract = 0 },
> +	{ .integer = 250000, .fract = 0 },
> +	{ .integer = 100000, .fract = 0 },
> +	{ .integer = 50000, .fract = 0 },
> +	{ .integer = 25000, .fract = 0 },
> +	{ .integer = 10000, .fract = 0 },
> +	{ .integer = 1000000, .fract = 0 },
> +	{ .integer = 2000000, .fract = 0 },
> +};
> +AFE440X_TABLE_ATTR(tia_resistance_available, afe4404_res_table);
> +
> +static const struct afe440x_val_table afe4404_cap_table[] = {
> +	{ .integer = 0, .fract = 5000 },
> +	{ .integer = 0, .fract = 2500 },
> +	{ .integer = 0, .fract = 10000 },
> +	{ .integer = 0, .fract = 7500 },
> +	{ .integer = 0, .fract = 20000 },
> +	{ .integer = 0, .fract = 17500 },
> +	{ .integer = 0, .fract = 25000 },
> +	{ .integer = 0, .fract = 22500 },
> +};
> +AFE440X_TABLE_ATTR(tia_capacitance_available, afe4404_cap_table);
> +
> +static ssize_t afe440x_show_register(struct device *dev,
> +				     struct device_attribute *attr,
> +				     char *buf)
> +{
> +	struct iio_dev *indio_dev = dev_to_iio_dev(dev);
> +	struct afe4404_data *afe = iio_priv(indio_dev);
> +	struct afe440x_attr *afe440x_attr = to_afe440x_attr(attr);
> +	unsigned int reg_val, type;
> +	int vals[2];
> +	int ret, val_len;
> +
> +	ret = regmap_read(afe->regmap, afe440x_attr->reg, &reg_val);
> +	if (ret)
> +		return ret;
> +
> +	reg_val &= afe440x_attr->mask;
> +	reg_val >>= afe440x_attr->shift;
> +
> +	switch (afe440x_attr->type) {
> +	case SIMPLE:
> +		type = IIO_VAL_INT;
> +		val_len = 1;
> +		vals[0] = reg_val;
> +		break;
> +	case RESISTANCE:
> +	case CAPACITANCE:
> +		type = IIO_VAL_INT_PLUS_MICRO;
> +		val_len = 2;
> +		if (reg_val < afe440x_attr->table_size) {
> +			vals[0] = afe440x_attr->val_table[reg_val].integer;
> +			vals[1] = afe440x_attr->val_table[reg_val].fract;
> +			break;
> +		}
> +		return -EINVAL;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	return iio_format_value(buf, type, val_len, vals);
> +}
> +
> +static ssize_t afe440x_store_register(struct device *dev,
> +				      struct device_attribute *attr,
> +				      const char *buf, size_t count)
> +{
> +	struct iio_dev *indio_dev = dev_to_iio_dev(dev);
> +	struct afe4404_data *afe = iio_priv(indio_dev);
> +	struct afe440x_attr *afe440x_attr = to_afe440x_attr(attr);
> +	int val, integer, fract, ret;
> +
> +	ret = iio_str_to_fixpoint(buf, 100000, &integer, &fract);
> +	if (ret)
> +		return ret;
> +
> +	switch (afe440x_attr->type) {
> +	case SIMPLE:
> +		val = integer;
> +		break;
> +	case RESISTANCE:
> +	case CAPACITANCE:
> +		for (val = 0; val < afe440x_attr->table_size; val++)
> +			if (afe440x_attr->val_table[val].integer == integer &&
> +			    afe440x_attr->val_table[val].fract == fract)
> +				break;
> +		if (val == afe440x_attr->table_size)
> +			return -EINVAL;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	ret = regmap_update_bits(afe->regmap, afe440x_attr->reg,
> +				 afe440x_attr->mask,
> +				 (val << afe440x_attr->shift));
> +	if (ret)
> +		return ret;
> +
> +	return count;
> +}
> +
> +static AFE440X_ATTR(tia_separate_en, AFE4404_TIA_GAIN_SEP, AFE440X_TIAGAIN_ENSEPGAIN, SIMPLE, NULL, 0);
> +
> +static AFE440X_ATTR(tia_resistance1, AFE4404_TIA_GAIN, AFE4404_TIA_GAIN_RES, RESISTANCE, afe4404_res_table, ARRAY_SIZE(afe4404_res_table));
> +static AFE440X_ATTR(tia_capacitance1, AFE4404_TIA_GAIN, AFE4404_TIA_GAIN_CAP, CAPACITANCE, afe4404_cap_table, ARRAY_SIZE(afe4404_cap_table));
> +
> +static AFE440X_ATTR(tia_resistance2, AFE4404_TIA_GAIN_SEP, AFE4404_TIA_GAIN_RES, RESISTANCE, afe4404_res_table, ARRAY_SIZE(afe4404_res_table));
> +static AFE440X_ATTR(tia_capacitance2, AFE4404_TIA_GAIN_SEP, AFE4404_TIA_GAIN_CAP, CAPACITANCE, afe4404_cap_table, ARRAY_SIZE(afe4404_cap_table));
> +
> +static struct attribute *afe440x_attributes[] = {
> +	&afe440x_attr_tia_separate_en.dev_attr.attr,
> +	&afe440x_attr_tia_resistance1.dev_attr.attr,
> +	&afe440x_attr_tia_capacitance1.dev_attr.attr,
> +	&afe440x_attr_tia_resistance2.dev_attr.attr,
> +	&afe440x_attr_tia_capacitance2.dev_attr.attr,
> +	&dev_attr_tia_resistance_available.attr,
> +	&dev_attr_tia_capacitance_available.attr,
> +	NULL
> +};
> +
> +static const struct attribute_group afe440x_attribute_group = {
> +	.attrs = afe440x_attributes
> +};
> +
> +static int afe4404_read_raw(struct iio_dev *indio_dev,
> +			    struct iio_chan_spec const *chan,
> +			    int *val, int *val2, long mask)
> +{
> +	struct afe4404_data *afe = iio_priv(indio_dev);
> +	const struct afe440x_reg_info reg_info = afe4404_reg_info[chan->address];
> +	int ret;
> +
> +	switch (chan->type) {
> +	case IIO_INTENSITY:
> +		switch (mask) {
> +		case IIO_CHAN_INFO_RAW:
> +			ret = regmap_read(afe->regmap, reg_info.reg, val);
> +			if (ret)
> +				return ret;
> +			return IIO_VAL_INT;
> +		case IIO_CHAN_INFO_OFFSET:
> +			ret = regmap_read(afe->regmap, reg_info.offreg,
> +					  val);
> +			if (ret)
> +				return ret;
> +			*val &= reg_info.mask;
> +			*val >>= reg_info.shift;
> +			return IIO_VAL_INT;
> +		}
> +		break;
> +	case IIO_CURRENT:
> +		switch (mask) {
> +		case IIO_CHAN_INFO_RAW:
> +			ret = regmap_read(afe->regmap, reg_info.reg, val);
> +			if (ret)
> +				return ret;
> +			*val &= reg_info.mask;
> +			*val >>= reg_info.shift;
> +			return IIO_VAL_INT;
> +		case IIO_CHAN_INFO_SCALE:
> +			*val = 0;
> +			*val2 = 800000;
> +			return IIO_VAL_INT_PLUS_MICRO;
> +		}
> +		break;
> +	default:
> +		break;
> +	}
> +
> +	return -EINVAL;
> +}
> +
> +static int afe4404_write_raw(struct iio_dev *indio_dev,
> +			     struct iio_chan_spec const *chan,
> +			     int val, int val2, long mask)
> +{
> +	struct afe4404_data *afe = iio_priv(indio_dev);
> +	const struct afe440x_reg_info reg_info = afe4404_reg_info[chan->address];
> +
> +	switch (chan->type) {
> +	case IIO_INTENSITY:
> +		switch (mask) {
> +		case IIO_CHAN_INFO_OFFSET:
> +			return regmap_update_bits(afe->regmap,
> +				reg_info.offreg,
> +				reg_info.mask,
> +				(val << reg_info.shift));
> +		}
> +		break;
> +	case IIO_CURRENT:
> +		switch (mask) {
> +		case IIO_CHAN_INFO_RAW:
> +			return regmap_update_bits(afe->regmap,
> +				reg_info.reg,
> +				reg_info.mask,
> +				(val << reg_info.shift));
> +		}
> +		break;
> +	default:
> +		break;
> +	}
> +
> +	return -EINVAL;
> +}
> +
> +static const struct iio_info afe4404_iio_info = {
> +	.attrs = &afe440x_attribute_group,
> +	.read_raw = afe4404_read_raw,
> +	.write_raw = afe4404_write_raw,
> +	.driver_module = THIS_MODULE,
> +};
> +
> +static irqreturn_t afe4404_trigger_handler(int irq, void *private)
> +{
> +	struct iio_poll_func *pf = private;
> +	struct iio_dev *indio_dev = pf->indio_dev;
> +	struct afe4404_data *afe = iio_priv(indio_dev);
> +	int ret, bit, i = 0;
> +	s32 buffer[10];
> +
> +	for_each_set_bit(bit, indio_dev->active_scan_mask,
> +			 indio_dev->masklength) {
> +		ret = regmap_read(afe->regmap, afe4404_reg_info[bit].reg,
> +				  &buffer[i++]);
> +		if (ret)
> +			goto err;
> +	}
> +
> +	iio_push_to_buffers_with_timestamp(indio_dev, buffer, pf->timestamp);
> +err:
> +	iio_trigger_notify_done(indio_dev->trig);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static const struct iio_trigger_ops afe4404_trigger_ops = {
> +	.owner = THIS_MODULE,
> +};
Hmm, no state control which is unusual.
> +
> +/* Default timings from data-sheet */
> +#define AFE4404_TIMING_PAIRS			\
> +	{ AFE440X_PRPCOUNT,	39999	},	\
> +	{ AFE440X_LED2LEDSTC,	0	},	\
> +	{ AFE440X_LED2LEDENDC,	398	},	\
> +	{ AFE440X_LED2STC,	80	},	\
> +	{ AFE440X_LED2ENDC,	398	},	\
> +	{ AFE440X_ADCRSTSTCT0,	5600	},	\
> +	{ AFE440X_ADCRSTENDCT0,	5606	},	\
> +	{ AFE440X_LED2CONVST,	5607	},	\
> +	{ AFE440X_LED2CONVEND,	6066	},	\
> +	{ AFE4404_LED3LEDSTC,	400	},	\
> +	{ AFE4404_LED3LEDENDC,	798	},	\
> +	{ AFE440X_ALED2STC,	480	},	\
> +	{ AFE440X_ALED2ENDC,	798	},	\
> +	{ AFE440X_ADCRSTSTCT1,	6068	},	\
> +	{ AFE440X_ADCRSTENDCT1,	6074	},	\
> +	{ AFE440X_ALED2CONVST,	6075	},	\
> +	{ AFE440X_ALED2CONVEND,	6534	},	\
> +	{ AFE440X_LED1LEDSTC,	800	},	\
> +	{ AFE440X_LED1LEDENDC,	1198	},	\
> +	{ AFE440X_LED1STC,	880	},	\
> +	{ AFE440X_LED1ENDC,	1198	},	\
> +	{ AFE440X_ADCRSTSTCT2,	6536	},	\
> +	{ AFE440X_ADCRSTENDCT2,	6542	},	\
> +	{ AFE440X_LED1CONVST,	6543	},	\
> +	{ AFE440X_LED1CONVEND,	7003	},	\
> +	{ AFE440X_ALED1STC,	1280	},	\
> +	{ AFE440X_ALED1ENDC,	1598	},	\
> +	{ AFE440X_ADCRSTSTCT3,	7005	},	\
> +	{ AFE440X_ADCRSTENDCT3,	7011	},	\
> +	{ AFE440X_ALED1CONVST,	7012	},	\
> +	{ AFE440X_ALED1CONVEND,	7471	},	\
> +	{ AFE440X_PDNCYCLESTC,	7671	},	\
> +	{ AFE440X_PDNCYCLEENDC,	39199	}
> +
> +static const struct reg_sequence afe4404_reg_sequences[] = {
> +	AFE4404_TIMING_PAIRS,
> +	{ AFE440X_CONTROL1, AFE440X_CONTROL1_TIMEREN },
> +	{ AFE4404_TIA_GAIN, AFE4404_TIA_GAIN_RES_50_K },
> +	{ AFE440X_LEDCNTRL, (0xf << AFE4404_LEDCNTRL_ILED1_SHIFT) |
> +			    (0x3 << AFE4404_LEDCNTRL_ILED2_SHIFT) |
> +			    (0x3 << AFE4404_LEDCNTRL_ILED3_SHIFT) },
> +	{ AFE440X_CONTROL2, AFE440X_CONTROL3_OSC_ENABLE	},
> +};
> +
> +static const struct regmap_range afe4404_yes_ranges[] = {
> +	regmap_reg_range(AFE440X_LED2VAL, AFE440X_LED1_ALED1VAL),
> +	regmap_reg_range(AFE4404_AVG_LED2_ALED2VAL, AFE4404_AVG_LED1_ALED1VAL),
> +};
> +
> +static const struct regmap_access_table afe4404_volatile_table = {
> +	.yes_ranges = afe4404_yes_ranges,
> +	.n_yes_ranges = ARRAY_SIZE(afe4404_yes_ranges),
> +};
> +
> +static const struct regmap_config afe4404_regmap_config = {
> +	.reg_bits = 8,
> +	.val_bits = 24,
> +
> +	.max_register = AFE4404_AVG_LED1_ALED1VAL,
> +	.cache_type = REGCACHE_RBTREE,
> +	.volatile_table = &afe4404_volatile_table,
> +};
> +
> +#ifdef CONFIG_OF
> +static const struct of_device_id afe4404_of_match[] = {
> +	{ .compatible = "ti,afe4404", },
> +	{ /* sentinel */ }
> +};
> +MODULE_DEVICE_TABLE(of, afe4404_of_match);
> +#endif
> +
> +static int afe4404_suspend(struct device *dev)
> +{
> +	struct iio_dev *indio_dev = dev_to_iio_dev(dev);
> +	struct afe4404_data *afe = iio_priv(indio_dev);
> +	int ret;
> +
> +	ret = regmap_update_bits(afe->regmap, AFE440X_CONTROL2,
> +				 AFE440X_CONTROL2_PDN_AFE,
> +				 AFE440X_CONTROL2_PDN_AFE);
> +	if (ret)
> +		return ret;
> +
> +	ret = regulator_disable(afe->regulator);
> +	if (ret) {
> +		dev_err(dev, "Unable to disable regulator\n");
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +static int afe4404_resume(struct device *dev)
> +{
> +	struct iio_dev *indio_dev = dev_to_iio_dev(dev);
> +	struct afe4404_data *afe = iio_priv(indio_dev);
> +	int ret;
> +
> +	ret = regulator_enable(afe->regulator);
> +	if (ret) {
> +		dev_err(dev, "Unable to enable regulator\n");
> +		return ret;
> +	}
> +
> +	ret = regmap_update_bits(afe->regmap, AFE440X_CONTROL2,
> +				 AFE440X_CONTROL2_PDN_AFE, 0);
> +	if (ret)
> +		return ret;
> +
> +	return 0;
> +}
> +
> +static SIMPLE_DEV_PM_OPS(afe4404_pm_ops, afe4404_suspend, afe4404_resume);
> +
Looking nice and clean in general - few bits not getting unwound in the
remove however.
> +static int afe4404_probe(struct i2c_client *client,
> +			 const struct i2c_device_id *id)
> +{
> +	struct iio_dev *indio_dev;
> +	struct afe4404_data *afe;
> +	int ret;
> +
> +	indio_dev = devm_iio_device_alloc(&client->dev, sizeof(*afe));
> +	if (!indio_dev)
> +		return -ENOMEM;
> +
> +	afe = iio_priv(indio_dev);
> +	i2c_set_clientdata(client, indio_dev);
> +
> +	afe->dev = &client->dev;
> +	afe->irq = client->irq;
> +
> +	afe->regmap = devm_regmap_init_i2c(client, &afe4404_regmap_config);
> +	if (IS_ERR(afe->regmap)) {
> +		dev_err(afe->dev, "Unable to allocate register map\n");
> +		return PTR_ERR(afe->regmap);
> +	}
> +
> +	afe->regulator = devm_regulator_get(afe->dev, "tx_sup");
> +	if (IS_ERR(afe->regulator)) {
> +		dev_err(afe->dev, "Unable to get regulator\n");
> +		return PTR_ERR(afe->regulator);
> +	}
> +	ret = regulator_enable(afe->regulator);
> +	if (ret) {
> +		dev_err(afe->dev, "Unable to enable regulator\n");
> +		return ret;
> +	}
> +
> +	ret = regmap_write(afe->regmap, AFE440X_CONTROL0,
> +			   AFE440X_CONTROL0_SW_RESET);
> +	if (ret) {
> +		dev_err(afe->dev, "Unable to reset device\n");
> +		return ret;
> +	}
> +
> +	ret = regmap_multi_reg_write(afe->regmap, afe4404_reg_sequences,
> +				     ARRAY_SIZE(afe4404_reg_sequences));
> +	if (ret) {
> +		dev_err(afe->dev, "Unable to set register defaults\n");
> +		return ret;
> +	}
> +
> +	indio_dev->modes = INDIO_DIRECT_MODE;
> +	indio_dev->dev.parent = afe->dev;
> +	indio_dev->channels = afe4404_channels;
> +	indio_dev->num_channels = ARRAY_SIZE(afe4404_channels);
> +	indio_dev->name = AFE4404_DRIVER_NAME;
> +	indio_dev->info = &afe4404_iio_info;
> +
> +	if (afe->irq > 0) {
> +		afe->trig = devm_iio_trigger_alloc(afe->dev,
> +						   "%s-dev%d",
> +						   indio_dev->name,
> +						   indio_dev->id);
> +		if (!afe->trig) {
> +			dev_err(afe->dev, "Unable to allocate IIO trigger\n");
> +			return -ENOMEM;
> +		}
> +
> +		iio_trigger_set_drvdata(afe->trig, indio_dev);
> +
> +		afe->trig->ops = &afe4404_trigger_ops;
> +		afe->trig->dev.parent = afe->dev;
> +
> +		ret = iio_trigger_register(afe->trig);
> +		if (ret) {
> +			dev_err(afe->dev, "Unable to register IIO trigger\n");
> +			return ret;
> +		}
> +
> +		ret = devm_request_threaded_irq(afe->dev, afe->irq,
> +						iio_trigger_generic_data_rdy_poll,
> +						NULL, IRQF_ONESHOT,
> +						AFE4404_DRIVER_NAME,
> +						afe->trig);
> +		if (ret) {
> +			dev_err(afe->dev, "Unable to request IRQ\n");
> +			return ret;
> +		}
> +	}
> +
> +	ret = iio_triggered_buffer_setup(indio_dev, &iio_pollfunc_store_time,
> +					 afe4404_trigger_handler, NULL);
> +	if (ret) {
> +		dev_err(afe->dev, "Unable to setup buffer\n");
> +		return ret;
> +	}
> +
> +	ret = iio_device_register(indio_dev);
> +	if (ret) {
> +		dev_err(afe->dev, "Unable to register IIO device\n");
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +static int afe4404_remove(struct i2c_client *client)
> +{
> +	struct iio_dev *indio_dev = i2c_get_clientdata(client);
> +	struct afe4404_data *afe = iio_priv(indio_dev);
> +	int ret;
> +
> +	iio_device_unregister(indio_dev);
> +
Would expect unwinding of the triggered_buffer here.
iio_triggered_buffer_cleanup()

> +	iio_trigger_unregister(afe->trig);
This should be protected by a check on afe->irq as for the register in probe.
There is no protection against afe->trig == NULL in iio_trigger_unregister.
That is kind of deliberate as it makes sure the probe / remove in drivers
are balanced unlike here.

> +
> +	ret = regulator_disable(afe->regulator);
> +	if (ret) {
> +		dev_err(afe->dev, "Unable to disable regulator\n");
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +static const struct i2c_device_id afe4404_ids[] = {
> +	{ "afe4404", 0 },
> +	{ /* sentinel */ }
> +};
> +MODULE_DEVICE_TABLE(i2c, afe4404_ids);
> +
> +static struct i2c_driver afe4404_i2c_driver = {
> +	.driver = {
> +		.name = AFE4404_DRIVER_NAME,
> +		.of_match_table = of_match_ptr(afe4404_of_match),
> +		.pm = &afe4404_pm_ops,
> +	},
> +	.probe = afe4404_probe,
> +	.remove = afe4404_remove,
> +	.id_table = afe4404_ids,
> +};
> +module_i2c_driver(afe4404_i2c_driver);
> +
> +MODULE_AUTHOR("Andrew F. Davis <afd-l0cyMroinI0@public.gmane.org>");
> +MODULE_DESCRIPTION("TI AFE4404 Heart Rate and Pulse Oximeter");
> +MODULE_LICENSE("GPL v2");
> diff --git a/drivers/iio/health/afe440x.h b/drivers/iio/health/afe440x.h
> new file mode 100644
> index 0000000..9641653
> --- /dev/null
> +++ b/drivers/iio/health/afe440x.h
> @@ -0,0 +1,193 @@
> +/*
> + * AFE440X Heart Rate Monitors and Low-Cost Pulse Oximeters
> + *
> + * Copyright (C) 2015 Texas Instruments Incorporated - http://www.ti.com/
> + *	Andrew F. Davis <afd-l0cyMroinI0@public.gmane.org>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful, but
> + * WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * General Public License for more details.
> + */
> +
> +#ifndef _AFE440X_H
> +#define _AFE440X_H
> +
> +/* AFE440X registers */
> +#define AFE440X_CONTROL0		0x00
> +#define AFE440X_LED2STC			0x01
> +#define AFE440X_LED2ENDC		0x02
> +#define AFE440X_LED1LEDSTC		0x03
> +#define AFE440X_LED1LEDENDC		0x04
> +#define AFE440X_ALED2STC		0x05
> +#define AFE440X_ALED2ENDC		0x06
> +#define AFE440X_LED1STC			0x07
> +#define AFE440X_LED1ENDC		0x08
> +#define AFE440X_LED2LEDSTC		0x09
> +#define AFE440X_LED2LEDENDC		0x0a
> +#define AFE440X_ALED1STC		0x0b
> +#define AFE440X_ALED1ENDC		0x0c
> +#define AFE440X_LED2CONVST		0x0d
> +#define AFE440X_LED2CONVEND		0x0e
> +#define AFE440X_ALED2CONVST		0x0f
> +#define AFE440X_ALED2CONVEND		0x10
> +#define AFE440X_LED1CONVST		0x11
> +#define AFE440X_LED1CONVEND		0x12
> +#define AFE440X_ALED1CONVST		0x13
> +#define AFE440X_ALED1CONVEND		0x14
> +#define AFE440X_ADCRSTSTCT0		0x15
> +#define AFE440X_ADCRSTENDCT0		0x16
> +#define AFE440X_ADCRSTSTCT1		0x17
> +#define AFE440X_ADCRSTENDCT1		0x18
> +#define AFE440X_ADCRSTSTCT2		0x19
> +#define AFE440X_ADCRSTENDCT2		0x1a
> +#define AFE440X_ADCRSTSTCT3		0x1b
> +#define AFE440X_ADCRSTENDCT3		0x1c
> +#define AFE440X_PRPCOUNT		0x1d
> +#define AFE440X_CONTROL1		0x1e
> +#define AFE440X_LEDCNTRL		0x22
> +#define AFE440X_CONTROL2		0x23
> +#define AFE440X_ALARM			0x29
> +#define AFE440X_LED2VAL			0x2a
> +#define AFE440X_ALED2VAL		0x2b
> +#define AFE440X_LED1VAL			0x2c
> +#define AFE440X_ALED1VAL		0x2d
> +#define AFE440X_LED2_ALED2VAL		0x2e
> +#define AFE440X_LED1_ALED1VAL		0x2f
> +#define AFE440X_CONTROL3		0x31
> +#define AFE440X_PDNCYCLESTC		0x32
> +#define AFE440X_PDNCYCLEENDC		0x33
> +
> +/* CONTROL0 register fields */
> +#define AFE440X_CONTROL0_REG_READ	BIT(0)
> +#define AFE440X_CONTROL0_TM_COUNT_RST	BIT(1)
> +#define AFE440X_CONTROL0_SW_RESET	BIT(3)
> +
> +/* CONTROL1 register fields */
> +#define AFE440X_CONTROL1_TIMEREN	BIT(8)
> +
> +/* TIAGAIN register fields */
> +#define AFE440X_TIAGAIN_ENSEPGAIN_MASK	BIT(15)
> +#define AFE440X_TIAGAIN_ENSEPGAIN_SHIFT	15
> +
> +/* CONTROL2 register fields */
> +#define AFE440X_CONTROL2_PDN_AFE	BIT(0)
> +#define AFE440X_CONTROL2_PDN_RX		BIT(1)
> +#define AFE440X_CONTROL2_DYNAMIC4	BIT(3)
> +#define AFE440X_CONTROL2_DYNAMIC3	BIT(4)
> +#define AFE440X_CONTROL2_DYNAMIC2	BIT(14)
> +#define AFE440X_CONTROL2_DYNAMIC1	BIT(20)
> +
> +/* CONTROL3 register fields */
> +#define AFE440X_CONTROL3_CLKDIV		GENMASK(2, 0)
> +
> +/* CONTROL0 values */
> +#define AFE440X_CONTROL0_WRITE		0x0
> +#define AFE440X_CONTROL0_READ		0x1
> +
> +struct afe440x_reg_info {
> +	unsigned int reg;
> +	unsigned int offreg;
> +	unsigned int shift;
> +	unsigned int mask;
> +};
> +
> +#define AFE440X_REG_INFO(_id, _reg, _offreg, _sm)		\
> +	[_id] = {						\
> +		.reg = _reg,					\
> +		.offreg = _offreg,				\
> +		.shift = _sm ## _SHIFT,				\
> +		.mask = _sm ## _MASK,				\
> +	}
I'm not overly keen on the hiding fo the indexing.  I'd prefer
this was just the bit {...} and you had the fact it was filling in an
indexed element explicit where used.
> +
> +#define AFE440X_INTENSITY_CHAN(_index, _name, _mask)		\
> +	{							\
> +		.type = IIO_INTENSITY,				\
> +		.channel = _index,				\
> +		.address = _index,				\
> +		.scan_index = _index,				\
> +		.scan_type = {					\
> +				.sign = 's',			\
> +				.realbits = 24,			\
> +				.storagebits = 32,		\
> +				.endianness = IIO_CPU,		\
> +		},						\
> +		.extend_name = _name,				\
> +		.info_mask_separate = BIT(IIO_CHAN_INFO_RAW) |	\
> +			_mask,					\
> +	}
> +
> +#define AFE440X_CURRENT_CHAN(_index, _name)			\
> +	{							\
> +		.type = IIO_CURRENT,				\
> +		.channel = _index,				\
> +		.address = _index,				\
> +		.scan_index = _index,				\
> +		.extend_name = _name,				\
> +		.info_mask_separate = BIT(IIO_CHAN_INFO_RAW) |	\
> +			BIT(IIO_CHAN_INFO_SCALE),		\
> +		.output = true,					\
> +	}
> +

I'd prefix reg_type to avoid possible name clashes in future.
> +enum reg_type {
> +	SIMPLE,
> +	RESISTANCE,
> +	CAPACITANCE,
> +};
> +
> +/* this could be made more general for other IIO drivers if needed --------- */

Yes, but lets do that at as a follow up.

> +struct afe440x_val_table {
> +	int integer;
> +	int fract;
> +};
> +
> +#define AFE440X_TABLE_ATTR(_name, _table)				\
> +static ssize_t _name ## _show(struct device *dev,			\
> +			      struct device_attribute *attr, char *buf)	\
> +{									\
> +	ssize_t len = 0;						\
> +	int i;								\
> +									\
> +	for (i = 0; i < ARRAY_SIZE(_table); i++)			\
> +		len += scnprintf(buf + len, PAGE_SIZE - len, "%d.%06u ", \
> +				 _table[i].integer,			\
> +				 _table[i].fract);			\
> +									\
> +	buf[len - 1] = '\n';						\
> +									\
> +	return len;							\
> +}									\
> +static DEVICE_ATTR_RO(_name)
> +/* ------------------------------------------------------------------------- */
> +
> +struct afe440x_attr {
> +	struct device_attribute dev_attr;
> +	unsigned int reg;
> +	unsigned int shift;
> +	unsigned int mask;
> +	enum reg_type type;
> +	const struct afe440x_val_table *val_table;
> +	unsigned int table_size;
> +};
> +
> +#define to_afe440x_attr(_dev_attr)				\
> +	container_of(_dev_attr, struct afe440x_attr, dev_attr)
> +
> +#define AFE440X_ATTR(_name, _reg, _field, _type, _table, _size)	\
> +	struct afe440x_attr afe440x_attr_##_name = {		\
> +		.dev_attr = __ATTR(_name, (S_IRUGO | S_IWUSR),	\
> +				   afe440x_show_register,	\
> +				   afe440x_store_register),	\
> +		.reg = _reg,					\
> +		.shift = _field ## _SHIFT,			\
> +		.mask = _field ## _MASK,			\
> +		.type = _type,					\
> +		.val_table = _table,				\
> +		.table_size = _size,				\
> +	}
> +
> +#endif /* _AFE440X_H */
> 
