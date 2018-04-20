From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v2 2/2] rusage: allow 64-bit times ru_utime/ru_stime
Date: Fri, 20 Apr 2018 14:05:14 +0200
Message-ID: <20180420120605.1612248-2-arnd@arndb.de>
References: <20180420120605.1612248-1-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180420120605.1612248-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: y2038@lists.linaro.org
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, linux-api@vger.kernel.org, linux-arch@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Paul Eggert <eggert@cs.ucla.edu>, "Eric W . Biederman" <ebiederm@xmission.com>, Richard Henderson <rth@twiddle.net>, Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Matt Turner <mattst88@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, Dominik Brodowski <linux@dominikbrodowski.net>, Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@linux-foundation.org>, linux-alpha@vger.kernel.org, Deepa Dinamani <deepa.kernel@gmail.com>, Ingo Molnar <mingo@kernel.org>
List-Id: linux-api@vger.kernel.org

As part of the y2038 system call work, the getrusage/wait4/waitid system
calls came up, since they pass time data to user space in 'timeval'
format as required by POSIX. This means the existing kernel data structure
is no longer compatible with the one from user space once we have a C
library exposing 64-bit time_t, requiring the library to convert the
kernel structure into its own structure.

This patch moves that conversion into the kernel itself, providing a
set of system calls that can directly be used to implement the libc
getrusage/wait4/waitid functions as we have traditionally done.

There are two advantages to this:

- The new path becomes the native case, avoiding the conversion
  overhead for future 32-bit C libraries.  At least glibc will still
  have to implement a conversion logic as a fallback in order to run
  new applications on older kernels, but that does not have to be used
  on new kernels.
- The range for the ru_utime/ru_stime is no longer limited to
  a 31-bit second counter (about 68 years). That limit may theoretically
  be hit on large SMP systems with a single process running for an
  extended time, e.g. 256 concurrent threads running for more than
  97 days.  Note that there is no overflow in 2038, as all the times
  are relative to the start of a process.

The downside of this is obviously the added complexity of having three
additional system call entry points plus their respective compat handlers,
and updated syscall tables on each architecture (not included in this
patch). Overall, I think this is *not* worth it, but I feel it's important
to show how it can be done and what the cost is.

There are probably some minor improvements that can be implemented on top,
as well as bugs that I introduce.  When reviewing this patch, let's for
now focus instead on the question whether we want it at all or not.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/alpha/kernel/osf_sys.c   |   2 +-
 include/linux/compat.h        |  26 ++++++++-
 include/linux/resource.h      |   4 +-
 include/linux/sched/task.h    |   4 +-
 include/linux/syscalls.h      |   8 +++
 include/uapi/linux/resource.h |  29 ++++++++++
 kernel/compat.c               |  30 ++++++++++-
 kernel/exit.c                 | 120 ++++++++++++++++++++++++++++++++++++++----
 kernel/sys.c                  |  74 +++++++++++++++++++++++---
 9 files changed, 275 insertions(+), 22 deletions(-)

