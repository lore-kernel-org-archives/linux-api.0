From: Jonathan Cameron <jic23-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/2] iio: health: Add driver for the TI AFE4404 heart
 monitor
Date: Sun, 1 Nov 2015 20:52:37 +0000
Message-ID: <56367B95.3030105@kernel.org>
References: <1446309089-21094-1-git-send-email-afd@ti.com>
 <1446309089-21094-3-git-send-email-afd@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1446309089-21094-3-git-send-email-afd-l0cyMroinI0@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Andrew F. Davis" <afd-l0cyMroinI0@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Hartmut Knaack <knaack.h-Mmb7MZpHnFY@public.gmane.org>, Lars-Peter Clausen <lars-Qo5EllUWu/uELgA04lAiVw@public.gmane.org>, Peter Meerwald <pmeerw-jW+XmwGofnusTnJN9+BGXg@public.gmane.org>
Cc: devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-iio-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 31/10/15 16:31, Andrew F. Davis wrote:
> Add driver for the TI AFE4404 heart rate monitor and pulse oximeter.
> This device detects reflected LED light fluctuations and presents an ADC
> value to the user space for further signal processing.
> 
> Data sheet located here:
> http://www.ti.com/product/AFE4404/datasheet
> 
> Signed-off-by: Andrew F. Davis <afd-l0cyMroinI0@public.gmane.org>
Hi Andrew,

Good to see this resurface.  It's a fascinating little device.

Anyhow, most of the interesting bit in here is unsuprisingly concerned
with the interface.  I know we went round a few loops of this before but
it still feels like we haven't worked out to handle it well.  I would like
as much input as we can get on this as inevitablly it will have
repercussions outside this driver.

Your approach of hammering out descriptive sysfs attributes is a good
starting point but we need to work towards a formal description that
can be generalised.  Whilst there are not many similar devices out there
to this one, I suspect there are a few and more may well show up in
future.

The escence of my rather roundabout response inline is that I'm suggesting
adding a new channel type to represent light transmission, taking the analogous
case of proximity devices in which we are looking at light reflection.
I've also taken the justification we use for illuminance vs intensity readings
for two sensor ALS sensors as a precident for having compound channels of a different
type to the 'raw' data that feeds them.  Hence I propose something along
the lines of:

in_intensityX_raw (raw channel value with the led on)
in_intensityX_ambient_raw (raw channel value with the led off)

in_intensitytransmittedX_raw the differential signal which is actually just
measuring the proportion of light that got through the finger or similar.
(other naming suggestions welcome!)

Lots more detail inline, but I wanted anyone at a quick glance to know
what we are discussing.  Perhaps my suggestion is bonkers so feel free
to pick it to shreds.

The average channels are also unusual to handle.  When would a user
want to get both the average and non average channel via the triggered
buffer?   I propose that we might handle these generically by treating
the averaging process as a filter and extending the filter interface to
describe it.

I also do feel that the modularity you have driven for to support your
other part has perhaps come at the expense of some false complexity
(I think there are easier to follow ways of keeping thing modular without
 as many duplicate copies of pointers as you pass around here).
 
Jonathan

