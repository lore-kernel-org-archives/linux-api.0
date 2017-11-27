From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 3/3] y2038: rusage: use __kernel_old_timeval for process times
Date: Mon, 27 Nov 2017 18:00:47 +0100
Message-ID: <20171127170121.634826-3-arnd@arndb.de>
References: <20171127170121.634826-1-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171127170121.634826-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: y2038@lists.linaro.org, libc-alpha@sourceware.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Albert ARIBAUD <albert.aribaud@3adev.fr>, Arnd Bergmann <arnd@arndb.de>, Richard Henderson <rth@twiddle.net>, Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Matt Turner <mattst88@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>, Deepa Dinamani <deepa.kernel@gmail.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Kirill Tkhai <ktkhai@virtuozzo.com>, linux-alpha@vger.kernel.org
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
   system calls that is otherwise compatible. A possible problem here
   is that we end up with incompatible definitions of rusage between
   /usr/include/linux/resource.h and /usr/include/bits/resource.h

c) Change the definition of struct rusage to be independent of
   time_t. This is the easiest change, as it does not involve new system
   call entry points, but it has the risk of introducing compile-time
   incompatibilities with user space sources that rely on the type
   of ru_utime and ru_stime.

I'm picking approch c) for its simplicity, but I'd like to hear from
others whether they would prefer a different approach.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/alpha/kernel/osf_sys.c   | 2 +-
 include/uapi/linux/resource.h | 4 ++--
 kernel/sys.c                  | 4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/alpha/kernel/osf_sys.c b/arch/alpha/kernel/osf_sys.c
index fa1a392ca9a2..445ded2ea471 100644
--- a/arch/alpha/kernel/osf_sys.c
+++ b/arch/alpha/kernel/osf_sys.c
@@ -970,7 +970,7 @@ put_tv32(struct timeval32 __user *o, struct timespec64 *i)
 }
 
 static inline long
-put_tv_to_tv32(struct timeval32 __user *o, struct timeval *i)
+put_tv_to_tv32(struct timeval32 __user *o, struct __kernel_old_timeval *i)
 {
 	return copy_to_user(o, &(struct timeval32){
 				.tv_sec = i->tv_sec,
diff --git a/include/uapi/linux/resource.h b/include/uapi/linux/resource.h
index cc00fd079631..74ef57b38f9f 100644
--- a/include/uapi/linux/resource.h
+++ b/include/uapi/linux/resource.h
@@ -22,8 +22,8 @@
 #define	RUSAGE_THREAD	1		/* only the calling thread */
 
 struct	rusage {
-	struct timeval ru_utime;	/* user time used */
-	struct timeval ru_stime;	/* system time used */
+	struct __kernel_old_timeval ru_utime;	/* user time used */
+	struct __kernel_old_timeval ru_stime;	/* system time used */
 	__kernel_long_t	ru_maxrss;	/* maximum resident set size */
 	__kernel_long_t	ru_ixrss;	/* integral shared memory size */
 	__kernel_long_t	ru_idrss;	/* integral unshared data size */
diff --git a/kernel/sys.c b/kernel/sys.c
index 83ffd7dccf23..c459e294aa9e 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1717,8 +1717,8 @@ void getrusage(struct task_struct *p, int who, struct rusage *r)
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
