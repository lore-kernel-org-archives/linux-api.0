From: "Joel Fernandes (Google)" <joel@joelfernandes.org>
Subject: [PATCH v5 3/6] [RFC] x86: Add support for idle bit in swap PTE
Date: Wed,  7 Aug 2019 13:15:56 -0400
Message-ID: <20190807171559.182301-3-joel@joelfernandes.org>
References: <20190807171559.182301-1-joel@joelfernandes.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190807171559.182301-1-joel@joelfernandes.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: "Joel Fernandes (Google)" <joel@joelfernandes.org>, Alexey Dobriyan <adobriyan@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Borislav Petkov <bp@alien8.de>, Brendan Gregg <bgregg@netflix.com>, Catalin Marinas <catalin.marinas@arm.com>, Christian Hansen <chansen3@cisco.com>, dancol@google.com, fmayer@google.com, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, joelaf@google.com, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, kernel-team@android.com, linux-api@vger.kernel.org, linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@linux.ibm.com>, minchan@kernel.org, namhyung@google.com, paulmck@linux.ibm.com, Robin Murphy <robin.murphy@arm>
List-Id: linux-api@vger.kernel.org

This bit will be used by idle page tracking code to correctly identify
if a page that was swapped out was idle before it got swapped out.
Without this PTE bit, we lose information about if a page is idle or not
since the page frame gets unmapped and the page gets freed.

Bits 2-6 are unused in the swap PTE (see the comment in
arch/x86/include/asm/pgtable_64.h). Bit 2 corresponds to _PAGE_USER. Use
it for swap PTE purposes.

Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
---
 arch/x86/Kconfig                     |  1 +
 arch/x86/include/asm/pgtable.h       | 15 +++++++++++++++
 arch/x86/include/asm/pgtable_types.h |  6 ++++++
 3 files changed, 22 insertions(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 222855cc0158..728f22370f17 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -139,6 +139,7 @@ config X86
 	select HAVE_ARCH_MMAP_RND_COMPAT_BITS	if MMU && COMPAT
 	select HAVE_ARCH_COMPAT_MMAP_BASES	if MMU && COMPAT
 	select HAVE_ARCH_PREL32_RELOCATIONS
+	select HAVE_ARCH_PTE_SWP_PGIDLE
 	select HAVE_ARCH_SECCOMP_FILTER
 	select HAVE_ARCH_THREAD_STRUCT_WHITELIST
 	select HAVE_ARCH_STACKLEAK
diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index 0bc530c4eb13..ef3e662cee4a 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -1371,6 +1371,21 @@ static inline pmd_t pmd_swp_clear_soft_dirty(pmd_t pmd)
 #endif
 #endif
 
+static inline pte_t pte_swp_mkpage_idle(pte_t pte)
+{
+	return pte_set_flags(pte, _PAGE_SWP_PGIDLE);
+}
+
+static inline int pte_swp_page_idle(pte_t pte)
+{
+	return pte_flags(pte) & _PAGE_SWP_PGIDLE;
+}
+
+static inline pte_t pte_swp_clear_mkpage_idle(pte_t pte)
+{
+	return pte_clear_flags(pte, _PAGE_SWP_PGIDLE);
+}
+
 #define PKRU_AD_BIT 0x1
 #define PKRU_WD_BIT 0x2
 #define PKRU_BITS_PER_PKEY 2
diff --git a/arch/x86/include/asm/pgtable_types.h b/arch/x86/include/asm/pgtable_types.h
index b5e49e6bac63..6739cba4c900 100644
--- a/arch/x86/include/asm/pgtable_types.h
+++ b/arch/x86/include/asm/pgtable_types.h
@@ -100,6 +100,12 @@
 #define _PAGE_SWP_SOFT_DIRTY	(_AT(pteval_t, 0))
 #endif
 
+#ifdef CONFIG_IDLE_PAGE_TRACKING
+#define _PAGE_SWP_PGIDLE	_PAGE_USER
+#else
+#define _PAGE_SWP_PGIDLE	(_AT(pteval_t, 0))
+#endif
+
 #if defined(CONFIG_X86_64) || defined(CONFIG_X86_PAE)
 #define _PAGE_NX	(_AT(pteval_t, 1) << _PAGE_BIT_NX)
 #define _PAGE_DEVMAP	(_AT(u64, 1) << _PAGE_BIT_DEVMAP)
-- 
2.22.0.770.g0f2c4a37fd-goog
