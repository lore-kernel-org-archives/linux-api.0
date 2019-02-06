From: Dmitry Safonov <dima@arista.com>
Subject: [PATCH 07/32] timens/kernel: Take into account timens clock offsets in clock_nanosleep
Date: Wed,  6 Feb 2019 00:10:41 +0000
Message-ID: <20190206001107.16488-8-dima@arista.com>
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

Wire up clock_nanosleep() to timens offsets.

Signed-off-by: Andrei Vagin <avagin@openvz.org>
Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 kernel/time/hrtimer.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/kernel/time/hrtimer.c b/kernel/time/hrtimer.c
index f5cfa1b73d6f..47345aea406d 100644
--- a/kernel/time/hrtimer.c
+++ b/kernel/time/hrtimer.c
@@ -42,6 +42,7 @@
 #include <linux/timer.h>
 #include <linux/freezer.h>
 #include <linux/compat.h>
+#include <linux/time_namespace.h>
 
 #include <linux/uaccess.h>
 
@@ -1721,9 +1722,16 @@ long hrtimer_nanosleep(const struct timespec64 *rqtp,
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
2.20.1
