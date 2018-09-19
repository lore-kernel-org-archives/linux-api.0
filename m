From: Dmitry Safonov <dima@arista.com>
Subject: [RFC 05/20] timerfd/timens: Take into account ns clock offsets
Date: Wed, 19 Sep 2018 21:50:22 +0100
Message-ID: <20180919205037.9574-6-dima@arista.com>
References: <20180919205037.9574-1-dima@arista.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180919205037.9574-1-dima@arista.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Dmitry Safonov <0x7f454c46@gmail.com>, Andrei Vagin <avagin@gmail.com>, Dmitry Safonov <dima@arista.com>, Adrian Reber <adrian@lisas.de>, Andrei Vagin <avagin@openvz.org>, Andy Lutomirski <luto@kernel.org>, Christian Brauner <christian.brauner@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, "Eric W. Biederman" <ebiederm@xmission.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jeff Dike <jdike@addtoit.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Shuah Khan <shuah@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, containers@lists.linux-foundation.org, criu@openvz.org, linux-api@vger.kernel.org, x86@kernel.org
List-Id: linux-api@vger.kernel.org

From: Andrei Vagin <avagin@gmail.com>

Make timerfd respect timens offsets.
Provide two helpers timens_clock_to_host() timens_clock_from_host() that
are useful to wire up timens to different kernel subsystems.
Following patches will use timens_clock_from_host(), added here for
completeness.

Signed-off-by: Andrei Vagin <avagin@openvz.org>
Co-developed-by: Dmitry Safonov <dima@arista.com>
Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 fs/timerfd.c                   | 16 +++++++++++-----
 include/linux/time_namespace.h | 11 +++++++++++
 kernel/time_namespace.c        | 39 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 61 insertions(+), 5 deletions(-)

diff --git a/fs/timerfd.c b/fs/timerfd.c
index d69ad801eb80..001ab7a0fd8b 100644
--- a/fs/timerfd.c
+++ b/fs/timerfd.c
@@ -26,6 +26,7 @@
 #include <linux/syscalls.h>
 #include <linux/compat.h>
 #include <linux/rcupdate.h>
+#include <linux/time_namespace.h>
 
 struct timerfd_ctx {
 	union {
@@ -433,22 +434,27 @@ SYSCALL_DEFINE2(timerfd_create, int, clockid, int, flags)
 }
 
 static int do_timerfd_settime(int ufd, int flags, 
-		const struct itimerspec64 *new,
+		struct itimerspec64 *new,
 		struct itimerspec64 *old)
 {
 	struct fd f;
 	struct timerfd_ctx *ctx;
 	int ret;
 
-	if ((flags & ~TFD_SETTIME_FLAGS) ||
-		 !itimerspec64_valid(new))
-		return -EINVAL;
-
 	ret = timerfd_fget(ufd, &f);
 	if (ret)
 		return ret;
 	ctx = f.file->private_data;
 
+	if (flags & TFD_TIMER_ABSTIME)
+		timens_clock_to_host(ctx->clockid, &new->it_value);
+
+	if ((flags & ~TFD_SETTIME_FLAGS) ||
+		 !itimerspec64_valid(new)) {
+		fdput(f);
+		return -EINVAL;
+	}
+
 	if (isalarm(ctx) && !capable(CAP_WAKE_ALARM)) {
 		fdput(f);
 		return -EPERM;
diff --git a/include/linux/time_namespace.h b/include/linux/time_namespace.h
index 4960c54f1b33..910711d1c39d 100644
--- a/include/linux/time_namespace.h
+++ b/include/linux/time_namespace.h
@@ -38,6 +38,9 @@ static inline void put_time_ns(struct time_namespace *ns)
 	kref_put(&ns->kref, free_time_ns);
 }
 
+void timens_clock_to_host(int clockid, struct timespec64 *val);
+void timens_clock_from_host(int clockid, struct timespec64 *val);
+
 #else
 static inline void get_time_ns(struct time_namespace *ns)
 {
@@ -56,6 +59,14 @@ static inline struct time_namespace *copy_time_ns(unsigned long flags,
 	return old_ns;
 }
 
+static inline void timens_clock_to_host(int clockid, struct timespec64 *val)
+{
+}
+
+static inline void timens_clock_from_host(int clockid, struct timespec64 *val)
+{
+}
+
 #endif
 
 #endif /* _LINUX_TIMENS_H */
diff --git a/kernel/time_namespace.c b/kernel/time_namespace.c
index a985529754b4..f96871cb8124 100644
--- a/kernel/time_namespace.c
+++ b/kernel/time_namespace.c
@@ -154,6 +154,45 @@ static struct user_namespace *timens_owner(struct ns_common *ns)
 	return to_time_ns(ns)->user_ns;
 }
 
+static void clock_timens_fixup(int clockid, struct timespec64 *val, bool to_ns)
+{
+	struct timens_offsets *ns_offsets = current->nsproxy->time_ns->offsets;
+	struct timespec64 *offsets = NULL;
+
+	if (!ns_offsets)
+		return;
+
+	if (val->tv_sec == 0 && val->tv_nsec == 0)
+		return;
+
+	switch (clockid) {
+	case CLOCK_MONOTONIC:
+		offsets = &ns_offsets->monotonic_time_offset;
+		break;
+	case CLOCK_BOOTTIME:
+		offsets = &ns_offsets->monotonic_boottime_offset;
+		break;
+	}
+
+	if (!offsets)
+		return;
+
+	if (to_ns)
+		*val = timespec64_add(*val, *offsets);
+	else
+		*val = timespec64_sub(*val, *offsets);
+}
+
+void timens_clock_to_host(int clockid, struct timespec64 *val)
+{
+	clock_timens_fixup(clockid, val, false);
+}
+
+void timens_clock_from_host(int clockid, struct timespec64 *val)
+{
+	clock_timens_fixup(clockid, val, true);
+}
+
 const struct proc_ns_operations timens_operations = {
 	.name		= "time",
 	.type		= CLONE_NEWTIME,
-- 
2.13.6
