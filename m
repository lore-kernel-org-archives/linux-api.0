From: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Subject: [to-be-updated] timerfd-add-tfd_notify_clock_set-to-watch-for-clock-changes.patch removed from -mm tree
Date: Fri, 11 Mar 2011 16:00:35 -0800
Message-ID: <201103120000.p2C00ZCu003461__17502.9499260292$1299888095$gmane$org@imap1.linux-foundation.org>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: virtuoso-0lOfPCoBze7YtjvyW6yDsg@public.gmane.org, chris.friesen-b7o/lNNmKxtBDgjK7y7TUQ@public.gmane.org, davidel-AhlLAIvw+VEjIGhXcJzhZg@public.gmane.org, dedekind1-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, feng.tang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, gregkh-l3A5Bk7waGM@public.gmane.org, johnstul-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, kay.sievers-tD+1rO4QERM@public.gmane.org, ken@bitsko
List-Id: linux-api@vger.kernel.org


The patch titled
     timerfd: add TFD_NOTIFY_CLOCK_SET to watch for clock changes
has been removed from the -mm tree.  Its filename was
     timerfd-add-tfd_notify_clock_set-to-watch-for-clock-changes.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: timerfd: add TFD_NOTIFY_CLOCK_SET to watch for clock changes
From: Alexander Shishkin <virtuoso-0lOfPCoBze7YtjvyW6yDsg@public.gmane.org>

Certain userspace applications (like "clock" desktop applets or cron or
systemd) might want to be notified when some other application changes the
system time.  There are several known to me reasons for this:

 - avoiding periodic wakeups to poll time changes;
 - rearming CLOCK_REALTIME timers when said changes happen;
 - changing system timekeeping policy for system-wide time management
   programs;
 - keeping guest applications/operating systems running in emulators
   up to date;
 - recalculation of traffic signal cycles in Advanced Traffic Controllers
   (ATC), which is part of ATC API requirements [1] as developed by ATC
   working group of the U.S. Institute of Transportation Engineers (ITE).

This is another attempt to approach notifying userspace about system clock
changes.  The other one is using an eventfd and a syscall [1].  In the
course of discussing the necessity of a syscall for this kind of
notifications, it was suggested that this functionality can be achieved
via timers [2] (and timerfd in particular [3]).  This idea got quite some
support [4], [5], [6] and some vague criticism [7], so I decided to try
and go a bit further with it.

[1] http://www.ite.org/standards/atcapi/version2.asp
[2] http://marc.info/?l=linux-kernel&m=128950389423614&w=2
[3] http://marc.info/?l=linux-kernel&m=128951020831573&w=2
[4] http://marc.info/?l=linux-kernel&m=128951588006157&w=2
[5] http://marc.info/?l=linux-kernel&m=128951503205111&w=2
[6] http://marc.info/?l=linux-kernel&m=128955890118477&w=2
[7] http://marc.info/?l=linux-kernel&m=129002967031104&w=2
[8] http://marc.info/?l=linux-kernel&m=129002672227263&w=2

To use this notification functionality, user has to call timerfd_settime()
with TFD_NOTIFY_CLOCK_SET flag.  After this CLOCK_REALTIME timers will
read as the number of times the wall clock has been set since last read
and poll every time the wall clock is set; CLOCK_MONOTONIC timers will
behave likewise, but in the event of the clock being updated upon resuming
from suspend.  For both CLOCK_REALTIME and CLOCK_MONOTONIC timers with
TFD_NOTIFY_CLOCK_SET flag set, a call to timerfd_gettime() will return
current wall clock in it_value.

Kay said:

: We want it for systemd, to provide cron-like functionality but without
: the need to stupidly wake up every minute and check the system time
: for possible jumps.
: 
: It also sounds useful for a generic resume (after system suspend)
: notification for applications, which isn't really possible today.


Scott said:

