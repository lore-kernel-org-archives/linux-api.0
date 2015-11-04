From: Jonathan Cameron <jic23-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 0/2] iio: Heart Rate Monitors
Date: Wed, 4 Nov 2015 18:57:31 +0000
Message-ID: <563A551B.2010808@kernel.org>
References: <1446309089-21094-1-git-send-email-afd@ti.com>
 <56365B8A.3030908@kernel.org> <56378FF6.7000703@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56378FF6.7000703-l0cyMroinI0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Andrew F. Davis" <afd-l0cyMroinI0@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Hartmut Knaack <knaack.h-Mmb7MZpHnFY@public.gmane.org>, Lars-Peter Clausen <lars-Qo5EllUWu/uELgA04lAiVw@public.gmane.org>, Peter Meerwald <pmeerw-jW+XmwGofnusTnJN9+BGXg@public.gmane.org>
Cc: devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-iio-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 02/11/15 16:31, Andrew F. Davis wrote:
> On 11/01/2015 12:35 PM, Jonathan Cameron wrote:
>> On 31/10/15 16:31, Andrew F. Davis wrote:
>>> Hello all,
>>>
>>> This series adds the TI AFE4404 "Ultra-small, Integrated AFE for
>>> Wearable, Optical Heart Rate Monitoring and Bio-Sensing".
>>>
>>> This work is based on previous work by Dan Murphy [0] who is working
>>> on other tasks at the moment, so I will be helping to continue
>>> upstreaming this driver. This is more of a re-write than a continuation
>>> and there are many changes so I am submitting this as a v1.
>>>
>>> This device is very similar to the AFE4403 and I was originally planning
>>> on pushing the two drivers together with common core functions in a
>>> third file. The AFE4403 driver is still being tested so I merged common
>>> code back into this driver, this is why this driver may seem a bit
>>> unnecessarily modular. I will probably split this stuff back out when
>>> I push the AFE4403.
>>>
>>> I also had some issues with sysfs naming for the channels; this device
>>> has three input channels from three LED stages and two ambient
>>> channels based on the LED stages. This might have been be a good place
>>> for using IIO modifiers[1], but we also have two differential channels
>>> based on the ambient channels, and channels cannot have both modifiers
>>> and be differential (the modifier is stored in the differential channel's
>>> ID field?).
>> True enough. Didn't expect to run into this particular problem, but I guess
>> someone will always make hardware breaking any assumptions we make from the
>> software side of things.
> 
> Seems that way, it probably would work to have modified be more that a single
> bit flag, maybe call it modifier and just store the modifier in there. Doesn't
> look like it would be that hard right now to fix.
As I stated below the issue is then to figure out how to get it into the event
codes without breaking backwards compatibility.  It could probably be done but would
involve something hideous like a bit for this event is on a channel that is both
differential and modified.  Then we need to potentially sneak into the code
2 modifiers, 2 indexes and a bit saying to use them all.  

This is rapidly getting to some very long naming to avoid simply saying what
the channel is in reality which is a measure of light transmission.  I'm kind
of thinking that information is more useful to userspace than ending up with
something along the lines of

in_intensity0_lit-intensity0_ambient_raw

it's worth noting for the discussion below that if you didn't have modifiers
you'd need to index those two channels separately as the event codes that
might be generated can't have strings burried in them.  So you'd have
the even more cyptic.

in_intensity0_lit-in_intensity1_ambient_raw
(or if you dropped the extra string from these attributes simply
in_intensity0-intensity1_raw
vs
in_intensitytransmitted0_raw
>  
> I'm not really sure I understand the need for modifiers at all really, seems
> most are used by a single driver to get around just naming the channel.
In a sense they do serve that purpose, but their primary purpose is to provide
a short hand lookup for common elements that 'identify' a channel.
These get used in a couple of places in particular:
1) Event codes - now we could have insisted that any process using events holds
sufficient state to allow it to identify the channel purely based on type and index
but instead decided that the vast majority of cases where there is a reason to
map to a unique identifier are straight forward (e.g. an axis for multi axis
sensors).  If anyone needs to still do a more detailed lookup to identify the source
of an event they still can (effectively nothing is lost)

2) In kernel mappings - consumers of IIO channels could in theory do a name look
up if it was all string based, but then all we've done is pushed the problem on
one step and have to maintain copies of the magic string mapping that says 
'This is an x axis'.

Hwmon basically only ever uses string based naming (as it just has sysfs attributes
instantiated by every driver from scratch).  It works for that case, but has caused
a lot of grief when people try for example to base a thermal driver on top
of hwmon. Obviously this doesn't precisely map given the nature of hwmon channels
is typically simpler and they are almost always accompanied by a userspace mapping
in lm-sensors that identifies what they are wired to on a particular board.

Input goes right the otherway and more or less provides no naming based stuff at all
instead mapping to a set of big enums to identify things.

So we could have done it all with strings but at the time it seems more
straight forward to map onto a known subset using a simple look up.
Perhaps we should have done this differently, but such is life!

One thing it has really gained me from a maintainer point of view is 
avoiding small missnaming issues by effectively enforcing the ABI.  Any break
from the ABI is really obvious and needs a detailed justification!

I am kind of wondering if channels should all come with a help description
via sysfs attribute to allow more user readable data to be encoded in the 
driver.  The issue with doing this would be maintaining it fixed for ever
as any such help descriptions become ABI the moment they are exposed to userspace.

What fun,

Jonathan


> 
>>> So I used sysfs names that would be close to what they
>>> would be if IIO supported these things.
>> Fair enough as a starting point though we probably want to figure out how
>> to do this 'right'.   Adding an extra field to the channel descriptor will
>> be easy enough - it'll be event codes that are nasty to handle.
>>
>> Jonathan
>>>
>>> [0] http://www.spinics.net/lists/linux-iio/msg18413.html
>>> [1] IIO_MOD_TEMP_AMBIENT could be renamed IIO_MOD_AMBIENT as it can
>>> also apply to LIGHT, PRESSURE, HUMIDITY, etc..
>> No problem with this change so please send a patch.
>>>
>>> Thanks,
>>> Andrew
>>>
>>> Andrew F. Davis (2):
>>>    Documentation: afe4404: Add DT bindings for the AFE4404 heart monitor
>>>    iio: health: Add driver for the TI AFE4404 heart monitor
>>>
>>>   .../ABI/testing/sysfs-bus-iio-health-afe4404       |  70 +++
>>>   .../devicetree/bindings/iio/health/afe4404.txt     |  27 ++
>>>   drivers/iio/Kconfig                                |   1 +
>>>   drivers/iio/Makefile                               |   1 +
>>>   drivers/iio/health/Kconfig                         |  24 +
>>>   drivers/iio/health/Makefile                        |   6 +
>>>   drivers/iio/health/afe4404.c                       | 526 +++++++++++++++++++++
>>>   drivers/iio/health/afe440x.h                       | 159 +++++++
>>>   8 files changed, 814 insertions(+)
>>>   create mode 100644 Documentation/ABI/testing/sysfs-bus-iio-health-afe4404
>>>   create mode 100644 Documentation/devicetree/bindings/iio/health/afe4404.txt
>>>   create mode 100644 drivers/iio/health/Kconfig
>>>   create mode 100644 drivers/iio/health/Makefile
>>>   create mode 100644 drivers/iio/health/afe4404.c
>>>   create mode 100644 drivers/iio/health/afe440x.h
>>>
>>
