From: "Andrew F. Davis" <afd-l0cyMroinI0@public.gmane.org>
Subject: Re: [PATCH v3 5/5] iio: health: Add driver for the TI AFE4403 heart
 monitor
Date: Wed, 30 Dec 2015 11:34:30 -0600
Message-ID: <568415A6.1010501@ti.com>
References: <1450132561-5245-1-git-send-email-afd@ti.com>
 <1450132561-5245-6-git-send-email-afd@ti.com> <56798F9C.8020304@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-iio-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56798F9C.8020304-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-iio-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jonathan Cameron <jic23-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Hartmut Knaack <knaack.h-Mmb7MZpHnFY@public.gmane.org>, Lars-Peter Clausen <lars-Qo5EllUWu/uELgA04lAiVw@public.gmane.org>, Peter Meerwald <pmeerw-jW+XmwGofnusTnJN9+BGXg@public.gmane.org>
Cc: devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-iio-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 12/22/2015 11:59 AM, Jonathan Cameron wrote:
> On 14/12/15 22:36, Andrew F. Davis wrote:
>> Add driver for the TI AFE4403 heart rate monitor and pulse oximeter.
>> This device detects reflected LED light fluctuations and presents an ADC
>> value to the user space for further signal processing.
>>
>> Data sheet located here:
>> http://www.ti.com/product/AFE4403/datasheet
>>
>> Signed-off-by: Andrew F. Davis <afd-l0cyMroinI0@public.gmane.org>
> I assume the plan is to break some of this out into a common shared
> 'helper' module for the two drivers?   You will probably want
> to do that before we merge either of them.  Again, doesn't look like
> it will be a big job as you just have cut and paste functions in
> here (I think!)
>

Yeah, that's the plan.

To make review easier I was going to just get everything fixed and
upstreamed in the one, then the next patch could be a more trivial
addition adding the other part. Otherwise every problem in one
would need fixed in both.

> I also picked up on a lack of locking around read update pairs
> that I'd missed in reviewing the 4404 driver. Please fix it there
> as well.
>

Will do.

> Otherwise a few spi specific bits inline and as you expect
> the comments from one driver mostly apply to the other as well
> (in both directions!)
>> ---
>>   .../ABI/testing/sysfs-bus-iio-health-afe4403       |  52 ++
>>   drivers/iio/health/Kconfig                         |  12 +
>>   drivers/iio/health/Makefile                        |   1 +
>>   drivers/iio/health/afe4403.c                       | 696 +++++++++++++++++++++
>>   4 files changed, 761 insertions(+)
>>   create mode 100644 Documentation/ABI/testing/sysfs-bus-iio-health-afe4403
>>   create mode 100644 drivers/iio/health/afe4403.c
>>
>> diff --git a/Documentation/ABI/testing/sysfs-bus-iio-health-afe4403 b/Documentation/ABI/testing/sysfs-bus-iio-health-afe4403
>> new file mode 100644
>> index 0000000..325efcb
>> --- /dev/null
>> +++ b/Documentation/ABI/testing/sysfs-bus-iio-health-afe4403
>> @@ -0,0 +1,52 @@
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
>> +		25000, 10000, 1000000, and 0 Ohms.
>> +		Valid capacitance settings are 5, 10, 20, 25, 30, 35, 45, 50, 55,
>> +		60, 70, 75, 80, 85, 95, 100, 155, 160, 170, 175, 180, 185, 195,
>> +		200, 205, 210, 220, 225, 230, 235, 245, and 250 picoFarads.
> Given we have two devices with very similar ABI up to the values, I'd
> suggest providing *_available attributes so these can be queried from
> userspace and you can create a single ABI document covering the two drivers.

Will add.

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
>> +What:		/sys/bus/iio/devices/iio:deviceX/in_intensity_ledY-ledY_ambient_raw
>> +Date:		December 2015
>> +KernelVersion:
>> +Contact:	Andrew F. Davis <afd-l0cyMroinI0@public.gmane.org>
>> +Description:
>> +		Get differential values from the ADC for these stages. Y is the
>> +		specific LED number. The values are expressed in 24-bit twos
>> +		complement for the specified LEDs.
>> +
>> +What:		/sys/bus/iio/devices/iio:deviceX/out_current_ledY_raw
>> +Date:		December 2015
>> +KernelVersion:
>> +Contact:	Andrew F. Davis <afd-l0cyMroinI0@public.gmane.org>
>> +Description:
>> +		Get and set the LED current for the specified LED. Y is the
>> +		specific LED number.
>> +		Values range from 0 -> 255. Current is calculated by
>> +		current = (value / 256) * 50mA
> This level of detail is exposed anyway in the userspace interface, so I
> would not expect it to be explicitly mentioned here.  Without this I 'think'
> we can combine this with the docs for the afe4404.
>

Makes sense. The afe4404 will have an extra couple channels in this doc
eventually but we can deal with that when they are added.

