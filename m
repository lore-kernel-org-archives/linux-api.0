From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 19/19] y2038: use __kernel_timespec in sys_sched_rr_get_interval
Date: Wed,  6 May 2015 18:30:26 +0200
Message-ID: <1430929826-318934-20-git-send-email-arnd@arndb.de>
References: <1430929826-318934-1-git-send-email-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1430929826-318934-1-git-send-email-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: y2038@lists.linaro.org
Cc: baolin.wang@linaro.org, tglx@linutronix.de, albert.aribaud@3adev.fr, john.stultz@linaro.org, bamvor.zhangjian@linaro.org, ruchandani.tina@gmail.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, libc-alpha@sourceware.org, Arnd Bergmann <arnd@arndb.de>
List-Id: linux-api@vger.kernel.org

sys_sched_rr_get_interval is easily converted to use __kernel_timespec,
by changing the function prototype. In order to allow compat handling
on 32-bit architectures, we also move compat_sys_sched_getaffinity
into the same file and unify the implementation, which avoids converting
the structure multiple times.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 include/linux/syscalls.h |  2 +-
 kernel/compat.c          | 20 --------------------
 kernel/sched/core.c      | 35 ++++++++++++++++++++++++++++-------
 3 files changed, 29 insertions(+), 28 deletions(-)

diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 90c3cd889387..ce41abb4cd0a 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -305,7 +305,7 @@ asmlinkage long sys_sched_yield(void);
 asmlinkage long sys_sched_get_priority_max(int policy);
 asmlinkage long sys_sched_get_priority_min(int policy);
 asmlinkage long sys_sched_rr_get_interval(pid_t pid,
-					struct timespec __user *interval);
+				struct __kernel_timespec __user *interval);
 asmlinkage long sys_setpriority(int which, int who, int niceval);
 asmlinkage long sys_getpriority(int which, int who);
 
diff --git a/kernel/compat.c b/kernel/compat.c
index ec09c6e1d594..f6d17f06ec3d 100644
--- a/kernel/compat.c
+++ b/kernel/compat.c
@@ -1288,27 +1288,7 @@ COMPAT_SYSCALL_DEFINE4(migrate_pages, compat_pid_t, pid,
 	return sys_migrate_pages(pid, nr_bits + 1, old, new);
 }
 #endif
-#endif
-
-#ifdef CONFIG_COMPAT_TIME
-COMPAT_SYSCALL_DEFINE2(sched_rr_get_interval,
-		       compat_pid_t, pid,
-		       struct compat_timespec __user *, interval)
-{
-	struct timespec t;
-	int ret;
-	mm_segment_t old_fs = get_fs();
-
-	set_fs(KERNEL_DS);
-	ret = sys_sched_rr_get_interval(pid, (struct timespec __user *)&t);
-	set_fs(old_fs);
-	if (compat_put_timespec(&t, interval))
-		return -EFAULT;
-	return ret;
-}
-#endif
 
-#ifdef CONFIG_COMPAT
 /*
  * Allocate user-space memory for the duration of a single system call,
  * in order to marshall parameters inside a compat thunk.
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index fe22f7510bce..498ab3ab46dc 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -35,6 +35,8 @@
 #include <asm/mmu_context.h>
 #include <linux/interrupt.h>
 #include <linux/capability.h>
+#include <linux/compat.h>
+#include <linux/compat_time.h>
 #include <linux/completion.h>
 #include <linux/kernel_stat.h>
 #include <linux/debug_locks.h>
@@ -4468,15 +4470,13 @@ SYSCALL_DEFINE1(sched_get_priority_min, int, policy)
  * Return: On success, 0 and the timeslice is in @interval. Otherwise,
  * an error code.
  */
-SYSCALL_DEFINE2(sched_rr_get_interval, pid_t, pid,
-		struct timespec __user *, interval)
+static int sched_rr_get_interval(pid_t pid, struct timespec64 *t)
 {
 	struct task_struct *p;
 	unsigned int time_slice;
 	unsigned long flags;
 	struct rq *rq;
 	int retval;
-	struct timespec t;
 
 	if (pid < 0)
 		return -EINVAL;
@@ -4497,16 +4497,37 @@ SYSCALL_DEFINE2(sched_rr_get_interval, pid_t, pid,
 		time_slice = p->sched_class->get_rr_interval(rq, p);
 	task_rq_unlock(rq, p, &flags);
 
-	rcu_read_unlock();
-	jiffies_to_timespec(time_slice, &t);
-	retval = copy_to_user(interval, &t, sizeof(t)) ? -EFAULT : 0;
-	return retval;
+	jiffies_to_timespec64(time_slice, t);
 
 out_unlock:
 	rcu_read_unlock();
 	return retval;
 }
 
+SYSCALL_DEFINE2(sched_rr_get_interval, pid_t, pid,
+		struct __kernel_timespec __user *, interval)
+{
+	struct timespec64 t;
+	int ret = sched_rr_get_interval(pid, &t);
+	if (ret)
+		return ret;
+
+	return put_timespec64(&t, interval);
+}
+
+#ifdef CONFIG_COMPAT_TIME
+COMPAT_SYSCALL_DEFINE2(sched_rr_get_interval, compat_pid_t, pid,
+		       struct compat_timespec __user *, interval)
+{
+	struct timespec64 t;
+	int ret = sched_rr_get_interval(pid, &t);
+	if (ret)
+		return ret;
+
+	return compat_put_timespec64(&t, interval);
+}
+#endif
+
 static const char stat_nam[] = TASK_STATE_TO_CHAR_STR;
 
 void sched_show_task(struct task_struct *p)
-- 
2.1.0.rc2
