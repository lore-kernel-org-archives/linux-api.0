From: Minchan Kim <minchan@kernel.org>
Subject: Re: [PATCH v1 1/4] mm: introduce MADV_COLD
Date: Thu, 20 Jun 2019 14:01:32 +0900
Message-ID: <20190620050132.GC105727@google.com>
References: <20190603053655.127730-1-minchan@kernel.org>
 <20190603053655.127730-2-minchan@kernel.org>
 <20190604203841.GC228607@google.com>
 <20190610100904.GC55602@google.com>
 <20190612172104.GA125771@google.com>
 <20190613044824.GF55602@google.com>
 <20190619171340.GA83620@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190619171340.GA83620@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Joel Fernandes <joel@joelfernandes.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, Tim Murray <timmurray@google.com>, Suren Baghdasaryan <surenb@google.com>, Daniel Colascione <dancol@google.com>, Shakeel Butt <shakeelb@google.com>, Sonny Rao <sonnyrao@google.com>, Brian Geffon <bgeffon@google.com>, jannh@google.com, oleg@redhat.com, christian@brauner.io, oleksandr@redhat.com, hdanton@sina.com, vdavydov.dev@gmail.com
List-Id: linux-api@vger.kernel.org

On Wed, Jun 19, 2019 at 01:13:40PM -0400, Joel Fernandes wrote:
< snip >

Ccing Vladimir

