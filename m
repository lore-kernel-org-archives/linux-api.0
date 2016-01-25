From: "Andrew F. Davis" <afd-l0cyMroinI0@public.gmane.org>
Subject: Re: [PATCH v4 4/4] iio: health: Add driver for the TI AFE4403 heart
 monitor
Date: Mon, 25 Jan 2016 14:36:45 -0600
Message-ID: <56A6875D.1090505@ti.com>
References: <1453742941-12086-1-git-send-email-afd@ti.com>
 <1453742941-12086-5-git-send-email-afd@ti.com>
 <alpine.DEB.2.02.1601251941370.14521@pmeerw.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.02.1601251941370.14521-jW+XmwGofnusTnJN9+BGXg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Meerwald-Stadler <pmeerw-jW+XmwGofnusTnJN9+BGXg@public.gmane.org>
Cc: Jonathan Cameron <jic23-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hartmut Knaack <knaack.h-Mmb7MZpHnFY@public.gmane.org>, Lars-Peter Clausen <lars-Qo5EllUWu/uELgA04lAiVw@public.gmane.org>, Dan Murphy <dmurphy-l0cyMroinI0@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, linux-iio-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 01/25/2016 02:21 PM, Peter Meerwald-Stadler wrote:
>
>> Add driver for the TI AFE4403 heart rate monitor and pulse oximeter.
>> This device detects reflected LED light fluctuations and presents an ADC
>> value to the user space for further signal processing.
>
> some comments below
>
>> Data sheet located here:
>> http://www.ti.com/product/AFE4403/datasheet
>>
>> Signed-off-by: Andrew F. Davis <afd-l0cyMroinI0@public.gmane.org>
>> ---
>>   drivers/iio/health/Kconfig   |  12 +
>>   drivers/iio/health/Makefile  |   1 +
>>   drivers/iio/health/afe4403.c | 698 +++++++++++++++++++++++++++++++++++++++++++
>>   3 files changed, 711 insertions(+)
>>   create mode 100644 drivers/iio/health/afe4403.c
>>
>> diff --git a/drivers/iio/health/Kconfig b/drivers/iio/health/Kconfig
>> index 632a14b..f0c1977 100644
>> --- a/drivers/iio/health/Kconfig
>> +++ b/drivers/iio/health/Kconfig
>> @@ -7,6 +7,18 @@ menu "Health Sensors"
>>
>>   menu "Heart Rate Monitors"
>>
>> +config AFE4403
>> +	tristate "TI AFE4403 Heart Rate Monitor"
>> +	depends on SPI_MASTER
>> +	select IIO_BUFFER
>> +	select IIO_TRIGGERED_BUFFER
>> +	help
>> +	  Say yes to choose the Texas Instruments AFE4403
>> +	  heart rate monitor and low-cost pulse oximeter.
>> +
>> +	  To compile this driver as a module, choose M here: the
>> +	  module will be called afe4403.
>> +
>>   config AFE4404
>>   	tristate "TI AFE4404 heart rate and pulse oximeter sensor"
>>   	depends on I2C
>> diff --git a/drivers/iio/health/Makefile b/drivers/iio/health/Makefile
>> index b37c0d5..9955a2a 100644
>> --- a/drivers/iio/health/Makefile
>> +++ b/drivers/iio/health/Makefile
>> @@ -4,5 +4,6 @@
>>
>>   # When adding new entries keep the list in alphabetical order
>>
>> +obj-$(CONFIG_AFE4403)		+= afe4403.o
>>   obj-$(CONFIG_AFE4404)		+= afe4404.o
>>   obj-$(CONFIG_MAX30100)		+= max30100.o
>> diff --git a/drivers/iio/health/afe4403.c b/drivers/iio/health/afe4403.c
>> new file mode 100644
>> index 0000000..2c8565f
>> --- /dev/null
>> +++ b/drivers/iio/health/afe4403.c
>> @@ -0,0 +1,698 @@
>> +/*
>> + * AFE4403 Heart Rate Monitors and Low-Cost Pulse Oximeters
>> + *
>> + * Copyright (C) 2015 Texas Instruments Incorporated - http://www.ti.com/
>> + *	Andrew F. Davis <afd-l0cyMroinI0@public.gmane.org>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful, but
>> + * WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
>> + * General Public License for more details.
>> + */
>> +
>> +#include <linux/device.h>
>> +#include <linux/err.h>
>> +#include <linux/interrupt.h>
>> +#include <linux/kernel.h>
>> +#include <linux/module.h>
>> +#include <linux/regmap.h>
>> +#include <linux/spi/spi.h>
>> +#include <linux/sysfs.h>
>> +#include <linux/regulator/consumer.h>
>> +
>> +#include <linux/iio/iio.h>
>> +#include <linux/iio/sysfs.h>
>> +#include <linux/iio/buffer.h>
>> +#include <linux/iio/trigger.h>
>> +#include <linux/iio/triggered_buffer.h>
>> +#include <linux/iio/trigger_consumer.h>
>> +
>> +#include "afe440x.h"
>> +
>> +#define AFE4403_DRIVER_NAME		"afe4403"
>> +
>> +/* AFE4403 Registers */
>> +#define AFE4403_TIAGAIN			0x20
>> +#define AFE4403_TIA_AMB_GAIN		0x21
>> +
>> +/* AFE4403 GAIN register fields */
>> +#define AFE4403_TIAGAIN_RES_MASK	GENMASK(2, 0)
>> +#define AFE4403_TIAGAIN_RES_SHIFT	0
>> +#define AFE4403_TIAGAIN_CAP_MASK	GENMASK(7, 3)
>> +#define AFE4403_TIAGAIN_CAP_SHIFT	3
>> +
>> +/* AFE4403 LEDCNTRL register fields */
>> +#define AFE440X_LEDCNTRL_LED1_MASK		GENMASK(15, 8)
>
> if these defines are generic for AFE440X, they should go to the header
> file; if not, they should be named AFE4403
>

