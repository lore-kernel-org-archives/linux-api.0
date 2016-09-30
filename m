From: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 3/3] mm: Change vm_is_stack_for_task() to vm_is_stack_for_current()
Date: Fri, 30 Sep 2016 10:58:58 -0700
Message-ID: <4c3f68f426e6c061ca98b4fc7ef85ffbb0a25b0c.1475257877.git.luto@kernel.org>
References: <cover.1475257877.git.luto@kernel.org>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1475257877.git.luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
In-Reply-To: <cover.1475257877.git.luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
References: <cover.1475257877.git.luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Brian Gerst <brgerst-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Jann Horn <jann-XZ1E9jl8jIdeoWH0uzbU5w@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Tycho Andersen <tycho.andersen-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Asking for a non-current task's stack can't be done without races
unless the task is frozen in kernel mode.  As far as I know,
vm_is_stack_for_task() never had a safe non-current use case.

The __unused annotation is because some KSTK_ESP implementations
ignore their parameter, which IMO is further justification for this
patch.

Signed-off-by: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 include/linux/mm.h       | 2 +-
 mm/util.c                | 4 +++-
 security/selinux/hooks.c | 2 +-
 3 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index ef815b9cd426..c365cf49f54a 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1403,7 +1403,7 @@ static inline int stack_guard_page_end(struct vm_area_struct *vma,
 		!vma_growsup(vma->vm_next, addr);
 }
 
-int vma_is_stack_for_task(struct vm_area_struct *vma, struct task_struct *t);
+int vma_is_stack_for_current(struct vm_area_struct *vma);
 
 extern unsigned long move_page_tables(struct vm_area_struct *vma,
 		unsigned long old_addr, struct vm_area_struct *new_vma,
diff --git a/mm/util.c b/mm/util.c
index 662cddf914af..c174e8921995 100644
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
index 13185a6c266a..3a40135bde5e 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -3505,7 +3505,7 @@ static int selinux_file_mprotect(struct vm_area_struct *vma,
 		} else if (!vma->vm_file &&
 			   ((vma->vm_start <= vma->vm_mm->start_stack &&
 			     vma->vm_end >= vma->vm_mm->start_stack) ||
-			    vma_is_stack_for_task(vma, current))) {
+			    vma_is_stack_for_current(vma))) {
 			rc = current_has_perm(current, PROCESS__EXECSTACK);
 		} else if (vma->vm_file && vma->anon_vma) {
 			/*
-- 
2.7.4
