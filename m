From: Yu-cheng Yu <yu-cheng.yu@intel.com>
Subject: [RFC PATCH v9 10/27] x86/mm: Update pte_modify, pmd_modify, and _PAGE_CHG_MASK for _PAGE_DIRTY_SW
Date: Wed,  5 Feb 2020 10:19:18 -0800
Message-ID: <20200205181935.3712-11-yu-cheng.yu@intel.com>
References: <20200205181935.3712-1-yu-cheng.yu@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20200205181935.3712-1-yu-cheng.yu@intel.com>
Sender: linux-doc-owner@vger.kernel.org
To: x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@kernel.org>, Balbir Singh <bsingharora@gmail.com>, Borislav Petkov <bp@alien8.de>, Cyrill Gorcunov <gorcunov@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Eugene Syromiatnikov <esyr@redhat.com>, Florian Weimer <fweimer@redhat.com>, "H.J. Lu" <hjl.tools@gmail.com>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Mike Kravetz <mike.kravetz@oracle.com>, Nadav Amit <nadav.amit@gmail.com>
Cc: Yu-cheng Yu <yu-cheng.yu@intel.com>
List-Id: linux-api@vger.kernel.org

After the introduction of _PAGE_DIRTY_SW, pte_modify and pmd_modify need to
set the Dirty bit accordingly: if Shadow Stack is enabled and _PAGE_RW is
cleared, use _PAGE_DIRTY_SW; otherwise _PAGE_DIRTY_HW.

Since the Dirty bit is modify by pte_modify(), remove _PAGE_DIRTY_HW from
PAGE_CHG_MASK.

Signed-off-by: Yu-cheng Yu <yu-cheng.yu@intel.com>
---
 arch/x86/include/asm/pgtable.h       | 16 ++++++++++++++++
 arch/x86/include/asm/pgtable_types.h |  4 ++--
 2 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index 62aeb118bc36..2733e7ec16b3 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -702,6 +702,14 @@ static inline pte_t pte_modify(pte_t pte, pgprot_t newprot)
 	val &= _PAGE_CHG_MASK;
 	val |= check_pgprot(newprot) & ~_PAGE_CHG_MASK;
 	val = flip_protnone_guard(oldval, val, PTE_PFN_MASK);
+
+	if (pte_dirty(pte)) {
+		if (static_cpu_has(X86_FEATURE_SHSTK) && !(val & _PAGE_RW))
+			val |= _PAGE_DIRTY_SW;
+		else
+			val |= _PAGE_DIRTY_HW;
+	}
+
 	return __pte(val);
 }
 
@@ -712,6 +720,14 @@ static inline pmd_t pmd_modify(pmd_t pmd, pgprot_t newprot)
 	val &= _HPAGE_CHG_MASK;
 	val |= check_pgprot(newprot) & ~_HPAGE_CHG_MASK;
 	val = flip_protnone_guard(oldval, val, PHYSICAL_PMD_PAGE_MASK);
+
+	if (pmd_dirty(pmd)) {
+		if (static_cpu_has(X86_FEATURE_SHSTK) && !(val & _PAGE_RW))
+			val |= _PAGE_DIRTY_SW;
+		else
+			val |= _PAGE_DIRTY_HW;
+	}
+
 	return __pmd(val);
 }
 
diff --git a/arch/x86/include/asm/pgtable_types.h b/arch/x86/include/asm/pgtable_types.h
index 826823df917f..e7e28bf7e919 100644
--- a/arch/x86/include/asm/pgtable_types.h
+++ b/arch/x86/include/asm/pgtable_types.h
@@ -150,8 +150,8 @@
  * instance, and is *not* included in this mask since
  * pte_modify() does modify it.
  */
-#define _PAGE_CHG_MASK	(PTE_PFN_MASK | _PAGE_PCD | _PAGE_PWT |		\
-			 _PAGE_SPECIAL | _PAGE_ACCESSED | _PAGE_DIRTY_HW |	\
+#define _PAGE_CHG_MASK	(PTE_PFN_MASK | _PAGE_PCD | _PAGE_PWT |	\
+			 _PAGE_SPECIAL | _PAGE_ACCESSED |	\
 			 _PAGE_SOFT_DIRTY | _PAGE_DEVMAP)
 #define _HPAGE_CHG_MASK (_PAGE_CHG_MASK | _PAGE_PSE)
 
-- 
2.21.0
