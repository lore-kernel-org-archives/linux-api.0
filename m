From: Jonathan Cameron <jic23-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 2/2] iio: health: Add driver for the TI AFE4404 heart
 monitor
Date: Sat, 5 Dec 2015 18:21:28 +0000
Message-ID: <56632B28.4080702@kernel.org>
References: <1449086240-13375-1-git-send-email-afd@ti.com>
 <1449086240-13375-3-git-send-email-afd@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-iio-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1449086240-13375-3-git-send-email-afd-l0cyMroinI0@public.gmane.org>
Sender: linux-iio-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Andrew F. Davis" <afd-l0cyMroinI0@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Hartmut Knaack <knaack.h-Mmb7MZpHnFY@public.gmane.org>, Lars-Peter Clausen <lars-Qo5EllUWu/uELgA04lAiVw@public.gmane.org>, Peter Meerwald <pmeerw-jW+XmwGofnusTnJN9+BGXg@public.gmane.org>
Cc: devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-iio-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 02/12/15 19:57, Andrew F. Davis wrote:
> Add driver for the TI AFE4404 heart rate monitor and pulse oximeter.
> This device detects reflected LED light fluctuations and presents an ADC
> value to the user space for further signal processing.
> 
> Datasheet: http://www.ti.com/product/AFE4404/datasheet
> 
> Signed-off-by: Andrew F. Davis <afd-l0cyMroinI0@public.gmane.org>
I like this a lot.  Seems much simpler to me.

Various bits and bobs inline though.  You quite rightly stated there
was too much to describe in the change log so I've kind of started
from scratch on the review as well.

Thanks for your hard work on this.

Jonathan
> ---
>  .../ABI/testing/sysfs-bus-iio-health-afe4404       |  20 +
>  drivers/iio/Kconfig                                |   1 +
>  drivers/iio/Makefile                               |   1 +
>  drivers/iio/health/Kconfig                         |  25 +
>  drivers/iio/health/Makefile                        |   6 +
>  drivers/iio/health/afe4404.c                       | 619 +++++++++++++++++++++
>  drivers/iio/health/afe440x.h                       | 168 ++++++
>  7 files changed, 840 insertions(+)
>  create mode 100644 Documentation/ABI/testing/sysfs-bus-iio-health-afe4404
>  create mode 100644 drivers/iio/health/Kconfig
>  create mode 100644 drivers/iio/health/Makefile
>  create mode 100644 drivers/iio/health/afe4404.c
>  create mode 100644 drivers/iio/health/afe440x.h
> 
> diff --git a/Documentation/ABI/testing/sysfs-bus-iio-health-afe4404 b/Documentation/ABI/testing/sysfs-bus-iio-health-afe4404
> new file mode 100644
> index 0000000..c104d66
> --- /dev/null
> +++ b/Documentation/ABI/testing/sysfs-bus-iio-health-afe4404
> @@ -0,0 +1,20 @@
> +What:		/sys/bus/iio/devices/iio:deviceX/tia_resistanceY
> +		/sys/bus/iio/devices/iio:deviceX/tia_capacitanceY
> +Date:		December 2015
> +KernelVersion:
> +Contact:	Andrew F. Davis <afd-l0cyMroinI0@public.gmane.org>
> +Description:
> +		Get and set the resistance and the capacitance settings for the
> +		Transimpedance Amplifier. Y is 1 for Rf1 and Cf1, Y is 2 for
> +		Rf2 and Cf2 values.
> +		Resistance setting is from 0 -> 7
> +		Capcitance setting is from 0 -> 15
No magic numbers if at all possible.  These correspond to real resistances
and capacitances.

You also want an _available attribute for each of them for the different
possible values.

I'm not overly keep on the naming still but it's part specific enough that
if you fix the units I'll let it go ;)
> +
> +What:		/sys/bus/iio/devices/iio:deviceX/tia_separate_en
> +Date:		December 2015
> +KernelVersion:
> +Contact:	Andrew F. Davis <afd-l0cyMroinI0@public.gmane.org>
> +Description:
> +		Enable or disable separate settings for the TransImpedance
> +		Amplifier above, when disabled both values are set by the
> +		first channel.
Weird and wonderful but fine for a part specific attibute!

