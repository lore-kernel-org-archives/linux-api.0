From: Minchan Kim <minchan@kernel.org>
Subject: [RFCv2 5/6] mm: introduce external memory hinting API
Date: Fri, 31 May 2019 15:43:12 +0900
Message-ID: <20190531064313.193437-6-minchan@kernel.org>
References: <20190531064313.193437-1-minchan@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190531064313.193437-1-minchan@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, Tim Murray <timmurray@google.com>, Joel Fernandes <joel@joelfernandes.org>, Suren Baghdasaryan <surenb@google.com>, Daniel Colascione <dancol@google.com>, Shakeel Butt <shakeelb@google.com>, Sonny Rao <sonnyrao@google.com>, Brian Geffon <bgeffon@google.com>, jannh@google.com, oleg@redhat.com, christian@brauner.io, oleksandr@redhat.com, hdanton@sina.com, Minchan Kim <minchan@kernel.org>
List-Id: linux-api@vger.kernel.org

There is some usecase that centralized userspace daemon want to give
a memory hint like MADV_[COLD|PAGEEOUT] to other process. Android's
ActivityManagerService is one of them.

It's similar in spirit to madvise(MADV_WONTNEED), but the information
required to make the reclaim decision is not known to the app. Instead,
it is known to the centralized userspace daemon(ActivityManagerService),
and that daemon must be able to initiate reclaim on its own without
any app involvement.

To solve the issue, this patch introduces new syscall process_madvise(2).
It could give a hint to the exeternal process of pidfd.

 int process_madvise(int pidfd, void *addr, size_t length, int advise,
			unsigned long cookie, unsigned long flag);

Since it could affect other process's address range, only privileged
process(CAP_SYS_PTRACE) or something else(e.g., being the same UID)
gives it the right to ptrace the process could use it successfully.

The syscall has a cookie argument to privode atomicity(i.e., detect
target process's address space change since monitor process has parsed
the address range of target process so the operaion could fail in case
of happening race). Although there is no interface to get a cookie
at this moment, it could be useful to consider it as argument to avoid
introducing another new syscall in future. It could support *atomicity*
for disruptive hint(e.g., MADV_DONTNEED|FREE).
flag argument is reserved for future use if we need to extend the API.

I think supporting all hints madvise has/will supported/support to
process_madvise are rather risky. Because I'm not sure all hints makes
sense from external process and implementation for the hint may rely on
caller is current context like MADV_INJECT_ERROR so it could be error-prone
if the caller is external process. Other example is userfaultfd because
userfaultfd_remove need to release mmap_sem during the operation, which
wouuld be a obstacle to implement atomicity later. So, I just limited hints
as MADV_[COLD|PAGEOUT] at this moment. If someone want to expose other hint
we need to hear their workload/scenario and could review carefully by
design/implmentation of each hint. It's more safe for maintainace -
Once we open a buggy syscall but found hard to fix it later, we never
roll back.

TODO: once we agree the direction, I need to define the syscall for
every architecture.

* RFCv1
  * not export pidfd_to_pid. Use pidfd_pid - Christian
  * use mm struct instead of task_struct for madvise_core - Oleg
  * add cookie variable as syscall argument to guarantee atomicity - dancol

* internal review
  * use ptrace capability - surenb, dancol

I didn't solve the issue Olge pointed out(task we got from
pid_task could be a zombie leader so that syscall will fai
by mm_access even though process is alive with other threads)
because it's not a only problem of this new syscall but it's
general problem for other MM syscalls like process_vm_readv,
move_pages so need more discussion.

Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 arch/x86/entry/syscalls/syscall_32.tbl |  1 +
 arch/x86/entry/syscalls/syscall_64.tbl |  1 +
 include/linux/pid.h                    |  4 ++
 include/linux/syscalls.h               |  3 +
 include/uapi/asm-generic/unistd.h      |  4 +-
 kernel/fork.c                          |  8 +++
 kernel/signal.c                        |  7 ++-
 kernel/sys_ni.c                        |  1 +
 mm/madvise.c                           | 87 ++++++++++++++++++++++++++
 9 files changed, 113 insertions(+), 3 deletions(-)

