From: Dmitry Safonov <dima@arista.com>
Subject: [RFC 15/20] timens: Optimize zero-offsets
Date: Wed, 19 Sep 2018 21:50:32 +0100
Message-ID: <20180919205037.9574-16-dima@arista.com>
References: <20180919205037.9574-1-dima@arista.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180919205037.9574-1-dima@arista.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Dmitry Safonov <0x7f454c46@gmail.com>, Dmitry Safonov <dima@arista.com>, Adrian Reber <adrian@lisas.de>, Andrei Vagin <avagin@openvz.org>, Andy Lutomirski <luto@kernel.org>, Christian Brauner <christian.brauner@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, "Eric W. Biederman" <ebiederm@xmission.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jeff Dike <jdike@addtoit.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Shuah Khan <shuah@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, containers@lists.linux-foundation.org, criu@openvz.org, linux-api@vger.kernel.org, x86@kernel.org
List-Id: linux-api@vger.kernel.org

Fall through on host or in ns without time set.
Add TIMENS_FALLBACK_SYSCALL which might be wired up if timens offsets
should be unknown for userspace (will result in fall-back to syscalls).

Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 arch/x86/entry/vdso/vclock_gettime.c | 17 +++++++++++++----
 include/linux/timens_offsets.h       | 12 ++++++++++--
 kernel/time/posix-timers.c           | 21 ++++++++++++---------
 kernel/time_namespace.c              |  2 +-
 4 files changed, 36 insertions(+), 16 deletions(-)

diff --git a/arch/x86/entry/vdso/vclock_gettime.c b/arch/x86/entry/vdso/vclock_gettime.c
index a265e2737a9a..458cb1992e2e 100644
--- a/arch/x86/entry/vdso/vclock_gettime.c
+++ b/arch/x86/entry/vdso/vclock_gettime.c
@@ -252,17 +252,25 @@ notrace void set_normalized_timespec(struct timespec *ts, time_t sec, s64 nsec)
 	ts->tv_nsec = nsec;
 }
 
-notrace static __always_inline void monotonic_to_ns(struct timespec *ts)
+notrace static __always_inline int monotonic_to_ns(struct timespec *ts)
 {
 #ifdef CONFIG_TIME_NS
 	struct timens_offsets *timens = (struct timens_offsets *) &timens_page;
 	struct timespec offset;
 
+	/* Optimization: time is the same as on host, return right away */
+	if (!(timens->flags & TIMENS_USE_OFFSETS))
+		return 0;
+
+	if (timens->flags & TIMENS_FALLBACK_SYSCALL)
+		return -1;
+
 	offset = timespec64_to_timespec(timens->monotonic_time_offset);
 
 	*ts = timespec_add(*ts, offset);
 
 #endif
+	return 0;
 }
 
 notrace static int __always_inline do_monotonic(struct timespec *ts)
@@ -283,8 +291,6 @@ notrace static int __always_inline do_monotonic(struct timespec *ts)
 	ts->tv_sec += __iter_div_u64_rem(ns, NSEC_PER_SEC, &ns);
 	ts->tv_nsec = ns;
 
-	monotonic_to_ns(ts);
-
 	return mode;
 }
 
@@ -306,7 +312,6 @@ notrace static void do_monotonic_coarse(struct timespec *ts)
 		ts->tv_sec = gtod->monotonic_time_coarse_sec;
 		ts->tv_nsec = gtod->monotonic_time_coarse_nsec;
 	} while (unlikely(gtod_read_retry(gtod, seq)));
-	monotonic_to_ns(ts);
 }
 
 notrace int __vdso_clock_gettime(clockid_t clock, struct timespec *ts)
@@ -319,12 +324,16 @@ notrace int __vdso_clock_gettime(clockid_t clock, struct timespec *ts)
 	case CLOCK_MONOTONIC:
 		if (do_monotonic(ts) == VCLOCK_NONE)
 			goto fallback;
+		if (monotonic_to_ns(ts))
+			goto fallback;
 		break;
 	case CLOCK_REALTIME_COARSE:
 		do_realtime_coarse(ts);
 		break;
 	case CLOCK_MONOTONIC_COARSE:
 		do_monotonic_coarse(ts);
+		if (monotonic_to_ns(ts))
+			goto fallback;
 		break;
 	default:
 		goto fallback;
