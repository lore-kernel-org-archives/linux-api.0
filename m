From: "Andrew F. Davis" <afd-l0cyMroinI0@public.gmane.org>
Subject: Re: [PATCH v3 3/5] iio: health: Add driver for the TI AFE4404 heart
 monitor
Date: Wed, 30 Dec 2015 11:23:41 -0600
Message-ID: <5684131D.1010705@ti.com>
References: <1450132561-5245-1-git-send-email-afd@ti.com>
 <1450132561-5245-4-git-send-email-afd@ti.com> <56798A53.9080905@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56798A53.9080905-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jonathan Cameron <jic23-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Hartmut Knaack <knaack.h-Mmb7MZpHnFY@public.gmane.org>, Lars-Peter Clausen <lars-Qo5EllUWu/uELgA04lAiVw@public.gmane.org>, Peter Meerwald <pmeerw-jW+XmwGofnusTnJN9+BGXg@public.gmane.org>
Cc: devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-iio-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 12/22/2015 11:37 AM, Jonathan Cameron wrote:
> On 14/12/15 22:35, Andrew F. Davis wrote:
>> Add driver for the TI AFE4404 heart rate monitor and pulse oximeter.
>> This device detects reflected LED light fluctuations and presents an=
 ADC
>> value to the user space for further signal processing.
>>
>> Datasheet: http://www.ti.com/product/AFE4404/datasheet
>>
>> Signed-off-by: Andrew F. Davis <afd-l0cyMroinI0@public.gmane.org>
> Hi Andrew,
>
> Sorry I didn't get to this a the weekend. We are now likely to just
> miss the merge window so lets get this cleaned up and ready to go
> for the start of the next cycle (probably 3rd week of January)
>

No problem, I've been on holiday these last few days anyway.

> Looking good mostly.  A few minor bits and bobs I either missed befor=
e
> or that got introduced as side effects of your changes.
> I thought about fixing them up and applying, but I think it's just
> a shade to many changes and I need your feedback on a couple of them
> anyway.
>
> Jonathan
>
>> ---
>>   .../ABI/testing/sysfs-bus-iio-health-afe4404       |  60 ++
>>   drivers/iio/Kconfig                                |   1 +
>>   drivers/iio/Makefile                               |   1 +
>>   drivers/iio/health/Kconfig                         |  25 +
>>   drivers/iio/health/Makefile                        |   6 +
>>   drivers/iio/health/afe4404.c                       | 700 +++++++++=
++++++++++++
>>   drivers/iio/health/afe440x.h                       | 202 ++++++
>>   7 files changed, 995 insertions(+)
>>   create mode 100644 Documentation/ABI/testing/sysfs-bus-iio-health-=
afe4404
>>   create mode 100644 drivers/iio/health/Kconfig
>>   create mode 100644 drivers/iio/health/Makefile
>>   create mode 100644 drivers/iio/health/afe4404.c
>>   create mode 100644 drivers/iio/health/afe440x.h
>>
>> diff --git a/Documentation/ABI/testing/sysfs-bus-iio-health-afe4404 =
b/Documentation/ABI/testing/sysfs-bus-iio-health-afe4404
>> new file mode 100644
>> index 0000000..b01ca47
>> --- /dev/null
>> +++ b/Documentation/ABI/testing/sysfs-bus-iio-health-afe4404
>> @@ -0,0 +1,60 @@
>> +What:		/sys/bus/iio/devices/iio:deviceX/tia_resistanceY
>> +		/sys/bus/iio/devices/iio:deviceX/tia_capacitanceY
>> +Date:		December 2015
>> +KernelVersion:
>> +Contact:	Andrew F. Davis <afd-l0cyMroinI0@public.gmane.org>
>> +Description:
>> +		Get and set the resistance and the capacitance settings for the
>> +		Transimpedance Amplifier. Y is 1 for Rf1 and Cf1, Y is 2 for
>> +		Rf2 and Cf2 values.
>> +		Valid Resistance settings are 500000, 250000, 100000, 50000,
>> +		25000, 10000, 1000000, and 2000000 Ohms.
>> +		Valid capacitance settings are 5, 2.5, 10, 7.5, 20, 17.5, 25,
>> +		and 22.5 picoFarads.
> Defined units for IIO are nanofarads - see sysfs-bus-iio.
> Would really like to keep this consistent and doesn't look like that =
should
> be terribly hard to do here.
>

