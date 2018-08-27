From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 02/14] y2038: Make do_gettimeofday() and get_seconds() inline
Date: Mon, 27 Aug 2018 21:45:19 +0200
Message-ID: <20180827194531.3796559-3-arnd@arndb.de>
References: <20180827194531.3796559-1-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180827194531.3796559-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: tglx@linutronix.de
Cc: y2038@lists.linaro.org, linux-api@vger.kernel.org, Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, deepa.kernel@gmail.com, linux-arch@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
List-Id: linux-api@vger.kernel.org

get_seconds() and do_gettimeofday() are only used by a few modules now any
more (waiting for the respective patches to get accepted), and they are
among the last holdouts of code that is not y2038 safe in the core kernel.

Move the implementation into the timekeeping32.h header to clean up
the core kernel and isolate the old interfaces further.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 include/linux/timekeeping32.h | 15 +++++++++++++--
 kernel/time/time.c            | 15 +++++++++------
 kernel/time/timekeeping.c     | 24 ------------------------
 3 files changed, 22 insertions(+), 32 deletions(-)

diff --git a/include/linux/timekeeping32.h b/include/linux/timekeeping32.h
index a4a4991160fb..a502616f7e1c 100644
--- a/include/linux/timekeeping32.h
+++ b/include/linux/timekeeping32.h
@@ -6,8 +6,19 @@
  * over time so we can remove the file here.
  */
 
-extern void do_gettimeofday(struct timeval *tv);
-unsigned long get_seconds(void);
+static inline void do_gettimeofday(struct timeval *tv)
+{
+	struct timespec64 now;
+
+	ktime_get_real_ts64(&now);
+	tv->tv_sec = now.tv_sec;
+	tv->tv_usec = now.tv_nsec/1000;
+}
+
+static inline unsigned long get_seconds(void)
+{
+	return ktime_get_real_seconds();
+}
 
 static inline void getnstimeofday(struct timespec *ts)
 {
diff --git a/kernel/time/time.c b/kernel/time/time.c
index 712543011106..de332250d6fa 100644
--- a/kernel/time/time.c
+++ b/kernel/time/time.c
@@ -144,9 +144,11 @@ SYSCALL_DEFINE2(gettimeofday, struct timeval __user *, tv,
 		struct timezone __user *, tz)
 {
 	if (likely(tv != NULL)) {
-		struct timeval ktv;
-		do_gettimeofday(&ktv);
-		if (copy_to_user(tv, &ktv, sizeof(ktv)))
+		struct timespec64 ts;
+
+		ktime_get_real_ts64(&ts);
+		if (put_user(ts.tv_sec, &tv->tv_sec) ||
+		    put_user(ts.tv_nsec / 1000, &tv->tv_usec))
 			return -EFAULT;
 	}
 	if (unlikely(tz != NULL)) {
@@ -227,10 +229,11 @@ COMPAT_SYSCALL_DEFINE2(gettimeofday, struct compat_timeval __user *, tv,
 		       struct timezone __user *, tz)
 {
 	if (tv) {
-		struct timeval ktv;
+		struct timespec64 ts;
 
-		do_gettimeofday(&ktv);
-		if (compat_put_timeval(&ktv, tv))
+		ktime_get_real_ts64(&ts);
+		if (put_user(ts.tv_sec, &tv->tv_sec) ||
+		    put_user(ts.tv_nsec / 1000, &tv->tv_usec))
 			return -EFAULT;
 	}
 	if (tz) {
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index f3b22f456fac..2d110c948805 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -1211,22 +1211,6 @@ int get_device_system_crosststamp(int (*get_time_fn)
 }
 EXPORT_SYMBOL_GPL(get_device_system_crosststamp);
 
-/**
- * do_gettimeofday - Returns the time of day in a timeval
- * @tv:		pointer to the timeval to be set
- *
- * NOTE: Users should be converted to using getnstimeofday()
- */
-void do_gettimeofday(struct timeval *tv)
-{
-	struct timespec64 now;
-
-	getnstimeofday64(&now);
-	tv->tv_sec = now.tv_sec;
-	tv->tv_usec = now.tv_nsec/1000;
-}
-EXPORT_SYMBOL(do_gettimeofday);
-
 /**
  * do_settimeofday64 - Sets the time of day.
  * @ts:     pointer to the timespec64 variable containing the new time
@@ -2174,14 +2158,6 @@ void getboottime64(struct timespec64 *ts)
 }
 EXPORT_SYMBOL_GPL(getboottime64);
 
-unsigned long get_seconds(void)
-{
-	struct timekeeper *tk = &tk_core.timekeeper;
-
-	return tk->xtime_sec;
-}
-EXPORT_SYMBOL(get_seconds);
-
 void ktime_get_coarse_real_ts64(struct timespec64 *ts)
 {
 	struct timekeeper *tk = &tk_core.timekeeper;
-- 
2.18.0
