From: Jonathan Cameron <jic23@kernel.org>
Subject: Re: [PATCH 2/2] iio: health: Add driver for the TI AFE4404 heart
 monitor
Date: Wed, 4 Nov 2015 19:40:14 +0000
Message-ID: <563A5F1E.70904@kernel.org>
References: <1446309089-21094-1-git-send-email-afd@ti.com>
 <1446309089-21094-3-git-send-email-afd@ti.com> <56367B95.3030105@kernel.org>
 <5637C96C.5010602@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5637C96C.5010602@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Andrew F. Davis" <afd@ti.com>, Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Hartmut Knaack <knaack.h@gmx.de>, Lars-Peter Clausen <lars@metafoo.de>, Peter Meerwald <pmeerw@pmeerw.net>
Cc: devicetree@vger.kernel.org, linux-iio@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 02/11/15 20:37, Andrew F. Davis wrote:
> On 11/01/2015 02:52 PM, Jonathan Cameron wrote:
>> On 31/10/15 16:31, Andrew F. Davis wrote:
>>> Add driver for the TI AFE4404 heart rate monitor and pulse oximeter.
>>> This device detects reflected LED light fluctuations and presents an ADC
>>> value to the user space for further signal processing.
>>>
>>> Data sheet located here:
>>> http://www.ti.com/product/AFE4404/datasheet
>>>
>>> Signed-off-by: Andrew F. Davis <afd@ti.com>
>> Hi Andrew,
>>
>> Good to see this resurface.  It's a fascinating little device.
>>
>> Anyhow, most of the interesting bit in here is unsuprisingly concerned
>> with the interface.  I know we went round a few loops of this before but
>> it still feels like we haven't worked out to handle it well.  I would like
>> as much input as we can get on this as inevitablly it will have
>> repercussions outside this driver.
>>
>> Your approach of hammering out descriptive sysfs attributes is a good
>> starting point but we need to work towards a formal description that
>> can be generalised.  Whilst there are not many similar devices out there
>> to this one, I suspect there are a few and more may well show up in
>> future.
>>
> 
> Yeah, I'm working on brining up drivers for them now :)
cool
> 
>> The escence of my rather roundabout response inline is that I'm suggesting
>> adding a new channel type to represent light transmission, taking the analogous
>> case of proximity devices in which we are looking at light reflection.
>> I've also taken the justification we use for illuminance vs intensity readings
>> for two sensor ALS sensors as a precident for having compound channels of a different
>> type to the 'raw' data that feeds them.  Hence I propose something along
>> the lines of:
>>
>> in_intensityX_raw (raw channel value with the led on)
>> in_intensityX_ambient_raw (raw channel value with the led off)
>>
> 
> I'm not sure, I know it may be too late for a lot of drivers but putting the 'X'
> against the 'intensity' works for devices like ADCs/DACs with a simple list
> of numeric channels, but for any other device with named channels this will
> become very inconsistent, especially when adding modified channels and
> differential channels.
Sadly its ABI now so we can't realistically change it.  We can extend, we can't
replace (we we can over the course of a lot of years but that's a nightmare).

> 
> For example:
> 
> in_intensity5_name_ambient-2_mean_raw
The oddity here is that in your case the device in interacting with a stimulus
output.  Normally the index reflects an actual sensor.  We are kind of bludgeoning
it in. The only equivalently nasty case I know of is touch screens where different
resistances are being connected - from a generic point of view those are a nightmare
as well (as every implementation does it differently).
> 
> This is the differential of name and an unnamed channel '2', also something
> is an average, is it channel '2', is it the whole differential channel? Is
> 5 this channels id or part of the first differential channel name? Who knows!
> 
> The way I would do it is with this more universal format:
> 
> [direction]_[type]_[name|number]_[info]
Hind sight is a great thing in that the extra _ would have made parsing marginally
easier.
> 
> 
> And then we just drop trying to deal with modifiers and differential stuff
> internally, just let the driver give the channel a name with those. We then
> wouldn't need to deal with channels numbers ether, just names.
See my reply to the cover letter thread.  You can't pass a name in an event
to userspace and we'd end up string matching all over the place or you end
up not encoding the information currently in the modifier at all.  

Perhaps you are right in that it would still have been neater but such is hind sight!

The one I wonder about occasionally is similar to what you suggest, but don't
ever having anything other than number (and I'd keep the differential channels.
Then have an extra sysfs attribute that provides the modifier string.

Then I'm not sure it gains us much.
Also note that in the classic ADC case (and there are a whole load more
of those than weird light sensors ;) there are only indexes and differential channels
so it all becomes rather cleaner.

in_voltage0-1_raw 

It's also worth noting that whilst we do allow freeform extend_name elements
they are very rarely accepted in drivers as the moment you do that you have
something that standard userspace code won't know what to do with.
> 
> struct iio_chan_spec {
>     enum iio_chan_type    type;
>>>>     const char        *name;
>     unsigned long        address;
>     int            scan_index;
>     struct {
>         char    sign;
>         u8    realbits;
>         u8    storagebits;
>         u8    shift;
>         u8    repeat;
>         enum iio_endian endianness;
>     } scan_type;
>     const struct iio_event_spec *event_spec;
>     unsigned int        num_event_specs;
>     const struct iio_chan_spec_ext_info *ext_info;
>     const char        *datasheet_name;
>     unsigned        output:1;
> };
> 
> ADCs with lists of numeric channels would then not need to assign to channel
> and set indexed, just set name = "3".
And we'd immediately have to string match to do events.
> 
> in_voltage_0_raw
> in_voltage_1_raw
> in_voltage_2_raw
> etc..
> 
> Differential would become:
> 
> in_voltage_0-1_raw
> in_voltage_2-6_raw
> etc..
> 
> Again this might be too late to change for some existing drivers, but for
> new ones nothing is really stoping this.
There is - abi compliance.  We are simply not going to have two different ABIs.
Your use case may involve only drivers that are used with custom userspace code
(afterall this one isn't much use without a load of processing) but the 
vast majority of drivers are generic and talk to the same userspace.

So whilst this is an interesting discussion, it's effectively an academic
exercise.  We have an ABI. What's there is effectively set in stone.  New
drivers that do the same thing as existing drivers MUST use the existing
ABI..

Where we have flexibility is to extend the ABI for devices that haven't
been supported before.

> 
>> in_intensitytransmittedX_raw the differential signal which is actually just
>> measuring the proportion of light that got through the finger or similar.
>> (other naming suggestions welcome!)
>>
> 
> As above, why keep patching the framework, let the drivers set the names,
> I would have:
> 
> name = "led1-led1_ambient";
> 
> so:
>
> in_intensity_led1-led1_ambient_raw
> 
> which would match the data sheet and match the names of the channels
> that these are differencing on ("led1" and "led1_ambient").
> 
>> Lots more detail inline, but I wanted anyone at a quick glance to know
>> what we are discussing.  Perhaps my suggestion is bonkers so feel free
>> to pick it to shreds.
>>
>> The average channels are also unusual to handle.  When would a user
>> want to get both the average and non average channel via the triggered
>> buffer?   I propose that we might handle these generically by treating
>> the averaging process as a filter and extending the filter interface to
>> describe it.
>>
> 
> Maybe they want one for display and let the hardware do the filtering on
> the other? IDK
> 
> The end user my not need them both at the same time, but I see no reason
> to limit them from using them if the want and keeping them as channels
> like in the data sheet to avoid confusion.
Sure.   Was just curious ;)
> 
>> I also do feel that the modularity you have driven for to support your
>> other part has perhaps come at the expense of some false complexity
>> (I think there are easier to follow ways of keeping thing modular without
>>   as many duplicate copies of pointers as you pass around here).
>>
>> Jonathan
>>
>> p.s. Seemed like a good idea to look at this on a Sunday evening
>> to avoid some truely terrible TV...  Now for the TV I think!
> 
> Hope this was more interesting that Sunday evening TV :)
It involved dancing chipmunks.  This didn't have to be that interesting ;)
> 
>>> ---
>>>   .../ABI/testing/sysfs-bus-iio-health-afe4404       |  70 +++
>>>   drivers/iio/Kconfig                                |   1 +
>>>   drivers/iio/Makefile                               |   1 +
>>>   drivers/iio/health/Kconfig                         |  24 +
>>>   drivers/iio/health/Makefile                        |   6 +
>>>   drivers/iio/health/afe4404.c                       | 526 +++++++++++++++++++++
>>>   drivers/iio/health/afe440x.h                       | 159 +++++++
>>>   7 files changed, 787 insertions(+)
>>>   create mode 100644 Documentation/ABI/testing/sysfs-bus-iio-health-afe4404
>>>   create mode 100644 drivers/iio/health/Kconfig
>>>   create mode 100644 drivers/iio/health/Makefile
>>>   create mode 100644 drivers/iio/health/afe4404.c
>>>   create mode 100644 drivers/iio/health/afe440x.h
>>>
>>> diff --git a/Documentation/ABI/testing/sysfs-bus-iio-health-afe4404 b/Documentation/ABI/testing/sysfs-bus-iio-health-afe4404
>>> new file mode 100644
>>> index 0000000..c67748b
>>> --- /dev/null
>>> +++ b/Documentation/ABI/testing/sysfs-bus-iio-health-afe4404
>>> @@ -0,0 +1,70 @@
>>> +What:        /sys/bus/iio/devices/iio:deviceX/out_resistanceY_tia_raw
>>> +        /sys/bus/iio/devices/iio:deviceX/out_capacitanceY_tia_raw
>>> +Date:        October 2015
>>> +KernelVersion:
>>> +Contact:    Andrew F. Davis <afd@ti.com>
>>> +Description:
>>> +        Get and set the resistance and the capacitance settings for the
>>> +        Transimpedance Amplifier. Y is 1 for Rf1 and Cf1, Y is 2 for
>>> +        Rf2 and Cf2 values.
>>> +        Resistance setting is from 0 -> 7
>>> +        Capcitance setting is from 0 -> 15
>> These are defined types, so need to be in the relevant defined base units.
>> I know it is a pain to map real world values directly to the driver units
>> but if it actually makes sense to expose these to userspace they need to
>> defined in the same units as every other element of that type is - so
>> if you don't provide a scale for the 'channels' then it should be
>> nanofarads and ohms.
>>
> 
> I'll see what I can do.
> 
>> Could be handled as an output channel internaly with and extended_name -
>> this sort of internally handled value is exactly what
>> the extended_name stuff is meant to be used to identify.
>>
> 
> Not sure if we would gain anything from handling them as actual channels.
Does seem unlikely any code not directly tied to this driver will ever know
what to do with them enough for it to make sense.
> 
>> These are really controlling a front end analog filter, so another option would
>> be to use the filter description attributes to handle this.  They are however
>> somewhat 'minimalist' for this case so would need extending. (this will also
>> get complex if we start describing the average channel as a filtered channel
>> as well).
> 
> Same as above, it probably makes more sense to keep these simple and close
> to the data sheet to avoid user having to learn about all this internal
> wiring stuff.
Just a small point, but if the exposed interface of a driver to userspace
requires reading the datasheet to understand it, it's not a great starting point.
These are kind of 'magic calibration parameters' so I'm not that bothered.
> 
>>> +
>>> +What:        /sys/bus/iio/devices/iio:deviceX/tia_separate_enable
>>> +Date:        October 2015
>>> +KernelVersion:
>>> +Contact:    Andrew F. Davis <afd@ti.com>
>>> +Description:
>>> +        Enable or disable separate settings for the TransImpedance
>>> +        Amplifier above, when disabled both values are set by the
>>> +        first channel.
>> This is an 'interesting' one.  Might be cleaner to just have both values exposed
>> and switch this on and off depending on whether they are equal?  That way we
>> don't need the custom interface.
>> Perhaps we need a brief description of why one might not want separate control?
>> (i.e. if we have separate control and set them to the same value, what do we lose?)
>>
> 
> If we set them separate by default then users who are following the data sheet
> and only writing to the first channel will only be setting the gain of one, and
> not both, which is probably what most want.
> 
> Also if you want them to be the same and change one first it will cause them to
> be out of step until the other is set, might cause problems when setting them
> while streaming in data.
Would it ever make sense to set them like whilst streaming?  I've no idea!
I'm just keen to keep custom ABI to a minimum.  
> 
>>> +
>>> +What:        /sys/bus/iio/devices/iio:deviceX/out_current_ledY_raw
>>> +Date:        October 2015
>>> +KernelVersion:
>>> +Contact:    Andrew F. Davis <afd@ti.com>
>>> +Description:
>>> +        Get and set the LED current for the specified LED.
>>> +        Y is the specific LED number.
>>> +        Values range from 0 -> 63.  Current is calculated by
>>> +        current = value * 0.8mA
>>
>> Existence of this attribute is fine, but you need to do the relevant
>> handling to allow it to be a standard current channel. You can't have the
>> mysterious * 0.8mA.  Also it should be called out_currentX_led_raw
>> (so led is an extended name)  IIRC we do this for some proximity sensors.
>>
> 
> Isn't this the case for raw? I figured scaled was for when we want the driver
> to do the unit conversions for us?
You can do that, but then you need to provide 
out_current_ledY_scale to specify what the scale is.  If you do, then oops
I missed it.
> 
> As for naming same as above.
> 
>>> +
>>> +What:        /sys/bus/iio/devices/iio:deviceX/in_intensity_ledY_raw
>>> +        /sys/bus/iio/devices/iio:deviceX/in_intensity_ledY_ambient_raw
>>> +Date:        October 2015
>>> +KernelVersion:
>>> +Contact:    Andrew F. Davis <afd@ti.com>
>>> +Description:
>>> +        Get measured values from the ADC for these stages. Y is the
>>> +        specific LED number. The values are expressed in 24-bit twos
>>> +        complement for the specified LEDs.
>> These are getting a little bit 'clunky' in naming.  Could map them back to
>> the simpler
>>
>> in_intensityX_raw and in_intensityX_ambient_raw and rely on the channel index
>> to associate them with an LED.
>>
> 
> As above, I think that would add unnecessary confusion in mapping numbers to names.
> The output channel is for 'led1' the input should be for 'led1' not '1_raw' or
> such.
This is still nasty as it's not really it's a channel reading an arbitrary combination
of led signal and ambient.  Yes the LED bit is for led 1, but there is nothing here indicating
that a fair bit of the signal may well come from elsewhere.
> 
>> The led version of ambient strikes me as odd to start with given I think the LED
>> is turned off during that measurement?  This is merely to do with when they
>> occur in the sequence?
>>
>> What we are really dealing with here is a single photodiode and an led sequencer.
>> Perhaps we need a modifier that simply means the source is an led driven at the same instance?
>> (this is the same as for proximity sensors, but there the signal is explicitly proximity).
>>
> 
> Yeah, the device is basically one photodiode and one ADC feeding to one of four storage
> registers. The sequencer controls which LEDs are on, what buffer to fill, and
> when the ADC is sampling from which buffer to which register. This is all user definable
> so you can sample one LED twice, or not even sample the ambient light at all if you
> want.
> 
> This I why I would like to keep the input names locked to the data sheet, they are named
> based on the name of the sequencer control that fills them. Abstracting this away would
> add endless confusion.
> 
>> Maybe, we should be treating these as a different type entirely?  They are measuring light
>> levels, but in common with proximity sensors the 'interesting' bit is what is effecting
>> those levels.  Perhaps a new type would make sense.
>> How about:
>>
>> in_intensitytransmittedX_raw
>> in_intensityX_raw
>>
>> This makes a mess of the differential channels however, as suddenly they are taking the
>> difference of two signals of different types.  Ah well there goes a good plan.  I'd neglected
>> that the transmitted version is the combination of the ambient and the transmitted.
>>
>> This is irritatingly hard to map onto anything generic.
>>
> 
> Exactly, there is no reason to enforce generic names for devices like these.
If there is going to be more than one of them and a common userspace library
then we need to have at least a consistent ABI.
> 
>> Perhaps the next thing is to think of these a bit like the ALS sensors that use
>> two sensors to work out what the illuminance is and do it similar to that (somewhat
>> hiding the relationship).  In that case we'd have
>>
>> in_intensityX_ambient_raw
>> in_intensityX_raw (transmitted and ambient - maybe some modifier to indicate this
>> - like we do for the hideous 'both' modifier for the visible + infrared sensitive
>> element is some ALSs? - note both seemed sensible at the time, now the name seems
>> bonkers - oops.)
>>
>> and the differential would become
>> in_intensitytransmittedX_raw
>>
>> In the ALS analogy the transform is often horribly non linear so could
>> never be represented as a differential channel (unlike here). Maybe
>> from a userspace interface point of view the best bet here is to not represent
>> it as a differential channel... Are all such light sensors even linear - here the
>> assumption is the connected diode is. Perhaps that won't always hold true in future.
>>
>> (this is my favourite option at the moment)
>>
> 
> The real issue is trying to use the framework and these modifiers to handle
> the naming and function for all these different devices, it's no longer a
> framework if it has to be modified and extended for every new device type.
The point is to extend it within the general structure of the framework. Of course
it needs to be extended for each new device type.  When we first got an accelerometer
did you expect us to pretend it was an ADC because that's all the framework supported
at the time?

This is measuring something new, hence not unreasonable to extend the ABI to cope with
it. Future devices measuring the same thing will have to use the ABI we define here.

Yes, the framework grows over time, and yes it needs to be extended. This is only
natural as new devices turn up that do new things.

Be careful to note that your strings naming the things would be just as much part of
the ABI as any new modifier or channel type.

If the framework is not general enough it needs to be extended.
> 
>>> +
>>> +What:        /sys/bus/iio/devices/iio:deviceX/in_intensity_led1-led1_ambient_raw
>>> +        /sys/bus/iio/devices/iio:deviceX/in_intensity_led2-led2_ambient_raw
>>> +Date:        October 2015
>>> +KernelVersion:
>>> +Contact:    Andrew F. Davis <afd@ti.com>
>>> +Description:
>>> +        Get differential values from the ADC for these stages.  The
>>> +        values are expressed in 24-bit twos complement for the
>>> +        specified LEDs.
>>> +
>>> +What:        /sys/bus/iio/devices/iio:deviceX/in_intensity_led1-led1_ambient_mean_raw
>>> +        /sys/bus/iio/devices/iio:deviceX/in_intensity_led2-led2_ambient_mean_raw
>>> +Date:        October 2015
>>> +KernelVersion:
>>> +Contact:    Andrew F. Davis <afd@ti.com>
>>> +Description:
>>> +        Get average values from the ADC for these stages.  The
>>> +        values are expressed in 24-bit twos complement for the
>>> +        specified LEDs.
>>
>> Oh goody another weird one ;)  I note in the current proposal, it's not obvious
>> that the mean acutally applies to the differential.  Another element in favour
>> of the new channel type option.
>>
>> We do have a chan info element for average raw that would do the job for the sysfs
>> attribute.   However, as you are pushing this into the buffer, it doesn't work for
>> us here.
>>
> 
> This seems like a big problem with the framework at the moment, we have all these
> modifiers and chan_info elements, but they only apply to the sysfs read/writes.
> So there is a large disconnect between sysfs channels and buffer channels,
> but solvable if we drop the modifiers and just have driver named channels.
I do see where you are coming from. Perhaps if we were starting again we could explore
whether it is possible to overcome the issues that drove us to modifiers in the first
place.

