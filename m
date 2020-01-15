From: Chen Yu <yu.c.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH][v7] x86/resctrl: Add task resctrl information display
Date: Wed, 15 Jan 2020 17:28:51 +0800
Message-ID: <20200115092851.14761-1-yu.c.chen@intel.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Chen Yu <yu.c.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Reinette Chatre <reinette.chatre-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Fenghua Yu <fenghua.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Krzysztof Kozlowski <krzk-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mauro Carvalho Chehab <mchehab+samsung-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Monitoring tools that want to find out which resctrl control and monitor
groups a task belongs to must currently read the "tasks" file in every
group until they locate the process ID.

Add an additional file /proc/{pid}/cpu_resctrl_groups to provide this
information:

1)   res:
     mon:

resctrl is not available.

2)   res:/
     mon:

Task is part of the root resctrl control group, and it is not associated
to any monitor group.

3)  res:/
    mon:mon0

Task is part of the root resctrl control group and monitor group mon0.

4)  res:group0
    mon:

Task is part of resctrl control group group0, and it is not associated
to any monitor group.

5) res:group0
   mon:mon1

Task is part of resctrl control group group0 and monitor group mon1.

Tested-by: Jinshi Chen <jinshi.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Reinette Chatre <reinette.chatre-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Fenghua Yu <fenghua.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Cc: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Krzysztof Kozlowski <krzk-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Mauro Carvalho Chehab <mchehab+samsung-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Signed-off-by: Chen Yu <yu.c.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
v1: Initial version reviewed by Reinette Chatre,
    Fenghua Yu and Tony Luck.

v2: According to Boris's suggestion,
    reduce indentation level in proc_resctrl_show().
    Create the include/linux/resctrl.h header and
    declare proc_resctrl_show() in this file, so
    that other architectures would probably use it
    in the future. Different architectures should
    implement architectural specific proc_resctrl_show()
    accordingly.

v3: According to Boris's suggestion,
    Return empty string if the resctrl filesystem has
    not been mounted.
    Rename the config from CPU_RESCTRL to PROC_CPU_RESCTRL
    to better represent its usage. Move PROC_CPU_RESCTRL
    from arch/Kconfig to fs/proc/Kconfig.
    And let PROC_CPU_RESCTRL to be depended on PROC_FS.

v4: According to Thomas's suggestion, changed the output
    from multiple lines to one single line.

v5: According to Alexey's feedback, removed the header file
    proc_fs.h in resctrl.h, and changed seq_puts() to
    seq_putc() for simplicity.

v6: According to Chris Down's suggestion,
    1. rename:
    /proc/{pid}/resctrl to /proc/{pid}/cpu_resctrl
    to better reflect its meaning.
    2. change the description in comments:
    "control group" to "resctrl control group"
    as the former is confusing for cgroup users.

v7: According to Boris's suggestion,
    split the output into two lines, to display the
    resctrl control group and monitor group respctively
    to be more human/tool-readable. Renamed the file to
    cpu_resctrl_groups.
---
 arch/x86/Kconfig                       |  1 +
 arch/x86/kernel/cpu/resctrl/rdtgroup.c | 86 ++++++++++++++++++++++++++
 fs/proc/Kconfig                        |  4 ++
 fs/proc/base.c                         |  7 +++
 include/linux/resctrl.h                | 14 +++++
 5 files changed, 112 insertions(+)
 create mode 100644 include/linux/resctrl.h

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 5e8949953660..6e17a68c7d77 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -456,6 +456,7 @@ config X86_CPU_RESCTRL
 	bool "x86 CPU resource control support"
 	depends on X86 && (CPU_SUP_INTEL || CPU_SUP_AMD)
 	select KERNFS
+	select PROC_CPU_RESCTRL		if PROC_FS
 	help
 	  Enable x86 CPU resource control support.
 
diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
index 2e3b06d6bbc6..4b185740d29d 100644
--- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
+++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
@@ -725,6 +725,92 @@ static int rdtgroup_tasks_show(struct kernfs_open_file *of,
 	return ret;
 }
 
