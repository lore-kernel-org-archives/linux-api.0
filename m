From: Jason Baron <jbaron@akamai.com>
Subject: Re: [PATCH 2/2] epoll: introduce EPOLLEXCLUSIVE and EPOLLROUNDROBIN
Date: Mon, 09 Feb 2015 22:59:05 -0500
Message-ID: <54D98209.2080901@akamai.com>
References: <cover.1423509605.git.jbaron@akamai.com> <68a0ad4a99551ea3bfff89da461bb490d63b0ca8.1423509605.git.jbaron@akamai.com> <54D915FC.7010003@amacapital.net> <54D92780.4000303@akamai.com> <CALCETrUQZHHE_PJYoMw8g9C5AAxSdF-jU85EF317O4Krk+bV9w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrUQZHHE_PJYoMw8g9C5AAxSdF-jU85EF317O4Krk+bV9w@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>, Linux API <linux-api@vger.kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Eric Wong <normalperson@yhbt.net>, Davide Libenzi <davidel@xmailserver.org>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On 02/09/2015 05:45 PM, Andy Lutomirski wrote:
> On Mon, Feb 9, 2015 at 1:32 PM, Jason Baron <jbaron@akamai.com> wrote:
>> On 02/09/2015 03:18 PM, Andy Lutomirski wrote:
>>> On 02/09/2015 12:06 PM, Jason Baron wrote:
>>>> Epoll file descriptors that are added to a shared wakeup source are always
>>>> added in a non-exclusive manner. That means that when we have multiple epoll
>>>> fds attached to a shared wakeup source they are all woken up. This can
>>>> lead to excessive cpu usage and uneven load distribution.
>>>>
>>>> This patch introduces two new 'events' flags that are intended to be used
>>>> with EPOLL_CTL_ADD operations. EPOLLEXCLUSIVE, adds the epoll fd to the event
>>>> source in an exclusive manner such that the minimum number of threads are
>>>> woken. EPOLLROUNDROBIN, which depends on EPOLLEXCLUSIVE also being set, can
>>>> also be added to the 'events' flag, such that we round robin around the set
>>>> of waiting threads.
>>>>
>>>> An implementation note is that in the epoll wakeup routine,
>>>> 'ep_poll_callback()', if EPOLLROUNDROBIN is set, we return 1, for a successful
>>>> wakeup, only when there are current waiters. The idea is to use this additional
>>>> heuristic in order minimize wakeup latencies.
>>> I don't understand what this is intended to do.
>>>
>>> If an event has EPOLLONESHOT, then this only one thread should be woken regardless, right?  If not, isn't that just a bug that should be fixed?
>>>
>> hmm...so with EPOLLONESHOT you basically get notified once about an event. If i have multiple epoll fds (say 1 per-thread) attached to a single source in EPOLLONESHOT, then all threads will potentially get woken up once per event. Then, I would have to re-arm all of them. So I don't think this addresses this particular usecase...what I am trying to avoid is this mass wakeup or thundering herd for a shared event source.
> Now I understand.  Why are you using multiple epollfds?
>
> --Andy

So the multiple epollfds is really a way to partition the set of events. Otherwise, I have all the threads contending on all the events that are being generated. So I'm not sure if that is scalable.

In the use-case I'm trying to describe, I've partitioned a large set of the events, but there may still be some event sources that we wish to share among all of the threads (or even subsets of them), so as not to overload any one in particular.

More specifically, in the case of a single listen socket, its natural to call accept() on the thread that has been woken up, but without doing round robin, you quickly get into a very unbalanced load, and in addition you waste a lot of cpu doing unnecessary wakeups. There are other approaches to solve this, specifically using SO_REUSEPORT, which creates a separate socket per-thread and gets one back to the separately partitioned events case previously described. However, SO_REUSEPORT, I believe is very specific to tcp/udp, and in addition does not have knowledge of the threads that are actively waiting as the epoll code does.

Thanks,

-Jason
