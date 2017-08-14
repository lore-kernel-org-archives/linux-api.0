From: Thomas Garnier <thgarnie@google.com>
Subject: [PATCH v3 3/4] arm/syscalls: Optimize address limit check
Date: Mon, 14 Aug 2017 14:37:31 -0700
Message-ID: <20170814213732.104301-3-thgarnie@google.com>
References: <20170814213732.104301-1-thgarnie@google.com>
Return-path: <kernel-hardening-return-9432-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <20170814213732.104301-1-thgarnie@google.com>
To: Al Viro <viro@zeniv.linux.org.uk>, Dave Hansen <dave.hansen@intel.com>, Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>, Thomas Garnier <thgarnie@google.com>, Yonghong Song <yhs@fb.com>, David Howells <dhowells@redhat.com>, Russell King <linux@armlinux.org.uk>, Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@amacapital.net>, Will Drewry <wad@chromium.org>, Dave Martin <Dave.Martin@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>
Cc: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kernel-hardening@lists.openwall.com
List-Id: linux-api@vger.kernel.org

Disable the generic address limit check in favor of an architecture
specific optimized implementation. The generic implementation using
pending work flags did not work well with ARM and alignment faults.

The address limit is checked on each syscall return path to user-mode
path as well as the irq user-mode return function. If the address limit
was changed, a function is called to report data corruption (stopping
the kernel or process based on configuration).

The address limit check has to be done before any pending work because
they can reset the address limit and the process is killed using a
SIGKILL signal. For example the lkdtm address limit check does not work
because the signal to kill the process will reset the user-mode address
limit.

Signed-off-by: Thomas Garnier <thgarnie@google.com>
---
 arch/arm/kernel/entry-common.S | 11 +++++++++++
 arch/arm/kernel/signal.c       |  7 +++++++
 2 files changed, 18 insertions(+)

diff --git a/arch/arm/kernel/entry-common.S b/arch/arm/kernel/entry-common.S
index 0b60adf4a5d9..99c908226065 100644
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
@@ -48,10 +49,14 @@ ret_fast_syscall:
  UNWIND(.fnstart	)
  UNWIND(.cantunwind	)
 	disable_irq_notrace			@ disable interrupts
+	ldr	r2, [tsk, #TI_ADDR_LIMIT]
+	cmp	r2, #TASK_SIZE
+	blne	addr_limit_check_failed
 	ldr	r1, [tsk, #TI_FLAGS]		@ re-check for syscall tracing
 	tst	r1, #_TIF_SYSCALL_WORK | _TIF_WORK_MASK
 	bne	fast_work_pending
 
+
 	/* perform architecture specific actions before user return */
 	arch_ret_to_user r1, lr
 
@@ -74,6 +79,9 @@ ret_fast_syscall:
  UNWIND(.cantunwind	)
 	str	r0, [sp, #S_R0 + S_OFF]!	@ save returned r0
 	disable_irq_notrace			@ disable interrupts
+	ldr	r2, [tsk, #TI_ADDR_LIMIT]
+	cmp	r2, #TASK_SIZE
+	blne	addr_limit_check_failed
 	ldr	r1, [tsk, #TI_FLAGS]		@ re-check for syscall tracing
 	tst	r1, #_TIF_SYSCALL_WORK | _TIF_WORK_MASK
 	beq	no_work_pending
@@ -106,6 +114,9 @@ ENTRY(ret_to_user)
 ret_slow_syscall:
 	disable_irq_notrace			@ disable interrupts
 ENTRY(ret_to_user_from_irq)
+	ldr	r2, [tsk, #TI_ADDR_LIMIT]
+	cmp	r2, #TASK_SIZE
+	blne	addr_limit_check_failed
 	ldr	r1, [tsk, #TI_FLAGS]
 	tst	r1, #_TIF_WORK_MASK
 	bne	slow_work_pending
diff --git a/arch/arm/kernel/signal.c b/arch/arm/kernel/signal.c
index 5814298ef0b7..b67ae12503f3 100644
--- a/arch/arm/kernel/signal.c
+++ b/arch/arm/kernel/signal.c
@@ -14,6 +14,7 @@
 #include <linux/uaccess.h>
 #include <linux/tracehook.h>
 #include <linux/uprobes.h>
+#include <linux/syscalls.h>
 
 #include <asm/elf.h>
 #include <asm/cacheflush.h>
@@ -673,3 +674,9 @@ struct page *get_signal_page(void)
 
 	return page;
 }
+
+/* Defer to generic check */
+asmlinkage void addr_limit_check_failed(void)
+{
+	addr_limit_user_check();
+}
-- 
2.14.1.480.gb18f417b89-goog