+#ifdef CONFIG_PROC_CPU_RESCTRL
+
+/*
+ * A task can only be part of one resctrl control group and of one monitor
+ * group which is associated to that control group.
+ *
+ * 1)   res:
+ *      mon:
+ *
+ *    resctrl is not available.
+ *
+ * 2)   res:/
+ *      mon:
+ *
+ *    Task is part of the root resctrl control group, and it is not associated
+ *    to any monitor group.
+ *
+ * 3)  res:/
+ *     mon:mon0
+ *
+ *    Task is part of the root resctrl control group and monitor group mon0.
+ *
+ * 4)  res:group0
+ *     mon:
+ *
+ *    Task is part of resctrl control group group0, and it is not associated
+ *    to any monitor group.
+ *
+ * 5) res:group0
+ *    mon:mon1
+ *
+ *    Task is part of resctrl control group group0 and monitor group mon1.
+ */
+int proc_resctrl_show(struct seq_file *s, struct pid_namespace *ns,
+		      struct pid *pid, struct task_struct *tsk)
+{
+	struct rdtgroup *rdtg;
+	int ret = 0;
+
+	mutex_lock(&rdtgroup_mutex);
+
+	/* Return empty if resctrl has not been mounted. */
+	if (!static_branch_unlikely(&rdt_enable_key)) {
+		seq_puts(s, "res:\nmon:\n");
+		goto unlock;
+	}
+
+	list_for_each_entry(rdtg, &rdt_all_groups, rdtgroup_list) {
+		struct rdtgroup *crg;
+
+		/*
+		 * Task information is only relevant for shareable
+		 * and exclusive groups.
+		 */
+		if (rdtg->mode != RDT_MODE_SHAREABLE &&
+		    rdtg->mode != RDT_MODE_EXCLUSIVE)
+			continue;
+
+		if (rdtg->closid != tsk->closid)
+			continue;
+
+		seq_printf(s, "res:%s%s\n", (rdtg == &rdtgroup_default) ? "/" : "",
+			   rdtg->kn->name);
+		seq_puts(s, "mon:");
+		list_for_each_entry(crg, &rdtg->mon.crdtgrp_list,
+				    mon.crdtgrp_list) {
+			if (tsk->rmid != crg->mon.rmid)
+				continue;
+			seq_printf(s, "%s", crg->kn->name);
+			break;
+		}
+		seq_putc(s, '\n');
+		goto unlock;
+	}
+	/*
+	 * The above search should succeed. Otherwise return
+	 * with an error.
+	 */
+	ret = -ENOENT;
+unlock:
+	mutex_unlock(&rdtgroup_mutex);
+
+	return ret;
+}
+#endif
+
 static int rdt_last_cmd_status_show(struct kernfs_open_file *of,
 				    struct seq_file *seq, void *v)
 {
diff --git a/fs/proc/Kconfig b/fs/proc/Kconfig
index 733881a6387b..27ef84d99f59 100644
--- a/fs/proc/Kconfig
+++ b/fs/proc/Kconfig
@@ -103,3 +103,7 @@ config PROC_CHILDREN
 config PROC_PID_ARCH_STATUS
 	def_bool n
 	depends on PROC_FS
+
+config PROC_CPU_RESCTRL
+	def_bool n
+	depends on PROC_FS
diff --git a/fs/proc/base.c b/fs/proc/base.c
index ebea9501afb8..bbffd654bb0e 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -94,6 +94,7 @@
 #include <linux/sched/debug.h>
 #include <linux/sched/stat.h>
 #include <linux/posix-timers.h>
+#include <linux/resctrl.h>
 #include <trace/events/oom.h>
 #include "internal.h"
 #include "fd.h"
@@ -3060,6 +3061,9 @@ static const struct pid_entry tgid_base_stuff[] = {
 #endif
 #ifdef CONFIG_CGROUPS
 	ONE("cgroup",  S_IRUGO, proc_cgroup_show),
+#endif
+#ifdef CONFIG_PROC_CPU_RESCTRL
+	ONE("cpu_resctrl_groups", S_IRUGO, proc_resctrl_show),
 #endif
 	ONE("oom_score",  S_IRUGO, proc_oom_score),
 	REG("oom_adj",    S_IRUGO|S_IWUSR, proc_oom_adj_operations),
@@ -3460,6 +3464,9 @@ static const struct pid_entry tid_base_stuff[] = {
 #endif
 #ifdef CONFIG_CGROUPS
 	ONE("cgroup",  S_IRUGO, proc_cgroup_show),
+#endif
+#ifdef CONFIG_PROC_CPU_RESCTRL
+	ONE("cpu_resctrl_groups", S_IRUGO, proc_resctrl_show),
 #endif
 	ONE("oom_score", S_IRUGO, proc_oom_score),
 	REG("oom_adj",   S_IRUGO|S_IWUSR, proc_oom_adj_operations),
diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
new file mode 100644
index 000000000000..daf5cf64c6a6
--- /dev/null
+++ b/include/linux/resctrl.h
@@ -0,0 +1,14 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _RESCTRL_H
+#define _RESCTRL_H
+
+#ifdef CONFIG_PROC_CPU_RESCTRL
+
+int proc_resctrl_show(struct seq_file *m,
+		      struct pid_namespace *ns,
+		      struct pid *pid,
+		      struct task_struct *tsk);
+
+#endif
+
+#endif /* _RESCTRL_H */
-- 
2.17.1