As noted below, I think we need to document all the new ABI even though
much of it is just extended names on standard channels.

> diff --git a/drivers/iio/Kconfig b/drivers/iio/Kconfig
> index 66792e7..ac085ab 100644
> --- a/drivers/iio/Kconfig
> +++ b/drivers/iio/Kconfig
> @@ -52,6 +52,7 @@ source "drivers/iio/common/Kconfig"
>  source "drivers/iio/dac/Kconfig"
>  source "drivers/iio/frequency/Kconfig"
>  source "drivers/iio/gyro/Kconfig"
> +source "drivers/iio/health/Kconfig"
>  source "drivers/iio/humidity/Kconfig"
>  source "drivers/iio/imu/Kconfig"
>  source "drivers/iio/light/Kconfig"
> diff --git a/drivers/iio/Makefile b/drivers/iio/Makefile
> index aeca726..6c5eb2a 100644
> --- a/drivers/iio/Makefile
> +++ b/drivers/iio/Makefile
> @@ -18,6 +18,7 @@ obj-y += common/
>  obj-y += dac/
>  obj-y += gyro/
>  obj-y += frequency/
> +obj-y += health/
>  obj-y += humidity/
>  obj-y += imu/
>  obj-y += light/
> diff --git a/drivers/iio/health/Kconfig b/drivers/iio/health/Kconfig
> new file mode 100644
> index 0000000..526e7af
> --- /dev/null
> +++ b/drivers/iio/health/Kconfig
> @@ -0,0 +1,25 @@
> +#
> +# Health drivers
> +#
> +# When adding new entries keep the list in alphabetical order
> +
> +menu "Health"
> +
> +menu "Heart Rate Monitors"
> +
> +config AFE4404
> +	tristate "TI AFE4404 Heart Rate Monitor"
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
> +
> +endmenu
> +
> +endmenu
> diff --git a/drivers/iio/health/Makefile b/drivers/iio/health/Makefile
> new file mode 100644
> index 0000000..c108c8d
> --- /dev/null
> +++ b/drivers/iio/health/Makefile
> @@ -0,0 +1,6 @@
> +#
> +# Makefile for IIO Health drivers
> +#
> +# When adding new entries keep the list in alphabetical order
> +
> +obj-$(CONFIG_AFE4404) += afe4404.o
> diff --git a/drivers/iio/health/afe4404.c b/drivers/iio/health/afe4404.c
> new file mode 100644
> index 0000000..d36c1d9
> --- /dev/null
> +++ b/drivers/iio/health/afe4404.c
> @@ -0,0 +1,619 @@
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
> +#include <linux/delay.h>
> +#include <linux/err.h>
> +#include <linux/interrupt.h>
> +#include <linux/i2c.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/of_gpio.h>
> +#include <linux/regmap.h>
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
> +enum afe4404_chan_id {
> +	LED1,
> +	ALED1,
> +	LED2,
> +	ALED2,
> +	LED3,
> +	LED1_ALED1,
> +	LED2_ALED2,
> +	AVG_LED1_ALED1,
> +	AVG_LED2_ALED2,
> +	ILED1,
> +	ILED2,
> +	ILED3,
> +};
> +
> +#define AFE4404_REG_INFO(_id, _reg, _offreg, _sm)		\
> +	[_id] = {						\
> +		.reg = _reg,					\
> +		.offreg = _offreg,				\
> +		.shift = _sm ## _SHIFT,				\
> +		.mask = _sm ## _MASK,				\
> +	}
> +
> +struct {
> +	unsigned int reg;
> +	unsigned int offreg;
> +	unsigned int shift;
> +	unsigned int mask;
> +} reg_info[] = {
> +	AFE4404_REG_INFO(LED1, AFE440X_LED1VAL, AFE4404_OFFDAC, AFE4404_OFFDAC_CURR_LED1),
> +	AFE4404_REG_INFO(ALED1, AFE440X_ALED1VAL, AFE4404_OFFDAC, AFE4404_OFFDAC_CURR_ALED1),
> +	AFE4404_REG_INFO(LED2, AFE440X_LED2VAL, AFE4404_OFFDAC, AFE4404_OFFDAC_CURR_LED2),
> +	AFE4404_REG_INFO(ALED2, AFE440X_ALED2VAL, AFE4404_OFFDAC, AFE4404_OFFDAC_CURR_ALED2),
> +	AFE4404_REG_INFO(LED3, AFE440X_ALED2VAL, 0, NULL),
> +	AFE4404_REG_INFO(LED1_ALED1, AFE440X_LED1_ALED1VAL, 0, NULL),
> +	AFE4404_REG_INFO(LED2_ALED2, AFE440X_LED2_ALED2VAL, 0, NULL),
> +	AFE4404_REG_INFO(AVG_LED1_ALED1, AFE4404_AVG_LED1_ALED1VAL, 0, NULL),
> +	AFE4404_REG_INFO(AVG_LED2_ALED2, AFE4404_AVG_LED2_ALED2VAL, 0, NULL),
> +	AFE4404_REG_INFO(ILED1, AFE440X_LEDCNTRL, 0, AFE4404_LEDCNTRL_ILED1),
> +	AFE4404_REG_INFO(ILED2, AFE440X_LEDCNTRL, 0, AFE4404_LEDCNTRL_ILED2),
> +	AFE4404_REG_INFO(ILED3, AFE440X_LEDCNTRL, 0, AFE4404_LEDCNTRL_ILED3),
> +};
> +
> +static const struct iio_chan_spec afe4404_channels[] = {
> +	/* ADC values */
> +	AFE440X_INTENSITY_CHAN(LED1, "led1", BIT(IIO_CHAN_INFO_OFFSET)),
> +	AFE440X_INTENSITY_CHAN(ALED1, "led1_ambient", BIT(IIO_CHAN_INFO_OFFSET)),
(this one is still 'interesting' as it's nothing to do with led1 other than it's
taken temporily close to it - the led is presumably off at the time! - I can't
think of a better way though - maybe another reviewer will)
> +	AFE440X_INTENSITY_CHAN(LED2, "led2", BIT(IIO_CHAN_INFO_OFFSET)),
> +	AFE440X_INTENSITY_CHAN(ALED2, "led2_ambient", BIT(IIO_CHAN_INFO_OFFSET)),
> +	AFE440X_INTENSITY_CHAN(LED3, "led3", BIT(IIO_CHAN_INFO_OFFSET)),
> +	AFE440X_INTENSITY_CHAN(LED1_ALED1, "led1-led1_ambient", 0),
> +	AFE440X_INTENSITY_CHAN(LED2_ALED2, "led2-led2_ambient", 0),
This trick for the differential cases is a cludge to work around deficiencies
in our existing infrastructure, but it's straight forward one for an unusual
case so fair enough.

> +	AFE440X_INTENSITY_CHAN(AVG_LED1_ALED1, "led1-led1_ambient_mean", 0),
> +	AFE440X_INTENSITY_CHAN(AVG_LED2_ALED2, "led2-led2_ambient_mean", 0),
I'd love to better describe these two with the filters made explicit as
separate sysfs attributes rather than here.  It's kind of backwards but
we do have oversampling to define what is happening here.  I also note
that the true output rate of this is lower than the other channels.

If we were to propose a decimation to match with oversampling and to
explicitly document them as a pair it might work.  Which is relevant
for a channel is dependent on the 'natural - e.g. the trigger rate'
at which we fill the buffer.  So if the whole device is performing
decimation and we read at the reduced frequency then it is oversampling
- if we read at the original frequency it is decimation.

What do you think?
> +	/* LED current */
> +	AFE440X_CURRENT_CHAN(ILED1, "led1"),
> +	AFE440X_CURRENT_CHAN(ILED2, "led2"),
> +	AFE440X_CURRENT_CHAN(ILED3, "led3"),

Whilst all these now just 'stretch' :) the current ABI structure they
do need explicitly documenting somewhere.  Probably odd enough that they'll
want to go in your part specific doc rather than just adding the specific
naming to the existing abi.

