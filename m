From: Oleksandr Natalenko <oleksandr@redhat.com>
Subject: Re: [PATCH v2 0/5] Introduce MADV_COLD and MADV_PAGEOUT
Date: Wed, 12 Jun 2019 13:19:20 +0200
Message-ID: <20190612111920.evedpmre63ivnxkz@butterfly.localdomain>
References: <20190610111252.239156-1-minchan@kernel.org>
 <20190612105945.GA16442@amd>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190612105945.GA16442@amd>
Sender: linux-kernel-owner@vger.kernel.org
To: Pavel Machek <pavel@ucw.cz>
Cc: Minchan Kim <minchan@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, Tim Murray <timmurray@google.com>, Joel Fernandes <joel@joelfernandes.org>, Suren Baghdasaryan <surenb@google.com>, Daniel Colascione <dancol@google.com>, Shakeel Butt <shakeelb@google.com>, Sonny Rao <sonnyrao@google.com>, Brian Geffon <bgeffon@google.com>, jannh@google.com, oleg@redhat.com, christian@brauner.io, hdanton@sina.com, lizeb@google.com
List-Id: linux-api@vger.kernel.org

On Wed, Jun 12, 2019 at 12:59:45PM +0200, Pavel Machek wrote:
> > - Problem
> > 
> > Naturally, cached apps were dominant consumers of memory on the system.
> > However, they were not significant consumers of swap even though they are
> > good candidate for swap. Under investigation, swapping out only begins
> > once the low zone watermark is hit and kswapd wakes up, but the overall
> > allocation rate in the system might trip lmkd thresholds and cause a cached
> > process to be killed(we measured performance swapping out vs. zapping the
> > memory by killing a process. Unsurprisingly, zapping is 10x times faster
> > even though we use zram which is much faster than real storage) so kill
> > from lmkd will often satisfy the high zone watermark, resulting in very
> > few pages actually being moved to swap.
> 
> Is it still faster to swap-in the application than to restart it?

It's the same type of question I was addressing earlier in the remote
KSM discussion: making applications aware of all the memory management stuff
or delegate the decision to some supervising task.

In this case, we cannot rewrite all the application to handle imaginary
SIGRESTART (or whatever you invent to handle restarts gracefully). SIGTERM
may require more memory to finish stuff to not lose your data (and I guess
you don't want to lose your data, right?), and SIGKILL is pretty much
destructive.

Offloading proactive memory management to a process that knows how to do
it allows to handle not only throwaway containers/microservices, but also
usual desktop/mobile workflow.

> > This approach is similar in spirit to madvise(MADV_WONTNEED), but the
> > information required to make the reclaim decision is not known to the app.
> > Instead, it is known to a centralized userspace daemon, and that daemon
> > must be able to initiate reclaim on its own without any app involvement.
> > To solve the concern, this patch introduces new syscall -
> > 
> >     struct pr_madvise_param {
> >             int size;               /* the size of this structure */
> >             int cookie;             /* reserved to support atomicity */
> >             int nr_elem;            /* count of below arrary fields */
> >             int __user *hints;      /* hints for each range */
> >             /* to store result of each operation */
> >             const struct iovec __user *results;
> >             /* input address ranges */
> >             const struct iovec __user *ranges;
> >     };
> >     
> >     int process_madvise(int pidfd, struct pr_madvise_param *u_param,
> >                             unsigned long flags);
> 
> That's quite a complex interface.
> 
> Could we simply have feel_free_to_swap_out(int pid) syscall? :-).

I wonder for how long we'll go on with adding new syscalls each time we need
some amendment to existing interfaces. Yes, clone6(), I'm looking at
you :(.

In case of process_madvise() keep in mind it will be focused not only on
MADV_COLD, but also, potentially, on other MADV_ flags as well. I can
hardly imagine we'll add one syscall per each flag.

-- 
  Best regards,
    Oleksandr Natalenko (post-factum)
    Senior Software Maintenance Engineer
