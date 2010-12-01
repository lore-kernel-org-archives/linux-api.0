From: Alexander Shishkin <virtuoso@slind.org>
Subject: [PATCH] timerfd: add TFD_NOTIFY_CLOCK_SET to watch for clock changes
Date: Wed,  1 Dec 2010 03:39:47 +0200
Message-ID: <1291167587-16695-1-git-send-email-virtuoso@slind.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Alexander Shishkin <virtuoso@slind.org>, Thomas Gleixner <tglx@linutronix.de>, Alexander Viro <viro@zeniv.linux.org.uk>, Greg Kroah-Hartman <gregkh@suse.de>, Feng Tang <feng.tang@intel.com>, Andrew Morton <akpm@linux-foundation.org>, Michael Tokarev <mjt@tls.msk.ru>, Marcelo Tosatti <mtosatti@redhat.com>, John Stultz <johnstul@us.ibm.com>, Chris Friesen <chris.friesen@genband.com>, Kay Sievers <kay.sievers@vrfy.org>, "Kirill A. Shutemov" <kirill@shutemov.name>, Artem Bityutskiy <dedekind1@gmail.com>, Davide Libenzi <davidel@xmailserver.org>, Lennart Poettering <mzxreary@0pointer.de>, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Certain userspace applications (like "clock" desktop applets or cron or
systemd) might want to be notified when some other application changes
the system time. There are several known to me reasons for this:
 - avoiding periodic wakeups to poll time changes;
 - rearming CLOCK_REALTIME timers when said changes happen;
 - changing system timekeeping policy for system-wide time management
   programs;
 - keeping guest applications/operating systems running in emulators
   up to date.

This is another attempt to approach notifying userspace about system
clock changes. The other one is using an eventfd and a syscall [1]. In
the course of discussing the necessity of a syscall for this kind of
notifications, it was suggested that this functionality can be achieved
via timers [2] (and timerfd in particular [3], [4]). This idea got quite
some support [5], [6], [7], [8] and some vague criticism [9], so I
decided to try and go a bit further with it.

To use this notification functionality, user has to call timerfd_settime()
with TFD_NOTIFY_CLOCK_SET flag. After this CLOCK_REALTIME timers will
read as the number of times the wall clock has been set since last read
and poll every time the wall clock is set; CLOCK_MONOTONIC timers will
behave likewise, but in the event of the clock being updated upon resuming
from suspend. For both CLOCK_REALTIME and CLOCK_MONOTONIC timers with
TFD_NOTIFY_CLOCK_SET flag set, a call to timerfd_gettime() will return
current wall clock in it_value.

[1] http://marc.info/?l=linux-kernel&m=128950389423614&w=2
[2] http://marc.info/?l=linux-kernel&m=128951020831573&w=2
[3] http://marc.info/?l=linux-kernel&m=128951588006157&w=2
[4] http://marc.info/?l=linux-kernel&m=129053371132722&w=2
[5] http://marc.info/?l=linux-kernel&m=128951503205111&w=2
[6] http://marc.info/?l=linux-kernel&m=128955890118477&w=2
[7] http://marc.info/?l=linux-kernel&m=129002967031104&w=2
[8] http://marc.info/?l=linux-kernel&m=129055226425679&w=2
[9] http://marc.info/?l=linux-kernel&m=129002672227263&w=2

Signed-off-by: Alexander Shishkin <virtuoso@slind.org>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Alexander Viro <viro@zeniv.linux.org.uk>
CC: Greg Kroah-Hartman <gregkh@suse.de>
CC: Feng Tang <feng.tang@intel.com>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Michael Tokarev <mjt@tls.msk.ru>
CC: Marcelo Tosatti <mtosatti@redhat.com>
CC: John Stultz <johnstul@us.ibm.com>
CC: Chris Friesen <chris.friesen@genband.com>
CC: Kay Sievers <kay.sievers@vrfy.org>
CC: Kirill A. Shutemov <kirill@shutemov.name>
CC: Artem Bityutskiy <dedekind1@gmail.com>
CC: Davide Libenzi <davidel@xmailserver.org>
CC: Lennart Poettering <mzxreary@0pointer.de>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: linux-api@vger.kernel.org
CC: linux-fsdevel@vger.kernel.org
CC: linux-kernel@vger.kernel.org
---
 fs/timerfd.c            |   53 +++++++++++++++++++++++++++++++++++++++++++++-
 include/linux/hrtimer.h |    6 +++++
 include/linux/timerfd.h |    3 +-
 kernel/hrtimer.c        |    6 +++++
 4 files changed, 65 insertions(+), 3 deletions(-)

