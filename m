From: Minchan Kim <minchan@kernel.org>
Subject: Re: [PATCH v17 7/7] mm: Don't split THP page when syscall is called
Date: Mon, 1 Dec 2014 09:11:55 +0900
Message-ID: <20141201001155.GA11340@bbox>
References: <1413799924-17946-1-git-send-email-minchan@kernel.org>
 <1413799924-17946-8-git-send-email-minchan@kernel.org>
 <20141127154921.GA11051@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20141127154921.GA11051@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
To: Michal Hocko <mhocko@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Michael Kerrisk <mtk.manpages@gmail.com>, linux-api@vger.kernel.org, Hugh Dickins <hughd@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@redhat.com>, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, Mel Gorman <mgorman@suse.de>, Jason Evans <je@fb.com>, zhangyanfei@cn.fujitsu.com, "Kirill A. Shutemov" <kirill@shutemov.name>, Andrea Arcangeli <aarcange@redhat.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
List-Id: linux-api@vger.kernel.org

On Thu, Nov 27, 2014 at 04:49:21PM +0100, Michal Hocko wrote:
> On Mon 20-10-14 19:12:04, Minchan Kim wrote:
> > We don't need to split THP page when MADV_FREE syscall is
> > called. It could be done when VM decide really frees it so
> > we could avoid unnecessary THP split.
> > 
> > Cc: Andrea Arcangeli <aarcange@redhat.com>
> > Acked-by: Rik van Riel <riel@redhat.com>
> > Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> > Signed-off-by: Minchan Kim <minchan@kernel.org>
> 
> Other than a minor comment below
> Reviewed-by: Michal Hocko <mhocko@suse.cz>

Thanks!

> 
> > ---
> >  include/linux/huge_mm.h |  4 ++++
> >  mm/huge_memory.c        | 35 +++++++++++++++++++++++++++++++++++
> >  mm/madvise.c            | 21 ++++++++++++++++++++-
> >  mm/rmap.c               |  8 ++++++--
> >  mm/vmscan.c             | 28 ++++++++++++++++++----------
> >  5 files changed, 83 insertions(+), 13 deletions(-)
> > 
> [...]
> > diff --git a/mm/madvise.c b/mm/madvise.c
> > index a21584235bb6..84badee5f46d 100644
> > --- a/mm/madvise.c
> > +++ b/mm/madvise.c
> > @@ -271,8 +271,26 @@ static int madvise_free_pte_range(pmd_t *pmd, unsigned long addr,
> >  	spinlock_t *ptl;
> >  	pte_t *pte, ptent;
> >  	struct page *page;
> > +	unsigned long next;
> > +
> > +	next = pmd_addr_end(addr, end);
> > +	if (pmd_trans_huge(*pmd)) {
> > +		if (next - addr != HPAGE_PMD_SIZE) {
> > +#ifdef CONFIG_DEBUG_VM
> > +			if (!rwsem_is_locked(&mm->mmap_sem)) {
> > +				pr_err("%s: mmap_sem is unlocked! addr=0x%lx end=0x%lx vma->vm_start=0x%lx vma->vm_end=0x%lx\n",
> > +					__func__, addr, end,
> > +					vma->vm_start,
> > +					vma->vm_end);
> > +				BUG();
> > +			}
> > +#endif
> 
> Why is this code here? madvise_free_pte_range is called only from the
> madvise path and we are holding mmap_sem and relying on that for regular
> pages as well.

Make sense.

>From 2ecc213a2c3634cbee7529055fd6348b03307ed5 Mon Sep 17 00:00:00 2001
From: Minchan Kim <minchan@kernel.org>
Date: Mon, 1 Dec 2014 09:07:18 +0900
Subject: [PATCH] mm: remove lock validation check for MADV_FREE

Curretnly, madvise_free_pte_range is called only madvise path
which already holds an mmap_sem so it's pointless to add the
lock validation check.

Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 mm/madvise.c | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/mm/madvise.c b/mm/madvise.c
index dc024effa9bf..6fc9b8298da1 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -275,18 +275,9 @@ static int madvise_free_pte_range(pmd_t *pmd, unsigned long addr,
 
 	next = pmd_addr_end(addr, end);
 	if (pmd_trans_huge(*pmd)) {
-		if (next - addr != HPAGE_PMD_SIZE) {
-#ifdef CONFIG_DEBUG_VM
-			if (!rwsem_is_locked(&mm->mmap_sem)) {
-				pr_err("%s: mmap_sem is unlocked! addr=0x%lx end=0x%lx vma->vm_start=0x%lx vma->vm_end=0x%lx\n",
-					__func__, addr, end,
-					vma->vm_start,
-					vma->vm_end);
-				BUG();
-			}
-#endif
+		if (next - addr != HPAGE_PMD_SIZE)
 			split_huge_page_pmd(vma, addr, pmd);
-		} else if (!madvise_free_huge_pmd(tlb, vma, pmd, addr))
+		else if (!madvise_free_huge_pmd(tlb, vma, pmd, addr))
 			goto next;
 		/* fall through */
 	}
-- 
2.0.0


-- 
Kind regards,
Minchan Kim

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