[...]

>> +static ssize_t afe440x_store_register(struct device *dev,
>> +				      struct device_attribute *attr,
>> +				      const char *buf, size_t count)
>> +{
>> +	struct iio_dev *indio_dev = dev_to_iio_dev(dev);
>> +	struct afe440x_data *afe440x = iio_device_get_drvdata(indio_dev);
>> +	struct afe440x_attr *afe440x_attr = to_afe440x_attr(attr);
>> +	unsigned int reg_val;
>> +	int val, integer, fract, ret;
>> +
>> +	ret = iio_str_to_fixpoint(buf, 100000, &integer, &fract);
>> +	if (ret)
>> +		return ret;
>> +
> Probably want locking in here as well as again no guarantees exist
> on serializing these function calls.

ACK, not really sure why I left all the locking out.

>> +	ret = regmap_read(afe440x->regmap, afe440x_attr->reg, &reg_val);
>> +	if (ret)
>> +		return ret;
>> +
>> +	switch (afe440x_attr->type) {
>> +	case SIMPLE:
>> +		val = integer;
>> +		break;
>> +	case RESISTANCE:
>> +		for (val = 0; val < ARRAY_SIZE(afe4403_res_table); val++)
>> +			if (afe4403_res_table[val].integer == integer &&
>> +			    afe4403_res_table[val].fract == fract)
>> +				break;
>> +		if (val == ARRAY_SIZE(afe4403_res_table))
>> +			return -EINVAL;
>> +		break;
>> +	case CAPACITANCE:
>> +		for (val = 0; val < ARRAY_SIZE(afe4403_cap_table); val++)
>> +			if (afe4403_cap_table[val].integer == integer &&
>> +			    afe4403_cap_table[val].fract == fract)
>> +				break;
>> +		if (val == ARRAY_SIZE(afe4403_cap_table))
>> +			return -EINVAL;
>> +		break;
>> +	default:
>> +		return -EINVAL;
>> +	}
>> +
>> +	reg_val &= ~afe440x_attr->mask;
>> +	reg_val |= ((val << afe440x_attr->shift) & afe440x_attr->mask);
>> +
>> +	ret = regmap_write(afe440x->regmap, afe440x_attr->reg, reg_val);
>> +	if (ret)
>> +		return ret;
>> +
>> +	return count;
>> +}
>> +
>> +static AFE440X_ATTR(tia_separate_en, AFE4403_TIAGAIN, AFE440X_TIAGAIN_ENSEPGAIN, SIMPLE);
>> +
>> +static AFE440X_ATTR(tia_resistance1, AFE4403_TIAGAIN, AFE4403_TIAGAIN_RES, RESISTANCE);
>> +static AFE440X_ATTR(tia_capacitance1, AFE4403_TIAGAIN, AFE4403_TIAGAIN_CAP, CAPACITANCE);
>> +
>> +static AFE440X_ATTR(tia_resistance2, AFE4403_TIA_AMB_GAIN, AFE4403_TIAGAIN_RES, RESISTANCE);
>> +static AFE440X_ATTR(tia_capacitance2, AFE4403_TIA_AMB_GAIN, AFE4403_TIAGAIN_RES, CAPACITANCE);
>> +
>> +static struct attribute *afe440x_attributes[] = {
>> +	&afe440x_attr_tia_separate_en.dev_attr.attr,
>> +	&afe440x_attr_tia_resistance1.dev_attr.attr,
>> +	&afe440x_attr_tia_capacitance1.dev_attr.attr,
>> +	&afe440x_attr_tia_resistance2.dev_attr.attr,
>> +	&afe440x_attr_tia_capacitance2.dev_attr.attr,
>> +	NULL
>> +};
>> +
>> +static const struct attribute_group afe440x_attribute_group = {
>> +	.attrs = afe440x_attributes
>> +};
>> +
>> +static int afe440x_read_raw(struct iio_dev *indio_dev,
>> +			    struct iio_chan_spec const *chan,
>> +			    int *val, int *val2, long mask)
>> +{
>> +	struct afe440x_data *afe440x = iio_device_get_drvdata(indio_dev);
>> +	int ret;
>> +
>> +	switch (chan->type) {
>> +	case IIO_INTENSITY:
>> +		switch (mask) {
>> +		case IIO_CHAN_INFO_RAW:
>> +			ret = regmap_read(afe440x->regmap,
>> +					  reg_info[chan->address].reg, val);
>> +			if (ret)
>> +				return ret;
>> +			return IIO_VAL_INT;
>> +		case IIO_CHAN_INFO_OFFSET:
>> +			ret = regmap_read(afe440x->regmap,
>> +					  reg_info[chan->address].offreg, val);
>> +			if (ret)
>> +				return ret;
>> +			*val &= reg_info[chan->address].mask;
>> +			*val >>= reg_info[chan->address].shift;
>> +			return IIO_VAL_INT;
>> +		}
>> +		break;
>> +	case IIO_CURRENT:
>> +		switch (mask) {
>> +		case IIO_CHAN_INFO_RAW:
>> +			ret = regmap_read(afe440x->regmap,
>> +					  reg_info[chan->address].reg, val);
>> +			if (ret)
>> +				return ret;
>> +			*val &= reg_info[chan->address].mask;
>> +			*val >>= reg_info[chan->address].shift;
>> +			return IIO_VAL_INT;
>> +		case IIO_CHAN_INFO_SCALE:
>> +			*val = 0;
>> +			*val2 = 800000;
>> +			return IIO_VAL_INT_PLUS_MICRO;
>> +		}
>> +		break;
>> +	default:
>> +		break;
>> +	}
>> +
>> +	return -EINVAL;
>> +}
>> +
>> +static int afe440x_write_raw(struct iio_dev *indio_dev,
>> +			     struct iio_chan_spec const *chan,
>> +			     int val, int val2, long mask)
>> +{
>> +	struct afe440x_data *afe440x = iio_device_get_drvdata(indio_dev);
>> +	unsigned int reg_val;
>> +	int ret;
>> +
>> +	switch (chan->type) {
>> +	case IIO_INTENSITY:
>> +		switch (mask) {
>> +		case IIO_CHAN_INFO_OFFSET:
> I missed this entirely in the other driver, but you want some
> locking around the read / write pairs (a local mutex in your
> struct afe440x_data would be the conventional means of doing this).
> There is no serialization of sysfs operations so you can have
> more than one process causing these to happen at the same time.
>

ACK

>> +			ret = regmap_read(afe440x->regmap,
>> +					  reg_info[chan->address].offreg,
>> +					  &reg_val);
>> +			if (ret)
>> +				return ret;
>> +			reg_val &= ~reg_info[chan->address].mask;
>> +			reg_val |= ((val << reg_info[chan->address].shift) &
>> +					reg_info[chan->address].mask);
>> +			return regmap_write(afe440x->regmap,
>> +					    reg_info[chan->address].offreg,
>> +					    reg_val);
>> +		}
>> +		break;
>> +	case IIO_CURRENT:
>> +		switch (mask) {
>> +		case IIO_CHAN_INFO_RAW:
>> +			ret = regmap_read(afe440x->regmap,
>> +					  reg_info[chan->address].reg,
>> +					  &reg_val);
>> +			if (ret)
>> +				return ret;
>> +			reg_val &= ~reg_info[chan->address].mask;
>> +			reg_val |= ((val << reg_info[chan->address].shift) &
>> +					reg_info[chan->address].mask);
>> +			return regmap_write(afe440x->regmap,
>> +					    reg_info[chan->address].reg,
>> +					    reg_val);
>> +		}
>> +		break;
>> +	default:
>> +		break;
>> +	}
>> +
>> +	return -EINVAL;
>> +}
>> +
>> +static const struct iio_info afe440x_iio_info = {
>> +	.attrs = &afe440x_attribute_group,
>> +	.read_raw = afe440x_read_raw,
>> +	.write_raw = afe440x_write_raw,
>> +	.driver_module = THIS_MODULE,
>> +};
>> +
>> +static irqreturn_t afe440x_trigger_handler(int irq, void *private)
>> +{
>> +	struct iio_poll_func *pf = private;
>> +	struct iio_dev *indio_dev = pf->indio_dev;
>> +	struct afe440x_data *afe440x = iio_device_get_drvdata(indio_dev);
>> +	int ret, bit, i = 0;
>> +	s32 buffer[12];
>> +	u8 tx[4] = {AFE440X_CONTROL0, 0x0, 0x0, AFE440X_CONTROL0_READ};
>> +	u8 rx[3];
>> +
>> +	/* Enable reading from the device */
>> +	ret = spi_write(afe440x->spi, tx, 4);
> See rules for spi buffers. They have to be cacheline_aligned.
> I'd do the standard trick to add them to your afe440x_data
> structure and force them to start on a new cacheline.  Alternative
> is to allocate and free everytime this function is called.
>

I'll probably keep the buffer static somewhere, might make locking
a bit tricky but I'll fix all this.

> Right now you'll get corruption on some / many SPI controllers
> that are doing DMA from time to time as other data will be in
> in the same cacheline.
>> +	if (ret)
>> +		goto err;
>> +
>> +	for_each_set_bit(bit, indio_dev->active_scan_mask,
>> +			 indio_dev->masklength) {
>> +		ret = spi_write_then_read(afe440x->spi,
>> +					  &reg_info[bit].reg, 1, rx, 3);
> Interestingly write_then_read (IIRC) uses bounce buffers to avoid
> the need to ensure cacheline alignment of buffers within drivers..
>

I wonder if it would make more sense to do something like this
above, I'll look into it.

Thanks,
Andrew
