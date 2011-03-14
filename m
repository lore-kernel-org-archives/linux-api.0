From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: [PATCH, v9 1/3] hrtimer: introduce effective timer slack
Date: Mon, 14 Mar 2011 16:05:22 +0200
Message-ID: <1300111524-5666-2-git-send-email-kirill@shutemov.name>
References: <1300111524-5666-1-git-send-email-kirill@shutemov.name>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1300111524-5666-1-git-send-email-kirill@shutemov.name>
Sender: linux-kernel-owner@vger.kernel.org
To: Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>, Andrew Morton <akpm@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: containers@lists.linux-foundation.org, jacob.jun.pan@linux.intel.com, Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org, Matt Helsley <matthltc@us.ibm.com>, linux-api@vger.kernel.org, "Kirill A. Shutemov" <kirill@shutemov.name>
List-Id: linux-api@vger.kernel.org

task_get_effective_timer_slack() returns timer slack value to be used
to configure per-task timers. It can be equal or higher than task's
timer slack value.

For now task_get_effective_timer_slack() returns timer_slack_ns of the
task. Timer slack cgroup controller will implement a bit more
sophisticated logic.

Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
---
 fs/select.c           |    7 ++-----
 include/linux/sched.h |    6 ++++++
 kernel/fork.c         |    4 ++++
 kernel/futex.c        |    4 ++--
 kernel/hrtimer.c      |    2 +-
 5 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/fs/select.c b/fs/select.c
index e56560d..fb7d6ec 100644
--- a/fs/select.c
+++ b/fs/select.c
@@ -69,7 +69,6 @@ static long __estimate_accuracy(struct timespec *tv)
 
 long select_estimate_accuracy(struct timespec *tv)
 {
-	unsigned long ret;
 	struct timespec now;
 
 	/*
@@ -81,10 +80,8 @@ long select_estimate_accuracy(struct timespec *tv)
 
 	ktime_get_ts(&now);
 	now = timespec_sub(*tv, now);
-	ret = __estimate_accuracy(&now);
-	if (ret < current->timer_slack_ns)
-		return current->timer_slack_ns;
-	return ret;
+	return min_t(long, __estimate_accuracy(&now),
+			task_get_effective_timer_slack(current));
 }
 
 
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 777d8a5..44f6f55 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2620,6 +2620,12 @@ static inline unsigned long rlimit_max(unsigned int limit)
 	return task_rlimit_max(current, limit);
 }
 
+static inline unsigned long task_get_effective_timer_slack(
+		struct task_struct *tsk)
+{
+	return tsk->timer_slack_ns;
+}
+
 #endif /* __KERNEL__ */
 
 #endif
diff --git a/kernel/fork.c b/kernel/fork.c
index 25e4291..4958de9 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1089,6 +1089,10 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	memset(&p->rss_stat, 0, sizeof(p->rss_stat));
 #endif
 
+	/*
+	 * Save current task's (not effective) timer slack value as default
+	 * timer slack value for new task.
+	 */
 	p->default_timer_slack_ns = current->timer_slack_ns;
 
 	task_io_accounting_init(&p->ioac);
diff --git a/kernel/futex.c b/kernel/futex.c
index b766d28..e5811c4 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -1845,7 +1845,7 @@ static int futex_wait(u32 __user *uaddr, unsigned int flags, u32 val,
 				      HRTIMER_MODE_ABS);
 		hrtimer_init_sleeper(to, current);
 		hrtimer_set_expires_range_ns(&to->timer, *abs_time,
-					     current->timer_slack_ns);
+				     task_get_effective_timer_slack(current));
 	}
 
 retry:
@@ -2242,7 +2242,7 @@ static int futex_wait_requeue_pi(u32 __user *uaddr, unsigned int flags,
 				      HRTIMER_MODE_ABS);
 		hrtimer_init_sleeper(to, current);
 		hrtimer_set_expires_range_ns(&to->timer, *abs_time,
-					     current->timer_slack_ns);
+				     task_get_effective_timer_slack(current));
 	}
 
 	/*
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 0c8d7c0..ffc9a8d 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -1542,7 +1542,7 @@ long hrtimer_nanosleep(struct timespec *rqtp, struct timespec __user *rmtp,
 	int ret = 0;
 	unsigned long slack;
 
-	slack = current->timer_slack_ns;
+	slack = task_get_effective_timer_slack(current);
 	if (rt_task(current))
 		slack = 0;
 
-- 
1.7.4.1