Ah, for some reason I thought pico, will fix.

>> +
>> +What:		/sys/bus/iio/devices/iio:deviceX/tia_separate_en
>> +Date:		December 2015
>> +KernelVersion:
>> +Contact:	Andrew F. Davis <afd-l0cyMroinI0@public.gmane.org>
>> +Description:
>> +		Enable or disable separate settings for the TransImpedance
>> +		Amplifier above, when disabled both values are set by the
>> +		first channel.
>> +
>> +What:		/sys/bus/iio/devices/iio:deviceX/in_intensity_ledY_raw
>> +		/sys/bus/iio/devices/iio:deviceX/in_intensity_ledY_ambient_raw
>> +Date:		December 2015
>> +KernelVersion:
>> +Contact:	Andrew F. Davis <afd-l0cyMroinI0@public.gmane.org>
>> +Description:
>> +		Get measured values from the ADC for these stages. Y is the
>> +		specific LED number. The values are expressed in 24-bit twos
>> +		complement.
>> +
>> +What:		/sys/bus/iio/devices/iio:deviceX/in_intensity_ledY-ledY_ambi=
ent_raw
>> +Date:		December 2015
>> +KernelVersion:
>> +Contact:	Andrew F. Davis <afd-l0cyMroinI0@public.gmane.org>
>> +Description:
>> +		Get differential values from the ADC for these stages. Y is the
>> +		specific LED number. The values are expressed in 24-bit twos
>> +		complement for the specified LEDs.
>> +
>> +What:		/sys/bus/iio/devices/iio:deviceX/out_current_ledY_offset
>> +		/sys/bus/iio/devices/iio:deviceX/out_current_ledY_ambient_offset
>> +Date:		December 2015
>> +KernelVersion:
>> +Contact:	Andrew F. Davis <afd-l0cyMroinI0@public.gmane.org>
>> +Description:
>> +		Get and set the offset cancellation DAC setting for these
>> +		stages. The values are expressed in 5-bit sign=E2=80=93magnitude.
>> +
>> +What:		/sys/bus/iio/devices/iio:deviceX/out_current_ledY_raw
>> +Date:		December 2015
>> +KernelVersion:
>> +Contact:	Andrew F. Davis <afd-l0cyMroinI0@public.gmane.org>
>> +Description:
>> +		Get and set the LED current for the specified LED. Y is the
>> +		specific LED number.
>> +		Values range from 0 -> 63. Current is calculated by
>> +		current =3D value * 0.8mA
> Otherwise, we both know that the ABI is less than ideal, but it's pro=
bably
> the best solution we can easily manage so lets go with this.
> While it's not easy to revise this in future it can be done should we
> end up with a more generic way of representing the complex cases seen=
 here
> (no idea what that might be!)
>

Sounds good.

>> diff --git a/drivers/iio/Kconfig b/drivers/iio/Kconfig
>> index 66792e7..ac085ab 100644
>> --- a/drivers/iio/Kconfig
>> +++ b/drivers/iio/Kconfig
>> @@ -52,6 +52,7 @@ source "drivers/iio/common/Kconfig"
>>   source "drivers/iio/dac/Kconfig"
>>   source "drivers/iio/frequency/Kconfig"
>>   source "drivers/iio/gyro/Kconfig"
>> +source "drivers/iio/health/Kconfig"
>>   source "drivers/iio/humidity/Kconfig"
>>   source "drivers/iio/imu/Kconfig"
>>   source "drivers/iio/light/Kconfig"
>> diff --git a/drivers/iio/Makefile b/drivers/iio/Makefile
>> index aeca726..6c5eb2a 100644
>> --- a/drivers/iio/Makefile
>> +++ b/drivers/iio/Makefile
>> @@ -18,6 +18,7 @@ obj-y +=3D common/
>>   obj-y +=3D dac/
>>   obj-y +=3D gyro/
>>   obj-y +=3D frequency/
>> +obj-y +=3D health/
>>   obj-y +=3D humidity/
>>   obj-y +=3D imu/
>>   obj-y +=3D light/
>> diff --git a/drivers/iio/health/Kconfig b/drivers/iio/health/Kconfig
>> new file mode 100644
>> index 0000000..526e7af
>> --- /dev/null
>> +++ b/drivers/iio/health/Kconfig
>> @@ -0,0 +1,25 @@
>> +#
>> +# Health drivers
>> +#
>> +# When adding new entries keep the list in alphabetical order
>> +
>> +menu "Health"
> I'll merge this as appropriate given we now have a health
> driver in tree (the simpler maxim one that got going after this one).