> +};
> +
> +static ssize_t afe440x_show_register(struct device *dev,
> +				     struct device_attribute *attr,
> +				     char *buf)
> +{
> +	struct iio_dev *indio_dev = dev_to_iio_dev(dev);
> +	struct afe440x_data *afe440x = iio_device_get_drvdata(indio_dev);
> +	struct afe440x_reg *afe440x_reg = to_afe440x_reg(attr);
> +	unsigned int reg_val;
> +	int ret;
> +
> +	ret = regmap_read(afe440x->regmap, afe440x_reg->reg, &reg_val);
> +	if (ret)
> +		return ret;
> +
> +	reg_val >>= afe440x_reg->shift;
> +	reg_val &= afe440x_reg->mask;
> +
> +	return scnprintf(buf, PAGE_SIZE, "%u\n", reg_val);
> +}
> +
> +static ssize_t afe440x_store_register(struct device *dev,
> +				      struct device_attribute *attr,
> +				      const char *buf, size_t count)
> +{
> +	struct iio_dev *indio_dev = dev_to_iio_dev(dev);
> +	struct afe440x_data *afe440x = iio_device_get_drvdata(indio_dev);
> +	struct afe440x_reg *afe440x_reg = to_afe440x_reg(attr);
> +	unsigned int reg_val;
> +	int val, ret;
> +
> +	if (kstrtoint(buf, 0, &val))
> +		return -EINVAL;
> +
> +	ret = regmap_read(afe440x->regmap, afe440x_reg->reg, &reg_val);
> +	if (ret)
> +		return ret;
> +
> +	reg_val &= ~afe440x_reg->mask;
> +	reg_val |= ((val << afe440x_reg->shift) & afe440x_reg->mask);
> +
> +	ret = regmap_write(afe440x->regmap, afe440x_reg->reg, reg_val);
> +	if (ret)
> +		return ret;
> +
> +	return count;
> +}
> +
> +AFE440X_ATTR(tia_separate_en, AFE4404_TIA_GAIN_SEP, AFE440X_TIAGAIN_ENSEPGAIN);
> +
> +AFE440X_ATTR(tia_resistance1, AFE4404_TIA_GAIN, AFE4404_TIA_GAIN_RES);
> +AFE440X_ATTR(tia_capacitance1, AFE4404_TIA_GAIN, AFE4404_TIA_GAIN_CAP);
> +
> +AFE440X_ATTR(tia_resistance2, AFE4404_TIA_GAIN_SEP, AFE4404_TIA_GAIN_RES);
> +AFE440X_ATTR(tia_capacitance2, AFE4404_TIA_GAIN_SEP, AFE4404_TIA_GAIN_CAP);
> +
> +static struct attribute *afe4404_attributes[] = {
> +	&afe440x_reg_tia_separate_en.dev_attr.attr,
> +	&afe440x_reg_tia_resistance1.dev_attr.attr,
> +	&afe440x_reg_tia_capacitance1.dev_attr.attr,
> +	&afe440x_reg_tia_resistance2.dev_attr.attr,
> +	&afe440x_reg_tia_capacitance2.dev_attr.attr,
> +	NULL
> +};
> +
> +static const struct attribute_group afe4404_attribute_group = {
> +	.attrs = afe4404_attributes
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
> +static const struct iio_info afe4404_iio_info = {
> +	.attrs	= &afe4404_attribute_group,
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
> +	int ret, bit, reg, i = 0;
> +	s32 buffer[12];
> +
> +	for_each_set_bit(bit, indio_dev->active_scan_mask,
> +			 indio_dev->masklength) {
> +		reg = reg_info[bit].reg;
why the local reg variable? Stick it dirrectly in the functional call.
> +		ret = regmap_read(afe440x->regmap, reg, &buffer[i++]);
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
> +static const struct iio_trigger_ops afe440x_trigger_ops = {
> +	.owner = THIS_MODULE,
> +};
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
> +	{ /* sentinel */ },
> +};
> +MODULE_DEVICE_TABLE(of, afe4404_of_match);
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
> +		dev_err(dev, "Failed to disable regulator\n");
> +		return ret;
> +	}
Some of the static code checkers (probably coccicheck) will
point out that moving the return ret out of the above brackets
will have the same effect as you have here in less code.

It's worth running sparse, smatch and coccicheck on drivers before
submitting as otherwise we miss things and then get a series
of 'fix' patches after this hits a public tree rather than the list
(you sometimes get them for posting on the list as well these days!)
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
I'd expect you want to turn the device off on remove given you turn
it on during a resume...
> +
> +	ret = regulator_enable(afe440x->regulator);
> +	if (ret) {
> +		dev_err(dev, "Failed to enable regulator\n");
> +		return ret;
> +	}
You turn the reg on here, but nowhere else that I can see.
Why should it be on during the initial start?
> +
> +	return 0;
> +}
> +
> +SIMPLE_DEV_PM_OPS(afe440x_pm_ops, afe440x_suspend, afe440x_resume);
> +
> +static int afe440x_iio_setup(struct afe440x_data *afe440x)
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
> +	indio_dev->channels = afe440x->channels;
> +	indio_dev->num_channels = afe440x->num_channels;
> +	indio_dev->name = afe440x->name;
> +	indio_dev->info = afe440x->info;
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
> +						afe440x->name, afe440x->trig);
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
This suprises me a little - I'd expect such a complex part to
do at least some power saving or similar...

