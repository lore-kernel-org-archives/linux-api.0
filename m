From: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Subject: [patch 050/160] prctl: add PR_SET_PROCTITLE_AREA option for prctl()
Date: Fri, 05 Mar 2010 13:42:37 -0800
Message-ID: <201003052142.o25Lgbpg029522@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org, bdonlan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, drepper-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mingo-X9Un+BFzKDI@public.gmane.org, oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, tss-X3B1VOXEql0@public.gmane.org, xiyou.wangcong-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: linux-api@vger.kernel.org

From: KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>

Currently glibc2 doesn't have setproctitle(3), so several userland daemons
attempt to emulate it by doing some brutal stack modifications.  This
works most of the time, but it has problems.  For example:

 % ps -ef |grep avahi-daemon
 avahi     1679     1  0 09:20 ?        00:00:00 avahi-daemon: running [kosadesk.local]

 # cat /proc/1679/cmdline
 avahi-daemon: running [kosadesk.local]

This looks good, but the process has also overwritten its environment area
and made the environ file useless:

 # cat /proc/1679/environ
 adesk.local]

Another problem is that the process title length is limited by the size of
the environment.  Security conscious people try to avoid potential
information leaks by clearing most of the environment before running a
daemon:

 # env - MINIMUM_NEEDED_VAR=foo /path/to/daemon

The resulting environment size may be too small to fit the wanted process
titles.

This patch makes it possible for userspace to implement setproctitle()
cleanly.  It adds a new PR_SET_PROCTITLE_AREA option for prctl(), which
updates task's mm_struct->arg_start and arg_end to the given area.

 test_setproctitle.c
 ================================================
 #include <string.h>
 #include <stdlib.h>
 #include <unistd.h>
 #include <stdio.h>
 #include <sys/prctl.h>

 #define ERR(str) (perror(str), exit(1))

 void settitle(char* title){
         int err;

         err = prctl(35, title, strlen(title)+1);
         if (err < 0)
                 ERR("prctl ");
 }

 void main(void){
         long i;
         char buf[1024];

         for (i = 0; i < 10000000000LL; i++){
                 sprintf(buf, "loooooooooooooooooooooooong string %d",i);
                 settitle(buf);
         }
 }
 ==================================================

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Signed-off-by: Timo Sirainen <tss-X3B1VOXEql0@public.gmane.org>
Cc: Bryan Donlan <bdonlan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Ulrich Drepper <drepper-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: WANG Cong <xiyou.wangcong-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>
Cc: <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Signed-off-by: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
---

 fs/proc/base.c        |   39 +++++++++++++++++++++++++++++----------
 include/linux/mm.h    |    2 ++
 include/linux/prctl.h |    3 +++
 kernel/sys.c          |   26 ++++++++++++++++++++++++++
 mm/memory.c           |   40 +++++++++++++++++++++++++++-------------
 5 files changed, 87 insertions(+), 23 deletions(-)

