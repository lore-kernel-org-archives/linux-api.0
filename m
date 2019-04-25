From: Dmitry Safonov <dima@arista.com>
Subject: [PATCHv3 06/27] posix-timers/timens: Take into account clock offsets
Date: Thu, 25 Apr 2019 17:13:55 +0100
Message-ID: <20190425161416.26600-7-dima@arista.com>
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

Wire timer_settime() syscall into time namespace virtualization.

Signed-off-by: Andrei Vagin <avagin@openvz.org>
Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 kernel/time/alarmtimer.c   | 3 +++
 kernel/time/posix-timers.c | 2 ++
 2 files changed, 5 insertions(+)

diff --git a/kernel/time/alarmtimer.c b/kernel/time/alarmtimer.c
index 31f99361342e..23f5c39c8d23 100644
--- a/kernel/time/alarmtimer.c
+++ b/kernel/time/alarmtimer.c
@@ -26,6 +26,7 @@
 #include <linux/freezer.h>
 #include <linux/compat.h>
 #include <linux/module.h>
+#include <linux/time_namespace.h>
 
 #include "posix-timers.h"
 
@@ -621,6 +622,8 @@ static void alarm_timer_arm(struct k_itimer *timr, ktime_t expires,
 
 	if (!absolute)
 		expires = ktime_add_safe(expires, base->gettime());
+	else
+		expires = timens_ktime_to_host(base->base_clockid, expires);
 	if (sigev_none)
 		alarm->node.expires = expires;
 	else
diff --git a/kernel/time/posix-timers.c b/kernel/time/posix-timers.c
index a723e63d55fd..7922731f98cd 100644
--- a/kernel/time/posix-timers.c
+++ b/kernel/time/posix-timers.c
@@ -803,6 +803,8 @@ static void common_hrtimer_arm(struct k_itimer *timr, ktime_t expires,
 
 	if (!absolute)
 		expires = ktime_add_safe(expires, timer->base->get_time());
+	else
+		expires = timens_ktime_to_host(timer->base->clockid, expires);
 	hrtimer_set_expires(timer, expires);
 
 	if (!sigev_none)
-- 
2.21.0
