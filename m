From: Dmitry Safonov <dima@arista.com>
Subject: [RFC 06/20] kernel: Take into account timens clock offsets in clock_nanosleep
Date: Wed, 19 Sep 2018 21:50:23 +0100
Message-ID: <20180919205037.9574-7-dima@arista.com>
References: <20180919205037.9574-1-dima@arista.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180919205037.9574-1-dima@arista.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Dmitry Safonov <0x7f454c46@gmail.com>, Andrei Vagin <avagin@gmail.com>, Dmitry Safonov <dima@arista.com>, Adrian Reber <adrian@lisas.de>, Andrei Vagin <avagin@openvz.org>, Andy Lutomirski <luto@kernel.org>, Christian Brauner <christian.brauner@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, "Eric W. Biederman" <ebiederm@xmission.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jeff Dike <jdike@addtoit.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Shuah Khan <shuah@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, containers@lists.linux-foundation.org, criu@openvz.org, linux-api@vger.kernel.org, x86@kernel.org
List-Id: linux-api@vger.kernel.org

From: Andrei Vagin <avagin@gmail.com>

Wire up clock_nanosleep to timens offsets.

Signed-off-by: Andrei Vagin <avagin@openvz.org>
Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 kernel/time/hrtimer.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/kernel/time/hrtimer.c b/kernel/time/hrtimer.c
index e1a549c9e399..4fe80c1325b2 100644
--- a/kernel/time/hrtimer.c
+++ b/kernel/time/hrtimer.c
@@ -51,6 +51,7 @@
 #include <linux/timer.h>
 #include <linux/freezer.h>
 #include <linux/compat.h>
+#include <linux/time_namespace.h>
 
 #include <linux/uaccess.h>
 
@@ -1730,9 +1731,16 @@ long hrtimer_nanosleep(const struct timespec64 *rqtp,
 {
 	struct restart_block *restart;
 	struct hrtimer_sleeper t;
+	struct timespec64 tp;
 	int ret = 0;
 	u64 slack;
 
+	if (!(mode & HRTIMER_MODE_REL)) {
+		tp = *rqtp;
+		rqtp = &tp;
+		timens_clock_to_host(clockid, &tp);
+	}
+
 	slack = current->timer_slack_ns;
 	if (dl_task(current) || rt_task(current))
 		slack = 0;
-- 
2.13.6
