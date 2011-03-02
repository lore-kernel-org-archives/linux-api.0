From: "Kirill A. Shutsemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
Subject: [PATCH, v7] cgroups: introduce timer slack controller
Date: Wed,  2 Mar 2011 18:40:01 +0200
Message-ID: <1299084001-3916-2-git-send-email-kirill@shutemov.name>
References: <1299084001-3916-1-git-send-email-kirill@shutemov.name>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1299084001-3916-1-git-send-email-kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Paul Menage <menage-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Cc: containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, Arjan van de Ven <arjan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Helsley <matthltc-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

From: Kirill A. Shutemov <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>

Every task_struct has timer_slack_ns value. This value uses to round up
poll() and select() timeout values. This feature can be useful in
mobile environment where combined wakeups are desired.

cgroup subsys "timer_slack" implement timer slack controller. It
provides a way to set minimal timer slack value for a group of tasks.
If a task belongs to a cgroup with minimal timer slack value higher than
task's value, cgroup's value will be applied.

Idea-by: Jacob Pan <jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Signed-off-by: Kirill A. Shutemov <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
---
 Documentation/cgroups/timer_slack.txt |   66 ++++++++++++++++++++
 fs/select.c                           |    7 +--
 include/linux/cgroup_subsys.h         |    6 ++
 include/linux/sched.h                 |    9 +++
 init/Kconfig                          |    8 +++
 kernel/Makefile                       |    1 +
 kernel/cgroup_timer_slack.c           |  107 +++++++++++++++++++++++++++++++++
 kernel/futex.c                        |    4 +-
 kernel/hrtimer.c                      |    2 +-
 9 files changed, 202 insertions(+), 8 deletions(-)
 create mode 100644 Documentation/cgroups/timer_slack.txt
 create mode 100644 kernel/cgroup_timer_slack.c

diff --git a/Documentation/cgroups/timer_slack.txt b/Documentation/cgroups/timer_slack.txt
new file mode 100644
index 0000000..16ac066
--- /dev/null
+++ b/Documentation/cgroups/timer_slack.txt
@@ -0,0 +1,66 @@
+Timer Slack Controller
+=====================
+
+Overview
+--------
+
+Every task_struct has timer_slack_ns value. This value uses to round up
+poll() and select() timeout values. This feature can be useful in
+mobile environment where combined wakeups are desired.
+
+cgroup subsys "timer_slack" implement timer slack controller. It
+provides a way to set minimal timer slack value for a group of tasks.
+If a task belongs to a cgroup with minimal timer slack value higher than
+task's value, cgroup's value will be applied.
+
+User interface
+--------------
+
+To get timer slack controller functionality you need to enable it in
+kernel configuration:
+
+CONFIG_CGROUP_TIMER_SLACK=y
+
+The controller provides only one file:
+
+# mount -t cgroup -o timer_slack none /sys/fs/cgroup
+# ls /sys/fs/cgroup/timer_slack.*
+/sys/fs/cgroup/timer_slack.min_slack_ns
+
+By defeault it's 0:
+
+# cat /sys/fs/cgroup/timer_slack.min_slack_ns
+0
+
+You can set it to some value:
+
+# echo 50000 > /sys/fs/cgroup/timer_slack.min_slack_ns
+# cat /sys/fs/cgroup/timer_slack.min_slack_ns
+50000
+
+Tasks still can set task's value below 50000 using prctl(), but in this
+case cgroup's value will be applied.
+
+Timer slack controller supports hierarchical groups. The only rule:
+parent's minimal timer slack value should be less or equal to child's.
+
+# mkdir /sys/fs/cgroup/a
+# cat /sys/fs/cgroup/a/timer_slack.min_slack_ns
+50000
+# echo 70000 > /sys/fs/cgroup/a/timer_slack.min_slack_ns
+# cat /sys/fs/cgroup/a/timer_slack.min_slack_ns
+70000
+
+You'll get -EPERM, if you try to set child's timer_slack.min_slack_ns >
+parent's timer_slack.min_slack_ns:
+
+# /bin/echo 40000 > /sys/fs/cgroup/a/timer_slack.min_slack_ns
+/bin/echo: write error: Operation not permitted
+
+Child's value will be adjusted if necessary on parent's value update:
+
+# echo 100000 > /sys/fs/cgroup/timer_slack.min_slack_ns
+# cat /sys/fs/cgroup/timer_slack.min_slack_ns 
+100000
+# cat /sys/fs/cgroup/a/timer_slack.min_slack_ns 
+100000
diff --git a/fs/select.c b/fs/select.c
index e56560d..a189e4d 100644
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
+	return clamp(__estimate_accuracy(&now),
+			get_task_timer_slack(current), LONG_MAX);
 }
 
 
