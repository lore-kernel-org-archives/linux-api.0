From: "Mike Rapoport" <rppt@linux.vnet.ibm.com>
Subject: [PATCH v2] mm: introduce MADV_RESET_HUGEPAGE
Date: Mon, 29 May 2017 08:32:04 +0300
Message-ID: <1496035924-27251-1-git-send-email-rppt@linux.vnet.ibm.com>
Return-path: <owner-linux-mm@kvack.org>
Sender: owner-linux-mm@kvack.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Andrea Arcangeli <aarcange@redhat.com>, Michal Hocko <mhocko@kernel.org>, Vlastimil Babka <vbabka@suse.cz>, linux-mm <linux-mm@kvack.org>, linux-api <linux-api@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Mike Rapoport <rppt@linux.vnet.ibm.com>
List-Id: linux-api@vger.kernel.org

Currently applications can explicitly enable or disable THP for a memory
region using MADV_HUGEPAGE or MADV_NOHUGEPAGE. However, once either of
these advises is used, the region will always have
VM_HUGEPAGE/VM_NOHUGEPAGE flag set in vma->vm_flags.
The MADV_RESET_HUGEPAGE resets both these flags and allows managing THP in
the region according to system-wide settings.

Signed-off-by: Mike Rapoport <rppt@linux.vnet.ibm.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---

v2 changes:
* Use _RESET_ instead of _CLR_ as per Kirill's suggestion
* Fix build on arches that do not include mman-common.h


 arch/alpha/include/uapi/asm/mman.h     | 3 +++
 arch/mips/include/uapi/asm/mman.h      | 3 +++
 arch/parisc/include/uapi/asm/mman.h    | 3 +++
 arch/xtensa/include/uapi/asm/mman.h    | 3 +++
 include/uapi/asm-generic/mman-common.h | 3 +++
 mm/khugepaged.c                        | 7 +++++++
 mm/madvise.c                           | 5 +++++
 7 files changed, 27 insertions(+)

diff --git a/arch/alpha/include/uapi/asm/mman.h b/arch/alpha/include/uapi/asm/mman.h
index 02760f6..cb3095f 100644
--- a/arch/alpha/include/uapi/asm/mman.h
+++ b/arch/alpha/include/uapi/asm/mman.h
@@ -64,6 +64,9 @@
 					   overrides the coredump filter bits */
 #define MADV_DODUMP	17		/* Clear the MADV_NODUMP flag */
 
+#define MADV_RESET_HUGEPAGE 18		/* Reset flags controlling backing with
+					   hugepages */
+
 /* compatibility flags */
 #define MAP_FILE	0
 
diff --git a/arch/mips/include/uapi/asm/mman.h b/arch/mips/include/uapi/asm/mman.h
index 655e2fb..b5a181b 100644
--- a/arch/mips/include/uapi/asm/mman.h
+++ b/arch/mips/include/uapi/asm/mman.h
@@ -91,6 +91,9 @@
 					   overrides the coredump filter bits */
 #define MADV_DODUMP	17		/* Clear the MADV_NODUMP flag */
 
+#define MADV_RESET_HUGEPAGE 18		/* Reset flags controlling backing with
+					   hugepages */
+
 /* compatibility flags */
 #define MAP_FILE	0
 
diff --git a/arch/parisc/include/uapi/asm/mman.h b/arch/parisc/include/uapi/asm/mman.h
index 5979745..d671906 100644
--- a/arch/parisc/include/uapi/asm/mman.h
+++ b/arch/parisc/include/uapi/asm/mman.h
@@ -60,6 +60,9 @@
 					   overrides the coredump filter bits */
 #define MADV_DODUMP	70		/* Clear the MADV_NODUMP flag */
 
+#define MADV_RESET_HUGEPAGE 71		/* Reset flags controlling backing with
+					   hugepages */
+
 /* compatibility flags */
 #define MAP_FILE	0
 #define MAP_VARIABLE	0
diff --git a/arch/xtensa/include/uapi/asm/mman.h b/arch/xtensa/include/uapi/asm/mman.h
index 24365b3..9c038d0 100644
--- a/arch/xtensa/include/uapi/asm/mman.h
+++ b/arch/xtensa/include/uapi/asm/mman.h
@@ -103,6 +103,9 @@
 					   overrides the coredump filter bits */
 #define MADV_DODUMP	17		/* Clear the MADV_NODUMP flag */
 
+#define MADV_RESET_HUGEPAGE 18		/* Reset flags controlling backing with
+					   hugepages */
+
 /* compatibility flags */
 #define MAP_FILE	0
 
diff --git a/include/uapi/asm-generic/mman-common.h b/include/uapi/asm-generic/mman-common.h
index 8c27db0..fa62825 100644
--- a/include/uapi/asm-generic/mman-common.h
+++ b/include/uapi/asm-generic/mman-common.h
@@ -58,6 +58,9 @@
 					   overrides the coredump filter bits */
 #define MADV_DODUMP	17		/* Clear the MADV_DONTDUMP flag */
 
+#define MADV_RESET_HUGEPAGE 18		/* Reset flags controlling backing with
+					   hugepages */
+
 /* compatibility flags */
 #define MAP_FILE	0
 
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 945fd1c..32c66e7 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -336,6 +336,13 @@ int hugepage_madvise(struct vm_area_struct *vma,
 		 * it got registered before VM_NOHUGEPAGE was set.
 		 */
 		break;
+	case MADV_RESET_HUGEPAGE:
+		*vm_flags &= ~(VM_HUGEPAGE | VM_NOHUGEPAGE);
+		/*
+		 * The vma will be treated according to the
+		 * system-wide settings in transparent_hugepage_flags
+		 */
+		break;
 	}
 
 	return 0;
diff --git a/mm/madvise.c b/mm/madvise.c
index 25b78ee..6d6dd09 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -105,6 +105,7 @@ static long madvise_behavior(struct vm_area_struct *vma,
 		break;
 	case MADV_HUGEPAGE:
 	case MADV_NOHUGEPAGE:
+	case MADV_RESET_HUGEPAGE:
 		error = hugepage_madvise(vma, &new_flags, behavior);
 		if (error) {
 			/*
@@ -684,6 +685,7 @@ madvise_behavior_valid(int behavior)
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	case MADV_HUGEPAGE:
 	case MADV_NOHUGEPAGE:
+	case MADV_RESET_HUGEPAGE:
 #endif
 	case MADV_DONTDUMP:
 	case MADV_DODUMP:
@@ -739,6 +741,9 @@ madvise_behavior_valid(int behavior)
  *  MADV_NOHUGEPAGE - mark the given range as not worth being backed by
  *		transparent huge pages so the existing pages will not be
  *		coalesced into THP and new pages will not be allocated as THP.
+ *  MADV_RESET_HUGEPAGE - clear MADV_HUGEPAGE/MADV_NOHUGEPAGE marking;
+ *		the range will be treated by khugepaged according to the
+ *		system wide settings
  *  MADV_DONTDUMP - the application wants to prevent pages in the given range
  *		from being included in its core dump.
  *  MADV_DODUMP - cancel MADV_DONTDUMP: no longer exclude from core dump.
-- 
2.7.4

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