p.s. Seemed like a good idea to look at this on a Sunday evening
to avoid some truely terrible TV...  Now for the TV I think!
> ---
>  .../ABI/testing/sysfs-bus-iio-health-afe4404       |  70 +++
>  drivers/iio/Kconfig                                |   1 +
>  drivers/iio/Makefile                               |   1 +
>  drivers/iio/health/Kconfig                         |  24 +
>  drivers/iio/health/Makefile                        |   6 +
>  drivers/iio/health/afe4404.c                       | 526 +++++++++++++++++++++
>  drivers/iio/health/afe440x.h                       | 159 +++++++
>  7 files changed, 787 insertions(+)
>  create mode 100644 Documentation/ABI/testing/sysfs-bus-iio-health-afe4404
>  create mode 100644 drivers/iio/health/Kconfig
>  create mode 100644 drivers/iio/health/Makefile
>  create mode 100644 drivers/iio/health/afe4404.c
>  create mode 100644 drivers/iio/health/afe440x.h
> 
> diff --git a/Documentation/ABI/testing/sysfs-bus-iio-health-afe4404 b/Documentation/ABI/testing/sysfs-bus-iio-health-afe4404
> new file mode 100644
> index 0000000..c67748b
> --- /dev/null
> +++ b/Documentation/ABI/testing/sysfs-bus-iio-health-afe4404
> @@ -0,0 +1,70 @@
> +What:		/sys/bus/iio/devices/iio:deviceX/out_resistanceY_tia_raw
> +		/sys/bus/iio/devices/iio:deviceX/out_capacitanceY_tia_raw
> +Date:		October 2015
> +KernelVersion:
> +Contact:	Andrew F. Davis <afd-l0cyMroinI0@public.gmane.org>
> +Description:
> +		Get and set the resistance and the capacitance settings for the
> +		Transimpedance Amplifier. Y is 1 for Rf1 and Cf1, Y is 2 for
> +		Rf2 and Cf2 values.
> +		Resistance setting is from 0 -> 7
> +		Capcitance setting is from 0 -> 15
These are defined types, so need to be in the relevant defined base units.
I know it is a pain to map real world values directly to the driver units
but if it actually makes sense to expose these to userspace they need to
defined in the same units as every other element of that type is - so
if you don't provide a scale for the 'channels' then it should be
nanofarads and ohms.

Could be handled as an output channel internaly with and extended_name -
this sort of internally handled value is exactly what
the extended_name stuff is meant to be used to identify.

These are really controlling a front end analog filter, so another option would
be to use the filter description attributes to handle this.  They are however
somewhat 'minimalist' for this case so would need extending. (this will also
get complex if we start describing the average channel as a filtered channel
as well).
> +
> +What:		/sys/bus/iio/devices/iio:deviceX/tia_separate_enable
> +Date:		October 2015
> +KernelVersion:
> +Contact:	Andrew F. Davis <afd-l0cyMroinI0@public.gmane.org>
> +Description:
> +		Enable or disable separate settings for the TransImpedance
> +		Amplifier above, when disabled both values are set by the
> +		first channel.
This is an 'interesting' one.  Might be cleaner to just have both values exposed
and switch this on and off depending on whether they are equal?  That way we
don't need the custom interface.
Perhaps we need a brief description of why one might not want separate control?
(i.e. if we have separate control and set them to the same value, what do we lose?)

> +
> +What:		/sys/bus/iio/devices/iio:deviceX/out_current_ledY_raw
> +Date:		October 2015
> +KernelVersion:
> +Contact:	Andrew F. Davis <afd-l0cyMroinI0@public.gmane.org>
> +Description:
> +		Get and set the LED current for the specified LED.
> +		Y is the specific LED number.
> +		Values range from 0 -> 63.  Current is calculated by
> +		current = value * 0.8mA

Existence of this attribute is fine, but you need to do the relevant
handling to allow it to be a standard current channel. You can't have the
mysterious * 0.8mA.  Also it should be called out_currentX_led_raw
(so led is an extended name)  IIRC we do this for some proximity sensors.

> +
> +What:		/sys/bus/iio/devices/iio:deviceX/in_intensity_ledY_raw
> +		/sys/bus/iio/devices/iio:deviceX/in_intensity_ledY_ambient_raw
> +Date:		October 2015
> +KernelVersion:
> +Contact:	Andrew F. Davis <afd-l0cyMroinI0@public.gmane.org>
> +Description:
> +		Get measured values from the ADC for these stages. Y is the
> +		specific LED number. The values are expressed in 24-bit twos
> +		complement for the specified LEDs.
These are getting a little bit 'clunky' in naming.  Could map them back to
the simpler

in_intensityX_raw and in_intensityX_ambient_raw and rely on the channel index
to associate them with an LED.

The led version of ambient strikes me as odd to start with given I think the LED
is turned off during that measurement?  This is merely to do with when they
occur in the sequence?

What we are really dealing with here is a single photodiode and an led sequencer.
Perhaps we need a modifier that simply means the source is an led driven at the same instance?
(this is the same as for proximity sensors, but there the signal is explicitly proximity).

