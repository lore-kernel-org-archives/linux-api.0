From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [RFC PATCH for 4.21 07/16] cpu_opv: limit amount of virtual address space used by cpu_opv
Date: Wed, 10 Oct 2018 15:19:27 -0400
Message-ID: <20181010191936.7495-8-mathieu.desnoyers@efficios.com>
References: <20181010191936.7495-1-mathieu.desnoyers@efficios.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181010191936.7495-1-mathieu.desnoyers@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, Steven Rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Joel Fernandes <joelaf@google.com>, Mathieu Desnoyers <mathieu.desnoyers@ef>
List-Id: linux-api@vger.kernel.org

Introduce sysctl cpu_opv_va_max_bytes, which limits the amount of
virtual address space that can be used by cpu_opv.

Its default value is the maximum amount of virtual address space which
can be used by a single cpu_opv system call (256 kB on x86).

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Paul Turner <pjt@google.com>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Andy Lutomirski <luto@amacapital.net>
CC: Andi Kleen <andi@firstfloor.org>
CC: Dave Watson <davejwatson@fb.com>
CC: Chris Lameter <cl@linux.com>
CC: Ingo Molnar <mingo@redhat.com>
CC: "H. Peter Anvin" <hpa@zytor.com>
CC: Ben Maurer <bmaurer@fb.com>
CC: Steven Rostedt <rostedt@goodmis.org>
CC: Josh Triplett <josh@joshtriplett.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Russell King <linux@arm.linux.org.uk>
CC: Catalin Marinas <catalin.marinas@arm.com>
CC: Will Deacon <will.deacon@arm.com>
CC: Michael Kerrisk <mtk.manpages@gmail.com>
CC: Boqun Feng <boqun.feng@gmail.com>
CC: linux-api@vger.kernel.org
---
 kernel/cpu_opv.c | 75 +++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 kernel/sysctl.c  | 15 ++++++++++++
 2 files changed, 89 insertions(+), 1 deletion(-)

diff --git a/kernel/cpu_opv.c b/kernel/cpu_opv.c
index c4e4040bb5ff..db144b71d51a 100644
--- a/kernel/cpu_opv.c
+++ b/kernel/cpu_opv.c
@@ -30,6 +30,7 @@
 #include <linux/pagemap.h>
 #include <linux/mm.h>
 #include <linux/vmalloc.h>
+#include <linux/atomic.h>
 #include <asm/ptrace.h>
 #include <asm/byteorder.h>
 #include <asm/cacheflush.h>
@@ -49,6 +50,16 @@
 /* Maximum number of virtual addresses per op. */
 #define CPU_OP_VEC_MAX_ADDR		(2 * CPU_OP_VEC_LEN_MAX)
 
