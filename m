From: Jason Baron <jbaron-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 2/2] epoll: introduce EPOLLEXCLUSIVE and EPOLLROUNDROBIN
Date: Wed, 25 Feb 2015 10:48:18 -0500
Message-ID: <54EDEEC2.2040201@akamai.com>
References: <cover.1424200151.git.jbaron@akamai.com> <7956874bfdc7403f37afe8a75e50c24221039bd2.1424200151.git.jbaron@akamai.com> <20150218080740.GA10199@gmail.com> <54E4B2D0.8020706@akamai.com> <20150218163300.GA28007@gmail.com> <54E4CE14.5010708@akamai.com> <20150218174533.GB31566@gmail.com> <20150218175123.GA31878@gmail.com> <54E557CF.8080702@akamai.com> <20150222002432.GA9031@dcvr.yhbt.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150222002432.GA9031-yBiyF41qdooeIZ0/mPfg9Q@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eric Wong <normalperson-rMlxZR9MS24@public.gmane.org>
Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, davidel-AhlLAIvw+VEjIGhXcJzhZg@public.gmane.org, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>, "luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org >> Andy Lutomirski" <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 02/21/2015 07:24 PM, Eric Wong wrote:
> Jason Baron <jbaron-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org> wrote:
>> On 02/18/2015 12:51 PM, Ingo Molnar wrote:
>>> * Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>>>
>>>>> [...] However, I think the userspace API change is less 
>>>>> clear since epoll_wait() doesn't currently have an 
>>>>> 'input' events argument as epoll_ctl() does.
>>>> ... but the change would be a bit clearer and somewhat 
>>>> more flexible: LIFO or FIFO queueing, right?
>>>>
>>>> But having the queueing model as part of the epoll 
>>>> context is a legitimate approach as well.
>>> Btw., there's another optimization that the networking code 
>>> already does when processing incoming packets: waking up a 
>>> thread on the local CPU, where the wakeup is running.
>>>
>>> Doing the same on epoll would have real scalability 
>>> advantages where incoming events are IRQ driven and are 
>>> distributed amongst multiple CPUs.
>>>
>>> Where events are task driven the scheduler will already try 
>>> to pair up waker and wakee so it might not show up in 
>>> measurements that markedly.
>>>
>> Right, so this makes me think that we may want to potentially
>> support a variety of wakeup policies. Adding these to the
>> generic wake up code is just going to be too messy. So, perhaps
>> a better approach here would be to register a single
>> wait_queue_t with the event source queue that will always
>> be woken up, and then layer any epoll balancing/irq affinity
>> policies on top of that. So in essence we end up with sort of
>> two queues layers, but I think it provides much nicer isolation
>> between layers. Also, the bulk of the changes are going to be
>> isolated to the epoll code, and we avoid Andy's concern about
>> missing, or starving out wakeups.
>>
>> So here's a stab at how this API could look:
>>
>> 1. ep1 = epoll_create1(EPOLL_POLICY);
>>
>> So EPOLL_POLICY here could the round robin policy described
>> here, or the irq affinity or other ideas. The idea is to create
>> an fd that is local to the process, such that other processes
>> can not subsequently attach to it and affect our policy.
> I'm not against defining more policies if needed.
> Maybe FIFO vs LIFO is a good case for this.
>
> For affinity, it could probably be done transparently based on
> epoll_wait retrievals + EPOLL_CTL_MOD operations.
>
>> 2. epoll_ctl(ep1, EPOLL_CTL_ADD, fd_source, NULL);
>>
>> This associates ep1 with the event source. ep1 can be
>> associated with or added to at most 1 wakeup source. This call
>> would largely just form the association, but not queue anything
>> to the fd_source wait queue.
> This would mean one extra FD for every fd_source, but that's
> only a handful of FDs (listen sockets), correct?

Yes, one extra epoll fd per shared wakeup source, so this should
result in very few additional fds.

>> 3. epoll_ctl(ep2, EPOLL_CTL_ADD, ep1, event);
>>     epoll_ctl(ep3, EPOLL_CTL_ADD, ep1, event);
>>     epoll_ctl(ep4, EPOLL_CTL_ADD, ep1, event);
>>      .
>>      .
>>      .
>>
>> Finally, we add the epoll sets to the event source (indirectly via
>> ep1). So the first add would actually queue the callback to the
>> fd_source. While the subsequent calls would simply queue things
>> to the 'nested' wakeup queue associated with ep1.
> I'm not sure I follow, wouldn't this increase the number of wakeups?

I agree, my text there is confusing...I've posted this idea as
v3 of this series, so hopefully that clarifies this approach.

Thanks,

-Jason