Maybe, we should be treating these as a different type entirely?  They are measuring light
levels, but in common with proximity sensors the 'interesting' bit is what is effecting
those levels.  Perhaps a new type would make sense.
How about:

in_intensitytransmittedX_raw
in_intensityX_raw

This makes a mess of the differential channels however, as suddenly they are taking the
difference of two signals of different types.  Ah well there goes a good plan.  I'd neglected
that the transmitted version is the combination of the ambient and the transmitted.

This is irritatingly hard to map onto anything generic.

Perhaps the next thing is to think of these a bit like the ALS sensors that use
two sensors to work out what the illuminance is and do it similar to that (somewhat
hiding the relationship).  In that case we'd have

in_intensityX_ambient_raw
in_intensityX_raw (transmitted and ambient - maybe some modifier to indicate this
- like we do for the hideous 'both' modifier for the visible + infrared sensitive
element is some ALSs? - note both seemed sensible at the time, now the name seems
bonkers - oops.)

and the differential would become
in_intensitytransmittedX_raw

In the ALS analogy the transform is often horribly non linear so could
never be represented as a differential channel (unlike here). Maybe
from a userspace interface point of view the best bet here is to not represent
it as a differential channel... Are all such light sensors even linear - here the
assumption is the connected diode is. Perhaps that won't always hold true in future.

(this is my favourite option at the moment)

> +
> +What:		/sys/bus/iio/devices/iio:deviceX/in_intensity_led1-led1_ambient_raw
> +		/sys/bus/iio/devices/iio:deviceX/in_intensity_led2-led2_ambient_raw
> +Date:		October 2015
> +KernelVersion:
> +Contact:	Andrew F. Davis <afd-l0cyMroinI0@public.gmane.org>
> +Description:
> +		Get differential values from the ADC for these stages.  The
> +		values are expressed in 24-bit twos complement for the
> +		specified LEDs.
> +
> +What:		/sys/bus/iio/devices/iio:deviceX/in_intensity_led1-led1_ambient_mean_raw
> +		/sys/bus/iio/devices/iio:deviceX/in_intensity_led2-led2_ambient_mean_raw
> +Date:		October 2015
> +KernelVersion:
> +Contact:	Andrew F. Davis <afd-l0cyMroinI0@public.gmane.org>
> +Description:
> +		Get average values from the ADC for these stages.  The
> +		values are expressed in 24-bit twos complement for the
> +		specified LEDs.

Oh goody another weird one ;)  I note in the current proposal, it's not obvious
that the mean acutally applies to the differential.  Another element in favour
of the new channel type option.

We do have a chan info element for average raw that would do the job for the sysfs
attribute.   However, as you are pushing this into the buffer, it doesn't work for
us here.

This is basically a low pass filtered version of the signal, so one option would
be a duplicate channel that has the addition of filter attributes to describe that
the filter applied (similar to the existing low pass filter controls).

The challenge would be making it clear that the channel is infact the same as the
led2 channel but with the filter.

Actually, odd question, but why would someone want both the unfiltered and filtered
versions via the buffered interface?

> +
> +What:		/sys/bus/iio/devices/iio:deviceX/out_current_offdac_ledY_raw
> +		/sys/bus/iio/devices/iio:deviceX/out_current_offdac_ledY_ambient_raw
> +Date:		October 2015
> +KernelVersion:
> +Contact:	Andrew F. Davis <afd-l0cyMroinI0@public.gmane.org>
> +Description:
> +		Get and set the offset cancellation DAC setting for these
> +		stages.
> +		Values range from 0 -> 15
Are these in mA?

