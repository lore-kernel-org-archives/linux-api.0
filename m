From: Petr Mladek <pmladek-AlSwsSmVLrQ@public.gmane.org>
Subject: [RFC PATCH 05/18] freezer/scheduler: Add freezable_cond_resched()
Date: Fri,  5 Jun 2015 17:01:04 +0200
Message-ID: <1433516477-5153-6-git-send-email-pmladek@suse.cz>
References: <1433516477-5153-1-git-send-email-pmladek@suse.cz>
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1433516477-5153-1-git-send-email-pmladek-AlSwsSmVLrQ@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>, Anna Schumaker <anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Chris Mason <clm-b10kYP2dOMg@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, live-patching-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Petr Mladek <pmladek-AlSwsSmVLrQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

It makes sense to call cond_resched() in freezable kthreads.
But there is the chicken&egg problem whether to call try_to_freeze()
before or after the schedule.

This patch adds freezable_cond_resched(). It uses the same trick as
freezable_schedule(). It tells the freezer that it might ignore
the sleeping process.

Note that it might be used only on locations where the freezing
is safe. It means that no lock is taken and we are ready to sleep
for a very long time.

Signed-off-by: Petr Mladek <pmladek-AlSwsSmVLrQ@public.gmane.org>
---
 include/linux/freezer.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/include/linux/freezer.h b/include/linux/freezer.h
index 6b7fd9cf5ea2..1446f210dfc6 100644
--- a/include/linux/freezer.h
+++ b/include/linux/freezer.h
@@ -172,6 +172,14 @@ static inline void freezable_schedule(void)
 	freezer_count();
 }
 
+/* Like cond_resched(), but should not block the freezer. */
+static inline void freezable_cond_resched(void)
+{
+	freezer_do_not_count();
+	cond_resched();
+	freezer_count();
+}
+
 /* DO NOT ADD ANY NEW CALLERS OF THIS FUNCTION */
 static inline void freezable_schedule_unsafe(void)
 {
-- 
1.8.5.6

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
