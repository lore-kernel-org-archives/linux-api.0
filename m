From: tip-bot for Andy Lutomirski <tipbot@zytor.com>
Subject: [tip:mm/urgent] mm: Change vm_is_stack_for_task() to
 vm_is_stack_for_current()
Date: Thu, 20 Oct 2016 04:14:25 -0700
Message-ID: <tip-d17af5056cf9e9fc05e68832f7c15687fcc12281@git.kernel.org>
References: <4c3f68f426e6c061ca98b4fc7ef85ffbb0a25b0c.1475257877.git.luto@kernel.org>
Reply-To: viro@zeniv.linux.org.uk, luto@kernel.org, tglx@linutronix.de,
          bp@alien8.de, torvalds@linux-foundation.org, hpa@zytor.com,
          tycho.andersen@canonical.com, brgerst@gmail.com,
          keescook@chromium.org, peterz@infradead.org,
          linux-kernel@vger.kernel.org, jann@thejh.net,
          linux-api@vger.kernel.org, mingo@kernel.org,
          akpm@linux-foundation.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4c3f68f426e6c061ca98b4fc7ef85ffbb0a25b0c.1475257877.git.luto@kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: linux-tip-commits@vger.kernel.org
Cc: luto@kernel.org, viro@zeniv.linux.org.uk, tglx@linutronix.de, bp@alien8.de, torvalds@linux-foundation.org, hpa@zytor.com, tycho.andersen@canonical.com, brgerst@gmail.com, keescook@chromium.org, peterz@infradead.org, linux-kernel@vger.kernel.org, jann@thejh.net, linux-api@vger.kernel.org, akpm@linux-foundation.org, mingo@kernel.org
List-Id: linux-api@vger.kernel.org

Commit-ID:  d17af5056cf9e9fc05e68832f7c15687fcc12281
Gitweb:     http://git.kernel.org/tip/d17af5056cf9e9fc05e68832f7c15687fcc12281
Author:     Andy Lutomirski <luto@kernel.org>
AuthorDate: Fri, 30 Sep 2016 10:58:58 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 20 Oct 2016 09:21:41 +0200

mm: Change vm_is_stack_for_task() to vm_is_stack_for_current()

Asking for a non-current task's stack can't be done without races
unless the task is frozen in kernel mode.  As far as I know,
vm_is_stack_for_task() never had a safe non-current use case.

The __unused annotation is because some KSTK_ESP implementations
ignore their parameter, which IMO is further justification for this
patch.

Signed-off-by: Andy Lutomirski <luto@kernel.org>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Brian Gerst <brgerst@gmail.com>
Cc: Jann Horn <jann@thejh.net>
Cc: Kees Cook <keescook@chromium.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux API <linux-api@vger.kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Tycho Andersen <tycho.andersen@canonical.com>
Link: http://lkml.kernel.org/r/4c3f68f426e6c061ca98b4fc7ef85ffbb0a25b0c.1475257877.git.luto@kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/mm.h       | 2 +-
 mm/util.c                | 4 +++-
 security/selinux/hooks.c | 2 +-
 3 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index e9caec6..a658a51 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1391,7 +1391,7 @@ static inline int stack_guard_page_end(struct vm_area_struct *vma,
 		!vma_growsup(vma->vm_next, addr);
 }
 
-int vma_is_stack_for_task(struct vm_area_struct *vma, struct task_struct *t);
+int vma_is_stack_for_current(struct vm_area_struct *vma);
 
 extern unsigned long move_page_tables(struct vm_area_struct *vma,
 		unsigned long old_addr, struct vm_area_struct *new_vma,
diff --git a/mm/util.c b/mm/util.c
index 662cddf..c174e89 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -230,8 +230,10 @@ void __vma_link_list(struct mm_struct *mm, struct vm_area_struct *vma,
 }
 
 /* Check if the vma is being used as a stack by this task */
-int vma_is_stack_for_task(struct vm_area_struct *vma, struct task_struct *t)
+int vma_is_stack_for_current(struct vm_area_struct *vma)
 {
+	struct task_struct * __maybe_unused t = current;
+
 	return (vma->vm_start <= KSTK_ESP(t) && vma->vm_end >= KSTK_ESP(t));
 }
 
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 0850579..09fd610 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -3557,7 +3557,7 @@ static int selinux_file_mprotect(struct vm_area_struct *vma,
 		} else if (!vma->vm_file &&
 			   ((vma->vm_start <= vma->vm_mm->start_stack &&
 			     vma->vm_end >= vma->vm_mm->start_stack) ||
-			    vma_is_stack_for_task(vma, current))) {
+			    vma_is_stack_for_current(vma))) {
 			rc = current_has_perm(current, PROCESS__EXECSTACK);
 		} else if (vma->vm_file && vma->anon_vma) {
 			/*
