From: Jason Baron <jbaron-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/2] epoll: introduce EPOLLEXCLUSIVE and EPOLLROUNDROBIN
Date: Tue, 10 Feb 2015 14:16:58 -0500
Message-ID: <54DA592A.3050102@akamai.com>
References: <cover.1423509605.git.jbaron@akamai.com> <68a0ad4a99551ea3bfff89da461bb490d63b0ca8.1423509605.git.jbaron@akamai.com> <54D915FC.7010003@amacapital.net> <54D92780.4000303@akamai.com> <CALCETrUQZHHE_PJYoMw8g9C5AAxSdF-jU85EF317O4Krk+bV9w@mail.gmail.com> <54D98209.2080901@akamai.com> <20150210044939.GA15616@dcvr.yhbt.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150210044939.GA15616-yBiyF41qdooeIZ0/mPfg9Q@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eric Wong <normalperson-rMlxZR9MS24@public.gmane.org>
Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Davide Libenzi <davidel-AhlLAIvw+VEjIGhXcJzhZg@public.gmane.org>, Michael Kerrisk-manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 02/09/2015 11:49 PM, Eric Wong wrote:
> Jason Baron <jbaron-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org> wrote:
>> On 02/09/2015 05:45 PM, Andy Lutomirski wrote:
>>> On Mon, Feb 9, 2015 at 1:32 PM, Jason Baron <jbaron-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org> wrote:
>>>> On 02/09/2015 03:18 PM, Andy Lutomirski wrote:
>>>>> On 02/09/2015 12:06 PM, Jason Baron wrote:
>>>>>> Epoll file descriptors that are added to a shared wakeup source are always
>>>>>> added in a non-exclusive manner. That means that when we have multiple epoll
>>>>>> fds attached to a shared wakeup source they are all woken up. This can
>>>>>> lead to excessive cpu usage and uneven load distribution.
>>>>>>
>>>>>> This patch introduces two new 'events' flags that are intended to be used
>>>>>> with EPOLL_CTL_ADD operations. EPOLLEXCLUSIVE, adds the epoll fd to the event
>>>>>> source in an exclusive manner such that the minimum number of threads are
>>>>>> woken. EPOLLROUNDROBIN, which depends on EPOLLEXCLUSIVE also being set, can
>>>>>> also be added to the 'events' flag, such that we round robin around the set
>>>>>> of waiting threads.
>>>>>>
>>>>>> An implementation note is that in the epoll wakeup routine,
>>>>>> 'ep_poll_callback()', if EPOLLROUNDROBIN is set, we return 1, for a successful
>>>>>> wakeup, only when there are current waiters. The idea is to use this additional
>>>>>> heuristic in order minimize wakeup latencies.
>>>>> I don't understand what this is intended to do.
>>>>>
>>>>> If an event has EPOLLONESHOT, then this only one thread should be woken regardless, right?  If not, isn't that just a bug that should be fixed?
>>>>>
>>>> hmm...so with EPOLLONESHOT you basically get notified once about an event. If i have multiple epoll fds (say 1 per-thread) attached to a single source in EPOLLONESHOT, then all threads will potentially get woken up once per event. Then, I would have to re-arm all of them. So I don't think this addresses this particular usecase...what I am trying to avoid is this mass wakeup or thundering herd for a shared event source.
>>> Now I understand.  Why are you using multiple epollfds?
>>>
>>> --Andy
>> So the multiple epollfds is really a way to partition the set of
>> events. Otherwise, I have all the threads contending on all the events
>> that are being generated. So I'm not sure if that is scalable.
> I wonder if EPOLLONESHOT + epoll_wait with a sufficiently large
> maxevents value is sufficient for you.  All events would be shared, so
> they can migrate between threads(*).  Each thread takes a largish set of
> events on every epoll_wait call and doesn't call epoll_wait again until
> it's done with the whole set it got.
>
> You'll hit more contention on EPOLL_CTL_MOD with shared events and a
> single epoll, but I think it's a better goal to make that lock-free.

Its not just EPOLL_CTL_MOD, but there's also going to be contention on
epoll add and remove since there is only 1 epoll fd in this case. I'm also
concerned about the balancing of the workload among threads in the single
queue case. I think its quite reasonable to have user-space partition
the set
of events among threads as it sees fit using multiple epoll fds.

However, currently this multiple epoll fd scheme does not handle events from
a shared event source well. As I mentioned there is a thundering herd wakeup
in this case, and the wakeups are unbalanced. In fact, we have an
application
that currently does EPOLL_CTL_REMOVEs followed by EPOLL_CTL_ADDs
periodically against a shared wakeup source in order to re-balance the
wakeup
queues. This solves the balancing issues to an extent, but not the
thundering
herd. I'd like to move this logic down into the kernel with this patch set.

> (*) Too large a maxevents will lead to head-of-line blocking, but from
> what I'm inferring, you already risk that with multiple epollfds and
> separate threads working on them.
>
> Do you have a userland use case to share?

I've been trying to describe the use case, maybe I haven't been doing a good
job :(

>> In the use-case I'm trying to describe, I've partitioned a large set
>> of the events, but there may still be some event sources that we wish
>> to share among all of the threads (or even subsets of them), so as not
>> to overload any one in particular.
>  
>> More specifically, in the case of a single listen socket, its natural
>> to call accept() on the thread that has been woken up, but without
>> doing round robin, you quickly get into a very unbalanced load, and in
>> addition you waste a lot of cpu doing unnecessary wakeups. There are
>> other approaches to solve this, specifically using SO_REUSEPORT, which
>> creates a separate socket per-thread and gets one back to the
>> separately partitioned events case previously described. However,
>> SO_REUSEPORT, I believe is very specific to tcp/udp, and in addition
>> does not have knowledge of the threads that are actively waiting as
>> the epoll code does.
> Did you try my suggestion of using a dedicated thread (or thread pool)
> which does nothing but loop on accept() + EPOLL_CTL_ADD?
>
> Those dedicated threads could do its own round-robin in userland to pick
> a different epollfd to call EPOLL_CTL_ADD on.

Thanks for your suggestion! I'm not actively working on the user-space
code here, but I will pass it along.

I would prefer though not to have to context switch the 'accept' thread
on and off the cpu every time there is a new connection. So the approach
suggested here essentially moves this dedicated thread (threads), down
into the kernel and avoids the creation of these threads entirely.

Thanks,

-Jason
