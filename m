From: Matthew Garrett <matthewgarrett@google.com>
Subject: [PATCH V3] mm: Allow userland to request that the kernel clear memory
 on release
Date: Thu, 25 Apr 2019 15:58:28 -0700
Message-ID: <20190425225828.212472-1-matthewgarrett@google.com>
References: <CACdnJuup-y1xAO93wr+nr6ARacxJ9YXgaceQK9TLktE7shab1w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CACdnJuup-y1xAO93wr+nr6ARacxJ9YXgaceQK9TLktE7shab1w@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Matthew Garrett <mjg59@google.com>
List-Id: linux-api@vger.kernel.org

From: Matthew Garrett <mjg59@google.com>

Applications that hold secrets and wish to avoid them leaking can use
mlock() to prevent the page from being pushed out to swap and
MADV_DONTDUMP to prevent it from being included in core dumps. Applications
can also use atexit() handlers to overwrite secrets on application exit.
However, if an attacker can reboot the system into another OS, they can
dump the contents of RAM and extract secrets. We can avoid this by setting
CONFIG_RESET_ATTACK_MITIGATION on UEFI systems in order to request that the
firmware wipe the contents of RAM before booting another OS, but this means
rebooting takes a *long* time - the expected behaviour is for a clean
shutdown to remove the request after scrubbing secrets from RAM in order to
avoid this.

Unfortunately, if an application exits uncleanly, its secrets may still be
present in RAM. This can't be easily fixed in userland (eg, if the OOM
killer decides to kill a process holding secrets, we're not going to be able
to avoid that), so this patch adds a new flag to madvise() to allow userland
to request that the kernel clear the covered pages whenever the page
map count hits zero. Since vm_flags is already full on 32-bit, it
will only work on 64-bit systems. This is currently only permitted on
private mappings that have not yet been populated in order to simplify
implementation, which should suffice for the envisaged use cases. We can
extend the behaviour later if we come up with a robust set of semantics.

Signed-off-by: Matthew Garrett <mjg59@google.com>
---

Updated based on feedback from Jann - for now let's just prevent setting
the flag on anything that has already mapped some pages, which avoids
child processes being able to interfere with the parent. In addition,
move the page clearing logic into page_remove_rmap() to ensure that we
cover the full set of cases (eg, handling page migration properly).

 include/linux/mm.h                     |  6 ++++++
 include/linux/rmap.h                   |  2 +-
 include/uapi/asm-generic/mman-common.h |  2 ++
 kernel/events/uprobes.c                |  2 +-
 mm/huge_memory.c                       | 12 ++++++------
 mm/hugetlb.c                           |  4 ++--
 mm/khugepaged.c                        |  2 +-
 mm/ksm.c                               |  2 +-
 mm/madvise.c                           | 25 +++++++++++++++++++++++++
 mm/memory.c                            |  6 +++---
 mm/migrate.c                           |  4 ++--
 mm/rmap.c                              |  9 +++++++--
 12 files changed, 57 insertions(+), 19 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 6b10c21630f5..64bdab679275 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -257,6 +257,8 @@ extern unsigned int kobjsize(const void *objp);
 #define VM_HIGH_ARCH_2	BIT(VM_HIGH_ARCH_BIT_2)
 #define VM_HIGH_ARCH_3	BIT(VM_HIGH_ARCH_BIT_3)
 #define VM_HIGH_ARCH_4	BIT(VM_HIGH_ARCH_BIT_4)
+
+#define VM_WIPEONRELEASE BIT(37)       /* Clear pages when releasing them */
 #endif /* CONFIG_ARCH_USES_HIGH_VMA_FLAGS */
 
 #ifdef CONFIG_ARCH_HAS_PKEYS
@@ -298,6 +300,10 @@ extern unsigned int kobjsize(const void *objp);
 # define VM_GROWSUP	VM_NONE
 #endif
 
+#ifndef VM_WIPEONRELEASE
+# define VM_WIPEONRELEASE VM_NONE
+#endif
+
 /* Bits set in the VMA until the stack is in its final location */
 #define VM_STACK_INCOMPLETE_SETUP	(VM_RAND_READ | VM_SEQ_READ)
 