diff --git a/fs/timerfd.c b/fs/timerfd.c
index 8c4fc14..c3362dc 100644
--- a/fs/timerfd.c
+++ b/fs/timerfd.c
@@ -30,8 +30,13 @@ struct timerfd_ctx {
 	u64 ticks;
 	int expired;
 	int clockid;
+	struct list_head notifiers_list;
 };
 
+/* TFD_NOTIFY_CLOCK_SET timers go here */
+static DEFINE_SPINLOCK(notifiers_lock);
+static LIST_HEAD(notifiers_list);
+
 /*
  * This gets called when the timer event triggers. We set the "expired"
  * flag, but we do not re-arm the timer (in case it's necessary,
@@ -51,6 +56,23 @@ static enum hrtimer_restart timerfd_tmrproc(struct hrtimer *htmr)
 	return HRTIMER_NORESTART;
 }
 
+void timerfd_clock_was_set(clockid_t clockid)
+{
+	struct timerfd_ctx *ctx;
+	unsigned long flags;
+
+	spin_lock(&notifiers_lock);
+	list_for_each_entry(ctx, &notifiers_list, notifiers_list) {
+		spin_lock_irqsave(&ctx->wqh.lock, flags);
+		if (ctx->tmr.base->index == clockid) {
+			ctx->ticks++;
+			wake_up_locked(&ctx->wqh);
+		}
+		spin_unlock_irqrestore(&ctx->wqh.lock, flags);
+	}
+	spin_unlock(&notifiers_lock);
+}
+
 static ktime_t timerfd_get_remaining(struct timerfd_ctx *ctx)
 {
 	ktime_t remaining;
@@ -72,6 +94,12 @@ static void timerfd_setup(struct timerfd_ctx *ctx, int flags,
 	ctx->expired = 0;
 	ctx->ticks = 0;
 	ctx->tintv = timespec_to_ktime(ktmr->it_interval);
+
+	if (flags & TFD_NOTIFY_CLOCK_SET) {
+		list_add(&ctx->notifiers_list, &notifiers_list);
+		return;
+	}
+
 	hrtimer_init(&ctx->tmr, ctx->clockid, htmode);
 	hrtimer_set_expires(&ctx->tmr, texp);
 	ctx->tmr.function = timerfd_tmrproc;
@@ -83,7 +111,12 @@ static int timerfd_release(struct inode *inode, struct file *file)
 {
 	struct timerfd_ctx *ctx = file->private_data;
 
-	hrtimer_cancel(&ctx->tmr);
+	if (!list_empty(&ctx->notifiers_list)) {
+		spin_lock(&notifiers_lock);
+		list_del(&ctx->notifiers_list);
+		spin_unlock(&notifiers_lock);
+	} else
+		hrtimer_cancel(&ctx->tmr);
 	kfree(ctx);
 	return 0;
 }
@@ -113,6 +146,7 @@ static ssize_t timerfd_read(struct file *file, char __user *buf, size_t count,
 
 	if (count < sizeof(ticks))
 		return -EINVAL;
+
 	spin_lock_irq(&ctx->wqh.lock);
 	if (file->f_flags & O_NONBLOCK)
 		res = -EAGAIN;
@@ -120,7 +154,8 @@ static ssize_t timerfd_read(struct file *file, char __user *buf, size_t count,
 		res = wait_event_interruptible_locked_irq(ctx->wqh, ctx->ticks);
 	if (ctx->ticks) {
 		ticks = ctx->ticks;
-		if (ctx->expired && ctx->tintv.tv64) {
+		if (ctx->expired && ctx->tintv.tv64 &&
+		    list_empty(&ctx->notifiers_list)) {
 			/*
 			 * If tintv.tv64 != 0, this is a periodic timer that
 			 * needs to be re-armed. We avoid doing it in the timer
@@ -218,13 +253,17 @@ SYSCALL_DEFINE4(timerfd_settime, int, ufd, int, flags,
 	 * it to the new values.
 	 */
 	for (;;) {
+		spin_lock(&notifiers_lock);
 		spin_lock_irq(&ctx->wqh.lock);
 		if (hrtimer_try_to_cancel(&ctx->tmr) >= 0)
 			break;
 		spin_unlock_irq(&ctx->wqh.lock);
+		spin_unlock(&notifiers_lock);
 		cpu_relax();
 	}
 
