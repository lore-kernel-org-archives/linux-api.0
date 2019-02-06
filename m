From: Dmitry Safonov <dima@arista.com>
Subject: [PATCH 03/32] timens: Introduce CLOCK_MONOTONIC offsets
Date: Wed,  6 Feb 2019 00:10:37 +0000
Message-ID: <20190206001107.16488-4-dima@arista.com>
References: <20190206001107.16488-1-dima@arista.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190206001107.16488-1-dima@arista.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Andrei Vagin <avagin@openvz.org>, Dmitry Safonov <dima@arista.com>, Adrian Reber <adrian@lisas.de>, Andrei Vagin <avagin@gmail.com>, Andy Lutomirski <luto@kernel.org>, Andy Tucker <agtucker@google.com>, Arnd Bergmann <arnd@arndb.de>, Christian Brauner <christian.brauner@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, Dmitry Safonov <0x7f454c46@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jeff Dike <jdike@addtoit.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Shuah Khan <shuah@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, containers@lists.linux-foundation.org, criu@openvz.org, linux-api@vger.kernel.org, x86@kernel.org
List-Id: linux-api@vger.kernel.org

From: Andrei Vagin <avagin@openvz.org>

Add monotonic time virtualisation for time namespace.
Introduce timespec for monotionic clock into timens offsets and wire
clock_gettime() syscall.

Signed-off-by: Andrei Vagin <avagin@openvz.org>
Co-developed-by: Dmitry Safonov <dima@arista.com>
Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 include/linux/time_namespace.h | 11 ++++++++++
 include/linux/timens_offsets.h |  1 +
 kernel/time/posix-timers.c     | 10 +++++++++
 kernel/time/posix-timers.h     |  1 +
 kernel/time_namespace.c        | 38 ++++++++++++++++++++++++++++++++++
 5 files changed, 61 insertions(+)

diff --git a/include/linux/time_namespace.h b/include/linux/time_namespace.h
index b6985aa87479..f1807d7f524d 100644
--- a/include/linux/time_namespace.h
+++ b/include/linux/time_namespace.h
@@ -41,6 +41,9 @@ static inline void put_time_ns(struct time_namespace *ns)
 }
 
 
+extern void timens_clock_to_host(int clockid, struct timespec64 *val);
+extern void timens_clock_from_host(int clockid, struct timespec64 *val);
+
 #else
 static inline struct time_namespace *get_time_ns(struct time_namespace *ns)
 {
@@ -65,6 +68,14 @@ static inline int timens_on_fork(struct nsproxy *nsproxy, struct task_struct *ts
 	return 0;
 }
 
+static inline void timens_clock_to_host(int clockid, struct timespec64 *val)
+{
+}
+
+static inline void timens_clock_from_host(int clockid, struct timespec64 *val)
+{
+}
+
 #endif
 
 #endif /* _LINUX_TIMENS_H */
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
index 0e84bb72a3da..b6d5145858a3 100644
--- a/kernel/time/posix-timers.c
+++ b/kernel/time/posix-timers.c
@@ -30,6 +30,7 @@
 #include <linux/hashtable.h>
 #include <linux/compat.h>
 #include <linux/nospec.h>
+#include <linux/time_namespace.h>
 
 #include "timekeeping.h"
 #include "posix-timers.h"
@@ -1041,6 +1042,9 @@ SYSCALL_DEFINE2(clock_gettime, const clockid_t, which_clock,
 
 	error = kc->clock_get(which_clock, &kernel_tp);
 
+	if (!error && kc->clock_timens_adjust)
+		timens_clock_from_host(which_clock, &kernel_tp);
+
 	if (!error && put_timespec64(&kernel_tp, tp))
 		error = -EFAULT;
 
@@ -1117,6 +1121,9 @@ COMPAT_SYSCALL_DEFINE2(clock_gettime, clockid_t, which_clock,
 
 	err = kc->clock_get(which_clock, &ts);
 
+	if (!err && kc->clock_timens_adjust)
+		timens_clock_from_host(which_clock, &ts);
+
 	if (!err && put_old_timespec32(&ts, tp))
 		err = -EFAULT;
 
@@ -1259,6 +1266,7 @@ static const struct k_clock clock_realtime = {
 static const struct k_clock clock_monotonic = {
 	.clock_getres		= posix_get_hrtimer_res,
 	.clock_get		= posix_ktime_get_ts,
+	.clock_timens_adjust	= true,
 	.nsleep			= common_nsleep,
 	.timer_create		= common_timer_create,
 	.timer_set		= common_timer_set,
@@ -1274,6 +1282,7 @@ static const struct k_clock clock_monotonic = {
 static const struct k_clock clock_monotonic_raw = {
 	.clock_getres		= posix_get_hrtimer_res,
 	.clock_get		= posix_get_monotonic_raw,
+	.clock_timens_adjust	= true,
 };
 
 static const struct k_clock clock_realtime_coarse = {
@@ -1284,6 +1293,7 @@ static const struct k_clock clock_realtime_coarse = {
 static const struct k_clock clock_monotonic_coarse = {
 	.clock_getres		= posix_get_coarse_res,
 	.clock_get		= posix_get_monotonic_coarse,
+	.clock_timens_adjust	= true,
 };
 
 static const struct k_clock clock_tai = {
diff --git a/kernel/time/posix-timers.h b/kernel/time/posix-timers.h
index ddb21145211a..1cf306bde639 100644
--- a/kernel/time/posix-timers.h
+++ b/kernel/time/posix-timers.h
@@ -24,6 +24,7 @@ struct k_clock {
 	int	(*timer_try_to_cancel)(struct k_itimer *timr);
 	void	(*timer_arm)(struct k_itimer *timr, ktime_t expires,
 			     bool absolute, bool sigev_none);
+	bool	clock_timens_adjust;
 };
 
 extern const struct k_clock clock_posix_cpu;
diff --git a/kernel/time_namespace.c b/kernel/time_namespace.c
index 4828447721ec..57694be9e9db 100644
--- a/kernel/time_namespace.c
+++ b/kernel/time_namespace.c
@@ -191,6 +191,44 @@ static struct user_namespace *timens_owner(struct ns_common *ns)
 	return to_time_ns(ns)->user_ns;
 }
 
+static void clock_timens_fixup(int clockid, struct timespec64 *val, bool to_ns)
+{
+	struct timens_offsets *ns_offsets = current->nsproxy->time_ns->offsets;
+	struct timespec64 *offsets = NULL;
+
+	if (!ns_offsets)
+		return;
+
+	if (val->tv_sec == 0 && val->tv_nsec == 0)
+		return;
+
+	switch (clockid) {
+	case CLOCK_MONOTONIC:
+	case CLOCK_MONOTONIC_RAW:
+	case CLOCK_MONOTONIC_COARSE:
+		offsets = &ns_offsets->monotonic_time_offset;
+		break;
+	}
+
+	if (!offsets)
+		return;
+
+	if (to_ns)
+		*val = timespec64_add(*val, *offsets);
+	else
+		*val = timespec64_sub(*val, *offsets);
+}
+
+void timens_clock_to_host(int clockid, struct timespec64 *val)
+{
+	clock_timens_fixup(clockid, val, false);
+}
+
+void timens_clock_from_host(int clockid, struct timespec64 *val)
+{
+	clock_timens_fixup(clockid, val, true);
+}
+
 const struct proc_ns_operations timens_operations = {
 	.name		= "time",
 	.type		= CLONE_NEWTIME,
-- 
2.20.1