If that is the case you'll want to do that in the remove after the device
is unregistered (to avoid a race with userspace interfaces still available).

Can always be added in a later patch however!
> +	if (ret) {
> +		dev_err(afe440x->dev, "Unable to register IIO device\n");
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +static int afe4404_probe(struct i2c_client *client,
> +			 const struct i2c_device_id *id)
> +{
> +	struct afe440x_data *afe440x;
> +	int ret;
> +
> +	afe440x = devm_kzalloc(&client->dev, sizeof(*afe440x), GFP_KERNEL);
> +	if (!afe440x)
> +		return -ENOMEM;
This is all still backwards to my mind and could be easily refactored
to provide the device specific stuff in a similar way to other IIO drivers
do it with a mixture of const data and appropriate callbacks.

I appreciate I haven't seen the other driver you mentioned shares a lot
of the code, but I doubt it does anything that couldn't be handled that
way around.
> +
> +	i2c_set_clientdata(client, afe440x);
> +
> +	afe440x->dev = &client->dev;
> +	afe440x->irq = client->irq;
> +
> +	afe440x->regmap = devm_regmap_init_i2c(client, &afe4404_regmap_config);
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
Given you turn the reg on during the resume, I'm guessing you want to turn
it on here and off in remove?  No reason to assume it is on when the
board is powered up!

> +
> +	ret = regmap_write(afe440x->regmap, AFE440X_CONTROL0,
> +			   AFE440X_CONTROL0_SW_RESET);
> +	if (ret) {
> +		dev_err(afe440x->dev, "Unable to reset device\n");
> +		return ret;
> +	}
> +
> +	ret = regmap_register_patch(afe440x->regmap, afe4404_reg_sequences,
> +				    ARRAY_SIZE(afe4404_reg_sequences));
> +	if (ret) {
> +		dev_err(afe440x->dev, "Unable to set register defaults\n");
> +		return ret;
> +	}
> +
As I suggest below in the header, I'd put these elements
into a separate structure (as they are constant for a given part)
> +	afe440x->channels = afe4404_channels;
> +	afe440x->num_channels = ARRAY_SIZE(afe4404_channels);
> +	afe440x->name = AFE4404_DRIVER_NAME;
> +	afe440x->info = &afe4404_iio_info;
> +
> +	return afe440x_iio_setup(afe440x);
> +}
> +
> +static const struct i2c_device_id afe4404_ids[] = {
> +	{ "afe4404", 0 },
> +	{ /* sentinel */ },
> +};
> +MODULE_DEVICE_TABLE(i2c, afe4404_ids);
> +
> +static struct i2c_driver afe4404_i2c_driver = {
> +	.driver = {
> +		.name = AFE4404_DRIVER_NAME,
> +		.of_match_table = of_match_ptr(afe4404_of_match),
> +		.pm = &afe440x_pm_ops,
> +	},
> +	.probe = afe4404_probe,
> +	.id_table = afe4404_ids,
> +};
> +module_i2c_driver(afe4404_i2c_driver);
> +
> +MODULE_AUTHOR("Andrew F. Davis <afd-l0cyMroinI0@public.gmane.org>");
> +MODULE_DESCRIPTION("TI AFE4404 Heart Rate and Pulse Oximeter");
> +MODULE_LICENSE("GPL");
> diff --git a/drivers/iio/health/afe440x.h b/drivers/iio/health/afe440x.h
> new file mode 100644
> index 0000000..73a2577
> --- /dev/null
> +++ b/drivers/iio/health/afe440x.h
> @@ -0,0 +1,168 @@
> +/*
> + * AFE440X Heart Rate Monitors and Low-Cost Pulse Oximeters
> + *
> + * Author: Andrew F. Davis <afd-l0cyMroinI0@public.gmane.org>
> + *
> + * Copyright: (C) 2015 Texas Instruments, Inc.
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
I know you are aiming to support more devices and hence the header file
spit may make sense, but please squish it into the .c file for now and
pull it out as part of the series adding the new devices - avoids
me getting patches 'tidying this up' in the interval before the other
device support makes it.
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
> +#define AFE440X_TIAGAIN			0x20
> +#define AFE440X_TIA_AMB_GAIN		0x21
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
I'd particularly like to see the above two definitions next to the
arrays they are used to instantiate - makes for easier review!

> +
> +struct afe440x_reg {
> +	struct device_attribute dev_attr;
> +	unsigned int reg;
> +	unsigned int shift;
> +	unsigned int mask;
> +};
> +
> +#define to_afe440x_reg(_dev_attr)				\
> +	container_of(_dev_attr, struct afe440x_reg, dev_attr)
> +
> +#define AFE440X_ATTR(_name, _reg, _field)			\
> +	struct afe440x_reg afe440x_reg_##_name = {		\
> +		.dev_attr = __ATTR(_name, (S_IRUGO | S_IWUSR),	\
> +				   afe440x_show_register,	\
> +				   afe440x_store_register),	\
> +		.reg = _reg,					\
> +		.shift = _field ## _SHIFT,			\
> +		.mask = _field ## _MASK,			\
> +	}
For now I'd like to see this in the .c file 
> +
> +/**
> + * struct afe440x_data
> + * @dev - Device structure
> + * @name - Device name
You still have a few bits in here that are presumably there
to assist supporting multiple drivers.  I don't think they
belong in this structure.

Split them out to say
struct afe440x_device_info and pass that into your iio_setup
function as well.  Then they won't be in this struct for it's
other uses which would be cleaner (at the cost of one extra
parameter to that function call)

It will also split out thsoe parts that are constant for a given
type of device from those that are instance specific
(such as Irq's etc).

> + * @regmap - Register map of the device
> + * @regulator - Pointer to the regulator for the IC
> + * @channels - IIO channels
> + * @num_channels - Number of IIO channels
> + * @info - IIO info for device
> + * @trig - IIO trigger for this device
> + * @irq - ADC_RDY line interrupt number
> +**/
Nicely documented - thanks.
> +struct afe440x_data {
> +	struct device *dev;
> +	const char *name;
> +	struct regmap *regmap;
> +	struct regulator *regulator;
> +	struct iio_chan_spec const *channels;
> +	int num_channels;
> +	const struct iio_info *info;
> +	struct iio_trigger *trig;
> +	int irq;
> +};
> +
> +#endif /* _AFE440X_H */
> 
