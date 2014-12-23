From: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH RESEND v4] sched/fair: Add advisory flag for borrowing a
 timeslice
Date: Tue, 23 Dec 2014 11:52:51 +0100
Message-ID: <20141223105251.GB22203@gmail.com>
References: <1418928259-6311-1-git-send-email-khalid.aziz@oracle.com>
 <20141218222846.GH30905@twins.programming.kicks-ass.net>
 <54935842.5020507@oracle.com>
 <alpine.DEB.2.11.1412182355020.17382@nanos>
 <54936562.5070502@oracle.com>
 <alpine.DEB.2.11.1412190045590.17382@nanos>
 <54949BF0.8030403@oracle.com>
 <alpine.DEB.2.11.1412200041220.17382@nanos>
 <5498498B.90703@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5498498B.90703-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Khalid Aziz <khalid.aziz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, corbet-T1hC0tSOHrs@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, ak-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, raistlin-k2GhghHVRtY@public.gmane.org, kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, atomlin-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org, athorlton-sJ/iWh9BUns@public.gmane.org, oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, daeseok.youn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, yangds.fnst-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org, sbauer-F61uvSdQLzf2fBVCVOL8/A@public.gmane.org, vishnu.ps-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, axboe-b10kYP2dOMg@public.gmane.org, paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org


* Khalid Aziz <khalid.aziz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:

> On 12/19/2014 04:57 PM, Thomas Gleixner wrote:
> >On Fri, 19 Dec 2014, Khalid Aziz wrote:
> >>The queuing problem caused by a task taking a contended lock just before its
> >>current timeslice is up which userspace app wouldn't know about, is a real
> >>problem nevertheless.
> >
> >We know that already.
> >
> >>My patch attempts to avoid the contention in the first
> >>place. futex with adaptive spinning is a post-contention solution that tries
> >>to minimize the cost of contention but does nothing to avoid the contention.
> >
> >I never said that adaptive spinning can solve that problem.
> >
> >If you would have carefuly read what I wrote, you might have noticed,
> >that I said:
> >
> >      a proper futex like spin mechanism
> >
> >Can you spot the subtle difference between that phrase and 'futex with
> >adaptive spinning'?
> >
> >>Solving this problem using futex can help only if the userspace lock uses
> >>futex.
> >
> >A really fundamentally new and earth shattering insight.
> >
> >If you would spend your time to actually digest what maintainers are
> >telling you, we might make progress on that matter.
> >
> >But you prefer to spend your time by repeating yourself and providing
> >completely useless information.
> >
> >What you are missing completely here is that neither me nor other
> >maintainers involved care about how you spend your time. But we very
> >much care about the time WE waste with your behaviour.
> 
> I am sorry that you feel the need to continue to resort to 
> personal attacks [...]

Thomas did not attack your person AFAICS - he criticised your 
arguments with increasing volume, because he did not see you 
respond to his arguments in substance.

> even after I made it clear in my last response that I was not 
> going to pursue this patch. There is no possibility of a 
> productive discussion of a solution at this point. [...]

I think there is very much a possibility of a productive 
discussion:

> [...] I hope someone else can find a solution you find 
> acceptable.

to implement what Thomas suggested in the discussion: a proper 
futex like spin mechanism? That looks like a totally acceptable 
solution to me, without the disadvantages of your proposed 
solution.

Thanks,

	Ingo
