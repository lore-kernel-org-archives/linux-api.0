From: Jonathan Cameron <jic23-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 5/5] iio: health: Add driver for the TI AFE4403 heart
 monitor
Date: Tue, 22 Dec 2015 17:59:56 +0000
Message-ID: <56798F9C.8020304@kernel.org>
References: <1450132561-5245-1-git-send-email-afd@ti.com>
 <1450132561-5245-6-git-send-email-afd@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1450132561-5245-6-git-send-email-afd-l0cyMroinI0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Andrew F. Davis" <afd-l0cyMroinI0@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Hartmut Knaack <knaack.h-Mmb7MZpHnFY@public.gmane.org>, Lars-Peter Clausen <lars-Qo5EllUWu/uELgA04lAiVw@public.gmane.org>, Peter Meerwald <pmeerw-jW+XmwGofnusTnJN9+BGXg@public.gmane.org>
Cc: devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-iio-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 14/12/15 22:36, Andrew F. Davis wrote:
> Add driver for the TI AFE4403 heart rate monitor and pulse oximeter.
> This device detects reflected LED light fluctuations and presents an ADC
> value to the user space for further signal processing.
> 
> Data sheet located here:
> http://www.ti.com/product/AFE4403/datasheet
> 
> Signed-off-by: Andrew F. Davis <afd-l0cyMroinI0@public.gmane.org>
I assume the plan is to break some of this out into a common shared
'helper' module for the two drivers?   You will probably want
to do that before we merge either of them.  Again, doesn't look like
it will be a big job as you just have cut and paste functions in
here (I think!)

I also picked up on a lack of locking around read update pairs
that I'd missed in reviewing the 4404 driver. Please fix it there
as well.

Otherwise a few spi specific bits inline and as you expect
the comments from one driver mostly apply to the other as well
(in both directions!)
> ---
>  .../ABI/testing/sysfs-bus-iio-health-afe4403       |  52 ++
>  drivers/iio/health/Kconfig                         |  12 +
>  drivers/iio/health/Makefile                        |   1 +
>  drivers/iio/health/afe4403.c                       | 696 +++++++++++++++++++++
>  4 files changed, 761 insertions(+)
>  create mode 100644 Documentation/ABI/testing/sysfs-bus-iio-health-afe4403
>  create mode 100644 drivers/iio/health/afe4403.c
> 
> diff --git a/Documentation/ABI/testing/sysfs-bus-iio-health-afe4403 b/Documentation/ABI/testing/sysfs-bus-iio-health-afe4403
> new file mode 100644
> index 0000000..325efcb
> --- /dev/null
> +++ b/Documentation/ABI/testing/sysfs-bus-iio-health-afe4403
> @@ -0,0 +1,52 @@
> +What:		/sys/bus/iio/devices/iio:deviceX/tia_resistanceY
> +		/sys/bus/iio/devices/iio:deviceX/tia_capacitanceY
> +Date:		December 2015
> +KernelVersion:
> +Contact:	Andrew F. Davis <afd-l0cyMroinI0@public.gmane.org>
> +Description:
> +		Get and set the resistance and the capacitance settings for the
> +		Transimpedance Amplifier. Y is 1 for Rf1 and Cf1, Y is 2 for
> +		Rf2 and Cf2 values.
> +		Valid Resistance settings are 500000, 250000, 100000, 50000,
> +		25000, 10000, 1000000, and 0 Ohms.
> +		Valid capacitance settings are 5, 10, 20, 25, 30, 35, 45, 50, 55,
> +		60, 70, 75, 80, 85, 95, 100, 155, 160, 170, 175, 180, 185, 195,
> +		200, 205, 210, 220, 225, 230, 235, 245, and 250 picoFarads.
Given we have two devices with very similar ABI up to the values, I'd
suggest providing *_available attributes so these can be queried from
userspace and you can create a single ABI document covering the two drivers.
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
> +What:		/sys/bus/iio/devices/iio:deviceX/out_current_ledY_raw
> +Date:		December 2015
> +KernelVersion:
> +Contact:	Andrew F. Davis <afd-l0cyMroinI0@public.gmane.org>
> +Description:
> +		Get and set the LED current for the specified LED. Y is the
> +		specific LED number.
> +		Values range from 0 -> 255. Current is calculated by
> +		current = (value / 256) * 50mA
This level of detail is exposed anyway in the userspace interface, so I
would not expect it to be explicitly mentioned here.  Without this I 'think'
we can combine this with the docs for the afe4404.

