From: Thomas Garnier <thgarnie@google.com>
Subject: [PATCH v3 3/4] arm/syscalls: Specific usage of verify_pre_usermode_state
Date: Fri, 10 Mar 2017 16:05:00 -0800
Message-ID: <20170311000501.46607-3-thgarnie@google.com>
References: <20170311000501.46607-1-thgarnie@google.com>
Return-path: <kernel-hardening-return-7014-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <20170311000501.46607-1-thgarnie@google.com>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, David Howells <dhowells@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Al Viro <viro@zeniv.linux.org.uk>, Dave Hansen <dave.hansen@intel.com>, Thomas Garnier <thgarnie@google.com>, =?UTF-8?q?Ren=C3=A9=20Nyffenegger?= <mail@renenyffenegger.ch>, Andrew Morton <akpm@linux-foundation.org>, Kees Cook <keescook@chromium.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Andy Lutomirski <luto@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Nicolas Pitre <nicolas.pitre@linaro.org>, Petr Mladek <pmladek@suse.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Helge Deller <deller@gmx.de>, Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@kernel.org>, John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutron>
Cc: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, x86@kernel.org, linux-arm-kernel@lists.infradead.org, kernel-hardening@lists.openwall.com
List-Id: linux-api@vger.kernel.org

Implement specific usage of verify_pre_usermode_state for user-mode
returns for arm.
---
Based on next-20170308
---
 arch/arm/Kconfig               |  1 +
 arch/arm/include/asm/domain.h  |  3 +++
 arch/arm/kernel/entry-common.S | 32 +++++++++++++++++++++++++++++++-
 3 files changed, 35 insertions(+), 1 deletion(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 0d4e71b42c77..704fd8f197fa 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -12,6 +12,7 @@ config ARM
 	select ARCH_HAVE_CUSTOM_GPIO_H
 	select ARCH_HAS_GCOV_PROFILE_ALL
 	select ARCH_MIGHT_HAVE_PC_PARPORT
+	select ARCH_NO_SYSCALL_VERIFY_PRE_USERMODE_STATE
 	select ARCH_OPTIONAL_KERNEL_RWX if ARCH_HAS_STRICT_KERNEL_RWX
 	select ARCH_OPTIONAL_KERNEL_RWX_DEFAULT if CPU_V7
 	select ARCH_SUPPORTS_ATOMIC_RMW
diff --git a/arch/arm/include/asm/domain.h b/arch/arm/include/asm/domain.h
index 99d9f630d6b6..fd1cd24ca9fe 100644
--- a/arch/arm/include/asm/domain.h
+++ b/arch/arm/include/asm/domain.h
@@ -58,6 +58,9 @@
 #define domain_mask(dom)	((3) << (2 * (dom)))
 #define domain_val(dom,type)	((type) << (2 * (dom)))
 
+#define DOMAIN_KERNEL_MASK	domain_mask(DOMAIN_KERNEL)
+#define DOMAIN_CLIENT_VALUE	domain_val(DOMAIN_KERNEL, DOMAIN_CLIENT)
+
 #ifdef CONFIG_CPU_SW_DOMAIN_PAN
 #define DACR_INIT \
 	(domain_val(DOMAIN_USER, DOMAIN_NOACCESS) | \
diff --git a/arch/arm/kernel/entry-common.S b/arch/arm/kernel/entry-common.S
index eb5cd77bf1d8..8d9bfe9ff313 100644
--- a/arch/arm/kernel/entry-common.S
+++ b/arch/arm/kernel/entry-common.S
@@ -12,6 +12,7 @@
 #include <asm/unistd.h>
 #include <asm/ftrace.h>
 #include <asm/unwind.h>
+#include <asm/memory.h>
 #ifdef CONFIG_AEABI
 #include <asm/unistd-oabi.h>
 #endif
@@ -27,7 +28,6 @@
 
 #include "entry-header.S"
 
-
 	.align	5
 #if !(IS_ENABLED(CONFIG_TRACE_IRQFLAGS) || IS_ENABLED(CONFIG_CONTEXT_TRACKING))
 /*
@@ -40,9 +40,12 @@ ret_fast_syscall:
  UNWIND(.fnstart	)
  UNWIND(.cantunwind	)
 	disable_irq_notrace			@ disable interrupts
+	ldr	r2, [tsk, #TI_ADDR_LIMIT]
 	ldr	r1, [tsk, #TI_FLAGS]		@ re-check for syscall tracing
 	tst	r1, #_TIF_SYSCALL_WORK | _TIF_WORK_MASK
 	bne	fast_work_pending
+	cmp	r2, #TASK_SIZE
+	blne	addr_limit_fail
 
 	/* perform architecture specific actions before user return */
 	arch_ret_to_user r1, lr
@@ -66,6 +69,7 @@ ret_fast_syscall:
  UNWIND(.cantunwind	)
 	str	r0, [sp, #S_R0 + S_OFF]!	@ save returned r0
 	disable_irq_notrace			@ disable interrupts
+	ldr	r2, [tsk, #TI_ADDR_LIMIT]
 	ldr	r1, [tsk, #TI_FLAGS]		@ re-check for syscall tracing
 	tst	r1, #_TIF_SYSCALL_WORK | _TIF_WORK_MASK
 	beq	no_work_pending
@@ -82,6 +86,7 @@ slow_work_pending:
 	mov	r2, why				@ 'syscall'
 	bl	do_work_pending
 	cmp	r0, #0
+	ldreq   r2, [tsk, #TI_ADDR_LIMIT]
 	beq	no_work_pending
 	movlt	scno, #(__NR_restart_syscall - __NR_SYSCALL_BASE)
 	ldmia	sp, {r0 - r6}			@ have to reload r0 - r6
@@ -99,9 +104,12 @@ ret_slow_syscall:
 	disable_irq_notrace			@ disable interrupts
 ENTRY(ret_to_user_from_irq)
 	ldr	r1, [tsk, #TI_FLAGS]
+	ldr	r2, [tsk, #TI_ADDR_LIMIT]
 	tst	r1, #_TIF_WORK_MASK
 	bne	slow_work_pending
 no_work_pending:
+	cmp	r2, #TASK_SIZE
+	blne	addr_limit_fail
 	asm_trace_hardirqs_on save = 0
 
 	/* perform architecture specific actions before user return */
@@ -125,6 +133,28 @@ ENTRY(ret_from_fork)
 	b	ret_slow_syscall
 ENDPROC(ret_from_fork)
 
+addr_limit_fail:
+#ifdef CONFIG_BUG_ON_DATA_CORRUPTION
+	stmfd	sp!, {r0, lr}
+	bl	verify_pre_usermode_state
+	ldmfd	sp!, {r0, lr}
+#else
+	/*
+	 * Similar to set_fs(USER_DS) in verify_pre_usermode_state without a
+	 * warning.
+	 */
+	mov	r2, #TASK_SIZE
+	str	r2, [tsk, #TI_ADDR_LIMIT]
+#ifdef CONFIG_CPU_USE_DOMAINS
+	/* Switch domain like modify_domain(DOMAIN_KERNEL, DOMAIN_CLIENT) */
+	mrc	p15, 0, r2, c3, c0, 0		@ Get domain register
+	bic	r2, r2, #DOMAIN_KERNEL_MASK	@ Clear the domain part
+	orr	r2, r2, #DOMAIN_CLIENT_VALUE	@ Enforce DOMAIN_CLIENT
+	mcr	p15, 0, r2, c3, c0, 0		@ Set domain register
+#endif
+#endif
+	ret     lr
+
 /*=============================================================================
  * SWI handler
  *-----------------------------------------------------------------------------
-- 
2.12.0.246.ga2ecc84866-goog
