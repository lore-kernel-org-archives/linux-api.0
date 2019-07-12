From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v4 4/4] mm: introduce MADV_PAGEOUT
Date: Fri, 12 Jul 2019 09:58:09 -0400
Message-ID: <20190712135809.GB31107@cmpxchg.org>
References: <20190711012528.176050-1-minchan@kernel.org>
 <20190711012528.176050-5-minchan@kernel.org>
 <20190711184223.GD20341@cmpxchg.org>
 <20190712051828.GA128252@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190712051828.GA128252@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Minchan Kim <minchan@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, Michal Hocko <mhocko@suse.com>, Tim Murray <timmurray@google.com>, Joel Fernandes <joel@joelfernandes.org>, Suren Baghdasaryan <surenb@google.com>, Daniel Colascione <dancol@google.com>, Shakeel Butt <shakeelb@google.com>, Sonny Rao <sonnyrao@google.com>, oleksandr@redhat.com, hdanton@sina.com, lizeb@google.com, Dave Hansen <dave.hansen@intel.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
List-Id: linux-api@vger.kernel.org

On Fri, Jul 12, 2019 at 02:18:28PM +0900, Minchan Kim wrote:
> Hi Johannes,
> 
> On Thu, Jul 11, 2019 at 02:42:23PM -0400, Johannes Weiner wrote:
> > On Thu, Jul 11, 2019 at 10:25:28AM +0900, Minchan Kim wrote:
> > > @@ -480,6 +482,198 @@ static long madvise_cold(struct vm_area_struct *vma,
> > >  	return 0;
> > >  }
> > >  
> > > +static int madvise_pageout_pte_range(pmd_t *pmd, unsigned long addr,
> > > +				unsigned long end, struct mm_walk *walk)
> > > +{
> > > +	struct mmu_gather *tlb = walk->private;
> > > +	struct mm_struct *mm = tlb->mm;
> > > +	struct vm_area_struct *vma = walk->vma;
> > > +	pte_t *orig_pte, *pte, ptent;
> > > +	spinlock_t *ptl;
> > > +	LIST_HEAD(page_list);
> > > +	struct page *page;
> > > +	unsigned long next;
> > > +
> > > +	if (fatal_signal_pending(current))
> > > +		return -EINTR;
> > > +
> > > +	next = pmd_addr_end(addr, end);
> > > +	if (pmd_trans_huge(*pmd)) {
> > > +		pmd_t orig_pmd;
> > > +
> > > +		tlb_change_page_size(tlb, HPAGE_PMD_SIZE);
> > > +		ptl = pmd_trans_huge_lock(pmd, vma);
> > > +		if (!ptl)
> > > +			return 0;
> > > +
> > > +		orig_pmd = *pmd;
> > > +		if (is_huge_zero_pmd(orig_pmd))
> > > +			goto huge_unlock;
> > > +
> > > +		if (unlikely(!pmd_present(orig_pmd))) {
> > > +			VM_BUG_ON(thp_migration_supported() &&
> > > +					!is_pmd_migration_entry(orig_pmd));
> > > +			goto huge_unlock;
> > > +		}
> > > +
> > > +		page = pmd_page(orig_pmd);
> > > +		if (next - addr != HPAGE_PMD_SIZE) {
> > > +			int err;
> > > +
> > > +			if (page_mapcount(page) != 1)
> > > +				goto huge_unlock;
> > > +			get_page(page);
> > > +			spin_unlock(ptl);
> > > +			lock_page(page);
> > > +			err = split_huge_page(page);
> > > +			unlock_page(page);
> > > +			put_page(page);
> > > +			if (!err)
> > > +				goto regular_page;
> > > +			return 0;
> > > +		}
> > > +
> > > +		if (isolate_lru_page(page))
> > > +			goto huge_unlock;
> > > +
> > > +		if (pmd_young(orig_pmd)) {
> > > +			pmdp_invalidate(vma, addr, pmd);
> > > +			orig_pmd = pmd_mkold(orig_pmd);
> > > +
> > > +			set_pmd_at(mm, addr, pmd, orig_pmd);
> > > +			tlb_remove_tlb_entry(tlb, pmd, addr);
> > > +		}
> > > +
> > > +		ClearPageReferenced(page);
> > > +		test_and_clear_page_young(page);
> > > +		list_add(&page->lru, &page_list);
> > > +huge_unlock:
> > > +		spin_unlock(ptl);
> > > +		reclaim_pages(&page_list);
> > > +		return 0;
> > > +	}
> > > +
> > > +	if (pmd_trans_unstable(pmd))
> > > +		return 0;
> > > +regular_page:
> > > +	tlb_change_page_size(tlb, PAGE_SIZE);
> > > +	orig_pte = pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
> > > +	flush_tlb_batched_pending(mm);
> > > +	arch_enter_lazy_mmu_mode();
> > > +	for (; addr < end; pte++, addr += PAGE_SIZE) {
> > > +		ptent = *pte;
> > > +		if (!pte_present(ptent))
> > > +			continue;
> > > +
> > > +		page = vm_normal_page(vma, addr, ptent);
> > > +		if (!page)
> > > +			continue;
> > > +
> > > +		/*
> > > +		 * creating a THP page is expensive so split it only if we
> > > +		 * are sure it's worth. Split it if we are only owner.
> > > +		 */
> > > +		if (PageTransCompound(page)) {
> > > +			if (page_mapcount(page) != 1)
> > > +				break;
> > > +			get_page(page);
> > > +			if (!trylock_page(page)) {
> > > +				put_page(page);
> > > +				break;
> > > +			}
> > > +			pte_unmap_unlock(orig_pte, ptl);
> > > +			if (split_huge_page(page)) {
> > > +				unlock_page(page);
> > > +				put_page(page);
> > > +				pte_offset_map_lock(mm, pmd, addr, &ptl);
> > > +				break;
> > > +			}
> > > +			unlock_page(page);
> > > +			put_page(page);
> > > +			pte = pte_offset_map_lock(mm, pmd, addr, &ptl);
> > > +			pte--;
> > > +			addr -= PAGE_SIZE;
> > > +			continue;
> > > +		}
> > > +
> > > +		VM_BUG_ON_PAGE(PageTransCompound(page), page);
> > > +
> > > +		if (isolate_lru_page(page))
> > > +			continue;
> > > +
> > > +		if (pte_young(ptent)) {
> > > +			ptent = ptep_get_and_clear_full(mm, addr, pte,
> > > +							tlb->fullmm);
> > > +			ptent = pte_mkold(ptent);
> > > +			set_pte_at(mm, addr, pte, ptent);
> > > +			tlb_remove_tlb_entry(tlb, pte, addr);
> > > +		}
> > > +		ClearPageReferenced(page);
> > > +		test_and_clear_page_young(page);
> > > +		list_add(&page->lru, &page_list);
> > > +	}
> > > +
> > > +	arch_leave_lazy_mmu_mode();
> > > +	pte_unmap_unlock(orig_pte, ptl);
> > > +	reclaim_pages(&page_list);
> > > +	cond_resched();
> > > +
> > > +	return 0;
> > > +}
> > 
> > I know you have briefly talked about code sharing already.
> > 
> > While I agree that sharing with MADV_FREE is maybe a stretch, I
> > applied these patches and compared the pageout and the cold page table
> > functions, and they are line for line the same EXCEPT for 2-3 lines at
> > the very end, where one reclaims and the other deactivates. It would
> > be good to share here, it shouldn't be hard or result in fragile code.
> 
> Fair enough if we leave MADV_FREE.
> 
> > 
> > Something like int madvise_cold_or_pageout_range(..., bool pageout)?
> 
> How about this?
> 
> From 41592f23e876ec21e49dc3c76dc89538e2bb16be Mon Sep 17 00:00:00 2001
> From: Minchan Kim <minchan@kernel.org>
> Date: Fri, 12 Jul 2019 14:05:36 +0900
> Subject: [PATCH] mm: factor out common parts between MADV_COLD and
>  MADV_PAGEOUT
> 
> There are many common parts between MADV_COLD and MADV_PAGEOUT.
> This patch factor them out to save code duplication.
> 
> Signed-off-by: Minchan Kim <minchan@kernel.org>

This looks much better, thanks!

> @@ -423,6 +445,12 @@ static int madvise_cold_pte_range(pmd_t *pmd, unsigned long addr,
>  
>  		VM_BUG_ON_PAGE(PageTransCompound(page), page);
>  
> +		if (pageout) {
> +			if (isolate_lru_page(page))
> +				continue;
> +			list_add(&page->lru, &page_list);
> +		}
> +
>  		if (pte_young(ptent)) {
>  			ptent = ptep_get_and_clear_full(mm, addr, pte,
>  							tlb->fullmm);

One thought on the ordering here.

When LRU isolation fails, it would still make sense to clear the young
bit: we cannot reclaim the page as we wanted to, but the user still
provided a clear hint that the page is cold and she won't be touching
it for a while. MADV_PAGEOUT is basically MADV_COLD + try_to_reclaim.
So IMO isolation should go to the end next to deactivate_page().
