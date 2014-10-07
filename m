From: Jonathan Cameron <jic23@kernel.org>
Subject: RE: [PATCH 3/8] iio: Add support for DA9150 GPADC
Date: Tue, 07 Oct 2014 20:36:36 +0100
Message-ID: <3B049606-083E-4220-ADBF-71D74C0A9D9F@kernel.org>
References: <cover.1411396718.git.Adam.Thomson.Opensource@diasemi.com> <ee4c56931f326d8ee9c1313c44456bce2dec8b8c.1411396719.git.Adam.Thomson.Opensource@diasemi.com> <5426964A.3050407@kernel.org> <2E89032DDAA8B9408CB92943514A0337AB518D23@SW-EX-MBX01.diasemi.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-pm-owner@vger.kernel.org>
In-Reply-To: <2E89032DDAA8B9408CB92943514A0337AB518D23@SW-EX-MBX01.diasemi.com>
Sender: linux-pm-owner@vger.kernel.org
To: "Opensource [Adam Thomson]" <Adam.Thomson.Opensource@diasemi.com>, Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>, "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>, Sebastian Reichel <sre@kernel.org>, Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>, David Woodhouse <dwmw2@infradead.org>, "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>, Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Grant Likely <grant.likely@linaro.org>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Joe Perches <joe@perches.com>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Support Opensource <Support.Opensource@diasemi.com>
List-Id: linux-api@vger.kernel.org



On October 7, 2014 3:55:55 PM GMT+01:00, "Opensource [Adam Thomson]" <Adam.Thomson.Opensource@diasemi.com> wrote:
>On September 27, 2014 11:50, Jonathan Cameron wrote:
>
>> On 23/09/14 11:53, Adam Thomson wrote:
>> > This patch adds support for DA9150 Charger & Fuel-Gauge IC GPADC.
>
>> > +
>> > +static inline int da9150_gpadc_gpio_6v_voltage_now(int raw_val)
>> > +{
>> > +	/* Convert to mV */
>> > +	return (6 * ((raw_val * 1000) + 500)) / 1024;
>> These could all be expressed as raw values with offsets
>> and scales (and that would be preferred).
>> E.g. This one has offset 500000 and scale 6000/1024 or even
>> better use IIO_VAL_FRACTIONAL_LOG2 for scale with val1 = 6000
>> and val2 = (log_2 1024) = 10.
>> 
>
>What you've suggested isn't correct. The problem here is that the
>offset is
>added first to the raw ADC reading, without factoring the ADC value
>accordingly
>to match the factor of the offset. If we take the original equation
>provided for
>this channel of the ADC, the offset is actually 0.5 which should be
>added to the
>raw ADC value. This doesn't fit into the implementation in the kernel
>as we
>can't use floating point. If we multiply the offset but not the raw ADC
>value,
>then add them before applying the scale factor, then the result is
>wrong at the
>end. Basically you need a scale for the raw ADC value to match the
>offset scale
>so you can achieve the correct results, which is what my calculation
>does.
>But that seems impossible with the current raw|offset|scale method.
Oops got that wrong.  The fixed point maths to fix the in kernel interface isn't exactly
 difficult but indeed it does not handle this currently.
>
>> > +	ret = iio_map_array_register(indio_dev,
>da9150_gpadc_default_maps);
>> > +	if (ret) {
>> > +		dev_err(dev, "Failed to register IIO maps: %d\n", ret);
>> > +		return ret;
>> > +	}
>> I'd suggest doing the devm_request_thread_irq before the
>iio_map_array
>> stuff.  This is purely to avoid the order during remove not being
>> obviously correct as it isn't the reverse of during probe.
>
>Ok, should still work ok that way so can update.
>
>> > +static int da9150_gpadc_remove(struct platform_device *pdev)
>> > +{
>> > +	struct iio_dev *indio_dev = platform_get_drvdata(pdev);
>> > +
>> > +	iio_map_array_unregister(indio_dev);
>> Twice in one day.  I'm definitely thinking we should add a
>> devm version of iio_map_array_register...
>
>I assume you mean here that iio_device_unregister() should come first?
>Will
>update.
Nope just that such a new function might be useful.

-- 
Sent from my Android phone with K-9 Mail. Please excuse my brevity.
