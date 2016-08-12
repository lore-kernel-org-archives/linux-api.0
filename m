From: Mathieu Poirier <mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] perf_event_open.2: 4.9 PERF_EVENT_IOC_SET_DRV_CONFIGS support
Date: Fri, 12 Aug 2016 12:02:51 -0600
Message-ID: <CANLsYkwvLQCBkn5yXne2vm+eqcErH=ABmK0yPu=g_F-+HkCiQg@mail.gmail.com>
References: <1470935365-2097-1-git-send-email-mathieu.poirier@linaro.org> <alpine.DEB.2.11.1608121351590.15187@pianoman.cluster.toy>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.11.1608121351590.15187-C8guHiyadNolD86y6aYYU+kYYgab/bYf@public.gmane.org>
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vince Weaver <vince-yfjdyHUqu3OsTnJN9+BGXg@public.gmane.org>
Cc: Michael Kerrisk-manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 12 August 2016 at 11:57, Vince Weaver <vince-yfjdyHUqu3OsTnJN9+BGXg@public.gmane.org> wrote:
> On Thu, 11 Aug 2016, Mathieu Poirier wrote:
>> +.TP
>> +.BR PERF_EVENT_IOC_SET_DRV_CONFIGS " (since Linux 4.9)"
>> +This makes it possible to pass configuration parameters to PMU drivers.
>> +Configuration parameters are specific to each drivers.
>> +
>> +The argument is a pointer to the desired configuration parameters.
>
> So I gave up and read the code and I'm guessing this is what you really
> mean:
>
> .TP
> .BR PERF_EVENT_IOC_SET_DRV_CONFIGS " (since Linux 4.9)"
> Pass custom configuration paramaters to a PMU driver.
>
> The argument is a pointer to a NUL-termiated string of up to
> PAGE_SIZE in length.
> The string contains a list of comma-separated configuration options
> that will be parsed by the kernel.
> The kernel handles both singleton values as well as name/value pairs
> that are indicated with the '=' character.
> The size of the strings is limited internally to PERF_DRV_CONFIG_MAX
> (which is not visible to userspace).
>

Yes this is a very good description but in sharp contrast with what is
currently done for the ioctl() descriptors in this page.  I shied away
from writing that much based on how slim the current descriptions
were.

>
>
> some additional questions: can this ioctl be run at any time or should it
> only be run while the event is quiet?  Does the change in options take
> place immediately?

That is up to PMU drivers to decide - for CoreSight it is set only
once when trace sessions are created.  Any changes from thereon will
be ignored.

Thanks for the review.
Mathieu

>
> Vince
--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
