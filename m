From: Dmitry Safonov <dima@arista.com>
Subject: [PATCHv7 08/33] posix-timers: Use clock_get_ktime() in common_timer_get()
Date: Fri, 11 Oct 2019 02:23:16 +0100
Message-ID: <20191011012341.846266-9-dima@arista.com>
References: <20191011012341.846266-1-dima@arista.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191011012341.846266-1-dima@arista.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Dmitry Safonov <0x7f454c46@gmail.com>, Andrei Vagin <avagin@gmail.com>, Dmitry Safonov <dima@arista.com>, Adrian Reber <adrian@lisas.de>, Andrei Vagin <avagin@openvz.org>, Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Christian Brauner <christian.brauner@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, "Eric W. Biederman" <ebiederm@xmission.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jann Horn <jannh@google.com>, Jeff Dike <jdike@addtoit.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Shuah Khan <shuah@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Vincenzo Frascino <vincenzo.frascino@arm.com>, containers@lists.linux-foundation.org, criu@openvz.org, linux-api
List-Id: linux-api@vger.kernel.org

From: Andrei Vagin <avagin@gmail.com>

Now, when the clock_get_ktime() callback exists, the suboptimal
timespec64-based conversion can be removed from common_timer_get().

Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrei Vagin <avagin@gmail.com>
Co-developed-by: Dmitry Safonov <dima@arista.com>
Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 kernel/time/posix-timers.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/kernel/time/posix-timers.c b/kernel/time/posix-timers.c
index 1d7329e8425f..47a8d43fe1c6 100644
--- a/kernel/time/posix-timers.c
+++ b/kernel/time/posix-timers.c
@@ -665,7 +665,6 @@ void common_timer_get(struct k_itimer *timr, struct itimerspec64 *cur_setting)
 {
 	const struct k_clock *kc = timr->kclock;
 	ktime_t now, remaining, iv;
-	struct timespec64 ts64;
 	bool sig_none;
 
 	sig_none = timr->it_sigev_notify == SIGEV_NONE;
@@ -683,12 +682,7 @@ void common_timer_get(struct k_itimer *timr, struct itimerspec64 *cur_setting)
 			return;
 	}
 
-	/*
-	 * The timespec64 based conversion is suboptimal, but it's not
-	 * worth to implement yet another callback.
-	 */
-	kc->clock_get_timespec(timr->it_clock, &ts64);
-	now = timespec64_to_ktime(ts64);
+	now = kc->clock_get_ktime(timr->it_clock);
 
 	/*
 	 * When a requeue is pending or this is a SIGEV_NONE timer move the
-- 
2.23.0
