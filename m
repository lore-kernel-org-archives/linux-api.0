From: "Andrew F. Davis" <afd-l0cyMroinI0@public.gmane.org>
Subject: Re: [PATCH 0/2] iio: Heart Rate Monitors
Date: Mon, 2 Nov 2015 10:31:50 -0600
Message-ID: <56378FF6.7000703@ti.com>
References: <1446309089-21094-1-git-send-email-afd@ti.com>
 <56365B8A.3030908@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56365B8A.3030908-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jonathan Cameron <jic23-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Hartmut Knaack <knaack.h-Mmb7MZpHnFY@public.gmane.org>, Lars-Peter Clausen <lars-Qo5EllUWu/uELgA04lAiVw@public.gmane.org>, Peter Meerwald <pmeerw-jW+XmwGofnusTnJN9+BGXg@public.gmane.org>
Cc: devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-iio-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 11/01/2015 12:35 PM, Jonathan Cameron wrote:
> On 31/10/15 16:31, Andrew F. Davis wrote:
>> Hello all,
>>
>> This series adds the TI AFE4404 "Ultra-small, Integrated AFE for
>> Wearable, Optical Heart Rate Monitoring and Bio-Sensing".
>>
>> This work is based on previous work by Dan Murphy [0] who is working
>> on other tasks at the moment, so I will be helping to continue
>> upstreaming this driver. This is more of a re-write than a continuation
>> and there are many changes so I am submitting this as a v1.
>>
>> This device is very similar to the AFE4403 and I was originally planning
>> on pushing the two drivers together with common core functions in a
>> third file. The AFE4403 driver is still being tested so I merged common
>> code back into this driver, this is why this driver may seem a bit
>> unnecessarily modular. I will probably split this stuff back out when
>> I push the AFE4403.
>>
>> I also had some issues with sysfs naming for the channels; this device
>> has three input channels from three LED stages and two ambient
>> channels based on the LED stages. This might have been be a good place
>> for using IIO modifiers[1], but we also have two differential channels
>> based on the ambient channels, and channels cannot have both modifiers
>> and be differential (the modifier is stored in the differential channel's
>> ID field?).
> True enough. Didn't expect to run into this particular problem, but I guess
> someone will always make hardware breaking any assumptions we make from the
> software side of things.

Seems that way, it probably would work to have modified be more that a single
bit flag, maybe call it modifier and just store the modifier in there. Doesn't
look like it would be that hard right now to fix.

I'm not really sure I understand the need for modifiers at all really, seems
most are used by a single driver to get around just naming the channel.

>> So I used sysfs names that would be close to what they
>> would be if IIO supported these things.
> Fair enough as a starting point though we probably want to figure out how
> to do this 'right'.   Adding an extra field to the channel descriptor will
> be easy enough - it'll be event codes that are nasty to handle.
>
> Jonathan
>>
>> [0] http://www.spinics.net/lists/linux-iio/msg18413.html
>> [1] IIO_MOD_TEMP_AMBIENT could be renamed IIO_MOD_AMBIENT as it can
>> also apply to LIGHT, PRESSURE, HUMIDITY, etc..
> No problem with this change so please send a patch.
>>
>> Thanks,
>> Andrew
>>
>> Andrew F. Davis (2):
>>    Documentation: afe4404: Add DT bindings for the AFE4404 heart monitor
>>    iio: health: Add driver for the TI AFE4404 heart monitor
>>
>>   .../ABI/testing/sysfs-bus-iio-health-afe4404       |  70 +++
>>   .../devicetree/bindings/iio/health/afe4404.txt     |  27 ++
>>   drivers/iio/Kconfig                                |   1 +
>>   drivers/iio/Makefile                               |   1 +
>>   drivers/iio/health/Kconfig                         |  24 +
>>   drivers/iio/health/Makefile                        |   6 +
>>   drivers/iio/health/afe4404.c                       | 526 +++++++++++++++++++++
>>   drivers/iio/health/afe440x.h                       | 159 +++++++
>>   8 files changed, 814 insertions(+)
>>   create mode 100644 Documentation/ABI/testing/sysfs-bus-iio-health-afe4404
>>   create mode 100644 Documentation/devicetree/bindings/iio/health/afe4404.txt
>>   create mode 100644 drivers/iio/health/Kconfig
>>   create mode 100644 drivers/iio/health/Makefile
>>   create mode 100644 drivers/iio/health/afe4404.c
>>   create mode 100644 drivers/iio/health/afe440x.h
>>
>
