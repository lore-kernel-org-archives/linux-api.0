From: Dmitry Safonov <dima@arista.com>
Subject: [RFC 13/20] posix-timers/timens: Take into account clock offsets
Date: Wed, 19 Sep 2018 21:50:30 +0100
Message-ID: <20180919205037.9574-14-dima@arista.com>
References: <20180919205037.9574-1-dima@arista.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180919205037.9574-1-dima@arista.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Dmitry Safonov <0x7f454c46@gmail.com>, Andrei Vagin <avagin@gmail.com>, Dmitry Safonov <dima@arista.com>, Adrian Reber <adrian@lisas.de>, Andrei Vagin <avagin@openvz.org>, Andy Lutomirski <luto@kernel.org>, Christian Brauner <christian.brauner@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, "Eric W. Biederman" <ebiederm@xmission.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jeff Dike <jdike@addtoit.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Shuah Khan <shuah@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, containers@lists.linux-foundation.org, criu@openvz.org, linux-api@vger.kernel.org, x86@kernel.org
List-Id: linux-api@vger.kernel.org

From: Andrei Vagin <avagin@gmail.com>

Provide a helper that will convert clocks to time namespace.

Signed-off-by: Andrei Vagin <avagin@openvz.org>
Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 kernel/time/posix-timers.c | 52 +++++++++++++++++++++++++++++++---------------
 kernel/time/posix-timers.h |  2 ++
 2 files changed, 37 insertions(+), 17 deletions(-)

diff --git a/kernel/time/posix-timers.c b/kernel/time/posix-timers.c
index d38835a21c5d..701cb0602b7a 100644
--- a/kernel/time/posix-timers.c
+++ b/kernel/time/posix-timers.c
@@ -206,12 +206,26 @@ static int posix_clock_realtime_adj(const clockid_t which_clock,
 	return do_adjtimex(t);
 }
 