diff --git a/arch/x86/entry/syscalls/syscall_32.tbl b/arch/x86/entry/syscalls/syscall_32.tbl
index 43e4429a5272..5f44a29b7882 100644
--- a/arch/x86/entry/syscalls/syscall_32.tbl
+++ b/arch/x86/entry/syscalls/syscall_32.tbl
@@ -439,3 +439,4 @@
 432	i386	fsmount			sys_fsmount			__ia32_sys_fsmount
 433	i386	fspick			sys_fspick			__ia32_sys_fspick
 434	i386	pidfd_open		sys_pidfd_open			__ia32_sys_pidfd_open
+435	i386	process_madvise		sys_process_madvise		__ia32_sys_process_madvise
diff --git a/arch/x86/entry/syscalls/syscall_64.tbl b/arch/x86/entry/syscalls/syscall_64.tbl
index 1bee0a77fdd3..35e91f3e9646 100644
--- a/arch/x86/entry/syscalls/syscall_64.tbl
+++ b/arch/x86/entry/syscalls/syscall_64.tbl
@@ -356,6 +356,7 @@
 432	common	fsmount			__x64_sys_fsmount
 433	common	fspick			__x64_sys_fspick
 434	common	pidfd_open		__x64_sys_pidfd_open
+435	common	process_madvise		__x64_sys_process_madvise
 
 #
 # x32-specific system call numbers start at 512 to avoid cache impact
diff --git a/include/linux/pid.h b/include/linux/pid.h
index a261712ac3fe..a49ef789c034 100644
--- a/include/linux/pid.h
+++ b/include/linux/pid.h
@@ -73,6 +73,10 @@ extern struct pid init_struct_pid;
 extern const struct file_operations pidfd_fops;
 extern int pidfd_create(struct pid *pid);
 
