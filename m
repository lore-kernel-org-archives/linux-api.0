From: Minchan Kim <minchan@kernel.org>
Subject: Re: [PATCH v2 1/5] mm: introduce MADV_COLD
Date: Thu, 20 Jun 2019 09:06:51 +0900
Message-ID: <20190620000650.GB52978@google.com>
References: <20190610111252.239156-1-minchan@kernel.org>
 <20190610111252.239156-2-minchan@kernel.org>
 <20190619125611.GO2968@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190619125611.GO2968@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Michal Hocko <mhocko@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>, Tim Murray <timmurray@google.com>, Joel Fernandes <joel@joelfernandes.org>, Suren Baghdasaryan <surenb@google.com>, Daniel Colascione <dancol@google.com>, Shakeel Butt <shakeelb@google.com>, Sonny Rao <sonnyrao@google.com>, Brian Geffon <bgeffon@google.com>, jannh@google.com, oleg@redhat.com, christian@brauner.io, oleksandr@redhat.com, hdanton@sina.com, lizeb@google.com
List-Id: linux-api@vger.kernel.org

On Wed, Jun 19, 2019 at 02:56:12PM +0200, Michal Hocko wrote:
> On Mon 10-06-19 20:12:48, Minchan Kim wrote:
> > When a process expects no accesses to a certain memory range, it could
> > give a hint to kernel that the pages can be reclaimed when memory pressure
> > happens but data should be preserved for future use.  This could reduce
> > workingset eviction so it ends up increasing performance.
> > 
> > This patch introduces the new MADV_COLD hint to madvise(2) syscall.
> > MADV_COLD can be used by a process to mark a memory range as not expected
> > to be used in the near future. The hint can help kernel in deciding which
> > pages to evict early during memory pressure.
> > 
> > It works for every LRU pages like MADV_[DONTNEED|FREE]. IOW, It moves
> > 
> > 	active file page -> inactive file LRU
> > 	active anon page -> inacdtive anon LRU
> > 
> > Unlike MADV_FREE, it doesn't move active anonymous pages to inactive
> > file LRU's head because MADV_COLD is a little bit different symantic.
> > MADV_FREE means it's okay to discard when the memory pressure because
> > the content of the page is *garbage* so freeing such pages is almost zero
> > overhead since we don't need to swap out and access afterward causes just
> > minor fault. Thus, it would make sense to put those freeable pages in
> > inactive file LRU to compete other used-once pages. It makes sense for
> > implmentaion point of view, too because it's not swapbacked memory any
> > longer until it would be re-dirtied. Even, it could give a bonus to make
> > them be reclaimed on swapless system. However, MADV_COLD doesn't mean
> > garbage so reclaiming them requires swap-out/in in the end so it's bigger
> > cost. Since we have designed VM LRU aging based on cost-model, anonymous
> > cold pages would be better to position inactive anon's LRU list, not file
> > LRU. Furthermore, it would help to avoid unnecessary scanning if system
> > doesn't have a swap device. Let's start simpler way without adding
> > complexity at this moment.
> 
> I would only add that it is a caveat that workloads with a lot of page
> cache are likely to ignore MADV_COLD on anonymous memory because we
> rarely age anonymous LRU lists.

Okay, I will add some more.

> 
> [...]
> > +static int madvise_cold_pte_range(pmd_t *pmd, unsigned long addr,
> > +				unsigned long end, struct mm_walk *walk)
> > +{
> 
> This is duplicating a large part of madvise_free_pte_range with some
> subtle differences which are not explained anywhere (e.g. why does
> madvise_free_huge_pmd need try_lock on a page while not here? etc.).

madvise_free_huge_pmd handle dirty bit but this is not.

> 
> Why cannot we reuse a large part of that code and differ essentially on
> the reclaim target check and action? Have you considered to consolidate
> the code to share as much as possible? Maybe that is easier said than
> done because the devil is always in details...

Yub, it was not pretty when I tried. Please see last patch in this
patchset.
