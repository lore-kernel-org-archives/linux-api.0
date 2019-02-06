From: Dmitry Safonov <dima@arista.com>
Subject: [PATCH 05/32] timerfd/timens: Take into account ns clock offsets
Date: Wed,  6 Feb 2019 00:10:39 +0000
Message-ID: <20190206001107.16488-6-dima@arista.com>
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

Make timerfd respect timens offsets.
Provide two helpers timens_clock_to_host() timens_clock_from_host() that
are useful to wire up timens to different kernel subsystems.
Following patches will use timens_clock_from_host(), added here for
completeness.

Signed-off-by: Andrei Vagin <avagin@openvz.org>
Co-developed-by: Dmitry Safonov <dima@arista.com>
Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 fs/timerfd.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/fs/timerfd.c b/fs/timerfd.c
index 803ca070d42e..c7ae1e371912 100644
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
-- 
2.20.1
