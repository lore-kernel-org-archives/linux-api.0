From: Octavian Purdila <octavian.purdila-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH 2/3] iio: allow better control for flushing the
 hardware fifo
Date: Sun, 3 May 2015 09:11:49 +0300
Message-ID: <CAE1zotKDQjQS70tY0NS6536pjmKW8mbH_p+2aOv0kM0075hgkA@mail.gmail.com>
References: <1430306340-5026-1-git-send-email-octavian.purdila@intel.com>
	<1430306340-5026-3-git-send-email-octavian.purdila@intel.com>
	<55450C9E.4060409@metafoo.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55450C9E.4060409-Qo5EllUWu/uELgA04lAiVw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lars-Peter Clausen <lars-Qo5EllUWu/uELgA04lAiVw@public.gmane.org>
Cc: Jonathan Cameron <jic23-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hartmut Knaack <knaack.h-Mmb7MZpHnFY@public.gmane.org>, Peter Meerwald <pmeerw-jW+XmwGofnusTnJN9+BGXg@public.gmane.org>, "linux-iio-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-iio-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Adriana Reus <adriana.reus-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Sat, May 2, 2015 at 8:42 PM, Lars-Peter Clausen <lars-Qo5EllUWu/uELgA04lAiVw@public.gmane.org> wrote:
> On 04/29/2015 01:18 PM, Octavian Purdila wrote:
>>
>> Some applications need to be able to flush [1] the hardware fifo of
>> the device and to receive events of when that happened [2] so that it
>> can ignore stale data.
>>
>> This patch adds a new event (IIO_EV_TYPE_HWFIFO_FLUSHED) that should
>> be sent to userspace when a flush has been completed. The application
>> will be able to identify which are the samples to ignore based on the
>> timestamp of the event.
>>
>> To allow applications to accurately generate a hardware fifo flush on
>> demand, this patch also adds a new sysfs entry that triggers a
>> hardware fifo flush when written to.
>>
>> [1]
>> https://source.android.com/devices/sensors/hal-interface.html#flush_sensor
>> [2]
>> https://source.android.com/devices/sensors/hal-interface.html#metadata_flush_complete_events
>
>
> Since there is no asynchronous queue for commands to be executed in IIO
> adding a asynchronous completion event doesn't make too much sense. This is
> something that needs to be handled at the HAL level.
>
> The HAL needs to have a queue of commands that need to be executed where new
> events can be added asynchronously, then has a loop which goes through the
> commands in the queue and executes them, and once executed generated the
> appropriate completion event.
>

Hi Lars,

Thanks for the review.

We can't do this at the HAL level because the needed information is
only available at the HAL level. At the HAL level each received sample
from the driver is converted to an event. When doing a flush the HAL
must add a special event (flush complete) after the last sample in the
hardware fifo. But the HAL does not know how many samples are in the
hardware fifo, how many are in the device buffer, etc.

>
> I really wish that document would specify what is actually meant by flush.
> Copy the FIFO content to a software buffer or discard the FIFO content.
>

It does say: "... and flushes the FIFO; those events are delivered as
usual (i.e.: as if the maximum reporting latency had expired) ..."

>
>>
>> Signed-off-by: Octavian Purdila <octavian.purdila-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>> ---
>>   Documentation/ABI/testing/sysfs-bus-iio | 11 +++++++++++
>>   include/linux/iio/sysfs.h               |  3 +++
>>   include/uapi/linux/iio/types.h          |  1 +
>>   3 files changed, 15 insertions(+)
>>
>> diff --git a/Documentation/ABI/testing/sysfs-bus-iio
>> b/Documentation/ABI/testing/sysfs-bus-iio
>> index 866b4ec..bb4d8de 100644
>> --- a/Documentation/ABI/testing/sysfs-bus-iio
>> +++ b/Documentation/ABI/testing/sysfs-bus-iio
>> @@ -1375,3 +1375,14 @@ Description:
>>                 The emissivity ratio of the surface in the field of view
>> of the
>>                 contactless temperature sensor.  Emissivity varies from 0
>> to 1,
>>                 with 1 being the emissivity of a black body.
>> +
>> +What:          /sys/bus/iio/devices/iio:deviceX/buffer/hwfifo_flush
>> +KernelVersion: 4.2
>> +Contact:       linux-iio-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> +Description:
>> +               Write only entry that accepts a single strictly positive
>> integer
>> +               specifying the number of samples to flush from the
>> hardware fifo
>> +               to the device buffer. When the flush is completed an
>> +               IIO_EV_TYPE_HWFIFO_FLUSHED event is generated. The event
>> has the
>> +               timestamp equal with the timestamp of last sample that was
>> +               flushed from the hardware fifo.
>
>
> I'd prefer this to be handled through the normal read() API rather than
> having a side channel for it. Big question is how though. We could specify
> that reading in O_NONBLOCK mode will always read data if it is available and
> not only if it is above the watermark threshold.

Do you mean to try and flush when the available data in the device
buffer is less then the requested size? That should work and hopefully
the ABI change does not matter since the hwfifo stuff has not been
released yet.

I prefer the explicit flush though. I think it is better to have the
ABIs clearly visible instead of being buried in the details.