+	INIT_LIST_HEAD(&ctx->notifiers_list);
+
 	/*
 	 * If the timer is expired and it's periodic, we need to advance it
 	 * because the caller may want to know the previous expiration time.
@@ -243,6 +282,7 @@ SYSCALL_DEFINE4(timerfd_settime, int, ufd, int, flags,
 	timerfd_setup(ctx, flags, &ktmr);
 
 	spin_unlock_irq(&ctx->wqh.lock);
+	spin_unlock(&notifiers_lock);
 	fput(file);
 	if (otmr && copy_to_user(otmr, &kotmr, sizeof(kotmr)))
 		return -EFAULT;
@@ -262,6 +302,14 @@ SYSCALL_DEFINE2(timerfd_gettime, int, ufd, struct itimerspec __user *, otmr)
 	ctx = file->private_data;
 
 	spin_lock_irq(&ctx->wqh.lock);
+	if (!list_empty(&ctx->notifiers_list)) {
+		kotmr.it_value = current_kernel_time();
+		kotmr.it_interval.tv_sec = 0;
+		kotmr.it_interval.tv_nsec = 0;
+		spin_unlock_irq(&ctx->wqh.lock);
+		goto out;
+	}
+
 	if (ctx->expired && ctx->tintv.tv64) {
 		ctx->expired = 0;
 		ctx->ticks +=
@@ -273,6 +321,7 @@ SYSCALL_DEFINE2(timerfd_gettime, int, ufd, struct itimerspec __user *, otmr)
 	spin_unlock_irq(&ctx->wqh.lock);
 	fput(file);
 
+out:
 	return copy_to_user(otmr, &kotmr, sizeof(kotmr)) ? -EFAULT: 0;
 }
 
diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
index fd0c1b8..0224f27 100644
--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -247,6 +247,12 @@ static inline ktime_t hrtimer_expires_remaining(const struct hrtimer *timer)
     return ktime_sub(timer->_expires, timer->base->get_time());
 }
 
+#ifdef CONFIG_TIMERFD
+extern void timerfd_clock_was_set(clockid_t clockid);
+#else
+static inline void timerfd_clock_was_set(clockid_t clockid) {}
+#endif
+
 #ifdef CONFIG_HIGH_RES_TIMERS
 struct clock_event_device;
 
diff --git a/include/linux/timerfd.h b/include/linux/timerfd.h
index 2d07929..c3ddad9 100644
--- a/include/linux/timerfd.h
+++ b/include/linux/timerfd.h
@@ -19,6 +19,7 @@
  * shared O_* flags.
  */
 #define TFD_TIMER_ABSTIME (1 << 0)
+#define TFD_NOTIFY_CLOCK_SET (1 << 1)
 #define TFD_CLOEXEC O_CLOEXEC
 #define TFD_NONBLOCK O_NONBLOCK
 
@@ -26,6 +27,6 @@
 /* Flags for timerfd_create.  */
 #define TFD_CREATE_FLAGS TFD_SHARED_FCNTL_FLAGS
 /* Flags for timerfd_settime.  */
-#define TFD_SETTIME_FLAGS TFD_TIMER_ABSTIME
+#define TFD_SETTIME_FLAGS (TFD_TIMER_ABSTIME | TFD_NOTIFY_CLOCK_SET)
 
 #endif /* _LINUX_TIMERFD_H */
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 72206cf..7da5fe1 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -646,6 +646,9 @@ void clock_was_set(void)
 {
 	/* Retrigger the CPU local events everywhere */
 	on_each_cpu(retrigger_next_event, NULL, 1);
+
+	/* Trigger timerfd notifiers */
+	timerfd_clock_was_set(CLOCK_REALTIME);
 }
 
 /*
@@ -658,6 +661,9 @@ void hres_timers_resume(void)
 		  KERN_INFO "hres_timers_resume() called with IRQs enabled!");
 
 	retrigger_next_event(NULL);
+
+	/* Trigger timerfd notifiers */
+	timerfd_clock_was_set(CLOCK_MONOTONIC);
 }
 
 /*
-- 
1.7.2.1.45.gb66c2