diff -puN fs/proc/base.c~prctl-add-pr_set_proctitle_area-option-for-prctl fs/proc/base.c
--- a/fs/proc/base.c~prctl-add-pr_set_proctitle_area-option-for-prctl
+++ a/fs/proc/base.c
@@ -255,34 +255,53 @@ static int proc_pid_cmdline(struct task_
 	int res = 0;
 	unsigned int len;
 	struct mm_struct *mm = get_task_mm(task);
+
 	if (!mm)
 		goto out;
+
+	/* The process was not constructed yet? */
 	if (!mm->arg_end)
 		goto out_mm;	/* Shh! No looking before we're done */
 
- 	len = mm->arg_end - mm->arg_start;
- 
+	down_read(&mm->mmap_sem);
+	len = mm->arg_end - mm->arg_start;
 	if (len > PAGE_SIZE)
 		len = PAGE_SIZE;
- 
-	res = access_process_vm(task, mm->arg_start, buffer, len, 0);
 
-	// If the nul at the end of args has been overwritten, then
-	// assume application is using setproctitle(3).
+	res = access_process_vm_locked(task, mm, mm->arg_start, buffer, len, 0);
+
+	/*
+	 * If argv and environ aren't continuous (i.e. the process used
+	 * prctl(PR_SET_PROCTITLE_AREA)), we don't care about the evironment
+	 * override.
+	 */
+	if (mm->arg_end != mm->env_start)
+		goto out_unlock;
+
+	/*
+	 * If the nul at the end of args has been overwritten, then assume
+	 * application is using sendmail's SPT_REUSEARGV style argv override.
+	 */
 	if (res > 0 && buffer[res-1] != '\0' && len < PAGE_SIZE) {
 		len = strnlen(buffer, res);
-		if (len < res) {
-		    res = len;
-		} else {
+		if (len < res)
+			res = len;
+		else {
 			len = mm->env_end - mm->env_start;
 			if (len > PAGE_SIZE - res)
 				len = PAGE_SIZE - res;
-			res += access_process_vm(task, mm->env_start, buffer+res, len, 0);
+			res += access_process_vm_locked(task, mm, mm->env_start,
+							buffer+res, len, 0);
 			res = strnlen(buffer, res);
 		}
 	}
+
+out_unlock:
+	up_read(&mm->mmap_sem);
+
 out_mm:
 	mmput(mm);
+
 out:
 	return res;
 }
diff -puN include/linux/mm.h~prctl-add-pr_set_proctitle_area-option-for-prctl include/linux/mm.h
--- a/include/linux/mm.h~prctl-add-pr_set_proctitle_area-option-for-prctl
+++ a/include/linux/mm.h
@@ -835,6 +835,8 @@ static inline int handle_mm_fault(struct
 
 extern int make_pages_present(unsigned long addr, unsigned long end);
 extern int access_process_vm(struct task_struct *tsk, unsigned long addr, void *buf, int len, int write);
+extern int access_process_vm_locked(struct task_struct *tsk, struct mm_struct *mm,
+				    unsigned long addr, void *buf, int len, int write);
 
 int get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
 			unsigned long start, int nr_pages, int write, int force,
diff -puN include/linux/prctl.h~prctl-add-pr_set_proctitle_area-option-for-prctl include/linux/prctl.h
--- a/include/linux/prctl.h~prctl-add-pr_set_proctitle_area-option-for-prctl
+++ a/include/linux/prctl.h
@@ -102,4 +102,7 @@
 
 #define PR_MCE_KILL_GET 34
 
+/* Set process title memory area for setproctitle() */
+#define PR_SET_PROCTITLE_AREA 35
+
 #endif /* _LINUX_PRCTL_H */
diff -puN kernel/sys.c~prctl-add-pr_set_proctitle_area-option-for-prctl kernel/sys.c
--- a/kernel/sys.c~prctl-add-pr_set_proctitle_area-option-for-prctl
+++ a/kernel/sys.c
@@ -1575,6 +1575,32 @@ SYSCALL_DEFINE5(prctl, int, option, unsi
 			else
 				error = PR_MCE_KILL_DEFAULT;
 			break;
+		case PR_SET_PROCTITLE_AREA: {
+			struct mm_struct *mm = current->mm;
+			unsigned long start = arg2;
+			unsigned long len = arg3;
+			unsigned long end = start + len;
+
+			if (len > PAGE_SIZE)
+				return -EINVAL;
+
+			/*
+			 * If the process pass broken pointer, EFAULT is might better
+			 * than ps output zero-length proctitle. Plus if
+			 * the process pass kernel address (or something-else),
+			 * We have to block it. Oherwise, strange exploit
+			 * chance is there.
+			 */
+			if (!access_ok(VERIFY_READ, start, len))
+				return -EFAULT;
+
+			down_write(&mm->mmap_sem);
+			mm->arg_start = start;
+			mm->arg_end = end;
+			up_write(&mm->mmap_sem);
+
+			return 0;
+		}
 		default:
 			error = -EINVAL;
 			break;
diff -puN mm/memory.c~prctl-add-pr_set_proctitle_area-option-for-prctl mm/memory.c
--- a/mm/memory.c~prctl-add-pr_set_proctitle_area-option-for-prctl
+++ a/mm/memory.c
@@ -3378,22 +3378,13 @@ int generic_access_phys(struct vm_area_s
 }
 #endif
 
-/*
- * Access another process' address space.
- * Source/target buffer must be kernel space,
- * Do not walk the page table directly, use get_user_pages
- */
-int access_process_vm(struct task_struct *tsk, unsigned long addr, void *buf, int len, int write)
+/* Similar to access_process_vm(), but mmap_sem held is required. */
+int access_process_vm_locked(struct task_struct *tsk, struct mm_struct *mm,
+			     unsigned long addr, void *buf, int len, int write)
 {
-	struct mm_struct *mm;
 	struct vm_area_struct *vma;
 	void *old_buf = buf;
 
-	mm = get_task_mm(tsk);
-	if (!mm)
-		return 0;
-
-	down_read(&mm->mmap_sem);
 	/* ignore errors, just check how much was successfully transferred */
 	while (len) {
 		int bytes, ret, offset;
@@ -3440,10 +3431,33 @@ int access_process_vm(struct task_struct
 		buf += bytes;
 		addr += bytes;
 	}
+
+	return buf - old_buf;
+}
+
+/*
+ * Access another process' address space.
+ * Source/target buffer must be kernel space,
+ * Do not walk the page table directly, use get_user_pages
+ * ignore errors, just check how much was successfully transferred. IOW, this
+ * function always return >=0 value.
+ */
+int access_process_vm(struct task_struct *tsk, unsigned long addr, void *buf, int len, int write)
+{
+	int ret;
+	struct mm_struct *mm;
+
+	/* Probably tsk isn't current. We can't access tsk->mm directly. */
+	mm = get_task_mm(tsk);
+	if (!mm)
+		return 0;
+
+	down_read(&mm->mmap_sem);
+	ret = access_process_vm_locked(tsk, mm, addr, buf, len, write);
 	up_read(&mm->mmap_sem);
 	mmput(mm);
 
-	return buf - old_buf;
+	return ret;
 }
 
 /*
_
