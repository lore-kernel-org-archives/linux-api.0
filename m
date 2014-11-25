From: Khalid Aziz <khalid.aziz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3] sched/fair: Add advisory flag for borrowing a timeslice
Date: Tue, 25 Nov 2014 07:50:13 -0700
Message-ID: <54749725.3050307@oracle.com>
References: <1416862595-24513-1-git-send-email-khalid.aziz@oracle.com>	 <alpine.DEB.2.11.1411242317380.6439@nanos> <1416889208.4335.127.camel@maggy.simpson.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1416889208.4335.127.camel-sZ+7a5bGyC/1wTEvPJ5Q0F6hYfS7NtTn@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Galbraith <umgwanakikbuti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: corbet-T1hC0tSOHrs@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, ak-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, liwanp-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, raistlin-k2GhghHVRtY@public.gmane.org, kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, atomlin-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org, athorlton-sJ/iWh9BUns@public.gmane.org, oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, daeseok.youn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, yangds.fnst-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org, sbauer-F61uvSdQLzf2fBVCVOL8/A@public.gmane.org, vishnu.ps-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, axboe-b10kYP2dOMg@public.gmane.org, paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 11/24/2014 09:20 PM, Mike Galbraith wrote:
> On Tue, 2014-11-25 at 00:35 +0100, Thomas Gleixner wrote:
>
>> Aside of the general issues I have with this (see the inline replies
>> to your changelog) the overall impression of this patch is that it is
>> a half baken and carelessly cobbled together extract of some data base
>> specific kernel hackery, which I prefer not to see at all.
>
> It culminates in a lumbering pseudo RT class of task disguised as a fair
> class task.  I'd expect more gain by twiddling knobs to let last buddy
> do its job than the 3% mentioned.
>
> You could perhaps create a SUPER_BATCH class that is not wakeup
> preempted by any fair class task of <= priority, not only BATCH and
> IDLE, but that's as nasty as this patch, though loads prettier.  The
> tick time thing doesn't feel right at all... if you're hurt badly by the
> tick, you're likely holding the lock too long methinks.
>
> 	-Mike
>
>

It is definitely not an attempt to solve any kind of RT problem. It 
would be a poor attempt if it indeed attempted to solve an RT problem. 
RT is all about guarantees. This patch does not help there at all and 
hence I have no intention of ever applying anything like this to 
SCHED_FIFO or SCHED_RR.

This problem is not caused by task holding the lock too long. It is 
caused by the task happening to acquire the lock just before its current 
timeslice is up. In that case, it does not matter how long the task 
holds the lock for.

--
Khalid
