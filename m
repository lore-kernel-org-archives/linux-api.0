From: Mathieu Poirier <mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] perf_event_open.2: 4.9 PERF_EVENT_IOC_SET_DRV_CONFIGS support
Date: Fri, 12 Aug 2016 14:47:54 -0600
Message-ID: <CANLsYkxmQ+f2AURD+GtP5AvTHh=F1zgRwgtRm7t6L6-Ptda2+A@mail.gmail.com>
References: <1470935365-2097-1-git-send-email-mathieu.poirier@linaro.org>
 <alpine.DEB.2.11.1608121248100.10883@pianoman.cluster.toy>
 <CANLsYkyKJJ-qHjyzpus6=Cx7OjN5gigBFdd2-cc7e-ezosJTjQ@mail.gmail.com> <alpine.DEB.2.11.1608121620200.25142@pianoman.cluster.toy>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.11.1608121620200.25142-C8guHiyadNolD86y6aYYU+kYYgab/bYf@public.gmane.org>
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vince Weaver <vince-yfjdyHUqu3OsTnJN9+BGXg@public.gmane.org>
Cc: Michael Kerrisk-manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 12 August 2016 at 14:31, Vince Weaver <vince-yfjdyHUqu3OsTnJN9+BGXg@public.gmane.org> wrote:
> On Fri, 12 Aug 2016, Mathieu Poirier wrote:
>>
>> I am adding an interface to pass PMU specific configuration to the
>> driver.  Since PMU drivers exist for different architecture and
>> drivers I am making the mechanism as generic as possible.
>
> It's a shame we are ending up with two "string configuration" ioctls.
> PERF_EVENT_IOC_SET_FILTER and this new one.  Though I guess
> PERF_EVENT_IOC_SET_FILTER is not really set up to be used generically.
>
>> "@cfg" and "@cfg=option".  The lexer will strip off the '@' and pass
>> "cfg" and "cfg=option" to the kernel.
>>
>> What gets sent down to the kernel is driver specific - it is up to the
>> PMU drivers to parse and validate what's given to them.
>
> But the core kernel is parsing "=" and "," in this case, so it's not
> entirely up to the PMU driver, right?

Upon Peter's request the core will does some initial parsing but the
PMU drivers are responsible to parse the "cfg" and "option" parts in
order to validate their content.

>
> Is there going to be a list of allowed keywords somewhere, under /sys
> or similar?

SysFS is very constraining - I think it would be much better in the
PMU's documentation under Documentation/.  I have a patch ready for
that.

>
>>> .TP
>>> .BR PERF_EVENT_IOC_SET_DRV_CONFIGS " (since Linux 4.9)"
>>> Pass custom configuration paramaters to a PMU driver.
>>>
>>> The argument is a pointer to a NUL-termiated string of up to
>>> PAGE_SIZE in length.
>>> The string contains a list of comma-separated configuration options
>>> that will be parsed by the kernel.
>>> The kernel handles both singleton values as well as name/value pairs
>>> that are indicated with the '=' character.
>>> The size of the strings is limited internally to PERF_DRV_CONFIG_MAX
>>> (which is not visible to userspace).
>>>
>
>> Yes this is a very good description but in sharp contrast with what is
>> currently done for the ioctl() descriptors in this page.  I shied away
>> from writing that much based on how slim the current descriptions were.
>
> Well that's because this interface is a lot more complex than some of the
> other ioctls which just take a simple integer (or no argument at all).
>
> The ftrace ioctl description could definitely use some expansion.

I agree.

>
>> > some additional questions: can this ioctl be run at any time or should
>> > only be run while the event is quiet?  Does the change in options take
>> > place immediately?
>
>> That is up to PMU drivers to decide - for CoreSight it is set only
>> once when trace sessions are created.  Any changes from thereon will
>> be ignored.
>
> Then shouldn't this be set at perf_event_open() and not by an ioctl()?

Using an ioctl() seemed to be the best approach since all the
infrastructure is already there.  Also different drivers may need to
see configuration options updated - it is simply not the case for
CoreSight.

By the way, my next patchset will make PERF_DRV_CONFIG_MAX visible to
user space.

Thanks,
Mathieu

>
> Vince
--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
