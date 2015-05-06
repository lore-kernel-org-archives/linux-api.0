From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 12/19] y2038: add compat_{get,put}_timespec64
Date: Wed,  6 May 2015 18:30:19 +0200
Message-ID: <1430929826-318934-13-git-send-email-arnd@arndb.de>
References: <1430929826-318934-1-git-send-email-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1430929826-318934-1-git-send-email-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: y2038@lists.linaro.org
Cc: baolin.wang@linaro.org, tglx@linutronix.de, albert.aribaud@3adev.fr, john.stultz@linaro.org, bamvor.zhangjian@linaro.org, ruchandani.tina@gmail.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, libc-alpha@sourceware.org, Arnd Bergmann <arnd@arndb.de>
List-Id: linux-api@vger.kernel.org

These are new helper functions that convert between a user compat_timespec
and a kernel timespec64 structure.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 include/linux/compat_time.h |  2 ++
 kernel/compat.c             | 32 ++++++++++++++++++++++++++++++++
 2 files changed, 34 insertions(+)

diff --git a/include/linux/compat_time.h b/include/linux/compat_time.h
index e3b43bd79801..d91d0d9c753b 100644
--- a/include/linux/compat_time.h
+++ b/include/linux/compat_time.h
@@ -112,6 +112,8 @@ extern int compat_get_timespec(struct timespec *, const void __user *);
 extern int compat_put_timespec(const struct timespec *, void __user *);
 extern int compat_get_timeval(struct timeval *, const void __user *);
 extern int compat_put_timeval(const struct timeval *, void __user *);
+extern int compat_get_timespec64(struct timespec64 *ts, const void __user *uts);
+extern int compat_put_timespec64(const struct timespec64 *ts, void __user *uts);
 
 /*
  * This function convert a timespec if necessary and returns a *user
diff --git a/kernel/compat.c b/kernel/compat.c
index e56ee6a23c0f..d8d0a4711cc7 100644
--- a/kernel/compat.c
+++ b/kernel/compat.c
@@ -157,6 +157,20 @@ static int __compat_put_timespec(const struct timespec *ts, struct compat_timesp
 			__put_user(ts->tv_nsec, &cts->tv_nsec)) ? -EFAULT : 0;
 }
 
+static int __compat_get_timespec64(struct timespec64 *ts, const struct compat_timespec __user *cts)
+{
+	return (!access_ok(VERIFY_READ, cts, sizeof(*cts)) ||
+			__get_user(ts->tv_sec, &cts->tv_sec) ||
+			__get_user(ts->tv_nsec, &cts->tv_nsec)) ? -EFAULT : 0;
+}
+
+static int __compat_put_timespec64(const struct timespec64 *ts, struct compat_timespec __user *cts)
+{
+	return (!access_ok(VERIFY_WRITE, cts, sizeof(*cts)) ||
+			__put_user(ts->tv_sec, &cts->tv_sec) ||
+			__put_user(ts->tv_nsec, &cts->tv_nsec)) ? -EFAULT : 0;
+}
+
 int compat_get_timeval(struct timeval *tv, const void __user *utv)
 {
 	if (COMPAT_USE_64BIT_TIME)
@@ -193,6 +207,24 @@ int compat_put_timespec(const struct timespec *ts, void __user *uts)
 }
 EXPORT_SYMBOL_GPL(compat_put_timespec);
 
+int compat_get_timespec64(struct timespec64 *ts, const void __user *uts)
+{
+	if (COMPAT_USE_64BIT_TIME)
+		return copy_from_user(ts, uts, sizeof(*ts)) ? -EFAULT : 0;
+	else
+		return __compat_get_timespec64(ts, uts);
+}
+EXPORT_SYMBOL_GPL(compat_get_timespec64);
+
+int compat_put_timespec64(const struct timespec64 *ts, void __user *uts)
+{
+	if (COMPAT_USE_64BIT_TIME)
+		return copy_to_user(uts, ts, sizeof(*ts)) ? -EFAULT : 0;
+	else
+		return __compat_put_timespec64(ts, uts);
+}
+EXPORT_SYMBOL_GPL(compat_put_timespec64);
+
 #ifdef CONFIG_COMPAT
 int compat_convert_timespec(struct timespec __user **kts,
 			    const void __user *cts)
-- 
2.1.0.rc2
