From: Minchan Kim <minchan@kernel.org>
Subject: Re: [PATCH v2 0/5] Introduce MADV_COLD and MADV_PAGEOUT
Date: Thu, 20 Jun 2019 08:42:35 +0900
Message-ID: <20190619234235.GA52978@google.com>
References: <20190610111252.239156-1-minchan@kernel.org>
 <20190619122750.GN2968@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190619122750.GN2968@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Michal Hocko <mhocko@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>, Tim Murray <timmurray@google.com>, Joel Fernandes <joel@joelfernandes.org>, Suren Baghdasaryan <surenb@google.com>, Daniel Colascione <dancol@google.com>, Shakeel Butt <shakeelb@google.com>, Sonny Rao <sonnyrao@google.com>, Brian Geffon <bgeffon@google.com>, jannh@google.com, oleg@redhat.com, christian@brauner.io, oleksandr@redhat.com, hdanton@sina.com, lizeb@google.com
List-Id: linux-api@vger.kernel.org

On Wed, Jun 19, 2019 at 02:27:50PM +0200, Michal Hocko wrote:
> On Mon 10-06-19 20:12:47, Minchan Kim wrote:
> > This patch is part of previous series:
> > https://lore.kernel.org/lkml/20190531064313.193437-1-minchan@kernel.org/T/#u
> > Originally, it was created for external madvise hinting feature.
> > 
> > https://lkml.org/lkml/2019/5/31/463
> > Michal wanted to separte the discussion from external hinting interface
> > so this patchset includes only first part of my entire patchset
> > 
> >   - introduce MADV_COLD and MADV_PAGEOUT hint to madvise.
> > 
> > However, I keep entire description for others for easier understanding
> > why this kinds of hint was born.
> > 
> > Thanks.
> > 
> > This patchset is against on next-20190530.
> > 
> > Below is description of previous entire patchset.
> > ================= &< =====================
> > 
> > - Background
> > 
> > The Android terminology used for forking a new process and starting an app
> > from scratch is a cold start, while resuming an existing app is a hot start.
> > While we continually try to improve the performance of cold starts, hot
> > starts will always be significantly less power hungry as well as faster so
> > we are trying to make hot start more likely than cold start.
> > 
> > To increase hot start, Android userspace manages the order that apps should
> > be killed in a process called ActivityManagerService. ActivityManagerService
> > tracks every Android app or service that the user could be interacting with
> > at any time and translates that into a ranked list for lmkd(low memory
> > killer daemon). They are likely to be killed by lmkd if the system has to
> > reclaim memory. In that sense they are similar to entries in any other cache.
> > Those apps are kept alive for opportunistic performance improvements but
> > those performance improvements will vary based on the memory requirements of
> > individual workloads.
> > 
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
> > 
> > - Approach
> > 
> > The approach we chose was to use a new interface to allow userspace to
> > proactively reclaim entire processes by leveraging platform information.
> > This allowed us to bypass the inaccuracy of the kernel’s LRUs for pages
> > that are known to be cold from userspace and to avoid races with lmkd
> > by reclaiming apps as soon as they entered the cached state. Additionally,
> > it could provide many chances for platform to use much information to
> > optimize memory efficiency.
> > 
> > To achieve the goal, the patchset introduce two new options for madvise.
> > One is MADV_COLD which will deactivate activated pages and the other is
> > MADV_PAGEOUT which will reclaim private pages instantly. These new options
> > complement MADV_DONTNEED and MADV_FREE by adding non-destructive ways to
> > gain some free memory space. MADV_PAGEOUT is similar to MADV_DONTNEED in a way
> > that it hints the kernel that memory region is not currently needed and
> > should be reclaimed immediately; MADV_COLD is similar to MADV_FREE in a way
> > that it hints the kernel that memory region is not currently needed and
> > should be reclaimed when memory pressure rises.
> 
> This all is a very good background information suitable for the cover
> letter.
> 
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
> But this and the following paragraphs are referring to the later step
> when the madvise gains a remote process capabilities and that is out
> of the scope of this patch series so I would simply remove it from
> here. Andrew tends to put the cover letter into the first patch of the
> series and that would be indeed
> confusing here.

Okay, I will remove the part in next revision.
