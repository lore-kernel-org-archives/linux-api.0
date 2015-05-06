From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: [PATCH 11/19] y2038: introduce and use struct __kernel_rusage
Date: Wed,  6 May 2015 18:30:18 +0200
Message-ID: <1430929826-318934-12-git-send-email-arnd@arndb.de>
References: <1430929826-318934-1-git-send-email-arnd@arndb.de>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1430929826-318934-1-git-send-email-arnd-r2nGTMty4D4@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: y2038-cunTk1MwBs8s++Sfvej+rw@public.gmane.org
Cc: baolin.wang-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, albert.aribaud-iEu9NFBzPZE@public.gmane.org, john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, bamvor.zhangjian-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, ruchandani.tina-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, libc-alpha-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
List-Id: linux-api@vger.kernel.org

'struct rusage' is not compatible with user space that defines time_t
as 64-bit. While there will never be an overflow of the timeval
members in this structure, the current definition breaks any program
that relies on the member to be a timeval.

This introduces a new struct __kernel_rusage that is defined to match
the 64-bit version of struct rusage. 32-bit architectures that use
CONFIG_COMPAT_TIME can then use compat_sys_getrusage() etc to get
the original structure, while the normal sys_getrusage() function
will provide the new layout in both native and compat32 mode.

On 32-bit architectures that do not set CONFIG_COMPAT_TIME, as well
as all 64-bit architectures, this patch is intented to have no
user-visible impact.

Signed-off-by: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
---
 arch/alpha/kernel/osf_sys.c   |  4 ++--
 include/linux/compat_time.h   |  3 +--
 include/linux/resource.h      |  8 ++++++--
 include/linux/syscalls.h      |  7 +++----
 include/uapi/linux/resource.h | 32 ++++++++++++++++++++++++++++++++
 kernel/compat.c               | 42 +++++++++++++++++++++++++++++++++++++-----
 kernel/exit.c                 |  6 +++---
 kernel/sys.c                  | 23 ++++++++++++++---------
 8 files changed, 98 insertions(+), 27 deletions(-)