: Cron is another obvious one (or init systems attempting to replace
: cron). Having to wakeup and check the time every minute can be
: non-conducive to power savings, it would be better if we could just
: sleep until the next alarm and be woken up if the time changes in
: between.
: 
: (That being said, we also need to poll for and/or check for timezone
: changes - but those are entirely userspace, so we can deal with that
: separately)

Signed-off-by: Alexander Shishkin <virtuoso-0lOfPCoBze7YtjvyW6yDsg@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-l3A5Bk7waGM@public.gmane.org>
Cc: Feng Tang <feng.tang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Michael Tokarev <mjt-XAri/EZa3C4vJsYlp49lxw@public.gmane.org>
Cc: Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: John Stultz <johnstul-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Cc: Chris Friesen <chris.friesen-b7o/lNNmKxtBDgjK7y7TUQ@public.gmane.org>
Cc: Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>
Cc: Kirill A. Shutemov <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
Cc: Artem Bityutskiy <dedekind1-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Davide Libenzi <davidel-AhlLAIvw+VEjIGhXcJzhZg@public.gmane.org>
Cc: Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Scott James Remnant <scott-Umf49k1wg4FWk0Htik3J/w@public.gmane.org>
Cc: Ken MacLeod <ken-VbOJbV3qneKf+c8Povm/Gg@public.gmane.org>
Cc: Shaun Reich <predator106-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Signed-off-by: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
---

 fs/timerfd.c            |   94 +++++++++++++++++++++++++++++++++-----
 include/linux/hrtimer.h |    6 ++
 include/linux/timerfd.h |    3 -
 kernel/compat.c         |    5 +-
 kernel/hrtimer.c        |    4 +
 kernel/time.c           |   11 +++-
 6 files changed, 109 insertions(+), 14 deletions(-)

diff -puN fs/timerfd.c~timerfd-add-tfd_notify_clock_set-to-watch-for-clock-changes fs/timerfd.c
--- a/fs/timerfd.c~timerfd-add-tfd_notify_clock_set-to-watch-for-clock-changes
+++ a/fs/timerfd.c
@@ -22,6 +22,7 @@
 #include <linux/anon_inodes.h>
 #include <linux/timerfd.h>
 #include <linux/syscalls.h>