+struct file;
+
+extern struct pid *pidfd_pid(const struct file *file);
+
 static inline struct pid *get_pid(struct pid *pid)
 {
 	if (pid)
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 1a4dc53f40d9..6ba081c955f6 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -872,6 +872,9 @@ asmlinkage long sys_munlockall(void);
 asmlinkage long sys_mincore(unsigned long start, size_t len,
 				unsigned char __user * vec);
 asmlinkage long sys_madvise(unsigned long start, size_t len, int behavior);
+asmlinkage long sys_process_madvise(int pidfd, unsigned long start,
+				size_t len, int behavior,
+				unsigned long cookie, unsigned long flags);
 asmlinkage long sys_remap_file_pages(unsigned long start, unsigned long size,
 			unsigned long prot, unsigned long pgoff,
 			unsigned long flags);
diff --git a/include/uapi/asm-generic/unistd.h b/include/uapi/asm-generic/unistd.h
index e5684a4512c0..082d1f3fe3a2 100644
--- a/include/uapi/asm-generic/unistd.h
+++ b/include/uapi/asm-generic/unistd.h
@@ -846,9 +846,11 @@ __SYSCALL(__NR_fsmount, sys_fsmount)
 __SYSCALL(__NR_fspick, sys_fspick)
 #define __NR_pidfd_open 434
 __SYSCALL(__NR_pidfd_open, sys_pidfd_open)
+#define __NR_process_madvise 435
+__SYSCALL(__NR_process_madvise, sys_process_madvise)
 
 #undef __NR_syscalls
-#define __NR_syscalls 435
+#define __NR_syscalls 436
 
 /*
  * 32 bit systems traditionally used different
diff --git a/kernel/fork.c b/kernel/fork.c
index 9f238cdd886e..b76aade51631 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1738,6 +1738,14 @@ const struct file_operations pidfd_fops = {
 #endif
 };
 
+struct pid *pidfd_pid(const struct file *file)
+{
+	if (file->f_op == &pidfd_fops)
+		return file->private_data;
+
+	return ERR_PTR(-EBADF);
+}
+
 /**
  * pidfd_create() - Create a new pid file descriptor.
  *
diff --git a/kernel/signal.c b/kernel/signal.c
index b477e21ecafc..b376870d7565 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -3702,8 +3702,11 @@ static int copy_siginfo_from_user_any(kernel_siginfo_t *kinfo, siginfo_t *info)
 
 static struct pid *pidfd_to_pid(const struct file *file)
 {
-	if (file->f_op == &pidfd_fops)
-		return file->private_data;
+	struct pid *pid;
+
+	pid = pidfd_pid(file);
+	if (pid)
+		return pid;
 
 	return tgid_pidfd_to_pid(file);
 }
diff --git a/kernel/sys_ni.c b/kernel/sys_ni.c
index 4d9ae5ea6caf..5277421795ab 100644
--- a/kernel/sys_ni.c
+++ b/kernel/sys_ni.c
@@ -278,6 +278,7 @@ COND_SYSCALL(mlockall);
 COND_SYSCALL(munlockall);
 COND_SYSCALL(mincore);
 COND_SYSCALL(madvise);
+COND_SYSCALL(process_madvise);
 COND_SYSCALL(remap_file_pages);
 COND_SYSCALL(mbind);
 COND_SYSCALL_COMPAT(mbind);
diff --git a/mm/madvise.c b/mm/madvise.c
index 466623ea8c36..fd205e928a1b 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -15,6 +15,7 @@
 #include <linux/hugetlb.h>
 #include <linux/falloc.h>
 #include <linux/sched.h>
+#include <linux/sched/mm.h>
 #include <linux/ksm.h>
 #include <linux/fs.h>
 #include <linux/file.h>
@@ -983,6 +984,31 @@ madvise_behavior_valid(int behavior)
 	}
 }
 
+static bool
+process_madvise_behavior_valid(int behavior)
+{
+	switch (behavior) {
+	case MADV_COLD:
+	case MADV_PAGEOUT:
+		return true;
+
+	default:
+		return false;
+	}
+}
+
+/*
+ * madvise_core - request behavior hint to address range of the target process
+ *
+ * @task: task_struct got behavior hint, not giving the hint
+ * @mm: mm_struct got behavior hint, not giving the hint
+ * @start: base address of the hinted range
+ * @len_in: length of the hinted range
+ * @behavior: requested hint
+ *
+ * @task could be a zombie leader if it calls sys_exit so accessing mm_struct
+ * via task->mm is prohibited. Please use @mm insetad of task->mm.
+ */
 static int madvise_core(struct task_struct *task, struct mm_struct *mm,
 			unsigned long start, size_t len_in, int behavior)
 {
@@ -1146,3 +1172,64 @@ SYSCALL_DEFINE3(madvise, unsigned long, start, size_t, len_in, int, behavior)
 {
 	return madvise_core(current, current->mm, start, len_in, behavior);
 }
+
+SYSCALL_DEFINE6(process_madvise, int, pidfd, unsigned long, start,
+		size_t, len_in, int, behavior, unsigned long, cookie,
+		unsigned long, flags)
+{
+	int ret;
+	struct fd f;
+	struct pid *pid;
+	struct task_struct *task;
+	struct mm_struct *mm;
+
+	if (flags != 0)
+		return -EINVAL;
+
+	/*
+	 * We don't support cookie to gaurantee address space change
+	 * atomicity yet.
+	 */
+	if (cookie != 0)
+		return -EINVAL;
+
+	if (!process_madvise_behavior_valid(behavior))
+		return return -EINVAL;
+
+	f = fdget(pidfd);
+	if (!f.file)
+		return -EBADF;
+
+	pid = pidfd_pid(f.file);
+	if (IS_ERR(pid)) {
+		ret = PTR_ERR(pid);
+		goto err;
+	}
+
+	rcu_read_lock();
+	task = pid_task(pid, PIDTYPE_PID);
+	if (!task) {
+		rcu_read_unlock();
+		ret = -ESRCH;
+		goto err;
+	}
+
+	get_task_struct(task);
+	rcu_read_unlock();
+
+	mm = mm_access(task, PTRACE_MODE_ATTACH_FSCREDS);
+	if (!mm || IS_ERR(mm)) {
+		ret = IS_ERR(mm) ? PTR_ERR(mm) : -ESRCH;
+		if (ret == -EACCES)
+			ret = -EPERM;
+		goto release_task;
+	}
+
+	ret = madvise_core(task, mm, start, len_in, behavior);
+	mmput(mm);
+release_task:
+	put_task_struct(task);
+err:
+	fdput(f);
+	return ret;
+}
-- 
2.22.0.rc1.257.g3120a18244-goog