ACK

>> +
>> +menu "Heart Rate Monitors"
>> +
>> +config AFE4404
>> +	tristate "TI AFE4404 Heart Rate Monitor"
>> +	depends on I2C
>> +	select REGMAP_I2C
>> +	select IIO_BUFFER
>> +	select IIO_TRIGGERED_BUFFER
>> +	help
>> +	  Say yes to choose the Texas Instruments AFE4404
>> +	  heart rate monitor and low-cost pulse oximeter.
>> +
>> +	  To compile this driver as a module, choose M here: the
>> +	  module will be called afe4404.
>> +
>> +endmenu
>> +
>> +endmenu
>> diff --git a/drivers/iio/health/Makefile b/drivers/iio/health/Makefi=
le
>> new file mode 100644
>> index 0000000..c108c8d
>> --- /dev/null
>> +++ b/drivers/iio/health/Makefile
>> @@ -0,0 +1,6 @@
>> +#
>> +# Makefile for IIO Health drivers
>> +#
>> +# When adding new entries keep the list in alphabetical order
>> +
>> +obj-$(CONFIG_AFE4404) +=3D afe4404.o
>> diff --git a/drivers/iio/health/afe4404.c b/drivers/iio/health/afe44=
04.c
>> new file mode 100644
>> index 0000000..d199a35
>> --- /dev/null
>> +++ b/drivers/iio/health/afe4404.c
>> @@ -0,0 +1,700 @@

[...]

>> +static irqreturn_t afe440x_trigger_handler(int irq, void *private)
>> +{
>> +	struct iio_poll_func *pf =3D private;
>> +	struct iio_dev *indio_dev =3D pf->indio_dev;
>> +	struct afe440x_data *afe440x =3D iio_device_get_drvdata(indio_dev)=
;
>> +	int ret, bit, i =3D 0;
>> +	s32 buffer[12];
> 7 input channels, align to 64bytes + one timestamp =3D 10 not 12?
> I may well be missing something or losing the ability to count!
>

Left over from when we had 9 channels, will fix, your counting
abilities are still present :)

[...]

