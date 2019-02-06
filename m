From: Dmitry Safonov <dima@arista.com>
Subject: [PATCH 06/32] posix-timers/timens: Take into account clock offsets
Date: Wed,  6 Feb 2019 00:10:40 +0000
Message-ID: <20190206001107.16488-7-dima@arista.com>
References: <20190206001107.16488-1-dima@arista.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190206001107.16488-1-dima@arista.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Andrei Vagin <avagin@gmail.com>, Dmitry Safonov <dima@arista.com>, Adrian Reber <adrian@lisas.de>, Andrei Vagin <avagin@openvz.org>, Andy Lutomirski <luto@kernel.org>, Andy Tucker <agtucker@google.com>, Arnd Bergmann <arnd@arndb.de>, Christian Brauner <christian.brauner@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, Dmitry Safonov <0x7f454c46@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jeff Dike <jdike@addtoit.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Shuah Khan <shuah@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, containers@lists.linux-foundation.org, criu@openvz.org, linux-api@vger.kernel.org, x86@kernel.org
List-Id: linux-api@vger.kernel.org

From: Andrei Vagin <avagin@gmail.com>

Wire timer_settime() syscall into time namespace virtualization.

Signed-off-by: Andrei Vagin <avagin@openvz.org>
Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 kernel/time/posix-timers.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/kernel/time/posix-timers.c b/kernel/time/posix-timers.c
index 782708054df2..d008dfd5b081 100644
--- a/kernel/time/posix-timers.c
+++ b/kernel/time/posix-timers.c
@@ -854,10 +854,6 @@ static int do_timer_settime(timer_t timer_id, int flags,
 	unsigned long flag;
 	int error = 0;
 
-	if (!timespec64_valid(&new_spec64->it_interval) ||
-	    !timespec64_valid(&new_spec64->it_value))
-		return -EINVAL;
-
 	if (old_spec64)
 		memset(old_spec64, 0, sizeof(*old_spec64));
 retry:
@@ -865,6 +861,15 @@ static int do_timer_settime(timer_t timer_id, int flags,
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
-- 
2.20.1
