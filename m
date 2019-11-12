From: Dmitry Safonov <dima@arista.com>
Subject: [PATCHv8 08/34] alarmtimer: Provide get_timespec() callback
Date: Tue, 12 Nov 2019 01:26:57 +0000
Message-ID: <20191112012724.250792-9-dima@arista.com>
References: <20191112012724.250792-1-dima@arista.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191112012724.250792-1-dima@arista.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Dmitry Safonov <0x7f454c46@gmail.com>, Andrei Vagin <avagin@gmail.com>, Dmitry Safonov <dima@arista.com>, Adrian Reber <adrian@lisas.de>, Andrei Vagin <avagin@openvz.org>, Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Christian Brauner <christian.brauner@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, "Eric W. Biederman" <ebiederm@xmission.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jann Horn <jannh@google.com>, Jeff Dike <jdike@addtoit.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Shuah Khan <shuah@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Vincenzo Frascino <vincenzo.frascino@arm.com>, containers@lists.linux-foundation.org, criu@openvz.org, linux-api
List-Id: linux-api@vger.kernel.org

From: Andrei Vagin <avagin@gmail.com>

The upcoming support for time namespaces requires to have access to:
  - The time in a task's time namespace for sys_clock_gettime()
  - The time in the root name space for common_timer_get()

Wire up alarm bases with get_timespec().

Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrei Vagin <avagin@gmail.com>
Co-developed-by: Dmitry Safonov <dima@arista.com>
Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 kernel/time/alarmtimer.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/kernel/time/alarmtimer.c b/kernel/time/alarmtimer.c
index 22b6f9b133b2..357be1fe6e1f 100644
--- a/kernel/time/alarmtimer.c
+++ b/kernel/time/alarmtimer.c
@@ -37,12 +37,14 @@
  * @lock:		Lock for syncrhonized access to the base
  * @timerqueue:		Timerqueue head managing the list of events
  * @get_ktime:		Function to read the time correlating to the base
+ * @get_timespec:	Function to read the namespace time correlating to the base
  * @base_clockid:	clockid for the base
  */
 static struct alarm_base {
 	spinlock_t		lock;
 	struct timerqueue_head	timerqueue;
 	ktime_t			(*get_ktime)(void);
+	void			(*get_timespec)(struct timespec64 *tp);
 	clockid_t		base_clockid;
 } alarm_bases[ALARM_NUMTYPE];
 
@@ -670,7 +672,8 @@ static int alarm_clock_get_timespec(clockid_t which_clock, struct timespec64 *tp
 	if (!alarmtimer_get_rtcdev())
 		return -EINVAL;
 
-	*tp = ktime_to_timespec64(base->get_ktime());
+	base->get_timespec(tp);
+
 	return 0;
 }
 
@@ -883,8 +886,10 @@ static int __init alarmtimer_init(void)
 	/* Initialize alarm bases */
 	alarm_bases[ALARM_REALTIME].base_clockid = CLOCK_REALTIME;
 	alarm_bases[ALARM_REALTIME].get_ktime = &ktime_get_real;
+	alarm_bases[ALARM_REALTIME].get_timespec = ktime_get_real_ts64,
 	alarm_bases[ALARM_BOOTTIME].base_clockid = CLOCK_BOOTTIME;
 	alarm_bases[ALARM_BOOTTIME].get_ktime = &ktime_get_boottime;
+	alarm_bases[ALARM_BOOTTIME].get_timespec = ktime_get_boottime_ts64;
 	for (i = 0; i < ALARM_NUMTYPE; i++) {
 		timerqueue_init_head(&alarm_bases[i].timerqueue);
 		spin_lock_init(&alarm_bases[i].lock);
-- 
2.24.0