Perhaps we can extend the abi to include your naming suggestion (though I would not
include it in the sysfs attribute names, but rather as an additional field) but
it could only be used in cases where we are defining new ABI, not as a replacement
for existing ABI. 
> 
>> This is basically a low pass filtered version of the signal, so one option would
>> be a duplicate channel that has the addition of filter attributes to describe that
>> the filter applied (similar to the existing low pass filter controls).
>>
>> The challenge would be making it clear that the channel is infact the same as the
>> led2 channel but with the filter.
>>
> 
> Really not worth the effort obscuring these things, I don't see how we gain anything.
> 
>> Actually, odd question, but why would someone want both the unfiltered and filtered
>> versions via the buffered interface?
>>
> 
> I don't know, but the device offers it as a channel, so why decide for the customer
> what they can and cant do?
> 
>>> +
>>> +What:        /sys/bus/iio/devices/iio:deviceX/out_current_offdac_ledY_raw
>>> +        /sys/bus/iio/devices/iio:deviceX/out_current_offdac_ledY_ambient_raw
>>> +Date:        October 2015
>>> +KernelVersion:
>>> +Contact:    Andrew F. Davis <afd@ti.com>
>>> +Description:
>>> +        Get and set the offset cancellation DAC setting for these
>>> +        stages.
>>> +        Values range from 0 -> 15
>> Are these in mA?
>>
>> Not sure I like the naming here.  You could either treat them as explicit output
>> channels, or (and I'd be tempted to favour this) as calibration offsets for the
>> in_intensitytransmitted_ channel described above (or maybe the straight intensity
>> channels - I'm now confused on what is what here!).
>>
> 
> Can you imagine how the user will feel if we try to hide all the details with
> these names? The data sheet calls them 'offdac_led1' so why hide that.
Because the next datasheet that comes along for a different part might call
them something subtly different then we end up with needing custom userspace
code for each part.  If we do that then there is no point in having the devices
in IIO in the first place.   The reason all this ABI needs to be considered from
a generic point of view is that we are setting precedence.  Naming should not
be defined by what it happened to be called on the particular instance of
the datasheet against which the first driver was defined (and yes we have
had instances of the names changing entirely on datasheets).

The point is to come up with ABI that is generic. That is probably the most
important part of IIO (and the bit we spend most time discussing / arguing about).

This is a calibration offset applied to the incoming signal - arguably by calling
offdac_led1 you are obscuring the useful information to the user which is 'what
is this for?'.
  
> 
>>
>>
>>> diff --git a/drivers/iio/Kconfig b/drivers/iio/Kconfig
>>> index 4011eff..53e1892 100644
>>> --- a/drivers/iio/Kconfig
>>> +++ b/drivers/iio/Kconfig
>>> @@ -65,6 +65,7 @@ source "drivers/iio/common/Kconfig"
>>>   source "drivers/iio/dac/Kconfig"
>>>   source "drivers/iio/frequency/Kconfig"
>>>   source "drivers/iio/gyro/Kconfig"
>>> +source "drivers/iio/health/Kconfig"
>>>   source "drivers/iio/humidity/Kconfig"
>>>   source "drivers/iio/imu/Kconfig"
>>>   source "drivers/iio/light/Kconfig"
>>> diff --git a/drivers/iio/Makefile b/drivers/iio/Makefile
>>> index 698afc2..d350cb3 100644
>>> --- a/drivers/iio/Makefile
>>> +++ b/drivers/iio/Makefile
>>> @@ -18,6 +18,7 @@ obj-y += common/
>>>   obj-y += dac/
>>>   obj-y += gyro/
>>>   obj-y += frequency/
>>> +obj-y += health/
>>>   obj-y += humidity/
>>>   obj-y += imu/
>>>   obj-y += light/
>>> diff --git a/drivers/iio/health/Kconfig b/drivers/iio/health/Kconfig
>>> new file mode 100644
>>> index 0000000..f5e5d82
>>> --- /dev/null
>>> +++ b/drivers/iio/health/Kconfig
>>> @@ -0,0 +1,24 @@
>>> +#
>>> +# Health drivers
>>> +#
>>> +# When adding new entries keep the list in alphabetical order
>>> +
>>> +menu "Health"
>>> +
>>> +menu "Heart Rate Monitors"
>>> +
>>> +config AFE4404
>>> +    tristate "TI AFE4404 Heart Rate Monitor"
>>> +    depends on I2C
>>> +    select IIO_BUFFER
>>> +    select IIO_TRIGGERED_BUFFER
>>> +    help
>>> +      Say yes to choose the Texas Instruments AFE4404
>>> +      heart rate monitor and low-cost pulse oximeter.
>>> +
>>> +      To compile this driver as a module, choose M here: the
>>> +      module will be called afe4404.
>>> +
>>> +endmenu
>>> +
>>> +endmenu
>>> diff --git a/drivers/iio/health/Makefile b/drivers/iio/health/Makefile
>>> new file mode 100644
>>> index 0000000..c108c8d
>>> --- /dev/null
>>> +++ b/drivers/iio/health/Makefile
>>> @@ -0,0 +1,6 @@
>>> +#
>>> +# Makefile for IIO Health drivers
>>> +#
>>> +# When adding new entries keep the list in alphabetical order
>>> +
>>> +obj-$(CONFIG_AFE4404) += afe4404.o
>>> diff --git a/drivers/iio/health/afe4404.c b/drivers/iio/health/afe4404.c
>>> new file mode 100644
>>> index 0000000..af65f30
>>> --- /dev/null
>>> +++ b/drivers/iio/health/afe4404.c
>>> @@ -0,0 +1,526 @@
>>> +/*
>>> + * AFE4404 Heart Rate Monitors and Low-Cost Pulse Oximeters
>>> + *
>>> + * Author: Andrew F. Davis <afd@ti.com>
>>> + *
>>> + * Copyright: (C) 2015 Texas Instruments, Inc.
>>> + *
>>> + * This program is free software; you can redistribute it and/or modify
>>> + * it under the terms of the GNU General Public License version 2 as
>>> + * published by the Free Software Foundation.
>>> + *
>>> + * This program is distributed in the hope that it will be useful, but
>>> + * WITHOUT ANY WARRANTY; without even the implied warranty of
>>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
>>> + * General Public License for more details.
>>> + */
>>> +
>>> +#include <linux/device.h>
>>> +#include <linux/delay.h>
>>> +#include <linux/err.h>
>>> +#include <linux/interrupt.h>
>>> +#include <linux/i2c.h>
>>> +#include <linux/kernel.h>
>>> +#include <linux/module.h>
>>> +#include <linux/of_gpio.h>
>>> +#include <linux/regmap.h>
>>> +#include <linux/slab.h>
>>> +#include <linux/sysfs.h>
>>> +#include <linux/regulator/consumer.h>
>>> +
>>> +#include <linux/iio/iio.h>
>>> +#include <linux/iio/sysfs.h>
>>> +#include <linux/iio/buffer.h>
>>> +#include <linux/iio/trigger.h>
>>> +#include <linux/iio/triggered_buffer.h>
>>> +#include <linux/iio/trigger_consumer.h>
>>> +
>>> +#include "afe440x.h"
>>> +
>>> +#define AFE4404_DRIVER_NAME        "afe4404"
>>> +
>>> +/* AFE4404 registers */
>>
>> Maybe say 'AFE4404 specific registers' to make it clear
>> there are others in the header.
>>
> 
> ACK
> 
>>> +#define AFE4404_TIA_GAIN_SEP        0x20
>>> +#define AFE4404_TIA_GAIN        0x21
>>> +#define AFE4404_PROG_TG_STC        0x34
>>> +#define AFE4404_PROG_TG_ENDC        0x35
>>> +#define AFE4404_LED3LEDSTC        0x36
>>> +#define AFE4404_LED3LEDENDC        0x37
>>> +#define AFE4404_CLKDIV_PRF        0x39
>>> +#define AFE4404_OFFDAC            0x3a
>>> +#define AFE4404_DEC            0x3d
>>> +#define AFE4404_AVG_LED2_ALED2VAL    0x3f
>>> +#define AFE4404_AVG_LED1_ALED1VAL    0x40
>>> +
>>> +/* AFE4404 GAIN register fields */
>> Is it worth considering the regmap field stuff?  That
>> way all this could go into the field defintions, and
>> perhaps then give a cleaner driver?
> 
> I tried it here, it didn't really add anything useful in this instance.
Fair enough.
> 
>>> +#define AFE4404_TIA_GAIN_RES_MASK    GENMASK(2, 0)
>>> +#define AFE4404_TIA_GAIN_RES_SHIFT    0
>>> +#define AFE4404_TIA_GAIN_CAP_MASK    GENMASK(5, 3)
>>> +#define AFE4404_TIA_GAIN_CAP_SHIFT    3
>>> +
>>> +/* AFE4404 LEDCNTRL register fields */
>>> +#define AFE4404_LEDCNTRL_ILED1_MASK    GENMASK(5, 0)
>>> +#define AFE4404_LEDCNTRL_ILED1_SHIFT    0
>>> +#define AFE4404_LEDCNTRL_ILED2_MASK    GENMASK(11, 6)
>>> +#define AFE4404_LEDCNTRL_ILED2_SHIFT    6
>>> +#define AFE4404_LEDCNTRL_ILED3_MASK    GENMASK(17, 12)
>>> +#define AFE4404_LEDCNTRL_ILED3_SHIFT    12
>>> +
>>> +/* AFE4404 CONTROL3 register fields */
>>> +#define AFE440X_CONTROL3_OSC_ENABLE    BIT(9)
>>> +
>>> +/* AFE4404 OFFDAC register current fields */
>>> +#define AFE4404_OFFDAC_CURR_LED1_MASK    GENMASK(8, 5)
>>> +#define AFE4404_OFFDAC_CURR_LED1_SHIFT    5
>>> +#define AFE4404_OFFDAC_CURR_LED2_MASK    GENMASK(18, 15)
>>> +#define AFE4404_OFFDAC_CURR_LED2_SHIFT    15
>>> +#define AFE4404_OFFDAC_CURR_LED3_MASK    GENMASK(3, 0)
>>> +#define AFE4404_OFFDAC_CURR_LED3_SHIFT    0
>>> +#define AFE4404_OFFDAC_CURR_AMB1_MASK    GENMASK(13, 10)
>>> +#define AFE4404_OFFDAC_CURR_AMB1_SHIFT    10
>>> +#define AFE4404_OFFDAC_CURR_AMB2_MASK    GENMASK(3, 0)
>>> +#define AFE4404_OFFDAC_CURR_AMB2_SHIFT    0
>>> +
>>> +/* AFE4404 OFFDAC register polarity fields */
>>> +#define AFE4404_OFFDAC_POL_LED1_MASK    BIT(9)
>>> +#define AFE4404_OFFDAC_POL_LED1_SHIFT    9
>>> +#define AFE4404_OFFDAC_POL_LED2_MASK    BIT(19)
>>> +#define AFE4404_OFFDAC_POL_LED2_SHIFT    19
>>> +#define AFE4404_OFFDAC_POL_LED3_MASK    BIT(4)
>>> +#define AFE4404_OFFDAC_POL_LED3_SHIFT    4
>>> +#define AFE4404_OFFDAC_POL_AMB1_MASK    BIT(14)
>>> +#define AFE4404_OFFDAC_POL_AMB1_SHIFT    14
>>> +#define AFE4404_OFFDAC_POL_AMB2_MASK    BIT(4)
>>> +#define AFE4404_OFFDAC_POL_AMB2_SHIFT    4
>>> +
>>> +/* AFE4404 TIA_GAIN_CAP values */
>>> +#define AFE4404_TIA_GAIN_CAP_5_P    0x0
>>> +#define AFE4404_TIA_GAIN_CAP_2_5_P    0x1
>>> +#define AFE4404_TIA_GAIN_CAP_10_P    0x2
>>> +#define AFE4404_TIA_GAIN_CAP_7_5_P    0x3
>>> +#define AFE4404_TIA_GAIN_CAP_20_P    0x4
>>> +#define AFE4404_TIA_GAIN_CAP_17_5_P    0x5
>>> +#define AFE4404_TIA_GAIN_CAP_25_P    0x6
>>> +#define AFE4404_TIA_GAIN_CAP_22_5_P    0x7
>> I'd be tempted to represent this as a lookup table instead
>> of this set of defines.  This is particular true
>> in light of the fact the sysfs attribute needs to map them
>> to standard units. Given that will need to be in nano farads
>> and these are pico you only need the 'val2 part' and use the
>> int_plus_micro form.  The search will be rather more iritating
>> as these are in a non obvious order, but such is life.
>>
>> Hence (I'd use the C99 asignments stuff to make it obvious
>> that the index is important!)
>>
>> static const int afe4404_tia_gain_caps_femto_farads[] = {
>>        [0] = 5000,
>>        [1] = 2500,
>>        [2] = 10000,
>>        [3] = 7500,
>>        [4] = 20000,
>>        [5] = 17500,
>>        [6] = 25000,
>>        [7] = 22500 };
> 
> If I offered the scaled input to userspace this will probably be
> how I do it. Before the defines were only used internally for
> setting the default values.
> 
>>> +
>>> +/* AFE4404 TIA_GAIN_RES values */
>>> +#define AFE4404_TIA_GAIN_RES_500_K    0x0
>>> +#define AFE4404_TIA_GAIN_RES_250_K    0x1
>>> +#define AFE4404_TIA_GAIN_RES_100_K    0x2
>>> +#define AFE4404_TIA_GAIN_RES_50_K    0x3
>>> +#define AFE4404_TIA_GAIN_RES_25_K    0x4
>>> +#define AFE4404_TIA_GAIN_RES_10_K    0x5
>>> +#define AFE4404_TIA_GAIN_RES_1_M    0x6
>>> +#define AFE4404_TIA_GAIN_RES_2_M    0x7
>>
>> Same as for the capacitances.
>>
>>> +
>>> +enum afe4404_chan_id {
>>> +    LED1VAL,
>>> +    ALED1VAL,
>>> +    LED2VAL,
>>> +    ALED2VAL,
>>> +    LED3VAL,
>>> +    LED1_ALED1VAL,
>>> +    LED2_ALED2VAL,
>>> +    AVG_LED1_ALED1VAL,
>>> +    AVG_LED2_ALED2VAL,
>>> +};
>>> +
>>> +static const struct iio_chan_spec afe4404_channels[] = {
>>> +    /* ADC values from the IC */
>>> +    AFE440X_READ_CHAN(LED1VAL, "led1", AFE440X_LED1VAL),
>>> +    AFE440X_READ_CHAN(ALED1VAL, "led1_ambient", AFE440X_ALED1VAL),
>>> +    AFE440X_READ_CHAN(LED2VAL, "led2", AFE440X_LED2VAL),
>>> +    AFE440X_READ_CHAN(ALED2VAL, "led2_ambient", AFE440X_ALED2VAL),
>>> +    AFE440X_READ_CHAN(LED3VAL, "led3", AFE440X_ALED2VAL),
>>> +    AFE440X_READ_CHAN(LED1_ALED1VAL, "led1-led1_ambient", AFE440X_LED1_ALED1VAL),
>>> +    AFE440X_READ_CHAN(LED2_ALED2VAL, "led2-led2_ambient", AFE440X_LED2_ALED2VAL),
>>> +    AFE440X_READ_CHAN(AVG_LED1_ALED1VAL, "led1-led1_ambient_mean", AFE4404_AVG_LED1_ALED1VAL),
>>> +    AFE440X_READ_CHAN(AVG_LED2_ALED2VAL, "led2-led2_ambient_mean", AFE4404_AVG_LED2_ALED2VAL),
>>> +};
>>> +
>>> +static ssize_t afe440x_show_register(struct device *dev,
>>> +                  struct device_attribute *attr,
>>> +                  char *buf)
>>> +{
>>> +    struct iio_dev *indio_dev = dev_to_iio_dev(dev);
>>> +    struct afe440x_data *afe440x = iio_device_get_drvdata(indio_dev);
>>> +    struct afe440x_reg *afe440x_reg = to_afe440x_reg(attr);
>>> +    int reg_val;
>>> +    int ret;
>>> +
>>> +    ret = regmap_read(afe440x->regmap, afe440x_reg->reg, &reg_val);
>>> +    if (ret)
>>> +        return ret;
>>> +
>>> +    reg_val >>= afe440x_reg->shift;
>>> +    reg_val &= afe440x_reg->mask;
>>> +
>>> +    return scnprintf(buf, PAGE_SIZE, "%u\n", reg_val);
>>> +}
>>> +
>>> +static ssize_t afe440x_store_register(struct device *dev,
>>> +                   struct device_attribute *attr,
>>> +                   const char *buf, size_t count)
>>> +{
>>> +    struct iio_dev *indio_dev = dev_to_iio_dev(dev);
>>> +    struct afe440x_data *afe440x = iio_device_get_drvdata(indio_dev);
>>> +    struct afe440x_reg *afe440x_reg = to_afe440x_reg(attr);
>>> +    unsigned val;
>>> +    int reg_val;
>>> +    int ret;
>>> +
>>> +    if (kstrtoint(buf, 0, &val))
>>> +        return -EINVAL;
>>> +
>>> +    ret = regmap_read(afe440x->regmap, afe440x_reg->reg, &reg_val);
>>> +    if (ret)
>>> +        return ret;
>>> +
>>> +    reg_val &= ~afe440x_reg->mask;
>>> +    reg_val |= ((val << afe440x_reg->shift) & afe440x_reg->mask);
>>> +
>>> +    ret = regmap_write(afe440x->regmap, afe440x_reg->reg, reg_val);
>>> +    if (ret)
>>> +        return ret;
>>> +
>>> +    return count;
>>> +}
>>> +
>>> +AFE440X_ATTR(tia_separate_enable, AFE4404_TIA_GAIN_SEP, AFE440X_TIAGAIN_ENSEPGAIN);
>>> +
>>> +AFE440X_ATTR(out_resistance1_tia_raw, AFE4404_TIA_GAIN, AFE4404_TIA_GAIN_RES);
>>> +AFE440X_ATTR(out_capacitance1_tia_raw, AFE4404_TIA_GAIN, AFE4404_TIA_GAIN_CAP);
>>> +
>>> +AFE440X_ATTR(out_resistance2_tia_raw, AFE4404_TIA_GAIN_SEP, AFE4404_TIA_GAIN_RES);
>>> +AFE440X_ATTR(out_capacitance2_tia_raw, AFE4404_TIA_GAIN_SEP, AFE4404_TIA_GAIN_CAP);
>> I talk about these above.  They look to me like they should either be treated as output
>> channels or possibly as controls on a filter (which is what they really are)
>>> +
>>> +AFE440X_ATTR(out_current_offdac_led1_raw, AFE4404_OFFDAC, AFE4404_OFFDAC_CURR_LED1);
>>> +AFE440X_ATTR(out_current_offdac_led2_raw, AFE4404_OFFDAC, AFE4404_OFFDAC_CURR_LED2);
>>> +AFE440X_ATTR(out_current_offdac_led3_raw, AFE4404_OFFDAC, AFE4404_OFFDAC_CURR_LED3);
>> Again, talked about earlier.  These could be treated as calibration offsets (similar to
>> the ones applied to trim gyros in high end IMUs for example).
>>
>> This stuff makes me wonder whether we are anywhere near descriptive enough of the analog
>> front ends to devices we support.  Probably not I guess!
> 
> As above, I would probably just leave this to the individual part driver's discretion how
> the front end controls are named and handled.
This is ABI - hence the first driver set precedence. What these do is not really part specific
so we should work out generic ABI.
> 
>>> +
>>> +AFE440X_ATTR(out_current_offdac_led1_ambient_raw, AFE4404_OFFDAC, AFE4404_OFFDAC_CURR_AMB1);
>>> +AFE440X_ATTR(out_current_offdac_led2_ambient_raw, AFE4404_OFFDAC, AFE4404_OFFDAC_CURR_AMB2);
>>> +
>>> +AFE440X_ATTR(out_current_led1_raw, AFE440X_LEDCNTRL, AFE4404_LEDCNTRL_ILED1);
>>> +AFE440X_ATTR(out_current_led2_raw, AFE440X_LEDCNTRL, AFE4404_LEDCNTRL_ILED2);
>>> +AFE440X_ATTR(out_current_led3_raw, AFE440X_LEDCNTRL, AFE4404_LEDCNTRL_ILED3);
>> We already do this for some proximity sensors - just might be better to represent them
>> as straight forward output channels.  I suppose if we really get into it they
>> are output intensity channels, but perhaps best to ignore that.
> 
> Right, they are not meant to be set very often or steamed to like a DAC channel,
> probably best to just leave them as sysfs controls.
They can still be sysfs only and channels.
Just set the scan_index for them to -1.

One advantage of this is that they become accessible to other users within the kernel
(why they'd want to access them I have no idea ;)

> 
>>> +
>>> +static struct attribute *afe4404_attributes[] = {
>>> +    &afe440x_reg_tia_separate_enable.dev_attr.attr,
>>> +    &afe440x_reg_out_resistance1_tia_raw.dev_attr.attr,
>>> +    &afe440x_reg_out_capacitance1_tia_raw.dev_attr.attr,
>>> +    &afe440x_reg_out_resistance2_tia_raw.dev_attr.attr,
>>> +    &afe440x_reg_out_capacitance2_tia_raw.dev_attr.attr,
>>> +    &afe440x_reg_out_current_offdac_led1_raw.dev_attr.attr,
>>> +    &afe440x_reg_out_current_offdac_led2_raw.dev_attr.attr,
>>> +    &afe440x_reg_out_current_offdac_led3_raw.dev_attr.attr,
>>> +    &afe440x_reg_out_current_offdac_led1_ambient_raw.dev_attr.attr,
>>> +    &afe440x_reg_out_current_offdac_led2_ambient_raw.dev_attr.attr,
>>> +    &afe440x_reg_out_current_led1_raw.dev_attr.attr,
>>> +    &afe440x_reg_out_current_led2_raw.dev_attr.attr,
>>> +    &afe440x_reg_out_current_led3_raw.dev_attr.attr,
>>> +    NULL
>>> +};
>>> +
>>> +static const struct attribute_group afe4404_attribute_group = {
>>> +    .attrs = afe4404_attributes
>>> +};
>>> +
>>> +static int afe440x_read_raw(struct iio_dev *indio_dev,
>>> +             struct iio_chan_spec const *chan,
>>> +             int *val, int *val2, long mask)
>>> +{
>>> +    struct afe440x_data *afe440x = iio_device_get_drvdata(indio_dev);
>>> +    int ret;
>>> +
>>> +    ret = regmap_read(afe440x->regmap, chan->address, val);
>>> +    if (ret)
>>> +        return ret;
>>> +
>>> +    *val2 = 0;
>> There should be no need to set *val2 as it's never read if the return
>> is IIO_VAL_INT.  Nothing wrong with paranoia however ;)
> 
> ACK
> 
>>> +
>>> +    return IIO_VAL_INT;
>>> +}
>>> +
>>> +static const struct iio_info afe4404_iio_info = {
>>> +    .attrs    = &afe4404_attribute_group,
>>> +    .read_raw = afe440x_read_raw,
>>> +    .driver_module = THIS_MODULE,
>>> +};
>>> +
>>> +static irqreturn_t afe440x_trigger_handler(int irq, void *private)
>>> +{
>>> +    struct iio_poll_func *pf = (struct iio_poll_func *)private;
>> Shouldn't be any need to explicitly cast when coming from a void *
>>
> 
> ACK
> 
>>> +    struct iio_dev *indio_dev = pf->indio_dev;
>>> +    struct afe440x_data *afe440x = iio_device_get_drvdata(indio_dev);
>>> +    int ret, bit, reg, i = 0;
>>> +    s32 buffer[10];
>> So there are 9 channels?  Then you need space for the timestamp that needs
>> to be 8 byte aligned. Hence this needs to be s32 buffer[12].
>> (iio_push_to_buffers_with_timestamp is rather odd  - see the documentation)
> 
> Yeah, this is a left over from the AFE4403 that only has 8 channels. Fixed.
> 
>>> +
>>> +    for_each_set_bit(bit, indio_dev->active_scan_mask,
>>> +             indio_dev->masklength) {
>>> +        reg = afe440x->channels[bit].address;
>>
>> Why using the version in afe440x (which arguably shouldn't be there)
>> rather than the one in indio_dev->channels[bit].address?
>>
> 
> Ops, forgot that is still accesable in indio_dev. Fixed.
> 
>>> +        ret = regmap_read(afe440x->regmap, reg, &buffer[i++]);
>>> +        if (ret)
>>> +            goto err;
>>> +    }
>>> +
>>> +    iio_push_to_buffers_with_timestamp(indio_dev, buffer, pf->timestamp);
>>> +err:
>>> +    iio_trigger_notify_done(indio_dev->trig);
>>> +
>>> +    return IRQ_HANDLED;
>>> +}
>>> +
>>> +static const struct iio_trigger_ops afe440x_trigger_ops = {
>>> +    .owner = THIS_MODULE,
>>> +};
>>> +
>>> +/* Default timings from data-sheet */
>>> +#define AFE4404_TIMING_PAIRS            \
>>> +    { AFE440X_PRPCOUNT,    39999    },    \
>>> +    { AFE440X_LED2LEDSTC,    0    },    \
>>> +    { AFE440X_LED2LEDENDC,    398    },    \
>>> +    { AFE440X_LED2STC,    80    },    \
>>> +    { AFE440X_LED2ENDC,    398    },    \
>>> +    { AFE440X_ADCRSTSTCT0,    5600    },    \
>>> +    { AFE440X_ADCRSTENDCT0,    5606    },    \
>>> +    { AFE440X_LED2CONVST,    5607    },    \
>>> +    { AFE440X_LED2CONVEND,    6066    },    \
>>> +    { AFE4404_LED3LEDSTC,    400    },    \
>>> +    { AFE4404_LED3LEDENDC,    798    },    \
>>> +    { AFE440X_ALED2STC,    480    },    \
>>> +    { AFE440X_ALED2ENDC,    798    },    \
>>> +    { AFE440X_ADCRSTSTCT1,    6068    },    \
>>> +    { AFE440X_ADCRSTENDCT1,    6074    },    \
>>> +    { AFE440X_ALED2CONVST,    6075    },    \
>>> +    { AFE440X_ALED2CONVEND,    6534    },    \
>>> +    { AFE440X_LED1LEDSTC,    800    },    \
>>> +    { AFE440X_LED1LEDENDC,    1198    },    \
>>> +    { AFE440X_LED1STC,    880    },    \
>>> +    { AFE440X_LED1ENDC,    1198    },    \
>>> +    { AFE440X_ADCRSTSTCT2,    6536    },    \
>>> +    { AFE440X_ADCRSTENDCT2,    6542    },    \
>>> +    { AFE440X_LED1CONVST,    6543    },    \
>>> +    { AFE440X_LED1CONVEND,    7003    },    \
>>> +    { AFE440X_ALED1STC,    1280    },    \
>>> +    { AFE440X_ALED1ENDC,    1598    },    \
>>> +    { AFE440X_ADCRSTSTCT3,    7005    },    \
>>> +    { AFE440X_ADCRSTENDCT3,    7011    },    \
>>> +    { AFE440X_ALED1CONVST,    7012    },    \
>>> +    { AFE440X_ALED1CONVEND,    7471    },    \
>>> +    { AFE440X_PDNCYCLESTC,    7671    },    \
>>> +    { AFE440X_PDNCYCLEENDC,    39199    }
>>> +
>>> +static const struct reg_sequence afe4404_reg_sequences[] = {
>>> +    AFE4404_TIMING_PAIRS,
>>> +    { AFE440X_CONTROL1, AFE440X_CONTROL1_TIMEREN },
>>> +    { AFE4404_TIA_GAIN, AFE4404_TIA_GAIN_RES_50_K },
>>> +    { AFE440X_LEDCNTRL, (0xf << AFE4404_LEDCNTRL_ILED1_SHIFT) |
>>> +                (0x3 << AFE4404_LEDCNTRL_ILED2_SHIFT) |
>>> +                (0x3 << AFE4404_LEDCNTRL_ILED3_SHIFT) },
>>> +    { AFE440X_CONTROL2, AFE440X_CONTROL3_OSC_ENABLE    },
>>> +};
>>> +
>>> +static const struct regmap_range afe4404_yes_ranges[] = {
>>> +    regmap_reg_range(AFE440X_LED2VAL, AFE440X_LED1_ALED1VAL),
>>> +    regmap_reg_range(AFE4404_AVG_LED2_ALED2VAL, AFE4404_AVG_LED1_ALED1VAL),
>>> +};
>>> +
>>> +static const struct regmap_access_table afe4404_volatile_table = {
>>> +    .yes_ranges = afe4404_yes_ranges,
>>> +    .n_yes_ranges = ARRAY_SIZE(afe4404_yes_ranges),
>>> +};
>>> +
>>> +static const struct regmap_config afe4404_regmap_config = {
>>> +    .reg_bits = 8,
>>> +    .val_bits = 24,
>>> +
>>> +    .max_register = AFE4404_AVG_LED1_ALED1VAL,
>>> +    .cache_type = REGCACHE_RBTREE,
>>> +    .volatile_table = &afe4404_volatile_table,
>>> +};
>>> +
>>> +#ifdef CONFIG_OF
>>> +static const struct of_device_id afe4404_of_match[] = {
>>> +    { .compatible = "ti,afe4404", },
>>> +    { /* sentinel */ },
>>> +};
>>> +MODULE_DEVICE_TABLE(of, afe4404_of_match);
>>> +#endif
>>> +
>>> +static int afe440x_suspend(struct device *dev)
>>> +{
>>> +    struct afe440x_data *afe440x = dev_get_drvdata(dev);
>>> +    int ret;
>>> +
>>> +    ret = regmap_update_bits(afe440x->regmap, AFE440X_CONTROL2,
>>> +                 AFE440X_CONTROL2_PDN_AFE,
>>> +                 AFE440X_CONTROL2_PDN_AFE);
>>> +    if (ret)
>>> +        return ret;
>>> +
>>> +    ret = regulator_disable(afe440x->regulator);
>>> +    if (ret) {
>>> +        dev_err(dev, "Failed to disable regulator\n");
>>> +        return ret;
>>> +    }
>>> +
>>> +    return 0;
>>> +}
>>> +
>>> +static int afe440x_resume(struct device *dev)
>>> +{
>>> +    struct afe440x_data *afe440x = dev_get_drvdata(dev);
>>> +    int ret;
>>> +
>>> +    ret = regmap_update_bits(afe440x->regmap, AFE440X_CONTROL2,
>>> +                 AFE440X_CONTROL2_PDN_AFE, 0);
>>> +    if (ret)
>>> +        return ret;
>>> +
>>> +    ret = regulator_enable(afe440x->regulator);
>>> +    if (ret) {
>>> +        dev_err(dev, "Failed to enable regulator\n");
>>> +        return ret;
>>> +    }
>>> +
>>> +    return 0;
>>> +}
>>> +
>>> +SIMPLE_DEV_PM_OPS(afe440x_pm_ops, afe440x_suspend, afe440x_resume);
>>> +
>>> +static int afe440x_iio_setup(struct afe440x_data *afe440x)
>>> +{
>>> +    struct iio_dev *indio_dev;
>>> +    int ret;
>>> +
>>> +    indio_dev = devm_iio_device_alloc(afe440x->dev, 0);
>>> +    if (indio_dev == NULL) {
>>> +        dev_err(afe440x->dev, "Unable to allocate IIO device\n");
>>> +        return -ENOMEM;
>>> +    }
>>> +
>>> +    iio_device_set_drvdata(indio_dev, afe440x);
>>> +
>>> +    indio_dev->modes = INDIO_DIRECT_MODE;
>>> +    indio_dev->dev.parent = afe440x->dev;
>>> +    indio_dev->channels = afe440x->channels;
>>> +    indio_dev->num_channels = afe440x->num_channels;
>>> +    indio_dev->name = afe440x->name;
>>> +    indio_dev->info = afe440x->info;
>>> +
>>> +    if (afe440x->irq > 0) {
>>> +        afe440x->trig = devm_iio_trigger_alloc(afe440x->dev, "%s-dev%d",
>>> +                               indio_dev->name,
>>> +                               indio_dev->id);
>>> +        if (afe440x->trig == NULL) {
>>> +            dev_err(afe440x->dev, "Unable to allocate IIO trigger\n");
>>> +            return -ENOMEM;
>>> +        }
>>> +
>>> +        iio_trigger_set_drvdata(afe440x->trig, indio_dev);
>>> +
>>> +        afe440x->trig->ops = &afe440x_trigger_ops;
>>> +        afe440x->trig->dev.parent = afe440x->dev;
>>> +
>>> +        ret = iio_trigger_register(afe440x->trig);
>>> +        if (ret) {
>>> +            dev_err(afe440x->dev, "Unable to register IIO trigger\n");
>>> +            return ret;
>>> +        }
>>> +
>>> +        ret = devm_request_threaded_irq(afe440x->dev, afe440x->irq,
>>> +                        iio_trigger_generic_data_rdy_poll,
>>> +                        NULL, IRQF_ONESHOT,
>>> +                        "afe4404", afe440x->trig);
>>> +        if (ret) {
>>> +            dev_err(afe440x->dev, "Unable to request IRQ\n");
>>> +            return ret;
>>> +        }
>>> +    }
>>> +
>>> +    ret = iio_triggered_buffer_setup(indio_dev, &iio_pollfunc_store_time,
>>> +                     &afe440x_trigger_handler, NULL);
>>> +    if (ret) {
>>> +        dev_err(afe440x->dev, "Unable to setup buffer\n");
>>> +        return ret;
>>> +    }
>>> +
>>> +    ret = devm_iio_device_register(afe440x->dev, indio_dev);
>>> +    if (ret) {
>>> +        dev_err(afe440x->dev, "Unable to register IIO device\n");
>>> +        return ret;
>>> +    }
>>> +
>>> +    return 0;
>>> +}
>>> +
>>> +static int afe4404_probe(struct i2c_client *client,
>>> +            const struct i2c_device_id *id)
>>> +{
>>> +    struct afe440x_data *afe440x;
>>> +    int ret;
>>> +
>>> +    afe440x = devm_kzalloc(&client->dev, sizeof(*afe440x), GFP_KERNEL);
>>> +    if (!afe440x)
>>> +        return -ENOMEM;
>> Hmm. I guess this more of the stuff from this being a highly modular driver.
>> Right now that is really hurting the organisation of the code.
>>
>> You'd be better off just using the devm_iio_device_alloc call to allocate
>> both your private data and the iio device data.  You could then pass the
>> iio_dev to your iio_setup function if you really want to.
>> Not bouncing through having copies of everything in your afe440x structure
>> would also make it a lot cleaner without hurting your modularity substantially.
>>
>> I can see that you were aiming to completely separate the iio side
>> from the more generic driver parts, but that division is all a bit blured and
>> leads to more complex code.
>>
> 
> Well the reason for this was that everytime I would fix something or add it in
> the afe4404 driver I would have to make the same change in the afe4403, so I
> moved all this stuff to a single common file. Only the interface and some IIO
> table are different between parts. The division is by device differece, not by
> IIO/generic code. I can push the AFE4403 driver if you would like to see how
> little code is needed to suport the other device.
> 
>>> +
>>> +    i2c_set_clientdata(client, afe440x);
>>> +
>>> +    afe440x->dev = &client->dev;
>>> +    afe440x->irq = client->irq;
>>> +
>>> +    afe440x->regmap = devm_regmap_init_i2c(client, &afe4404_regmap_config);
>>> +    if (IS_ERR(afe440x->regmap)) {
>>> +        dev_err(afe440x->dev, "Unable to allocate register map\n");
>>> +        return PTR_ERR(afe440x->regmap);
>>> +    }
>>> +
>>> +    afe440x->regulator = devm_regulator_get(afe440x->dev, "led");
>>> +    if (IS_ERR(afe440x->regulator)) {
>>> +        dev_err(afe440x->dev, "Unable to get regulator\n");
>>> +        return PTR_ERR(afe440x->regulator);
>>> +    }
>>> +
>>> +    ret = regmap_write(afe440x->regmap, AFE440X_CONTROL0,
>>> +               AFE440X_CONTROL0_SW_RESET);
>>> +    if (ret) {
>>> +        dev_err(afe440x->dev, "Unable to reset device\n");
>>> +        return ret;
>>> +    }
>>> +
>>> +    ret = regmap_register_patch(afe440x->regmap, afe4404_reg_sequences,
>>> +                    ARRAY_SIZE(afe4404_reg_sequences));
>> Cool. Never knew that one existed before...
>>> +    if (ret) {
>>> +        dev_err(afe440x->dev, "Unable to set register defaults\n");
>>> +        return ret;
>>> +    }
>>> +
>>> +    afe440x->channels = afe4404_channels;
>>> +    afe440x->num_channels = ARRAY_SIZE(afe4404_channels);
>>> +    afe440x->name = AFE4404_DRIVER_NAME;
>>> +    afe440x->info = &afe4404_iio_info;
>>> +
>>> +    return afe440x_iio_setup(afe440x);
>>> +}
>>> +
>>> +static const struct i2c_device_id afe4404_ids[] = {
>>> +    { "afe4404", 0 },
>>> +    { /* sentinel */ },
>>> +};
>>> +MODULE_DEVICE_TABLE(i2c, afe4404_ids);
>>> +
>>> +static struct i2c_driver afe4404_i2c_driver = {
>>> +    .driver = {
>>> +        .name = AFE4404_DRIVER_NAME,
>>> +        .of_match_table = of_match_ptr(afe4404_of_match),
>>> +        .pm = &afe440x_pm_ops,
>>> +    },
>>> +    .probe = afe4404_probe,
>>> +    .id_table = afe4404_ids,
>>> +};
>>> +module_i2c_driver(afe4404_i2c_driver);
>>> +
>>> +MODULE_AUTHOR("Andrew F. Davis <afd@ti.com>");
>>> +MODULE_DESCRIPTION("TI AFE4404 Heart Rate and Pulse Oximeter");
>>> +MODULE_LICENSE("GPL");
>>> diff --git a/drivers/iio/health/afe440x.h b/drivers/iio/health/afe440x.h
>>> new file mode 100644
>>> index 0000000..2d98a20
>>> --- /dev/null
>>> +++ b/drivers/iio/health/afe440x.h
>>> @@ -0,0 +1,159 @@
>>> +/*
>>> + * AFE440X Heart Rate Monitors and Low-Cost Pulse Oximeters
>>> + *
>>> + * Author: Andrew F. Davis <afd@ti.com>
>>> + *
>>> + * Copyright: (C) 2015 Texas Instruments, Inc.
>>> + *
>>> + * This program is free software; you can redistribute it and/or modify
>>> + * it under the terms of the GNU General Public License version 2 as
>>> + * published by the Free Software Foundation.
>>> + *
>>> + * This program is distributed in the hope that it will be useful, but
>>> + * WITHOUT ANY WARRANTY; without even the implied warranty of
>>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
>>> + * General Public License for more details.
>>> + */
>>> +
>>> +#ifndef _AFE440X_H
>>> +#define _AFE440X_H
>>> +
>>> +/* AFE440X registers */
>>> +#define AFE440X_CONTROL0        0x00
>>> +#define AFE440X_LED2STC            0x01
>>> +#define AFE440X_LED2ENDC        0x02
>>> +#define AFE440X_LED1LEDSTC        0x03
>>> +#define AFE440X_LED1LEDENDC        0x04
>>> +#define AFE440X_ALED2STC        0x05
>>> +#define AFE440X_ALED2ENDC        0x06
>>> +#define AFE440X_LED1STC            0x07
>>> +#define AFE440X_LED1ENDC        0x08
>>> +#define AFE440X_LED2LEDSTC        0x09
>>> +#define AFE440X_LED2LEDENDC        0x0a
>>> +#define AFE440X_ALED1STC        0x0b
>>> +#define AFE440X_ALED1ENDC        0x0c
>>> +#define AFE440X_LED2CONVST        0x0d
>>> +#define AFE440X_LED2CONVEND        0x0e
>>> +#define AFE440X_ALED2CONVST        0x0f
>>> +#define AFE440X_ALED2CONVEND        0x10
>>> +#define AFE440X_LED1CONVST        0x11
>>> +#define AFE440X_LED1CONVEND        0x12
>>> +#define AFE440X_ALED1CONVST        0x13
>>> +#define AFE440X_ALED1CONVEND        0x14
>>> +#define AFE440X_ADCRSTSTCT0        0x15
>>> +#define AFE440X_ADCRSTENDCT0        0x16
>>> +#define AFE440X_ADCRSTSTCT1        0x17
>>> +#define AFE440X_ADCRSTENDCT1        0x18
>>> +#define AFE440X_ADCRSTSTCT2        0x19
>>> +#define AFE440X_ADCRSTENDCT2        0x1a
>>> +#define AFE440X_ADCRSTSTCT3        0x1b
>>> +#define AFE440X_ADCRSTENDCT3        0x1c
>>> +#define AFE440X_PRPCOUNT        0x1d
>>> +#define AFE440X_CONTROL1        0x1e
>>> +#define AFE440X_TIAGAIN            0x20
>>> +#define AFE440X_TIA_AMB_GAIN        0x21
>>> +#define AFE440X_LEDCNTRL        0x22
>>> +#define AFE440X_CONTROL2        0x23
>>> +#define AFE440X_ALARM            0x29
>>> +#define AFE440X_LED2VAL            0x2a
>>> +#define AFE440X_ALED2VAL        0x2b
>>> +#define AFE440X_LED1VAL            0x2c
>>> +#define AFE440X_ALED1VAL        0x2d
>>> +#define AFE440X_LED2_ALED2VAL        0x2e
>>> +#define AFE440X_LED1_ALED1VAL        0x2f
>>> +#define AFE440X_CONTROL3        0x31
>>> +#define AFE440X_PDNCYCLESTC        0x32
>>> +#define AFE440X_PDNCYCLEENDC        0x33
>>> +
>>> +/* CONTROL0 register fields */
>>> +#define AFE440X_CONTROL0_REG_READ    BIT(0)
>>> +#define AFE440X_CONTROL0_TM_COUNT_RST    BIT(1)
>>> +#define AFE440X_CONTROL0_SW_RESET    BIT(3)
>>> +
>>> +/* CONTROL1 register fields */
>>> +#define AFE440X_CONTROL1_TIMEREN    BIT(8)
>>> +
>>> +/* TIAGAIN register fields */
>>> +#define AFE440X_TIAGAIN_ENSEPGAIN_MASK    BIT(15)
>>> +#define AFE440X_TIAGAIN_ENSEPGAIN_SHIFT    15
>>> +
>>> +/* CONTROL2 register fields */
>>> +#define AFE440X_CONTROL2_PDN_AFE    BIT(0)
>>> +#define AFE440X_CONTROL2_PDN_RX        BIT(1)
>>> +#define AFE440X_CONTROL2_DYNAMIC4    BIT(3)
>>> +#define AFE440X_CONTROL2_DYNAMIC3    BIT(4)
>>> +#define AFE440X_CONTROL2_DYNAMIC2    BIT(14)
>>> +#define AFE440X_CONTROL2_DYNAMIC1    BIT(20)
>>> +
>>> +/* CONTROL3 register fields */
>>> +#define AFE440X_CONTROL3_CLKDIV        GENMASK(2, 0)
>>> +
>>> +/* CONTROL0 values */
>>> +#define AFE440X_CONTROL0_WRITE        0x0
>>> +#define AFE440X_CONTROL0_READ        0x1
>>> +
>>> +#define AFE440X_READ_CHAN(_index, _name, _address)        \
>>> +    {                            \
>>> +        .type = IIO_INTENSITY,                \
>>> +        .channel = _index,                \
>>> +        .address = _address,                \
>>> +        .scan_index = _index,                \
>>> +        .scan_type = {                    \
>>> +                .sign = 's',            \
>>> +                .realbits = 24,            \
>>> +                .storagebits = 32,        \
>>> +                .endianness = IIO_CPU,        \
>>> +        },                        \
>>> +        .extend_name = _name,                \
>>> +        .info_mask_separate = BIT(IIO_CHAN_INFO_RAW),    \
>>> +    }
>>> +
>>> +struct afe440x_reg {
>>> +    struct device_attribute dev_attr;
>>> +    u8 reg;
>>> +    unsigned long shift;
>>> +    unsigned long mask;
>>> +};
>>> +
>>> +#define to_afe440x_reg(_dev_attr)                \
>>> +    container_of(_dev_attr, struct afe440x_reg, dev_attr)
>>> +
>>> +#define AFE440X_ATTR(_name, _reg, _field)            \
>>> +    struct afe440x_reg afe440x_reg_##_name = {        \
>>> +        .dev_attr = __ATTR(_name, (S_IRUGO | S_IWUSR),    \
>>> +                   afe440x_show_register,    \
>>> +                   afe440x_store_register),    \
>>> +        .reg = _reg,                    \
>>> +        .shift = _field ## _SHIFT,            \
>>> +        .mask = _field ## _MASK,            \
>>> +    }
>>> +
>>> +/**
>>> + * struct afe440x_data
>>> + * @dev - Device structure
>>> + * @name - Device name
>>> + * @spi - SPI device pointer the driver is attached to
>>> + * @iolock - Read/Write mutex
>>> + * @regmap - Register map of the device
>>> + * @regulator - Pointer to the regulator for the IC
>>> + * @channels - IIO channels
>>> + * @num_channels - Number of IIO channels
>>> + * @info - IIO info for device
>>> + * @trig - IIO trigger for this device
>>> + * @irq - ADC_RDY line interrupt number
>>> +**/
>>> +struct afe440x_data {
>>> +    struct device *dev;
>> This is used in remarkably few places and those are all effectively
>> in the device probe.  Perhaps just passing it directly would make sense.
>>
>>> +    const char *name;
>> Why have another instance of name given it's held in the iio_dev anyway?
>>
>>> +    struct spi_device *spi;
>> Not used anywhere that I can find.
>>
> 
> This structure is common to the AFE4404 and AFE4403, storing the spi_device
> is only needed for the AFE4403 (I'm hoping to use regmap for both and remove
> this but the AFE4403's SPI interface seems non-standard and so incompatible
> with regmap, but I'm still testing this).
> 
>>> +    struct mutex iolock;
>> Another one not used anywhere (left-overs from pre regmap?)
>>
> 
> Same as above, used for the SPI devices.
> 
>>> +    struct regmap *regmap;
>>> +    struct regulator *regulator;
>>> +    struct iio_chan_spec const *channels;
>>> +    int num_channels;
>> Having the above in here as well makes limited sense given the versions
>> in iio_dev are identical.
>>
>> I'm guessing some of this was due to how the modular stuff you refer
>> to in the cover letter was done.  However, I'm suspecting that was
>> done less than cleanly to end up with this mixture of constant and non
>> constant elements in here.  There should have been a chip_info structure
>> consisting of entirely constant elements (such as channels etc) rather than
>> this combined structure.
>>
>>> +    const struct iio_info *info;
>> Again, can't see any reason to ever have this directly in here.
>>
> 
> All of the above are there so I can pass just an afe440x_data to the driver
> core and have it do the initilizing, which is identical for these devices
> outside of those structures. I could probably use a chip_info like you said
> though for this.
> 
>>> +    struct iio_trigger *trig;
>>> +    int irq;
>>> +};
>>> +
>>> +#endif /* _AFE440X_H */
>>>
>>
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-iio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
