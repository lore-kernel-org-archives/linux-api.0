From: Khalid Aziz <khalid.aziz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3] sched/fair: Add advisory flag for borrowing a timeslice
Date: Tue, 25 Nov 2014 12:38:23 -0700
Message-ID: <5474DAAF.2050300@oracle.com>
References: <1416862595-24513-1-git-send-email-khalid.aziz@oracle.com>	 <alpine.DEB.2.11.1411242317380.6439@nanos>	 <1416889208.4335.127.camel@maggy.simpson.net> <54749725.3050307@oracle.com> <1416937564.3512.15.camel@maggy.simpson.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1416937564.3512.15.camel-sZ+7a5bGyC/1wTEvPJ5Q0F6hYfS7NtTn@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Galbraith <umgwanakikbuti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, corbet-T1hC0tSOHrs@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, ak-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, liwanp-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, raistlin-k2GhghHVRtY@public.gmane.org, kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, atomlin-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org, athorlton-sJ/iWh9BUns@public.gmane.org, oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, daeseok.youn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, yangds.fnst-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org, sbauer-F61uvSdQLzf2fBVCVOL8/A@public.gmane.org, vishnu.ps-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, axboe-b10kYP2dOMg@public.gmane.org, paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 11/25/2014 10:46 AM, Mike Galbraith wrote:
> On Tue, 2014-11-25 at 07:50 -0700, Khalid Aziz wrote:
>
>> It is definitely not an attempt to solve any kind of RT problem.
>
> No no, I'm saying that giving certain tasks special dispensations
> effectively elevates them.  Temporarily or otherwise, they play by
> different rules, will block more deserving tasks, and it's not cut and
> dried that that blocking will not do more harm than good.
>
> Is it a clear win to make say some kworker or other global asset wait
> when it could have preempted and been gone in usecs?  Nope.

I understand. You are right, this allows some apps to gain special 
dispensation. On a general purpose system, I agree this can be 
problematic and it is important that it be easy to disable this. This is 
why I added sysctl tunable and made "disabled" the default state for 
this feature. Allowing temporary elevation of a task as part of the 
overall system design is ok when it is intentional and done after 
considering impact on other tasks running on the system. A large 
database server typically is not a general purpose server that runs any 
arbitrary tasks. These systems are tweaked in many ways to ensure 
optimal performance for database and not necessarily other apps. This 
patch gives admins one more knob to turn when maximizing performance. 
Any general purpose system that sees no use for this feature can leave 
this feature in its default state of disabled. I can see usefulness of 
this patch for other servers used in telecommunication infrastructure 
for instance, where the server is dedicated to specific task(s) and 
needs to update critical database with minimal contention, for example 
switch map on a telco switch controller or channel allocation map on a 
base station controller. I am sure people more familiar with other 
industries can see usefulness in other dedicated applications.

Thanks,
Khalid
