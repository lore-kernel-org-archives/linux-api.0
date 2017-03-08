From: Thomas Garnier <thgarnie@google.com>
Subject: [PATCH v1 2/4] x86/syscalls: Specific usage of verify_pre_usermode_state
Date: Wed,  8 Mar 2017 13:38:42 -0800
Message-ID: <20170308213844.131877-2-thgarnie@google.com>
References: <20170308213844.131877-1-thgarnie@google.com>
Return-path: <kernel-hardening-return-6931-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <20170308213844.131877-1-thgarnie@google.com>
To: Arnd Bergmann <arnd@arndb.de>, David Howells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, Dave Hansen <dave.hansen@intel.com>, Thomas Garnier <thgarnie@google.com>, =?UTF-8?q?Ren=C3=A9=20Nyffenegger?= <mail@renenyffenegger.ch>, Andrew Morton <akpm@linux-foundation.org>, Kees Cook <keescook@chromium.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Petr Mladek <pmladek@suse.com>, Andy Lutomirski <luto@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Nicolas Pitre <nicolas.pitre@linaro.org>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Helge Deller <deller@gmx.de>, Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@kernel.org>, John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@redhat.com>, Stanislav Kinsburskiy <skinsbursky@virtuozzo.com>
Cc: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org, linux-arm-kernel@lists.infradead.org, kernel-hardening@lists.openwall.com
List-Id: linux-api@vger.kernel.org

Implement specific usage of verify_pre_usermode_state for user-mode
returns for x86.
---
Based on next-20170308
---
 arch/x86/Kconfig          | 1 +
 arch/x86/entry/common.c   | 3 +++
 arch/x86/entry/entry_64.S | 6 ++++++
 3 files changed, 10 insertions(+)

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
index d2b2a2948ffe..795c31eebd09 100644
--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -201,6 +201,7 @@ entry_SYSCALL_64_fastpath:
 	 * It might end up jumping to the slow path.  If it jumps, RAX
 	 * and all argument registers are clobbered.
 	 */
+
 	call	*sys_call_table(, %rax, 8)
 .Lentry_SYSCALL_64_after_fastpath_call:
 
@@ -218,6 +219,11 @@ entry_SYSCALL_64_fastpath:
 	testl	$_TIF_ALLWORK_MASK, TASK_TI_flags(%r11)
 	jnz	1f
 
+	/*
+	 * Check user-mode state on fast path return, the same check is done
+	 * under the slow path through syscall_return_slowpath.
+	 */
+	call	verify_pre_usermode_state
 	LOCKDEP_SYS_EXIT
 	TRACE_IRQS_ON		/* user mode is traced as IRQs on */
 	movq	RIP(%rsp), %rcx
-- 
2.12.0.246.ga2ecc84866-goog
