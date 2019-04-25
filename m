From: Dmitry Safonov <dima@arista.com>
Subject: [PATCHv3 07/27] timens/kernel: Take into account timens clock offsets in clock_nanosleep
Date: Thu, 25 Apr 2019 17:13:56 +0100
Message-ID: <20190425161416.26600-8-dima@arista.com>
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

Wire up clock_nanosleep() to timens offsets.

Signed-off-by: Andrei Vagin <avagin@openvz.org>
Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 kernel/time/alarmtimer.c   |  2 ++
 kernel/time/posix-stubs.c  |  8 ++++----
 kernel/time/posix-timers.c | 12 ++++++++++--
 3 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/kernel/time/alarmtimer.c b/kernel/time/alarmtimer.c
index 23f5c39c8d23..409d518acbb3 100644
--- a/kernel/time/alarmtimer.c
+++ b/kernel/time/alarmtimer.c
@@ -816,6 +816,8 @@ static int alarm_timer_nsleep(const clockid_t which_clock, int flags,
 		ktime_t now = alarm_bases[type].gettime();
 
 		exp = ktime_add_safe(now, exp);
+	} else {
+		exp = timens_ktime_to_host(alarm_bases[type].base_clockid, exp);
 	}
 
 	ret = alarmtimer_do_nsleep(&alarm, exp, type);
diff --git a/kernel/time/posix-stubs.c b/kernel/time/posix-stubs.c
index edaf075d1ee4..f319d51e2e01 100644
--- a/kernel/time/posix-stubs.c
+++ b/kernel/time/posix-stubs.c
@@ -147,8 +147,8 @@ SYSCALL_DEFINE4(clock_nanosleep, const clockid_t, which_clock, int, flags,
 		rmtp = NULL;
 	current->restart_block.nanosleep.type = rmtp ? TT_NATIVE : TT_NONE;
 	current->restart_block.nanosleep.rmtp = rmtp;
-	return hrtimer_nanosleep(&t, flags & TIMER_ABSTIME ?
-				 HRTIMER_MODE_ABS : HRTIMER_MODE_REL,
+	return hrtimer_nanosleep(&t, HRTIMER_MODE_NS | (flags & TIMER_ABSTIME ?
+				 HRTIMER_MODE_ABS : HRTIMER_MODE_REL),
 				 which_clock);
 }
 
@@ -233,8 +233,8 @@ SYSCALL_DEFINE4(clock_nanosleep_time32, clockid_t, which_clock, int, flags,
 		rmtp = NULL;
 	current->restart_block.nanosleep.type = rmtp ? TT_COMPAT : TT_NONE;
 	current->restart_block.nanosleep.compat_rmtp = rmtp;
-	return hrtimer_nanosleep(&t, flags & TIMER_ABSTIME ?
-				 HRTIMER_MODE_ABS : HRTIMER_MODE_REL,
+	return hrtimer_nanosleep(&t, HRTIMER_MODE_NS | (flags & TIMER_ABSTIME ?
+				 HRTIMER_MODE_ABS : HRTIMER_MODE_REL),
 				 which_clock);
 }
 #endif
diff --git a/kernel/time/posix-timers.c b/kernel/time/posix-timers.c
index 7922731f98cd..39c0330464a3 100644
--- a/kernel/time/posix-timers.c
+++ b/kernel/time/posix-timers.c
@@ -1188,6 +1188,14 @@ static int common_nsleep(const clockid_t which_clock, int flags,
 				 which_clock);
 }
 
+static int common_nsleep_timens(const clockid_t which_clock, int flags,
+			 const struct timespec64 *rqtp)
+{
+	return hrtimer_nanosleep(rqtp, HRTIMER_MODE_NS | (flags & TIMER_ABSTIME ?
+				 HRTIMER_MODE_ABS : HRTIMER_MODE_REL),
+				 which_clock);
+}
+
 SYSCALL_DEFINE4(clock_nanosleep, const clockid_t, which_clock, int, flags,
 		const struct __kernel_timespec __user *, rqtp,
 		struct __kernel_timespec __user *, rmtp)
@@ -1262,7 +1270,7 @@ static const struct k_clock clock_realtime = {
 static const struct k_clock clock_monotonic = {
 	.clock_getres		= posix_get_hrtimer_res,
 	.clock_get		= posix_ktime_get_ts,
-	.nsleep			= common_nsleep,
+	.nsleep			= common_nsleep_timens,
 	.timer_create		= common_timer_create,
 	.timer_set		= common_timer_set,
 	.timer_get		= common_timer_get,
@@ -1307,7 +1315,7 @@ static const struct k_clock clock_tai = {
 static const struct k_clock clock_boottime = {
 	.clock_getres		= posix_get_hrtimer_res,
 	.clock_get		= posix_get_boottime,
-	.nsleep			= common_nsleep,
+	.nsleep			= common_nsleep_timens,
 	.timer_create		= common_timer_create,
 	.timer_set		= common_timer_set,
 	.timer_get		= common_timer_get,
-- 
2.21.0
