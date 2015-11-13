From: Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 01/17] mm: support madvise(MADV_FREE)
Date: Fri, 13 Nov 2015 15:17:19 +0900
Message-ID: <20151113061719.GC5235@bbox>
References: <1447302793-5376-1-git-send-email-minchan@kernel.org>
 <1447302793-5376-2-git-send-email-minchan@kernel.org>
 <20151112112620.GB22481@node.shutemov.name>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151112112620.GB22481-sVvlyX1904swdBt8bTSxpkEMvNT87kid@public.gmane.org>
Content-Disposition: inline
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Jason Evans <je-b10kYP2dOMg@public.gmane.org>, Daniel Micay <danielmicay-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Shaohua Li <shli-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, yalin.wang2010-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, Nov 12, 2015 at 01:26:20PM +0200, Kirill A. Shutemov wrote:
> On Thu, Nov 12, 2015 at 01:32:57PM +0900, Minchan Kim wrote:
> > @@ -256,6 +260,125 @@ static long madvise_willneed(struct vm_area_struct *vma,
> >  	return 0;
> >  }
> >  
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
> 
> Could you put VM_BUG_ON_PAGE(PageTransCompound(page), page) here?
> Just in case.

No problem.

> 
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
> 
> Hm. Do we handle pages shared over fork() here?
> Souldn't we ignore pages with mapcount > 0?

It was handled later patch by historical reason but it's better
to fold the patch to this.

Thanks for review!