The register "AFE440X_LEDCNTRL" is common, the field "LED1" in that
register is not, only common field definitions are in the common
header.

>> +#define AFE440X_LEDCNTRL_LED1_SHIFT		8
>> +#define AFE440X_LEDCNTRL_LED2_MASK		GENMASK(7, 0)
>> +#define AFE440X_LEDCNTRL_LED2_SHIFT		0
>> +#define AFE440X_LEDCNTRL_LED_RANGE_MASK		GENMASK(17, 16)
>> +#define AFE440X_LEDCNTRL_LED_RANGE_SHIFT	16
>> +
>> +/* AFE4403 CONTROL2 register fields */
>> +#define AFE440X_CONTROL2_PWR_DWN_TX	BIT(2)
>> +#define AFE440X_CONTROL2_EN_SLOW_DIAG	BIT(8)
>> +#define AFE440X_CONTROL2_DIAG_OUT_TRI	BIT(10)
>> +#define AFE440X_CONTROL2_TX_BRDG_MOD	BIT(11)
>> +#define AFE440X_CONTROL2_TX_REF_MASK	GENMASK(18, 17)
>> +#define AFE440X_CONTROL2_TX_REF_SHIFT	17
>> +
>> +/* AFE4404 NULL fields */
>> +#define NULL_MASK	0
>> +#define NULL_SHIFT	0
>
> needed? prefix?
>

Same as other patch.

>> +
>> +/* AFE4403 LEDCNTRL values */
>> +#define AFE440X_LEDCNTRL_RANGE_TX_HALF	0x1
>> +#define AFE440X_LEDCNTRL_RANGE_TX_FULL	0x2
>> +#define AFE440X_LEDCNTRL_RANGE_TX_OFF	0x3
>> +
>> +/* AFE4403 CONTROL2 values */
>> +#define AFE440X_CONTROL2_TX_REF_025	0x0
>> +#define AFE440X_CONTROL2_TX_REF_050	0x1
>> +#define AFE440X_CONTROL2_TX_REF_100	0x2
>> +#define AFE440X_CONTROL2_TX_REF_075	0x3
>> +
>> +/* AFE4403 CONTROL3 values */
>> +#define AFE440X_CONTROL3_CLK_DIV_2	0x0
>
> AFE440X (then move to .h) or AFE4403?
>

Same as above.

