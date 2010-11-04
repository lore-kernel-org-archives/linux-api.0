From: Richard Cochran <richardcochran-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH RFC 3/8] clock device: convert clock_getres
Date: Thu, 4 Nov 2010 20:28:53 +0100
Message-ID: <b876aeff06dc000704f093cf7694c7f07ebca412.1288897199.git.richard.cochran@omicron.at>
References: <cover.1288897198.git.richard.cochran@omicron.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <cover.1288897198.git.richard.cochran-3mrvs1K0uXizZXS1Dc/lvw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, John Stultz <johnstul-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

This patch lets the clock_getres system call use dynamic clock devices.

Signed-off-by: Richard Cochran <richard.cochran-3mrvs1K0uXizZXS1Dc/lvw@public.gmane.org>
---
 include/linux/posix-timers.h |    1 +
 kernel/posix-timers.c        |    3 +--
 kernel/time/clockdevice.c    |   27 +++++++++++++++++++++++++++
 3 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/include/linux/posix-timers.h b/include/linux/posix-timers.h
index 70f40e6..7d6a4f0 100644
--- a/include/linux/posix-timers.h
+++ b/include/linux/posix-timers.h
@@ -137,5 +137,6 @@ long clock_nanosleep_restart(struct restart_block *restart_block);
 void update_rlimit_cpu(struct task_struct *task, unsigned long rlim_new);
 
 int posix_clock_gettime(const clockid_t clock, struct timespec __user *tp);
+int posix_clock_getres(const clockid_t clock, struct timespec __user *tp);
 
 #endif
diff --git a/kernel/posix-timers.c b/kernel/posix-timers.c
index 4aecbfa..baa6a2e 100644
--- a/kernel/posix-timers.c
+++ b/kernel/posix-timers.c
@@ -969,8 +969,7 @@ int posix_clock_gettime(const clockid_t which_clock,
 
 }
 
-SYSCALL_DEFINE2(clock_getres, const clockid_t, which_clock,
-		struct timespec __user *, tp)
+int posix_clock_getres(const clockid_t which_clock, struct timespec __user *tp)
 {
 	struct timespec rtn_tp;
 	int error;
diff --git a/kernel/time/clockdevice.c b/kernel/time/clockdevice.c
index e80117b..6629ae7 100644
--- a/kernel/time/clockdevice.c
+++ b/kernel/time/clockdevice.c
@@ -211,3 +211,30 @@ SYSCALL_DEFINE2(clock_gettime,
 	mutex_unlock(&clk->mux);
 	return err;
 }
+
+SYSCALL_DEFINE2(clock_getres,
+		const clockid_t, id, struct timespec __user *, user_ts)
+{
+	struct timespec ts;
+	struct clock_device *clk;
+	int err;
+
+	clk = clockid_to_clock_device(id);
+	if (!clk)
+		return posix_clock_getres(id, user_ts);
+
+	mutex_lock(&clk->mux);
+
+	if (clk->zombie)
+		err = -ENODEV;
+	else if (!clk->ops->clock_getres)
+		err = -EOPNOTSUPP;
+	else
+		err = clk->ops->clock_getres(clk->priv, &ts);
+
+	if (!err && user_ts && copy_to_user(user_ts, &ts, sizeof(ts)))
+		err = -EFAULT;
+
+	mutex_unlock(&clk->mux);
+	return err;
+}
-- 
1.7.0.4
