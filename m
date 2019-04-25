From: Dmitry Safonov <dima@arista.com>
Subject: [PATCHv3 05/27] timerfd/timens: Take into account ns clock offsets
Date: Thu, 25 Apr 2019 17:13:54 +0100
Message-ID: <20190425161416.26600-6-dima@arista.com>
References: <20190425161416.26600-1-dima@arista.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190425161416.26600-1-dima@arista.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Andrei Vagin <avagin@gmail.com>, Dmitry Safonov <dima@arista.com>, Adrian Reber <adrian@lisas.de>, Andrei Vagin <avagin@openvz.org>, Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Christian Brauner <christian.brauner@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, Dmitry Safonov <0x7f454c46@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jeff Dike <jdike@addtoit.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Shuah Khan <shuah@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Vincenzo Frascino <vincenzo.frascino@arm.com>, containers@lists.linux-foundation.org, criu@openvz.org, linux-api@vger.kernel.org, x86@kernel.org
List-Id: linux-api@vger.kernel.org

From: Andrei Vagin <avagin@gmail.com>

Make timerfd respect timens offsets.
Provide a helper timens_ktime_to_host() that is useful to wire up
timens to different kernel subsystems.

Signed-off-by: Andrei Vagin <avagin@openvz.org>
Co-developed-by: Dmitry Safonov <dima@arista.com>
Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 fs/timerfd.c                   |  8 +++++--
 include/linux/hrtimer.h        |  1 +
 include/linux/time_namespace.h | 40 ++++++++++++++++++++++++++++++++++
 kernel/time/hrtimer.c          |  3 +++
 4 files changed, 50 insertions(+), 2 deletions(-)

diff --git a/fs/timerfd.c b/fs/timerfd.c
index 6a6fc8aa1de7..a55ade09eee1 100644
--- a/fs/timerfd.c
+++ b/fs/timerfd.c
@@ -26,6 +26,7 @@
 #include <linux/syscalls.h>
 #include <linux/compat.h>
 #include <linux/rcupdate.h>
+#include <linux/time_namespace.h>
 
 struct timerfd_ctx {
 	union {
@@ -179,6 +180,8 @@ static int timerfd_setup(struct timerfd_ctx *ctx, int flags,
 	htmode = (flags & TFD_TIMER_ABSTIME) ?
 		HRTIMER_MODE_ABS: HRTIMER_MODE_REL;
 
+	htmode |= HRTIMER_MODE_NS;
+
 	texp = timespec64_to_ktime(ktmr->it_value);
 	ctx->expired = 0;
 	ctx->ticks = 0;
@@ -197,9 +200,10 @@ static int timerfd_setup(struct timerfd_ctx *ctx, int flags,
 
 	if (texp != 0) {
 		if (isalarm(ctx)) {
-			if (flags & TFD_TIMER_ABSTIME)
+			if (flags & TFD_TIMER_ABSTIME) {
+				texp = timens_ktime_to_host(clockid, texp);
 				alarm_start(&ctx->t.alarm, texp);
-			else
+			} else
 				alarm_start_relative(&ctx->t.alarm, texp);
 		} else {
 			hrtimer_start(&ctx->t.tmr, texp, htmode);
diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
index 2e8957eac4d4..4b9c89c797ee 100644
--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -38,6 +38,7 @@ enum hrtimer_mode {
 	HRTIMER_MODE_REL	= 0x01,
 	HRTIMER_MODE_PINNED	= 0x02,
 	HRTIMER_MODE_SOFT	= 0x04,
+	HRTIMER_MODE_NS		= 0x08,
 
 	HRTIMER_MODE_ABS_PINNED = HRTIMER_MODE_ABS | HRTIMER_MODE_PINNED,
 	HRTIMER_MODE_REL_PINNED = HRTIMER_MODE_REL | HRTIMER_MODE_PINNED,
diff --git a/include/linux/time_namespace.h b/include/linux/time_namespace.h
index 5f0da6858b10..988414f7f791 100644
--- a/include/linux/time_namespace.h
+++ b/include/linux/time_namespace.h
@@ -56,6 +56,41 @@ static inline void timens_add_boottime(struct timespec64 *ts)
                 *ts = timespec64_add(*ts, ns_offsets->monotonic_boottime_offset);
 }
 
+static inline ktime_t timens_ktime_to_host(clockid_t clockid, ktime_t tim)
+{
+	struct timens_offsets *ns_offsets = current->nsproxy->time_ns->offsets;
+	struct timespec64 *offset;
+	ktime_t koff;
+
+	if (!ns_offsets)
+		return tim;
+
+	switch (clockid) {
+		case CLOCK_MONOTONIC:
+		case CLOCK_MONOTONIC_RAW:
+		case CLOCK_MONOTONIC_COARSE:
+			offset = &ns_offsets->monotonic_time_offset;
+			break;
+		case CLOCK_BOOTTIME:
+		case CLOCK_BOOTTIME_ALARM:
+			offset = &ns_offsets->monotonic_boottime_offset;
+			break;
+		default:
+			return tim;
+	}
+
+	koff = timespec64_to_ktime(*offset);
+	if (tim < koff)
+		tim = 0;
+	else if (KTIME_MAX - tim < -koff)
+		tim = KTIME_MAX;
+	else
+		tim = ktime_sub(tim, koff);
+
+	return tim;
+}
+
+
 #else
 static inline struct time_namespace *get_time_ns(struct time_namespace *ns)
 {
@@ -82,6 +117,11 @@ static inline int timens_on_fork(struct nsproxy *nsproxy, struct task_struct *ts
 
 static inline void timens_add_monotonic(struct timespec64 *ts) {}
 static inline void timens_add_boottime(struct timespec64 *ts) {}
+
+static inline ktime_t timens_ktime_to_host(clockid_t clockid, ktime_t tim)
+{
+	return tim;
+}
 #endif
 
 #endif /* _LINUX_TIMENS_H */
diff --git a/kernel/time/hrtimer.c b/kernel/time/hrtimer.c
index 41dfff23c1f9..484a0efec1df 100644
--- a/kernel/time/hrtimer.c
+++ b/kernel/time/hrtimer.c
@@ -42,6 +42,7 @@
 #include <linux/timer.h>
 #include <linux/freezer.h>
 #include <linux/compat.h>
+#include <linux/time_namespace.h>
 
 #include <linux/uaccess.h>
 
@@ -1069,6 +1070,8 @@ static int __hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim,
 
 	if (mode & HRTIMER_MODE_REL)
 		tim = ktime_add_safe(tim, base->get_time());
+	else if (mode & HRTIMER_MODE_NS)
+		tim = timens_ktime_to_host(base->clockid, tim);
 
 	tim = hrtimer_update_lowres(timer, tim, mode);
 
-- 
2.21.0