> > > > > > +static int madvise_cold_pte_range(pmd_t *pmd, unsigned long addr,
> > > > > > +				unsigned long end, struct mm_walk *walk)
> > > > > > +{
> > > > > > +	pte_t *orig_pte, *pte, ptent;
> > > > > > +	spinlock_t *ptl;
> > > > > > +	struct page *page;
> > > > > > +	struct vm_area_struct *vma = walk->vma;
> > > > > > +	unsigned long next;
> > > > > > +
> > > > > > +	next = pmd_addr_end(addr, end);
> > > > > > +	if (pmd_trans_huge(*pmd)) {
> > > > > > +		ptl = pmd_trans_huge_lock(pmd, vma);
> > > > > > +		if (!ptl)
> > > > > > +			return 0;
> > > > > > +
> > > > > > +		if (is_huge_zero_pmd(*pmd))
> > > > > > +			goto huge_unlock;
> > > > > > +
> > > > > > +		page = pmd_page(*pmd);
> > > > > > +		if (page_mapcount(page) > 1)
> > > > > > +			goto huge_unlock;
> > > > > > +
> > > > > > +		if (next - addr != HPAGE_PMD_SIZE) {
> > > > > > +			int err;
> > > > > > +
> > > > > > +			get_page(page);
> > > > > > +			spin_unlock(ptl);
> > > > > > +			lock_page(page);
> > > > > > +			err = split_huge_page(page);
> > > > > > +			unlock_page(page);
> > > > > > +			put_page(page);
> > > > > > +			if (!err)
> > > > > > +				goto regular_page;
> > > > > > +			return 0;
> > > > > > +		}
> > > > > > +
> > > > > > +		pmdp_test_and_clear_young(vma, addr, pmd);
> > > > > > +		deactivate_page(page);
> > > > > > +huge_unlock:
> > > > > > +		spin_unlock(ptl);
> > > > > > +		return 0;
> > > > > > +	}
> > > > > > +
> > > > > > +	if (pmd_trans_unstable(pmd))
> > > > > > +		return 0;
> > > > > > +
> > > > > > +regular_page:
> > > > > > +	orig_pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
> > > > > > +	for (pte = orig_pte; addr < end; pte++, addr += PAGE_SIZE) {
> > > > > > +		ptent = *pte;
> > > > > > +
> > > > > > +		if (pte_none(ptent))
> > > > > > +			continue;
> > > > > > +
> > > > > > +		if (!pte_present(ptent))
> > > > > > +			continue;
> > > > > > +
> > > > > > +		page = vm_normal_page(vma, addr, ptent);
> > > > > > +		if (!page)
> > > > > > +			continue;
> > > > > > +
> > > > > > +		if (page_mapcount(page) > 1)
> > > > > > +			continue;
> > > > > > +
> > > > > > +		ptep_test_and_clear_young(vma, addr, pte);
> > > > > 
> > > > > Wondering here how it interacts with idle page tracking. Here since young
> > > > > flag is cleared by the cold hint, page_referenced_one() or
> > > > > page_idle_clear_pte_refs_one() will not be able to clear the page-idle flag
> > > > > if it was previously set since it does not know any more that a page was
> > > > > actively referenced.
> > > > 
> > > > ptep_test_and_clear_young doesn't change PG_idle/young so idle page tracking
> > > > doesn't affect.
> > 
> > You said *young flag* in the comment, which made me confused. I thought you meant
> > PG_young flag but you mean PTE access bit.
> > 
> > > 
> > > Clearing of the young bit in the PTE does affect idle tracking.
> > > 
> > > Both page_referenced_one() and page_idle_clear_pte_refs_one() check this bit.
> > > 
> > > > > bit was previously set, just so that page-idle tracking works smoothly when
> > > > > this hint is concurrently applied?
> > > > 
> > > > deactivate_page will remove PG_young bit so that the page will be reclaimed.
> > > > Do I miss your point?
> > > 
> > > Say a process had accessed PTE bit not set, then idle tracking is run and PG_Idle
> > > is set. Now the page is accessed from userspace thus setting the accessed PTE
> > > bit.  Now a remote process passes this process_madvise cold hint (I know your
> > > current series does not support remote process, but I am saying for future
> > > when you post this). Because you cleared the PTE accessed bit through the
> > > hint, idle tracking no longer will know that the page is referenced and the
> > > user gets confused because accessed page appears to be idle.
> > 
> > Right.
> > 
> > > 
> > > I think to fix this, what you should do is clear the PG_Idle flag if the
> > > young/accessed PTE bits are set. If PG_Idle is already cleared, then you
> > > don't need to do anything.
> > 
> > I'm not sure. What does it make MADV_COLD special?
> > How about MADV_FREE|MADV_DONTNEED?
> > Why don't they clear PG_Idle if pte was young at tearing down pte? 
> 
> Good point, so it sounds like those (MADV_FREE|MADV_DONTNEED) also need to be fixed then?

Not sure. If you want it, maybe you need to fix every pte clearing and pte_mkold
part, which is more general to cover every sites like munmap, get_user_pages and
so on. Anyway, I don't think it's related to this patchset.

> 
> > The page could be shared by other processes so if we miss to clear out
> > PG_idle in there, page idle tracking could miss the access history forever.
> 
> I did not understand this. So say a page X is shared process P and Q and
> assume the PG_idle flag is set on the page.
> 
> P accesses memory and has the pte accessed bit set. P now gets the MADV_COLD
> hint and forgets to clear the idle flag while clearing the pte accessed bit.
> 
> Now the page appears to be idle, even though it was not. This has nothing to
> do with Q and whether the page is shared or not.

What I meant was MADV_FREE|MADV_DONTNEED.

> 
> > If it's not what you want, maybe we need to fix all places all at once.
> > However, I'm not sure. Rather than, I want to keep PG_idle in those hints
> > even though pte was accesssed because the process now gives strong hint
> > "The page is idle from now on". It's valid because he knows himself better than
> > others, even admin. IOW, he declare the page is not workingset any more.
> 
> Even if the PG_idle flag is not cleared - it is not a strong hint for working
> set size IMHO, because the page *was* accessed so the process definitely needed the
> page at some point even though now it says it is MADV_COLD. So that is part
> of working set. I don't think we should implicitly provide such hints and we
> should fix it.
> 
> Also I was saying in previous email, if process_madvise (future extension) is
> called from say activity manager, then the process and the user running the
> idle tracking feature has no idea that the page was accessed because the idle
> flag is still set. That is a bit weird and is loss of information.
> 
> It may not be a big deal in the long run if the page is accessed a lot, since
> the PTE accessed bit will be set again and idle-tracking feature may not miss
> it, but why leave it to chance if it is a simple fix?

Consistency with other madvise hints.

There are many places you could lose the information as I mentioned and I'm
really not conviced we need fixing because currently page-idle tracking
feature is biased to work with . If you believe we need to fix it,
it would be better to have a separate discussion, not here.

> 
> > What's the problem if page idle tracking feature miss it?
> 
> What's the problem if PG_idle flag is cleared here? It is just a software
> flag.

Again consistency. I don't think it's a MADV_PAGEOUT specific issue.
Since I pointed out other places idle tracking is missing(? not sure),
Let's discuss it separately if you feel we need fix.

Furthermore, once the page is reclaimed, that means the page could be
deallocated so you automatically don't see any PG_idle from the page.

> 
> > If other processs still have access bit of their pte for the page, page idle
> > tracking could find the page as non-idle so it's no problem, either.
> 
> Yes, but if the other process also does not access the page, then the access
> information is lost.
> 
> thanks!
> 
>  - Joel
> 