>> +#define AFE440X_CONTROL3_CLK_DIV_4	0x2
>> +#define AFE440X_CONTROL3_CLK_DIV_6	0x3
>> +#define AFE440X_CONTROL3_CLK_DIV_8	0x4
>> +#define AFE440X_CONTROL3_CLK_DIV_12	0x5
>> +#define AFE440X_CONTROL3_CLK_DIV_1	0x7
>> +
>> +/* AFE4403 TIAGAIN_CAP values */
>> +#define AFE4403_TIAGAIN_CAP_5_P		0x0
>> +#define AFE4403_TIAGAIN_CAP_10_P	0x1
>> +#define AFE4403_TIAGAIN_CAP_20_P	0x2
>> +#define AFE4403_TIAGAIN_CAP_30_P	0x3
>> +#define AFE4403_TIAGAIN_CAP_55_P	0x8
>> +#define AFE4403_TIAGAIN_CAP_155_P	0x10
>> +
>> +/* AFE4403 TIAGAIN_RES values */
>> +#define AFE4403_TIAGAIN_RES_500_K	0x0
>> +#define AFE4403_TIAGAIN_RES_250_K	0x1
>> +#define AFE4403_TIAGAIN_RES_100_K	0x2
>> +#define AFE4403_TIAGAIN_RES_50_K	0x3
>> +#define AFE4403_TIAGAIN_RES_25_K	0x4
>> +#define AFE4403_TIAGAIN_RES_10_K	0x5
>> +#define AFE4403_TIAGAIN_RES_1_M		0x6
>> +#define AFE4403_TIAGAIN_RES_NONE	0x7
>> +
>> +/**
>> + * struct afe4403_data
>> + * @dev - Device structure
>> + * @spi - SPI device handle
>> + * @regmap - Register map of the device
>> + * @regulator - Pointer to the regulator for the IC
>> + * @trig - IIO trigger for this device
>> + * @irq - ADC_RDY line interrupt number
>> + */
>> +struct afe4403_data {
>> +	struct device *dev;
>> +	struct spi_device *spi;
>> +	struct regmap *regmap;
>> +	struct regulator *regulator;
>> +	struct iio_trigger *trig;
>> +	int irq;
>> +};
>> +
>> +enum afe4403_chan_id {
>> +	LED1,
>> +	ALED1,
>> +	LED2,
>> +	ALED2,
>> +	LED1_ALED1,
>> +	LED2_ALED2,
>> +	ILED1,
>> +	ILED2,
>> +};
>> +
>> +static const struct afe440x_reg_info afe4403_reg_info[] = {
>> +	AFE440X_REG_INFO(LED1, AFE440X_LED1VAL, 0, NULL),
>> +	AFE440X_REG_INFO(ALED1, AFE440X_ALED1VAL, 0, NULL),
>> +	AFE440X_REG_INFO(LED2, AFE440X_LED2VAL, 0, NULL),
>> +	AFE440X_REG_INFO(ALED2, AFE440X_ALED2VAL, 0, NULL),
>> +	AFE440X_REG_INFO(LED1_ALED1, AFE440X_LED1_ALED1VAL, 0, NULL),
>> +	AFE440X_REG_INFO(LED2_ALED2, AFE440X_LED2_ALED2VAL, 0, NULL),
>> +	AFE440X_REG_INFO(ILED1, AFE440X_LEDCNTRL, 0, AFE440X_LEDCNTRL_LED1),
>> +	AFE440X_REG_INFO(ILED2, AFE440X_LEDCNTRL, 0, AFE440X_LEDCNTRL_LED2),
>> +};
>> +
>> +static const struct iio_chan_spec afe4403_channels[] = {
>> +	/* ADC values */
>> +	AFE440X_INTENSITY_CHAN(LED1, "led1", 0),
>> +	AFE440X_INTENSITY_CHAN(ALED1, "led1_ambient", 0),
>> +	AFE440X_INTENSITY_CHAN(LED2, "led2", 0),
>> +	AFE440X_INTENSITY_CHAN(ALED2, "led2_ambient", 0),
>> +	AFE440X_INTENSITY_CHAN(LED1_ALED1, "led1-led1_ambient", 0),
>> +	AFE440X_INTENSITY_CHAN(LED2_ALED2, "led2-led2_ambient", 0),
>> +	/* LED current */
>> +	AFE440X_CURRENT_CHAN(ILED1, "led1"),
>> +	AFE440X_CURRENT_CHAN(ILED2, "led2"),
>> +};
>> +
>> +static const struct afe440x_val_table afe4403_res_table[] = {
>> +	{ 500000 }, { 250000 }, { 100000 }, { 50000 },
>> +	{ 25000 }, { 10000 }, { 1000000 }, { 0 },
>> +};
>> +AFE440X_TABLE_ATTR(tia_resistance_available, afe4403_res_table);
>> +
>> +static const struct afe440x_val_table afe4403_cap_table[] = {
>> +	{ 0, 5000 }, { 0, 10000 }, { 0, 20000 }, { 0, 25000 },
>> +	{ 0, 30000 }, { 0, 35000 }, { 0, 45000 }, { 0, 50000 },
>> +	{ 0, 55000 }, { 0, 60000 }, { 0, 70000 }, { 0, 75000 },
>> +	{ 0, 80000 }, { 0, 85000 }, { 0, 95000 }, { 0, 100000 },
>> +	{ 0, 155000 }, { 0, 160000 }, { 0, 170000 }, { 0, 175000 },
>> +	{ 0, 180000 }, { 0, 185000 }, { 0, 195000 }, { 0, 200000 },
>> +	{ 0, 205000 }, { 0, 210000 }, { 0, 220000 }, { 0, 225000 },
>> +	{ 0, 230000 }, { 0, 235000 }, { 0, 245000 }, { 0, 250000 },
>> +};
>> +AFE440X_TABLE_ATTR(tia_capacitance_available, afe4403_cap_table);
>> +
>> +static ssize_t afe440x_show_register(struct device *dev,
>> +				     struct device_attribute *attr,
>> +				     char *buf)
>
> common code with afe4404?
>

Yes, all functions/structs/variables that are identical are given
the "afe440x" name, this way they can maybe be moved somewhere
common at some point and not require any renaming in the calling
functions.

[...]
