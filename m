From: Dmitry Safonov <dima@arista.com>
Subject: [RFC 03/20] timens: Introduce CLOCK_MONOTONIC offsets
Date: Wed, 19 Sep 2018 21:50:20 +0100
Message-ID: <20180919205037.9574-4-dima@arista.com>
References: <20180919205037.9574-1-dima@arista.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180919205037.9574-1-dima@arista.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Dmitry Safonov <0x7f454c46@gmail.com>, Andrei Vagin <avagin@openvz.org>, Dmitry Safonov <dima@arista.com>, Adrian Reber <adrian@lisas.de>, Andy Lutomirski <luto@kernel.org>, Christian Brauner <christian.brauner@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, "Eric W. Biederman" <ebiederm@xmission.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jeff Dike <jdike@addtoit.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Shuah Khan <shuah@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, containers@lists.linux-foundation.org, criu@openvz.org, linux-api@vger.kernel.org, x86@kernel.org
List-Id: linux-api@vger.kernel.org

From: Andrei Vagin <avagin@openvz.org>

Adds monotonic time virtualisation for time namespace.
Provide clock_set() API to set monotonic time inside ns.

Signed-off-by: Andrei Vagin <avagin@openvz.org>
Co-developed-by: Dmitry Safonov <dima@arista.com>
Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 include/linux/timens_offsets.h |  1 +
 kernel/time/posix-timers.c     | 34 ++++++++++++++++++++++++++++++++++
 2 files changed, 35 insertions(+)

diff --git a/include/linux/timens_offsets.h b/include/linux/timens_offsets.h
index 7d7cb68ea778..248b0c0bb92a 100644
--- a/include/linux/timens_offsets.h
+++ b/include/linux/timens_offsets.h
@@ -3,6 +3,7 @@
 #define _LINUX_TIME_OFFSETS_H
 
 struct timens_offsets {
+	struct timespec64  monotonic_time_offset;
 };
 
 #endif
diff --git a/kernel/time/posix-timers.c b/kernel/time/posix-timers.c
index 4b9127e95430..3c1f98760dec 100644
--- a/kernel/time/posix-timers.c
+++ b/kernel/time/posix-timers.c
@@ -51,6 +51,7 @@
 #include <linux/hashtable.h>
 #include <linux/compat.h>
 #include <linux/nospec.h>
+#include <linux/time_namespace.h>
 
 #include "timekeeping.h"
 #include "posix-timers.h"
@@ -205,12 +206,40 @@ static int posix_clock_realtime_adj(const clockid_t which_clock,
 	return do_adjtimex(t);
 }
 
+static void timens_adjust_monotonic(struct timespec64 *tp)
+{
+	struct timens_offsets *ns_offsets = current->nsproxy->time_ns->offsets;
+
+	if (ns_offsets)
+		*tp = timespec64_add(*tp, ns_offsets->monotonic_time_offset);
+}
+
+static int posix_ktime_set_ts(clockid_t which_clock,
+				const struct timespec64 *tp)
+{
+	struct timens_offsets *ns_offsets = current->nsproxy->time_ns->offsets;
+	struct timespec64 ktp;
+
+	if (!ns_capable(current->nsproxy->time_ns->user_ns, CAP_SYS_TIME))
+		return -EPERM;
+
+	ktime_get_ts64(&ktp);
+
+	if (ns_offsets)
+		ns_offsets->monotonic_time_offset = timespec64_sub(*tp, ktp);
+	else
+		return -EINVAL;
+
+	return 0;
+}
+
 /*
  * Get monotonic time for posix timers
  */
 static int posix_ktime_get_ts(clockid_t which_clock, struct timespec64 *tp)
 {
 	ktime_get_ts64(tp);
+	timens_adjust_monotonic(tp);
 	return 0;
 }
 
@@ -220,6 +249,7 @@ static int posix_ktime_get_ts(clockid_t which_clock, struct timespec64 *tp)
 static int posix_get_monotonic_raw(clockid_t which_clock, struct timespec64 *tp)
 {
 	ktime_get_raw_ts64(tp);
+	timens_adjust_monotonic(tp);
 	return 0;
 }
 
@@ -234,6 +264,7 @@ static int posix_get_monotonic_coarse(clockid_t which_clock,
 						struct timespec64 *tp)
 {
 	ktime_get_coarse_ts64(tp);
+	timens_adjust_monotonic(tp);
 	return 0;
 }
 
@@ -1283,6 +1314,7 @@ static const struct k_clock clock_realtime = {
 static const struct k_clock clock_monotonic = {
 	.clock_getres		= posix_get_hrtimer_res,
 	.clock_get		= posix_ktime_get_ts,
+	.clock_set		= posix_ktime_set_ts,
 	.nsleep			= common_nsleep,
 	.timer_create		= common_timer_create,
 	.timer_set		= common_timer_set,
@@ -1298,6 +1330,7 @@ static const struct k_clock clock_monotonic = {
 static const struct k_clock clock_monotonic_raw = {
 	.clock_getres		= posix_get_hrtimer_res,
 	.clock_get		= posix_get_monotonic_raw,
+	.clock_set		= posix_ktime_set_ts,
 };
 
 static const struct k_clock clock_realtime_coarse = {
@@ -1308,6 +1341,7 @@ static const struct k_clock clock_realtime_coarse = {
 static const struct k_clock clock_monotonic_coarse = {
 	.clock_getres		= posix_get_coarse_res,
 	.clock_get		= posix_get_monotonic_coarse,
+	.clock_set		= posix_ktime_set_ts,
 };
 
 static const struct k_clock clock_tai = {
-- 
2.13.6
