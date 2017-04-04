From: Thomas Garnier <thgarnie-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v6 2/4] x86/syscalls: Specific usage of verify_pre_usermode_state
Date: Tue,  4 Apr 2017 10:47:25 -0700
Message-ID: <20170404174727.35478-2-thgarnie@google.com>
References: <20170404174727.35478-1-thgarnie@google.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170404174727.35478-1-thgarnie-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Martin Schwidefsky <schwidefsky-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Heiko Carstens <heiko.carstens-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Thomas Garnier <thgarnie-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, =?UTF-8?q?Ren=C3=A9=20Nyffenegger?= <mail-gLCNRsNSrVdVZEhyV+6z5nIPMjoJpjVV@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Paul E . McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Stephen Smalley <sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>, Pavel Tikhomirov <ptikhomirov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, kernel-hardening-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org
List-Id: linux-api@vger.kernel.org

Implement specific usage of verify_pre_usermode_state for user-mode
returns for x86.

Signed-off-by: Thomas Garnier <thgarnie-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
Based on next-20170404
---
 arch/x86/Kconfig                        |  1 +
 arch/x86/entry/common.c                 |  3 +++
 arch/x86/entry/entry_64.S               |  8 ++++++++
 arch/x86/include/asm/pgtable_64_types.h | 11 +++++++++++
 arch/x86/include/asm/processor.h        | 11 -----------
 5 files changed, 23 insertions(+), 11 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 9a5af1e1cd61..3d7eb9298f2d 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -63,6 +63,7 @@ config X86
 	select ARCH_MIGHT_HAVE_ACPI_PDC		if ACPI
 	select ARCH_MIGHT_HAVE_PC_PARPORT
 	select ARCH_MIGHT_HAVE_PC_SERIO
+	select ARCH_NO_SYSCALL_VERIFY_PRE_USERMODE_STATE
 	select ARCH_SUPPORTS_ATOMIC_RMW
 	select ARCH_SUPPORTS_DEFERRED_STRUCT_PAGE_INIT
 	select ARCH_SUPPORTS_NUMA_BALANCING	if X86_64
diff --git a/arch/x86/entry/common.c b/arch/x86/entry/common.c
index cdefcfdd9e63..76ef050255c9 100644
--- a/arch/x86/entry/common.c
+++ b/arch/x86/entry/common.c
@@ -23,6 +23,7 @@
 #include <linux/user-return-notifier.h>
 #include <linux/uprobes.h>
 #include <linux/livepatch.h>
+#include <linux/syscalls.h>
 
 #include <asm/desc.h>
 #include <asm/traps.h>
@@ -183,6 +184,8 @@ __visible inline void prepare_exit_to_usermode(struct pt_regs *regs)
 	struct thread_info *ti = current_thread_info();
 	u32 cached_flags;
 
+	verify_pre_usermode_state();
+
 	if (IS_ENABLED(CONFIG_PROVE_LOCKING) && WARN_ON(!irqs_disabled()))
 		local_irq_disable();
 
diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
index d2b2a2948ffe..c079b010205c 100644
--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -218,6 +218,14 @@ entry_SYSCALL_64_fastpath:
 	testl	$_TIF_ALLWORK_MASK, TASK_TI_flags(%r11)
 	jnz	1f
 
+	/*
+	 * If address limit is not based on user-mode, jump to slow path for
+	 * additional security checks.
+	 */
+	movq	$TASK_SIZE_MAX, %rcx
+	cmp	%rcx, TASK_addr_limit(%r11)
+	jnz	1f
+
 	LOCKDEP_SYS_EXIT
 	TRACE_IRQS_ON		/* user mode is traced as IRQs on */
 	movq	RIP(%rsp), %rcx
diff --git a/arch/x86/include/asm/pgtable_64_types.h b/arch/x86/include/asm/pgtable_64_types.h
index 516593e66bd6..12fa851c7fa8 100644
--- a/arch/x86/include/asm/pgtable_64_types.h
+++ b/arch/x86/include/asm/pgtable_64_types.h
@@ -78,4 +78,15 @@ typedef struct { pteval_t pte; } pte_t;
 
 #define EARLY_DYNAMIC_PAGE_TABLES	64
 
+/*
+ * User space process size. 47bits minus one guard page.  The guard
+ * page is necessary on Intel CPUs: if a SYSCALL instruction is at
+ * the highest possible canonical userspace address, then that
+ * syscall will enter the kernel with a non-canonical return
+ * address, and SYSRET will explode dangerously.  We avoid this
+ * particular problem by preventing anything from being mapped
+ * at the maximum canonical address.
+ */
+#define TASK_SIZE_MAX	((_AC(1, UL) << 47) - PAGE_SIZE)
+
 #endif /* _ASM_X86_PGTABLE_64_DEFS_H */
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 3cada998a402..e80822582d3e 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -825,17 +825,6 @@ static inline void spin_lock_prefetch(const void *x)
 #define KSTK_ESP(task)		(task_pt_regs(task)->sp)
 
 #else
-/*
- * User space process size. 47bits minus one guard page.  The guard
- * page is necessary on Intel CPUs: if a SYSCALL instruction is at
- * the highest possible canonical userspace address, then that
- * syscall will enter the kernel with a non-canonical return
- * address, and SYSRET will explode dangerously.  We avoid this
- * particular problem by preventing anything from being mapped
- * at the maximum canonical address.
- */
-#define TASK_SIZE_MAX	((1UL << 47) - PAGE_SIZE)
-
 /* This decides where the kernel will search for a free chunk of vm
  * space during mmap's.
  */
-- 
2.12.2.715.g7642488e1d-goog