-static void timens_adjust_monotonic(struct timespec64 *tp)
+static void common_timens_adjust(clockid_t which_clock, struct timespec64 *tp)
 {
 	struct timens_offsets *ns_offsets = current->nsproxy->time_ns->offsets;
 
-	if (ns_offsets)
+	if (!ns_offsets)
+		return;
+
+	switch (which_clock) {
+	case CLOCK_MONOTONIC:
+	case CLOCK_MONOTONIC_RAW:
+	case CLOCK_MONOTONIC_COARSE:
 		*tp = timespec64_add(*tp, ns_offsets->monotonic_time_offset);
+		break;
+	case CLOCK_BOOTTIME:
+		*tp = timespec64_add(*tp, ns_offsets->monotonic_boottime_offset);
+		break;
+	default:
+		WARN_ONCE(1, "Time Namespace offset for %d is not realized",
+				which_clock);
+	}
 }
 
 static int posix_ktime_set_ts(clockid_t which_clock,
@@ -239,7 +253,6 @@ static int posix_ktime_set_ts(clockid_t which_clock,
 static int posix_ktime_get_ts(clockid_t which_clock, struct timespec64 *tp)
 {
 	ktime_get_ts64(tp);
-	timens_adjust_monotonic(tp);
 	return 0;
 }
 
@@ -249,7 +262,6 @@ static int posix_ktime_get_ts(clockid_t which_clock, struct timespec64 *tp)
 static int posix_get_monotonic_raw(clockid_t which_clock, struct timespec64 *tp)
 {
 	ktime_get_raw_ts64(tp);
-	timens_adjust_monotonic(tp);
 	return 0;
 }
 
@@ -264,7 +276,6 @@ static int posix_get_monotonic_coarse(clockid_t which_clock,
 						struct timespec64 *tp)
 {
 	ktime_get_coarse_ts64(tp);
-	timens_adjust_monotonic(tp);
 	return 0;
 }
 
@@ -276,15 +287,7 @@ static int posix_get_coarse_res(const clockid_t which_clock, struct timespec64 *
 
 static int posix_get_boottime(const clockid_t which_clock, struct timespec64 *tp)
 {
-	struct timens_offsets *ns_offsets = current->nsproxy->time_ns->offsets;
-
 	ktime_get_boottime_ts64(tp);
-
-	if (!ns_offsets)
-		return 0;
-
-	*tp = timespec64_add(*tp, ns_offsets->monotonic_boottime_offset);
-
 	return 0;
 }
 
@@ -933,10 +936,6 @@ static int do_timer_settime(timer_t timer_id, int flags,
 	unsigned long flag;
 	int error = 0;
 
-	if (!timespec64_valid(&new_spec64->it_interval) ||
-	    !timespec64_valid(&new_spec64->it_value))
-		return -EINVAL;
-
 	if (old_spec64)
 		memset(old_spec64, 0, sizeof(*old_spec64));
 retry:
@@ -944,6 +943,15 @@ static int do_timer_settime(timer_t timer_id, int flags,
 	if (!timr)
 		return -EINVAL;
 
+	if (flags & TIMER_ABSTIME)
+		timens_clock_to_host(timr->it_clock, &new_spec64->it_value);
+
+	if (!timespec64_valid(&new_spec64->it_interval) ||
+	    !timespec64_valid(&new_spec64->it_value)) {
+		unlock_timer(timr, flag);
+		return -EINVAL;
+	}
+
 	kc = timr->kclock;
 	if (WARN_ON_ONCE(!kc || !kc->timer_set))
 		error = -EINVAL;
@@ -1121,6 +1129,9 @@ SYSCALL_DEFINE2(clock_gettime, const clockid_t, which_clock,
 
 	error = kc->clock_get(which_clock, &kernel_tp);
 
+	if (!error && kc->clock_timens_adjust)
+		kc->clock_timens_adjust(which_clock, &kernel_tp);
+
 	if (!error && put_timespec64(&kernel_tp, tp))
 		error = -EFAULT;
 
@@ -1197,6 +1208,9 @@ COMPAT_SYSCALL_DEFINE2(clock_gettime, clockid_t, which_clock,
 
 	err = kc->clock_get(which_clock, &ts);
 
+	if (!err && kc->clock_timens_adjust)
+		kc->clock_timens_adjust(which_clock, &ts);
+
 	if (!err && compat_put_timespec64(&ts, tp))
 		err = -EFAULT;
 
@@ -1340,6 +1354,7 @@ static const struct k_clock clock_monotonic = {
 	.clock_getres		= posix_get_hrtimer_res,
 	.clock_get		= posix_ktime_get_ts,
 	.clock_set		= posix_ktime_set_ts,
+	.clock_timens_adjust	= common_timens_adjust,
 	.nsleep			= common_nsleep,
 	.timer_create		= common_timer_create,
 	.timer_set		= common_timer_set,
@@ -1356,6 +1371,7 @@ static const struct k_clock clock_monotonic_raw = {
 	.clock_getres		= posix_get_hrtimer_res,
 	.clock_get		= posix_get_monotonic_raw,
 	.clock_set		= posix_ktime_set_ts,
+	.clock_timens_adjust	= common_timens_adjust,
 };
 
 static const struct k_clock clock_realtime_coarse = {
@@ -1367,6 +1383,7 @@ static const struct k_clock clock_monotonic_coarse = {
 	.clock_getres		= posix_get_coarse_res,
 	.clock_get		= posix_get_monotonic_coarse,
 	.clock_set		= posix_ktime_set_ts,
+	.clock_timens_adjust	= common_timens_adjust,
 };
 
 static const struct k_clock clock_tai = {
@@ -1388,6 +1405,7 @@ static const struct k_clock clock_boottime = {
 	.clock_getres		= posix_get_hrtimer_res,
 	.clock_get		= posix_get_boottime,
 	.clock_set		= posix_set_boottime,
+	.clock_timens_adjust	= common_timens_adjust,
 	.nsleep			= common_nsleep,
 	.timer_create		= common_timer_create,
 	.timer_set		= common_timer_set,
diff --git a/kernel/time/posix-timers.h b/kernel/time/posix-timers.h
index ddb21145211a..308774bea32a 100644
--- a/kernel/time/posix-timers.h
+++ b/kernel/time/posix-timers.h
@@ -8,6 +8,8 @@ struct k_clock {
 			     const struct timespec64 *tp);
 	int	(*clock_get)(const clockid_t which_clock,
 			     struct timespec64 *tp);
+	void	(*clock_timens_adjust)(const clockid_t which_clock,
+			     struct timespec64 *tp);
 	int	(*clock_adj)(const clockid_t which_clock, struct timex *tx);
 	int	(*timer_create)(struct k_itimer *timer);
 	int	(*nsleep)(const clockid_t which_clock, int flags,
-- 
2.13.6
