From: Richard Cochran <richardcochran-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH RFC 2/8] clock device: convert clock_gettime
Date: Thu, 4 Nov 2010 20:28:32 +0100
Message-ID: <81ccd2674ebf26332898761ba6b7b54f395a15bd.1288897199.git.richard.cochran@omicron.at>
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

This patch lets the clock_gettime system call use dynamic clock devices.

Signed-off-by: Richard Cochran <richard.cochran-3mrvs1K0uXizZXS1Dc/lvw@public.gmane.org>
---
 include/linux/clockdevice.h  |    9 ++++++
 include/linux/posix-timers.h |   21 ++++++++++++++-
 include/linux/time.h         |    2 +
 kernel/posix-timers.c        |    4 +-
 kernel/time/clockdevice.c    |   58 ++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 91 insertions(+), 3 deletions(-)

diff --git a/include/linux/clockdevice.h b/include/linux/clockdevice.h
index a8f9359..ae258ac 100644
--- a/include/linux/clockdevice.h
+++ b/include/linux/clockdevice.h
@@ -94,4 +94,13 @@ void destroy_clock_device(struct clock_device *clk);
  */
 void *clock_device_private(struct file *fp);
 
+/**
+ * clockid_to_clock_device() - obtain clock device pointer from a clock id
+ * @id: user space clock id
+ *
+ * Returns a pointer to the clock device, or NULL if the id is not a
+ * dynamic clock id.
+ */
+struct clock_device *clockid_to_clock_device(clockid_t id);
+
 #endif
diff --git a/include/linux/posix-timers.h b/include/linux/posix-timers.h
index 3e23844..70f40e6 100644
--- a/include/linux/posix-timers.h
+++ b/include/linux/posix-timers.h
@@ -17,10 +17,22 @@ struct cpu_timer_list {
 	int firing;
 };
 
+/* Bit fields within a clockid:
+ *
+ * The most significant 29 bits hold either a pid or a file descriptor.
+ *
+ * Bit 2 indicates whether a cpu clock refers to a thread or a process.
+ *
+ * Bits 1 and 0 give the type: PROF=0, VIRT=1, SCHED=2, or FD=3.
+ *
+ * A clockid is invalid if bits 2, 1, and 0 all set (see also CLOCK_INVALID
+ * in include/linux/time.h)
+ */
+
 #define CPUCLOCK_PID(clock)		((pid_t) ~((clock) >> 3))
 #define CPUCLOCK_PERTHREAD(clock) \
 	(((clock) & (clockid_t) CPUCLOCK_PERTHREAD_MASK) != 0)
-#define CPUCLOCK_PID_MASK	7
+
 #define CPUCLOCK_PERTHREAD_MASK	4
 #define CPUCLOCK_WHICH(clock)	((clock) & (clockid_t) CPUCLOCK_CLOCK_MASK)
 #define CPUCLOCK_CLOCK_MASK	3
