From: Jonathan Cameron <jic23-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 3/5] iio: health: Add driver for the TI AFE4404 heart
 monitor
Date: Tue, 22 Dec 2015 17:37:23 +0000
Message-ID: <56798A53.9080905@kernel.org>
References: <1450132561-5245-1-git-send-email-afd@ti.com>
 <1450132561-5245-4-git-send-email-afd@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-iio-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1450132561-5245-4-git-send-email-afd-l0cyMroinI0@public.gmane.org>
Sender: linux-iio-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Andrew F. Davis" <afd-l0cyMroinI0@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Hartmut Knaack <knaack.h-Mmb7MZpHnFY@public.gmane.org>, Lars-Peter Clausen <lars-Qo5EllUWu/uELgA04lAiVw@public.gmane.org>, Peter Meerwald <pmeerw-jW+XmwGofnusTnJN9+BGXg@public.gmane.org>
Cc: devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-iio-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 14/12/15 22:35, Andrew F. Davis wrote:
> Add driver for the TI AFE4404 heart rate monitor and pulse oximeter.
> This device detects reflected LED light fluctuations and presents an =
ADC
> value to the user space for further signal processing.
>=20
> Datasheet: http://www.ti.com/product/AFE4404/datasheet
>=20
> Signed-off-by: Andrew F. Davis <afd-l0cyMroinI0@public.gmane.org>
Hi Andrew,

Sorry I didn't get to this a the weekend. We are now likely to just
miss the merge window so lets get this cleaned up and ready to go
for the start of the next cycle (probably 3rd week of January)

Looking good mostly.  A few minor bits and bobs I either missed before
or that got introduced as side effects of your changes.
I thought about fixing them up and applying, but I think it's just
a shade to many changes and I need your feedback on a couple of them
anyway.

Jonathan

