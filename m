From: Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 3.16 330/366] fs/proc: Stop trying to report thread stacks
Date: Sun, 11 Nov 2018 19:49:05 +0000
Message-ID: <lsq.1541965745.600524608@decadent.org.uk>
References: <lsq.1541965744.387173642@decadent.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <lsq.1541965744.387173642@decadent.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Linus Torvalds <torvalds@linux-foundation.org>, Borislav Petkov <bp@alien8.de>, Peter Zijlstra <peterz@infradead.org>, Andy Lutomirski <luto@kernel.org>, Kees Cook <keescook@chromium.org>, Ingo Molnar <mingo@kernel.org>, Tycho Andersen <tycho.andersen@canonical.com>, Brian Gerst <brgerst@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Linux API <linux-api@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Jann Horn <jann@thejh.net>, Al Viro <viro@zeniv.linux.org.uk>
List-Id: linux-api@vger.kernel.org

3.16.61-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Lutomirski <luto@kernel.org>

commit b18cb64ead400c01bf1580eeba330ace51f8087d upstream.

This reverts more of:

  b76437579d13 ("procfs: mark thread stack correctly in proc/<pid>/maps")

... which was partially reverted by:

  65376df58217 ("proc: revert /proc/<pid>/maps [stack:TID] annotation")

Originally, /proc/PID/task/TID/maps was the same as /proc/TID/maps.

In current kernels, /proc/PID/maps (or /proc/TID/maps even for
threads) shows "[stack]" for VMAs in the mm's stack address range.

In contrast, /proc/PID/task/TID/maps uses KSTK_ESP to guess the
target thread's stack's VMA.  This is racy, probably returns garbage
and, on arches with CONFIG_TASK_INFO_IN_THREAD=y, is also crash-prone:
KSTK_ESP is not safe to use on tasks that aren't known to be running
ordinary process-context kernel code.

This patch removes the difference and just shows "[stack]" for VMAs
in the mm's stack range.  This is IMO much more sensible -- the
actual "stack" address really is treated specially by the VM code,
and the current thread stack isn't even well-defined for programs
that frequently switch stacks on their own.

Reported-by: Jann Horn <jann@thejh.net>
Signed-off-by: Andy Lutomirski <luto@kernel.org>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Brian Gerst <brgerst@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux API <linux-api@vger.kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Tycho Andersen <tycho.andersen@canonical.com>
Link: http://lkml.kernel.org/r/3e678474ec14e0a0ec34c611016753eea2e1b8ba.1475257877.git.luto@kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
[bwh: Backported to 3.16: Squash in the earlier commits 58cb65487e92
 "proc/maps: make vm_is_stack() logic namespace-friendly" and 
 65376df58217 "proc: revert /proc/<pid>/maps [stack:TID] annotation",
 which would introduce build failures if applied separately.]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -250,13 +250,28 @@ static int do_maps_open(struct inode *in
 	return ret;
 }
 
+/*
+ * Indicate if the VMA is a stack for the given task; for
+ * /proc/PID/maps that is the stack of the main task.
+ */
+static int is_stack(struct proc_maps_private *priv,
+		    struct vm_area_struct *vma)
+{
+	/*
+	 * We make no effort to guess what a given thread considers to be
+	 * its "stack".  It's not even well-defined for programs written
+	 * languages like Go.
+	 */
+	return vma->vm_start <= vma->vm_mm->start_stack &&
+		vma->vm_end >= vma->vm_mm->start_stack;
+}
+
 static void
 show_map_vma(struct seq_file *m, struct vm_area_struct *vma, int is_pid)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	struct file *file = vma->vm_file;
 	struct proc_maps_private *priv = m->private;
-	struct task_struct *task = priv->task;
 	vm_flags_t flags = vma->vm_flags;
 	unsigned long ino = 0;
 	unsigned long long pgoff = 0;
