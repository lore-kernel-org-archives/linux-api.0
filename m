From: Khalid Aziz <khalid.aziz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3] sched/fair: Add advisory flag for borrowing a timeslice
Date: Tue, 25 Nov 2014 10:22:36 -0700
Message-ID: <5474BADC.5030808@oracle.com>
References: <1416862595-24513-1-git-send-email-khalid.aziz@oracle.com> <5473E388.6000605@redhat.com> <547497A9.1080800@oracle.com> <54749F77.50905@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54749F77.50905-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, ak-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, raistlin-k2GhghHVRtY@public.gmane.org, kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, atomlin-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org, athorlton-sJ/iWh9BUns@public.gmane.org, oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, daeseok.youn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, yangds.fnst-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org, sbauer-F61uvSdQLzf2fBVCVOL8/A@public.gmane.org, vishnu.ps-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, axboe-b10kYP2dOMg@public.gmane.org, paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 11/25/2014 08:25 AM, Rik van Riel wrote:
> On 11/25/2014 09:52 AM, Khalid Aziz wrote:
>> On 11/24/2014 07:03 PM, Rik van Riel wrote:
>>> -----BEGIN PGP SIGNED MESSAGE-----
>>> Hash: SHA1
>>>
>>> On 11/24/2014 03:56 PM, Khalid Aziz wrote:
>>>> sched/fair: Add advisory flag for borrowing a timeslice
>>>>
>>>> This patch adds a way for a task to request to borrow one
>>>> timeslice from future if it is about to be preempted, so it could
>>>> delay preemption and complete any critical task it is in the middle
>>>> of.
>>>>
>>>> This feature helps with performance on databases and has been used
>>>> for many years on other OSs by the databases. This feature helps in
>>>> situation where a task acquires a lock before performing a critical
>>>> operation on the database and happens to get preempted
>>>
>>> Why don't the other tasks that want the lock sleep on the
>>> lock?
>>>
>>> I can see this "solution" help mostly with userspace spinlocks,
>>> which are relics of a past era that need to die. There is no
>>> way userspace spinlocks will not fail miserably on virtual
>>> machines, and it is time to get rid of them.
>>
>> This solution indeed is for userspace spinlocks. Database code has been
>> written with all critical locking implemented in userspace (as I have
>> been told by database folks. I am not a database guy).
>
> They should fix that.

Agreed, but that is a very large task for databases for sure and 
potentially for java as well (think exhaustive testing as well besides 
code re-write). I do not see this happening except as part of major 
re-architecture. In the mean time, if we can give them help without 
impacting kernel significantly for other users, it only makes Linux a 
more usable platform for them.

Thanks,
Khalid
