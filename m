From: Eric Wong <normalperson@yhbt.net>
Subject: Re: [PATCH v2 2/2] epoll: introduce EPOLLEXCLUSIVE and
 EPOLLROUNDROBIN
Date: Sun, 22 Feb 2015 00:24:32 +0000
Message-ID: <20150222002432.GA9031@dcvr.yhbt.net>
References: <cover.1424200151.git.jbaron@akamai.com>
 <7956874bfdc7403f37afe8a75e50c24221039bd2.1424200151.git.jbaron@akamai.com>
 <20150218080740.GA10199@gmail.com>
 <54E4B2D0.8020706@akamai.com>
 <20150218163300.GA28007@gmail.com>
 <54E4CE14.5010708@akamai.com>
 <20150218174533.GB31566@gmail.com>
 <20150218175123.GA31878@gmail.com>
 <54E557CF.8080702@akamai.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <54E557CF.8080702@akamai.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Jason Baron <jbaron@akamai.com>
Cc: Ingo Molnar <mingo@kernel.org>, peterz@infradead.org, mingo@redhat.com, viro@zeniv.linux.org.uk, akpm@linux-foundation.org, davidel@xmailserver.org, mtk.manpages@gmail.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>, "luto@amacapital.net >> Andy Lutomirski" <luto@amacapital.net>
List-Id: linux-api@vger.kernel.org

Jason Baron <jbaron@akamai.com> wrote:
> On 02/18/2015 12:51 PM, Ingo Molnar wrote:
> > * Ingo Molnar <mingo@kernel.org> wrote:
> >
> >>> [...] However, I think the userspace API change is less 
> >>> clear since epoll_wait() doesn't currently have an 
> >>> 'input' events argument as epoll_ctl() does.
> >> ... but the change would be a bit clearer and somewhat 
> >> more flexible: LIFO or FIFO queueing, right?
> >>
> >> But having the queueing model as part of the epoll 
> >> context is a legitimate approach as well.
> > Btw., there's another optimization that the networking code 
> > already does when processing incoming packets: waking up a 
> > thread on the local CPU, where the wakeup is running.
> >
> > Doing the same on epoll would have real scalability 
> > advantages where incoming events are IRQ driven and are 
> > distributed amongst multiple CPUs.
> >
> > Where events are task driven the scheduler will already try 
> > to pair up waker and wakee so it might not show up in 
> > measurements that markedly.
> >
> 
> Right, so this makes me think that we may want to potentially
> support a variety of wakeup policies. Adding these to the
> generic wake up code is just going to be too messy. So, perhaps
> a better approach here would be to register a single
> wait_queue_t with the event source queue that will always
> be woken up, and then layer any epoll balancing/irq affinity
> policies on top of that. So in essence we end up with sort of
> two queues layers, but I think it provides much nicer isolation
> between layers. Also, the bulk of the changes are going to be
> isolated to the epoll code, and we avoid Andy's concern about
> missing, or starving out wakeups.
> 
> So here's a stab at how this API could look:
> 
> 1. ep1 = epoll_create1(EPOLL_POLICY);
> 
> So EPOLL_POLICY here could the round robin policy described
> here, or the irq affinity or other ideas. The idea is to create
> an fd that is local to the process, such that other processes
> can not subsequently attach to it and affect our policy.

I'm not against defining more policies if needed.
Maybe FIFO vs LIFO is a good case for this.

For affinity, it could probably be done transparently based on
epoll_wait retrievals + EPOLL_CTL_MOD operations.

> 2. epoll_ctl(ep1, EPOLL_CTL_ADD, fd_source, NULL);
> 
> This associates ep1 with the event source. ep1 can be
> associated with or added to at most 1 wakeup source. This call
> would largely just form the association, but not queue anything
> to the fd_source wait queue.

This would mean one extra FD for every fd_source, but that's
only a handful of FDs (listen sockets), correct?

> 3. epoll_ctl(ep2, EPOLL_CTL_ADD, ep1, event);
>     epoll_ctl(ep3, EPOLL_CTL_ADD, ep1, event);
>     epoll_ctl(ep4, EPOLL_CTL_ADD, ep1, event);
>      .
>      .
>      .
> 
> Finally, we add the epoll sets to the event source (indirectly via
> ep1). So the first add would actually queue the callback to the
> fd_source. While the subsequent calls would simply queue things
> to the 'nested' wakeup queue associated with ep1.

I'm not sure I follow, wouldn't this increase the number of wakeups?

> So any existing epoll/poll/select calls could be queued as well
> to fd_source and will operate independenly from this mechanism,
> as the fd_source queue continues to be 'wake all'. Also, there
> should be no changes necessary to __wake_up_common(), other
> than potentially passing more back though the
> wait_queue_func_t, such as 'nr_exclusive'.