@@ -28,12 +40,17 @@ struct cpu_timer_list {
 #define CPUCLOCK_VIRT		1
 #define CPUCLOCK_SCHED		2
 #define CPUCLOCK_MAX		3
+#define CLOCKFD			CPUCLOCK_MAX
+#define CLOCKFD_MASK		(CPUCLOCK_PERTHREAD_MASK|CPUCLOCK_CLOCK_MASK)
 
 #define MAKE_PROCESS_CPUCLOCK(pid, clock) \
 	((~(clockid_t) (pid) << 3) | (clockid_t) (clock))
 #define MAKE_THREAD_CPUCLOCK(tid, clock) \
 	MAKE_PROCESS_CPUCLOCK((tid), (clock) | CPUCLOCK_PERTHREAD_MASK)
 
+#define FD_TO_CLOCKID(fd)  ((clockid_t) (fd << 3) | CLOCKFD)
+#define CLOCKID_TO_FD(clk) (((unsigned int) clk) >> 3)
+
 /* POSIX.1b interval timer structure. */
 struct k_itimer {
 	struct list_head list;		/* free/ allocate list */
@@ -119,4 +136,6 @@ long clock_nanosleep_restart(struct restart_block *restart_block);
 
 void update_rlimit_cpu(struct task_struct *task, unsigned long rlim_new);
 
+int posix_clock_gettime(const clockid_t clock, struct timespec __user *tp);
+
 #endif
diff --git a/include/linux/time.h b/include/linux/time.h
index 9f15ac7..914c48d 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -299,6 +299,8 @@ struct itimerval {
 #define CLOCKS_MASK			(CLOCK_REALTIME | CLOCK_MONOTONIC)
 #define CLOCKS_MONO			CLOCK_MONOTONIC
 
+#define CLOCK_INVALID			-1
+
 /*
  * The various flags for setting POSIX.1b interval timers:
  */
diff --git a/kernel/posix-timers.c b/kernel/posix-timers.c
index 9ca4973..4aecbfa 100644
--- a/kernel/posix-timers.c
+++ b/kernel/posix-timers.c
@@ -952,8 +952,8 @@ SYSCALL_DEFINE2(clock_settime, const clockid_t, which_clock,
 	return CLOCK_DISPATCH(which_clock, clock_set, (which_clock, &new_tp));
 }
 
-SYSCALL_DEFINE2(clock_gettime, const clockid_t, which_clock,
-		struct timespec __user *,tp)
+int posix_clock_gettime(const clockid_t which_clock,
+			struct timespec __user *tp)
 {
 	struct timespec kernel_tp;
 	int error;
diff --git a/kernel/time/clockdevice.c b/kernel/time/clockdevice.c
index 323b57b..e80117b 100644
--- a/kernel/time/clockdevice.c
+++ b/kernel/time/clockdevice.c
@@ -20,8 +20,11 @@
 #include <linux/cdev.h>
 #include <linux/clockdevice.h>
 #include <linux/device.h>
+#include <linux/file.h>
 #include <linux/mutex.h>
 #include <linux/slab.h>
+#include <linux/syscalls.h>
+#include <linux/uaccess.h>
 
 #define MAX_CLKDEV BITS_PER_LONG
 static DECLARE_BITMAP(clocks_map, MAX_CLKDEV);
@@ -153,3 +156,58 @@ void *clock_device_private(struct file *fp)
 	return clk->priv;
 }
 EXPORT_SYMBOL_GPL(clock_device_private);
+
+static inline bool clock_is_static(clockid_t id)
+{
+	if (0 == (id & ~CLOCKFD_MASK))
+		return true;
+	if (CLOCKFD == (id & CLOCKFD_MASK))
+		return false;
+	return true;
+}
+
+struct clock_device *clockid_to_clock_device(clockid_t id)
+{
+	struct clock_device *clk = NULL;
+	struct file *fp;
+
+	if (clock_is_static(id))
+		return NULL;
+
+	fp = fget(CLOCKID_TO_FD(id));
+	if (!fp)
+		return NULL;
+
+	if (fp->f_op->open == clock_device_open)
+		clk = fp->private_data;
+
+	fput(fp);
+	return clk;
+}
+
+SYSCALL_DEFINE2(clock_gettime,
+		const clockid_t, id, struct timespec __user *, user_ts)
+{
+	struct timespec ts;
+	struct clock_device *clk;
+	int err;
+
+	clk = clockid_to_clock_device(id);
+	if (!clk)
+		return posix_clock_gettime(id, user_ts);
+
+	mutex_lock(&clk->mux);
+
+	if (clk->zombie)
+		err = -ENODEV;
+	else if (!clk->ops->clock_gettime)
+		err = -EOPNOTSUPP;
+	else
+		err = clk->ops->clock_gettime(clk->priv, &ts);
+
+	if (!err && copy_to_user(user_ts, &ts, sizeof(ts)))
+		err = -EFAULT;
+
+	mutex_unlock(&clk->mux);
+	return err;
+}
-- 
1.7.0.4
