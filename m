From: Kees Cook <keescook@chromium.org>
Subject: [PATCH 3/4] arm/syscalls: Optimize address limit check
Date: Thu,  7 Sep 2017 08:30:46 -0700
Message-ID: <1504798247-48833-4-git-send-email-keescook@chromium.org>
References: <1504798247-48833-1-git-send-email-keescook@chromium.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1504798247-48833-1-git-send-email-keescook@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>
Cc: Kees Cook <keescook@chromium.org>, Thomas Garnier <thgarnie@google.com>, Thomas Gleixner <tglx@linutronix.de>, Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Andy Lutomirski <luto@amacapital.net>, Will Drewry <wad@chromium.org>, Al Viro <viro@zeniv.linux.org.uk>, Dave Martin <Dave.Martin@arm.com>, Pratyush Anand <panand@redhat.com>, Dave Hansen <dave.hansen@intel.com>, Arnd Bergmann <arnd@arndb.de>, David Howells <dhowells@redhat.com>, Yonghong Song <yhs@fb.com>, linux-arm-kernel@lists.infradead.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

From: Thomas Garnier <thgarnie@google.com>

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
Reviewed-by: Kees Cook <keescook@chromium.org>
Tested-by: Kees Cook <keescook@chromium.org>
Tested-by: Leonard Crestez <leonard.crestez@nxp.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/arm/kernel/entry-common.S | 11 +++++++++++
 arch/arm/kernel/signal.c       |  7 +++++++
 2 files changed, 18 insertions(+)

diff --git a/arch/arm/kernel/entry-common.S b/arch/arm/kernel/entry-common.S
index eb5cd77bf1d8..126fafc725bc 100644
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
@@ -40,10 +41,14 @@ ret_fast_syscall:
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
 
@@ -66,6 +71,9 @@ ret_fast_syscall:
  UNWIND(.cantunwind	)
 	str	r0, [sp, #S_R0 + S_OFF]!	@ save returned r0
 	disable_irq_notrace			@ disable interrupts
+	ldr	r2, [tsk, #TI_ADDR_LIMIT]
+	cmp	r2, #TASK_SIZE
+	blne	addr_limit_check_failed
 	ldr	r1, [tsk, #TI_FLAGS]		@ re-check for syscall tracing
 	tst	r1, #_TIF_SYSCALL_WORK | _TIF_WORK_MASK
 	beq	no_work_pending
@@ -98,6 +106,9 @@ ENTRY(ret_to_user)
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
2.7.4
