From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v2 1/2] y2038: rusage: Use __kernel_old_timeval for process times
Date: Fri, 20 Apr 2018 14:05:13 +0200
Message-ID: <20180420120605.1612248-1-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: y2038@lists.linaro.org
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, linux-api@vger.kernel.org, linux-arch@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Paul Eggert <eggert@cs.ucla.edu>, "Eric W . Biederman" <ebiederm@xmission.com>, Richard Henderson <rth@twiddle.net>, Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Matt Turner <mattst88@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, Dominik Brodowski <linux@dominikbrodowski.net>, Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@linux-foundation.org>, linux-alpha@vger.kernel.org
List-Id: linux-api@vger.kernel.org

'struct rusage' contains the run times of a process in 'timeval' format
and is accessed through the wait4() and getrusage() system calls. This
is not a problem for y2038 safety by itself, but causes an issue when
the C library starts using 64-bit time_t on 32-bit architectures because
the structure layout becomes incompatible.

There are three possible ways of dealing with this:

a) deprecate the wait4() and getrusage() system calls, and create
   a set of kernel interfaces based around a newly defined structure that
   could solve multiple problems at once, e.g. provide more fine-grained
   timestamps. The C library could then implement the posix interfaces
   on top of the new system calls.

b) Extend the approach taken by the x32 ABI, and use the 64-bit
   native structure layout for rusage on all architectures with new
   system calls that is otherwise compatible. A downside of this
   is that it requires a number of ugly hacks to deal with all the
   other fields of the structure also becoming 64 bit wide.
   Especially on big-endian architectures, we can't easily use the
   union trick from glibc.

c) Change the definition of struct rusage to be independent of
   time_t. This is the easiest change, as it does not involve new system
   call entry points, but it requires the C library to convert between
   the kernel format of the structure and the user space definition.

d) Add a new ABI variant of 'struct rusage' that corresponds to the
   current layout with 32-bit counters but 64-bit time_t. This would
   minimize the libc changes but require additional kernel code to
   handle a third binary layout on 64-bit kernels.

I'm picking approach c) for its simplicity. As pointed out by reviewers,
simply using the kernel structure in user space would not be POSIX
compliant, but I have verified that none of the usual C libraries (glibc,
musl, uclibc-ng, newlib) do that. Instead, they all provide their own
definition of 'struct rusage' to applications in sys/resource.h.

To be on the safe side, I'm only changing the definition inside of
the kernel and for user space with an updated 'time_t'. All existing
users will see the traditional layout that is compatible with what the
C libraries export. A 32-bit application that includes linux/resource.h
but uses an update C library with 64-bit time_t will now see the low-level
kernel structure that corresponds to the getrusage() system call interface
but that will be different from one defined in sys/resource.h for the
getrusage library interface.

Link: https://patchwork.kernel.org/patch/10077527/
Cc: Paul Eggert <eggert@cs.ucla.edu>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/alpha/kernel/osf_sys.c   | 15 +++++++++------
 include/uapi/linux/resource.h | 14 ++++++++++++--
 kernel/sys.c                  |  4 ++--
 3 files changed, 23 insertions(+), 10 deletions(-)

diff --git a/arch/alpha/kernel/osf_sys.c b/arch/alpha/kernel/osf_sys.c
index 89faa6f4de47..cad03ee445b3 100644
--- a/arch/alpha/kernel/osf_sys.c
+++ b/arch/alpha/kernel/osf_sys.c
@@ -1184,6 +1184,7 @@ SYSCALL_DEFINE4(osf_wait4, pid_t, pid, int __user *, ustatus, int, options,
 		struct rusage32 __user *, ur)
 {
 	unsigned int status = 0;
+	struct rusage32 r32;
 	struct rusage r;
 	long err = kernel_wait4(pid, &status, options, &r);
 	if (err <= 0)
@@ -1192,12 +1193,14 @@ SYSCALL_DEFINE4(osf_wait4, pid_t, pid, int __user *, ustatus, int, options,
 		return -EFAULT;
 	if (!ur)
 		return err;
-	if (put_tv_to_tv32(&ur->ru_utime, &r.ru_utime))
-		return -EFAULT;
-	if (put_tv_to_tv32(&ur->ru_stime, &r.ru_stime))
-		return -EFAULT;
-	if (copy_to_user(&ur->ru_maxrss, &r.ru_maxrss,
-	      sizeof(struct rusage32) - offsetof(struct rusage32, ru_maxrss)))
+	r32.ru_utime.tv_sec  = r.ru_utime.tv_sec;
+	r32.ru_utime.tv_usec = r.ru_utime.tv_usec;
+	r32.ru_stime.tv_sec  = r.ru_stime.tv_sec;
+	r32.ru_stime.tv_usec = r.ru_stime.tv_usec;
+	memcpy(&r32.ru_maxrss, &r.ru_maxrss,
+	      sizeof(struct rusage32) - offsetof(struct rusage32, ru_maxrss));
+
+	if (copy_to_user(ur, &r32, sizeof(r32)))
 		return -EFAULT;
 	return err;
 }
diff --git a/include/uapi/linux/resource.h b/include/uapi/linux/resource.h
index cc00fd079631..611d3745c70a 100644
--- a/include/uapi/linux/resource.h
+++ b/include/uapi/linux/resource.h
@@ -22,8 +22,18 @@
 #define	RUSAGE_THREAD	1		/* only the calling thread */
 
 struct	rusage {
-	struct timeval ru_utime;	/* user time used */
-	struct timeval ru_stime;	/* system time used */
+#if (__BITS_PER_LONG != 32 || !defined(__USE_TIME_BITS64)) && !defined(__KERNEL__)
+	struct timeval	ru_utime;	/* user time used */
+	struct timeval	ru_stime;	/* system time used */
+#else
+	/*
+	 * For 32-bit user space with 64-bit time_t, the binary layout
+	 * in these fields is incompatible with 'struct timeval', so the
+	 * C library has to translate this into the POSIX compatible layout.
+	 */
+	struct __kernel_old_timeval ru_utime;
+	struct __kernel_old_timeval ru_stime;
+#endif
 	__kernel_long_t	ru_maxrss;	/* maximum resident set size */
 	__kernel_long_t	ru_ixrss;	/* integral shared memory size */
 	__kernel_long_t	ru_idrss;	/* integral unshared data size */
diff --git a/kernel/sys.c b/kernel/sys.c
index ad692183dfe9..1de538f622e8 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1769,8 +1769,8 @@ void getrusage(struct task_struct *p, int who, struct rusage *r)
 	unlock_task_sighand(p, &flags);
 
 out:
-	r->ru_utime = ns_to_timeval(utime);
-	r->ru_stime = ns_to_timeval(stime);
+	r->ru_utime = ns_to_kernel_old_timeval(utime);
+	r->ru_stime = ns_to_kernel_old_timeval(stime);
 
 	if (who != RUSAGE_CHILDREN) {
 		struct mm_struct *mm = get_task_mm(p);
-- 
2.9.0