diff --git a/arch/alpha/kernel/osf_sys.c b/arch/alpha/kernel/osf_sys.c
index e51f578636a5..6824e68d32ad 100644
--- a/arch/alpha/kernel/osf_sys.c
+++ b/arch/alpha/kernel/osf_sys.c
@@ -1166,7 +1166,7 @@ SYSCALL_DEFINE2(osf_getrusage, int, who, struct rusage32 __user *, ru)
 SYSCALL_DEFINE4(osf_wait4, pid_t, pid, int __user *, ustatus, int, options,
 		struct rusage32 __user *, ur)
 {
-	struct rusage r;
+	struct __kernel_rusage r;
 	long ret, err;
 	unsigned int status = 0;
 	mm_segment_t old_fs;
@@ -1178,7 +1178,7 @@ SYSCALL_DEFINE4(osf_wait4, pid_t, pid, int __user *, ustatus, int, options,
 		
 	set_fs (KERNEL_DS);
 	ret = sys_wait4(pid, (unsigned int __user *) &status, options,
-			(struct rusage __user *) &r);
+			(struct __kernel_rusage __user *) &r);
 	set_fs (old_fs);
 
 	if (!access_ok(VERIFY_WRITE, ur, sizeof(*ur)))
diff --git a/include/linux/compat_time.h b/include/linux/compat_time.h
index 789b6415e90e..e3b43bd79801 100644
--- a/include/linux/compat_time.h
+++ b/include/linux/compat_time.h
@@ -141,8 +141,7 @@ struct compat_rusage {
 	compat_long_t	ru_nivcsw;
 };
 
-struct rusage;
-extern int put_compat_rusage(const struct rusage *,
+extern int put_compat_rusage(const struct __kernel_rusage *,
 			     struct compat_rusage __user *);
 
 static inline int compat_timeval_compare(struct compat_timeval *lhs,
diff --git a/include/linux/resource.h b/include/linux/resource.h
index 5bc3116e649c..8cdecf204607 100644
--- a/include/linux/resource.h
+++ b/include/linux/resource.h
@@ -1,12 +1,16 @@
 #ifndef _LINUX_RESOURCE_H
 #define _LINUX_RESOURCE_H
 
-#include <uapi/linux/resource.h>
+#ifndef CONFIG_COMPAT_TIME
+#define __kernel_rusage rusage
+#endif
 
+#include <uapi/linux/resource.h>
 
 struct task_struct;
 
-int getrusage(struct task_struct *p, int who, struct rusage __user *ru);
+int getrusage(struct task_struct *p, int who,
+	      struct __kernel_rusage __user *ru);
 int do_prlimit(struct task_struct *tsk, unsigned int resource,
 		struct rlimit *new_rlim, struct rlimit *old_rlim);
 
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 71b574b0365e..f3fdc312627b 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -36,7 +36,6 @@ struct old_utsname;
 struct pollfd;
 struct rlimit;
 struct rlimit64;
-struct rusage;
 struct sched_param;
 struct sched_attr;
 struct sel_arg_struct;
@@ -325,10 +324,10 @@ asmlinkage long sys_kexec_file_load(int kernel_fd, int initrd_fd,
 asmlinkage long sys_exit(int error_code);
 asmlinkage long sys_exit_group(int error_code);
 asmlinkage long sys_wait4(pid_t pid, int __user *stat_addr,
-				int options, struct rusage __user *ru);
+				int options, struct __kernel_rusage __user *ru);
 asmlinkage long sys_waitid(int which, pid_t pid,
 			   struct siginfo __user *infop,
-			   int options, struct rusage __user *ru);
+			   int options, struct __kernel_rusage __user *ru);
 asmlinkage long sys_waitpid(pid_t pid, int __user *stat_addr, int options);
 asmlinkage long sys_set_tid_address(int __user *tidptr);
 asmlinkage long sys_futex(u32 __user *uaddr, int op, u32 val,
@@ -650,7 +649,7 @@ asmlinkage long sys_setrlimit(unsigned int resource,
 asmlinkage long sys_prlimit64(pid_t pid, unsigned int resource,
 				const struct rlimit64 __user *new_rlim,
 				struct rlimit64 __user *old_rlim);
-asmlinkage long sys_getrusage(int who, struct rusage __user *ru);
+asmlinkage long sys_getrusage(int who, struct __kernel_rusage __user *ru);
 asmlinkage long sys_umask(int mask);
 
 asmlinkage long sys_msgget(key_t key, int msgflg);
diff --git a/include/uapi/linux/resource.h b/include/uapi/linux/resource.h
index 36fb3b5fb181..c4f3ba44db00 100644
--- a/include/uapi/linux/resource.h
+++ b/include/uapi/linux/resource.h
@@ -39,6 +39,38 @@ struct	rusage {
 	__kernel_long_t	ru_nivcsw;	/* involuntary " */
 };
 
+
+/*
+ * __kernel_rusage replaces rusage, and matches the layout of 64-bit rusage
+ * on both 32-bit and 64-bit machines, to let 32-bit user space migrate to
+ * 64-bit tv_sec.
+ */
+#ifndef __kernel_rusage
+struct __kernel_rusage_timeval {
+	__s64	tv_sec;
+	__s64	tv_usec;
+};
+
+struct	__kernel_rusage {
+	struct __kernel_rusage_timeval ru_utime; /* user time used */
+	struct __kernel_rusage_timeval ru_stime; /* system time used */
+	__s64	ru_maxrss;	/* maximum resident set size */
+	__s64	ru_ixrss;	/* integral shared memory size */
+	__s64	ru_idrss;	/* integral unshared data size */
+	__s64	ru_isrss;	/* integral unshared stack size */
+	__s64	ru_minflt;	/* page reclaims */
+	__s64	ru_majflt;	/* page faults */
+	__s64	ru_nswap;	/* swaps */
+	__s64	ru_inblock;	/* block input operations */
+	__s64	ru_oublock;	/* block output operations */
+	__s64	ru_msgsnd;	/* messages sent */
+	__s64	ru_msgrcv;	/* messages received */
+	__s64	ru_nsignals;	/* signals received */
+	__s64	ru_nvcsw;	/* voluntary context switches */
+	__s64	ru_nivcsw;	/* involuntary " */
+};
+#endif
+
 struct rlimit {
 	__kernel_ulong_t	rlim_cur;
 	__kernel_ulong_t	rlim_max;
diff --git a/kernel/compat.c b/kernel/compat.c
index 03bb63995027..e56ee6a23c0f 100644
--- a/kernel/compat.c
+++ b/kernel/compat.c
@@ -517,7 +517,7 @@ COMPAT_SYSCALL_DEFINE2(getrlimit, unsigned int, resource,
 #endif
 
 #ifdef CONFIG_COMPAT_TIME
-int put_compat_rusage(const struct rusage *r, struct compat_rusage __user *ru)
+int put_compat_rusage(const struct __kernel_rusage *r, struct compat_rusage __user *ru)
 {
 	if (!access_ok(VERIFY_WRITE, ru, sizeof(*ru)) ||
 	    __put_user(r->ru_utime.tv_sec, &ru->ru_utime.tv_sec) ||
@@ -551,7 +551,7 @@ COMPAT_SYSCALL_DEFINE4(wait4,
 	if (!ru) {
 		return sys_wait4(pid, stat_addr, options, NULL);
 	} else {
-		struct rusage r;
+		struct __kernel_rusage r;
 		int ret;
 		unsigned int status;
 		mm_segment_t old_fs = get_fs();
@@ -560,7 +560,7 @@ COMPAT_SYSCALL_DEFINE4(wait4,
 		ret = sys_wait4(pid,
 				(stat_addr ?
 				 (unsigned int __user *) &status : NULL),
-				options, (struct rusage __user *) &r);
+				options, (struct __kernel_rusage __user *) &r);
 		set_fs (old_fs);
 
 		if (ret > 0) {
@@ -579,7 +579,7 @@ COMPAT_SYSCALL_DEFINE5(waitid,
 		struct compat_rusage __user *, uru)
 {
 	siginfo_t info;
-	struct rusage ru;
+	struct __kernel_rusage ru;
 	long ret;
 	mm_segment_t old_fs = get_fs();
 
@@ -587,7 +587,7 @@ COMPAT_SYSCALL_DEFINE5(waitid,
 
 	set_fs(KERNEL_DS);
 	ret = sys_waitid(which, pid, (siginfo_t __user *)&info, options,
-			 uru ? (struct rusage __user *)&ru : NULL);
+			 uru ? (struct __kernel_rusage __user *)&ru : NULL);
 	set_fs(old_fs);
 
 	if ((ret < 0) || (info.si_signo == 0))
@@ -610,6 +610,38 @@ COMPAT_SYSCALL_DEFINE5(waitid,
 #endif
 
 #ifdef CONFIG_COMPAT
+COMPAT_SYSCALL_DEFINE5(waitid_time64,
+		int, which, compat_pid_t, pid,
+		struct compat_siginfo __user *, uinfo, int, options,
+		struct compat_rusage __user *, uru)
+{
+	siginfo_t info;
+	struct __kernel_rusage ru;
+	long ret;
+	mm_segment_t old_fs = get_fs();
+
+	memset(&info, 0, sizeof(info));
+
+	set_fs(KERNEL_DS);
+	ret = sys_waitid(which, pid, (siginfo_t __user *)&info, options,
+			 uru ? (struct __kernel_rusage __user *)&ru : NULL);
+	set_fs(old_fs);
+
+	if ((ret < 0) || (info.si_signo == 0))
+		return ret;
+
+	if (uru) {
+		/* sys_waitid() overwrites everything in ru */
+		ret = copy_to_user(uru, &ru, sizeof(ru));
+		if (ret)
+			return -EFAULT;
+	}
+
+	BUG_ON(info.si_code & __SI_MASK);
+	info.si_code |= __SI_CHLD;
+	return copy_siginfo_to_user32(uinfo, &info);
+}
+
 static int compat_get_user_cpu_mask(compat_ulong_t __user *user_mask_ptr,
 				    unsigned len, struct cpumask *new_mask)
 {
diff --git a/kernel/exit.c b/kernel/exit.c
index 22fcc05dec40..bf2de12e6ae1 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -894,7 +894,7 @@ struct wait_opts {
 
 	struct siginfo __user	*wo_info;
 	int __user		*wo_stat;
-	struct rusage __user	*wo_rusage;
+	struct __kernel_rusage __user *wo_rusage;
 
 	wait_queue_t		child_wait;
 	int			notask_error;
@@ -1514,7 +1514,7 @@ end:
 }
 
 SYSCALL_DEFINE5(waitid, int, which, pid_t, upid, struct siginfo __user *,
-		infop, int, options, struct rusage __user *, ru)
+		infop, int, options, struct __kernel_rusage __user *, ru)
 {
 	struct wait_opts wo;
 	struct pid *pid = NULL;
@@ -1582,7 +1582,7 @@ SYSCALL_DEFINE5(waitid, int, which, pid_t, upid, struct siginfo __user *,
 }
 
 SYSCALL_DEFINE4(wait4, pid_t, upid, int __user *, stat_addr,
-		int, options, struct rusage __user *, ru)
+		int, options, struct __kernel_rusage __user *, ru)
 {
 	struct wait_opts wo;
 	struct pid *pid = NULL;
diff --git a/kernel/sys.c b/kernel/sys.c
index a4e372b798a5..e578f33a286e 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1529,7 +1529,7 @@ SYSCALL_DEFINE2(setrlimit, unsigned int, resource, struct rlimit __user *, rlim)
  *
  */
 
-static void accumulate_thread_rusage(struct task_struct *t, struct rusage *r)
+static void accumulate_thread_rusage(struct task_struct *t, struct __kernel_rusage *r)
 {
 	r->ru_nvcsw += t->nvcsw;
 	r->ru_nivcsw += t->nivcsw;
@@ -1539,12 +1539,13 @@ static void accumulate_thread_rusage(struct task_struct *t, struct rusage *r)
 	r->ru_oublock += task_io_get_oublock(t);
 }
 
-static void k_getrusage(struct task_struct *p, int who, struct rusage *r)
+static void k_getrusage(struct task_struct *p, int who, struct __kernel_rusage *r)
 {
 	struct task_struct *t;
 	unsigned long flags;
 	cputime_t tgutime, tgstime, utime, stime;
 	unsigned long maxrss = 0;
+	struct timeval tv;
 
 	memset((char *)r, 0, sizeof (*r));
 	utime = stime = 0;
@@ -1599,8 +1600,12 @@ static void k_getrusage(struct task_struct *p, int who, struct rusage *r)
 	unlock_task_sighand(p, &flags);
 
 out:
-	cputime_to_timeval(utime, &r->ru_utime);
-	cputime_to_timeval(stime, &r->ru_stime);
+	cputime_to_timeval(utime, &tv);
+	r->ru_utime.tv_sec = tv.tv_sec;
+	r->ru_utime.tv_usec = tv.tv_usec;
+	cputime_to_timeval(stime, &tv);
+	r->ru_stime.tv_sec = tv.tv_sec;
+	r->ru_stime.tv_usec = tv.tv_usec;
 
 	if (who != RUSAGE_CHILDREN) {
 		struct mm_struct *mm = get_task_mm(p);
@@ -1613,15 +1618,15 @@ out:
 	r->ru_maxrss = maxrss * (PAGE_SIZE / 1024); /* convert pages to KBs */
 }
 
-int getrusage(struct task_struct *p, int who, struct rusage __user *ru)
+int getrusage(struct task_struct *p, int who, struct __kernel_rusage __user *ru)
 {
-	struct rusage r;
+	struct __kernel_rusage r;
 
 	k_getrusage(p, who, &r);
 	return copy_to_user(ru, &r, sizeof(r)) ? -EFAULT : 0;
 }
 
-SYSCALL_DEFINE2(getrusage, int, who, struct rusage __user *, ru)
+SYSCALL_DEFINE2(getrusage, int, who, struct __kernel_rusage __user *, ru)
 {
 	if (who != RUSAGE_SELF && who != RUSAGE_CHILDREN &&
 	    who != RUSAGE_THREAD)
@@ -1629,10 +1634,10 @@ SYSCALL_DEFINE2(getrusage, int, who, struct rusage __user *, ru)
 	return getrusage(current, who, ru);
 }
 
-#ifdef CONFIG_COMPAT
+#ifdef CONFIG_COMPAT_TIME
 COMPAT_SYSCALL_DEFINE2(getrusage, int, who, struct compat_rusage __user *, ru)
 {
-	struct rusage r;
+	struct __kernel_rusage r;
 
 	if (who != RUSAGE_SELF && who != RUSAGE_CHILDREN &&
 	    who != RUSAGE_THREAD)
-- 
2.1.0.rc2
