From: Yu-cheng Yu <yu-cheng.yu@intel.com>
Subject: [RFC PATCH v2 16/27] mm: Modify can_follow_write_pte/pmd for shadow stack
Date: Tue, 10 Jul 2018 15:26:28 -0700
Message-ID: <20180710222639.8241-17-yu-cheng.yu@intel.com>
References: <20180710222639.8241-1-yu-cheng.yu@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180710222639.8241-1-yu-cheng.yu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@amacapital.net>, Balbir Singh <bsingharora@gmail.com>, Cyrill Gorcunov <gorcunov@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Florian Weimer <fweimer@redhat.com>, "H.J. Lu" <hjl.tools@gmail.com>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromiun.org>, Mike Kravetz <mike.kravetz@oracle.com>, Nadav Amit <nadav.amit@gmail.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Machek <pavel@ucw.cz>Peter
Cc: Yu-cheng Yu <yu-cheng.yu@intel.com>
List-Id: linux-api@vger.kernel.org

There are three possible shadow stack PTE settings:

  Normal SHSTK PTE: (R/O + DIRTY_HW)
  SHSTK PTE COW'ed: (R/O + DIRTY_HW)
  SHSTK PTE shared as R/O data: (R/O + DIRTY_SW)

Update can_follow_write_pte/pmd for the shadow stack.

Signed-off-by: Yu-cheng Yu <yu-cheng.yu@intel.com>
---
 mm/gup.c         | 11 ++++++++---
 mm/huge_memory.c | 10 +++++++---
 2 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index b70d7ba7cc13..00171ee847af 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -64,10 +64,13 @@ static int follow_pfn_pte(struct vm_area_struct *vma, unsigned long address,
  * FOLL_FORCE can write to even unwritable pte's, but only
  * after we've gone through a COW cycle and they are dirty.
  */
-static inline bool can_follow_write_pte(pte_t pte, unsigned int flags)
+static inline bool can_follow_write_pte(pte_t pte, unsigned int flags,
+					bool shstk)
 {
+	bool pte_cowed = shstk ? is_shstk_pte(pte):pte_dirty(pte);
+
 	return pte_write(pte) ||
-		((flags & FOLL_FORCE) && (flags & FOLL_COW) && pte_dirty(pte));
+		((flags & FOLL_FORCE) && (flags & FOLL_COW) && pte_cowed);
 }
 
 static struct page *follow_page_pte(struct vm_area_struct *vma,
@@ -78,7 +81,9 @@ static struct page *follow_page_pte(struct vm_area_struct *vma,
 	struct page *page;
 	spinlock_t *ptl;
 	pte_t *ptep, pte;
+	bool shstk;
 
+	shstk = is_shstk_mapping(vma->vm_flags);
 retry:
 	if (unlikely(pmd_bad(*pmd)))
 		return no_page_table(vma, flags);
@@ -105,7 +110,7 @@ static struct page *follow_page_pte(struct vm_area_struct *vma,
 	}
 	if ((flags & FOLL_NUMA) && pte_protnone(pte))
 		goto no_page;
-	if ((flags & FOLL_WRITE) && !can_follow_write_pte(pte, flags)) {
+	if ((flags & FOLL_WRITE) && !can_follow_write_pte(pte, flags, shstk)) {
 		pte_unmap_unlock(ptep, ptl);
 		return NULL;
 	}
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 7f3e11d3b64a..db4c689a960a 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1389,10 +1389,13 @@ int do_huge_pmd_wp_page(struct vm_fault *vmf, pmd_t orig_pmd)
  * FOLL_FORCE can write to even unwritable pmd's, but only
  * after we've gone through a COW cycle and they are dirty.
  */
-static inline bool can_follow_write_pmd(pmd_t pmd, unsigned int flags)
+static inline bool can_follow_write_pmd(pmd_t pmd, unsigned int flags,
+					bool shstk)
 {
+	bool pmd_cowed = shstk ? is_shstk_pmd(pmd):pmd_dirty(pmd);
+
 	return pmd_write(pmd) ||
-	       ((flags & FOLL_FORCE) && (flags & FOLL_COW) && pmd_dirty(pmd));
+	       ((flags & FOLL_FORCE) && (flags & FOLL_COW) && pmd_cowed);
 }
 
 struct page *follow_trans_huge_pmd(struct vm_area_struct *vma,
@@ -1402,10 +1405,11 @@ struct page *follow_trans_huge_pmd(struct vm_area_struct *vma,
 {
 	struct mm_struct *mm = vma->vm_mm;
 	struct page *page = NULL;
+	bool shstk = is_shstk_mapping(vma->vm_flags);
 
 	assert_spin_locked(pmd_lockptr(mm, pmd));
 
-	if (flags & FOLL_WRITE && !can_follow_write_pmd(*pmd, flags))
+	if (flags & FOLL_WRITE && !can_follow_write_pmd(*pmd, flags, shstk))
 		goto out;
 
 	/* Avoid dumping huge zero page */
-- 
2.17.1