> diff --git a/drivers/iio/health/Kconfig b/drivers/iio/health/Kconfig
> index 526e7af..e338df4 100644
> --- a/drivers/iio/health/Kconfig
> +++ b/drivers/iio/health/Kconfig
> @@ -7,6 +7,18 @@ menu "Health"
>  
>  menu "Heart Rate Monitors"
>  
> +config AFE4403
> +	tristate "TI AFE4403 Heart Rate Monitor"
> +	depends on SPI_MASTER
> +	select IIO_BUFFER
> +	select IIO_TRIGGERED_BUFFER
> +	help
> +	  Say yes to choose the Texas Instruments AFE4403
> +	  heart rate monitor and low-cost pulse oximeter.
> +
> +	  To compile this driver as a module, choose M here: the
> +	  module will be called afe4403.
> +
>  config AFE4404
>  	tristate "TI AFE4404 Heart Rate Monitor"
>  	depends on I2C
> diff --git a/drivers/iio/health/Makefile b/drivers/iio/health/Makefile
> index c108c8d..81822ad 100644
> --- a/drivers/iio/health/Makefile
> +++ b/drivers/iio/health/Makefile
> @@ -3,4 +3,5 @@
>  #
>  # When adding new entries keep the list in alphabetical order
>  
> +obj-$(CONFIG_AFE4403) += afe4403.o
>  obj-$(CONFIG_AFE4404) += afe4404.o
> diff --git a/drivers/iio/health/afe4403.c b/drivers/iio/health/afe4403.c
> new file mode 100644
> index 0000000..551bc8b
> --- /dev/null
> +++ b/drivers/iio/health/afe4403.c
> @@ -0,0 +1,696 @@
> +/*
> + * AFE4403 Heart Rate Monitors and Low-Cost Pulse Oximeters
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
> +#include <linux/delay.h>
> +#include <linux/err.h>
> +#include <linux/interrupt.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/of_gpio.h>
> +#include <linux/regmap.h>
> +#include <linux/spi/spi.h>
> +#include <linux/slab.h>
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
> +#define AFE4403_DRIVER_NAME		"afe4403"
> +
> +/* AFE4403 Registers */
> +#define AFE4403_TIAGAIN			0x20
> +#define AFE4403_TIA_AMB_GAIN		0x21
> +
> +/* AFE4403 GAIN register fields */
> +#define AFE4403_TIAGAIN_RES_MASK	GENMASK(2, 0)
> +#define AFE4403_TIAGAIN_RES_SHIFT	0
> +#define AFE4403_TIAGAIN_CAP_MASK	GENMASK(7, 3)
> +#define AFE4403_TIAGAIN_CAP_SHIFT	3
> +
> +/* AFE4403 LEDCNTRL register fields */
> +#define AFE4403_LEDCNTRL_LED1_MASK		GENMASK(15, 8)
> +#define AFE4403_LEDCNTRL_LED1_SHIFT		8
> +#define AFE4403_LEDCNTRL_LED2_MASK		GENMASK(7, 0)
> +#define AFE4403_LEDCNTRL_LED2_SHIFT		0
> +#define AFE4403_LEDCNTRL_LED_RANGE_MASK		GENMASK(17, 16)
> +#define AFE4403_LEDCNTRL_LED_RANGE_SHIFT	16
> +
> +/* AFE4403 CONTROL2 register fields */
> +#define AFE4403_CONTROL2_PWR_DWN_TX	BIT(2)
> +#define AFE4403_CONTROL2_EN_SLOW_DIAG	BIT(8)
> +#define AFE4403_CONTROL2_DIAG_OUT_TRI	BIT(10)
> +#define AFE4403_CONTROL2_TX_BRDG_MOD	BIT(11)
> +#define AFE4403_CONTROL2_TX_REF_MASK	GENMASK(18, 17)
> +#define AFE4403_CONTROL2_TX_REF_SHIFT	17
> +
> +/* AFE4404 NULL fields */
> +#define NULL_MASK	0
> +#define NULL_SHIFT	0
> +
> +/* AFE4403 LEDCNTRL values */
> +#define AFE4403_LEDCNTRL_RANGE_TX_HALF	0x1
> +#define AFE4403_LEDCNTRL_RANGE_TX_FULL	0x2
> +#define AFE4403_LEDCNTRL_RANGE_TX_OFF	0x3
> +
> +/* AFE4403 CONTROL2 values */
> +#define AFE4403_CONTROL2_TX_REF_025	0x0
> +#define AFE4403_CONTROL2_TX_REF_050	0x1
> +#define AFE4403_CONTROL2_TX_REF_100	0x2
> +#define AFE4403_CONTROL2_TX_REF_075	0x3
> +
> +/* AFE4403 CONTROL3 values */
> +#define AFE4403_CONTROL3_CLK_DIV_2	0x0
> +#define AFE4403_CONTROL3_CLK_DIV_4	0x2
> +#define AFE4403_CONTROL3_CLK_DIV_6	0x3
> +#define AFE4403_CONTROL3_CLK_DIV_8	0x4
> +#define AFE4403_CONTROL3_CLK_DIV_12	0x5
> +#define AFE4403_CONTROL3_CLK_DIV_1	0x7
> +
> +/* AFE4403 TIAGAIN_CAP values */
> +#define AFE4403_TIAGAIN_CAP_5_P		0x0
> +#define AFE4403_TIAGAIN_CAP_10_P	0x1
> +#define AFE4403_TIAGAIN_CAP_20_P	0x2
> +#define AFE4403_TIAGAIN_CAP_30_P	0x3
> +#define AFE4403_TIAGAIN_CAP_55_P	0x8
> +#define AFE4403_TIAGAIN_CAP_155_P	0x10
> +
> +/* AFE4403 TIAGAIN_RES values */
> +#define AFE4403_TIAGAIN_RES_500_K	0x0
> +#define AFE4403_TIAGAIN_RES_250_K	0x1
> +#define AFE4403_TIAGAIN_RES_100_K	0x2
> +#define AFE4403_TIAGAIN_RES_50_K	0x3
> +#define AFE4403_TIAGAIN_RES_25_K	0x4
> +#define AFE4403_TIAGAIN_RES_10_K	0x5
> +#define AFE4403_TIAGAIN_RES_1_M		0x6
> +#define AFE4403_TIAGAIN_RES_NONE	0x7
> +
> +enum afe4403_chan_id {
> +	LED1,
> +	ALED1,
> +	LED2,
> +	ALED2,
> +	LED1_ALED1,
> +	LED2_ALED2,
> +	ILED1,
> +	ILED2,
> +};
> +
> +static const struct afe440x_reg_info reg_info[] = {
> +	AFE440X_REG_INFO(LED1, AFE440X_LED1VAL, 0, NULL),
> +	AFE440X_REG_INFO(ALED1, AFE440X_ALED1VAL, 0, NULL),
> +	AFE440X_REG_INFO(LED2, AFE440X_LED2VAL, 0, NULL),
> +	AFE440X_REG_INFO(ALED2, AFE440X_ALED2VAL, 0, NULL),
> +	AFE440X_REG_INFO(LED1_ALED1, AFE440X_LED1_ALED1VAL, 0, NULL),
> +	AFE440X_REG_INFO(LED2_ALED2, AFE440X_LED2_ALED2VAL, 0, NULL),
> +	AFE440X_REG_INFO(ILED1, AFE440X_LEDCNTRL, 0, AFE4403_LEDCNTRL_LED1),
> +	AFE440X_REG_INFO(ILED2, AFE440X_LEDCNTRL, 0, AFE4403_LEDCNTRL_LED2),
> +};
> +
> +static const struct iio_chan_spec afe4403_channels[] = {
> +	/* ADC values */
> +	AFE440X_INTENSITY_CHAN(LED1, "led1", 0),
> +	AFE440X_INTENSITY_CHAN(ALED1, "led1_ambient", 0),
> +	AFE440X_INTENSITY_CHAN(LED2, "led2", 0),
> +	AFE440X_INTENSITY_CHAN(ALED2, "led2_ambient", 0),
> +	AFE440X_INTENSITY_CHAN(LED1_ALED1, "led1-led1_ambient", 0),
> +	AFE440X_INTENSITY_CHAN(LED2_ALED2, "led2-led2_ambient", 0),
> +	/* LED current */
> +	AFE440X_CURRENT_CHAN(ILED1, "led1"),
> +	AFE440X_CURRENT_CHAN(ILED2, "led2"),
> +};
> +
> +static const struct afe440x_reg_lookup afe4403_res_table[] = {
> +	{ 500000 }, { 250000 }, { 100000 }, { 50000 },
> +	{ 25000 }, { 10000 }, { 1000000 }, { 0 },
> +};
> +
> +static const struct afe440x_reg_lookup afe4403_cap_table[] = {
> +	{ 5 }, { 10 }, { 20 }, { 25 }, { 30 }, { 35 }, { 45 },
> +	{ 50 }, { 55 }, { 60 }, { 70 }, { 75 }, { 80 }, { 85 },
> +	{ 95 }, { 100 }, { 155 }, { 160 }, { 170 }, { 175 }, { 180 },
> +	{ 185 }, { 195 }, { 200 }, { 205 }, { 210 }, { 220 }, { 225 },
> +	{ 230 }, { 235 }, { 245 }, { 250 },
> +};
> +
> +static ssize_t afe440x_show_register(struct device *dev,
> +				     struct device_attribute *attr,
> +				     char *buf)
> +{
> +	struct iio_dev *indio_dev = dev_to_iio_dev(dev);
> +	struct afe440x_data *afe440x = iio_device_get_drvdata(indio_dev);
> +	struct afe440x_attr *afe440x_attr = to_afe440x_attr(attr);
> +	unsigned int reg_val, type;
> +	int vals[2];
> +	int ret, val_len;
> +
> +	ret = regmap_read(afe440x->regmap, afe440x_attr->reg, &reg_val);
> +	if (ret)
> +		return ret;
> +
> +	reg_val >>= afe440x_attr->shift;
> +	reg_val &= afe440x_attr->mask;
> +
> +	switch (afe440x_attr->type) {
> +	case SIMPLE:
> +		type = IIO_VAL_INT;
> +		val_len = 1;
> +		vals[0] = reg_val;
> +		break;
> +	case RESISTANCE:
> +		type = IIO_VAL_INT_PLUS_MICRO;
> +		val_len = 2;
> +		if (reg_val < ARRAY_SIZE(afe4403_res_table)) {
> +			vals[0] = afe4403_res_table[reg_val].integer;
> +			vals[1] = afe4403_res_table[reg_val].fract;
> +			break;
> +		}
> +		return -EINVAL;
> +	case CAPACITANCE:
> +		type = IIO_VAL_INT_PLUS_MICRO;
> +		val_len = 2;
> +		if (reg_val < ARRAY_SIZE(afe4403_cap_table)) {
> +			vals[0] = afe4403_cap_table[reg_val].integer;
> +			vals[1] = afe4403_cap_table[reg_val].fract;
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
> +	struct afe440x_data *afe440x = iio_device_get_drvdata(indio_dev);
> +	struct afe440x_attr *afe440x_attr = to_afe440x_attr(attr);
> +	unsigned int reg_val;
> +	int val, integer, fract, ret;
> +
> +	ret = iio_str_to_fixpoint(buf, 100000, &integer, &fract);
> +	if (ret)
> +		return ret;
> +
Probably want locking in here as well as again no guarantees exist
on serializing these function calls.
> +	ret = regmap_read(afe440x->regmap, afe440x_attr->reg, &reg_val);
> +	if (ret)
> +		return ret;
> +
> +	switch (afe440x_attr->type) {
> +	case SIMPLE:
> +		val = integer;
> +		break;
> +	case RESISTANCE:
> +		for (val = 0; val < ARRAY_SIZE(afe4403_res_table); val++)
> +			if (afe4403_res_table[val].integer == integer &&
> +			    afe4403_res_table[val].fract == fract)
> +				break;
> +		if (val == ARRAY_SIZE(afe4403_res_table))
> +			return -EINVAL;
> +		break;
> +	case CAPACITANCE:
> +		for (val = 0; val < ARRAY_SIZE(afe4403_cap_table); val++)
> +			if (afe4403_cap_table[val].integer == integer &&
> +			    afe4403_cap_table[val].fract == fract)
> +				break;
> +		if (val == ARRAY_SIZE(afe4403_cap_table))
> +			return -EINVAL;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	reg_val &= ~afe440x_attr->mask;
> +	reg_val |= ((val << afe440x_attr->shift) & afe440x_attr->mask);
> +
> +	ret = regmap_write(afe440x->regmap, afe440x_attr->reg, reg_val);
> +	if (ret)
> +		return ret;
> +
> +	return count;
> +}
> +
> +static AFE440X_ATTR(tia_separate_en, AFE4403_TIAGAIN, AFE440X_TIAGAIN_ENSEPGAIN, SIMPLE);
> +
> +static AFE440X_ATTR(tia_resistance1, AFE4403_TIAGAIN, AFE4403_TIAGAIN_RES, RESISTANCE);
> +static AFE440X_ATTR(tia_capacitance1, AFE4403_TIAGAIN, AFE4403_TIAGAIN_CAP, CAPACITANCE);
> +
> +static AFE440X_ATTR(tia_resistance2, AFE4403_TIA_AMB_GAIN, AFE4403_TIAGAIN_RES, RESISTANCE);
> +static AFE440X_ATTR(tia_capacitance2, AFE4403_TIA_AMB_GAIN, AFE4403_TIAGAIN_RES, CAPACITANCE);
> +
> +static struct attribute *afe440x_attributes[] = {
> +	&afe440x_attr_tia_separate_en.dev_attr.attr,
> +	&afe440x_attr_tia_resistance1.dev_attr.attr,
> +	&afe440x_attr_tia_capacitance1.dev_attr.attr,
> +	&afe440x_attr_tia_resistance2.dev_attr.attr,
> +	&afe440x_attr_tia_capacitance2.dev_attr.attr,
> +	NULL
> +};
> +
> +static const struct attribute_group afe440x_attribute_group = {
> +	.attrs = afe440x_attributes
> +};
> +
> +static int afe440x_read_raw(struct iio_dev *indio_dev,
> +			    struct iio_chan_spec const *chan,
> +			    int *val, int *val2, long mask)
> +{
> +	struct afe440x_data *afe440x = iio_device_get_drvdata(indio_dev);
> +	int ret;
> +
> +	switch (chan->type) {
> +	case IIO_INTENSITY:
> +		switch (mask) {
> +		case IIO_CHAN_INFO_RAW:
> +			ret = regmap_read(afe440x->regmap,
> +					  reg_info[chan->address].reg, val);
> +			if (ret)
> +				return ret;
> +			return IIO_VAL_INT;
> +		case IIO_CHAN_INFO_OFFSET:
> +			ret = regmap_read(afe440x->regmap,
> +					  reg_info[chan->address].offreg, val);
> +			if (ret)
> +				return ret;
> +			*val &= reg_info[chan->address].mask;
> +			*val >>= reg_info[chan->address].shift;
> +			return IIO_VAL_INT;
> +		}
> +		break;
> +	case IIO_CURRENT:
> +		switch (mask) {
> +		case IIO_CHAN_INFO_RAW:
> +			ret = regmap_read(afe440x->regmap,
> +					  reg_info[chan->address].reg, val);
> +			if (ret)
> +				return ret;
> +			*val &= reg_info[chan->address].mask;
> +			*val >>= reg_info[chan->address].shift;
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
> +static int afe440x_write_raw(struct iio_dev *indio_dev,
> +			     struct iio_chan_spec const *chan,
> +			     int val, int val2, long mask)
> +{
> +	struct afe440x_data *afe440x = iio_device_get_drvdata(indio_dev);
> +	unsigned int reg_val;
> +	int ret;
> +
> +	switch (chan->type) {
> +	case IIO_INTENSITY:
> +		switch (mask) {
> +		case IIO_CHAN_INFO_OFFSET:
I missed this entirely in the other driver, but you want some
locking around the read / write pairs (a local mutex in your
struct afe440x_data would be the conventional means of doing this).
There is no serialization of sysfs operations so you can have
more than one process causing these to happen at the same time.

> +			ret = regmap_read(afe440x->regmap,
> +					  reg_info[chan->address].offreg,
> +					  &reg_val);
> +			if (ret)
> +				return ret;
> +			reg_val &= ~reg_info[chan->address].mask;
> +			reg_val |= ((val << reg_info[chan->address].shift) &
> +					reg_info[chan->address].mask);
> +			return regmap_write(afe440x->regmap,
> +					    reg_info[chan->address].offreg,
> +					    reg_val);
> +		}
> +		break;
> +	case IIO_CURRENT:
> +		switch (mask) {
> +		case IIO_CHAN_INFO_RAW:
> +			ret = regmap_read(afe440x->regmap,
> +					  reg_info[chan->address].reg,
> +					  &reg_val);
> +			if (ret)
> +				return ret;
> +			reg_val &= ~reg_info[chan->address].mask;
> +			reg_val |= ((val << reg_info[chan->address].shift) &
> +					reg_info[chan->address].mask);
> +			return regmap_write(afe440x->regmap,
> +					    reg_info[chan->address].reg,
> +					    reg_val);
> +		}
> +		break;
> +	default:
> +		break;
> +	}
> +
> +	return -EINVAL;
> +}
> +
> +static const struct iio_info afe440x_iio_info = {
> +	.attrs = &afe440x_attribute_group,
> +	.read_raw = afe440x_read_raw,
> +	.write_raw = afe440x_write_raw,
> +	.driver_module = THIS_MODULE,
> +};
> +
> +static irqreturn_t afe440x_trigger_handler(int irq, void *private)
> +{
> +	struct iio_poll_func *pf = private;
> +	struct iio_dev *indio_dev = pf->indio_dev;
> +	struct afe440x_data *afe440x = iio_device_get_drvdata(indio_dev);
> +	int ret, bit, i = 0;
> +	s32 buffer[12];
> +	u8 tx[4] = {AFE440X_CONTROL0, 0x0, 0x0, AFE440X_CONTROL0_READ};
> +	u8 rx[3];
> +
> +	/* Enable reading from the device */
> +	ret = spi_write(afe440x->spi, tx, 4);
See rules for spi buffers. They have to be cacheline_aligned.
I'd do the standard trick to add them to your afe440x_data
structure and force them to start on a new cacheline.  Alternative
is to allocate and free everytime this function is called.

Right now you'll get corruption on some / many SPI controllers
that are doing DMA from time to time as other data will be in
in the same cacheline.
> +	if (ret)
> +		goto err;
> +
> +	for_each_set_bit(bit, indio_dev->active_scan_mask,
> +			 indio_dev->masklength) {
> +		ret = spi_write_then_read(afe440x->spi,
> +					  &reg_info[bit].reg, 1, rx, 3);
Interestingly write_then_read (IIRC) uses bounce buffers to avoid
the need to ensure cacheline alignment of buffers within drivers..

> +		if (ret)
> +			goto err;
> +
> +		buffer[i++] = (rx[0] << 16) |
> +				(rx[1] << 8) |
> +				(rx[2]);
> +	}
> +
> +	/* Disable reading from the device */
> +	tx[3] = AFE440X_CONTROL0_WRITE;
> +	ret = spi_write(afe440x->spi, tx, 4);
> +	if (ret)
> +		goto err;
> +
> +	iio_push_to_buffers_with_timestamp(indio_dev, buffer, pf->timestamp);
> +err:
> +	iio_trigger_notify_done(indio_dev->trig);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static const struct iio_trigger_ops afe440x_trigger_ops = {
> +	.owner = THIS_MODULE,
> +};
> +
> +#define AFE4403_TIMING_PAIRS			\
> +	{ AFE440X_LED2STC,	0x000050 },	\
> +	{ AFE440X_LED2ENDC,	0x0003e7 },	\
> +	{ AFE440X_LED1LEDSTC,	0x0007d0 },	\
> +	{ AFE440X_LED1LEDENDC,	0x000bb7 },	\
> +	{ AFE440X_ALED2STC,	0x000438 },	\
> +	{ AFE440X_ALED2ENDC,	0x0007cf },	\
> +	{ AFE440X_LED1STC,	0x000820 },	\
> +	{ AFE440X_LED1ENDC,	0x000bb7 },	\
> +	{ AFE440X_LED2LEDSTC,	0x000000 },	\
> +	{ AFE440X_LED2LEDENDC,	0x0003e7 },	\
> +	{ AFE440X_ALED1STC,	0x000c08 },	\
> +	{ AFE440X_ALED1ENDC,	0x000f9f },	\
> +	{ AFE440X_LED2CONVST,	0x0003ef },	\
> +	{ AFE440X_LED2CONVEND,	0x0007cf },	\
> +	{ AFE440X_ALED2CONVST,	0x0007d7 },	\
> +	{ AFE440X_ALED2CONVEND,	0x000bb7 },	\
> +	{ AFE440X_LED1CONVST,	0x000bbf },	\
> +	{ AFE440X_LED1CONVEND,	0x009c3f },	\
> +	{ AFE440X_ALED1CONVST,	0x000fa7 },	\
> +	{ AFE440X_ALED1CONVEND,	0x001387 },	\
> +	{ AFE440X_ADCRSTSTCT0,	0x0003e8 },	\
> +	{ AFE440X_ADCRSTENDCT0,	0x0003eb },	\
> +	{ AFE440X_ADCRSTSTCT1,	0x0007d0 },	\
> +	{ AFE440X_ADCRSTENDCT1,	0x0007d3 },	\
> +	{ AFE440X_ADCRSTSTCT2,	0x000bb8 },	\
> +	{ AFE440X_ADCRSTENDCT2,	0x000bbb },	\
> +	{ AFE440X_ADCRSTSTCT3,	0x000fa0 },	\
> +	{ AFE440X_ADCRSTENDCT3,	0x000fa3 },	\
> +	{ AFE440X_PRPCOUNT,	0x009c3f },	\
> +	{ AFE440X_PDNCYCLESTC,	0x001518 },	\
> +	{ AFE440X_PDNCYCLEENDC,	0x00991f }
> +
> +static const struct reg_sequence afe4403_reg_sequences[] = {
> +	AFE4403_TIMING_PAIRS,
> +	{ AFE440X_CONTROL1, AFE440X_CONTROL1_TIMEREN | 0x000007},
> +	{ AFE4403_TIA_AMB_GAIN, AFE4403_TIAGAIN_RES_1_M },
> +	{ AFE440X_LEDCNTRL, (0x14 << AFE4403_LEDCNTRL_LED1_SHIFT) |
> +			    (0x14 << AFE4403_LEDCNTRL_LED2_SHIFT) },
> +	{ AFE440X_CONTROL2, AFE4403_CONTROL2_TX_REF_050 <<
> +			    AFE4403_CONTROL2_TX_REF_SHIFT },
> +};
> +
> +static const struct regmap_range afe4403_yes_ranges[] = {
> +	regmap_reg_range(AFE440X_LED2VAL, AFE440X_LED1_ALED1VAL),
> +};
> +
> +static const struct regmap_access_table afe4403_volatile_table = {
> +	.yes_ranges = afe4403_yes_ranges,
> +	.n_yes_ranges = ARRAY_SIZE(afe4403_yes_ranges),
> +};
> +
> +static const struct regmap_config afe4403_regmap_config = {
> +	.reg_bits = 8,
> +	.val_bits = 24,
> +
> +	.max_register = AFE440X_PDNCYCLEENDC,
> +	.cache_type = REGCACHE_RBTREE,
> +	.volatile_table = &afe4403_volatile_table,
> +};
> +
> +#ifdef CONFIG_OF
> +static const struct of_device_id afe4403_of_match[] = {
> +	{ .compatible = "ti,afe4403", },
> +	{ /* sentinel */ },
> +};
> +MODULE_DEVICE_TABLE(of, afe4403_of_match);
> +#endif
> +
> +static int afe440x_suspend(struct device *dev)
> +{
> +	struct afe440x_data *afe440x = dev_get_drvdata(dev);
> +	int ret;
> +
> +	ret = regmap_update_bits(afe440x->regmap, AFE440X_CONTROL2,
> +				 AFE440X_CONTROL2_PDN_AFE,
> +				 AFE440X_CONTROL2_PDN_AFE);
> +	if (ret)
> +		return ret;
> +
> +	ret = regulator_disable(afe440x->regulator);
> +	if (ret) {
> +		dev_err(dev, "Unable to disable regulator\n");
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +static int afe440x_resume(struct device *dev)
> +{
> +	struct afe440x_data *afe440x = dev_get_drvdata(dev);
> +	int ret;
> +
> +	ret = regmap_update_bits(afe440x->regmap, AFE440X_CONTROL2,
> +				 AFE440X_CONTROL2_PDN_AFE, 0);
> +	if (ret)
> +		return ret;
> +
> +	ret = regulator_enable(afe440x->regulator);
> +	if (ret) {
> +		dev_err(dev, "Unable to enable regulator\n");
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +SIMPLE_DEV_PM_OPS(afe440x_pm_ops, afe440x_suspend, afe440x_resume);
> +

> +static int afe440x_iio_setup(struct afe440x_data *afe440x,
> +			     const struct afe440x_info *afe440x_info)
> +{
> +	struct iio_dev *indio_dev;
> +	int ret;
> +
> +	indio_dev = devm_iio_device_alloc(afe440x->dev, 0);
> +	if (!indio_dev) {
> +		dev_err(afe440x->dev, "Unable to allocate IIO device\n");
> +		return -ENOMEM;
> +	}
> +
> +	iio_device_set_drvdata(indio_dev, afe440x);
> +
> +	indio_dev->modes = INDIO_DIRECT_MODE;
> +	indio_dev->dev.parent = afe440x->dev;
> +	indio_dev->channels = afe440x_info->channels;
> +	indio_dev->num_channels = afe440x_info->num_channels;
> +	indio_dev->name = afe440x_info->name;
> +	indio_dev->info = afe440x_info->info;
> +
> +	if (afe440x->irq > 0) {
> +		afe440x->trig = devm_iio_trigger_alloc(afe440x->dev,
> +						       "%s-dev%d",
> +						       indio_dev->name,
> +						       indio_dev->id);
> +		if (!afe440x->trig) {
> +			dev_err(afe440x->dev, "Unable to allocate IIO trigger\n");
> +			return -ENOMEM;
> +		}
> +
> +		iio_trigger_set_drvdata(afe440x->trig, indio_dev);
> +
> +		afe440x->trig->ops = &afe440x_trigger_ops;
> +		afe440x->trig->dev.parent = afe440x->dev;
> +
> +		ret = iio_trigger_register(afe440x->trig);
> +		if (ret) {
> +			dev_err(afe440x->dev, "Unable to register IIO trigger\n");
> +			return ret;
> +		}
> +
> +		ret = devm_request_threaded_irq(afe440x->dev, afe440x->irq,
> +						iio_trigger_generic_data_rdy_poll,
> +						NULL, IRQF_ONESHOT,
> +						afe440x_info->name,
> +						afe440x->trig);
> +		if (ret) {
> +			dev_err(afe440x->dev, "Unable to request IRQ\n");
> +			return ret;
> +		}
> +	}
> +
> +	ret = iio_triggered_buffer_setup(indio_dev, &iio_pollfunc_store_time,
> +					 &afe440x_trigger_handler, NULL);
> +	if (ret) {
> +		dev_err(afe440x->dev, "Unable to setup buffer\n");
> +		return ret;
> +	}
> +
> +	ret = devm_iio_device_register(afe440x->dev, indio_dev);
> +	if (ret) {
> +		dev_err(afe440x->dev, "Unable to register IIO device\n");
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +static const struct afe440x_info afe4403_info = {
> +	.name = AFE4403_DRIVER_NAME,
> +	.channels = afe4403_channels,
> +	.num_channels = ARRAY_SIZE(afe4403_channels),
> +	.info = &afe440x_iio_info,
> +};
> +
> +static int afe4403_probe(struct spi_device *spi)
> +{
> +	struct afe440x_data *afe440x;
> +	int ret;
> +
> +	afe440x = devm_kzalloc(&spi->dev, sizeof(*afe440x), GFP_KERNEL);
> +	if (!afe440x)
> +		return -ENOMEM;
> +
> +	spi_set_drvdata(spi, afe440x);
> +
> +	afe440x->dev = &spi->dev;
> +	afe440x->irq = spi->irq;
> +
> +	afe440x->spi = spi;
> +
> +	afe440x->regmap = devm_regmap_init_spi(spi, &afe4403_regmap_config);
> +	if (IS_ERR(afe440x->regmap)) {
> +		dev_err(afe440x->dev, "Unable to allocate register map\n");
> +		return PTR_ERR(afe440x->regmap);
> +	}
> +
> +	afe440x->regulator = devm_regulator_get(afe440x->dev, "tx_sup");
> +	if (IS_ERR(afe440x->regulator)) {
> +		dev_err(afe440x->dev, "Unable to get regulator\n");
> +		return PTR_ERR(afe440x->regulator);
> +	}
> +	ret = regulator_enable(afe440x->regulator);
> +	if (ret) {
> +		dev_err(afe440x->dev, "Unable to enable regulator\n");
> +		return ret;
> +	}
> +
> +	ret = regmap_write(afe440x->regmap, AFE440X_CONTROL0,
> +			   AFE440X_CONTROL0_SW_RESET);
> +	if (ret) {
> +		dev_err(afe440x->dev, "Unable to reset device\n");
> +		return ret;
> +	}
> +
> +	ret = regmap_register_patch(afe440x->regmap, afe4403_reg_sequences,
> +				    ARRAY_SIZE(afe4403_reg_sequences));
> +	if (ret) {
> +		dev_err(afe440x->dev, "Unable to set register defaults\n");
> +		return ret;
> +	}
> +
> +	return afe440x_iio_setup(afe440x, &afe4403_info);
> +}
> +
> +static int afe4403_remove(struct spi_device *spi)
> +{
> +	struct afe440x_data *afe440x = spi_get_drvdata(spi);
> +	int ret;
> +
> +	ret = regulator_disable(afe440x->regulator);
> +	if (ret) {
> +		dev_err(afe440x->dev, "Unable to disable regulator\n");
> +		return ret;
> +	}
Same devm_iio_device_register issues as the 4404 (would be odd if there
wasn't ;)
> +
> +	return 0;
> +}
> +
> +static const struct spi_device_id afe4403_ids[] = {
> +	{ "afe4403", 0 },
> +	{ /* sentinel */ },
> +};
> +MODULE_DEVICE_TABLE(spi, afe4403_ids);
> +
> +static struct spi_driver afe4403_spi_driver = {
> +	.driver = {
> +		.name = AFE4403_DRIVER_NAME,
> +		.of_match_table = of_match_ptr(afe4403_of_match),
> +		.pm = &afe440x_pm_ops,
> +	},
> +	.probe = afe4403_probe,
> +	.remove = afe4403_remove,
> +	.id_table = afe4403_ids,
> +};
> +module_spi_driver(afe4403_spi_driver);
> +
> +MODULE_AUTHOR("Andrew F. Davis <afd-l0cyMroinI0@public.gmane.org>");
> +MODULE_DESCRIPTION("TI AFE4403 Heart Rate and Pulse Oximeter");
> +MODULE_LICENSE("GPL");
> 
