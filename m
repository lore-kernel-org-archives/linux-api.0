From: Dmitry Safonov <dima@arista.com>
Subject: [RFC 04/20] timens: Introduce CLOCK_BOOTTIME offset
Date: Wed, 19 Sep 2018 21:50:21 +0100
Message-ID: <20180919205037.9574-5-dima@arista.com>
References: <20180919205037.9574-1-dima@arista.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180919205037.9574-1-dima@arista.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Dmitry Safonov <0x7f454c46@gmail.com>, Andrei Vagin <avagin@openvz.org>, Dmitry Safonov <dima@arista.com>, Adrian Reber <adrian@lisas.de>, Andy Lutomirski <luto@kernel.org>, Christian Brauner <christian.brauner@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, "Eric W. Biederman" <ebiederm@xmission.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jeff Dike <jdike@addtoit.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Shuah Khan <shuah@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, containers@lists.linux-foundation.org, criu@openvz.org, linux-api@vger.kernel.org, x86@kernel.org
List-Id: linux-api@vger.kernel.org

From: Andrei Vagin <avagin@openvz.org>

Adds boottime virtualisation for time namespace.
Provide clock_set() API to set boottime clock inside ns.

Signed-off-by: Andrei Vagin <avagin@openvz.org>
Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 include/linux/timens_offsets.h |  1 +
 kernel/time/posix-timers.c     | 26 ++++++++++++++++++++++++++
 2 files changed, 27 insertions(+)

diff --git a/include/linux/timens_offsets.h b/include/linux/timens_offsets.h
index 248b0c0bb92a..777530c46852 100644
--- a/include/linux/timens_offsets.h
+++ b/include/linux/timens_offsets.h
@@ -4,6 +4,7 @@
 
 struct timens_offsets {
 	struct timespec64  monotonic_time_offset;
+	struct timespec64  monotonic_boottime_offset;
 };
 
 #endif
diff --git a/kernel/time/posix-timers.c b/kernel/time/posix-timers.c
index 3c1f98760dec..d38835a21c5d 100644
--- a/kernel/time/posix-timers.c
+++ b/kernel/time/posix-timers.c
@@ -276,7 +276,32 @@ static int posix_get_coarse_res(const clockid_t which_clock, struct timespec64 *
 
 static int posix_get_boottime(const clockid_t which_clock, struct timespec64 *tp)
 {
+	struct timens_offsets *ns_offsets = current->nsproxy->time_ns->offsets;
+
 	ktime_get_boottime_ts64(tp);
+
+	if (!ns_offsets)
+		return 0;
+
+	*tp = timespec64_add(*tp, ns_offsets->monotonic_boottime_offset);
+
+	return 0;
+}
+
+static int posix_set_boottime(clockid_t which_clock, const struct timespec64 *tp)
+{
+	struct timens_offsets *ns_offsets = current->nsproxy->time_ns->offsets;
+	struct timespec64 ktp;
+
+	if (!ns_capable(current->nsproxy->time_ns->user_ns, CAP_SYS_TIME))
+		return -EPERM;
+
+	ktime_get_boottime_ts64(&ktp);
+
+	if (ns_offsets)
+		ns_offsets->monotonic_boottime_offset = timespec64_sub(*tp, ktp);
+	else
+		return -EINVAL;
 	return 0;
 }
 
@@ -1362,6 +1387,7 @@ static const struct k_clock clock_tai = {
 static const struct k_clock clock_boottime = {
 	.clock_getres		= posix_get_hrtimer_res,
 	.clock_get		= posix_get_boottime,
+	.clock_set		= posix_set_boottime,
 	.nsleep			= common_nsleep,
 	.timer_create		= common_timer_create,
 	.timer_set		= common_timer_set,
-- 
2.13.6
