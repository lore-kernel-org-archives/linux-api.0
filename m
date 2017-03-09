From: Thomas Garnier <thgarnie@google.com>
Subject: [PATCH v2 3/4] arm/syscalls: Specific usage of verify_pre_usermode_state
Date: Wed,  8 Mar 2017 17:24:55 -0800
Message-ID: <20170309012456.5631-3-thgarnie@google.com>
References: <20170309012456.5631-1-thgarnie@google.com>
Return-path: <kernel-hardening-return-6945-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <20170309012456.5631-1-thgarnie@google.com>
To: David Howells <dhowells@redhat.com>, Dave Hansen <dave.hansen@intel.com>, Arnd Bergmann <arnd@arndb.de>, Al Viro <viro@zeniv.linux.org.uk>, =?UTF-8?q?Ren=C3=A9=20Nyffenegger?= <mail@renenyffenegger.ch>, Thomas Garnier <thgarnie@google.com>, Andrew Morton <akpm@linux-foundation.org>, Kees Cook <keescook@chromium.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, "David S . Miller" <davem@davemloft.net>, Andy Lutomirski <luto@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Nicolas Pitre <nicolas.pitre@linaro.org>, Petr Mladek <pmladek@suse.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Helge Deller <deller@gmx.de>, Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@kernel.org>, Oleg Nesterov <oleg@redhat.com>, John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Pavel
Cc: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org, linux-arm-kernel@lists.infradead.org, kernel-hardening@lists.openwall.com
List-Id: linux-api@vger.kernel.org

Implement specific usage of verify_pre_usermode_state for user-mode
returns for arm.
---
Based on next-20170308
---
 arch/arm/Kconfig               |  1 +
 arch/arm/kernel/entry-common.S | 21 +++++++++++++++++++++
 2 files changed, 22 insertions(+)

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
diff --git a/arch/arm/kernel/entry-common.S b/arch/arm/kernel/entry-common.S
index eb5cd77bf1d8..a2cdf3d7bcff 100644
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
@@ -27,6 +28,23 @@
 
 #include "entry-header.S"
 
+#ifdef CONFIG_BUG_ON_DATA_CORRUPTION
+.macro VERIFY_PRE_USERMODE_STATE
+#if !(IS_ENABLED(CONFIG_TRACE_IRQFLAGS) || IS_ENABLED(CONFIG_CONTEXT_TRACKING))
+	stmdb	sp!, {r0}
+	bl	verify_pre_usermode_state
+	ldmia 	sp!, {r0}
+#else
+	bl	verify_pre_usermode_state
+#endif
+.endm
+#else
+/* Similar to set_fs(USER_DS) in verify_pre_usermode_state without a warning. */
+.macro VERIFY_PRE_USERMODE_STATE
+	mov	r1, $TASK_SIZE
+	str	r1, [tsk, #TI_ADDR_LIMIT]
+.endm
+#endif
 
 	.align	5
 #if !(IS_ENABLED(CONFIG_TRACE_IRQFLAGS) || IS_ENABLED(CONFIG_CONTEXT_TRACKING))
@@ -39,6 +57,7 @@
 ret_fast_syscall:
  UNWIND(.fnstart	)
  UNWIND(.cantunwind	)
+	VERIFY_PRE_USERMODE_STATE
 	disable_irq_notrace			@ disable interrupts
 	ldr	r1, [tsk, #TI_FLAGS]		@ re-check for syscall tracing
 	tst	r1, #_TIF_SYSCALL_WORK | _TIF_WORK_MASK
@@ -65,6 +84,7 @@ ret_fast_syscall:
  UNWIND(.fnstart	)
  UNWIND(.cantunwind	)
 	str	r0, [sp, #S_R0 + S_OFF]!	@ save returned r0
+	VERIFY_PRE_USERMODE_STATE
 	disable_irq_notrace			@ disable interrupts
 	ldr	r1, [tsk, #TI_FLAGS]		@ re-check for syscall tracing
 	tst	r1, #_TIF_SYSCALL_WORK | _TIF_WORK_MASK
@@ -263,6 +283,7 @@ __sys_trace:
 
 __sys_trace_return:
 	str	r0, [sp, #S_R0 + S_OFF]!	@ save returned r0
+	VERIFY_PRE_USERMODE_STATE
 	mov	r0, sp
 	bl	syscall_trace_exit
 	b	ret_slow_syscall
-- 
2.12.0.246.ga2ecc84866-goog
