From: Fan Du <fan.du-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/2] Add /proc/PID/{smaps, numa_maps} support for DAX
Date: Wed, 25 Oct 2017 08:27:35 +0800
Message-ID: <1508891255-15427-2-git-send-email-fan.du@intel.com>
References: <1508891255-15427-1-git-send-email-fan.du@intel.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1508891255-15427-1-git-send-email-fan.du-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Fan Du <fan.du-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

So user could check those interface for more detailed
information about how much DAX mappings are currently
created.

Here we use vma_is_dax method to find specific page
struture with DAX {huge, normal}page mappings,
vm_normal_page routine works as before without any
impact on the existing logical where _vm_normal_page
are called.

With this patch, user could check Device DAX usage at Ptes@ readings,
fox example, statistics from a Device DAX algined by 2MB:

7f6c17800000-7f6c17e00000 rw-s 00000000 00:06 20559  /dev/dax12.0
Size:               6144 kB
.
.
.
Ptes@2MB:      		6144 kB

Signed-off-by: Fan Du <fan.du-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
v3:
* Elaborate more about the usage suggested by Michal Hocko

v2:
* Using pte_devmap to check valid pfn page structure,
  Pointed out by Dan. thx!

---
 fs/proc/task_mmu.c | 24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 30dbf37..5c4535c 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -531,7 +531,10 @@ static void smaps_pte_entry(pte_t *pte, unsigned long addr,
 	struct page *page = NULL;
 
 	if (pte_present(*pte)) {
-		page = vm_normal_page(vma, addr, *pte);
+		if (!vma_is_dax(vma))
+			page = vm_normal_page(vma, addr, *pte);
+		else if (pte_devmap(*pte))
+			page = pte_page(*pte);
 		mss->rss_pte += PAGE_SIZE;
 	} else if (is_swap_pte(*pte)) {
 		swp_entry_t swpent = pte_to_swp_entry(*pte);
@@ -583,7 +586,11 @@ static void smaps_pmd_entry(pmd_t *pmd, unsigned long addr,
 	struct page *page;
 
 	/* FOLL_DUMP will return -EFAULT on huge zero page */
-	page = follow_trans_huge_pmd(vma, addr, pmd, FOLL_DUMP);
+	if (!vma_is_dax(vma))
+		page = follow_trans_huge_pmd(vma, addr, pmd, FOLL_DUMP);
+	else if (pmd_devmap(*pmd))
+		page = pmd_page(*pmd);
+
 	if (IS_ERR_OR_NULL(page))
 		return;
 	if (PageAnon(page))
@@ -1770,13 +1777,15 @@ static int gather_pte_stats(pmd_t *pmd, unsigned long addr,
 	spinlock_t *ptl;
 	pte_t *orig_pte;
 	pte_t *pte;
+	struct page *page;
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	ptl = pmd_trans_huge_lock(pmd, vma);
 	if (ptl) {
-		struct page *page;
-
-		page = can_gather_numa_stats_pmd(*pmd, vma, addr);
+		if (!vma_is_dax(vma))
+			page = can_gather_numa_stats_pmd(*pmd, vma, addr);
+		else if (pmd_devmap(*pmd))
+			page = pmd_page(*pmd);
 		if (page)
 			gather_stats(page, md, pmd_dirty(*pmd),
 				     HPAGE_PMD_SIZE/PAGE_SIZE);
@@ -1789,7 +1798,10 @@ static int gather_pte_stats(pmd_t *pmd, unsigned long addr,
 #endif
 	orig_pte = pte = pte_offset_map_lock(walk->mm, pmd, addr, &ptl);
 	do {
-		struct page *page = can_gather_numa_stats(*pte, vma, addr);
+		if (!vma_is_dax(vma))
+			page = can_gather_numa_stats(*pte, vma, addr);
+		else if (pte_devmap(*pte))
+			page = pte_page(*pte);
 		if (!page)
 			continue;
 		gather_stats(page, md, pte_dirty(*pte), 1);
-- 
1.8.3.1