diff --git a/include/linux/cgroup_subsys.h b/include/linux/cgroup_subsys.h
index ccefff0..e399228 100644
--- a/include/linux/cgroup_subsys.h
+++ b/include/linux/cgroup_subsys.h
@@ -66,3 +66,9 @@ SUBSYS(blkio)
 #endif
 
 /* */
+
+#ifdef CONFIG_CGROUP_TIMER_SLACK
+SUBSYS(timer_slack)
+#endif
+
+/* */
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 777d8a5..3751aaa 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2620,6 +2620,15 @@ static inline unsigned long rlimit_max(unsigned int limit)
 	return task_rlimit_max(current, limit);
 }
 
+#ifdef CONFIG_CGROUP_TIMER_SLACK
+extern unsigned long get_task_timer_slack(struct task_struct *tsk);
+#else
+static inline unsigned long get_task_timer_slack(struct task_struct *tsk)
+{
+	return tsk->timer_slack_ns;
+}
+#endif
+
 #endif /* __KERNEL__ */
 
 #endif
diff --git a/init/Kconfig b/init/Kconfig
index be788c0..bbc4d9c 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -596,6 +596,14 @@ config CGROUP_FREEZER
 	  Provides a way to freeze and unfreeze all tasks in a
 	  cgroup.
 
+config CGROUP_TIMER_SLACK
+	bool "Timer slack cgroup controller"
+	help
+	  Provides a way to set minimal timer slack value for tasks in
+	  a cgroup.
+	  It's useful in mobile devices where certain background apps
+	  are attached to a cgroup and combined wakeups are desired.
+
 config CGROUP_DEVICE
 	bool "Device controller for cgroups"
 	help
diff --git a/kernel/Makefile b/kernel/Makefile
index 353d3fe..0b60239 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -61,6 +61,7 @@ obj-$(CONFIG_BACKTRACE_SELF_TEST) += backtracetest.o
 obj-$(CONFIG_COMPAT) += compat.o
 obj-$(CONFIG_CGROUPS) += cgroup.o
 obj-$(CONFIG_CGROUP_FREEZER) += cgroup_freezer.o
+obj-$(CONFIG_CGROUP_TIMER_SLACK) += cgroup_timer_slack.o
 obj-$(CONFIG_CPUSETS) += cpuset.o
 obj-$(CONFIG_CGROUP_NS) += ns_cgroup.o
 obj-$(CONFIG_UTS_NS) += utsname.o
