From: Octavian Purdila <octavian.purdila-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH 2/3] iio: allow better control for flushing the
 hardware fifo
Date: Mon, 4 May 2015 18:36:41 +0300
Message-ID: <CAE1zot+sRtJTqnZDqjQOezVk7vTd8y0XBZUA=C2-MYYs4P5qLg@mail.gmail.com>
References: <1430306340-5026-1-git-send-email-octavian.purdila@intel.com>
	<1430306340-5026-3-git-send-email-octavian.purdila@intel.com>
	<55450C9E.4060409@metafoo.de>
	<CAE1zotKDQjQS70tY0NS6536pjmKW8mbH_p+2aOv0kM0075hgkA@mail.gmail.com>
	<5547846F.50604@metafoo.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-iio-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5547846F.50604-Qo5EllUWu/uELgA04lAiVw@public.gmane.org>
Sender: linux-iio-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lars-Peter Clausen <lars-Qo5EllUWu/uELgA04lAiVw@public.gmane.org>
Cc: Jonathan Cameron <jic23-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hartmut Knaack <knaack.h-Mmb7MZpHnFY@public.gmane.org>, Peter Meerwald <pmeerw-jW+XmwGofnusTnJN9+BGXg@public.gmane.org>, "linux-iio-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-iio-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Adriana Reus <adriana.reus-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, May 4, 2015 at 5:38 PM, Lars-Peter Clausen <lars-Qo5EllUWu/uELgA04lAiVw@public.gmane.org> wrote:
> On 05/03/2015 08:11 AM, Octavian Purdila wrote:
>>
>> On Sat, May 2, 2015 at 8:42 PM, Lars-Peter Clausen <lars-Qo5EllUWu/uELgA04lAiVw@public.gmane.org>
>> wrote:
>>>
>>> On 04/29/2015 01:18 PM, Octavian Purdila wrote:
>>>>
>>>>
>>>> Some applications need to be able to flush [1] the hardware fifo of
>>>> the device and to receive events of when that happened [2] so that it
>>>> can ignore stale data.
>>>>
>>>> This patch adds a new event (IIO_EV_TYPE_HWFIFO_FLUSHED) that should
>>>> be sent to userspace when a flush has been completed. The application
>>>> will be able to identify which are the samples to ignore based on the
>>>> timestamp of the event.
>>>>
>>>> To allow applications to accurately generate a hardware fifo flush on
>>>> demand, this patch also adds a new sysfs entry that triggers a
>>>> hardware fifo flush when written to.
>>>>
>>>> [1]
>>>>
>>>> https://source.android.com/devices/sensors/hal-interface.html#flush_sensor
>>>> [2]
>>>>
>>>> https://source.android.com/devices/sensors/hal-interface.html#metadata_flush_complete_events
>>>
>>>
>>>
>>> Since there is no asynchronous queue for commands to be executed in IIO
>>> adding a asynchronous completion event doesn't make too much sense. This
>>> is
>>> something that needs to be handled at the HAL level.
>>>
>>> The HAL needs to have a queue of commands that need to be executed where
>>> new
>>> events can be added asynchronously, then has a loop which goes through
>>> the
>>> commands in the queue and executes them, and once executed generated the
>>> appropriate completion event.
>>>
>>
>> Hi Lars,
>>
>> Thanks for the review.
>>
>> We can't do this at the HAL level because the needed information is
>> only available at the HAL level. At the HAL level each received sample
>> from the driver is converted to an event. When doing a flush the HAL
>> must add a special event (flush complete) after the last sample in the
>> hardware fifo. But the HAL does not know how many samples are in the
>> hardware fifo, how many are in the device buffer, etc.
>
>
> Ok, so that's what you need the timestamp for I presume? So the signature of
> the of the sync function is basically.
>
> timestamp sync(device)
>
> where timestamp is greater or equal to the timestamp of all samples before
> the sync and smaller or equal to all samples after the sync.
>

