From: Cyrill Gorcunov <gorcunov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [patch 3/4] timerfd: Implement timerfd_ioctl method to restore
 timerfd_ctx::ticks
Date: Wed, 2 Jul 2014 23:36:59 +0400
Message-ID: <20140702193659.GI12440@moon>
References: <20140623185431.396309193@openvz.org>
 <53B4382F.9030908@codeaurora.org>
 <20140702170416.GG12440@moon>
 <4188254.Av1Z2pQssC@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4188254.Av1Z2pQssC@wuerfel>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Cc: Christopher Covington <cov-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Linux ARM kernel mailing list <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Updated variant, thanks a lot for feedback!

---
From: Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Subject: timerfd: Implement timerfd_ioctl method to restore timerfd_ctx::ticks, v3

The read() of timerfd files allows to fetch the number of timer ticks
while there is no way to set it back from userspace.

To restore the timer's state as it was at checkpoint moment we need
a path to bring @ticks back. Initially I thought about writing ticks
back via write() interface but it seems such API is somehow obscure.

Instead implement timerfd_ioctl() method with TFD_IOC_SET_TICKS
command which allows to adjust @ticks into non-zero value waking
up the waiters.

I wrapped code with CONFIG_CHECKPOINT_RESTORE which can be
dropped off if there users except c/r camp appear.

v2 (by akpm@):
 - Use define timerfd_ioctl NULL for non c/r config

v3:
 - Use copy_from_user for @ticks fetching since
   not all arch support get_user for 8 byte argument

CC: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
CC: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
CC: Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
CC: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
CC: Christopher Covington <cov-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
CC: Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
CC: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Signed-off-by: Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
---
 fs/timerfd.c            |   37 +++++++++++++++++++++++++++++++++++++
 include/linux/timerfd.h |    5 +++++
 2 files changed, 42 insertions(+)

Index: linux-2.6.git/fs/timerfd.c
===================================================================
--- linux-2.6.git.orig/fs/timerfd.c
+++ linux-2.6.git/fs/timerfd.c
@@ -315,12 +315,49 @@ static int timerfd_show(struct seq_file
 #define timerfd_show NULL
 #endif
 
+#ifdef CONFIG_CHECKPOINT_RESTORE
+static long timerfd_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	struct timerfd_ctx *ctx = file->private_data;
+	int ret = 0;
+
+	switch (cmd) {
+	case TFD_IOC_SET_TICKS: {
+		u64 ticks;
+
+		if (copy_from_user(&ticks, (u64 __user *)arg, sizeof(ticks)))
+			return -EFAULT;
+		if (!ticks)
+			return -EINVAL;
+
+		spin_lock_irq(&ctx->wqh.lock);
+		if (!timerfd_canceled(ctx)) {
+			ctx->ticks = ticks;
+			if (ticks)
+				wake_up_locked(&ctx->wqh);
+		} else
+			ret = -ECANCELED;
+		spin_unlock_irq(&ctx->wqh.lock);
+		break;
+	}
+	default:
+		ret = -ENOTTY;
+		break;
+	}
+
+	return ret;
+}
+#else
+#define timerfd_ioctl NULL
+#endif
+
 static const struct file_operations timerfd_fops = {
 	.release	= timerfd_release,
 	.poll		= timerfd_poll,
 	.read		= timerfd_read,
 	.llseek		= noop_llseek,
 	.show_fdinfo	= timerfd_show,
+	.unlocked_ioctl	= timerfd_ioctl,
 };
 
 static int timerfd_fget(int fd, struct fd *p)
Index: linux-2.6.git/include/linux/timerfd.h
===================================================================
--- linux-2.6.git.orig/include/linux/timerfd.h
+++ linux-2.6.git/include/linux/timerfd.h
@@ -11,6 +11,9 @@
 /* For O_CLOEXEC and O_NONBLOCK */
 #include <linux/fcntl.h>
 
+/* For _IO helpers */
+#include <linux/ioctl.h>
+
 /*
  * CAREFUL: Check include/asm-generic/fcntl.h when defining
  * new flags, since they might collide with O_* ones. We want
@@ -29,4 +32,6 @@
 /* Flags for timerfd_settime.  */
 #define TFD_SETTIME_FLAGS (TFD_TIMER_ABSTIME | TFD_TIMER_CANCEL_ON_SET)
 
+#define TFD_IOC_SET_TICKS	_IOW('T', 0, u64)
+
 #endif /* _LINUX_TIMERFD_H */
