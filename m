From: Davidlohr Bueso <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>
Subject: Re: [PATCH v3] sched/fair: Add advisory flag for borrowing a
 timeslice (was: Pre-emption control for userspace)
Date: Mon, 24 Nov 2014 18:12:39 -0800
Message-ID: <1416881559.20575.14.camel@linux-t7sj.site>
References: <1416862595-24513-1-git-send-email-khalid.aziz@oracle.com>
	 <alpine.DEB.2.11.1411242317380.6439@nanos>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.11.1411242317380.6439@nanos>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: Khalid Aziz <khalid.aziz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, corbet-T1hC0tSOHrs@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, ak-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, liwanp-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, raistlin-k2GhghHVRtY@public.gmane.org, kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, atomlin-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org, athorlton-sJ/iWh9BUns@public.gmane.org, oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, daeseok.youn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, yangds.fnst-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org, sbauer-F61uvSdQLzf2fBVCVOL8/A@public.gmane.org, vishnu.ps-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, axboe-b10kYP2dOMg@public.gmane.org, paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, 2014-11-25 at 00:35 +0100, Thomas Gleixner wrote:
> On Mon, 24 Nov 2014, Khalid Aziz wrote:
> > sched/fair: Add advisory flag for borrowing a timeslice
> > 
> > This patch adds a way for a task to request to borrow one timeslice
> > from future if it is about to be preempted, so it could delay
> > preemption and complete any critical task it is in the middle of.
> > 
> > This feature helps with performance on databases and has been
> > used for many years on other OSs by the databases. This feature
> > helps in situation where a task acquires a lock before performing a
> > critical operation on the database and happens to get preempted before
> > it completes its task.  This lock being held causes all other tasks
> > that also acquire the same lock to perform their critical operation
> > on the database, to start queueing up and causing large number of
> > context switches.  This queueing problem can be avoided if the task
> > that acquires lock first could request scheduler to let it borrow one
> > timeslice once it enters its critical section and hence allow it to
> > complete its critical section without causing queueing problem. If
> 
> While you are niftily avoiding to talk about the nature of the lock, I
> can take it for granted that you are talking about user space
> spinlocks, right?

Probably, or perhaps userspace fair locks. If the task that is next in
line to acquire the lock is preempted and the lock is released, fairness
prevents anyone else from taking it instead.

Thanks,
Davidlohr
