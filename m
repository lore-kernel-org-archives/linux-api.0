From: Thomas Garnier <thgarnie@google.com>
Subject: [PATCH v8 4/4] arm64/syscalls: Optimize address limit check
Date: Wed, 26 Apr 2017 11:34:25 -0700
Message-ID: <20170426183425.32158-4-thgarnie@google.com>
References: <20170426183425.32158-1-thgarnie@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170426183425.32158-1-thgarnie@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Dave Hansen <dave.hansen@intel.com>, Arnd Bergmann <arnd@arndb.de>, David Howells <dhowells@redhat.com>, =?UTF-8?q?Ren=C3=A9=20Nyffenegger?= <mail@renenyffenegger.ch>, Thomas Garnier <thgarnie@google.com>, Andrew Morton <akpm@linux-foundation.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Ingo Molnar <mingo@kernel.org>, "Eric W . Biederman" <ebiederm@xmission.com>, Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@redhat.com>, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Kees Cook <keescook@chromium.o>
Cc: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, x86@kernel.org, linux-arm-kernel@lists.infradead.org, kernel-hardening@lists.openwall.com
List-Id: linux-api@vger.kernel.org

Disable the generic address limit check in favor of an architecture
specific optimized implementation.

The address limit is checked on each syscall return path to user-mode.
If it was changed, a generic handler is called to stop the kernel on an
explicit check.

Signed-off-by: Thomas Garnier <thgarnie@google.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
---
Based on next-20170426
---
 arch/arm64/Kconfig        |  1 +
 arch/arm64/kernel/entry.S | 12 ++++++++++++
 2 files changed, 13 insertions(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 3dcd7ec69bca..fe9466d3bf94 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -25,6 +25,7 @@ config ARM64
 	select ARCH_WANT_COMPAT_IPC_PARSE_VERSION
 	select ARCH_WANT_FRAME_POINTERS
 	select ARCH_HAS_UBSAN_SANITIZE_ALL
+	select ADDR_LIMIT_CHECK
 	select ARM_AMBA
 	select ARM_ARCH_TIMER
 	select ARM_GIC
diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index 43512d4d7df2..c895c4402d32 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -744,6 +744,8 @@ ENDPROC(cpu_switch_to)
 ret_fast_syscall:
 	disable_irq				// disable interrupts
 	str	x0, [sp, #S_X0]			// returned x0
+	ldr	x2, [tsk, #TSK_TI_ADDR_LIMIT]	// check addr limit change
+	tbnz	x2, #63, addr_limit_fail
 	ldr	x1, [tsk, #TSK_TI_FLAGS]	// re-check for syscall tracing
 	and	x2, x1, #_TIF_SYSCALL_WORK
 	cbnz	x2, ret_fast_syscall_trace
@@ -771,6 +773,8 @@ work_pending:
  */
 ret_to_user:
 	disable_irq				// disable interrupts
+	ldr	x2, [tsk, #TSK_TI_ADDR_LIMIT]	// check addr limit change
+	tbnz	x2, #63, addr_limit_fail
 	ldr	x1, [tsk, #TSK_TI_FLAGS]
 	and	x2, x1, #_TIF_WORK_MASK
 	cbnz	x2, work_pending
@@ -780,6 +784,14 @@ finish_ret_to_user:
 ENDPROC(ret_to_user)
 
 /*
+ * Address limit was incorrect before returning in user-mode which could be
+ * used to elevate privileges. Call the generic handler to stop the kernel on
+ * the appropriate check. This function does not return.
+ */
+addr_limit_fail:
+	b	addr_limit_check_failed
+
+/*
  * This is how we return from a fork.
  */
 ENTRY(ret_from_fork)
-- 
2.13.0.rc0.306.g87b477812d-goog
