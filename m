From: Deepa Dinamani <deepa.kernel@gmail.com>
Subject: [PATCH 1/3] time: Introduce struct __kernel_itimerspec
Date: Sat, 16 Jun 2018 22:11:42 -0700
Message-ID: <20180617051144.29756-2-deepa.kernel@gmail.com>
References: <20180617051144.29756-1-deepa.kernel@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180617051144.29756-1-deepa.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: arnd@arndb.de, tglx@linutronix.de, linux-kernel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, y2038@lists.linaro.org
List-Id: linux-api@vger.kernel.org

struct itimerspec is not y2038-safe.
Introduce a new struct __kernel_itimerspec based on the
kernel internal y2038-safe struct itimerspec64.

The definition of struct __kernel_itimerspec includes two
struct __kernel_timespec.
And, since struct __kernel_timespec has the same representation in native
and compat modes, so does struct __kernel_itimerspec. This helps have a
common entry point for syscalls using struct __kernel_itimerspec.

New y2038-safe syscalls will use this new type. Since most of the new
syscalls are just an update to the native syscalls with the type update,
place the new definition under CONFIG_64BIT_TIME. This helps
architectures that do not support the above config to keep using the
old definition of struct itimerspec.
Also change the get/put_itimerspec64 to use struct__kernel_itimerspec.
This will help 32 bit architectures to use the new syscalls when
architectures select CONFIG_64BIT_TIME.

Signed-off-by: Deepa Dinamani <deepa.kernel@gmail.com>
---
 include/linux/time.h      | 4 ++--
 include/linux/time64.h    | 1 +
 include/uapi/linux/time.h | 7 +++++++
 kernel/time/time.c        | 4 ++--
 4 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/include/linux/time.h b/include/linux/time.h
index aed74463592d..27d83fd2ae61 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -14,9 +14,9 @@ int get_timespec64(struct timespec64 *ts,
 int put_timespec64(const struct timespec64 *ts,
 		struct __kernel_timespec __user *uts);
 int get_itimerspec64(struct itimerspec64 *it,
-			const struct itimerspec __user *uit);
+			const struct __kernel_itimerspec __user *uit);
 int put_itimerspec64(const struct itimerspec64 *it,
-			struct itimerspec __user *uit);
+			struct __kernel_itimerspec __user *uit);
 
 extern time64_t mktime64(const unsigned int year, const unsigned int mon,
 			const unsigned int day, const unsigned int hour,
diff --git a/include/linux/time64.h b/include/linux/time64.h
index 0a7b2f79cec7..05634afba0db 100644
--- a/include/linux/time64.h
+++ b/include/linux/time64.h
@@ -12,6 +12,7 @@ typedef __u64 timeu64_t;
  */
 #ifndef CONFIG_64BIT_TIME
 #define __kernel_timespec timespec
+#define __kernel_itimerspec itimerspec
 #endif
 
 #include <uapi/linux/time.h>
diff --git a/include/uapi/linux/time.h b/include/uapi/linux/time.h
index fcf936656493..6b56a2208be7 100644
--- a/include/uapi/linux/time.h
+++ b/include/uapi/linux/time.h
@@ -49,6 +49,13 @@ struct __kernel_timespec {
 };
 #endif
 
+#ifndef __kernel_itimerspec
+struct __kernel_itimerspec {
+	struct __kernel_timespec it_interval;    /* timer period */
+	struct __kernel_timespec it_value;       /* timer expiration */
+};
+#endif
+
 /*
  * legacy timeval structure, only embedded in structures that
  * traditionally used 'timeval' to pass time intervals (not absolute
diff --git a/kernel/time/time.c b/kernel/time/time.c
index 6fa99213fc72..4e65916e3d13 100644
--- a/kernel/time/time.c
+++ b/kernel/time/time.c
@@ -929,7 +929,7 @@ int compat_put_timespec64(const struct timespec64 *ts, void __user *uts)
 EXPORT_SYMBOL_GPL(compat_put_timespec64);
 
 int get_itimerspec64(struct itimerspec64 *it,
-			const struct itimerspec __user *uit)
+			const struct __kernel_itimerspec __user *uit)
 {
 	int ret;
 
@@ -944,7 +944,7 @@ int get_itimerspec64(struct itimerspec64 *it,
 EXPORT_SYMBOL_GPL(get_itimerspec64);
 
 int put_itimerspec64(const struct itimerspec64 *it,
-			struct itimerspec __user *uit)
+			struct __kernel_itimerspec __user *uit)
 {
 	int ret;
 
-- 
2.17.1
