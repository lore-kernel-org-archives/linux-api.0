From: Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Subject: [patch 1/4] timerfd: Implement show_fdinfo method
Date: Wed, 16 Jul 2014 01:54:52 +0400
Message-ID: <20140715215703.114365649@openvz.org>
References: <20140715215451.499191426@openvz.org>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline; filename=timerfd-show-fdinfo-5
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

For checkpoint/restore of timerfd files we need to know how exactly
the timer were armed, to be able to recreate it on restore stage.
Thus implement show_fdinfo method which provides enough information
for that.

One of significant changes I think is the addition of @settime_flags
member. Currently there are two flags TFD_TIMER_ABSTIME and
TFD_TIMER_CANCEL_ON_SET, and the second can be found from
@might_cancel variable but in case if the flags will be extended
in future we most probably will have to somehow remember them
explicitly anyway so I guss doing that right now won't hurt.

To not bloat the timerfd_ctx structure I've converted @expired
to short integer and defined @settime_flags as short too.

v2 (by avagin@, vdavydov@ and tglx@):

 - Add it_value/it_interval fields
 - Save flags being used in timerfd_setup in context

v3 (by tglx@):
 - don't forget to use CONFIG_PROC_FS

v4 (by akpm@):
 -Use define timerfd_show NULL for non c/r config

CC: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
CC: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
CC: Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
CC: Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
CC: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Signed-off-by: Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
---
 fs/timerfd.c |   34 +++++++++++++++++++++++++++++++++-
 1 file changed, 33 insertions(+), 1 deletion(-)

Index: linux-2.6.git/fs/timerfd.c
===================================================================
--- linux-2.6.git.orig/fs/timerfd.c
+++ linux-2.6.git/fs/timerfd.c
@@ -35,8 +35,9 @@ struct timerfd_ctx {
 	ktime_t moffs;
 	wait_queue_head_t wqh;
 	u64 ticks;
-	int expired;
 	int clockid;
+	short unsigned expired;
+	short unsigned settime_flags;	/* to show in fdinfo */
 	struct rcu_head rcu;
 	struct list_head clist;
 	bool might_cancel;
@@ -196,6 +197,8 @@ static int timerfd_setup(struct timerfd_
 		if (timerfd_canceled(ctx))
 			return -ECANCELED;
 	}
+
+	ctx->settime_flags = flags & TFD_SETTIME_FLAGS;
 	return 0;
 }
 
@@ -284,11 +287,40 @@ static ssize_t timerfd_read(struct file
 	return res;
 }
 
+#ifdef CONFIG_PROC_FS
+static int timerfd_show(struct seq_file *m, struct file *file)
+{
+	struct timerfd_ctx *ctx = file->private_data;
+	struct itimerspec t;
+
+	spin_lock_irq(&ctx->wqh.lock);
+	t.it_value = ktime_to_timespec(timerfd_get_remaining(ctx));
+	t.it_interval = ktime_to_timespec(ctx->tintv);
+	spin_unlock_irq(&ctx->wqh.lock);
+
+	return seq_printf(m,
+			  "clockid: %d\n"
+			  "ticks: %llu\n"
+			  "settime flags: 0%o\n"
+			  "it_value: (%llu, %llu)\n"
+			  "it_interval: (%llu, %llu)\n",
+			  ctx->clockid, (unsigned long long)ctx->ticks,
+			  ctx->settime_flags,
+			  (unsigned long long)t.it_value.tv_sec,
+			  (unsigned long long)t.it_value.tv_nsec,
+			  (unsigned long long)t.it_interval.tv_sec,
+			  (unsigned long long)t.it_interval.tv_nsec);
+}
+#else
+#define timerfd_show NULL
+#endif
+
 static const struct file_operations timerfd_fops = {
 	.release	= timerfd_release,
 	.poll		= timerfd_poll,
 	.read		= timerfd_read,
 	.llseek		= noop_llseek,
+	.show_fdinfo	= timerfd_show,
 };
 
 static int timerfd_fget(int fd, struct fd *p)
