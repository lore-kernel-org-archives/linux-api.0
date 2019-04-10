From: Aubrey Li <aubrey.li@linux.intel.com>
Subject: [PATCH v14 1/3] /proc/pid/status: Add support for architecture specific output
Date: Wed, 10 Apr 2019 09:53:23 +0800
Message-ID: <20190410015326.24500-1-aubrey.li@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: tglx@linutronix.de, mingo@redhat.com, peterz@infradead.org, hpa@zytor.com
Cc: ak@linux.intel.com, tim.c.chen@linux.intel.com, dave.hansen@intel.com, arjan@linux.intel.com, adobriyan@gmail.com, akpm@linux-foundation.org, aubrey.li@intel.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Aubrey Li <aubrey.li@linux.intel.com>
List-Id: linux-api@vger.kernel.org

The architecture specific information of the running processes could
be useful to the userland. Add support to examine process architecture
specific information externally.

Signed-off-by: Aubrey Li <aubrey.li@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Linux API <linux-api@vger.kernel.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 fs/proc/array.c         | 5 +++++
 include/linux/proc_fs.h | 2 ++
 2 files changed, 7 insertions(+)

diff --git a/fs/proc/array.c b/fs/proc/array.c
index 2edbb657f859..331592a61718 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -401,6 +401,10 @@ static inline void task_thp_status(struct seq_file *m, struct mm_struct *mm)
 	seq_printf(m, "THP_enabled:\t%d\n", thp_enabled);
 }
 
+void __weak arch_proc_pid_status(struct seq_file *m, struct task_struct *task)
+{
+}
+
 int proc_pid_status(struct seq_file *m, struct pid_namespace *ns,
 			struct pid *pid, struct task_struct *task)
 {
@@ -424,6 +428,7 @@ int proc_pid_status(struct seq_file *m, struct pid_namespace *ns,
 	task_cpus_allowed(m, task);
 	cpuset_task_status_allowed(m, task);
 	task_context_switch_counts(m, task);
+	arch_proc_pid_status(m, task);
 	return 0;
 }
 
diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
index 52a283ba0465..bf4328cb58ed 100644
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -74,6 +74,8 @@ struct proc_dir_entry *proc_create_net_single_write(const char *name, umode_t mo
 						    proc_write_t write,
 						    void *data);
 extern struct pid *tgid_pidfd_to_pid(const struct file *file);
+/* Add support for architecture specific output in /proc/pid/status */
+void arch_proc_pid_status(struct seq_file *m, struct task_struct *task);
 
 #else /* CONFIG_PROC_FS */
 
-- 
2.21.0
