From: Dmitry Safonov <dima@arista.com>
Subject: [PATCH 04/32] timens: Introduce CLOCK_BOOTTIME offset
Date: Wed,  6 Feb 2019 00:10:38 +0000
Message-ID: <20190206001107.16488-5-dima@arista.com>
References: <20190206001107.16488-1-dima@arista.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190206001107.16488-1-dima@arista.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Andrei Vagin <avagin@openvz.org>, Dmitry Safonov <dima@arista.com>, Adrian Reber <adrian@lisas.de>, Andrei Vagin <avagin@gmail.com>, Andy Lutomirski <luto@kernel.org>, Andy Tucker <agtucker@google.com>, Arnd Bergmann <arnd@arndb.de>, Christian Brauner <christian.brauner@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, Dmitry Safonov <0x7f454c46@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jeff Dike <jdike@addtoit.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Shuah Khan <shuah@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, containers@lists.linux-foundation.org, criu@openvz.org, linux-api@vger.kernel.org, x86@kernel.org
List-Id: linux-api@vger.kernel.org

From: Andrei Vagin <avagin@openvz.org>

Adds boottime virtualisation for time namespace.
Introduce timespec for boottime clock into timens offsets and wire
clock_gettime() syscall.

Signed-off-by: Andrei Vagin <avagin@gmail.com>
Co-developed-by: Dmitry Safonov <dima@arista.com>
Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 include/linux/timens_offsets.h | 1 +
 kernel/time/posix-timers.c     | 1 +
 kernel/time_namespace.c        | 3 +++
 3 files changed, 5 insertions(+)

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
index b6d5145858a3..782708054df2 100644
--- a/kernel/time/posix-timers.c
+++ b/kernel/time/posix-timers.c
@@ -1314,6 +1314,7 @@ static const struct k_clock clock_tai = {
 static const struct k_clock clock_boottime = {
 	.clock_getres		= posix_get_hrtimer_res,
 	.clock_get		= posix_get_boottime,
+	.clock_timens_adjust	= true,
 	.nsleep			= common_nsleep,
 	.timer_create		= common_timer_create,
 	.timer_set		= common_timer_set,
diff --git a/kernel/time_namespace.c b/kernel/time_namespace.c
index 57694be9e9db..36b31f234472 100644
--- a/kernel/time_namespace.c
+++ b/kernel/time_namespace.c
@@ -208,6 +208,9 @@ static void clock_timens_fixup(int clockid, struct timespec64 *val, bool to_ns)
 	case CLOCK_MONOTONIC_COARSE:
 		offsets = &ns_offsets->monotonic_time_offset;
 		break;
+	case CLOCK_BOOTTIME:
+		offsets = &ns_offsets->monotonic_boottime_offset;
+		break;
 	}
 
 	if (!offsets)
-- 
2.20.1