> ---
>  .../ABI/testing/sysfs-bus-iio-health-afe4404       |  60 ++
>  drivers/iio/Kconfig                                |   1 +
>  drivers/iio/Makefile                               |   1 +
>  drivers/iio/health/Kconfig                         |  25 +
>  drivers/iio/health/Makefile                        |   6 +
>  drivers/iio/health/afe4404.c                       | 700 +++++++++++=
++++++++++
>  drivers/iio/health/afe440x.h                       | 202 ++++++
>  7 files changed, 995 insertions(+)
>  create mode 100644 Documentation/ABI/testing/sysfs-bus-iio-health-af=
e4404
>  create mode 100644 drivers/iio/health/Kconfig
>  create mode 100644 drivers/iio/health/Makefile
>  create mode 100644 drivers/iio/health/afe4404.c
>  create mode 100644 drivers/iio/health/afe440x.h
>=20
> diff --git a/Documentation/ABI/testing/sysfs-bus-iio-health-afe4404 b=
/Documentation/ABI/testing/sysfs-bus-iio-health-afe4404
> new file mode 100644
> index 0000000..b01ca47
> --- /dev/null
> +++ b/Documentation/ABI/testing/sysfs-bus-iio-health-afe4404
> @@ -0,0 +1,60 @@
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
> +		25000, 10000, 1000000, and 2000000 Ohms.
> +		Valid capacitance settings are 5, 2.5, 10, 7.5, 20, 17.5, 25,
> +		and 22.5 picoFarads.
Defined units for IIO are nanofarads - see sysfs-bus-iio.
Would really like to keep this consistent and doesn't look like that sh=
ould
be terribly hard to do here.

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
> +What:		/sys/bus/iio/devices/iio:deviceX/in_intensity_ledY-ledY_ambie=
nt_raw
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
> +		stages. The values are expressed in 5-bit sign=E2=80=93magnitude.
> +
> +What:		/sys/bus/iio/devices/iio:deviceX/out_current_ledY_raw
> +Date:		December 2015
> +KernelVersion:
> +Contact:	Andrew F. Davis <afd-l0cyMroinI0@public.gmane.org>
> +Description:
> +		Get and set the LED current for the specified LED. Y is the
> +		specific LED number.
> +		Values range from 0 -> 63. Current is calculated by
> +		current =3D value * 0.8mA
Otherwise, we both know that the ABI is less than ideal, but it's proba=
bly
the best solution we can easily manage so lets go with this.
While it's not easy to revise this in future it can be done should we
end up with a more generic way of representing the complex cases seen h=
ere
(no idea what that might be!)

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
> @@ -18,6 +18,7 @@ obj-y +=3D common/
>  obj-y +=3D dac/
>  obj-y +=3D gyro/
>  obj-y +=3D frequency/
> +obj-y +=3D health/
>  obj-y +=3D humidity/
>  obj-y +=3D imu/
>  obj-y +=3D light/
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
I'll merge this as appropriate given we now have a health
driver in tree (the simpler maxim one that got going after this one).
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
> diff --git a/drivers/iio/health/Makefile b/drivers/iio/health/Makefil=
e
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
> +obj-$(CONFIG_AFE4404) +=3D afe4404.o
> diff --git a/drivers/iio/health/afe4404.c b/drivers/iio/health/afe440=
4.c
> new file mode 100644
> index 0000000..d199a35
> --- /dev/null
> +++ b/drivers/iio/health/afe4404.c
> @@ -0,0 +1,700 @@
> +/*
> + * AFE4404 Heart Rate Monitors and Low-Cost Pulse Oximeters
> + *
> + * Copyright (C) 2015 Texas Instruments Incorporated - http://www.ti=
=2Ecom/
> + *	Andrew F. Davis <afd-l0cyMroinI0@public.gmane.org>
> + *
> + * This program is free software; you can redistribute it and/or mod=
ify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful, b=
ut
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
> +	ILED1,
> +	ILED2,
> +	ILED3,
> +};
> +
> +static const struct afe440x_reg_info reg_info[] =3D {
> +	AFE440X_REG_INFO(LED1, AFE440X_LED1VAL, AFE4404_OFFDAC, AFE4404_OFF=
DAC_CURR_LED1),
> +	AFE440X_REG_INFO(ALED1, AFE440X_ALED1VAL, AFE4404_OFFDAC, AFE4404_O=
=46FDAC_CURR_ALED1),
> +	AFE440X_REG_INFO(LED2, AFE440X_LED2VAL, AFE4404_OFFDAC, AFE4404_OFF=
DAC_CURR_LED2),
> +	AFE440X_REG_INFO(ALED2, AFE440X_ALED2VAL, AFE4404_OFFDAC, AFE4404_O=
=46FDAC_CURR_ALED2),
> +	AFE440X_REG_INFO(LED3, AFE440X_ALED2VAL, 0, NULL),
> +	AFE440X_REG_INFO(LED1_ALED1, AFE440X_LED1_ALED1VAL, 0, NULL),
> +	AFE440X_REG_INFO(LED2_ALED2, AFE440X_LED2_ALED2VAL, 0, NULL),
> +	AFE440X_REG_INFO(ILED1, AFE440X_LEDCNTRL, 0, AFE4404_LEDCNTRL_ILED1=
),
> +	AFE440X_REG_INFO(ILED2, AFE440X_LEDCNTRL, 0, AFE4404_LEDCNTRL_ILED2=
),
> +	AFE440X_REG_INFO(ILED3, AFE440X_LEDCNTRL, 0, AFE4404_LEDCNTRL_ILED3=
),
> +};
> +
> +static const struct iio_chan_spec afe4404_channels[] =3D {
> +	/* ADC values */
> +	AFE440X_INTENSITY_CHAN(LED1, "led1", BIT(IIO_CHAN_INFO_OFFSET)),
> +	AFE440X_INTENSITY_CHAN(ALED1, "led1_ambient", BIT(IIO_CHAN_INFO_OFF=
SET)),
> +	AFE440X_INTENSITY_CHAN(LED2, "led2", BIT(IIO_CHAN_INFO_OFFSET)),
> +	AFE440X_INTENSITY_CHAN(ALED2, "led2_ambient", BIT(IIO_CHAN_INFO_OFF=
SET)),
> +	AFE440X_INTENSITY_CHAN(LED3, "led3", BIT(IIO_CHAN_INFO_OFFSET)),
> +	AFE440X_INTENSITY_CHAN(LED1_ALED1, "led1-led1_ambient", 0),
> +	AFE440X_INTENSITY_CHAN(LED2_ALED2, "led2-led2_ambient", 0),
> +	/* LED current */
> +	AFE440X_CURRENT_CHAN(ILED1, "led1"),
> +	AFE440X_CURRENT_CHAN(ILED2, "led2"),
> +	AFE440X_CURRENT_CHAN(ILED3, "led3"),
> +};
> +
> +static const struct afe440x_reg_lookup afe4404_res_table[] =3D {
> +	{ .integer =3D 500000, .fract =3D 0 },
> +	{ .integer =3D 250000, .fract =3D 0 },
> +	{ .integer =3D 100000, .fract =3D 0 },
> +	{ .integer =3D 50000, .fract =3D 0 },
> +	{ .integer =3D 25000, .fract =3D 0 },
> +	{ .integer =3D 10000, .fract =3D 0 },
> +	{ .integer =3D 1000000, .fract =3D 0 },
> +	{ .integer =3D 2000000, .fract =3D 0 },
> +};
> +
> +static const struct afe440x_reg_lookup afe4404_cap_table[] =3D {
> +	{ .integer =3D 5, .fract =3D 0 },
> +	{ .integer =3D 2, .fract =3D 500000 },
> +	{ .integer =3D 10, .fract =3D 0 },
> +	{ .integer =3D 7, .fract =3D 500000 },
> +	{ .integer =3D 20, .fract =3D 0 },
> +	{ .integer =3D 17, .fract =3D 500000 },
> +	{ .integer =3D 25, .fract =3D 0 },
> +	{ .integer =3D 22, .fract =3D 500000 },
> +};
> +
> +static ssize_t afe440x_show_register(struct device *dev,
> +				     struct device_attribute *attr,
> +				     char *buf)
> +{
> +	struct iio_dev *indio_dev =3D dev_to_iio_dev(dev);
> +	struct afe440x_data *afe440x =3D iio_device_get_drvdata(indio_dev);
> +	struct afe440x_attr *afe440x_attr =3D to_afe440x_attr(attr);
> +	unsigned int reg_val, type;
> +	int vals[2];
> +	int ret, val_len;
> +
> +	ret =3D regmap_read(afe440x->regmap, afe440x_attr->reg, &reg_val);
> +	if (ret)
> +		return ret;
> +
> +	reg_val >>=3D afe440x_attr->shift;
> +	reg_val &=3D afe440x_attr->mask;
> +
> +	switch (afe440x_attr->type) {
> +	case SIMPLE:
> +		type =3D IIO_VAL_INT;
> +		val_len =3D 1;
> +		vals[0] =3D reg_val;
> +		break;
> +	case RESISTANCE:
> +		type =3D IIO_VAL_INT_PLUS_MICRO;
> +		val_len =3D 2;
> +		if (reg_val < ARRAY_SIZE(afe4404_res_table)) {
> +			vals[0] =3D afe4404_res_table[reg_val].integer;
> +			vals[1] =3D afe4404_res_table[reg_val].fract;
> +			break;
> +		}
> +		return -EINVAL;
> +	case CAPACITANCE:
> +		type =3D IIO_VAL_INT_PLUS_MICRO;
> +		val_len =3D 2;
> +		if (reg_val < ARRAY_SIZE(afe4404_cap_table)) {
> +			vals[0] =3D afe4404_cap_table[reg_val].integer;
> +			vals[1] =3D afe4404_cap_table[reg_val].fract;
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
> +	struct iio_dev *indio_dev =3D dev_to_iio_dev(dev);
> +	struct afe440x_data *afe440x =3D iio_device_get_drvdata(indio_dev);
> +	struct afe440x_attr *afe440x_attr =3D to_afe440x_attr(attr);
> +	unsigned int reg_val;
> +	int val, integer, fract, ret;
> +
> +	ret =3D iio_str_to_fixpoint(buf, 100000, &integer, &fract);
> +	if (ret)
> +		return ret;
> +
> +	ret =3D regmap_read(afe440x->regmap, afe440x_attr->reg, &reg_val);
> +	if (ret)
> +		return ret;
> +
> +	switch (afe440x_attr->type) {
> +	case SIMPLE:
> +		val =3D integer;
> +		break;
> +	case RESISTANCE:
> +		for (val =3D 0; val < ARRAY_SIZE(afe4404_res_table); val++)
> +			if (afe4404_res_table[val].integer =3D=3D integer &&
> +			    afe4404_res_table[val].fract =3D=3D fract)
> +				break;
> +		if (val =3D=3D ARRAY_SIZE(afe4404_res_table))
> +			return -EINVAL;
> +		break;
> +	case CAPACITANCE:
> +		for (val =3D 0; val < ARRAY_SIZE(afe4404_cap_table); val++)
> +			if (afe4404_cap_table[val].integer =3D=3D integer &&
> +			    afe4404_cap_table[val].fract =3D=3D fract)
> +				break;
> +		if (val =3D=3D ARRAY_SIZE(afe4404_cap_table))
> +			return -EINVAL;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	reg_val &=3D ~afe440x_attr->mask;
> +	reg_val |=3D ((val << afe440x_attr->shift) & afe440x_attr->mask);
> +
> +	ret =3D regmap_write(afe440x->regmap, afe440x_attr->reg, reg_val);
> +	if (ret)
> +		return ret;
> +
> +	return count;
> +}
> +
> +static AFE440X_ATTR(tia_separate_en, AFE4404_TIA_GAIN_SEP, AFE440X_T=
IAGAIN_ENSEPGAIN, SIMPLE);
> +
> +static AFE440X_ATTR(tia_resistance1, AFE4404_TIA_GAIN, AFE4404_TIA_G=
AIN_RES, RESISTANCE);
> +static AFE440X_ATTR(tia_capacitance1, AFE4404_TIA_GAIN, AFE4404_TIA_=
GAIN_CAP, CAPACITANCE);
> +
> +static AFE440X_ATTR(tia_resistance2, AFE4404_TIA_GAIN_SEP, AFE4404_T=
IA_GAIN_RES, RESISTANCE);
> +static AFE440X_ATTR(tia_capacitance2, AFE4404_TIA_GAIN_SEP, AFE4404_=
TIA_GAIN_CAP, CAPACITANCE);
> +
> +static struct attribute *afe440x_attributes[] =3D {
> +	&afe440x_attr_tia_separate_en.dev_attr.attr,
> +	&afe440x_attr_tia_resistance1.dev_attr.attr,
> +	&afe440x_attr_tia_capacitance1.dev_attr.attr,
> +	&afe440x_attr_tia_resistance2.dev_attr.attr,
> +	&afe440x_attr_tia_capacitance2.dev_attr.attr,
> +	NULL
> +};
> +
> +static const struct attribute_group afe440x_attribute_group =3D {
> +	.attrs =3D afe440x_attributes
> +};
> +
> +static int afe440x_read_raw(struct iio_dev *indio_dev,
> +			    struct iio_chan_spec const *chan,
> +			    int *val, int *val2, long mask)
> +{
> +	struct afe440x_data *afe440x =3D iio_device_get_drvdata(indio_dev);
> +	int ret;
> +
> +	switch (chan->type) {
> +	case IIO_INTENSITY:
> +		switch (mask) {
> +		case IIO_CHAN_INFO_RAW:
> +			ret =3D regmap_read(afe440x->regmap,
> +					  reg_info[chan->address].reg, val);
> +			if (ret)
> +				return ret;
> +			return IIO_VAL_INT;
> +		case IIO_CHAN_INFO_OFFSET:
> +			ret =3D regmap_read(afe440x->regmap,
> +					  reg_info[chan->address].offreg, val);
> +			if (ret)
> +				return ret;
> +			*val &=3D reg_info[chan->address].mask;
> +			*val >>=3D reg_info[chan->address].shift;
> +			return IIO_VAL_INT;
> +		}
> +		break;
> +	case IIO_CURRENT:
> +		switch (mask) {
> +		case IIO_CHAN_INFO_RAW:
> +			ret =3D regmap_read(afe440x->regmap,
> +					  reg_info[chan->address].reg, val);
> +			if (ret)
> +				return ret;
> +			*val &=3D reg_info[chan->address].mask;
> +			*val >>=3D reg_info[chan->address].shift;
> +			return IIO_VAL_INT;
> +		case IIO_CHAN_INFO_SCALE:
> +			*val =3D 0;
> +			*val2 =3D 800000;
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
> +	struct afe440x_data *afe440x =3D iio_device_get_drvdata(indio_dev);
> +	unsigned int reg_val;
> +	int ret;
> +
> +	switch (chan->type) {
> +	case IIO_INTENSITY:
> +		switch (mask) {
> +		case IIO_CHAN_INFO_OFFSET:
> +			ret =3D regmap_read(afe440x->regmap,
> +					  reg_info[chan->address].offreg,
> +					  &reg_val);
> +			if (ret)
> +				return ret;
> +			reg_val &=3D ~reg_info[chan->address].mask;
> +			reg_val |=3D ((val << reg_info[chan->address].shift) &
> +					reg_info[chan->address].mask);
> +			return regmap_write(afe440x->regmap,
> +					    reg_info[chan->address].offreg,
> +					    reg_val);
> +		}
> +		break;
> +	case IIO_CURRENT:
> +		switch (mask) {
> +		case IIO_CHAN_INFO_RAW:
> +			ret =3D regmap_read(afe440x->regmap,
> +					  reg_info[chan->address].reg,
> +					  &reg_val);
> +			if (ret)
> +				return ret;
> +			reg_val &=3D ~reg_info[chan->address].mask;
> +			reg_val |=3D ((val << reg_info[chan->address].shift) &
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
> +static const struct iio_info afe440x_iio_info =3D {
> +	.attrs =3D &afe440x_attribute_group,
> +	.read_raw =3D afe440x_read_raw,
> +	.write_raw =3D afe440x_write_raw,
> +	.driver_module =3D THIS_MODULE,
> +};
> +
> +static irqreturn_t afe440x_trigger_handler(int irq, void *private)
> +{
> +	struct iio_poll_func *pf =3D private;
> +	struct iio_dev *indio_dev =3D pf->indio_dev;
> +	struct afe440x_data *afe440x =3D iio_device_get_drvdata(indio_dev);
> +	int ret, bit, i =3D 0;
> +	s32 buffer[12];
7 input channels, align to 64bytes + one timestamp =3D 10 not 12?
I may well be missing something or losing the ability to count!

> +
> +	for_each_set_bit(bit, indio_dev->active_scan_mask,
> +			 indio_dev->masklength) {
> +		ret =3D regmap_read(afe440x->regmap, reg_info[bit].reg,
> +				  &buffer[i++]);
> +		if (ret)
> +			goto err;
> +	}
> +
> +	iio_push_to_buffers_with_timestamp(indio_dev, buffer, pf->timestamp=
);
> +err:
> +	iio_trigger_notify_done(indio_dev->trig);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static const struct iio_trigger_ops afe440x_trigger_ops =3D {
> +	.owner =3D THIS_MODULE,
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
> +static const struct reg_sequence afe4404_reg_sequences[] =3D {
> +	AFE4404_TIMING_PAIRS,
> +	{ AFE440X_CONTROL1, AFE440X_CONTROL1_TIMEREN },
> +	{ AFE4404_TIA_GAIN, AFE4404_TIA_GAIN_RES_50_K },
> +	{ AFE440X_LEDCNTRL, (0xf << AFE4404_LEDCNTRL_ILED1_SHIFT) |
> +			    (0x3 << AFE4404_LEDCNTRL_ILED2_SHIFT) |
> +			    (0x3 << AFE4404_LEDCNTRL_ILED3_SHIFT) },
> +	{ AFE440X_CONTROL2, AFE440X_CONTROL3_OSC_ENABLE	},
> +};
> +
> +static const struct regmap_range afe4404_yes_ranges[] =3D {
> +	regmap_reg_range(AFE440X_LED2VAL, AFE440X_LED1_ALED1VAL),
> +	regmap_reg_range(AFE4404_AVG_LED2_ALED2VAL, AFE4404_AVG_LED1_ALED1V=
AL),
> +};
> +
> +static const struct regmap_access_table afe4404_volatile_table =3D {
> +	.yes_ranges =3D afe4404_yes_ranges,
> +	.n_yes_ranges =3D ARRAY_SIZE(afe4404_yes_ranges),
> +};
> +
> +static const struct regmap_config afe4404_regmap_config =3D {
> +	.reg_bits =3D 8,
> +	.val_bits =3D 24,
> +
> +	.max_register =3D AFE4404_AVG_LED1_ALED1VAL,
> +	.cache_type =3D REGCACHE_RBTREE,
> +	.volatile_table =3D &afe4404_volatile_table,
> +};
> +
> +#ifdef CONFIG_OF
> +static const struct of_device_id afe4404_of_match[] =3D {
> +	{ .compatible =3D "ti,afe4404", },
> +	{ /* sentinel */ },
> +};
> +MODULE_DEVICE_TABLE(of, afe4404_of_match);
> +#endif
> +
> +static int afe440x_suspend(struct device *dev)
> +{
> +	struct afe440x_data *afe440x =3D dev_get_drvdata(dev);
> +	int ret;
> +
> +	ret =3D regmap_update_bits(afe440x->regmap, AFE440X_CONTROL2,
> +				 AFE440X_CONTROL2_PDN_AFE,
> +				 AFE440X_CONTROL2_PDN_AFE);
> +	if (ret)
> +		return ret;
> +
> +	ret =3D regulator_disable(afe440x->regulator);
> +	if (ret) {
> +		dev_err(dev, "Unable to disable regulator\n");
> +		return ret;
> +	}
Might get a static checker pointing out that a successful regulator_dis=
able
returns 0 anyway so you might as well have a single
return ret; here.  I don't care either way other than reducing noise
from those autobuilds.
> +
> +	return 0;
> +}
> +
> +static int afe440x_resume(struct device *dev)
> +{
> +	struct afe440x_data *afe440x =3D dev_get_drvdata(dev);
> +	int ret;
> +
> +	ret =3D regmap_update_bits(afe440x->regmap, AFE440X_CONTROL2,
> +				 AFE440X_CONTROL2_PDN_AFE, 0);
> +	if (ret)
> +		return ret;
> +
> +	ret =3D regulator_enable(afe440x->regulator);
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
This looks pretty good and clean though not quite traditional from
an IIO driver point of view (separate private data allocation)

I'd personally have had the devm_iio_device_alloc in the main probe
function then populated it in this function.  However,
I can happily live with this slight varient as it is easy enough
to follow with your nice const info structure approach.

> +static int afe440x_iio_setup(struct afe440x_data *afe440x,
> +			     const struct afe440x_info *afe440x_info)
> +{
> +	struct iio_dev *indio_dev;
> +	int ret;
> +
> +	indio_dev =3D devm_iio_device_alloc(afe440x->dev, 0);
> +	if (!indio_dev) {
> +		dev_err(afe440x->dev, "Unable to allocate IIO device\n");
> +		return -ENOMEM;
> +	}
> +
> +	iio_device_set_drvdata(indio_dev, afe440x);
> +
> +	indio_dev->modes =3D INDIO_DIRECT_MODE;
> +	indio_dev->dev.parent =3D afe440x->dev;
> +	indio_dev->channels =3D afe440x_info->channels;
> +	indio_dev->num_channels =3D afe440x_info->num_channels;
> +	indio_dev->name =3D afe440x_info->name;
> +	indio_dev->info =3D afe440x_info->info;
> +
> +	if (afe440x->irq > 0) {
> +		afe440x->trig =3D devm_iio_trigger_alloc(afe440x->dev,
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
> +		afe440x->trig->ops =3D &afe440x_trigger_ops;
> +		afe440x->trig->dev.parent =3D afe440x->dev;
> +
> +		ret =3D iio_trigger_register(afe440x->trig);
> +		if (ret) {
> +			dev_err(afe440x->dev, "Unable to register IIO trigger\n");
> +			return ret;
> +		}
> +
> +		ret =3D devm_request_threaded_irq(afe440x->dev, afe440x->irq,
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
> +	ret =3D iio_triggered_buffer_setup(indio_dev, &iio_pollfunc_store_t=
ime,
> +					 &afe440x_trigger_handler, NULL);
> +	if (ret) {
> +		dev_err(afe440x->dev, "Unable to setup buffer\n");
> +		return ret;
> +	}
> +
> +	ret =3D devm_iio_device_register(afe440x->dev, indio_dev);
Ah.  It took a lot of persuading to get me to allow the devm version
of this function in the first place.  It is only appropriate for
very simple devices where there is nothing to turn off.  The issue
is that it creates a race condition in the remove function (see below).
> +	if (ret) {
> +		dev_err(afe440x->dev, "Unable to register IIO device\n");
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +static const struct afe440x_info afe4404_info =3D {
> +	.name =3D AFE4404_DRIVER_NAME,
> +	.channels =3D afe4404_channels,
> +	.num_channels =3D ARRAY_SIZE(afe4404_channels),
> +	.info =3D &afe440x_iio_info,
> +};
> +
> +static int afe4404_probe(struct i2c_client *client,
> +			 const struct i2c_device_id *id)
> +{
> +	struct afe440x_data *afe440x;
> +	int ret;
> +
> +	afe440x =3D devm_kzalloc(&client->dev, sizeof(*afe440x), GFP_KERNEL=
);
> +	if (!afe440x)
> +		return -ENOMEM;
> +
> +	i2c_set_clientdata(client, afe440x);
> +
> +	afe440x->dev =3D &client->dev;
> +	afe440x->irq =3D client->irq;
> +
> +	afe440x->regmap =3D devm_regmap_init_i2c(client, &afe4404_regmap_co=
nfig);
> +	if (IS_ERR(afe440x->regmap)) {
> +		dev_err(afe440x->dev, "Unable to allocate register map\n");
> +		return PTR_ERR(afe440x->regmap);
> +	}
> +
> +	afe440x->regulator =3D devm_regulator_get(afe440x->dev, "tx_sup");
> +	if (IS_ERR(afe440x->regulator)) {
> +		dev_err(afe440x->dev, "Unable to get regulator\n");
> +		return PTR_ERR(afe440x->regulator);
> +	}
> +	ret =3D regulator_enable(afe440x->regulator);
> +	if (ret) {
> +		dev_err(afe440x->dev, "Unable to enable regulator\n");
> +		return ret;
> +	}
> +
> +	ret =3D regmap_write(afe440x->regmap, AFE440X_CONTROL0,
> +			   AFE440X_CONTROL0_SW_RESET);
> +	if (ret) {
> +		dev_err(afe440x->dev, "Unable to reset device\n");
> +		return ret;
> +	}
> +
> +	ret =3D regmap_register_patch(afe440x->regmap, afe4404_reg_sequence=
s,
> +				    ARRAY_SIZE(afe4404_reg_sequences));
> +	if (ret) {
> +		dev_err(afe440x->dev, "Unable to set register defaults\n");
> +		return ret;
> +	}
> +
> +	return afe440x_iio_setup(afe440x, &afe4404_info);
> +}
> +
> +static int afe4404_remove(struct i2c_client *client)
> +{
> +	struct afe440x_data *afe440x =3D i2c_get_clientdata(client);
> +	int ret;
> +
> +	ret =3D regulator_disable(afe440x->regulator);
> +	if (ret) {
> +		dev_err(afe440x->dev, "Unable to disable regulator\n");
> +		return ret;
> +	}
As the iio_device_unregister does not occur until after this function t=
he
result is that we turn this regulator off whilst the userspace / kernel=
space
interfaces to the device are still active.  Hence you can get a read in
the meantime and a rather unpredictable result.

The sad result of this is you need to not use the devm_ version of
iio_device_register but instead the unmanaged one and remove it by
hand at the start of the remove function.   Now if there was a managed
regulator enable then you could do it all with managed interfaces
and not have a remove function at all,  but there are probably good
reasons why that doesn't exist.
> +
> +	return 0;
> +}
> +
> +static const struct i2c_device_id afe4404_ids[] =3D {
> +	{ "afe4404", 0 },
> +	{ /* sentinel */ },
> +};
> +MODULE_DEVICE_TABLE(i2c, afe4404_ids);
> +
> +static struct i2c_driver afe4404_i2c_driver =3D {
> +	.driver =3D {
> +		.name =3D AFE4404_DRIVER_NAME,
> +		.of_match_table =3D of_match_ptr(afe4404_of_match),
> +		.pm =3D &afe440x_pm_ops,
> +	},
> +	.probe =3D afe4404_probe,
> +	.remove =3D afe4404_remove,
> +	.id_table =3D afe4404_ids,
> +};
> +module_i2c_driver(afe4404_i2c_driver);
> +
> +MODULE_AUTHOR("Andrew F. Davis <afd-l0cyMroinI0@public.gmane.org>");
> +MODULE_DESCRIPTION("TI AFE4404 Heart Rate and Pulse Oximeter");
> +MODULE_LICENSE("GPL");
> diff --git a/drivers/iio/health/afe440x.h b/drivers/iio/health/afe440=
x.h
> new file mode 100644
> index 0000000..575e528
> --- /dev/null
> +++ b/drivers/iio/health/afe440x.h
> @@ -0,0 +1,202 @@
> +/*
> + * AFE440X Heart Rate Monitors and Low-Cost Pulse Oximeters
> + *
> + * Copyright (C) 2015 Texas Instruments Incorporated - http://www.ti=
=2Ecom/
> + *	Andrew F. Davis <afd-l0cyMroinI0@public.gmane.org>
> + *
> + * This program is free software; you can redistribute it and/or mod=
ify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful, b=
ut
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
> +#define AFE440X_TIAGAIN			0x20
Just a small point, but you have some of these redefined
in the afe4403 drivers additional header.
Now the contents is different but the register numbering
matches.  I'd be tempted to make the difference more
obvious by renaming the AFE4404 versions without the X where
their contents is considerably different (even if they have the
same address..

I'd also push them down into the C file so only shared elements
across the two drivers are defined here.

Just makes the scope of the definitions more obvious.


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
> +struct afe440x_reg_info {
> +	unsigned int reg;
> +	unsigned int offreg;
> +	unsigned int shift;
> +	unsigned int mask;
> +};
> +
> +#define AFE440X_REG_INFO(_id, _reg, _offreg, _sm)		\
> +	[_id] =3D {						\
> +		.reg =3D _reg,					\
> +		.offreg =3D _offreg,				\
> +		.shift =3D _sm ## _SHIFT,				\
> +		.mask =3D _sm ## _MASK,				\
> +	}
> +
> +#define AFE440X_INTENSITY_CHAN(_index, _name, _mask)		\
> +	{							\
> +		.type =3D IIO_INTENSITY,				\
> +		.channel =3D _index,				\
> +		.address =3D _index,				\
> +		.scan_index =3D _index,				\
> +		.scan_type =3D {					\
> +				.sign =3D 's',			\
> +				.realbits =3D 24,			\
> +				.storagebits =3D 32,		\
> +				.endianness =3D IIO_CPU,		\
> +		},						\
> +		.extend_name =3D _name,				\
> +		.info_mask_separate =3D BIT(IIO_CHAN_INFO_RAW) |	\
> +			_mask,					\
> +	}
> +
> +#define AFE440X_CURRENT_CHAN(_index, _name)			\
> +	{							\
> +		.type =3D IIO_CURRENT,				\
> +		.channel =3D _index,				\
> +		.address =3D _index,				\
> +		.scan_index =3D _index,				\
> +		.extend_name =3D _name,				\
> +		.info_mask_separate =3D BIT(IIO_CHAN_INFO_RAW) |	\
> +			BIT(IIO_CHAN_INFO_SCALE),		\
> +		.output =3D true,					\
> +	}
> +
> +enum reg_type {
> +	SIMPLE,
> +	RESISTANCE,
> +	CAPACITANCE,
> +};
> +
> +struct afe440x_reg_lookup {
> +	int integer;
> +	int fract;
> +};
> +
> +struct afe440x_attr {
> +	struct device_attribute dev_attr;
> +	unsigned int reg;
> +	unsigned int shift;
> +	unsigned int mask;
> +	enum reg_type type;
> +};
> +
> +#define to_afe440x_attr(_dev_attr)				\
> +	container_of(_dev_attr, struct afe440x_attr, dev_attr)
> +
> +#define AFE440X_ATTR(_name, _reg, _field, _type)		\
> +	struct afe440x_attr afe440x_attr_##_name =3D {		\
> +		.dev_attr =3D __ATTR(_name, (S_IRUGO | S_IWUSR),	\
> +				   afe440x_show_register,	\
> +				   afe440x_store_register),	\
> +		.reg =3D _reg,					\
> +		.shift =3D _field ## _SHIFT,			\
> +		.mask =3D _field ## _MASK,			\
> +		.type =3D _type,					\
> +	}
> +
> +/**
> + * struct afe440x_info
> + * @name - Device name
> + * @channels - IIO channels
> + * @num_channels - Number of IIO channels
> + * @info - IIO info for device
> + */
> +struct afe440x_info {
> +	const char *name;
> +	struct iio_chan_spec const *channels;
> +	int num_channels;
> +	const struct iio_info *info;
> +};
> +
> +/**
> + * struct afe440x_data
> + * @dev - Device structure
> + * @regmap - Register map of the device
> + * @regulator - Pointer to the regulator for the IC
> + * @trig - IIO trigger for this device
> + * @irq - ADC_RDY line interrupt number
> + */
> +struct afe440x_data {
> +	struct device *dev;
> +	struct regmap *regmap;
> +	struct spi_device *spi;
> +	struct regulator *regulator;
> +	struct iio_trigger *trig;
> +	int irq;
> +};
> +
> +#endif /* _AFE440X_H */
>=20
