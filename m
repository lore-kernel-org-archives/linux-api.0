From: Lars-Peter Clausen <lars-Qo5EllUWu/uELgA04lAiVw@public.gmane.org>
Subject: Re: [RFC PATCH] iio: Export userspace IIO headers
Date: Tue, 10 Feb 2015 10:57:12 +0100
Message-ID: <54D9D5F8.9020700@metafoo.de>
References: <1423500586-26480-1-git-send-email-daniel.baluta@intel.com>	<54D8E8BD.3090904@metafoo.de> <CAEnQRZBWRmWcSe1izK7cEikwfG_oAEty05eCQXxWr71=8jbDEw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAEnQRZBWRmWcSe1izK7cEikwfG_oAEty05eCQXxWr71=8jbDEw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Daniel Baluta <daniel.baluta-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jonathan Cameron <jic23-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hartmut Knaack <knaack.h-Mmb7MZpHnFY@public.gmane.org>, Peter Meerwald <pmeerw-jW+XmwGofnusTnJN9+BGXg@public.gmane.org>, Irina Tirdea <irina.tirdea-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Roberta Dobrescu <roberta.dobrescu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-iio-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-iio-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 02/10/2015 09:05 AM, Daniel Baluta wrote:
> On Mon, Feb 9, 2015 at 7:05 PM, Lars-Peter Clausen <lars-Qo5EllUWu/uELgA04lAiVw@public.gmane.org> wrote:
>> On 02/09/2015 05:49 PM, Daniel Baluta wrote:
>>>
>>> After UAPI header file split [1] all user-kernel interfaces were
>>> placed under include/uapi/.
>>>
>>> This patch moves IIO user specific API from:
>>>          * include/linux/iio/events.h => include/uapi/linux/iio/events.h
>>>          * include/linux/iio/types.h => include/uapi/linux/iio/types.h
>>>
>>> Now there is no need for nasty tricks to compile userspace programs
>>> (e.g iio_event_monitor). Just installing the kernel headers with
>>> make headers_install command does the job.
>>>
>>> [1] http://lwn.net/Articles/507794/
>>
>>
>> Thanks for taking care of this, this is something that should have done a
>> while ago.
>
> Hi Lars,
>
> Thanks for the feedback!
>>
>> [...]
>>
>>> index 580ed5b..146cda1 100644
>
> <snip>
>
>>
>>
>> I think everything in this file below is not part of the ABI and should not
>> be exported to userspace.
>
> I agree about iio_event_info and IIO_VAL_* constants.
>
>>
>>> -
>>> -enum iio_event_info {
>>> -       IIO_EV_INFO_ENABLE,
>>> -       IIO_EV_INFO_VALUE,
>>> -       IIO_EV_INFO_HYSTERESIS,
>>> -       IIO_EV_INFO_PERIOD,
>>> -};
>>> -
>>> -enum iio_event_direction {
>>> -       IIO_EV_DIR_EITHER,
>>> -       IIO_EV_DIR_RISING,
>>> -       IIO_EV_DIR_FALLING,
>>> -       IIO_EV_DIR_NONE,
>>> -};
>
> iio_event_direction is exported to userspace via IIO_EVENT_CODE and
> I think it belongs to this file.

Right.

>
>>> -
>>> -#define IIO_VAL_INT 1
>>> -#define IIO_VAL_INT_PLUS_MICRO 2
>>> -#define IIO_VAL_INT_PLUS_NANO 3
>>> -#define IIO_VAL_INT_PLUS_MICRO_DB 4
>>> -#define IIO_VAL_INT_MULTIPLE 5
>>> -#define IIO_VAL_FRACTIONAL 10
>>> -#define IIO_VAL_FRACTIONAL_LOG2 11
>>> -
>
> I will send v2 in few hours, hopefully I'll get more feedback meanwhile.
>
> Do you thing should I remove the RFC tag?

Patch looks good to me.
