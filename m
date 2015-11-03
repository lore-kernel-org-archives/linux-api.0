From: Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/8] mm: support madvise(MADV_FREE)
Date: Tue, 3 Nov 2015 09:10:49 +0900
Message-ID: <20151103001049.GC17906@bbox>
References: <1446188504-28023-1-git-send-email-minchan@kernel.org>
 <1446188504-28023-2-git-send-email-minchan@kernel.org>
 <20151030164937.GA44946@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151030164937.GA44946-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Content-Disposition: inline
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shaohua Li <shli-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, zhangyanfei-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Jason Evans <je-b10kYP2dOMg@public.gmane.org>, Daniel Micay <danielmicay-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, yalin.wang2010-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Fri, Oct 30, 2015 at 09:49:37AM -0700, Shaohua Li wrote:
> On Fri, Oct 30, 2015 at 04:01:37PM +0900, Minchan Kim wrote:
> > +static int madvise_free_pte_range(pmd_t *pmd, unsigned long addr,
> > +				unsigned long end, struct mm_walk *walk)
> > +
> > +{
> > +	struct mmu_gather *tlb = walk->private;
> > +	struct mm_struct *mm = tlb->mm;
> > +	struct vm_area_struct *vma = walk->vma;
> > +	spinlock_t *ptl;
> > +	pte_t *pte, ptent;
> > +	struct page *page;
> > +
> > +	split_huge_page_pmd(vma, addr, pmd);
> > +	if (pmd_trans_unstable(pmd))
> > +		return 0;
> > +
> > +	pte = pte_offset_map_lock(mm, pmd, addr, &ptl);
> > +	arch_enter_lazy_mmu_mode();
> > +	for (; addr != end; pte++, addr += PAGE_SIZE) {
> > +		ptent = *pte;
> > +
> > +		if (!pte_present(ptent))
> > +			continue;
> > +
> > +		page = vm_normal_page(vma, addr, ptent);
> > +		if (!page)
> > +			continue;
> > +
> > +		if (PageSwapCache(page)) {
> > +			if (!trylock_page(page))
> > +				continue;
> > +
> > +			if (!try_to_free_swap(page)) {
> > +				unlock_page(page);
> > +				continue;
> > +			}
> > +
> > +			ClearPageDirty(page);
> > +			unlock_page(page);
> > +		}
> > +
> > +		/*
> > +		 * Some of architecture(ex, PPC) don't update TLB
> > +		 * with set_pte_at and tlb_remove_tlb_entry so for
> > +		 * the portability, remap the pte with old|clean
> > +		 * after pte clearing.
> > +		 */
> > +		ptent = ptep_get_and_clear_full(mm, addr, pte,
> > +						tlb->fullmm);
> > +		ptent = pte_mkold(ptent);
> > +		ptent = pte_mkclean(ptent);
> > +		set_pte_at(mm, addr, pte, ptent);
> > +		tlb_remove_tlb_entry(tlb, pte, addr);
> 
> The orginal ptent might not be dirty. In that case, the tlb_remove_tlb_entry
> is unnecessary, so please add a check. In practice, I saw more TLB flush with
> FREE compared to DONTNEED because of this issue.

Actually, it was my TODO but I forgot it. :(
I fixed for new version.
Thanks for the pointing out.

> 
> Thanks,
> Shaohua
