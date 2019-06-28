From: Yu-cheng Yu <yu-cheng.yu@intel.com>
Subject: [RFC PATCH 1/3] mm: Introduce VM_IBT for CET legacy code bitmap
Date: Fri, 28 Jun 2019 12:41:56 -0700
Message-ID: <20190628194158.2431-1-yu-cheng.yu@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@amacapital.net>, Balbir Singh <bsingharora@gmail.com>, Borislav Petkov <bp@alien8.de>, Cyrill Gorcunov <gorcunov@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Eugene Syromiatnikov <esyr@redhat.com>, Florian Weimer <fweimer@redhat.com>, "H.J. Lu" <hjl.tools@gmail.com>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Mike Kravetz <mike.kravetz@oracle.com>, Nadav Amit <nadav.amit@gmail.com>
Cc: Yu-cheng Yu <yu-cheng.yu@intel.com>
List-Id: linux-api@vger.kernel.org

The previous discussion of the IBT legacy code bitmap is here:

    https://lkml.org/lkml/2019/6/6/1032

When CET Indirect Branch Tracking (IBT) is enabled, the processor expects
every branch target is an ENDBR instruction, or the target's address is
marked as legacy in the legacy code bitmap.  The bitmap covers the whole
user-mode address space (TASK_SIZE_MAX for 64-bit, TASK_SIZE for IA32),
and each bit represents one page of linear address range.

This patch introduces VM_IBT for the bitmap.

Signed-off-by: Yu-cheng Yu <yu-cheng.yu@intel.com>
---
 fs/proc/task_mmu.c | 3 +++
 include/linux/mm.h | 8 ++++++++
 2 files changed, 11 insertions(+)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 66725e262a77..d707390285d3 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -663,6 +663,9 @@ static void show_smap_vma_flags(struct seq_file *m, struct vm_area_struct *vma)
 #endif /* CONFIG_ARCH_HAS_PKEYS */
 #ifdef CONFIG_X86_INTEL_SHADOW_STACK_USER
 		[ilog2(VM_SHSTK)]	= "ss",
+#endif
+#ifdef CONFIG_X86_INTEL_BRANCH_TRACKING_USER
+		[ilog2(VM_IBT)]		= "bt",
 #endif
 	};
 	size_t i;
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 921bae5fa7ab..a8da5bdfd7c9 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -299,12 +299,14 @@ extern unsigned int kobjsize(const void *objp);
 #define VM_HIGH_ARCH_BIT_3	35	/* bit only usable on 64-bit architectures */
 #define VM_HIGH_ARCH_BIT_4	36	/* bit only usable on 64-bit architectures */
 #define VM_HIGH_ARCH_BIT_5	37	/* bit only usable on 64-bit architectures */
+#define VM_HIGH_ARCH_BIT_6	38	/* bit only usable on 64-bit architectures */
 #define VM_HIGH_ARCH_0	BIT(VM_HIGH_ARCH_BIT_0)
 #define VM_HIGH_ARCH_1	BIT(VM_HIGH_ARCH_BIT_1)
 #define VM_HIGH_ARCH_2	BIT(VM_HIGH_ARCH_BIT_2)
 #define VM_HIGH_ARCH_3	BIT(VM_HIGH_ARCH_BIT_3)
 #define VM_HIGH_ARCH_4	BIT(VM_HIGH_ARCH_BIT_4)
 #define VM_HIGH_ARCH_5	BIT(VM_HIGH_ARCH_BIT_5)
+#define VM_HIGH_ARCH_6	BIT(VM_HIGH_ARCH_BIT_6)
 #endif /* CONFIG_ARCH_USES_HIGH_VMA_FLAGS */
 
 #ifdef CONFIG_ARCH_HAS_PKEYS
@@ -348,6 +350,12 @@ extern unsigned int kobjsize(const void *objp);
 # define VM_SHSTK	VM_NONE
 #endif
 
+#ifdef CONFIG_X86_INTEL_BRANCH_TRACKING_USER
+# define VM_IBT		VM_HIGH_ARCH_6
+#else
+# define VM_IBT		VM_NONE
+#endif
+
 #ifndef VM_GROWSUP
 # define VM_GROWSUP	VM_NONE
 #endif
-- 
2.17.1
