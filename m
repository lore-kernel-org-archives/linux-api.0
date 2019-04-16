From: Aubrey Li <aubrey.li@linux.intel.com>
Subject: [PATCH v15 2/3] x86,/proc/pid/status: Add AVX-512 usage elapsed time
Date: Tue, 16 Apr 2019 14:32:49 +0800
Message-ID: <20190416063250.7514-2-aubrey.li@linux.intel.com>
References: <20190416063250.7514-1-aubrey.li@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190416063250.7514-1-aubrey.li@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: tglx@linutronix.de, mingo@redhat.com, peterz@infradead.org, hpa@zytor.com
Cc: ak@linux.intel.com, tim.c.chen@linux.intel.com, dave.hansen@intel.com, arjan@linux.intel.com, adobriyan@gmail.com, akpm@linux-foundation.org, aubrey.li@intel.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Aubrey Li <aubrey.li@linux.intel.com>
List-Id: linux-api@vger.kernel.org

AVX-512 components use could cause core turbo frequency drop. So
it's useful to expose AVX-512 usage elapsed time as a heuristic hint
for the user space job scheduler to cluster the AVX-512 using tasks
together.

Tensorflow example:
$ while [ 1 ]; do cat /proc/tid/status | grep AVX; sleep 1; done
AVX512_elapsed_ms:      4
AVX512_elapsed_ms:      8
AVX512_elapsed_ms:      4

This means that 4 milliseconds have elapsed since the AVX512 usage
of tensorflow task was detected when the task was scheduled out.

Or:
$ cat /proc/tid/status | grep AVX512_elapsed_ms
AVX512_elapsed_ms:      -1

The number '-1' indicates that no AVX512 usage recorded before
thus the task unlikely has frequency drop issue.

User space tools may want to further check by:

$ perf stat --pid <pid> -e core_power.lvl2_turbo_license -- sleep 1

 Performance counter stats for process id '3558':

     3,251,565,961      core_power.lvl2_turbo_license

       1.004031387 seconds time elapsed

Non-zero counter value confirms that the task causes frequency drop.

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
 arch/x86/include/asm/processor.h |  4 +++
 arch/x86/kernel/fpu/xstate.c     | 42 ++++++++++++++++++++++++++++++++
 2 files changed, 46 insertions(+)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 2bb3a648fc12..5a7271ab78d8 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -991,4 +991,8 @@ enum l1tf_mitigations {
 
 extern enum l1tf_mitigations l1tf_mitigation;
 
+/* Add support for architecture specific output in /proc/pid/status */
+void arch_proc_pid_status(struct seq_file *m, struct task_struct *task);
+#define arch_proc_pid_status arch_proc_pid_status
+
 #endif /* _ASM_X86_PROCESSOR_H */
diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
index d7432c2b1051..5e55ed9584ab 100644
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -7,6 +7,8 @@
 #include <linux/cpu.h>
 #include <linux/mman.h>
 #include <linux/pkeys.h>
+#include <linux/seq_file.h>
+#include <linux/proc_fs.h>
 
 #include <asm/fpu/api.h>
 #include <asm/fpu/internal.h>
@@ -1243,3 +1245,43 @@ int copy_user_to_xstate(struct xregs_state *xsave, const void __user *ubuf)
 
 	return 0;
 }
+
+/*
+ * Report the amount of time elapsed in millisecond since last AVX512
+ * use in the task.
+ */
+static void avx512_status(struct seq_file *m, struct task_struct *task)
+{
+	unsigned long timestamp = READ_ONCE(task->thread.fpu.avx512_timestamp);
+	long delta;
+
+	if (!timestamp) {
+		/*
+		 * Report -1 if no AVX512 usage
+		 */
+		delta = -1;
+	} else {
+		delta = (long)(jiffies - timestamp);
+		/*
+		 * Cap to LONG_MAX if time difference > LONG_MAX
+		 */
+		if (delta < 0)
+			delta = LONG_MAX;
+		delta = jiffies_to_msecs(delta);
+	}
+
+	seq_put_decimal_ll(m, "AVX512_elapsed_ms:\t", delta);
+	seq_putc(m, '\n');
+}
+
+/*
+ * Report architecture specific information
+ */
+void arch_proc_pid_status(struct seq_file *m, struct task_struct *task)
+{
+	/*
+	 * Report AVX512 state if the processor and build option supported.
+	 */
+	if (cpu_feature_enabled(X86_FEATURE_AVX512F))
+		avx512_status(m, task);
+}
-- 
2.21.0