diff --git a/include/linux/rmap.h b/include/linux/rmap.h
index 988d176472df..abb47d623edd 100644
--- a/include/linux/rmap.h
+++ b/include/linux/rmap.h
@@ -177,7 +177,7 @@ void do_page_add_anon_rmap(struct page *, struct vm_area_struct *,
 void page_add_new_anon_rmap(struct page *, struct vm_area_struct *,
 		unsigned long, bool);
 void page_add_file_rmap(struct page *, bool);
-void page_remove_rmap(struct page *, bool);
+void page_remove_rmap(struct page *, struct vm_area_struct *, bool);
 
 void hugepage_add_anon_rmap(struct page *, struct vm_area_struct *,
 			    unsigned long);
diff --git a/include/uapi/asm-generic/mman-common.h b/include/uapi/asm-generic/mman-common.h
index abd238d0f7a4..82dfff4a8e3d 100644
--- a/include/uapi/asm-generic/mman-common.h
+++ b/include/uapi/asm-generic/mman-common.h
@@ -64,6 +64,8 @@
 #define MADV_WIPEONFORK 18		/* Zero memory on fork, child only */
 #define MADV_KEEPONFORK 19		/* Undo MADV_WIPEONFORK */
 
+#define MADV_WIPEONRELEASE 20
+#define MADV_DONTWIPEONRELEASE 21
 /* compatibility flags */
 #define MAP_FILE	0
 
diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index c5cde87329c7..2230a1717fe3 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -196,7 +196,7 @@ static int __replace_page(struct vm_area_struct *vma, unsigned long addr,
 	set_pte_at_notify(mm, addr, pvmw.pte,
 			mk_pte(new_page, vma->vm_page_prot));
 
-	page_remove_rmap(old_page, false);
+	page_remove_rmap(old_page, vma, false);
 	if (!page_mapped(old_page))
 		try_to_free_swap(old_page);
 	page_vma_mapped_walk_done(&pvmw);
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 165ea46bf149..1ad6ee5857b7 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1260,7 +1260,7 @@ static vm_fault_t do_huge_pmd_wp_page_fallback(struct vm_fault *vmf,
 
 	smp_wmb(); /* make pte visible before pmd */
 	pmd_populate(vma->vm_mm, vmf->pmd, pgtable);
-	page_remove_rmap(page, true);
+	page_remove_rmap(page, vma, true);
 	spin_unlock(vmf->ptl);
 
 	/*
@@ -1410,7 +1410,7 @@ vm_fault_t do_huge_pmd_wp_page(struct vm_fault *vmf, pmd_t orig_pmd)
 			add_mm_counter(vma->vm_mm, MM_ANONPAGES, HPAGE_PMD_NR);
 		} else {
 			VM_BUG_ON_PAGE(!PageHead(page), page);
-			page_remove_rmap(page, true);
+			page_remove_rmap(page, vma, true);
 			put_page(page);
 		}
 		ret |= VM_FAULT_WRITE;
@@ -1783,7 +1783,7 @@ int zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 
 		if (pmd_present(orig_pmd)) {
 			page = pmd_page(orig_pmd);
-			page_remove_rmap(page, true);
+			page_remove_rmap(page, vma, true);
 			VM_BUG_ON_PAGE(page_mapcount(page) < 0, page);
 			VM_BUG_ON_PAGE(!PageHead(page), page);
 		} else if (thp_migration_supported()) {
@@ -2146,7 +2146,7 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 			set_page_dirty(page);
 		if (!PageReferenced(page) && pmd_young(_pmd))
 			SetPageReferenced(page);
-		page_remove_rmap(page, true);
+		page_remove_rmap(page, vma, true);
 		put_page(page);
 		add_mm_counter(mm, mm_counter_file(page), -HPAGE_PMD_NR);
 		return;
@@ -2266,7 +2266,7 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 
 	if (freeze) {
 		for (i = 0; i < HPAGE_PMD_NR; i++) {
-			page_remove_rmap(page + i, false);
+			page_remove_rmap(page + i, vma, false);
 			put_page(page + i);
 		}
 	}
@@ -2954,7 +2954,7 @@ void set_pmd_migration_entry(struct page_vma_mapped_walk *pvmw,
 	if (pmd_soft_dirty(pmdval))
 		pmdswp = pmd_swp_mksoft_dirty(pmdswp);
 	set_pmd_at(mm, address, pvmw->pmd, pmdswp);
-	page_remove_rmap(page, true);
+	page_remove_rmap(page, vma, true);
 	put_page(page);
 }
 
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 6cdc7b2d9100..1df046525861 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3419,7 +3419,7 @@ void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
 			set_page_dirty(page);
 
 		hugetlb_count_sub(pages_per_huge_page(h), mm);
-		page_remove_rmap(page, true);
+		page_remove_rmap(page, vma, true);
 
 		spin_unlock(ptl);
 		tlb_remove_page_size(tlb, page, huge_page_size(h));
@@ -3643,7 +3643,7 @@ static vm_fault_t hugetlb_cow(struct mm_struct *mm, struct vm_area_struct *vma,
 		mmu_notifier_invalidate_range(mm, range.start, range.end);
 		set_huge_pte_at(mm, haddr, ptep,
 				make_huge_pte(vma, new_page, 1));
-		page_remove_rmap(old_page, true);
+		page_remove_rmap(old_page, vma, true);
 		hugepage_add_new_anon_rmap(new_page, vma, haddr);
 		set_page_huge_active(new_page);
 		/* Make the old page be freed below */
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 449044378782..20df74dfd954 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -673,7 +673,7 @@ static void __collapse_huge_page_copy(pte_t *pte, struct page *page,
 			 * superfluous.
 			 */
 			pte_clear(vma->vm_mm, address, _pte);
-			page_remove_rmap(src_page, false);
+			page_remove_rmap(src_page, vma, false);
 			spin_unlock(ptl);
 			free_page_and_swap_cache(src_page);
 		}
diff --git a/mm/ksm.c b/mm/ksm.c
index fc64874dc6f4..280705f65af7 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -1193,7 +1193,7 @@ static int replace_page(struct vm_area_struct *vma, struct page *page,
 	ptep_clear_flush(vma, addr, ptep);
 	set_pte_at_notify(mm, addr, ptep, newpte);
 
-	page_remove_rmap(page, false);
+	page_remove_rmap(page, vma, false);
 	if (!page_mapped(page))
 		try_to_free_swap(page);
 	put_page(page);
diff --git a/mm/madvise.c b/mm/madvise.c
index 21a7881a2db4..2a6e616e5c0d 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -92,6 +92,26 @@ static long madvise_behavior(struct vm_area_struct *vma,
 	case MADV_KEEPONFORK:
 		new_flags &= ~VM_WIPEONFORK;
 		break;
+	case MADV_WIPEONRELEASE:
+		/*
+		 * MADV_WIPEONRELEASE is only supported on as-yet unallocated
+		 * anonymous memory.
+		 */
+		if (VM_WIPEONRELEASE == 0 || vma->vm_file || vma->anon_vma ||
+		    vma->vm_flags & VM_SHARED) {
+			error = -EINVAL;
+			goto out;
+		}
+
+		new_flags |= VM_WIPEONRELEASE;
+		break;
+	case MADV_DONTWIPEONRELEASE:
+		if (VM_WIPEONRELEASE == 0) {
+			error = -EINVAL;
+			goto out;
+		}
+		new_flags &= ~VM_WIPEONRELEASE;
+		break;
 	case MADV_DONTDUMP:
 		new_flags |= VM_DONTDUMP;
 		break;
@@ -727,6 +747,8 @@ madvise_behavior_valid(int behavior)
 	case MADV_DODUMP:
 	case MADV_WIPEONFORK:
 	case MADV_KEEPONFORK:
+	case MADV_WIPEONRELEASE:
+	case MADV_DONTWIPEONRELEASE:
 #ifdef CONFIG_MEMORY_FAILURE
 	case MADV_SOFT_OFFLINE:
 	case MADV_HWPOISON:
@@ -785,6 +807,9 @@ madvise_behavior_valid(int behavior)
  *  MADV_DONTDUMP - the application wants to prevent pages in the given range
  *		from being included in its core dump.
  *  MADV_DODUMP - cancel MADV_DONTDUMP: no longer exclude from core dump.
+ *  MADV_WIPEONRELEASE - clear the contents of the memory after the last
+ *		reference to it has been released
+ *  MADV_DONTWIPEONRELEASE - cancel MADV_WIPEONRELEASE
  *
  * return values:
  *  zero    - success
diff --git a/mm/memory.c b/mm/memory.c
index ab650c21bccd..dd9555bb9aec 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1088,7 +1088,7 @@ static unsigned long zap_pte_range(struct mmu_gather *tlb,
 					mark_page_accessed(page);
 			}
 			rss[mm_counter(page)]--;
-			page_remove_rmap(page, false);
+			page_remove_rmap(page, vma, false);
 			if (unlikely(page_mapcount(page) < 0))
 				print_bad_pte(vma, addr, ptent, page);
 			if (unlikely(__tlb_remove_page(tlb, page))) {
@@ -1116,7 +1116,7 @@ static unsigned long zap_pte_range(struct mmu_gather *tlb,
 
 			pte_clear_not_present_full(mm, addr, pte, tlb->fullmm);
 			rss[mm_counter(page)]--;
-			page_remove_rmap(page, false);
+			page_remove_rmap(page, vma, false);
 			put_page(page);
 			continue;
 		}
@@ -2340,7 +2340,7 @@ static vm_fault_t wp_page_copy(struct vm_fault *vmf)
 			 * mapcount is visible. So transitively, TLBs to
 			 * old page will be flushed before it can be reused.
 			 */
-			page_remove_rmap(old_page, false);
+			page_remove_rmap(old_page, vma, false);
 		}
 
 		/* Free the old page.. */
diff --git a/mm/migrate.c b/mm/migrate.c
index 663a5449367a..5d3437a6541d 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -2083,7 +2083,7 @@ int migrate_misplaced_transhuge_page(struct mm_struct *mm,
 
 	page_ref_unfreeze(page, 2);
 	mlock_migrate_page(new_page, page);
-	page_remove_rmap(page, true);
+	page_remove_rmap(page, vma, true);
 	set_page_owner_migrate_reason(new_page, MR_NUMA_MISPLACED);
 
 	spin_unlock(ptl);
@@ -2313,7 +2313,7 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
 			 * drop page refcount. Page won't be freed, as we took
 			 * a reference just above.
 			 */
-			page_remove_rmap(page, false);
+			page_remove_rmap(page, vma, false);
 			put_page(page);
 
 			if (pte_present(pte))
diff --git a/mm/rmap.c b/mm/rmap.c
index b30c7c71d1d9..46dc9946a516 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1292,11 +1292,13 @@ static void page_remove_anon_compound_rmap(struct page *page)
 /**
  * page_remove_rmap - take down pte mapping from a page
  * @page:	page to remove mapping from
+ * @vma:	VMA the page belongs to
  * @compound:	uncharge the page as compound or small page
  *
  * The caller needs to hold the pte lock.
  */
-void page_remove_rmap(struct page *page, bool compound)
+void page_remove_rmap(struct page *page, struct vm_area_struct *vma,
+		      bool compound)
 {
 	if (!PageAnon(page))
 		return page_remove_file_rmap(page, compound);
@@ -1321,6 +1323,9 @@ void page_remove_rmap(struct page *page, bool compound)
 	if (PageTransCompound(page))
 		deferred_split_huge_page(compound_head(page));
 
+	if (unlikely(vma->vm_flags & VM_WIPEONRELEASE))
+		clear_highpage(page);
+
 	/*
 	 * It would be tidy to reset the PageAnon mapping here,
 	 * but that might overwrite a racing page_add_anon_rmap
@@ -1652,7 +1657,7 @@ static bool try_to_unmap_one(struct page *page, struct vm_area_struct *vma,
 		 *
 		 * See Documentation/vm/mmu_notifier.rst
 		 */
-		page_remove_rmap(subpage, PageHuge(page));
+		page_remove_rmap(subpage, vma, PageHuge(page));
 		put_page(page);
 	}
 
-- 
2.21.0.593.g511ec345e18-goog
