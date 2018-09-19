From: Dmitry Safonov <dima@arista.com>
Subject: [RFC 07/20] timens: Shift /proc/uptime
Date: Wed, 19 Sep 2018 21:50:24 +0100
Message-ID: <20180919205037.9574-8-dima@arista.com>
References: <20180919205037.9574-1-dima@arista.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180919205037.9574-1-dima@arista.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Dmitry Safonov <0x7f454c46@gmail.com>, Dmitry Safonov <dima@arista.com>, Adrian Reber <adrian@lisas.de>, Andrei Vagin <avagin@openvz.org>, Andy Lutomirski <luto@kernel.org>, Christian Brauner <christian.brauner@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, "Eric W. Biederman" <ebiederm@xmission.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jeff Dike <jdike@addtoit.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Shuah Khan <shuah@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, containers@lists.linux-foundation.org, criu@openvz.org, linux-api@vger.kernel.org, x86@kernel.org, Alexey Dobriyan <adobriyan@gmail.com>
List-Id: linux-api@vger.kernel.org

Respect boottime inside time namespace for /proc/uptime

Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 fs/proc/uptime.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/proc/uptime.c b/fs/proc/uptime.c
index a4c2791ab70b..4421ec058472 100644
--- a/fs/proc/uptime.c
+++ b/fs/proc/uptime.c
@@ -5,6 +5,7 @@
 #include <linux/sched.h>
 #include <linux/seq_file.h>
 #include <linux/time.h>
+#include <linux/time_namespace.h>
 #include <linux/kernel_stat.h>
 
 static int uptime_proc_show(struct seq_file *m, void *v)
@@ -20,6 +21,8 @@ static int uptime_proc_show(struct seq_file *m, void *v)
 		nsec += (__force u64) kcpustat_cpu(i).cpustat[CPUTIME_IDLE];
 
 	ktime_get_boottime_ts64(&uptime);
+	timens_clock_from_host(CLOCK_BOOTTIME, &uptime);
+
 	idle.tv_sec = div_u64_rem(nsec, NSEC_PER_SEC, &rem);
 	idle.tv_nsec = rem;
 	seq_printf(m, "%lu.%02lu %lu.%02lu\n",
-- 
2.13.6
