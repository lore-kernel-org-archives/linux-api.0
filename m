From: Richard Cochran <richardcochran@gmail.com>
Subject: [PATCH RFC 4/8] clock device: convert clock_settime
Date: Thu, 4 Nov 2010 20:29:13 +0100
Message-ID: <539a5244b2cc2319aa9054b25bb00dc4713b740d.1288897199.git.richard.cochran@omicron.at>
References: <cover.1288897198.git.richard.cochran@omicron.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <cover.1288897198.git.richard.cochran@omicron.at>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>, Arnd Bergmann <arnd@arndb.de>, Christoph Lameter <cl@linux.com>, John Stultz <johnstul@us.ibm.com>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>
List-Id: linux-api@vger.kernel.org

This patch lets the clock_settime system call use dynamic clock devices.

Signed-off-by: Richard Cochran <richard.cochran@omicron.at>
---
 include/linux/posix-timers.h |    1 +
 kernel/posix-timers.c        |    4 ++--
 kernel/time/clockdevice.c    |   26 ++++++++++++++++++++++++++
 3 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/include/linux/posix-timers.h b/include/linux/posix-timers.h
index 7d6a4f0..864ed7b 100644
--- a/include/linux/posix-timers.h
+++ b/include/linux/posix-timers.h
@@ -138,5 +138,6 @@ void update_rlimit_cpu(struct task_struct *task, unsigned long rlim_new);
 
 int posix_clock_gettime(const clockid_t clock, struct timespec __user *tp);
 int posix_clock_getres(const clockid_t clock, struct timespec __user *tp);
+int posix_clock_settime(const clockid_t clock, const struct timespec __user *t);
 
 #endif
diff --git a/kernel/posix-timers.c b/kernel/posix-timers.c
index baa6a2e..ef4e222 100644
--- a/kernel/posix-timers.c
+++ b/kernel/posix-timers.c
@@ -939,8 +939,8 @@ int do_posix_clock_nonanosleep(const clockid_t clock, int flags,
 }
 EXPORT_SYMBOL_GPL(do_posix_clock_nonanosleep);
 
-SYSCALL_DEFINE2(clock_settime, const clockid_t, which_clock,
-		const struct timespec __user *, tp)
+int posix_clock_settime(const clockid_t which_clock,
+			const struct timespec __user *tp)
 {
 	struct timespec new_tp;
 
diff --git a/kernel/time/clockdevice.c b/kernel/time/clockdevice.c
index 6629ae7..3f2870d 100644
--- a/kernel/time/clockdevice.c
+++ b/kernel/time/clockdevice.c
@@ -238,3 +238,29 @@ SYSCALL_DEFINE2(clock_getres,
 	mutex_unlock(&clk->mux);
 	return err;
 }
+
+SYSCALL_DEFINE2(clock_settime,
+		const clockid_t, id, const struct timespec __user *, user_ts)
+{
+	struct timespec ts;
+	struct clock_device *clk;
+	int err;
+
+	clk = clockid_to_clock_device(id);
+	if (!clk)
+		return posix_clock_settime(id, user_ts);
+
+	mutex_lock(&clk->mux);
+
+	if (clk->zombie)
+		err = -ENODEV;
+	else if (!clk->ops->clock_settime)
+		err = -EOPNOTSUPP;
+	else if (copy_from_user(&ts, user_ts, sizeof(ts)))
+		err = -EFAULT;
+	else
+		err = clk->ops->clock_settime(clk->priv, &ts);
+
+	mutex_unlock(&clk->mux);
+	return err;
+}
-- 
1.7.0.4
