From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 1/3] y2038: introduce struct __kernel_old_timeval
Date: Mon, 27 Nov 2017 18:00:45 +0100
Message-ID: <20171127170121.634826-1-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: y2038@lists.linaro.org, libc-alpha@sourceware.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Albert ARIBAUD <albert.aribaud@3adev.fr>, Arnd Bergmann <arnd@arndb.de>, Stephen Boyd <sboyd@codeaurora.org>, Al Viro <viro@zeniv.linux.org.uk>, Deepa Dinamani <deepa.kernel@gmail.com>, Ingo Molnar <mingo@kernel.org>, Andreas Dilger <adilger@dilger.ca>
List-Id: linux-api@vger.kernel.org

Dealing with 'struct timeval' users in the y2038 series is a bit tricky:

We have two definitions of timeval that are visible to user space,
one comes from glibc (or some other C library), the other comes from
linux/time.h. The kernel copy is what we want to be used for a number of
structures defined by the kernel itself, e.g. elf_prstatus (used it core
dumps), sysinfo and rusage (used in system calls).  These generally tend
to be used for passing time intervals rather than absolute (epoch-based)
times, so they do not suffer from the y2038 overflow. Some of them
could be changed to use 64-bit timestamps by creating new system calls,
others like the core files cannot easily be changed.

An application using these interfaces likely also uses gettimeofday()
or other interfaces that use absolute times, and pass 'struct timeval'
pointers directly into kernel interfaces, so glibc must redefine their
timeval based on a 64-bit time_t when they introduce their y2038-safe
interfaces.

The only reasonable way forward I see is to remove the 'timeval'
definion from the kernel's uapi headers, and change the interfaces that
we do not want to (or cannot) duplicate for 64-bit times to use a new
__kernel_old_timeval definition instead. This type should be avoided
for all new interfaces (those can use 64-bit nanoseconds, or the 64-bit
version of timespec instead), and should be used with great care when
converting existing interfaces from timeval, to be sure they don't suffer
from the y2038 overflow, and only with consensus for the particular user
that using __kernel_old_timeval is better than moving to a 64-bit based
interface. The structure name is intentionally chosen to not conflict
with user space types, and to be ugly enough to discourage its use.

Note that ioctl based interfaces that pass a bare 'timeval' pointer
cannot change to '__kernel_old_timeval' because the user space source
code refers to 'timeval' instead, and we don't want to modify the user
space sources if possible. However, any application that relies on a
structure to contain an embedded 'timeval' (e.g. by passing a pointer
to the member into a function call that expects a timeval pointer) is
broken when that structure gets converted to __kernel_old_timeval. I
don't see any way around that, and we have to rely on the compiler to
produce a warning or compile failure that will alert users when they
recompile their sources against a new libc.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 include/linux/time32.h    |  1 +
 include/uapi/linux/time.h | 12 ++++++++++++
 kernel/time/time.c        | 12 ++++++++++++
 3 files changed, 25 insertions(+)

diff --git a/include/linux/time32.h b/include/linux/time32.h
index 100411c979be..378c75d9a83c 100644
--- a/include/linux/time32.h
+++ b/include/linux/time32.h
@@ -205,5 +205,6 @@ static inline s64 timeval_to_ns(const struct timeval *tv)
  * Returns the timeval representation of the nsec parameter.
  */
 extern struct timeval ns_to_timeval(const s64 nsec);
+extern struct __kernel_old_timeval ns_to_kernel_old_timeval(const s64 nsec);
 
 #endif
diff --git a/include/uapi/linux/time.h b/include/uapi/linux/time.h
index 0ad4510884b0..30aa734135ad 100644
--- a/include/uapi/linux/time.h
+++ b/include/uapi/linux/time.h
@@ -50,6 +50,18 @@ struct __kernel_timespec {
 #endif
 
 /*
+ * legacy timeval structure, only embedded in structures that
+ * traditionally used 'timeval' to pass time intervals (not absolute
+ * times). Do not add new users. If user space fails to compile
+ * here, this is probably because it is not y2038 safe and needs to
+ * be changed to use another interface.
+ */
+struct __kernel_old_timeval {
+	__kernel_long_t tv_sec;			/* seconds */
+	__kernel_long_t tv_usec;		/* seconds */
+};
+
+/*
  * The IDs of the various system clocks (for POSIX.1b interval timers):
  */
 #define CLOCK_REALTIME			0
diff --git a/kernel/time/time.c b/kernel/time/time.c
index 518b56b17147..92002257f083 100644
--- a/kernel/time/time.c
+++ b/kernel/time/time.c
@@ -486,6 +486,18 @@ struct timeval ns_to_timeval(const s64 nsec)
 }
 EXPORT_SYMBOL(ns_to_timeval);
 
+struct __kernel_old_timeval ns_to_kernel_old_timeval(const s64 nsec)
+{
+	struct timespec64 ts = ns_to_timespec64(nsec);
+	struct __kernel_old_timeval tv;
+
+	tv.tv_sec = ts.tv_sec;
+	tv.tv_usec = (suseconds_t) ts.tv_nsec / 1000;
+
+	return tv;
+}
+EXPORT_SYMBOL(ns_to_kernel_old_timeval);
+
 /**
  * set_normalized_timespec - set timespec sec and nsec parts and normalize
  *
-- 
2.9.0
