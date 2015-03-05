From: Jason Baron <jbaron@akamai.com>
Subject: Re: [PATCH v3 0/3] epoll: introduce round robin wakeup mode
Date: Wed, 04 Mar 2015 22:53:39 -0500
Message-ID: <54F7D343.5090106@akamai.com>
References: <cover.1424805740.git.jbaron@akamai.com> <20150225073814.GA14558@gmail.com> <54EDF7D8.60201@akamai.com> <20150227131034.2f2787dcabf285191a1f6ffa@linux-foundation.org> <54F0E93C.3010306@akamai.com> <20150227143158.afa4ec39d49d5815cbbd6a6c@linux-foundation.org> <20150305000225.GA27592@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150305000225.GA27592@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: peterz@infradead.org, mingo@redhat.com, viro@zeniv.linux.org.uk, normalperson@yhbt.net, davidel@xmailserver.org, mtk.manpages@gmail.com, luto@amacapital.net, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, Alexander Viro <viro@ftp.linux.org.uk>
List-Id: linux-api@vger.kernel.org

On 03/04/2015 07:02 PM, Ingo Molnar wrote:
> * Andrew Morton <akpm@linux-foundation.org> wrote:
>
>> On Fri, 27 Feb 2015 17:01:32 -0500 Jason Baron <jbaron@akamai.com> wrote:
>>
>>>> I don't really understand the need for rotation/round-robin.  We can
>>>> solve the thundering herd via exclusive wakeups, but what is the point
>>>> in choosing to wake the task which has been sleeping for the longest
>>>> time?  Why is that better than waking the task which has been sleeping
>>>> for the *least* time?  That's probably faster as that task's data is
>>>> more likely to still be in cache.
>>>>
>>>> The changelogs talks about "starvation" but they don't really say what
>>>> this term means in this context, nor why it is a bad thing.
>>>>
>> I'm still not getting it.
>>
>>> So the idea with the 'rotation' is to try and distribute the
>>> workload more evenly across the worker threads.
>> Why?
>>
>>> We currently
>>> tend to wake up the 'head' of the queue over and over and
>>> thus the workload for us is not evenly distributed.
>> What's wrong with that?
>>
>>> In fact, we
>>> have a workload where we have to remove all the epoll sets
>>> and then re-add them in a different order to improve the situation.
>> Why?
> So my guess would be (but Jason would know this more precisely) that 
> spreading the workload to more tasks in a FIFO manner, the individual 
> tasks can move between CPUs better, and fill in available CPU 
> bandwidth better, increasing concurrency.
>
> With the current LIFO distribution of wakeups, the 'busiest' threads 
> will get many wakeups (potentially from different CPUs), making them 
> cache-hot, which may interfere with them easily migrating across CPUs.
>
> So while technically both approaches have similar concurrency, the 
> more 'spread out' task hierarchy schedules in a more consistent 
> manner.
>
> But ... this is just a wild guess and even if my description is 
> accurate then it should still be backed by robust measurements and 
> observations, before we extend the ABI.
>
> This hypothesis could be tested by the patch below: with the patch 
> applied if the performance difference between FIFO and LIFO epoll 
> wakeups disappears, then the root cause is the cache-hotness code in 
> the scheduler.
>
>

So what I think you are describing here fits the model
where you have single epoll fd (returned by epoll_create()),
which is then attached to wakeup fds. So that can be thought
of as having a single 'event' queue (the single epoll fd), where
multiple threads are competing to grab events via epoll_wait()
and things are currently LIFO there as you describe.

However, the use-case I was trying to get at is where you have
multiple epoll fds (or event queues), and really just one thread
doing epoll_wait() against a single epoll fd. So instead of having
all threads competing for all events, we have divided up the
events into separate queues.

Now, the 'problematic' case is where there may be an event
source that is shared among all these epoll fds - such as a listen
socket or a pipe. Now there are two distinct issues in this case
that this series is trying to address.

1) All epoll fds will receive a wakeup (and hence the threads
that are potentially blocking there, although they may not
return to user-space if the event has already been consumed).
I think the test case I posted shows this pretty clearly -
http://lwn.net/Articles/632590/. The number of context switches
without adding the to the wait queue is 50x the case where
they are added exclusively. That's a lot of extra cpu usage.

2) We are using the wakeup in this case to 'assign' work more
permanently to the thread. That is, in the case of a listen socket
we then add the connected socket to the woken up threads
local set of epoll events. So the load persists past the wake up.
And in this case, doing the round robin wakeups, simply allows
us to access more cpu bandwidth. (I'm also looking into potentially
using cpu affinity to do the wakeups as well as you suggested.)

Thanks,

-Jason
