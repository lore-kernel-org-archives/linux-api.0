From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [SCHED_DEADLINE man pages 2/2] sched(7) SCHED_DEADLINE
Date: Tue, 13 May 2014 19:54:42 +0200
Message-ID: <53725C62.1060809@gmail.com>
References: <53723235.40101@gmail.com>	<537233A9.6040102@gmail.com> <20140513175210.49eed2e34ac06a3c109ce963@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140513175210.49eed2e34ac06a3c109ce963-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Juri Lelli <juri.lelli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Dario Faggioli <raistlin-k2GhghHVRtY@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hello Juri,

On 05/13/2014 05:52 PM, Juri Lelli wrote:
> Hello,
> 
> On Tue, 13 May 2014 17:00:57 +0200
> "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> 
>> Hello Peter et al.
>>
>> Here is the section of the sched(7) page that describes SCHED_DEADLINE,
>> as rendered text, with the (entire) raw page source attached. Please 
>> carefully review.
>>
>> Cheers,
>>
>> Michael

[...]

>>        The following diagram clarifies these terms:
>>
>>            arrival/wakeup                   absolute deadline
>>                 |    start time                   |
>>                 |        |                        |
>>                 v        v                        v
>>            -----x--------xooooooooooooooooo-------x--------x---
>>                          |<- comp. time ->|
>>                 |<------- relative deadline ----->|
>>                 |<-------------- period ------------------>|
>>
>>        When  setting  a  SCHED_DEADLINE  policy  for  a thread using
>>        sched_setattr(2), one can specify three parameters:  Runtime,
>>        Deadline,  and  Period.   These parameters do not necessarily
>>        correspond to the aforementioned terms: usual practice is  to
>>        set  Runtime to something bigger than the average computation
>>        time (or worst-case execution time for hard real-time tasks),
>>        Deadline  to  the relative deadline, and Period to the period
>>        of the task.  Thus, for SCHED_DEADLINE scheduling, we have:
>>
>>            arrival/wakeup                   absolute deadline
>>                 |    start time                   |
>>                 |        |                        |
>>                 v        v                        v
>>            -----x--------xooooooooooooooooo-------x--------x---
>>                          |<-- Runtime --->|
> 
>                            |<-- Runtime   --->|
> 
> I originally drew this slightly bigger than comp. time above because we
> usually don't want tasks to be throttled in the average case. It's just
> a rule of thumb.

Ahh -- yes, I see now that I messed this up when I tweaked the
ASCII art. Thanks for catching that. Fixed now.

>>                 |<----------- Deadline ---------->|
>>                 |<-------------- Period ------------------>|
>>
>>        The three deadline-scheduling parameters  correspond  to  the
>>        sched_runtime, sched_deadline, and sched_period fields of the
>>        sched_attr structure;  see  sched_setattr(2).   These  fields
>>        express  value  in nanoseconds.  If sched_period is specified
>>        as 0, then it is made the same as sched_deadline.
>>
>>        The kernel requires that:
>>
>>            sched_runtime <= sched_deadline <= sched_period
>>
>>        In addition, under the current  implementation,  all  of  the
>>        parameter  values  must be at least 1024 (i.e., just over one
>>        microsecond, which is the resolution of the  implementation).
> 
> And below 2^63, as per the last bug fix we discussed.

Fixed.

Cheers,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
