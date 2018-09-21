From: Yu-cheng Yu <yu-cheng.yu@intel.com>
Subject: [RFC PATCH v4 24/27] mm/mmap: Create a guard area between VMAs
Date: Fri, 21 Sep 2018 08:03:48 -0700
Message-ID: <20180921150351.20898-25-yu-cheng.yu@intel.com>
References: <20180921150351.20898-1-yu-cheng.yu@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180921150351.20898-1-yu-cheng.yu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@amacapital.net>, Balbir Singh <bsingharora@gmail.com>, Cyrill Gorcunov <gorcunov@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Florian Weimer <fweimer@redhat.com>, "H.J. Lu" <hjl.tools@gmail.com>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Mike Kravetz <mike.kravetz@oracle.com>, Nadav Amit <nadav.amit@gmail.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Machek <pavel@ucw.cz>Peter
Cc: Yu-cheng Yu <yu-cheng.yu@intel.com>
List-Id: linux-api@vger.kernel.org

Create a guard area between VMAs, to detect memory corruption.

Signed-off-by: Yu-cheng Yu <yu-cheng.yu@intel.com>
---
 include/linux/mm.h | 30 ++++++++++++++++++++----------
 1 file changed, 20 insertions(+), 10 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index c4cc07baccda..3a823bdae09d 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2443,24 +2443,34 @@ static inline struct vm_area_struct * find_vma_intersection(struct mm_struct * m
 static inline unsigned long vm_start_gap(struct vm_area_struct *vma)
 {
 	unsigned long vm_start = vma->vm_start;
+	unsigned long gap;
+
+	if (vma->vm_flags & VM_GROWSDOWN)
+		gap = stack_guard_gap;
+	else
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
+	unsigned long gap;
+
+	if (vma->vm_flags & VM_GROWSUP)
+		gap = stack_guard_gap;
+	else
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
 
-- 
2.17.1
