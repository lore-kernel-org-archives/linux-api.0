From: Thomas Garnier <thgarnie@google.com>
Subject: [PATCH v5 3/4] arm/syscalls: Specific usage of verify_pre_usermode_state
Date: Thu, 23 Mar 2017 10:25:14 -0700
Message-ID: <20170323172515.27950-3-thgarnie@google.com>
References: <20170323172515.27950-1-thgarnie@google.com>
Return-path: <kernel-hardening-return-7085-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <20170323172515.27950-1-thgarnie@google.com>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, David Howells <dhowells@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Dave Hansen <dave.hansen@intel.com>, Al Viro <viro@zeniv.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, =?UTF-8?q?Ren=C3=A9=20Nyffenegger?= <mail@renenyffenegger.ch>, Thomas Garnier <thgarnie@google.com>, Andrew Morton <akpm@linux-foundation.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Ingo Molnar <mingo@kernel.org>, Oleg Nesterov <oleg@redhat.com>, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, Stephen Smalley <sds@tycho.nsa.gov>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Rik van Riel <riel@redhat.com>, Kees Cook <keescook@chromium.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Borislav Petkov <bp@a>
Cc: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, x86@kernel.org, linux-arm-kernel@lists.infradead.org, kernel-hardening@lists.openwall.com
List-Id: linux-api@vger.kernel.org

Implement specific usage of verify_pre_usermode_state for user-mode
returns for arm.
---
Based on next-20170322
---
 arch/arm/Kconfig               |  1 +
 arch/arm/kernel/entry-common.S | 16 +++++++++++++++-
 2 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index fcbc5ef1ec69..10c6dc3dfff9 100644
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
diff --git a/arch/arm/kernel/entry-common.S b/arch/arm/kernel/entry-common.S
index eb5cd77bf1d8..88c72c4e44ad 100644
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
@@ -125,6 +133,12 @@ ENTRY(ret_from_fork)
 	b	ret_slow_syscall
 ENDPROC(ret_from_fork)
 
+addr_limit_fail:
+	stmfd	sp!, {r0, lr}
+	bl	asm_verify_pre_usermode_state
+	ldmfd	sp!, {r0, lr}
+	ret     lr
+
 /*=============================================================================
  * SWI handler
  *-----------------------------------------------------------------------------
-- 
2.12.1.500.gab5fba24ee-goog
