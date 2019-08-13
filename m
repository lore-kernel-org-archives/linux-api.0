From: Yu-cheng Yu <yu-cheng.yu@intel.com>
Subject: [PATCH v8 16/27] mm: Handle THP/HugeTLB shadow stack page fault
Date: Tue, 13 Aug 2019 13:52:14 -0700
Message-ID: <20190813205225.12032-17-yu-cheng.yu@intel.com>
References: <20190813205225.12032-1-yu-cheng.yu@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190813205225.12032-1-yu-cheng.yu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@amacapital.net>, Balbir Singh <bsingharora@gmail.com>, Borislav Petkov <bp@alien8.de>, Cyrill Gorcunov <gorcunov@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Eugene Syromiatnikov <esyr@redhat.com>, Florian Weimer <fweimer@redhat.com>, "H.J. Lu" <hjl.tools@gmail.com>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Mike Kravetz <mike.kravetz@oracle.com>, Nadav Amit <nadav.amit@gmail.com>
Cc: Yu-cheng Yu <yu-cheng.yu@intel.com>
List-Id: linux-api@vger.kernel.org

This patch implements THP shadow stack (SHSTK) copying in the same
way as in the previous patch for regular PTE.

In copy_huge_pmd(), clear the dirty bit from the PMD to cause a page
fault upon the next SHSTK access to the PMD.  At that time, fix the
PMD and copy/re-use the page.

Signed-off-by: Yu-cheng Yu <yu-cheng.yu@intel.com>
---
 arch/x86/mm/pgtable.c         | 8 ++++++++
 include/asm-generic/pgtable.h | 6 ++++++
 mm/huge_memory.c              | 4 ++++
 3 files changed, 18 insertions(+)

diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
index 0c10d0c5e329..6f3959ca2a08 100644
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -886,6 +886,14 @@ inline pte_t pte_set_vma_features(pte_t pte, struct vm_area_struct *vma)
 		return pte;
 }
 
+inline pmd_t pmd_set_vma_features(pmd_t pmd, struct vm_area_struct *vma)
+{
+	if (vma->vm_flags & VM_SHSTK)
+		return pmd_mkdirty_shstk(pmd);
+	else
+		return pmd;
+}
+
 inline bool arch_copy_pte_mapping(vm_flags_t vm_flags)
 {
 	return (vm_flags & VM_SHSTK);
diff --git a/include/asm-generic/pgtable.h b/include/asm-generic/pgtable.h
index 89b0fa132f1f..438ce73b57ea 100644
--- a/include/asm-generic/pgtable.h
+++ b/include/asm-generic/pgtable.h
@@ -1194,12 +1194,18 @@ static inline pte_t pte_set_vma_features(pte_t pte, struct vm_area_struct *vma)
 	return pte;
 }
 
+static inline pmd_t pmd_set_vma_features(pmd_t pmd, struct vm_area_struct *vma)
+{
+	return pmd;
+}
+
 static inline bool arch_copy_pte_mapping(vm_flags_t vm_flags)
 {
 	return false;
 }
 #else
 pte_t pte_set_vma_features(pte_t pte, struct vm_area_struct *vma);
+pmd_t pmd_set_vma_features(pmd_t pmd, struct vm_area_struct *vma);
 bool arch_copy_pte_mapping(vm_flags_t vm_flags);
 #endif
 
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 1334ede667a8..39d66c628121 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -611,6 +611,7 @@ static vm_fault_t __do_huge_pmd_anonymous_page(struct vm_fault *vmf,
 
 		entry = mk_huge_pmd(page, vma->vm_page_prot);
 		entry = maybe_pmd_mkwrite(pmd_mkdirty(entry), vma);
+		entry = pmd_set_vma_features(entry, vma);
 		page_add_new_anon_rmap(page, vma, haddr, true);
 		mem_cgroup_commit_charge(page, memcg, false, true);
 		lru_cache_add_active_or_unevictable(page, vma);
@@ -1253,6 +1254,7 @@ static vm_fault_t do_huge_pmd_wp_page_fallback(struct vm_fault *vmf,
 		pte_t entry;
 		entry = mk_pte(pages[i], vma->vm_page_prot);
 		entry = maybe_mkwrite(pte_mkdirty(entry), vma);
+		entry = pte_set_vma_features(entry, vma);
 		memcg = (void *)page_private(pages[i]);
 		set_page_private(pages[i], 0);
 		page_add_new_anon_rmap(pages[i], vmf->vma, haddr, false);
@@ -1335,6 +1337,7 @@ vm_fault_t do_huge_pmd_wp_page(struct vm_fault *vmf, pmd_t orig_pmd)
 		pmd_t entry;
 		entry = pmd_mkyoung(orig_pmd);
 		entry = maybe_pmd_mkwrite(pmd_mkdirty(entry), vma);
+		entry = pmd_set_vma_features(entry, vma);
 		if (pmdp_set_access_flags(vma, haddr, vmf->pmd, entry,  1))
 			update_mmu_cache_pmd(vma, vmf->address, vmf->pmd);
 		ret |= VM_FAULT_WRITE;
@@ -1407,6 +1410,7 @@ vm_fault_t do_huge_pmd_wp_page(struct vm_fault *vmf, pmd_t orig_pmd)
 		pmd_t entry;
 		entry = mk_huge_pmd(new_page, vma->vm_page_prot);
 		entry = maybe_pmd_mkwrite(pmd_mkdirty(entry), vma);
+		entry = pmd_set_vma_features(entry, vma);
 		pmdp_huge_clear_flush_notify(vma, haddr, vmf->pmd);
 		page_add_new_anon_rmap(new_page, vma, haddr, true);
 		mem_cgroup_commit_charge(new_page, memcg, false, true);
-- 
2.17.1