Not sure I like the naming here.  You could either treat them as explicit output
channels, or (and I'd be tempted to favour this) as calibration offsets for the
in_intensitytransmitted_ channel described above (or maybe the straight intensity
channels - I'm now confused on what is what here!).



> diff --git a/drivers/iio/Kconfig b/drivers/iio/Kconfig
> index 4011eff..53e1892 100644
> --- a/drivers/iio/Kconfig
> +++ b/drivers/iio/Kconfig
> @@ -65,6 +65,7 @@ source "drivers/iio/common/Kconfig"
>  source "drivers/iio/dac/Kconfig"
>  source "drivers/iio/frequency/Kconfig"
>  source "drivers/iio/gyro/Kconfig"
> +source "drivers/iio/health/Kconfig"
>  source "drivers/iio/humidity/Kconfig"
>  source "drivers/iio/imu/Kconfig"
>  source "drivers/iio/light/Kconfig"
> diff --git a/drivers/iio/Makefile b/drivers/iio/Makefile
> index 698afc2..d350cb3 100644
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
> index 0000000..f5e5d82
> --- /dev/null
> +++ b/drivers/iio/health/Kconfig
> @@ -0,0 +1,24 @@
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
> index 0000000..af65f30
> --- /dev/null
> +++ b/drivers/iio/health/afe4404.c
> @@ -0,0 +1,526 @@
> +/*
> + * AFE4404 Heart Rate Monitors and Low-Cost Pulse Oximeters
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

Maybe say 'AFE4404 specific registers' to make it clear
there are others in the header.

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
Is it worth considering the regmap field stuff?  That
way all this could go into the field defintions, and
perhaps then give a cleaner driver?
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
> +/* AFE4404 CONTROL3 register fields */
> +#define AFE440X_CONTROL3_OSC_ENABLE	BIT(9)
> +
> +/* AFE4404 OFFDAC register current fields */
> +#define AFE4404_OFFDAC_CURR_LED1_MASK	GENMASK(8, 5)
> +#define AFE4404_OFFDAC_CURR_LED1_SHIFT	5
> +#define AFE4404_OFFDAC_CURR_LED2_MASK	GENMASK(18, 15)
> +#define AFE4404_OFFDAC_CURR_LED2_SHIFT	15
> +#define AFE4404_OFFDAC_CURR_LED3_MASK	GENMASK(3, 0)
> +#define AFE4404_OFFDAC_CURR_LED3_SHIFT	0
> +#define AFE4404_OFFDAC_CURR_AMB1_MASK	GENMASK(13, 10)
> +#define AFE4404_OFFDAC_CURR_AMB1_SHIFT	10
> +#define AFE4404_OFFDAC_CURR_AMB2_MASK	GENMASK(3, 0)
> +#define AFE4404_OFFDAC_CURR_AMB2_SHIFT	0
> +
> +/* AFE4404 OFFDAC register polarity fields */
> +#define AFE4404_OFFDAC_POL_LED1_MASK	BIT(9)
> +#define AFE4404_OFFDAC_POL_LED1_SHIFT	9
> +#define AFE4404_OFFDAC_POL_LED2_MASK	BIT(19)
> +#define AFE4404_OFFDAC_POL_LED2_SHIFT	19
> +#define AFE4404_OFFDAC_POL_LED3_MASK	BIT(4)
> +#define AFE4404_OFFDAC_POL_LED3_SHIFT	4
> +#define AFE4404_OFFDAC_POL_AMB1_MASK	BIT(14)
> +#define AFE4404_OFFDAC_POL_AMB1_SHIFT	14
> +#define AFE4404_OFFDAC_POL_AMB2_MASK	BIT(4)
> +#define AFE4404_OFFDAC_POL_AMB2_SHIFT	4
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
I'd be tempted to represent this as a lookup table instead
of this set of defines.  This is particular true
in light of the fact the sysfs attribute needs to map them
to standard units. Given that will need to be in nano farads
and these are pico you only need the 'val2 part' and use the
int_plus_micro form.  The search will be rather more iritating
as these are in a non obvious order, but such is life.

Hence (I'd use the C99 asignments stuff to make it obvious
that the index is important!)

static const int afe4404_tia_gain_caps_femto_farads[] = {
      [0] = 5000,
      [1] = 2500,
      [2] = 10000,
      [3] = 7500,
      [4] = 20000,
      [5] = 17500,
      [6] = 25000,
      [7] = 22500 };
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

Same as for the capacitances.

> +
> +enum afe4404_chan_id {
> +	LED1VAL,
> +	ALED1VAL,
> +	LED2VAL,
> +	ALED2VAL,
> +	LED3VAL,
> +	LED1_ALED1VAL,
> +	LED2_ALED2VAL,
> +	AVG_LED1_ALED1VAL,
> +	AVG_LED2_ALED2VAL,
> +};
> +
> +static const struct iio_chan_spec afe4404_channels[] = {
> +	/* ADC values from the IC */
> +	AFE440X_READ_CHAN(LED1VAL, "led1", AFE440X_LED1VAL),
> +	AFE440X_READ_CHAN(ALED1VAL, "led1_ambient", AFE440X_ALED1VAL),
> +	AFE440X_READ_CHAN(LED2VAL, "led2", AFE440X_LED2VAL),
> +	AFE440X_READ_CHAN(ALED2VAL, "led2_ambient", AFE440X_ALED2VAL),
> +	AFE440X_READ_CHAN(LED3VAL, "led3", AFE440X_ALED2VAL),
> +	AFE440X_READ_CHAN(LED1_ALED1VAL, "led1-led1_ambient", AFE440X_LED1_ALED1VAL),
> +	AFE440X_READ_CHAN(LED2_ALED2VAL, "led2-led2_ambient", AFE440X_LED2_ALED2VAL),
> +	AFE440X_READ_CHAN(AVG_LED1_ALED1VAL, "led1-led1_ambient_mean", AFE4404_AVG_LED1_ALED1VAL),
> +	AFE440X_READ_CHAN(AVG_LED2_ALED2VAL, "led2-led2_ambient_mean", AFE4404_AVG_LED2_ALED2VAL),
> +};
> +
> +static ssize_t afe440x_show_register(struct device *dev,
> +			      struct device_attribute *attr,
> +			      char *buf)
> +{
> +	struct iio_dev *indio_dev = dev_to_iio_dev(dev);
> +	struct afe440x_data *afe440x = iio_device_get_drvdata(indio_dev);
> +	struct afe440x_reg *afe440x_reg = to_afe440x_reg(attr);
> +	int reg_val;
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
> +			       struct device_attribute *attr,
> +			       const char *buf, size_t count)
> +{
> +	struct iio_dev *indio_dev = dev_to_iio_dev(dev);
> +	struct afe440x_data *afe440x = iio_device_get_drvdata(indio_dev);
> +	struct afe440x_reg *afe440x_reg = to_afe440x_reg(attr);
> +	unsigned val;
> +	int reg_val;
> +	int ret;
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
> +AFE440X_ATTR(tia_separate_enable, AFE4404_TIA_GAIN_SEP, AFE440X_TIAGAIN_ENSEPGAIN);
> +
> +AFE440X_ATTR(out_resistance1_tia_raw, AFE4404_TIA_GAIN, AFE4404_TIA_GAIN_RES);
> +AFE440X_ATTR(out_capacitance1_tia_raw, AFE4404_TIA_GAIN, AFE4404_TIA_GAIN_CAP);
> +
> +AFE440X_ATTR(out_resistance2_tia_raw, AFE4404_TIA_GAIN_SEP, AFE4404_TIA_GAIN_RES);
> +AFE440X_ATTR(out_capacitance2_tia_raw, AFE4404_TIA_GAIN_SEP, AFE4404_TIA_GAIN_CAP);
I talk about these above.  They look to me like they should either be treated as output
channels or possibly as controls on a filter (which is what they really are)
> +
> +AFE440X_ATTR(out_current_offdac_led1_raw, AFE4404_OFFDAC, AFE4404_OFFDAC_CURR_LED1);
> +AFE440X_ATTR(out_current_offdac_led2_raw, AFE4404_OFFDAC, AFE4404_OFFDAC_CURR_LED2);
> +AFE440X_ATTR(out_current_offdac_led3_raw, AFE4404_OFFDAC, AFE4404_OFFDAC_CURR_LED3);
Again, talked about earlier.  These could be treated as calibration offsets (similar to
the ones applied to trim gyros in high end IMUs for example).

This stuff makes me wonder whether we are anywhere near descriptive enough of the analog
front ends to devices we support.  Probably not I guess!
> +
> +AFE440X_ATTR(out_current_offdac_led1_ambient_raw, AFE4404_OFFDAC, AFE4404_OFFDAC_CURR_AMB1);
> +AFE440X_ATTR(out_current_offdac_led2_ambient_raw, AFE4404_OFFDAC, AFE4404_OFFDAC_CURR_AMB2);
> +
> +AFE440X_ATTR(out_current_led1_raw, AFE440X_LEDCNTRL, AFE4404_LEDCNTRL_ILED1);
> +AFE440X_ATTR(out_current_led2_raw, AFE440X_LEDCNTRL, AFE4404_LEDCNTRL_ILED2);
> +AFE440X_ATTR(out_current_led3_raw, AFE440X_LEDCNTRL, AFE4404_LEDCNTRL_ILED3);
We already do this for some proximity sensors - just might be better to represent them
as straight forward output channels.  I suppose if we really get into it they
are output intensity channels, but perhaps best to ignore that.
> +
> +static struct attribute *afe4404_attributes[] = {
> +	&afe440x_reg_tia_separate_enable.dev_attr.attr,
> +	&afe440x_reg_out_resistance1_tia_raw.dev_attr.attr,
> +	&afe440x_reg_out_capacitance1_tia_raw.dev_attr.attr,
> +	&afe440x_reg_out_resistance2_tia_raw.dev_attr.attr,
> +	&afe440x_reg_out_capacitance2_tia_raw.dev_attr.attr,
> +	&afe440x_reg_out_current_offdac_led1_raw.dev_attr.attr,
> +	&afe440x_reg_out_current_offdac_led2_raw.dev_attr.attr,
> +	&afe440x_reg_out_current_offdac_led3_raw.dev_attr.attr,
> +	&afe440x_reg_out_current_offdac_led1_ambient_raw.dev_attr.attr,
> +	&afe440x_reg_out_current_offdac_led2_ambient_raw.dev_attr.attr,
> +	&afe440x_reg_out_current_led1_raw.dev_attr.attr,
> +	&afe440x_reg_out_current_led2_raw.dev_attr.attr,
> +	&afe440x_reg_out_current_led3_raw.dev_attr.attr,
> +	NULL
> +};
> +
> +static const struct attribute_group afe4404_attribute_group = {
> +	.attrs = afe4404_attributes
> +};
> +
> +static int afe440x_read_raw(struct iio_dev *indio_dev,
> +		     struct iio_chan_spec const *chan,
> +		     int *val, int *val2, long mask)
> +{
> +	struct afe440x_data *afe440x = iio_device_get_drvdata(indio_dev);
> +	int ret;
> +
> +	ret = regmap_read(afe440x->regmap, chan->address, val);
> +	if (ret)
> +		return ret;
> +
> +	*val2 = 0;
There should be no need to set *val2 as it's never read if the return
is IIO_VAL_INT.  Nothing wrong with paranoia however ;)
> +
> +	return IIO_VAL_INT;
> +}
> +
> +static const struct iio_info afe4404_iio_info = {
> +	.attrs	= &afe4404_attribute_group,
> +	.read_raw = afe440x_read_raw,
> +	.driver_module = THIS_MODULE,
> +};
> +
> +static irqreturn_t afe440x_trigger_handler(int irq, void *private)
> +{
> +	struct iio_poll_func *pf = (struct iio_poll_func *)private;
Shouldn't be any need to explicitly cast when coming from a void *

> +	struct iio_dev *indio_dev = pf->indio_dev;
> +	struct afe440x_data *afe440x = iio_device_get_drvdata(indio_dev);
> +	int ret, bit, reg, i = 0;
> +	s32 buffer[10];
So there are 9 channels?  Then you need space for the timestamp that needs
to be 8 byte aligned. Hence this needs to be s32 buffer[12].
(iio_push_to_buffers_with_timestamp is rather odd  - see the documentation)
> +
> +	for_each_set_bit(bit, indio_dev->active_scan_mask,
> +			 indio_dev->masklength) {
> +		reg = afe440x->channels[bit].address;

Why using the version in afe440x (which arguably shouldn't be there)
rather than the one in indio_dev->channels[bit].address?

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
> +		dev_err(dev, "Failed to enable regulator\n");
> +		return ret;
> +	}
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
> +	if (indio_dev == NULL) {
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
> +		afe440x->trig = devm_iio_trigger_alloc(afe440x->dev, "%s-dev%d",
> +						       indio_dev->name,
> +						       indio_dev->id);
> +		if (afe440x->trig == NULL) {
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
> +						"afe4404", afe440x->trig);
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
> +static int afe4404_probe(struct i2c_client *client,
> +			const struct i2c_device_id *id)
> +{
> +	struct afe440x_data *afe440x;
> +	int ret;
> +
> +	afe440x = devm_kzalloc(&client->dev, sizeof(*afe440x), GFP_KERNEL);
> +	if (!afe440x)
> +		return -ENOMEM;
Hmm. I guess this more of the stuff from this being a highly modular driver.
Right now that is really hurting the organisation of the code.

You'd be better off just using the devm_iio_device_alloc call to allocate
both your private data and the iio device data.  You could then pass the
iio_dev to your iio_setup function if you really want to.
Not bouncing through having copies of everything in your afe440x structure
would also make it a lot cleaner without hurting your modularity substantially.

I can see that you were aiming to completely separate the iio side
from the more generic driver parts, but that division is all a bit blured and
leads to more complex code.

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
> +	afe440x->regulator = devm_regulator_get(afe440x->dev, "led");
> +	if (IS_ERR(afe440x->regulator)) {
> +		dev_err(afe440x->dev, "Unable to get regulator\n");
> +		return PTR_ERR(afe440x->regulator);
> +	}
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
Cool. Never knew that one existed before...
> +	if (ret) {
> +		dev_err(afe440x->dev, "Unable to set register defaults\n");
> +		return ret;
> +	}
> +
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
> index 0000000..2d98a20
> --- /dev/null
> +++ b/drivers/iio/health/afe440x.h
> @@ -0,0 +1,159 @@
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
> +#define AFE440X_READ_CHAN(_index, _name, _address)		\
> +	{							\
> +		.type = IIO_INTENSITY,				\
> +		.channel = _index,				\
> +		.address = _address,				\
> +		.scan_index = _index,				\
> +		.scan_type = {					\
> +				.sign = 's',			\
> +				.realbits = 24,			\
> +				.storagebits = 32,		\
> +				.endianness = IIO_CPU,		\
> +		},						\
> +		.extend_name = _name,				\
> +		.info_mask_separate = BIT(IIO_CHAN_INFO_RAW),	\
> +	}
> +
> +struct afe440x_reg {
> +	struct device_attribute dev_attr;
> +	u8 reg;
> +	unsigned long shift;
> +	unsigned long mask;
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
> +
> +/**
> + * struct afe440x_data
> + * @dev - Device structure
> + * @name - Device name
> + * @spi - SPI device pointer the driver is attached to
> + * @iolock - Read/Write mutex
> + * @regmap - Register map of the device
> + * @regulator - Pointer to the regulator for the IC
> + * @channels - IIO channels
> + * @num_channels - Number of IIO channels
> + * @info - IIO info for device
> + * @trig - IIO trigger for this device
> + * @irq - ADC_RDY line interrupt number
> +**/
> +struct afe440x_data {
> +	struct device *dev;
This is used in remarkably few places and those are all effectively
in the device probe.  Perhaps just passing it directly would make sense.

> +	const char *name;
Why have another instance of name given it's held in the iio_dev anyway?

> +	struct spi_device *spi;
Not used anywhere that I can find. 

> +	struct mutex iolock;
Another one not used anywhere (left-overs from pre regmap?)

> +	struct regmap *regmap;
> +	struct regulator *regulator;
> +	struct iio_chan_spec const *channels;
> +	int num_channels;
Having the above in here as well makes limited sense given the versions
in iio_dev are identical.

I'm guessing some of this was due to how the modular stuff you refer
to in the cover letter was done.  However, I'm suspecting that was
done less than cleanly to end up with this mixture of constant and non
constant elements in here.  There should have been a chip_info structure
consisting of entirely constant elements (such as channels etc) rather than
this combined structure.

> +	const struct iio_info *info;
Again, can't see any reason to ever have this directly in here.

> +	struct iio_trigger *trig;
> +	int irq;
> +};
> +
> +#endif /* _AFE440X_H */
> 

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
