From: tip-bot for Andy Lutomirski <tipbot@zytor.com>
Subject: [tip:mm/urgent] fs/proc: Stop trying to report thread stacks
Date: Thu, 20 Oct 2016 04:13:53 -0700
Message-ID: <tip-b18cb64ead400c01bf1580eeba330ace51f8087d@git.kernel.org>
References: <3e678474ec14e0a0ec34c611016753eea2e1b8ba.1475257877.git.luto@kernel.org>
Reply-To: peterz@infradead.org, linux-api@vger.kernel.org,
          akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
          mingo@kernel.org, bp@alien8.de, luto@kernel.org,
          brgerst@gmail.com, jann@thejh.net, keescook@chromium.org,
          torvalds@linux-foundation.org, tycho.andersen@canonical.com,
          tglx@linutronix.de, viro@zeniv.linux.org.uk, hannes@cmpxchg.org,
          hpa@zytor.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <3e678474ec14e0a0ec34c611016753eea2e1b8ba.1475257877.git.luto@kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: linux-tip-commits@vger.kernel.org
Cc: mingo@kernel.org, bp@alien8.de, luto@kernel.org, peterz@infradead.org, linux-api@vger.kernel.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, hannes@cmpxchg.org, hpa@zytor.com, brgerst@gmail.com, jann@thejh.net, keescook@chromium.org, torvalds@linux-foundation.org, tycho.andersen@canonical.com, tglx@linutronix.de
List-Id: linux-api@vger.kernel.org

Commit-ID:  b18cb64ead400c01bf1580eeba330ace51f8087d
Gitweb:     http://git.kernel.org/tip/b18cb64ead400c01bf1580eeba330ace51f8087d
Author:     Andy Lutomirski <luto@kernel.org>
AuthorDate: Fri, 30 Sep 2016 10:58:57 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 20 Oct 2016 09:21:41 +0200

fs/proc: Stop trying to report thread stacks

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
---
 Documentation/filesystems/proc.txt | 26 --------------------------
 fs/proc/task_mmu.c                 | 29 ++++++++++-------------------
 fs/proc/task_nommu.c               | 28 ++++++++++------------------
 3 files changed, 20 insertions(+), 63 deletions(-)

diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
index 219ffd4..74329fd 100644
--- a/Documentation/filesystems/proc.txt
+++ b/Documentation/filesystems/proc.txt
@@ -395,32 +395,6 @@ is not associated with a file:
 
  or if empty, the mapping is anonymous.
 
-The /proc/PID/task/TID/maps is a view of the virtual memory from the viewpoint
-of the individual tasks of a process. In this file you will see a mapping marked
-as [stack] if that task sees it as a stack. Hence, for the example above, the
-task-level map, i.e. /proc/PID/task/TID/maps for thread 1001 will look like this:
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
diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 6909582..35b92d8 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -266,24 +266,15 @@ static int do_maps_open(struct inode *inode, struct file *file,
  * /proc/PID/maps that is the stack of the main task.
  */
 static int is_stack(struct proc_maps_private *priv,
-		    struct vm_area_struct *vma, int is_pid)
+		    struct vm_area_struct *vma)
 {
-	int stack = 0;
-
-	if (is_pid) {
-		stack = vma->vm_start <= vma->vm_mm->start_stack &&
-			vma->vm_end >= vma->vm_mm->start_stack;
-	} else {
-		struct inode *inode = priv->inode;
-		struct task_struct *task;
-
-		rcu_read_lock();
-		task = pid_task(proc_pid(inode), PIDTYPE_PID);
-		if (task)
-			stack = vma_is_stack_for_task(vma, task);
-		rcu_read_unlock();
-	}
-	return stack;
+	/*
+	 * We make no effort to guess what a given thread considers to be
+	 * its "stack".  It's not even well-defined for programs written
+	 * languages like Go.
+	 */
+	return vma->vm_start <= vma->vm_mm->start_stack &&
+		vma->vm_end >= vma->vm_mm->start_stack;
 }
 
 static void
@@ -354,7 +345,7 @@ show_map_vma(struct seq_file *m, struct vm_area_struct *vma, int is_pid)
 			goto done;
 		}
 
-		if (is_stack(priv, vma, is_pid))
+		if (is_stack(priv, vma))
 			name = "[stack]";
 	}
 
@@ -1669,7 +1660,7 @@ static int show_numa_map(struct seq_file *m, void *v, int is_pid)
 		seq_file_path(m, file, "\n\t= ");
 	} else if (vma->vm_start <= mm->brk && vma->vm_end >= mm->start_brk) {
 		seq_puts(m, " heap");
-	} else if (is_stack(proc_priv, vma, is_pid)) {
+	} else if (is_stack(proc_priv, vma)) {
 		seq_puts(m, " stack");
 	}
 
diff --git a/fs/proc/task_nommu.c b/fs/proc/task_nommu.c
index faacb0c..3717562 100644
--- a/fs/proc/task_nommu.c
+++ b/fs/proc/task_nommu.c
@@ -124,25 +124,17 @@ unsigned long task_statm(struct mm_struct *mm,
 }
 
 static int is_stack(struct proc_maps_private *priv,
-		    struct vm_area_struct *vma, int is_pid)
+		    struct vm_area_struct *vma)
 {
 	struct mm_struct *mm = vma->vm_mm;
-	int stack = 0;
-
-	if (is_pid) {
-		stack = vma->vm_start <= mm->start_stack &&
-			vma->vm_end >= mm->start_stack;
-	} else {
-		struct inode *inode = priv->inode;
-		struct task_struct *task;
-
-		rcu_read_lock();
-		task = pid_task(proc_pid(inode), PIDTYPE_PID);
-		if (task)
-			stack = vma_is_stack_for_task(vma, task);
-		rcu_read_unlock();
-	}
-	return stack;
+
+	/*
+	 * We make no effort to guess what a given thread considers to be
+	 * its "stack".  It's not even well-defined for programs written
+	 * languages like Go.
+	 */
+	return vma->vm_start <= mm->start_stack &&
+		vma->vm_end >= mm->start_stack;
 }
 
 /*
@@ -184,7 +176,7 @@ static int nommu_vma_show(struct seq_file *m, struct vm_area_struct *vma,
 	if (file) {
 		seq_pad(m, ' ');
 		seq_file_path(m, file, "");
-	} else if (mm && is_stack(priv, vma, is_pid)) {
+	} else if (mm && is_stack(priv, vma)) {
 		seq_pad(m, ' ');
 		seq_printf(m, "[stack]");
 	}
