From: Yu-cheng Yu <yu-cheng.yu@intel.com>
Subject: [PATCH v7 05/14] mm/mmap: Add IBT bitmap size to address space limit check
Date: Thu,  6 Jun 2019 13:09:17 -0700
Message-ID: <20190606200926.4029-6-yu-cheng.yu@intel.com>
References: <20190606200926.4029-1-yu-cheng.yu@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190606200926.4029-1-yu-cheng.yu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@amacapital.net>, Balbir Singh <bsingharora@gmail.com>, Borislav Petkov <bp@alien8.de>, Cyrill Gorcunov <gorcunov@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Eugene Syromiatnikov <esyr@redhat.com>, Florian Weimer <fweimer@redhat.com>, "H.J. Lu" <hjl.tools@gmail.com>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Mike Kravetz <mike.kravetz@oracle.com>, Nadav Amit <nadav.amit@gmail.com>
Cc: Yu-cheng Yu <yu-cheng.yu@intel.com>
List-Id: linux-api@vger.kernel.org

The indirect branch tracking legacy bitmap takes a large address
space.  This causes may_expand_vm() failure on the address limit
check.  For a IBT-enabled task, add the bitmap size to the
address limit.

Signed-off-by: Yu-cheng Yu <yu-cheng.yu@intel.com>
---
 arch/x86/include/asm/mmu_context.h | 10 ++++++++++
 mm/mmap.c                          | 19 ++++++++++++++++++-
 2 files changed, 28 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/mmu_context.h b/arch/x86/include/asm/mmu_context.h
index a9a768529540..2499f6490428 100644
--- a/arch/x86/include/asm/mmu_context.h
+++ b/arch/x86/include/asm/mmu_context.h
@@ -360,6 +360,16 @@ static inline unsigned long __get_current_cr3_fast(void)
 	return cr3;
 }
 
+#ifdef CONFIG_X86_INTEL_BRANCH_TRACKING_USER
+static inline unsigned long arch_as_limit(void)
+{
+	if (current->thread.cet.ibt_enabled)
+		return current->thread.cet.ibt_bitmap_size;
+	else
+		return 0;
+}
+#endif
+
 typedef struct {
 	struct mm_struct *mm;
 } temp_mm_state_t;
diff --git a/mm/mmap.c b/mm/mmap.c
index 3b643ace2c49..a0d6fb559518 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -3283,13 +3283,30 @@ struct vm_area_struct *copy_vma(struct vm_area_struct **vmap,
 	return NULL;
 }
 
+#ifndef CONFIG_ARCH_HAS_AS_LIMIT
+static inline unsigned long arch_as_limit(void)
+{
+	return 0;
+}
+#endif
+
 /*
  * Return true if the calling process may expand its vm space by the passed
  * number of pages
  */
 bool may_expand_vm(struct mm_struct *mm, vm_flags_t flags, unsigned long npages)
 {
-	if (mm->total_vm + npages > rlimit(RLIMIT_AS) >> PAGE_SHIFT)
+	unsigned long as_limit = rlimit(RLIMIT_AS);
+	unsigned long as_limit_plus = as_limit + arch_as_limit();
+
+	/* as_limit_plus overflowed */
+	if (as_limit_plus < as_limit)
+		as_limit_plus = RLIM_INFINITY;
+
+	if (as_limit_plus > as_limit)
+		as_limit = as_limit_plus;
+
+	if (mm->total_vm + npages > as_limit >> PAGE_SHIFT)
 		return false;
 
 	if (is_data_mapping(flags) &&
-- 
2.17.1
