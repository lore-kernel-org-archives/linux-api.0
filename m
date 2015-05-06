From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: [PATCH 06/19] y2038: compile compat time code even when CONFIG_COMPAT is not set
Date: Wed,  6 May 2015 18:30:13 +0200
Message-ID: <1430929826-318934-7-git-send-email-arnd@arndb.de>
References: <1430929826-318934-1-git-send-email-arnd@arndb.de>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1430929826-318934-1-git-send-email-arnd-r2nGTMty4D4@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: y2038-cunTk1MwBs8s++Sfvej+rw@public.gmane.org
Cc: baolin.wang-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, albert.aribaud-iEu9NFBzPZE@public.gmane.org, john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, bamvor.zhangjian-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, ruchandani.tina-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, libc-alpha-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
List-Id: linux-api@vger.kernel.org

For the time being, we use conditional compilation in fs/compat.c
and kernel/compat.c to differentiate two cases:

a) code that is used for CONFIG_COMPAT_TIME is shared between
   32-bit and 64-bit architectures that provide support for
   existing 32-bit binaries with 32-bit time_t
b) code that is defined under CONFIG_COMPAT is only used on
   64-bit machines to provide support for 32-bit binaries,
   either system calls that do not use time_t or (rare) that use a
   64-bit time_t in compat mode.

We probably want to split those into separate files in the long
run, but at the moment, this makes it easier to avoid merge
conflicts.

Signed-off-by: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
---
 fs/Makefile                 |  1 +
 fs/compat.c                 | 12 +++++++++++-
 include/linux/thread_info.h |  2 +-
 kernel/Makefile             |  1 +
 kernel/compat.c             | 28 ++++++++++++++++++++++++++++
 5 files changed, 42 insertions(+), 2 deletions(-)

diff --git a/fs/Makefile b/fs/Makefile
index cb92fd4c3172..77f876cd94be 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -31,6 +31,7 @@ obj-$(CONFIG_AIO)               += aio.o
 obj-$(CONFIG_FS_DAX)		+= dax.o
 obj-$(CONFIG_FILE_LOCKING)      += locks.o
 obj-$(CONFIG_COMPAT)		+= compat.o compat_ioctl.o
+obj-$(CONFIG_COMPAT_TIME)	+= compat.o
 obj-$(CONFIG_BINFMT_AOUT)	+= binfmt_aout.o
 obj-$(CONFIG_BINFMT_EM86)	+= binfmt_em86.o
 obj-$(CONFIG_BINFMT_MISC)	+= binfmt_misc.o
diff --git a/fs/compat.c b/fs/compat.c
index 7d78cde20fc3..c5065aa1852c 100644
--- a/fs/compat.c
+++ b/fs/compat.c
@@ -54,6 +54,7 @@
 #include <asm/ioctls.h>
 #include "internal.h"
 
+#ifdef CONFIG_COMPAT_TIME
 /*
  * Not all architectures have sys_utime, so implement this in terms
  * of sys_utimes.
@@ -194,7 +195,9 @@ COMPAT_SYSCALL_DEFINE2(newfstat, unsigned int, fd,
 		error = cp_compat_stat(&stat, statbuf);
 	return error;
 }
+#endif /* CONFIG_COMPAT_TIME */
 
+#ifdef CONFIG_COMPAT
 static int put_compat_statfs(struct compat_statfs __user *ubuf, struct kstatfs *kbuf)
 {
 	
@@ -505,7 +508,9 @@ COMPAT_SYSCALL_DEFINE2(io_setup, unsigned, nr_reqs, u32 __user *, ctx32p)
 		ret = put_user((u32) ctx64, ctx32p);
 	return ret;
 }
+#endif
 
+#ifdef CONFIG_COMPAT_TIME
 COMPAT_SYSCALL_DEFINE5(io_getevents, compat_aio_context_t, ctx_id,
 		       compat_long_t, min_nr,
 		       compat_long_t, nr,
@@ -525,7 +530,9 @@ COMPAT_SYSCALL_DEFINE5(io_getevents, compat_aio_context_t, ctx_id,
 	} 
 	return sys_io_getevents(ctx_id, min_nr, nr, events, ut);
 }
+#endif
 
+#ifdef CONFIG_COMPAT
 /* A write operation does a read from user space and vice versa */
 #define vrfy_dir(type) ((type) == READ ? VERIFY_WRITE : VERIFY_READ)
 
