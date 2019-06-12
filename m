From: Dmitry Safonov <dima@arista.com>
Subject: [PATCHv4 05/28] timens: Introduce CLOCK_BOOTTIME offset
Date: Wed, 12 Jun 2019 20:26:04 +0100
Message-ID: <20190612192628.23797-6-dima@arista.com>
References: <20190612192628.23797-1-dima@arista.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190612192628.23797-1-dima@arista.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Andrei Vagin <avagin@gmail.com>, Dmitry Safonov <dima@arista.com>, Adrian Reber <adrian@lisas.de>, Andrei Vagin <avagin@openvz.org>, Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Christian Brauner <christian.brauner@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, Dmitry Safonov <0x7f454c46@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jann Horn <jannh@google.com>, Jeff Dike <jdike@addtoit.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Shuah Khan <shuah@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Vincenzo Frascino <vincenzo.frascino@arm.com>, containers@lists.linux-foundation.org, criu@openvz.org, linux-api@vger.ke
List-Id: linux-api@vger.kernel.org

From: Andrei Vagin <avagin@gmail.com>

Adds boottime virtualisation for time namespace.
Introduce timespec for boottime clock into timens offsets and wire
clock_gettime() syscall.

Signed-off-by: Andrei Vagin <avagin@gmail.com>
Co-developed-by: Dmitry Safonov <dima@arista.com>
Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 include/linux/time_namespace.h | 9 +++++++++
 include/linux/timens_offsets.h | 1 +
 kernel/time/alarmtimer.c       | 1 +
 kernel/time/posix-stubs.c      | 1 +
 kernel/time/posix-timers.c     | 1 +
 5 files changed, 13 insertions(+)

diff --git a/include/linux/time_namespace.h b/include/linux/time_namespace.h
index 81d0c989df3c..1dda8af6b9fe 100644
--- a/include/linux/time_namespace.h
+++ b/include/linux/time_namespace.h
@@ -48,6 +48,14 @@ static inline void timens_add_monotonic(struct timespec64 *ts)
                 *ts = timespec64_add(*ts, ns_offsets->monotonic);
 }
 
+static inline void timens_add_boottime(struct timespec64 *ts)
+{
+        struct timens_offsets *ns_offsets = current->nsproxy->time_ns->offsets;
+
+        if (ns_offsets)
+                *ts = timespec64_add(*ts, ns_offsets->boottime);
+}
+
 #else
 static inline struct time_namespace *get_time_ns(struct time_namespace *ns)
 {
@@ -73,6 +81,7 @@ static inline int timens_on_fork(struct nsproxy *nsproxy, struct task_struct *ts
 }
 
 static inline void timens_add_monotonic(struct timespec64 *ts) {}
+static inline void timens_add_boottime(struct timespec64 *ts) {}
 #endif
 
 #endif /* _LINUX_TIMENS_H */
diff --git a/include/linux/timens_offsets.h b/include/linux/timens_offsets.h
index eaac2c82be5c..e93aabaa5e45 100644
--- a/include/linux/timens_offsets.h
+++ b/include/linux/timens_offsets.h
@@ -4,6 +4,7 @@
 
 struct timens_offsets {
 	struct timespec64 monotonic;
+	struct timespec64 boottime;
 };
 
 #endif
diff --git a/kernel/time/alarmtimer.c b/kernel/time/alarmtimer.c
index 68a163c8b4f2..6346e6ee0d32 100644
--- a/kernel/time/alarmtimer.c
+++ b/kernel/time/alarmtimer.c
@@ -26,6 +26,7 @@
 #include <linux/freezer.h>
 #include <linux/compat.h>
 #include <linux/module.h>
+#include <linux/time_namespace.h>
 
 #include "posix-timers.h"
 
diff --git a/kernel/time/posix-stubs.c b/kernel/time/posix-stubs.c
index 17c67e0aecd8..edaf075d1ee4 100644
--- a/kernel/time/posix-stubs.c
+++ b/kernel/time/posix-stubs.c
@@ -82,6 +82,7 @@ int do_clock_gettime(clockid_t which_clock, struct timespec64 *tp)
 		break;
 	case CLOCK_BOOTTIME:
 		ktime_get_boottime_ts64(tp);
+		timens_add_boottime(tp);
 		break;
 	default:
 		return -EINVAL;
diff --git a/kernel/time/posix-timers.c b/kernel/time/posix-timers.c
index 52098f6ad596..573942ae2629 100644
--- a/kernel/time/posix-timers.c
+++ b/kernel/time/posix-timers.c
@@ -240,6 +240,7 @@ static int posix_get_coarse_res(const clockid_t which_clock, struct timespec64 *
 int posix_get_boottime_timespec(const clockid_t which_clock, struct timespec64 *tp)
 {
 	ktime_get_boottime_ts64(tp);
+	timens_add_boottime(tp);
 	return 0;
 }
 
-- 
2.22.0
