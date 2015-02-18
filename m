From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH v2 2/2] epoll: introduce EPOLLEXCLUSIVE and EPOLLROUNDROBIN
Date: Wed, 18 Feb 2015 15:12:43 -0800
Message-ID: <CALCETrUfs8R-CKwwq2x9xc9z=6aqKzOOaf2ts+TOs-H=W1sfug@mail.gmail.com>
References: <cover.1424200151.git.jbaron@akamai.com> <7956874bfdc7403f37afe8a75e50c24221039bd2.1424200151.git.jbaron@akamai.com>
 <20150218080740.GA10199@gmail.com> <54E4B2D0.8020706@akamai.com>
 <20150218163300.GA28007@gmail.com> <54E4CE14.5010708@akamai.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <54E4CE14.5010708@akamai.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Jason Baron <jbaron@akamai.com>
Cc: Davide Libenzi <davidel@xmailserver.org>, Michael Kerrisk <mtk.manpages@gmail.com>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Eric Wong <normalperson@yhbt.net>, Andrew Morton <akpm@linux-foundation.org>, Peter Zijlstra <peterz@infradead.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>, Linux API <linux-api@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>
List-Id: linux-api@vger.kernel.org

On Feb 18, 2015 9:38 AM, "Jason Baron" <jbaron@akamai.com> wrote:
>
> On 02/18/2015 11:33 AM, Ingo Molnar wrote:
> > * Jason Baron <jbaron@akamai.com> wrote:
> >
> >>> This has two main advantages: firstly it solves the
> >>> O(N) (micro-)problem, but it also more evenly
> >>> distributes events both between task-lists and within
> >>> epoll groups as tasks as well.
> >> Its solving 2 issues - spurious wakeups, and more even
> >> loading of threads. The event distribution is more even
> >> between 'epoll groups' with this patch, however, if
> >> multiple threads are blocking on a single 'epoll group',
> >> this patch does not affect the the event distribution
> >> there. [...]
> > Regarding your last point, are you sure about that?
> >
> > If we have say 16 epoll threads registered, and if the list
> > is static (no register/unregister activity), then the
> > wakeup pattern is in strict order of the list: threads
> > closer to the list head will be woken more frequently, in a
> > wake-once fashion. So if threads do just quick work and go
> > back to sleep quickly, then typically only the first 2-3
> > threads will get any runtime in practice - the wakeup
> > iteration never gets 'deep' into the list.
> >
> > With the round-robin shuffling of the list, the threads get
> > shuffled to the tail on wakeup, which distributes events
> > evenly: all 16 epoll threads will accumulate an even
> > distribution of runtime, statistically.
> >
> > Have I misunderstood this somehow?
> >
> >
>
> So in the case of multiple threads per epoll set, we currently
> add to the head of wakeup queue exclusively in 'epoll_wait()',
> and then subsequently remove from the queue once
> 'epoll_wait()' returns. So I don't think this patch addresses
> balancing on a per epoll set basis.
>
> I think we could address the case you describe by simply doing
> __add_wait_queue_tail_exclusive() instead of
> __add_wait_queue_exclusive() in epoll_wait(). However, I think
> the userspace API change is less clear since epoll_wait() doesn't
> currently have an 'input' events argument as epoll_ctl() does.

FWIW there's currently discussion about adding a new epoll API for
batch epoll_ctl.  It could be with coordinating with that effort if
some variant could address both use cases.

I'm still nervous about changing the per-fd wakeup stuff to do
anything other than waking everything.  After all, epoll and poll can
be used concurrently.

What about a slightly different approach: could an epoll fd support
multiple contexts?  For example, an fd could be set (with epoll_ctl or
the new batch stuff) to wake an any epoll waiter, one specific epoll
waiter, an epoll waiter preferably on the waking cpu, etc.

This would have the benefit of keeping the wakeup changes localized to
the epoll code.

--Andy

>
> Thanks,
>
> -Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-api" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
