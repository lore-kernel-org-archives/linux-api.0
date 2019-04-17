From: Aubrey Li <aubrey.li@linux.intel.com>
Subject: [PATCH v16 1/3] /proc/pid/status: Add support for architecture specific output
Date: Wed, 17 Apr 2019 18:18:38 +0800
Message-ID: <20190417101840.2926-1-aubrey.li@linux.intel.com>
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
 fs/proc/array.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/proc/array.c b/fs/proc/array.c
index 2edbb657f859..a6b394402ea2 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -96,6 +96,14 @@
 #include <asm/processor.h>
 #include "internal.h"
 
+/*
+ * Add support for architecture specific output in /proc/pid/status.
+ * arch_proc_pid_status() must be defined in asm/processor.h
+ */
+#ifndef	arch_proc_pid_status
+#define	arch_proc_pid_status(m, task)
+#endif
+
 void proc_task_name(struct seq_file *m, struct task_struct *p, bool escape)
 {
 	char *buf;
@@ -424,6 +432,7 @@ int proc_pid_status(struct seq_file *m, struct pid_namespace *ns,
 	task_cpus_allowed(m, task);
 	cpuset_task_status_allowed(m, task);
 	task_context_switch_counts(m, task);
+	arch_proc_pid_status(m, task);
 	return 0;
 }
 
-- 
2.21.0
