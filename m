From: Yu-cheng Yu <yu-cheng.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [RFC PATCH v9 12/27] x86/mm: Modify ptep_set_wrprotect and pmdp_set_wrprotect for _PAGE_DIRTY_SW
Date: Wed,  5 Feb 2020 10:19:20 -0800
Message-ID: <20200205181935.3712-13-yu-cheng.yu@intel.com>
References: <20200205181935.3712-1-yu-cheng.yu@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20200205181935.3712-1-yu-cheng.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Cyrill Gorcunov <gorcunov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Eugene Syromiatnikov <esyr-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Florian Weimer <fweimer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H.J. Lu" <hjl.tools-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jann Horn <jannh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Mike Kravetz <mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Nadav Amit <nadav.amit-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Yu-cheng Yu <yu-cheng.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

When Shadow Stack (SHSTK) is enabled, the [R/O + PAGE_DIRTY_HW] setting is
reserved only for SHSTK.  Non-Shadow Stack R/O PTEs are
[R/O + PAGE_DIRTY_SW].

When a PTE goes from [R/W + PAGE_DIRTY_HW] to [R/O + PAGE_DIRTY_SW], it
could become a transient SHSTK PTE in two cases.

The first case is that some processors can start a write but end up seeing
a read-only PTE by the time they get to the Dirty bit, creating a transient
SHSTK PTE.  However, this will not occur on processors supporting SHSTK
therefore we don't need a TLB flush here.

The second case is that when the software, without atomic, tests & replaces
PAGE_DIRTY_HW with PAGE_DIRTY_SW, a transient SHSTK PTE can exist.  This is
prevented with cmpxchg.

Dave Hansen, Jann Horn, Andy Lutomirski, and Peter Zijlstra provided many
insights to the issue.  Jann Horn provided the cmpxchg solution.

v9:
- Change compile-time conditionals to runtime checks.
- Fix parameters of try_cmpxchg(): change pte_t/pmd_t to
  pte_t.pte/pmd_t.pmd.

v4:
- Implement try_cmpxchg().

Signed-off-by: Yu-cheng Yu <yu-cheng.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 arch/x86/include/asm/pgtable.h | 66 ++++++++++++++++++++++++++++++++++
 1 file changed, 66 insertions(+)

diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index 2733e7ec16b3..43cb27379208 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -1253,6 +1253,39 @@ static inline pte_t ptep_get_and_clear_full(struct mm_struct *mm,
 static inline void ptep_set_wrprotect(struct mm_struct *mm,
 				      unsigned long addr, pte_t *ptep)
 {
+	/*
+	 * Some processors can start a write, but end up seeing a read-only
+	 * PTE by the time they get to the Dirty bit.  In this case, they
+	 * will set the Dirty bit, leaving a read-only, Dirty PTE which
+	 * looks like a Shadow Stack PTE.
+	 *
+	 * However, this behavior has been improved and will not occur on
+	 * processors supporting Shadow Stack.  Without this guarantee, a
+	 * transition to a non-present PTE and flush the TLB would be
+	 * needed.
+	 *
+	 * When changing a writable PTE to read-only and if the PTE has
+	 * _PAGE_DIRTY_HW set, we move that bit to _PAGE_DIRTY_SW so that
+	 * the PTE is not a valid Shadow Stack PTE.
+	 */
+#ifdef CONFIG_X86_64
+	if (static_cpu_has(X86_FEATURE_SHSTK)) {
+		pte_t new_pte, pte = READ_ONCE(*ptep);
+
+		do {
+			/*
+			 * This is the same as moving _PAGE_DIRTY_HW
+			 * to _PAGE_DIRTY_SW.
+			 */
+			new_pte = pte_wrprotect(pte);
+			new_pte.pte |= (new_pte.pte & _PAGE_DIRTY_HW) >>
+					_PAGE_BIT_DIRTY_HW << _PAGE_BIT_DIRTY_SW;
+			new_pte.pte &= ~_PAGE_DIRTY_HW;
+		} while (!try_cmpxchg(&ptep->pte, &pte.pte, new_pte.pte));
+
+		return;
+	}
+#endif
 	clear_bit(_PAGE_BIT_RW, (unsigned long *)&ptep->pte);
 }
 
@@ -1303,6 +1336,39 @@ static inline pud_t pudp_huge_get_and_clear(struct mm_struct *mm,
 static inline void pmdp_set_wrprotect(struct mm_struct *mm,
 				      unsigned long addr, pmd_t *pmdp)
 {
+	/*
+	 * Some processors can start a write, but end up seeing a read-only
+	 * PMD by the time they get to the Dirty bit.  In this case, they
+	 * will set the Dirty bit, leaving a read-only, Dirty PMD which
+	 * looks like a Shadow Stack PMD.
+	 *
+	 * However, this behavior has been improved and will not occur on
+	 * processors supporting Shadow Stack.  Without this guarantee, a
+	 * transition to a non-present PMD and flush the TLB would be
+	 * needed.
+	 *
+	 * When changing a writable PMD to read-only and if the PMD has
+	 * _PAGE_DIRTY_HW set, we move that bit to _PAGE_DIRTY_SW so that
+	 * the PMD is not a valid Shadow Stack PMD.
+	 */
+#ifdef CONFIG_X86_64
+	if (static_cpu_has(X86_FEATURE_SHSTK)) {
+		pmd_t new_pmd, pmd = READ_ONCE(*pmdp);
+
+		do {
+			/*
+			 * This is the same as moving _PAGE_DIRTY_HW
+			 * to _PAGE_DIRTY_SW.
+			 */
+			new_pmd = pmd_wrprotect(pmd);
+			new_pmd.pmd |= (new_pmd.pmd & _PAGE_DIRTY_HW) >>
+					_PAGE_BIT_DIRTY_HW << _PAGE_BIT_DIRTY_SW;
+			new_pmd.pmd &= ~_PAGE_DIRTY_HW;
+		} while (!try_cmpxchg(&pmdp->pmd, &pmd.pmd, new_pmd.pmd));
+
+		return;
+	}
+#endif
 	clear_bit(_PAGE_BIT_RW, (unsigned long *)pmdp);
 }
 
-- 
2.21.0
