From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCH 2/2] epoll: introduce EPOLLEXCLUSIVE and EPOLLROUNDROBIN
Date: Mon, 9 Feb 2015 14:45:10 -0800
Message-ID: <CALCETrUQZHHE_PJYoMw8g9C5AAxSdF-jU85EF317O4Krk+bV9w@mail.gmail.com>
References: <cover.1423509605.git.jbaron@akamai.com> <68a0ad4a99551ea3bfff89da461bb490d63b0ca8.1423509605.git.jbaron@akamai.com>
 <54D915FC.7010003@amacapital.net> <54D92780.4000303@akamai.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54D92780.4000303-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Baron <jbaron-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Eric Wong <normalperson-rMlxZR9MS24@public.gmane.org>, Davide Libenzi <davidel-AhlLAIvw+VEjIGhXcJzhZg@public.gmane.org>, Michael Kerrisk-manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Feb 9, 2015 at 1:32 PM, Jason Baron <jbaron-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org> wrote:
> On 02/09/2015 03:18 PM, Andy Lutomirski wrote:
>> On 02/09/2015 12:06 PM, Jason Baron wrote:
>>> Epoll file descriptors that are added to a shared wakeup source are always
>>> added in a non-exclusive manner. That means that when we have multiple epoll
>>> fds attached to a shared wakeup source they are all woken up. This can
>>> lead to excessive cpu usage and uneven load distribution.
>>>
>>> This patch introduces two new 'events' flags that are intended to be used
>>> with EPOLL_CTL_ADD operations. EPOLLEXCLUSIVE, adds the epoll fd to the event
>>> source in an exclusive manner such that the minimum number of threads are
>>> woken. EPOLLROUNDROBIN, which depends on EPOLLEXCLUSIVE also being set, can
>>> also be added to the 'events' flag, such that we round robin around the set
>>> of waiting threads.
>>>
>>> An implementation note is that in the epoll wakeup routine,
>>> 'ep_poll_callback()', if EPOLLROUNDROBIN is set, we return 1, for a successful
>>> wakeup, only when there are current waiters. The idea is to use this additional
>>> heuristic in order minimize wakeup latencies.
>>
>> I don't understand what this is intended to do.
>>
>> If an event has EPOLLONESHOT, then this only one thread should be woken regardless, right?  If not, isn't that just a bug that should be fixed?
>>
>
> hmm...so with EPOLLONESHOT you basically get notified once about an event. If i have multiple epoll fds (say 1 per-thread) attached to a single source in EPOLLONESHOT, then all threads will potentially get woken up once per event. Then, I would have to re-arm all of them. So I don't think this addresses this particular usecase...what I am trying to avoid is this mass wakeup or thundering herd for a shared event source.

Now I understand.  Why are you using multiple epollfds?

--Andy

>
>> If an event has EPOLLET, then the considerations are similar to EPOLLONESHOT, right?
>>
>
> EPOLLET is still going to cause this thundering herd.
>
>> If an event is a normal level-triggered non-one-shot event, then I don't understand how a round-robin wakeup makes any sense.  It's level-triggered, after all.
>
> Yeah, so the current behavior is to wake up all of the threads. I'm trying to add a new mode where it load balances among the threads interested in the event. Perhaps, the test program I attached to 0/2 will show the issue better?
>
> Also, this originally came up in the context of a single listening socket which was attached to multiple epoll fds each in a separate thread. With the attached patch, I can measure a large decrease in cpu usage and better balancing behavior among the accepting threads.
>
> Thanks,
>
> -Jason



-- 
Andy Lutomirski
AMA Capital Management, LLC