diff --git a/include/linux/timens_offsets.h b/include/linux/timens_offsets.h
index 92a8ea5601eb..8c43e7c3e632 100644
--- a/include/linux/timens_offsets.h
+++ b/include/linux/timens_offsets.h
@@ -2,6 +2,13 @@
 #ifndef _LINUX_TIME_OFFSETS_H
 #define _LINUX_TIME_OFFSETS_H
 
+enum {
+	/* We're in namespace - add offsets from vvar */
+	TIMENS_USE_OFFSETS	= 1,
+	/* Don't expose host's offsets, fall back to syscall - slow */
+	TIMENS_FALLBACK_SYSCALL	= 2, /* TODO if anyone actually interested */
+};
+
 /*
  * Time offsets need align as they're placed on vvar page,
  * which should have tail paddings on ia32 vdso.
@@ -10,8 +17,9 @@
  * to timespec because of a padding occuring between the fields.
  */
 struct timens_offsets {
-	struct timespec64  monotonic_time_offset __aligned(8);
-	struct timespec64  monotonic_boottime_offset __aligned(8);
+	u64		  flags;
+	struct timespec64 monotonic_time_offset __aligned(8);
+	struct timespec64 monotonic_boottime_offset __aligned(8);
 };
 
 #endif
diff --git a/kernel/time/posix-timers.c b/kernel/time/posix-timers.c
index 701cb0602b7a..576dbd24c498 100644
--- a/kernel/time/posix-timers.c
+++ b/kernel/time/posix-timers.c
@@ -210,7 +210,7 @@ static void common_timens_adjust(clockid_t which_clock, struct timespec64 *tp)
 {
 	struct timens_offsets *ns_offsets = current->nsproxy->time_ns->offsets;
 
-	if (!ns_offsets)
+	if (!ns_offsets || !(ns_offsets->flags & TIMENS_USE_OFFSETS))
 		return;
 
 	switch (which_clock) {
@@ -234,15 +234,16 @@ static int posix_ktime_set_ts(clockid_t which_clock,
 	struct timens_offsets *ns_offsets = current->nsproxy->time_ns->offsets;
 	struct timespec64 ktp;
 
+	if (!ns_offsets)
+		return -EINVAL;
+
 	if (!ns_capable(current->nsproxy->time_ns->user_ns, CAP_SYS_TIME))
 		return -EPERM;
 
 	ktime_get_ts64(&ktp);
 
-	if (ns_offsets)
-		ns_offsets->monotonic_time_offset = timespec64_sub(*tp, ktp);
-	else
-		return -EINVAL;
+	ns_offsets->monotonic_time_offset = timespec64_sub(*tp, ktp);
+	ns_offsets->flags |= TIMENS_USE_OFFSETS;
 
 	return 0;
 }
@@ -296,15 +297,17 @@ static int posix_set_boottime(clockid_t which_clock, const struct timespec64 *tp
 	struct timens_offsets *ns_offsets = current->nsproxy->time_ns->offsets;
 	struct timespec64 ktp;
 
+	if (!ns_offsets)
+		return -EINVAL;
+
 	if (!ns_capable(current->nsproxy->time_ns->user_ns, CAP_SYS_TIME))
 		return -EPERM;
 
 	ktime_get_boottime_ts64(&ktp);
 
-	if (ns_offsets)
-		ns_offsets->monotonic_boottime_offset = timespec64_sub(*tp, ktp);
-	else
-		return -EINVAL;
+	ns_offsets->monotonic_boottime_offset = timespec64_sub(*tp, ktp);
+	ns_offsets->flags |= TIMENS_USE_OFFSETS;
+
 	return 0;
 }
 
diff --git a/kernel/time_namespace.c b/kernel/time_namespace.c
index f88ae0e17d92..4052bdcec110 100644
--- a/kernel/time_namespace.c
+++ b/kernel/time_namespace.c
@@ -171,7 +171,7 @@ static void clock_timens_fixup(int clockid, struct timespec64 *val, bool to_ns)
 	struct timens_offsets *ns_offsets = current->nsproxy->time_ns->offsets;
 	struct timespec64 *offsets = NULL;
 
-	if (!ns_offsets)
+	if (!ns_offsets || !(ns_offsets->flags & TIMENS_USE_OFFSETS))
 		return;
 
 	if (val->tv_sec == 0 && val->tv_nsec == 0)
-- 
2.13.6