diff --git a/arch/alpha/kernel/osf_sys.c b/arch/alpha/kernel/osf_sys.c
index cad03ee445b3..aecdb48257b5 100644
--- a/arch/alpha/kernel/osf_sys.c
+++ b/arch/alpha/kernel/osf_sys.c
@@ -1185,7 +1185,7 @@ SYSCALL_DEFINE4(osf_wait4, pid_t, pid, int __user *, ustatus, int, options,
 {
 	unsigned int status = 0;
 	struct rusage32 r32;
-	struct rusage r;
+	struct __kernel_rusage r;
 	long err = kernel_wait4(pid, &status, options, &r);
 	if (err <= 0)
 		return err;
diff --git a/include/linux/compat.h b/include/linux/compat.h
index b73e2616a409..2ef30d314c48 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -105,7 +105,7 @@ typedef __compat_uid32_t	compat_uid_t;
 typedef __compat_gid32_t	compat_gid_t;
 
 struct compat_sel_arg_struct;
-struct rusage;
+struct __kernel_rusage;
 
 struct compat_itimerspec {
 	struct compat_timespec it_interval;
@@ -321,9 +321,31 @@ struct compat_rusage {
 	compat_long_t	ru_nivcsw;
 };
 
-extern int put_compat_rusage(const struct rusage *,
+struct compat_rusage_time64 {
+	struct __kernel_rusage_timeval ru_utime;
+	struct __kernel_rusage_timeval ru_stime;
+	compat_long_t	ru_maxrss;
+	compat_long_t	ru_ixrss;
+	compat_long_t	ru_idrss;
+	compat_long_t	ru_isrss;
+	compat_long_t	ru_minflt;
+	compat_long_t	ru_majflt;
+	compat_long_t	ru_nswap;
+	compat_long_t	ru_inblock;
+	compat_long_t	ru_oublock;
+	compat_long_t	ru_msgsnd;
+	compat_long_t	ru_msgrcv;
+	compat_long_t	ru_nsignals;
+	compat_long_t	ru_nvcsw;
+	compat_long_t	ru_nivcsw;
+};
+
+extern int put_compat_rusage(const struct __kernel_rusage *,
 			     struct compat_rusage __user *);
 
+extern int put_compat_rusage_time64(const struct __kernel_rusage *,
+				    struct compat_rusage_time64 __user *);
+
 struct compat_siginfo;
 
 struct compat_dirent {
diff --git a/include/linux/resource.h b/include/linux/resource.h
index bdf491cbcab7..8cebf90e76b7 100644
--- a/include/linux/resource.h
+++ b/include/linux/resource.h
@@ -7,8 +7,10 @@
 
 struct task_struct;
 
-void getrusage(struct task_struct *p, int who, struct rusage *ru);
+void getrusage(struct task_struct *p, int who, struct __kernel_rusage *ru);
 int do_prlimit(struct task_struct *tsk, unsigned int resource,
 		struct rlimit *new_rlim, struct rlimit *old_rlim);
 
+int put_rusage(const struct __kernel_rusage *rk, struct rusage __user *ru);
+
 #endif
diff --git a/include/linux/sched/task.h b/include/linux/sched/task.h
index 5be31eb7b266..cc54ae5e6010 100644
--- a/include/linux/sched/task.h
+++ b/include/linux/sched/task.h
@@ -10,7 +10,7 @@
 #include <linux/sched.h>
 
 struct task_struct;
-struct rusage;
+struct __kernel_rusage;
 union thread_union;
 
 /*
@@ -75,7 +75,7 @@ extern long _do_fork(unsigned long, unsigned long, unsigned long, int __user *,
 extern long do_fork(unsigned long, unsigned long, unsigned long, int __user *, int __user *);
 struct task_struct *fork_idle(int);
 extern pid_t kernel_thread(int (*fn)(void *), void *arg, unsigned long flags);
-extern long kernel_wait4(pid_t, int *, int, struct rusage *);
+extern long kernel_wait4(pid_t, int *, int, struct __kernel_rusage *);
 
 extern void free_task(struct task_struct *tsk);
 
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index a756ab42894f..084360078f29 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -37,6 +37,7 @@ struct pollfd;
 struct rlimit;
 struct rlimit64;
 struct rusage;
+struct __kernel_rusage;
 struct sched_param;
 struct sched_attr;
 struct sel_arg_struct;
@@ -522,6 +523,10 @@ asmlinkage long sys_waitid(int which, pid_t pid,
 			   struct siginfo __user *infop,
 			   int options, struct rusage __user *ru);
 
+asmlinkage long sys_waitid_time64(int which, pid_t pid,
+			   struct siginfo __user *infop,
+			   int options, struct __kernel_rusage __user *ru);
+
 /* kernel/fork.c */
 asmlinkage long sys_set_tid_address(int __user *tidptr);
 asmlinkage long sys_unshare(unsigned long unshare_flags);
@@ -656,6 +661,7 @@ asmlinkage long sys_getrlimit(unsigned int resource,
 asmlinkage long sys_setrlimit(unsigned int resource,
 				struct rlimit __user *rlim);
 asmlinkage long sys_getrusage(int who, struct rusage __user *ru);
+asmlinkage long sys_getrusage_time64(int who, struct __kernel_rusage __user *ru);
 asmlinkage long sys_umask(int mask);
 asmlinkage long sys_prctl(int option, unsigned long arg2, unsigned long arg3,
 			unsigned long arg4, unsigned long arg5);
@@ -821,6 +827,8 @@ asmlinkage long sys_recvmmsg(int fd, struct mmsghdr __user *msg,
 
 asmlinkage long sys_wait4(pid_t pid, int __user *stat_addr,
 				int options, struct rusage __user *ru);
+asmlinkage long sys_wait4_time64(pid_t pid, int __user *stat_addr,
+				int options, struct __kernel_rusage __user *ru);
 asmlinkage long sys_prlimit64(pid_t pid, unsigned int resource,
 				const struct rlimit64 __user *new_rlim,
 				struct rlimit64 __user *old_rlim);
diff --git a/include/uapi/linux/resource.h b/include/uapi/linux/resource.h
index 611d3745c70a..a822e716e122 100644
--- a/include/uapi/linux/resource.h
+++ b/include/uapi/linux/resource.h
@@ -50,6 +50,35 @@ struct	rusage {
 	__kernel_long_t	ru_nivcsw;	/* involuntary " */
 };
 
+/*
+ * __kernel_rusage is the binary that we expect 32-bit C libraries
+ * to provide for their 'struct rusage' after migrating to a 64-bit
+ * time_t.
+ */
+struct __kernel_rusage_timeval {
+	__s64 tv_sec;
+	__s64 tv_usec;
+};
+
+struct	__kernel_rusage {
+	struct __kernel_rusage_timeval	ru_utime; /* user time used */
+	struct __kernel_rusage_timeval	ru_stime; /* system time used */
+	__kernel_long_t	ru_maxrss;	/* maximum resident set size */
+	__kernel_long_t	ru_ixrss;	/* integral shared memory size */
+	__kernel_long_t	ru_idrss;	/* integral unshared data size */
+	__kernel_long_t	ru_isrss;	/* integral unshared stack size */
+	__kernel_long_t	ru_minflt;	/* page reclaims */
+	__kernel_long_t	ru_majflt;	/* page faults */
+	__kernel_long_t	ru_nswap;	/* swaps */
+	__kernel_long_t	ru_inblock;	/* block input operations */
+	__kernel_long_t	ru_oublock;	/* block output operations */
+	__kernel_long_t	ru_msgsnd;	/* messages sent */
+	__kernel_long_t	ru_msgrcv;	/* messages received */
+	__kernel_long_t	ru_nsignals;	/* signals received */
+	__kernel_long_t	ru_nvcsw;	/* voluntary context switches */
+	__kernel_long_t	ru_nivcsw;	/* involuntary " */
+};
+
 struct rlimit {
 	__kernel_ulong_t	rlim_cur;
 	__kernel_ulong_t	rlim_max;
diff --git a/kernel/compat.c b/kernel/compat.c
index 51a081b46832..e3cb7c14558a 100644
--- a/kernel/compat.c
+++ b/kernel/compat.c
@@ -234,7 +234,7 @@ COMPAT_SYSCALL_DEFINE3(sigprocmask, int, how,
 
 #endif
 
-int put_compat_rusage(const struct rusage *r, struct compat_rusage __user *ru)
+int put_compat_rusage(const struct __kernel_rusage *r, struct compat_rusage __user *ru)
 {
 	struct compat_rusage r32;
 	memset(&r32, 0, sizeof(r32));
@@ -261,6 +261,34 @@ int put_compat_rusage(const struct rusage *r, struct compat_rusage __user *ru)
 	return 0;
 }
 
+int put_compat_rusage_time64(const struct __kernel_rusage *r,
+			     struct compat_rusage_time64 __user *ru)
+{
+	struct compat_rusage_time64 r32;
+	memset(&r32, 0, sizeof(r32));
+	r32.ru_utime.tv_sec = r->ru_utime.tv_sec;
+	r32.ru_utime.tv_usec = r->ru_utime.tv_usec;
+	r32.ru_stime.tv_sec = r->ru_stime.tv_sec;
+	r32.ru_stime.tv_usec = r->ru_stime.tv_usec;
+	r32.ru_maxrss = r->ru_maxrss;
+	r32.ru_ixrss = r->ru_ixrss;
+	r32.ru_idrss = r->ru_idrss;
+	r32.ru_isrss = r->ru_isrss;
+	r32.ru_minflt = r->ru_minflt;
+	r32.ru_majflt = r->ru_majflt;
+	r32.ru_nswap = r->ru_nswap;
+	r32.ru_inblock = r->ru_inblock;
+	r32.ru_oublock = r->ru_oublock;
+	r32.ru_msgsnd = r->ru_msgsnd;
+	r32.ru_msgrcv = r->ru_msgrcv;
+	r32.ru_nsignals = r->ru_nsignals;
+	r32.ru_nvcsw = r->ru_nvcsw;
+	r32.ru_nivcsw = r->ru_nivcsw;
+	if (copy_to_user(ru, &r32, sizeof(r32)))
+		return -EFAULT;
+	return 0;
+}
+
 static int compat_get_user_cpu_mask(compat_ulong_t __user *user_mask_ptr,
 				    unsigned len, struct cpumask *new_mask)
 {
diff --git a/kernel/exit.c b/kernel/exit.c
index c3c7ac560114..5088c671ea74 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -995,7 +995,7 @@ struct wait_opts {
 
 	struct waitid_info	*wo_info;
 	int			wo_stat;
-	struct rusage		*wo_rusage;
+	struct __kernel_rusage	*wo_rusage;
 
 	wait_queue_entry_t		child_wait;
 	int			notask_error;
@@ -1548,7 +1548,7 @@ static long do_wait(struct wait_opts *wo)
 }
 
 static long kernel_waitid(int which, pid_t upid, struct waitid_info *infop,
-			  int options, struct rusage *ru)
+			  int options, struct __kernel_rusage *ru)
 {
 	struct wait_opts wo;
 	struct pid *pid = NULL;
@@ -1596,7 +1596,7 @@ static long kernel_waitid(int which, pid_t upid, struct waitid_info *infop,
 SYSCALL_DEFINE5(waitid, int, which, pid_t, upid, struct siginfo __user *,
 		infop, int, options, struct rusage __user *, ru)
 {
-	struct rusage r;
+	struct __kernel_rusage r;
 	struct waitid_info info = {.status = 0};
 	long err = kernel_waitid(which, upid, &info, options, ru ? &r : NULL);
 	int signo = 0;
@@ -1604,7 +1604,41 @@ SYSCALL_DEFINE5(waitid, int, which, pid_t, upid, struct siginfo __user *,
 	if (err > 0) {
 		signo = SIGCHLD;
 		err = 0;
-		if (ru && copy_to_user(ru, &r, sizeof(struct rusage)))
+		if (ru && put_rusage(&r, ru))
+			return -EFAULT;
+	}
+	if (!infop)
+		return err;
+
+	if (!access_ok(VERIFY_WRITE, infop, sizeof(*infop)))
+		return -EFAULT;
+
+	user_access_begin();
+	unsafe_put_user(signo, &infop->si_signo, Efault);
+	unsafe_put_user(0, &infop->si_errno, Efault);
+	unsafe_put_user(info.cause, &infop->si_code, Efault);
+	unsafe_put_user(info.pid, &infop->si_pid, Efault);
+	unsafe_put_user(info.uid, &infop->si_uid, Efault);
+	unsafe_put_user(info.status, &infop->si_status, Efault);
+	user_access_end();
+	return err;
+Efault:
+	user_access_end();
+	return -EFAULT;
+}
+
+SYSCALL_DEFINE5(waitid_time64, int, which, pid_t, upid, struct siginfo __user *,
+		infop, int, options, struct __kernel_rusage __user *, ru)
+{
+	struct __kernel_rusage r;
+	struct waitid_info info = {.status = 0};
+	long err = kernel_waitid(which, upid, &info, options, ru ? &r : NULL);
+	int signo = 0;
+
+	if (err > 0) {
+		signo = SIGCHLD;
+		err = 0;
+		if (ru && copy_to_user(ru, &r, sizeof(struct __kernel_rusage)))
 			return -EFAULT;
 	}
 	if (!infop)
@@ -1628,7 +1662,7 @@ SYSCALL_DEFINE5(waitid, int, which, pid_t, upid, struct siginfo __user *,
 }
 
 long kernel_wait4(pid_t upid, int __user *stat_addr, int options,
-		  struct rusage *ru)
+		  struct __kernel_rusage *ru)
 {
 	struct wait_opts wo;
 	struct pid *pid = NULL;
@@ -1673,11 +1707,24 @@ long kernel_wait4(pid_t upid, int __user *stat_addr, int options,
 SYSCALL_DEFINE4(wait4, pid_t, upid, int __user *, stat_addr,
 		int, options, struct rusage __user *, ru)
 {
-	struct rusage r;
+	struct __kernel_rusage r;
 	long err = kernel_wait4(upid, stat_addr, options, ru ? &r : NULL);
 
 	if (err > 0) {
-		if (ru && copy_to_user(ru, &r, sizeof(struct rusage)))
+		if (ru && put_rusage(&r, ru))
+			return -EFAULT;
+	}
+	return err;
+}
+
+SYSCALL_DEFINE4(wait4_time64, pid_t, upid, int __user *, stat_addr,
+		int, options, struct __kernel_rusage __user *, ru)
+{
+	struct __kernel_rusage r;
+	long err = kernel_wait4(upid, stat_addr, options, ru ? &r : NULL);
+
+	if (err > 0) {
+		if (ru && copy_to_user(ru, &r, sizeof(struct __kernel_rusage)))
 			return -EFAULT;
 	}
 	return err;
@@ -1703,7 +1750,7 @@ COMPAT_SYSCALL_DEFINE4(wait4,
 	int, options,
 	struct compat_rusage __user *, ru)
 {
-	struct rusage r;
+	struct __kernel_rusage r;
 	long err = kernel_wait4(pid, stat_addr, options, ru ? &r : NULL);
 	if (err > 0) {
 		if (ru && put_compat_rusage(&r, ru))
@@ -1712,12 +1759,27 @@ COMPAT_SYSCALL_DEFINE4(wait4,
 	return err;
 }
 
+COMPAT_SYSCALL_DEFINE4(wait4_time64,
+	compat_pid_t, pid,
+	compat_uint_t __user *, stat_addr,
+	int, options,
+	struct compat_rusage_time64 __user *, ru)
+{
+	struct __kernel_rusage r;
+	long err = kernel_wait4(pid, stat_addr, options, ru ? &r : NULL);
+	if (err > 0) {
+		if (ru && put_compat_rusage_time64(&r, ru))
+			return -EFAULT;
+	}
+	return err;
+}
+
 COMPAT_SYSCALL_DEFINE5(waitid,
 		int, which, compat_pid_t, pid,
 		struct compat_siginfo __user *, infop, int, options,
 		struct compat_rusage __user *, uru)
 {
-	struct rusage ru;
+	struct __kernel_rusage ru;
 	struct waitid_info info = {.status = 0};
 	long err = kernel_waitid(which, pid, &info, options, uru ? &ru : NULL);
 	int signo = 0;
@@ -1754,6 +1816,46 @@ COMPAT_SYSCALL_DEFINE5(waitid,
 	user_access_end();
 	return -EFAULT;
 }
+
+COMPAT_SYSCALL_DEFINE5(waitid_time64,
+		int, which, compat_pid_t, pid,
+		struct compat_siginfo __user *, infop, int, options,
+		struct compat_rusage_time64 __user *, uru)
+{
+	struct __kernel_rusage ru;
+	struct waitid_info info = {.status = 0};
+	long err = kernel_waitid(which, pid, &info, options, uru ? &ru : NULL);
+	int signo = 0;
+	if (err > 0) {
+		signo = SIGCHLD;
+		err = 0;
+		if (uru) {
+			/* kernel_waitid() overwrites everything in ru */
+			err = put_compat_rusage_time64(&ru, uru);
+			if (err)
+				return -EFAULT;
+		}
+	}
+
+	if (!infop)
+		return err;
+
+	if (!access_ok(VERIFY_WRITE, infop, sizeof(*infop)))
+		return -EFAULT;
+
+	user_access_begin();
+	unsafe_put_user(signo, &infop->si_signo, Efault);
+	unsafe_put_user(0, &infop->si_errno, Efault);
+	unsafe_put_user(info.cause, &infop->si_code, Efault);
+	unsafe_put_user(info.pid, &infop->si_pid, Efault);
+	unsafe_put_user(info.uid, &infop->si_uid, Efault);
+	unsafe_put_user(info.status, &infop->si_status, Efault);
+	user_access_end();
+	return err;
+Efault:
+	user_access_end();
+	return -EFAULT;
+}
 #endif
 
 __weak void abort(void)
diff --git a/kernel/sys.c b/kernel/sys.c
index 1de538f622e8..5b5f2dc19e79 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1699,7 +1699,7 @@ SYSCALL_DEFINE2(setrlimit, unsigned int, resource, struct rlimit __user *, rlim)
  *
  */
 
-static void accumulate_thread_rusage(struct task_struct *t, struct rusage *r)
+static void accumulate_thread_rusage(struct task_struct *t, struct __kernel_rusage *r)
 {
 	r->ru_nvcsw += t->nvcsw;
 	r->ru_nivcsw += t->nivcsw;
@@ -1709,12 +1709,13 @@ static void accumulate_thread_rusage(struct task_struct *t, struct rusage *r)
 	r->ru_oublock += task_io_get_oublock(t);
 }
 
-void getrusage(struct task_struct *p, int who, struct rusage *r)
+void getrusage(struct task_struct *p, int who, struct __kernel_rusage *r)
 {
 	struct task_struct *t;
 	unsigned long flags;
 	u64 tgutime, tgstime, utime, stime;
 	unsigned long maxrss = 0;
+	struct timespec64 ts;
 
 	memset((char *)r, 0, sizeof (*r));
 	utime = stime = 0;
@@ -1769,8 +1770,12 @@ void getrusage(struct task_struct *p, int who, struct rusage *r)
 	unlock_task_sighand(p, &flags);
 
 out:
-	r->ru_utime = ns_to_kernel_old_timeval(utime);
-	r->ru_stime = ns_to_kernel_old_timeval(stime);
+	ts = ns_to_timespec64(utime);
+	r->ru_utime.tv_sec = ts.tv_sec;
+	r->ru_utime.tv_usec = ts.tv_nsec / NSEC_PER_USEC;
+	ts = ns_to_timespec64(stime);
+	r->ru_stime.tv_sec = ts.tv_sec;
+	r->ru_stime.tv_usec = ts.tv_nsec / NSEC_PER_USEC;
 
 	if (who != RUSAGE_CHILDREN) {
 		struct mm_struct *mm = get_task_mm(p);
@@ -1783,10 +1788,54 @@ void getrusage(struct task_struct *p, int who, struct rusage *r)
 	r->ru_maxrss = maxrss * (PAGE_SIZE / 1024); /* convert pages to KBs */
 }
 
-SYSCALL_DEFINE2(getrusage, int, who, struct rusage __user *, ru)
+int put_rusage(const struct __kernel_rusage *rk, struct rusage __user *ru)
 {
 	struct rusage r;
 
+	if (IS_ENABLED(CONFIG_64BIT))
+		return copy_to_user(ru, &rk, sizeof(rk)) ? -EFAULT : 0;
+
+	memset(&r, 0, sizeof(r));
+	r.ru_utime.tv_sec = rk->ru_utime.tv_sec;
+	r.ru_utime.tv_usec = rk->ru_utime.tv_usec;
+	r.ru_stime.tv_sec = rk->ru_stime.tv_sec;
+	r.ru_stime.tv_usec = rk->ru_stime.tv_usec;
+	r.ru_maxrss = rk->ru_maxrss;
+	r.ru_ixrss = rk->ru_ixrss;
+	r.ru_idrss = rk->ru_idrss;
+	r.ru_isrss = rk->ru_isrss;
+	r.ru_minflt = rk->ru_minflt;
+	r.ru_majflt = rk->ru_majflt;
+	r.ru_nswap = rk->ru_nswap;
+	r.ru_inblock = rk->ru_inblock;
+	r.ru_oublock = rk->ru_oublock;
+	r.ru_msgsnd = rk->ru_msgsnd;
+	r.ru_msgrcv = rk->ru_msgrcv;
+	r.ru_nsignals = rk->ru_nsignals;
+	r.ru_nvcsw = rk->ru_nvcsw;
+	r.ru_nivcsw = rk->ru_nivcsw;
+	if (copy_to_user(ru, &r, sizeof(r)))
+		return -EFAULT;
+	return 0;
+}
+
+SYSCALL_DEFINE2(getrusage, int, who, struct rusage __user *, ru)
+{
+	struct __kernel_rusage r;
+
+	if (who != RUSAGE_SELF && who != RUSAGE_CHILDREN &&
+	    who != RUSAGE_THREAD)
+		return -EINVAL;
+
+	getrusage(current, who, &r);
+	return put_rusage(&r, ru);
+}
+
+#ifndef CONFIG_64BIT
+SYSCALL_DEFINE2(getrusage_time64, int, who, struct __kernel_rusage __user *, ru)
+{
+	struct __kernel_rusage r;
+
 	if (who != RUSAGE_SELF && who != RUSAGE_CHILDREN &&
 	    who != RUSAGE_THREAD)
 		return -EINVAL;
@@ -1794,11 +1843,12 @@ SYSCALL_DEFINE2(getrusage, int, who, struct rusage __user *, ru)
 	getrusage(current, who, &r);
 	return copy_to_user(ru, &r, sizeof(r)) ? -EFAULT : 0;
 }
+#endif
 
 #ifdef CONFIG_COMPAT
 COMPAT_SYSCALL_DEFINE2(getrusage, int, who, struct compat_rusage __user *, ru)
 {
-	struct rusage r;
+	struct __kernel_rusage r;
 
 	if (who != RUSAGE_SELF && who != RUSAGE_CHILDREN &&
 	    who != RUSAGE_THREAD)
@@ -1807,6 +1857,18 @@ COMPAT_SYSCALL_DEFINE2(getrusage, int, who, struct compat_rusage __user *, ru)
 	getrusage(current, who, &r);
 	return put_compat_rusage(&r, ru);
 }
+
+COMPAT_SYSCALL_DEFINE2(getrusage_time64, int, who, struct compat_rusage_time64 __user *, ru)
+{
+	struct __kernel_rusage r;
+
+	if (who != RUSAGE_SELF && who != RUSAGE_CHILDREN &&
+	    who != RUSAGE_THREAD)
+		return -EINVAL;
+
+	getrusage(current, who, &r);
+	return put_compat_rusage_time64(&r, ru);
+}
 #endif
 
 SYSCALL_DEFINE1(umask, int, mask)
-- 
2.9.0