>> +
>> +static int afe440x_suspend(struct device *dev)
>> +{
>> +	struct afe440x_data *afe440x =3D dev_get_drvdata(dev);
>> +	int ret;
>> +
>> +	ret =3D regmap_update_bits(afe440x->regmap, AFE440X_CONTROL2,
>> +				 AFE440X_CONTROL2_PDN_AFE,
>> +				 AFE440X_CONTROL2_PDN_AFE);
>> +	if (ret)
>> +		return ret;
>> +
>> +	ret =3D regulator_disable(afe440x->regulator);
>> +	if (ret) {
>> +		dev_err(dev, "Unable to disable regulator\n");
>> +		return ret;
>> +	}
> Might get a static checker pointing out that a successful regulator_d=
isable
> returns 0 anyway so you might as well have a single
> return ret; here.  I don't care either way other than reducing noise
> from those autobuilds.

I didn't get any warnings with mine, so if you don't care either way
I would prefer this way as it feels more consistent to me, we also
can see the successful return value without tracking down what the
last 'ret' assignment considers success.

>> +
>> +	return 0;
>> +}
>> +
>> +static int afe440x_resume(struct device *dev)
>> +{
>> +	struct afe440x_data *afe440x =3D dev_get_drvdata(dev);
>> +	int ret;
>> +
>> +	ret =3D regmap_update_bits(afe440x->regmap, AFE440X_CONTROL2,
>> +				 AFE440X_CONTROL2_PDN_AFE, 0);
>> +	if (ret)
>> +		return ret;
>> +
>> +	ret =3D regulator_enable(afe440x->regulator);
>> +	if (ret) {
>> +		dev_err(dev, "Unable to enable regulator\n");
>> +		return ret;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +SIMPLE_DEV_PM_OPS(afe440x_pm_ops, afe440x_suspend, afe440x_resume);
>> +
> This looks pretty good and clean though not quite traditional from
> an IIO driver point of view (separate private data allocation)
>
> I'd personally have had the devm_iio_device_alloc in the main probe
> function then populated it in this function.  However,
> I can happily live with this slight varient as it is easy enough
> to follow with your nice const info structure approach.
>

The rational for this should be more clear when I break off
all the common code that this allows us.

>> +static int afe440x_iio_setup(struct afe440x_data *afe440x,
>> +			     const struct afe440x_info *afe440x_info)
>> +{
>> +	struct iio_dev *indio_dev;
>> +	int ret;
>> +
>> +	indio_dev =3D devm_iio_device_alloc(afe440x->dev, 0);
>> +	if (!indio_dev) {
>> +		dev_err(afe440x->dev, "Unable to allocate IIO device\n");
>> +		return -ENOMEM;
>> +	}
>> +
>> +	iio_device_set_drvdata(indio_dev, afe440x);
>> +
>> +	indio_dev->modes =3D INDIO_DIRECT_MODE;
>> +	indio_dev->dev.parent =3D afe440x->dev;
>> +	indio_dev->channels =3D afe440x_info->channels;
>> +	indio_dev->num_channels =3D afe440x_info->num_channels;
>> +	indio_dev->name =3D afe440x_info->name;
>> +	indio_dev->info =3D afe440x_info->info;
>> +
>> +	if (afe440x->irq > 0) {
>> +		afe440x->trig =3D devm_iio_trigger_alloc(afe440x->dev,
>> +						       "%s-dev%d",
>> +						       indio_dev->name,
>> +						       indio_dev->id);
>> +		if (!afe440x->trig) {
>> +			dev_err(afe440x->dev, "Unable to allocate IIO trigger\n");
>> +			return -ENOMEM;
>> +		}
>> +
>> +		iio_trigger_set_drvdata(afe440x->trig, indio_dev);
>> +
>> +		afe440x->trig->ops =3D &afe440x_trigger_ops;
>> +		afe440x->trig->dev.parent =3D afe440x->dev;
>> +
>> +		ret =3D iio_trigger_register(afe440x->trig);
>> +		if (ret) {
>> +			dev_err(afe440x->dev, "Unable to register IIO trigger\n");
>> +			return ret;
>> +		}
>> +
>> +		ret =3D devm_request_threaded_irq(afe440x->dev, afe440x->irq,
>> +						iio_trigger_generic_data_rdy_poll,
>> +						NULL, IRQF_ONESHOT,
>> +						afe440x_info->name,
>> +						afe440x->trig);
>> +		if (ret) {
>> +			dev_err(afe440x->dev, "Unable to request IRQ\n");
>> +			return ret;
>> +		}
>> +	}
>> +
>> +	ret =3D iio_triggered_buffer_setup(indio_dev, &iio_pollfunc_store_=
time,
>> +					 &afe440x_trigger_handler, NULL);
>> +	if (ret) {
>> +		dev_err(afe440x->dev, "Unable to setup buffer\n");
>> +		return ret;
>> +	}
>> +
>> +	ret =3D devm_iio_device_register(afe440x->dev, indio_dev);
> Ah.  It took a lot of persuading to get me to allow the devm version
> of this function in the first place.  It is only appropriate for
> very simple devices where there is nothing to turn off.  The issue
> is that it creates a race condition in the remove function (see below=
).
>> +	if (ret) {
>> +		dev_err(afe440x->dev, "Unable to register IIO device\n");
>> +		return ret;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static const struct afe440x_info afe4404_info =3D {
>> +	.name =3D AFE4404_DRIVER_NAME,
>> +	.channels =3D afe4404_channels,
>> +	.num_channels =3D ARRAY_SIZE(afe4404_channels),
>> +	.info =3D &afe440x_iio_info,
>> +};
>> +
>> +static int afe4404_probe(struct i2c_client *client,
>> +			 const struct i2c_device_id *id)
>> +{
>> +	struct afe440x_data *afe440x;
>> +	int ret;
>> +
>> +	afe440x =3D devm_kzalloc(&client->dev, sizeof(*afe440x), GFP_KERNE=
L);
>> +	if (!afe440x)
>> +		return -ENOMEM;
>> +
>> +	i2c_set_clientdata(client, afe440x);
>> +
>> +	afe440x->dev =3D &client->dev;
>> +	afe440x->irq =3D client->irq;
>> +
>> +	afe440x->regmap =3D devm_regmap_init_i2c(client, &afe4404_regmap_c=
onfig);
>> +	if (IS_ERR(afe440x->regmap)) {
>> +		dev_err(afe440x->dev, "Unable to allocate register map\n");
>> +		return PTR_ERR(afe440x->regmap);
>> +	}
>> +
>> +	afe440x->regulator =3D devm_regulator_get(afe440x->dev, "tx_sup");
>> +	if (IS_ERR(afe440x->regulator)) {
>> +		dev_err(afe440x->dev, "Unable to get regulator\n");
>> +		return PTR_ERR(afe440x->regulator);
>> +	}
>> +	ret =3D regulator_enable(afe440x->regulator);
>> +	if (ret) {
>> +		dev_err(afe440x->dev, "Unable to enable regulator\n");
>> +		return ret;
>> +	}
>> +
>> +	ret =3D regmap_write(afe440x->regmap, AFE440X_CONTROL0,
>> +			   AFE440X_CONTROL0_SW_RESET);
>> +	if (ret) {
>> +		dev_err(afe440x->dev, "Unable to reset device\n");
>> +		return ret;
>> +	}
>> +
>> +	ret =3D regmap_register_patch(afe440x->regmap, afe4404_reg_sequenc=
es,
>> +				    ARRAY_SIZE(afe4404_reg_sequences));
>> +	if (ret) {
>> +		dev_err(afe440x->dev, "Unable to set register defaults\n");
>> +		return ret;
>> +	}
>> +
>> +	return afe440x_iio_setup(afe440x, &afe4404_info);
>> +}
>> +
>> +static int afe4404_remove(struct i2c_client *client)
>> +{
>> +	struct afe440x_data *afe440x =3D i2c_get_clientdata(client);
>> +	int ret;
>> +
>> +	ret =3D regulator_disable(afe440x->regulator);
>> +	if (ret) {
>> +		dev_err(afe440x->dev, "Unable to disable regulator\n");
>> +		return ret;
>> +	}
> As the iio_device_unregister does not occur until after this function=
 the
> result is that we turn this regulator off whilst the userspace / kern=
elspace
> interfaces to the device are still active.  Hence you can get a read =
in
> the meantime and a rather unpredictable result.
>
> The sad result of this is you need to not use the devm_ version of
> iio_device_register but instead the unmanaged one and remove it by
> hand at the start of the remove function.   Now if there was a manage=
d
> regulator enable then you could do it all with managed interfaces
> and not have a remove function at all,  but there are probably good
> reasons why that doesn't exist.

Possibly similar reason to this, will fix.

>> +
>> +	return 0;
>> +}
>> +
>> +static const struct i2c_device_id afe4404_ids[] =3D {
>> +	{ "afe4404", 0 },
>> +	{ /* sentinel */ },
>> +};
>> +MODULE_DEVICE_TABLE(i2c, afe4404_ids);
>> +
>> +static struct i2c_driver afe4404_i2c_driver =3D {
>> +	.driver =3D {
>> +		.name =3D AFE4404_DRIVER_NAME,
>> +		.of_match_table =3D of_match_ptr(afe4404_of_match),
>> +		.pm =3D &afe440x_pm_ops,
>> +	},
>> +	.probe =3D afe4404_probe,
>> +	.remove =3D afe4404_remove,
>> +	.id_table =3D afe4404_ids,
>> +};
>> +module_i2c_driver(afe4404_i2c_driver);
>> +
>> +MODULE_AUTHOR("Andrew F. Davis <afd-l0cyMroinI0@public.gmane.org>");
>> +MODULE_DESCRIPTION("TI AFE4404 Heart Rate and Pulse Oximeter");
>> +MODULE_LICENSE("GPL");
>> diff --git a/drivers/iio/health/afe440x.h b/drivers/iio/health/afe44=
0x.h
>> new file mode 100644
>> index 0000000..575e528
>> --- /dev/null
>> +++ b/drivers/iio/health/afe440x.h
>> @@ -0,0 +1,202 @@
>> +/*
>> + * AFE440X Heart Rate Monitors and Low-Cost Pulse Oximeters
>> + *
>> + * Copyright (C) 2015 Texas Instruments Incorporated - http://www.t=
i.com/
>> + *	Andrew F. Davis <afd-l0cyMroinI0@public.gmane.org>
>> + *
>> + * This program is free software; you can redistribute it and/or mo=
dify
>> + * it under the terms of the GNU General Public License version 2 a=
s
>> + * published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful, =
but
>> + * WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GN=
U
>> + * General Public License for more details.
>> + */
>> +
>> +#ifndef _AFE440X_H
>> +#define _AFE440X_H
>> +
>> +/* AFE440X registers */
>> +#define AFE440X_CONTROL0		0x00
>> +#define AFE440X_LED2STC			0x01
>> +#define AFE440X_LED2ENDC		0x02
>> +#define AFE440X_LED1LEDSTC		0x03
>> +#define AFE440X_LED1LEDENDC		0x04
>> +#define AFE440X_ALED2STC		0x05
>> +#define AFE440X_ALED2ENDC		0x06
>> +#define AFE440X_LED1STC			0x07
>> +#define AFE440X_LED1ENDC		0x08
>> +#define AFE440X_LED2LEDSTC		0x09
>> +#define AFE440X_LED2LEDENDC		0x0a
>> +#define AFE440X_ALED1STC		0x0b
>> +#define AFE440X_ALED1ENDC		0x0c
>> +#define AFE440X_LED2CONVST		0x0d
>> +#define AFE440X_LED2CONVEND		0x0e
>> +#define AFE440X_ALED2CONVST		0x0f
>> +#define AFE440X_ALED2CONVEND		0x10
>> +#define AFE440X_LED1CONVST		0x11
>> +#define AFE440X_LED1CONVEND		0x12
>> +#define AFE440X_ALED1CONVST		0x13
>> +#define AFE440X_ALED1CONVEND		0x14
>> +#define AFE440X_ADCRSTSTCT0		0x15
>> +#define AFE440X_ADCRSTENDCT0		0x16
>> +#define AFE440X_ADCRSTSTCT1		0x17
>> +#define AFE440X_ADCRSTENDCT1		0x18
>> +#define AFE440X_ADCRSTSTCT2		0x19
>> +#define AFE440X_ADCRSTENDCT2		0x1a
>> +#define AFE440X_ADCRSTSTCT3		0x1b
>> +#define AFE440X_ADCRSTENDCT3		0x1c
>> +#define AFE440X_PRPCOUNT		0x1d
>> +#define AFE440X_CONTROL1		0x1e
>> +#define AFE440X_TIAGAIN			0x20
> Just a small point, but you have some of these redefined
> in the afe4403 drivers additional header.
> Now the contents is different but the register numbering
> matches.  I'd be tempted to make the difference more
> obvious by renaming the AFE4404 versions without the X where
> their contents is considerably different (even if they have the
> same address..
>
> I'd also push them down into the C file so only shared elements
> across the two drivers are defined here.
>
> Just makes the scope of the definitions more obvious.
>

This was my original intent, but it looks like some have
gotten away from me, I'll see what I can do to clean this
up.

Thanks,
Andrew
