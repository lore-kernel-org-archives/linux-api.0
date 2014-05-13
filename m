From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [SCHED_DEADLINE man pages 0/2] Summary
Date: Tue, 13 May 2014 20:00:36 +0200
Message-ID: <53725DC4.3090802@gmail.com>
References: <53723235.40101@gmail.com> <20140513175416.765abe5b536257ab72d827bc@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140513175416.765abe5b536257ab72d827bc-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Juri Lelli <juri.lelli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Dario Faggioli <raistlin-k2GhghHVRtY@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 05/13/2014 05:54 PM, Juri Lelli wrote:
> Hi,
> 
> On Tue, 13 May 2014 16:54:45 +0200
> "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> 
>> Peter, at al.
>>
>> The follow ups to this mail contain the changes to man-pages for
>> the new sched_setattr() and sched_getattr() system calls, as well
>> as the changes to the sched(7) man page to document the 
>> SCHED_DEADLINE policy, all new changes in kernel 3.14.
>>
>> I used the text you submitted, but _heavily_ edited it, and added
>> a _lot_ of further details. Therefore, could you (and Juri, and 
>> Dario?) please carefully review the text.
>>
>> The follow-up mails are:
>>
>> [1/2] The sched_setattr.2 page that documents sched_setattr(2) 
>>       and sched_getattr(2).
>>
>> [2/2] The revisions to the sched(7) page.
>>
> 
> Apart from nitpicks in 2/2, this looks great to me.
> 
> Thanks a lot!

Thanks for checking the pages, Juri.

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