+/* Maximum address range size (aligned on SHMLBA) per virtual address. */
+#define CPU_OP_RANGE_PER_ADDR_MAX	(2 * SHMLBA)
+
+/*
+ * Minimum value for sysctl_cpu_opv_va_max_bytes is the maximum virtual memory
+ * space needed by one cpu_opv system call.
+ */
+#define CPU_OPV_VA_MAX_BYTES_MIN	\
+		(CPU_OP_VEC_MAX_ADDR * CPU_OP_RANGE_PER_ADDR_MAX)
+
 union op_fn_data {
 	uint8_t _u8;
 	uint16_t _u16;
@@ -81,6 +92,15 @@ typedef int (*op_fn_t)(union op_fn_data *data, uint64_t v, uint32_t len);
  */
 static DEFINE_MUTEX(cpu_opv_offline_lock);
 
+/* Maximum virtual address space which can be used by cpu_opv. */
+int sysctl_cpu_opv_va_max_bytes __read_mostly;
+int sysctl_cpu_opv_va_max_bytes_min;
+
+static atomic_t cpu_opv_va_allocated_bytes;
+
+/* Waitqueue for cpu_opv blocked on virtual address space reservation. */
+static DECLARE_WAIT_QUEUE_HEAD(cpu_opv_va_wait);
+
 /*
  * The cpu_opv system call executes a vector of operations on behalf of
  * user-space on a specific CPU with preemption disabled. It is inspired
@@ -546,6 +566,43 @@ static int cpu_opv_pin_pages_op(struct cpu_op *op,
 	return 0;
 }
 
+/*
+ * Approximate the amount of virtual address space required per
+ * vaddr to a worse-case of CPU_OP_RANGE_PER_ADDR_MAX.
+ */
+static int cpu_opv_reserve_va(int nr_vaddr, int *reserved_va)
+{
+	int nr_bytes = nr_vaddr * CPU_OP_RANGE_PER_ADDR_MAX;
+	int old_bytes, new_bytes;
+
+	WARN_ON_ONCE(*reserved_va != 0);
+	if (nr_bytes > sysctl_cpu_opv_va_max_bytes) {
+		WARN_ON_ONCE(1);
+		return -EINVAL;
+	}
+	do {
+		wait_event(cpu_opv_va_wait,
+			(old_bytes = atomic_read(&cpu_opv_va_allocated_bytes)) +
+			nr_bytes <= sysctl_cpu_opv_va_max_bytes);
+		new_bytes = old_bytes + nr_bytes;
+	} while (atomic_cmpxchg(&cpu_opv_va_allocated_bytes,
+		 old_bytes, new_bytes) != old_bytes);
+
+	*reserved_va = nr_bytes;
+	return 0;
+}
+
+static void cpu_opv_unreserve_va(int *reserved_va)
+{
+	int nr_bytes = *reserved_va;
+
+	if (!nr_bytes)
+		return;
+	atomic_sub(nr_bytes, &cpu_opv_va_allocated_bytes);
+	wake_up(&cpu_opv_va_wait);
+	*reserved_va = 0;
+}
+
 static int cpu_opv_pin_pages(struct cpu_op *cpuop, int cpuopcnt,
 			     struct cpu_opv_vaddr *vaddr_ptrs)
 {
@@ -1057,7 +1114,7 @@ SYSCALL_DEFINE4(cpu_opv, struct cpu_op __user *, ucpuopv, int, cpuopcnt,
 		.nr_vaddr = 0,
 		.is_kmalloc = false,
 	};
-	int ret, i, nr_vaddr = 0;
+	int ret, i, nr_vaddr = 0, reserved_va = 0;
 	bool retry = false;
 
 	if (unlikely(flags & ~CPU_OP_NR_FLAG))
@@ -1082,6 +1139,9 @@ SYSCALL_DEFINE4(cpu_opv, struct cpu_op __user *, ucpuopv, int, cpuopcnt,
 		vaddr_ptrs.is_kmalloc = true;
 	}
 again:
+	ret = cpu_opv_reserve_va(nr_vaddr, &reserved_va);
+	if (ret)
+		goto end;
 	ret = cpu_opv_pin_pages(cpuopv, cpuopcnt, &vaddr_ptrs);
 	if (ret)
 		goto end;
@@ -1106,6 +1166,7 @@ SYSCALL_DEFINE4(cpu_opv, struct cpu_op __user *, ucpuopv, int, cpuopcnt,
 	 */
 	if (vaddr_ptrs.nr_vaddr)
 		vm_unmap_aliases();
+	cpu_opv_unreserve_va(&reserved_va);
 	if (retry) {
 		retry = false;
 		vaddr_ptrs.nr_vaddr = 0;
@@ -1115,3 +1176,15 @@ SYSCALL_DEFINE4(cpu_opv, struct cpu_op __user *, ucpuopv, int, cpuopcnt,
 		kfree(vaddr_ptrs.addr);
 	return ret;
 }
+
+/*
+ * Dynamic initialization is required on sparc because SHMLBA is not a
+ * constant.
+ */
+static int __init cpu_opv_init(void)
+{
+	sysctl_cpu_opv_va_max_bytes = CPU_OPV_VA_MAX_BYTES_MIN;
+	sysctl_cpu_opv_va_max_bytes_min = CPU_OPV_VA_MAX_BYTES_MIN;
+	return 0;
+}
+core_initcall(cpu_opv_init);
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index cc02050fd0c4..eb34c6be2aa4 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -175,6 +175,11 @@ extern int unaligned_dump_stack;
 extern int no_unaligned_warning;
 #endif
 
+#ifdef CONFIG_CPU_OPV
+extern int sysctl_cpu_opv_va_max_bytes;
+extern int sysctl_cpu_opv_va_max_bytes_min;
+#endif
+
 #ifdef CONFIG_PROC_SYSCTL
 
 /**
@@ -1233,6 +1238,16 @@ static struct ctl_table kern_table[] = {
 		.extra2		= &one,
 	},
 #endif
+#ifdef CONFIG_CPU_OPV
+	{
+		.procname	= "cpu_opv_va_max_bytes",
+		.data		= &sysctl_cpu_opv_va_max_bytes,
+		.maxlen		= sizeof(sysctl_cpu_opv_va_max_bytes),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &sysctl_cpu_opv_va_max_bytes_min,
+	},
+#endif
 	{ }
 };
 
-- 
2.11.0