@@ -304,8 +319,6 @@ show_map_vma(struct seq_file *m, struct
 
 	name = arch_vma_name(vma);
 	if (!name) {
-		pid_t tid;
-
 		if (!mm) {
 			name = "[vdso]";
 			goto done;
@@ -317,22 +330,8 @@ show_map_vma(struct seq_file *m, struct
 			goto done;
 		}
 
-		tid = vm_is_stack(task, vma, is_pid);
-
-		if (tid != 0) {
-			/*
-			 * Thread stack in /proc/PID/task/TID/maps or
-			 * the main process stack.
-			 */
-			if (!is_pid || (vma->vm_start <= mm->start_stack &&
-			    vma->vm_end >= mm->start_stack)) {
-				name = "[stack]";
-			} else {
-				/* Thread stack in /proc/PID/maps */
-				seq_pad(m, ' ');
-				seq_printf(m, "[stack:%d]", tid);
-			}
-		}
+		if (is_stack(priv, vma))
+			name = "[stack]";
 	}
 
 done:
@@ -1433,19 +1432,8 @@ static int show_numa_map(struct seq_file
 		seq_path(m, &file->f_path, "\n\t= ");
 	} else if (vma->vm_start <= mm->brk && vma->vm_end >= mm->start_brk) {
 		seq_puts(m, " heap");
-	} else {
-		pid_t tid = vm_is_stack(task, vma, is_pid);
-		if (tid != 0) {
-			/*
-			 * Thread stack in /proc/PID/task/TID/maps or
-			 * the main process stack.
-			 */
-			if (!is_pid || (vma->vm_start <= mm->start_stack &&
-			    vma->vm_end >= mm->start_stack))
-				seq_puts(m, " stack");
-			else
-				seq_printf(m, " stack:%d", tid);
-		}
+	} else if (is_stack(proc_priv, vma)) {
+		seq_puts(m, " stack");
 	}
 
 	if (is_vm_hugetlb_page(vma))
--- a/fs/proc/task_nommu.c
+++ b/fs/proc/task_nommu.c
@@ -123,6 +123,20 @@ unsigned long task_statm(struct mm_struc
 	return size;
 }
 
+static int is_stack(struct proc_maps_private *priv,
+		    struct vm_area_struct *vma)
+{
+	struct mm_struct *mm = vma->vm_mm;
+
+	/*
+	 * We make no effort to guess what a given thread considers to be
+	 * its "stack".  It's not even well-defined for programs written
+	 * languages like Go.
+	 */
+	return vma->vm_start <= mm->start_stack &&
+		vma->vm_end >= mm->start_stack;
+}
+
 /*
  * display a single VMA to a sequenced file
  */
@@ -162,21 +176,9 @@ static int nommu_vma_show(struct seq_fil
 	if (file) {
 		seq_pad(m, ' ');
 		seq_path(m, &file->f_path, "");
-	} else if (mm) {
-		pid_t tid = vm_is_stack(priv->task, vma, is_pid);
-
-		if (tid != 0) {
-			seq_pad(m, ' ');
-			/*
-			 * Thread stack in /proc/PID/task/TID/maps or
-			 * the main process stack.
-			 */
-			if (!is_pid || (vma->vm_start <= mm->start_stack &&
-			    vma->vm_end >= mm->start_stack))
-				seq_printf(m, "[stack]");
-			else
-				seq_printf(m, "[stack:%d]", tid);
-		}
+	} else if (mm && is_stack(priv, vma)) {
+		seq_pad(m, ' ');
+		seq_printf(m, "[stack]");
 	}
 
 	seq_putc(m, '\n');
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1239,8 +1239,7 @@ int set_page_dirty_lock(struct page *pag
 int clear_page_dirty_for_io(struct page *page);
 int get_cmdline(struct task_struct *task, char *buffer, int buflen);
 
-extern pid_t
-vm_is_stack(struct task_struct *task, struct vm_area_struct *vma, int in_group);
+int vma_is_stack_for_task(struct vm_area_struct *vma, struct task_struct *t);
 
 extern unsigned long move_page_tables(struct vm_area_struct *vma,
 		unsigned long old_addr, struct vm_area_struct *new_vma,
--- a/mm/util.c
+++ b/mm/util.c
@@ -255,43 +255,11 @@ void __vma_link_list(struct mm_struct *m
 }
 
 /* Check if the vma is being used as a stack by this task */
-static int vm_is_stack_for_task(struct task_struct *t,
-				struct vm_area_struct *vma)
+int vma_is_stack_for_task(struct vm_area_struct *vma, struct task_struct *t)
 {
 	return (vma->vm_start <= KSTK_ESP(t) && vma->vm_end >= KSTK_ESP(t));
 }
 
-/*
- * Check if the vma is being used as a stack.
- * If is_group is non-zero, check in the entire thread group or else
- * just check in the current task. Returns the pid of the task that
- * the vma is stack for.
- */
-pid_t vm_is_stack(struct task_struct *task,
-		  struct vm_area_struct *vma, int in_group)
-{
-	pid_t ret = 0;
-
-	if (vm_is_stack_for_task(task, vma))
-		return task->pid;
-
-	if (in_group) {
-		struct task_struct *t;
-
-		rcu_read_lock();
-		for_each_thread(task, t) {
-			if (vm_is_stack_for_task(t, vma)) {
-				ret = t->pid;
-				goto done;
-			}
-		}
-done:
-		rcu_read_unlock();
-	}
-
-	return ret;
-}
-
 #if defined(CONFIG_MMU) && !defined(HAVE_ARCH_PICK_MMAP_LAYOUT)
 void arch_pick_mmap_layout(struct mm_struct *mm)
 {
--- a/Documentation/filesystems/proc.txt
+++ b/Documentation/filesystems/proc.txt
@@ -335,7 +335,7 @@ address           perms offset  dev   in
 a7cb1000-a7cb2000 ---p 00000000 00:00 0
 a7cb2000-a7eb2000 rw-p 00000000 00:00 0
 a7eb2000-a7eb3000 ---p 00000000 00:00 0
-a7eb3000-a7ed5000 rw-p 00000000 00:00 0          [stack:1001]
+a7eb3000-a7ed5000 rw-p 00000000 00:00 0
 a7ed5000-a8008000 r-xp 00000000 03:00 4222       /lib/libc.so.6
 a8008000-a800a000 r--p 00133000 03:00 4222       /lib/libc.so.6
 a800a000-a800b000 rw-p 00135000 03:00 4222       /lib/libc.so.6
@@ -367,40 +367,11 @@ is not associated with a file:
 
  [heap]                   = the heap of the program
  [stack]                  = the stack of the main process
- [stack:1001]             = the stack of the thread with tid 1001
  [vdso]                   = the "virtual dynamic shared object",
                             the kernel system call handler
 
  or if empty, the mapping is anonymous.
 
-The /proc/PID/task/TID/maps is a view of the virtual memory from the viewpoint
-of the individual tasks of a process. In this file you will see a mapping marked
-as [stack] if that task sees it as a stack. This is a key difference from the
-content of /proc/PID/maps, where you will see all mappings that are being used
-as stack by all of those tasks. Hence, for the example above, the task-level
-map, i.e. /proc/PID/task/TID/maps for thread 1001 will look like this:
-
-08048000-08049000 r-xp 00000000 03:00 8312       /opt/test
-08049000-0804a000 rw-p 00001000 03:00 8312       /opt/test
-0804a000-0806b000 rw-p 00000000 00:00 0          [heap]
-a7cb1000-a7cb2000 ---p 00000000 00:00 0
-a7cb2000-a7eb2000 rw-p 00000000 00:00 0
-a7eb2000-a7eb3000 ---p 00000000 00:00 0
-a7eb3000-a7ed5000 rw-p 00000000 00:00 0          [stack]
-a7ed5000-a8008000 r-xp 00000000 03:00 4222       /lib/libc.so.6
-a8008000-a800a000 r--p 00133000 03:00 4222       /lib/libc.so.6
-a800a000-a800b000 rw-p 00135000 03:00 4222       /lib/libc.so.6
-a800b000-a800e000 rw-p 00000000 00:00 0
-a800e000-a8022000 r-xp 00000000 03:00 14462      /lib/libpthread.so.0
-a8022000-a8023000 r--p 00013000 03:00 14462      /lib/libpthread.so.0
-a8023000-a8024000 rw-p 00014000 03:00 14462      /lib/libpthread.so.0
-a8024000-a8027000 rw-p 00000000 00:00 0
-a8027000-a8043000 r-xp 00000000 03:00 8317       /lib/ld-linux.so.2
-a8043000-a8044000 r--p 0001b000 03:00 8317       /lib/ld-linux.so.2
-a8044000-a8045000 rw-p 0001c000 03:00 8317       /lib/ld-linux.so.2
-aff35000-aff4a000 rw-p 00000000 00:00 0
-ffffe000-fffff000 r-xp 00000000 00:00 0          [vdso]
-
 The /proc/PID/smaps is an extension based on maps, showing the memory
 consumption for each of the process's mappings. For each of mappings there
 is a series of lines such as the following:
