From: Thomas Garnier <thgarnie@google.com>
Subject: [PATCH v2 2/4] x86/syscalls: Specific usage of verify_pre_usermode_state
Date: Wed,  8 Mar 2017 17:24:54 -0800
Message-ID: <20170309012456.5631-2-thgarnie@google.com>
References: <20170309012456.5631-1-thgarnie@google.com>
Return-path: <kernel-hardening-return-6944-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <20170309012456.5631-1-thgarnie@google.com>
To: David Howells <dhowells@redhat.com>, Dave Hansen <dave.hansen@intel.com>, Arnd Bergmann <arnd@arndb.de>, Al Viro <viro@zeniv.linux.org.uk>, =?UTF-8?q?Ren=C3=A9=20Nyffenegger?= <mail@renenyffenegger.ch>, Thomas Garnier <thgarnie@google.com>, Andrew Morton <akpm@linux-foundation.org>, Kees Cook <keescook@chromium.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, "David S . Miller" <davem@davemloft.net>, Andy Lutomirski <luto@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Nicolas Pitre <nicolas.pitre@linaro.org>, Petr Mladek <pmladek@suse.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Helge Deller <deller@gmx.de>, Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@kernel.org>, Oleg Nesterov <oleg@redhat.com>, John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Pavel
Cc: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org, linux-arm-kernel@lists.infradead.org, kernel-hardening@lists.openwall.com
List-Id: linux-api@vger.kernel.org

Implement specific usage of verify_pre_usermode_state for user-mode
returns for x86.
---
Based on next-20170308
---
 arch/x86/Kconfig                        |  1 +
 arch/x86/entry/common.c                 |  3 +++
 arch/x86/entry/entry_64.S               | 19 +++++++++++++++++++
 arch/x86/include/asm/pgtable_64_types.h | 11 +++++++++++
 arch/x86/include/asm/processor.h        | 11 -----------
 5 files changed, 34 insertions(+), 11 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 005df7c825f5..6d48e18e6f09 100644
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
index 370c42c7f046..525edbb77f03 100644
--- a/arch/x86/entry/common.c
+++ b/arch/x86/entry/common.c
@@ -22,6 +22,7 @@
 #include <linux/context_tracking.h>
 #include <linux/user-return-notifier.h>
 #include <linux/uprobes.h>
+#include <linux/syscalls.h>
 
 #include <asm/desc.h>
 #include <asm/traps.h>
@@ -180,6 +181,8 @@ __visible inline void prepare_exit_to_usermode(struct pt_regs *regs)
 	struct thread_info *ti = current_thread_info();
 	u32 cached_flags;
 
+	verify_pre_usermode_state();
+
 	if (IS_ENABLED(CONFIG_PROVE_LOCKING) && WARN_ON(!irqs_disabled()))
 		local_irq_disable();
 
diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
index d2b2a2948ffe..b3527d31b91b 100644
--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -96,6 +96,19 @@ ENDPROC(native_usergs_sysret64)
 # define TRACE_IRQS_IRETQ_DEBUG			TRACE_IRQS_IRETQ
 #endif
 
+#ifdef CONFIG_BUG_ON_DATA_CORRUPTION
+.macro VERIFY_PRE_USERMODE_STATE
+	call	verify_pre_usermode_state
+.endm
+#else
+/* Similar to set_fs(USER_DS) in verify_pre_usermode_state without a warning. */
+.macro VERIFY_PRE_USERMODE_STATE
+	movq	PER_CPU_VAR(current_task), %rax
+	movq	$TASK_SIZE_MAX, %rcx
+	movq	%rcx, TASK_addr_limit(%rax)
+.endm
+#endif
+
 /*
  * 64-bit SYSCALL instruction entry. Up to 6 arguments in registers.
  *
@@ -201,6 +214,7 @@ entry_SYSCALL_64_fastpath:
 	 * It might end up jumping to the slow path.  If it jumps, RAX
 	 * and all argument registers are clobbered.
 	 */
+
 	call	*sys_call_table(, %rax, 8)
 .Lentry_SYSCALL_64_after_fastpath_call:
 
@@ -218,6 +232,11 @@ entry_SYSCALL_64_fastpath:
 	testl	$_TIF_ALLWORK_MASK, TASK_TI_flags(%r11)
 	jnz	1f
 
+	/*
+	 * Check user-mode state on fast path return, the same check is done
+	 * under the slow path through syscall_return_slowpath.
+	 */
+	VERIFY_PRE_USERMODE_STATE
 	LOCKDEP_SYS_EXIT
 	TRACE_IRQS_ON		/* user mode is traced as IRQs on */
 	movq	RIP(%rsp), %rcx
diff --git a/arch/x86/include/asm/pgtable_64_types.h b/arch/x86/include/asm/pgtable_64_types.h
index 3a264200c62f..0fbbb79d058c 100644
--- a/arch/x86/include/asm/pgtable_64_types.h
+++ b/arch/x86/include/asm/pgtable_64_types.h
@@ -76,4 +76,15 @@ typedef struct { pteval_t pte; } pte_t;
 
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
index f385eca5407a..9bc99d37133e 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -829,17 +829,6 @@ static inline void spin_lock_prefetch(const void *x)
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
2.12.0.246.ga2ecc84866-goog
