From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: [PATCH, v9 3/3] cgroups: introduce timer slack controller
Date: Mon, 14 Mar 2011 16:05:24 +0200
Message-ID: <1300111524-5666-4-git-send-email-kirill@shutemov.name>
References: <1300111524-5666-1-git-send-email-kirill@shutemov.name>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1300111524-5666-1-git-send-email-kirill@shutemov.name>
Sender: linux-kernel-owner@vger.kernel.org
To: Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>, Andrew Morton <akpm@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: containers@lists.linux-foundation.org, jacob.jun.pan@linux.intel.com, Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org, Matt Helsley <matthltc@us.ibm.com>, linux-api@vger.kernel.org, "Kirill A. Shutemov" <kirill@shutemov.name>
List-Id: linux-api@vger.kernel.org

Every task_struct has timer_slack_ns value. This value uses to round up
poll() and select() timeout values. This feature can be useful in
mobile environment where combined wakeups are desired.

Originally, prctl() was the only way to change timer slack value of
a process. So you was not able change timer slack value of another
process.

cgroup subsys "timer_slack" implements timer slack controller. It
provides a way to set minimal timer slack value for a group of tasks.
If a task belongs to a cgroup with minimal timer slack value higher than
task's value, cgroup's value will be applied.

Timer slack controller allows to implement setting timer slack value of
a process based on a policy. For example, you can create foreground and
background cgroups and move tasks between them based on system state.

Idea-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
---
 Documentation/cgroups/timer_slack.txt |   72 +++++++++++++++++++
 include/linux/cgroup_subsys.h         |    6 ++
 include/linux/sched.h                 |    4 +
 init/Kconfig                          |    8 ++
 kernel/Makefile                       |    1 +
 kernel/cgroup_timer_slack.c           |  124 +++++++++++++++++++++++++++++++++
 6 files changed, 215 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/cgroups/timer_slack.txt
 create mode 100644 kernel/cgroup_timer_slack.c

diff --git a/Documentation/cgroups/timer_slack.txt b/Documentation/cgroups/timer_slack.txt
new file mode 100644
index 0000000..4006eab
--- /dev/null
+++ b/Documentation/cgroups/timer_slack.txt
@@ -0,0 +1,72 @@
+Timer Slack Controller
+======================
+
+Overview
+--------
+
+Every task_struct has timer_slack_ns value. This value uses to round up
+poll() and select() timeout values. This feature can be useful in
+mobile environment where combined wakeups are desired.
+
+Originally, prctl() was the only way to change timer slack value of
+a process. So you was not able change timer slack value of another
+process.
+
+cgroup subsys "timer_slack" implements timer slack controller. It
+provides a way to set minimal timer slack value for a group of tasks.
+If a task belongs to a cgroup with minimal timer slack value higher than
+task's value, cgroup's value will be applied.
+
+Timer slack controller allows to implement setting timer slack value of
+a process based on a policy. For example, you can create foreground and
+background cgroups and move tasks between them based on system state.
+
+User interface
+--------------
+
+To get timer slack controller functionality you need to enable it in
+kernel configuration:
+
+CONFIG_CGROUP_TIMER_SLACK=y
+
+The controller provides two files:
+
+# mount -t cgroup -o timer_slack none /sys/fs/cgroup
+# ls /sys/fs/cgroup/timer_slack.*
+/sys/fs/cgroup/timer_slack.effective_slack_ns
+/sys/fs/cgroup/timer_slack.min_slack_ns
+
+By default timer_slack.min_slack_ns is 0:
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
+Timer slack controller supports hierarchical groups.
+
+# mkdir /sys/fs/cgroup/a
+# cat /sys/fs/cgroup/a/timer_slack.min_slack_ns
+50000
+# echo 70000 > /sys/fs/cgroup/a/timer_slack.min_slack_ns
+# cat /sys/fs/cgroup/a/timer_slack.min_slack_ns
+70000
+
+You can set any value you want, but effective value will the highest value
+up by hierarchy. You can see effective timer slack value for the cgroup from
+timer_slack.effective_slack_ns file:
+
+# cat /sys/fs/cgroup/a/timer_slack.effective_slack_ns
+70000
+# echo 100000 > /sys/fs/cgroup/timer_slack.min_slack_ns
+# cat /sys/fs/cgroup/a/timer_slack.min_slack_ns
+70000
+# cat /sys/fs/cgroup/a/timer_slack.effective_slack_ns
+100000
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
index 44f6f55..c10da5d 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2620,11 +2620,15 @@ static inline unsigned long rlimit_max(unsigned int limit)
 	return task_rlimit_max(current, limit);
 }
 
+#ifdef CONFIG_CGROUP_TIMER_SLACK
+extern unsigned long task_get_effective_timer_slack(struct task_struct *tsk);
+#else
 static inline unsigned long task_get_effective_timer_slack(
 		struct task_struct *tsk)
 {
 	return tsk->timer_slack_ns;
 }
+#endif
 
 #endif /* __KERNEL__ */
 
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
index 0000000..9824807
--- /dev/null
+++ b/kernel/cgroup_timer_slack.c
@@ -0,0 +1,124 @@
+/*
+ * cgroup_timer_slack.c - control group timer slack subsystem
+ *
+ * Copyright Nokia Corparation, 2011
+ * Author: Kirill A. Shutemov
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
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
+		struct tslack_cgroup *parent;
+
+		parent = cgroup_to_tslack(cgroup->parent);
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
+	if (val > ULONG_MAX)
+		return -EINVAL;
+
+	cgroup_to_tslack(cgroup)->min_slack_ns = val;
+
+	return 0;
+}
+
+static u64 tslack_read_effective(struct cgroup *cgroup, struct cftype *cft)
+{
+	unsigned long min;
+
+	min = cgroup_to_tslack(cgroup)->min_slack_ns;
+	while (cgroup->parent) {
+		cgroup = cgroup->parent;
+		min = max(cgroup_to_tslack(cgroup)->min_slack_ns, min);
+	}
+
+	return min;
+}
+
+static struct cftype files[] = {
+	{
+		.name = "min_slack_ns",
+		.read_u64 = tslack_read_min,
+		.write_u64 = tslack_write_min,
+	},
+	{
+		.name = "effective_slack_ns",
+		.read_u64 = tslack_read_effective,
+	},
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
+unsigned long task_get_effective_timer_slack(struct task_struct *tsk)
+{
+	struct cgroup *cgroup;
+	unsigned long slack;
+
+	rcu_read_lock();
+	cgroup = task_cgroup(tsk, timer_slack_subsys.subsys_id);
+	slack = tslack_read_effective(cgroup, NULL);
+	rcu_read_unlock();
+
+	return max(tsk->timer_slack_ns, slack);
+}
-- 
1.7.4.1