Yes that is the idea, although the implementation is that we need to
insert an Android flush_complete event right before the event with the
timestamp strictly greater then the timestamp of the IIO fifo flushed
event.


> What your implementation does is implement a synchronous API to flush the
> FIFO but delivers the result of the operation asynchronously via a rather
> arbitrary delivery mechanism. That is in my opinion not a good API/ABI and
> might even have some race condition issues.
>
> If you do a flush, then read as much data as available you know that this
> data is from before the flush and any data read at a later point is after
> the flush.
>

We tried something similar (read in a loop until -EGAIN was received)
but run into issue where we needed to cycle a lot to get the -EAGAIN
at high sample frequencies and our guess was that read() is taking
more then the time to receive a new sample.

But if we modify the non-blocking case to flush the fifo even when the
available data is non-zero and we have requested more than what is
available I think we can avoid that issue. We'll try that and I'll get
back with more datapoints.

>>
>>>
>>> I really wish that document would specify what is actually meant by
>>> flush.
>>> Copy the FIFO content to a software buffer or discard the FIFO content.
>>>
>>
>> It does say: "... and flushes the FIFO; those events are delivered as
>> usual (i.e.: as if the maximum reporting latency had expired) ..."
>>
>
> Missed that, thanks.
>
>
>>>
>>>>
>>>> Signed-off-by: Octavian Purdila <octavian.purdila-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>>>> ---
>>>>    Documentation/ABI/testing/sysfs-bus-iio | 11 +++++++++++
>>>>    include/linux/iio/sysfs.h               |  3 +++
>>>>    include/uapi/linux/iio/types.h          |  1 +
>>>>    3 files changed, 15 insertions(+)
>>>>
>>>> diff --git a/Documentation/ABI/testing/sysfs-bus-iio
>>>> b/Documentation/ABI/testing/sysfs-bus-iio
>>>> index 866b4ec..bb4d8de 100644
>>>> --- a/Documentation/ABI/testing/sysfs-bus-iio
>>>> +++ b/Documentation/ABI/testing/sysfs-bus-iio
>>>> @@ -1375,3 +1375,14 @@ Description:
>>>>                  The emissivity ratio of the surface in the field of
>>>> view
>>>> of the
>>>>                  contactless temperature sensor.  Emissivity varies from
>>>> 0
>>>> to 1,
>>>>                  with 1 being the emissivity of a black body.
>>>> +
>>>> +What:          /sys/bus/iio/devices/iio:deviceX/buffer/hwfifo_flush
>>>> +KernelVersion: 4.2
>>>> +Contact:       linux-iio-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>>> +Description:
>>>> +               Write only entry that accepts a single strictly positive
>>>> integer
>>>> +               specifying the number of samples to flush from the
>>>> hardware fifo
>>>> +               to the device buffer. When the flush is completed an
>>>> +               IIO_EV_TYPE_HWFIFO_FLUSHED event is generated. The event
>>>> has the
>>>> +               timestamp equal with the timestamp of last sample that
>>>> was
>>>> +               flushed from the hardware fifo.
>>>
>>>
>>>
>>> I'd prefer this to be handled through the normal read() API rather than
>>> having a side channel for it. Big question is how though. We could
>>> specify
>>> that reading in O_NONBLOCK mode will always read data if it is available
>>> and
>>> not only if it is above the watermark threshold.
>>
>>
>> Do you mean to try and flush when the available data in the device
>> buffer is less then the requested size? That should work and hopefully
>> the ABI change does not matter since the hwfifo stuff has not been
>> released yet.
>
>
> Basically only let poll() and blocking read() block when not enough data is
> available. But for non-blocking read return as much data as possible if data
> is available.
>
>>
>> I prefer the explicit flush though. I think it is better to have the
>> ABIs clearly visible instead of being buried in the details.
>>
>
> Yea, it's a bit tricky. What should be used for this sysfs, IOCTL, read()...
>
> - Lars