@@ -1086,7 +1093,9 @@ COMPAT_SYSCALL_DEFINE4(openat, int, dfd, const char __user *, filename, int, fla
 {
 	return do_sys_open(dfd, filename, flags, mode);
 }
+#endif
 
+#ifdef CONFIG_COMPAT_TIME
 #define __COMPAT_NFDBITS       (8 * sizeof(compat_ulong_t))
 
 static int poll_select_copy_remaining(struct timespec *end_time, void __user *p,
@@ -1453,8 +1462,9 @@ COMPAT_SYSCALL_DEFINE5(ppoll, struct pollfd __user *, ufds,
 
 	return ret;
 }
+#endif
 
-#ifdef CONFIG_FHANDLE
+#if defined(CONFIG_FHANDLE) && defined(CONFIG_COMPAT)
 /*
  * Exactly like fs/open.c:sys_open_by_handle_at(), except that it
  * doesn't set the O_LARGEFILE flag.
diff --git a/include/linux/thread_info.h b/include/linux/thread_info.h
index ff307b548ed3..43686bb94374 100644
--- a/include/linux/thread_info.h
+++ b/include/linux/thread_info.h
@@ -32,7 +32,7 @@ struct restart_block {
 		struct {
 			clockid_t clockid;
 			struct timespec __user *rmtp;
-#ifdef CONFIG_COMPAT
+#ifdef CONFIG_COMPAT_TIME
 			struct compat_timespec __user *compat_rmtp;
 #endif
 			u64 expires;
diff --git a/kernel/Makefile b/kernel/Makefile
index 60c302cfb4d3..970f880a5f17 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -53,6 +53,7 @@ obj-$(CONFIG_BSD_PROCESS_ACCT) += acct.o
 obj-$(CONFIG_KEXEC) += kexec.o
 obj-$(CONFIG_BACKTRACE_SELF_TEST) += backtracetest.o
 obj-$(CONFIG_COMPAT) += compat.o
+obj-$(CONFIG_COMPAT_TIME) += compat.o
 obj-$(CONFIG_CGROUPS) += cgroup.o
 obj-$(CONFIG_CGROUP_FREEZER) += cgroup_freezer.o
 obj-$(CONFIG_CPUSETS) += cpuset.o
diff --git a/kernel/compat.c b/kernel/compat.c
index 24f00610c575..115ad84d4048 100644
--- a/kernel/compat.c
+++ b/kernel/compat.c
@@ -30,6 +30,7 @@
 
 #include <asm/uaccess.h>
 
+#ifdef CONFIG_COMPAT_TIME
 static int compat_get_timex(struct timex *txc, struct compat_timex __user *utp)
 {
 	memset(txc, 0, sizeof(struct timex));
@@ -190,6 +191,7 @@ int compat_put_timespec(const struct timespec *ts, void __user *uts)
 }
 EXPORT_SYMBOL_GPL(compat_put_timespec);
 
+#ifdef CONFIG_COMPAT
 int compat_convert_timespec(struct timespec __user **kts,
 			    const void __user *cts)
 {
@@ -212,6 +214,7 @@ int compat_convert_timespec(struct timespec __user **kts,
 	*kts = uts;
 	return 0;
 }
+#endif
 
 static long compat_nanosleep_restart(struct restart_block *restart)
 {
@@ -339,7 +342,9 @@ COMPAT_SYSCALL_DEFINE3(setitimer, int, which,
 		return -EFAULT;
 	return 0;
 }
+#endif
 
+#ifdef CONFIG_COMPAT
 static compat_clock_t clock_t_to_compat_clock_t(clock_t x)
 {
 	return compat_jiffies_to_clock_t(clock_t_to_jiffies(x));
@@ -507,7 +512,9 @@ COMPAT_SYSCALL_DEFINE2(getrlimit, unsigned int, resource,
 	}
 	return ret;
 }
+#endif
 
+#ifdef CONFIG_COMPAT_TIME
 int put_compat_rusage(const struct rusage *r, struct compat_rusage __user *ru)
 {
 	if (!access_ok(VERIFY_WRITE, ru, sizeof(*ru)) ||
@@ -598,7 +605,9 @@ COMPAT_SYSCALL_DEFINE5(waitid,
 	info.si_code |= __SI_CHLD;
 	return copy_siginfo_to_user32(uinfo, &info);
 }
+#endif
 
+#ifdef CONFIG_COMPAT
 static int compat_get_user_cpu_mask(compat_ulong_t __user *user_mask_ptr,
 				    unsigned len, struct cpumask *new_mask)
 {
@@ -660,7 +669,9 @@ COMPAT_SYSCALL_DEFINE3(sched_getaffinity, compat_pid_t,  pid, unsigned int, len,
 
 	return ret;
 }
+#endif
 
+#ifdef CONFIG_COMPAT_TIME
 int get_compat_itimerspec(struct itimerspec *dst,
 			  const struct compat_itimerspec __user *src)
 {
@@ -678,7 +689,9 @@ int put_compat_itimerspec(struct compat_itimerspec __user *dst,
 		return -EFAULT;
 	return 0;
 }
+#endif
 
+#ifdef CONFIG_COMPAT
 COMPAT_SYSCALL_DEFINE3(timer_create, clockid_t, which_clock,
 		       struct compat_sigevent __user *, timer_event_spec,
 		       timer_t __user *, created_timer_id)
@@ -696,7 +709,9 @@ COMPAT_SYSCALL_DEFINE3(timer_create, clockid_t, which_clock,
 
 	return sys_timer_create(which_clock, event, created_timer_id);
 }
+#endif
 
+#ifdef CONFIG_COMPAT_TIME
 COMPAT_SYSCALL_DEFINE4(timer_settime, timer_t, timer_id, int, flags,
 		       struct compat_itimerspec __user *, new,
 		       struct compat_itimerspec __user *, old)
@@ -865,7 +880,9 @@ COMPAT_SYSCALL_DEFINE4(clock_nanosleep, clockid_t, which_clock, int, flags,
 	}
 	return err;
 }
+#endif
 
+#ifdef CONFIG_COMPAT
 /*
  * We currently only need the following fields from the sigevent
  * structure: sigev_value, sigev_signo, sig_notify and (sometimes
@@ -991,6 +1008,7 @@ sigset_to_compat(compat_sigset_t *compat, const sigset_t *set)
 	}
 }
 
+#ifdef CONFIG_COMPAT_TIME
 COMPAT_SYSCALL_DEFINE4(rt_sigtimedwait, compat_sigset_t __user *, uthese,
 		struct compat_siginfo __user *, uinfo,
 		struct compat_timespec __user *, uts, compat_size_t, sigsetsize)
@@ -1022,7 +1040,10 @@ COMPAT_SYSCALL_DEFINE4(rt_sigtimedwait, compat_sigset_t __user *, uthese,
 
 	return ret;
 }
+#endif
+#endif
 
+#ifdef CONFIG_COMPAT_TIME
 #ifdef __ARCH_WANT_COMPAT_SYS_TIME
 
 /* compat_time_t is a 32 bit "long" and needs to get converted. */
@@ -1080,7 +1101,9 @@ COMPAT_SYSCALL_DEFINE1(adjtimex, struct compat_timex __user *, utp)
 
 	return ret;
 }
+#endif
 
+#ifdef CONFIG_COMPAT
 #ifdef CONFIG_NUMA
 COMPAT_SYSCALL_DEFINE6(move_pages, pid_t, pid, compat_ulong_t, nr_pages,
 		       compat_uptr_t __user *, pages32,
@@ -1135,7 +1158,9 @@ COMPAT_SYSCALL_DEFINE4(migrate_pages, compat_pid_t, pid,
 	return sys_migrate_pages(pid, nr_bits + 1, old, new);
 }
 #endif
+#endif
 
+#ifdef CONFIG_COMPAT_TIME
 COMPAT_SYSCALL_DEFINE2(sched_rr_get_interval,
 		       compat_pid_t, pid,
 		       struct compat_timespec __user *, interval)
@@ -1151,7 +1176,9 @@ COMPAT_SYSCALL_DEFINE2(sched_rr_get_interval,
 		return -EFAULT;
 	return ret;
 }
+#endif
 
+#ifdef CONFIG_COMPAT
 /*
  * Allocate user-space memory for the duration of a single system call,
  * in order to marshall parameters inside a compat thunk.
@@ -1172,3 +1199,4 @@ void __user *compat_alloc_user_space(unsigned long len)
 	return ptr;
 }
 EXPORT_SYMBOL_GPL(compat_alloc_user_space);
+#endif
-- 
2.1.0.rc2
