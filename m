From: Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH v2 04/13] mm: free swp_entry in madvise_free
Date: Wed,  4 Nov 2015 10:25:58 +0900
Message-ID: <1446600367-7976-5-git-send-email-minchan@kernel.org>
References: <1446600367-7976-1-git-send-email-minchan@kernel.org>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1446600367-7976-1-git-send-email-minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Jason Evans <je-b10kYP2dOMg@public.gmane.org>, Daniel Micay <danielmicay-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Shaohua Li <shli-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, yalin.wang2010-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
List-Id: linux-api@vger.kernel.org

When I test below piece of code with 12 processes(ie, 512M * 12 = 6G
consume) on my (3G ram + 12 cpu + 8G swap, the madvise_free is siginficat
slower (ie, 2x times) than madvise_dontneed.

loop = 5;
mmap(512M);
while (loop--) {
        memset(512M);
        madvise(MADV_FREE or MADV_DONTNEED);
}

The reason is lots of swapin.

1) dontneed: 1,612 swapin
2) madvfree: 879,585 swapin

If we find hinted pages were already swapped out when syscall is called,
it's pointless to keep the swapped-out pages in pte.
Instead, let's free the cold page because swapin is more expensive
than (alloc page + zeroing).

With this patch, it reduced swapin from 879,585 to 1,878 so elapsed time

1) dontneed: 6.10user 233.50system 0:50.44elapsed
2) madvfree: 6.03user 401.17system 1:30.67elapsed
2) madvfree + below patch: 6.70user 339.14system 1:04.45elapsed

Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Acked-by: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 mm/madvise.c | 26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff --git a/mm/madvise.c b/mm/madvise.c
index a8813f7b37b3..6240a5de4a3a 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -270,6 +270,7 @@ static int madvise_free_pte_range(pmd_t *pmd, unsigned long addr,
 	spinlock_t *ptl;
 	pte_t *pte, ptent;
 	struct page *page;
+	int nr_swap = 0;
 
 	split_huge_page_pmd(vma, addr, pmd);
 	if (pmd_trans_unstable(pmd))
@@ -280,8 +281,24 @@ static int madvise_free_pte_range(pmd_t *pmd, unsigned long addr,
 	for (; addr != end; pte++, addr += PAGE_SIZE) {
 		ptent = *pte;
 
-		if (!pte_present(ptent))
+		if (pte_none(ptent))
 			continue;
+		/*
+		 * If the pte has swp_entry, just clear page table to
+		 * prevent swap-in which is more expensive rather than
+		 * (page allocation + zeroing).
+		 */
+		if (!pte_present(ptent)) {
+			swp_entry_t entry;
+
+			entry = pte_to_swp_entry(ptent);
+			if (non_swap_entry(entry))
+				continue;
+			nr_swap--;
+			free_swap_and_cache(entry);
+			pte_clear_not_present_full(mm, addr, pte, tlb->fullmm);
+			continue;
+		}
 
 		page = vm_normal_page(vma, addr, ptent);
 		if (!page)
@@ -317,6 +334,13 @@ static int madvise_free_pte_range(pmd_t *pmd, unsigned long addr,
 		}
 	}
 
+	if (nr_swap) {
+		if (current->mm == mm)
+			sync_mm_rss(mm);
+
+		add_mm_counter(mm, MM_SWAPENTS, nr_swap);
+	}
+
 	arch_leave_lazy_mmu_mode();
 	pte_unmap_unlock(pte - 1, ptl);
 	cond_resched();
-- 
1.9.1
