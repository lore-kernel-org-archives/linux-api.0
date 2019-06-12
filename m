From: tip-bot for Aubrey Li <tipbot@zytor.com>
Subject: [tip:x86/core] proc: Add /proc/<pid>/arch_status
Date: Wed, 12 Jun 2019 05:34:51 -0700
Message-ID: <tip-68bc30bb9f33fc8d11e3d110d29e06490896a999@git.kernel.org>
References: <20190606012236.9391-1-aubrey.li@linux.intel.com>
Reply-To: ak@linux.intel.com, tglx@linutronix.de,
          linux-kernel@vger.kernel.org, arjan@linux.intel.com,
          hpa@zytor.com, aubrey.li@linux.intel.com, luto@kernel.org,
          linux-api@vger.kernel.org, peterz@infradead.org,
          akpm@linux-foundation.org, tim.c.chen@linux.intel.com,
          mingo@kernel.org, dave.hansen@intel.com, adobriyan@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190606012236.9391-1-aubrey.li@linux.intel.com>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: linux-tip-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, adobriyan@gmail.com, mingo@kernel.org, dave.hansen@intel.com, tim.c.chen@linux.intel.com, arjan@linux.intel.com, linux-kernel@vger.kernel.org, tglx@linutronix.de, ak@linux.intel.com, peterz@infradead.org, linux-api@vger.kernel.org, luto@kernel.org, aubrey.li@linux.intel.com, hpa@zytor.com
List-Id: linux-api@vger.kernel.org

Commit-ID:  68bc30bb9f33fc8d11e3d110d29e06490896a999
Gitweb:     https://git.kernel.org/tip/68bc30bb9f33fc8d11e3d110d29e06490896a999
Author:     Aubrey Li <aubrey.li@linux.intel.com>
AuthorDate: Thu, 6 Jun 2019 09:22:34 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 12 Jun 2019 11:42:13 +0200

proc: Add /proc/<pid>/arch_status

Exposing architecture specific per process information is useful for
various reasons. An example is the AVX512 usage on x86 which is important
for task placement for power/performance optimizations.

Adding this information to the existing /prcc/pid/status file would be the
obvious choise, but it has been agreed on that a explicit arch_status file
is better in separating the generic and architecture specific information.

[ tglx: Massage changelog ]

Signed-off-by: Aubrey Li <aubrey.li@linux.intel.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Andrew Morton <akpm@linux-foundation.org>
Cc: peterz@infradead.org
Cc: hpa@zytor.com
Cc: ak@linux.intel.com
Cc: tim.c.chen@linux.intel.com
Cc: dave.hansen@intel.com
Cc: arjan@linux.intel.com
Cc: adobriyan@gmail.com
Cc: aubrey.li@intel.com
Cc: linux-api@vger.kernel.org
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Linux API <linux-api@vger.kernel.org>
Link: https://lkml.kernel.org/r/20190606012236.9391-1-aubrey.li@linux.intel.com

---
 fs/proc/Kconfig         | 4 ++++
 fs/proc/base.c          | 6 ++++++
 include/linux/proc_fs.h | 9 +++++++++
 3 files changed, 19 insertions(+)

diff --git a/fs/proc/Kconfig b/fs/proc/Kconfig
index 62ee41b4bbd0..4c3dcb718961 100644
--- a/fs/proc/Kconfig
+++ b/fs/proc/Kconfig
@@ -98,3 +98,7 @@ config PROC_CHILDREN
 
 	  Say Y if you are running any user-space software which takes benefit from
 	  this interface. For example, rkt is such a piece of software.
+
+config PROC_PID_ARCH_STATUS
+	def_bool n
+	depends on PROC_FS
diff --git a/fs/proc/base.c b/fs/proc/base.c
index 9c8ca6cd3ce4..ec436c61eece 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -3061,6 +3061,9 @@ static const struct pid_entry tgid_base_stuff[] = {
 #ifdef CONFIG_STACKLEAK_METRICS
 	ONE("stack_depth", S_IRUGO, proc_stack_depth),
 #endif
+#ifdef CONFIG_PROC_PID_ARCH_STATUS
+	ONE("arch_status", S_IRUGO, proc_pid_arch_status),
+#endif
 };
 
 static int proc_tgid_base_readdir(struct file *file, struct dir_context *ctx)
@@ -3449,6 +3452,9 @@ static const struct pid_entry tid_base_stuff[] = {
 #ifdef CONFIG_LIVEPATCH
 	ONE("patch_state",  S_IRUSR, proc_pid_patch_state),
 #endif
+#ifdef CONFIG_PROC_PID_ARCH_STATUS
+	ONE("arch_status", S_IRUGO, proc_pid_arch_status),
+#endif
 };
 
 static int proc_tid_base_readdir(struct file *file, struct dir_context *ctx)
diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
index 52a283ba0465..a705aa2d03f9 100644
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -75,6 +75,15 @@ struct proc_dir_entry *proc_create_net_single_write(const char *name, umode_t mo
 						    void *data);
 extern struct pid *tgid_pidfd_to_pid(const struct file *file);
 
+#ifdef CONFIG_PROC_PID_ARCH_STATUS
+/*
+ * The architecture which selects CONFIG_PROC_PID_ARCH_STATUS must
+ * provide proc_pid_arch_status() definition.
+ */
+int proc_pid_arch_status(struct seq_file *m, struct pid_namespace *ns,
+			struct pid *pid, struct task_struct *task);
+#endif /* CONFIG_PROC_PID_ARCH_STATUS */
+
 #else /* CONFIG_PROC_FS */
 
 static inline void proc_root_init(void)
