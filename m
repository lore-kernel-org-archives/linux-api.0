From: Yu-cheng Yu <yu-cheng.yu@intel.com>
Subject: [PATCH v5 07/27] mm/mmap: Create a guard area between VMAs
Date: Thu, 11 Oct 2018 08:15:03 -0700
Message-ID: <20181011151523.27101-8-yu-cheng.yu@intel.com>
References: <20181011151523.27101-1-yu-cheng.yu@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181011151523.27101-1-yu-cheng.yu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@amacapital.net>, Balbir Singh <bsingharora@gmail.com>, Cyrill Gorcunov <gorcunov@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Eugene Syromiatnikov <esyr@redhat.com>, Florian Weimer <fweimer@redhat.com>, "H.J. Lu" <hjl.tools@gmail.com>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Mike Kravetz <mike.kravetz@oracle.com>, Nadav Amit <nadav.amit@gmail.com>, Oleg Nesterov <oleg@redhat.com>, Pa
Cc: Yu-cheng Yu <yu-cheng.yu@intel.com>
List-Id: linux-api@vger.kernel.org

Create a guard area between VMAs to detect memory corruption.

Signed-off-by: Yu-cheng Yu <yu-cheng.yu@intel.com>
---
 include/linux/mm.h | 30 ++++++++++++++++++++----------
 mm/Kconfig         |  7 +++++++
 2 files changed, 27 insertions(+), 10 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 0416a7204be3..53cfc104c0fb 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2417,24 +2417,34 @@ static inline struct vm_area_struct * find_vma_intersection(struct mm_struct * m
 static inline unsigned long vm_start_gap(struct vm_area_struct *vma)
 {
 	unsigned long vm_start = vma->vm_start;
+	unsigned long gap = 0;
+
+	if (vma->vm_flags & VM_GROWSDOWN)
+		gap = stack_guard_gap;
+	else if (IS_ENABLED(CONFIG_VM_AREA_GUARD))
+		gap = PAGE_SIZE;
+
+	vm_start -= gap;
+	if (vm_start > vma->vm_start)
+		vm_start = 0;
 
-	if (vma->vm_flags & VM_GROWSDOWN) {
-		vm_start -= stack_guard_gap;
-		if (vm_start > vma->vm_start)
-			vm_start = 0;
-	}
 	return vm_start;
 }
 
 static inline unsigned long vm_end_gap(struct vm_area_struct *vma)
 {
 	unsigned long vm_end = vma->vm_end;
+	unsigned long gap = 0;
+
+	if (vma->vm_flags & VM_GROWSUP)
+		gap = stack_guard_gap;
+	else if (IS_ENABLED(CONFIG_VM_AREA_GUARD))
+		gap = PAGE_SIZE;
+
+	vm_end += gap;
+	if (vm_end < vma->vm_end)
+		vm_end = -PAGE_SIZE;
 
-	if (vma->vm_flags & VM_GROWSUP) {
-		vm_end += stack_guard_gap;
-		if (vm_end < vma->vm_end)
-			vm_end = -PAGE_SIZE;
-	}
 	return vm_end;
 }
 
diff --git a/mm/Kconfig b/mm/Kconfig
index de64ea658716..0cdcad65640d 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -764,4 +764,11 @@ config GUP_BENCHMARK
 config ARCH_HAS_PTE_SPECIAL
 	bool
 
+config VM_AREA_GUARD
+	bool "VM area guard"
+	default n
+	help
+	  Create a guard area between VM areas so that access beyond
+	  limit can be detected.
+
 endmenu
-- 
2.17.1
