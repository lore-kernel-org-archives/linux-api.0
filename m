From: Yu-cheng Yu <yu-cheng.yu@intel.com>
Subject: [PATCH v8 17/27] mm: Update can_follow_write_pte/pmd for shadow stack
Date: Tue, 13 Aug 2019 13:52:15 -0700
Message-ID: <20190813205225.12032-18-yu-cheng.yu@intel.com>
References: <20190813205225.12032-1-yu-cheng.yu@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190813205225.12032-1-yu-cheng.yu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@amacapital.net>, Balbir Singh <bsingharora@gmail.com>, Borislav Petkov <bp@alien8.de>, Cyrill Gorcunov <gorcunov@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Eugene Syromiatnikov <esyr@redhat.com>, Florian Weimer <fweimer@redhat.com>, "H.J. Lu" <hjl.tools@gmail.com>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Mike Kravetz <mike.kravetz@oracle.com>, Nadav Amit <nadav.amit@gmail.com>
Cc: Yu-cheng Yu <yu-cheng.yu@intel.com>
List-Id: linux-api@vger.kernel.org

can_follow_write_pte/pmd look for the (RO & DIRTY) PTE/PMD to
verify an exclusive RO page still exists after a broken COW.

A shadow stack PTE is RO & PAGE_DIRTY_SW when it is shared,
otherwise RO & PAGE_DIRTY_HW.

Introduce pte_exclusive() and pmd_exclusive() to also verify a
shadow stack PTE is exclusive.

Also rename can_follow_write_pte/pmd() to can_follow_write() to
make their meaning clear; i.e. "Can we write to the page?", not
"Is the PTE writable?"

Signed-off-by: Yu-cheng Yu <yu-cheng.yu@intel.com>
---
 arch/x86/mm/pgtable.c         | 18 ++++++++++++++++++
 include/asm-generic/pgtable.h | 12 ++++++++++++
 mm/gup.c                      |  8 +++++---
 mm/huge_memory.c              |  8 +++++---
 4 files changed, 40 insertions(+), 6 deletions(-)

diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
index 6f3959ca2a08..326715fd0c50 100644
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -898,4 +898,22 @@ inline bool arch_copy_pte_mapping(vm_flags_t vm_flags)
 {
 	return (vm_flags & VM_SHSTK);
 }
+
+inline bool pte_exclusive(pte_t pte, struct vm_area_struct *vma)
+{
+	if (vma->vm_flags & VM_SHSTK)
+		return pte_dirty_hw(pte);
+	else
+		return pte_dirty(pte);
+}
+
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+inline bool pmd_exclusive(pmd_t pmd, struct vm_area_struct *vma)
+{
+	if (vma->vm_flags & VM_SHSTK)
+		return pmd_dirty_hw(pmd);
+	else
+		return pmd_dirty(pmd);
+}
+#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 #endif /* CONFIG_X86_INTEL_SHADOW_STACK_USER */
diff --git a/include/asm-generic/pgtable.h b/include/asm-generic/pgtable.h
index 438ce73b57ea..b58f40525ebc 100644
--- a/include/asm-generic/pgtable.h
+++ b/include/asm-generic/pgtable.h
@@ -1203,10 +1203,22 @@ static inline bool arch_copy_pte_mapping(vm_flags_t vm_flags)
 {
 	return false;
 }
+
+static inline bool pte_exclusive(pte_t pte, struct vm_area_struct *vma)
+{
+	return pte_dirty(pte);
+}
+
+static inline bool pmd_exclusive(pmd_t pmd, struct vm_area_struct *vma)
+{
+	return pmd_dirty(pmd);
+}
 #else
 pte_t pte_set_vma_features(pte_t pte, struct vm_area_struct *vma);
 pmd_t pmd_set_vma_features(pmd_t pmd, struct vm_area_struct *vma);
 bool arch_copy_pte_mapping(vm_flags_t vm_flags);
+bool pte_exclusive(pte_t pte, struct vm_area_struct *vma);
+bool pmd_exclusive(pmd_t pmd, struct vm_area_struct *vma);
 #endif
 
 #endif /* _ASM_GENERIC_PGTABLE_H */
diff --git a/mm/gup.c b/mm/gup.c
index 98f13ab37bac..d7b298c5f6cb 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -179,10 +179,12 @@ static int follow_pfn_pte(struct vm_area_struct *vma, unsigned long address,
  * FOLL_FORCE can write to even unwritable pte's, but only
  * after we've gone through a COW cycle and they are dirty.
  */
-static inline bool can_follow_write_pte(pte_t pte, unsigned int flags)
+static inline bool can_follow_write(pte_t pte, unsigned int flags,
+				    struct vm_area_struct *vma)
 {
 	return pte_write(pte) ||
-		((flags & FOLL_FORCE) && (flags & FOLL_COW) && pte_dirty(pte));
+		((flags & FOLL_FORCE) && (flags & FOLL_COW) &&
+		 pte_exclusive(pte, vma));
 }
 
 static struct page *follow_page_pte(struct vm_area_struct *vma,
@@ -220,7 +222,7 @@ static struct page *follow_page_pte(struct vm_area_struct *vma,
 	}
 	if ((flags & FOLL_NUMA) && pte_protnone(pte))
 		goto no_page;
-	if ((flags & FOLL_WRITE) && !can_follow_write_pte(pte, flags)) {
+	if ((flags & FOLL_WRITE) && !can_follow_write(pte, flags, vma)) {
 		pte_unmap_unlock(ptep, ptl);
 		return NULL;
 	}
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 39d66c628121..947eb0121671 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1444,10 +1444,12 @@ vm_fault_t do_huge_pmd_wp_page(struct vm_fault *vmf, pmd_t orig_pmd)
  * FOLL_FORCE can write to even unwritable pmd's, but only
  * after we've gone through a COW cycle and they are dirty.
  */
-static inline bool can_follow_write_pmd(pmd_t pmd, unsigned int flags)
+static inline bool can_follow_write(pmd_t pmd, unsigned int flags,
+				    struct vm_area_struct *vma)
 {
 	return pmd_write(pmd) ||
-	       ((flags & FOLL_FORCE) && (flags & FOLL_COW) && pmd_dirty(pmd));
+	       ((flags & FOLL_FORCE) && (flags & FOLL_COW) &&
+		pmd_exclusive(pmd, vma));
 }
 
 struct page *follow_trans_huge_pmd(struct vm_area_struct *vma,
@@ -1460,7 +1462,7 @@ struct page *follow_trans_huge_pmd(struct vm_area_struct *vma,
 
 	assert_spin_locked(pmd_lockptr(mm, pmd));
 
-	if (flags & FOLL_WRITE && !can_follow_write_pmd(*pmd, flags))
+	if (flags & FOLL_WRITE && !can_follow_write(*pmd, flags, vma))
 		goto out;
 
 	/* Avoid dumping huge zero page */
-- 
2.17.1