diff --git a/kernel/cgroup_timer_slack.c b/kernel/cgroup_timer_slack.c
new file mode 100644
index 0000000..c300125
--- /dev/null
+++ b/kernel/cgroup_timer_slack.c
@@ -0,0 +1,107 @@
+#include <linux/cgroup.h>
+#include <linux/slab.h>
+
+struct cgroup_subsys timer_slack_subsys;
+struct tslack_cgroup {
+	struct cgroup_subsys_state css;
+	unsigned long min_slack_ns;
+};
+
+static struct tslack_cgroup *cgroup_to_tslack(struct cgroup *cgroup)
+{
+	struct cgroup_subsys_state *css;
+
+	css = cgroup_subsys_state(cgroup, timer_slack_subsys.subsys_id);
+	return container_of(css, struct tslack_cgroup, css);
+}
+
+static struct cgroup_subsys_state *tslack_create(struct cgroup_subsys *subsys,
+		struct cgroup *cgroup)
+{
+	struct tslack_cgroup *tslack_cgroup;
+
+	tslack_cgroup = kmalloc(sizeof(*tslack_cgroup), GFP_KERNEL);
+	if (!tslack_cgroup)
+		return ERR_PTR(-ENOMEM);
+
+	if (cgroup->parent) {
+		struct tslack_cgroup *parent = cgroup_to_tslack(cgroup->parent);
+		tslack_cgroup->min_slack_ns = parent->min_slack_ns;
+	} else
+		tslack_cgroup->min_slack_ns = 0UL;
+
+	return &tslack_cgroup->css;
+}
+
+static void tslack_destroy(struct cgroup_subsys *tslack_cgroup,
+		struct cgroup *cgroup)
+{
+	kfree(cgroup_to_tslack(cgroup));
+}
+
+static u64 tslack_read_min(struct cgroup *cgroup, struct cftype *cft)
+{
+	return cgroup_to_tslack(cgroup)->min_slack_ns;
+}
+
+static int tslack_write_min(struct cgroup *cgroup, struct cftype *cft, u64 val)
+{
+	struct cgroup *cur;
+
+	if (val > ULONG_MAX)
+		return -EINVAL;
+
+	/* the min timer slack value should be more or equal than parent's */
+	if (cgroup->parent) {
+		struct tslack_cgroup *parent = cgroup_to_tslack(cgroup->parent);
+		if (parent->min_slack_ns > val)
+			return -EPERM;
+	}
+
+	cgroup_to_tslack(cgroup)->min_slack_ns = val;
+
+	/* update children's min slack value if needed */
+	list_for_each_entry(cur, &cgroup->children, sibling) {
+		struct tslack_cgroup *child = cgroup_to_tslack(cur);
+		if (val > child->min_slack_ns)
+			tslack_write_min(cur, cft, val);
+	}
+
+	return 0;
+}
+
+static struct cftype files[] = {
+	{
+		.name = "min_slack_ns",
+		.read_u64 = tslack_read_min,
+		.write_u64 = tslack_write_min,
+	}
+};
+
+static int tslack_populate(struct cgroup_subsys *subsys, struct cgroup *cgroup)
+{
+	return cgroup_add_files(cgroup, subsys, files, ARRAY_SIZE(files));
+}
+
+struct cgroup_subsys timer_slack_subsys = {
+	.name		= "timer_slack",
+	.subsys_id	= timer_slack_subsys_id,
+	.create		= tslack_create,
+	.destroy	= tslack_destroy,
+	.populate	= tslack_populate,
+};
+
+unsigned long get_task_timer_slack(struct task_struct *tsk)
+{
+	struct cgroup_subsys_state *css;
+	struct tslack_cgroup *tslack_cgroup;
+	unsigned long ret;
+
+	rcu_read_lock();
+	css = task_subsys_state(tsk, timer_slack_subsys.subsys_id);
+	tslack_cgroup = container_of(css, struct tslack_cgroup, css);
+	ret = max(tsk->timer_slack_ns, tslack_cgroup->min_slack_ns);
+	rcu_read_unlock();
+
+	return ret;
+}
diff --git a/kernel/futex.c b/kernel/futex.c
index b766d28..eca8773 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -1845,7 +1845,7 @@ static int futex_wait(u32 __user *uaddr, unsigned int flags, u32 val,
 				      HRTIMER_MODE_ABS);
 		hrtimer_init_sleeper(to, current);
 		hrtimer_set_expires_range_ns(&to->timer, *abs_time,
-					     current->timer_slack_ns);
+					     get_task_timer_slack(current));
 	}
 
 retry:
@@ -2242,7 +2242,7 @@ static int futex_wait_requeue_pi(u32 __user *uaddr, unsigned int flags,
 				      HRTIMER_MODE_ABS);
 		hrtimer_init_sleeper(to, current);
 		hrtimer_set_expires_range_ns(&to->timer, *abs_time,
-					     current->timer_slack_ns);
+					     get_task_timer_slack(current));
 	}
 
 	/*
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 0c8d7c0..cdf47ba 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -1542,7 +1542,7 @@ long hrtimer_nanosleep(struct timespec *rqtp, struct timespec __user *rmtp,
 	int ret = 0;
 	unsigned long slack;
 
-	slack = current->timer_slack_ns;
+	slack = get_task_timer_slack(current);
 	if (rt_task(current))
 		slack = 0;
 
-- 
1.7.4.1