+#include <linux/security.h>
 
 struct timerfd_ctx {
 	struct hrtimer tmr;
@@ -30,8 +31,13 @@ struct timerfd_ctx {
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
@@ -51,10 +57,31 @@ static enum hrtimer_restart timerfd_tmrp
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
 
+	/* for notification timers, return current time */
+	if (!list_empty(&ctx->notifiers_list))
+		return timespec_to_ktime(current_kernel_time());
+
 	remaining = hrtimer_expires_remaining(&ctx->tmr);
 	return remaining.tv64 < 0 ? ktime_set(0, 0): remaining;
 }
@@ -72,6 +99,12 @@ static void timerfd_setup(struct timerfd
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
@@ -83,7 +116,12 @@ static int timerfd_release(struct inode 
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
@@ -113,6 +151,7 @@ static ssize_t timerfd_read(struct file 
 
 	if (count < sizeof(ticks))
 		return -EINVAL;
+
 	spin_lock_irq(&ctx->wqh.lock);
 	if (file->f_flags & O_NONBLOCK)
 		res = -EAGAIN;
@@ -120,7 +159,8 @@ static ssize_t timerfd_read(struct file 
 		res = wait_event_interruptible_locked_irq(ctx->wqh, ctx->ticks);
 	if (ctx->ticks) {
 		ticks = ctx->ticks;
-		if (ctx->expired && ctx->tintv.tv64) {
+		if (ctx->expired && ctx->tintv.tv64 &&
+		    list_empty(&ctx->notifiers_list)) {
 			/*
 			 * If tintv.tv64 != 0, this is a periodic timer that
 			 * needs to be re-armed. We avoid doing it in the timer
@@ -184,6 +224,8 @@ SYSCALL_DEFINE2(timerfd_create, int, clo
 	ctx->clockid = clockid;
 	hrtimer_init(&ctx->tmr, clockid, HRTIMER_MODE_ABS);
 
+	INIT_LIST_HEAD(&ctx->notifiers_list);
+
 	ufd = anon_inode_getfd("[timerfd]", &timerfd_fops, ctx,
 			       O_RDWR | (flags & TFD_SHARED_FCNTL_FLAGS));
 	if (ufd < 0)
@@ -196,18 +238,24 @@ SYSCALL_DEFINE4(timerfd_settime, int, uf
 		const struct itimerspec __user *, utmr,
 		struct itimerspec __user *, otmr)
 {
+	int ret = 0;
 	struct file *file;
 	struct timerfd_ctx *ctx;
 	struct itimerspec ktmr, kotmr;
 
-	if (copy_from_user(&ktmr, utmr, sizeof(ktmr)))
-		return -EFAULT;
-
-	if ((flags & ~TFD_SETTIME_FLAGS) ||
-	    !timespec_valid(&ktmr.it_value) ||
-	    !timespec_valid(&ktmr.it_interval))
+	if (flags & ~TFD_SETTIME_FLAGS)
 		return -EINVAL;
 
+	/* utmr may be NULL for notification timerfd */
+	if (!(flags & TFD_NOTIFY_CLOCK_SET) || utmr) {
+		if (copy_from_user(&ktmr, utmr, sizeof(ktmr)))
+			return -EFAULT;
+
+		if (!timespec_valid(&ktmr.it_value) ||
+		    !timespec_valid(&ktmr.it_interval))
+			return -EINVAL;
+	}
+
 	file = timerfd_fget(ufd);
 	if (IS_ERR(file))
 		return PTR_ERR(file);
@@ -218,10 +266,12 @@ SYSCALL_DEFINE4(timerfd_settime, int, uf
 	 * it to the new values.
 	 */
 	for (;;) {
+		spin_lock(&notifiers_lock);
 		spin_lock_irq(&ctx->wqh.lock);
-		if (hrtimer_try_to_cancel(&ctx->tmr) >= 0)
+		if (!list_empty(&notifiers_list) || hrtimer_try_to_cancel(&ctx->tmr) >= 0)
 			break;
 		spin_unlock_irq(&ctx->wqh.lock);
+		spin_unlock(&notifiers_lock);
 		cpu_relax();
 	}
 
@@ -238,16 +288,39 @@ SYSCALL_DEFINE4(timerfd_settime, int, uf
 	kotmr.it_interval = ktime_to_timespec(ctx->tintv);
 
 	/*
+	 * for the notification timerfd, set current time to it_value
+	 * if the timer hasn't expired; otherwise someone has changed
+	 * the system time to the value that we don't know
+	 */
+	if (!list_empty(&ctx->notifiers_list) && utmr) {
+		if (ctx->ticks) {
+			ret = -EBUSY;
+			goto out;
+		}
+
+		ret = security_settime(&ktmr.it_value, NULL);
+		if (ret)
+			goto out;
+
+		spin_unlock_irq(&ctx->wqh.lock);
+		ret = do_settimeofday(&ktmr.it_value);
+		goto out1;
+	}
+
+	/*
 	 * Re-program the timer to the new value ...
 	 */
 	timerfd_setup(ctx, flags, &ktmr);
 
+out:
 	spin_unlock_irq(&ctx->wqh.lock);
+out1:
+	spin_unlock(&notifiers_lock);
 	fput(file);
 	if (otmr && copy_to_user(otmr, &kotmr, sizeof(kotmr)))
 		return -EFAULT;
 
-	return 0;
+	return ret;
 }
 
 SYSCALL_DEFINE2(timerfd_gettime, int, ufd, struct itimerspec __user *, otmr)
@@ -273,6 +346,7 @@ SYSCALL_DEFINE2(timerfd_gettime, int, uf
 	spin_unlock_irq(&ctx->wqh.lock);
 	fput(file);
 
+out:
 	return copy_to_user(otmr, &kotmr, sizeof(kotmr)) ? -EFAULT: 0;
 }
 
diff -puN include/linux/hrtimer.h~timerfd-add-tfd_notify_clock_set-to-watch-for-clock-changes include/linux/hrtimer.h
--- a/include/linux/hrtimer.h~timerfd-add-tfd_notify_clock_set-to-watch-for-clock-changes
+++ a/include/linux/hrtimer.h
@@ -248,6 +248,12 @@ static inline ktime_t hrtimer_expires_re
 	return ktime_sub(timer->node.expires, timer->base->get_time());
 }
 
+#ifdef CONFIG_TIMERFD
+extern void timerfd_clock_was_set(clockid_t clockid);
+#else
+static inline void timerfd_clock_was_set(clockid_t clockid) {}
+#endif
+
 #ifdef CONFIG_HIGH_RES_TIMERS
 struct clock_event_device;
 
diff -puN include/linux/timerfd.h~timerfd-add-tfd_notify_clock_set-to-watch-for-clock-changes include/linux/timerfd.h
--- a/include/linux/timerfd.h~timerfd-add-tfd_notify_clock_set-to-watch-for-clock-changes
+++ a/include/linux/timerfd.h
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
diff -puN kernel/compat.c~timerfd-add-tfd_notify_clock_set-to-watch-for-clock-changes kernel/compat.c
--- a/kernel/compat.c~timerfd-add-tfd_notify_clock_set-to-watch-for-clock-changes
+++ a/kernel/compat.c
@@ -995,7 +995,10 @@ asmlinkage long compat_sys_stime(compat_
 	if (err)
 		return err;
 
-	do_settimeofday(&tv);
+	err = do_settimeofday(&tv);
+	if (!err)
+		timerfd_clock_was_set(CLOCK_REALTIME);
+
 	return 0;
 }
 
diff -puN kernel/hrtimer.c~timerfd-add-tfd_notify_clock_set-to-watch-for-clock-changes kernel/hrtimer.c
--- a/kernel/hrtimer.c~timerfd-add-tfd_notify_clock_set-to-watch-for-clock-changes
+++ a/kernel/hrtimer.c
@@ -663,6 +663,7 @@ void clock_was_set(void)
 {
 	/* Retrigger the CPU local events everywhere */
 	on_each_cpu(retrigger_next_event, NULL, 1);
+
 }
 
 /*
@@ -675,6 +676,9 @@ void hres_timers_resume(void)
 		  KERN_INFO "hres_timers_resume() called with IRQs enabled!");
 
 	retrigger_next_event(NULL);
+
+	/* Trigger timerfd notifiers */
+	timerfd_clock_was_set(CLOCK_MONOTONIC);
 }
 
 /*
diff -puN kernel/time.c~timerfd-add-tfd_notify_clock_set-to-watch-for-clock-changes kernel/time.c
--- a/kernel/time.c~timerfd-add-tfd_notify_clock_set-to-watch-for-clock-changes
+++ a/kernel/time.c
@@ -92,7 +92,10 @@ SYSCALL_DEFINE1(stime, time_t __user *, 
 	if (err)
 		return err;
 
-	do_settimeofday(&tv);
+	err = do_settimeofday(&tv);
+	if (!err)
+		timerfd_clock_was_set(CLOCK_REALTIME);
+
 	return 0;
 }
 
@@ -177,7 +180,11 @@ int do_sys_settimeofday(const struct tim
 		/* SMP safe, again the code in arch/foo/time.c should
 		 * globally block out interrupts when it runs.
 		 */
-		return do_settimeofday(tv);
+		error = do_settimeofday(tv);
+		if (!error)
+			timerfd_clock_was_set(CLOCK_REALTIME);
+
+		return error;
 	}
 	return 0;
 }
_

Patches currently in -mm which might be from virtuoso-0lOfPCoBze7YtjvyW6yDsg@public.gmane.org are

linux-next.patch
scsi-fix-a-header-to-include-linux-typesh.patch
