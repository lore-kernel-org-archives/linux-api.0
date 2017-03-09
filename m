From: Thomas Garnier <thgarnie@google.com>
Subject: [PATCH v2 4/4] arm64/syscalls: Specific usage of verify_pre_usermode_state
Date: Wed,  8 Mar 2017 17:24:56 -0800
Message-ID: <20170309012456.5631-4-thgarnie@google.com>
References: <20170309012456.5631-1-thgarnie@google.com>
Return-path: <kernel-hardening-return-6946-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <20170309012456.5631-1-thgarnie@google.com>
To: David Howells <dhowells@redhat.com>, Dave Hansen <dave.hansen@intel.com>, Arnd Bergmann <arnd@arndb.de>, Al Viro <viro@zeniv.linux.org.uk>, =?UTF-8?q?Ren=C3=A9=20Nyffenegger?= <mail@renenyffenegger.ch>, Thomas Garnier <thgarnie@google.com>, Andrew Morton <akpm@linux-foundation.org>, Kees Cook <keescook@chromium.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, "David S . Miller" <davem@davemloft.net>, Andy Lutomirski <luto@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Nicolas Pitre <nicolas.pitre@linaro.org>, Petr Mladek <pmladek@suse.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Helge Deller <deller@gmx.de>, Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@kernel.org>, Oleg Nesterov <oleg@redhat.com>, John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Pavel
Cc: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org, linux-arm-kernel@lists.infradead.org, kernel-hardening@lists.openwall.com
List-Id: linux-api@vger.kernel.org

Implement specific usage of verify_pre_usermode_state for user-mode
returns for arm64.
---
Based on next-20170308
---
 arch/arm64/Kconfig        |  1 +
 arch/arm64/kernel/entry.S | 15 +++++++++++++++
 2 files changed, 16 insertions(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 896eba61e5ed..da54774838d8 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -24,6 +24,7 @@ config ARM64
 	select ARCH_WANT_COMPAT_IPC_PARSE_VERSION
 	select ARCH_WANT_FRAME_POINTERS
 	select ARCH_HAS_UBSAN_SANITIZE_ALL
+	select ARCH_NO_SYSCALL_VERIFY_PRE_USERMODE_STATE
 	select ARM_AMBA
 	select ARM_ARCH_TIMER
 	select ARM_GIC
diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index 43512d4d7df2..eca392ae63e9 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -737,6 +737,19 @@ ENTRY(cpu_switch_to)
 	ret
 ENDPROC(cpu_switch_to)
 
+#ifdef CONFIG_BUG_ON_DATA_CORRUPTION
+.macro VERIFY_PRE_USERMODE_STATE
+	bl	verify_pre_usermode_state
+.endm
+#else
+/* Similar to set_fs(USER_DS) in verify_pre_usermode_state without a warning. */
+.macro VERIFY_PRE_USERMODE_STATE
+	mov	x1, #TASK_SIZE_64
+	str	x1, [tsk, #TSK_TI_ADDR_LIMIT]
+.endm
+#endif
+
+
 /*
  * This is the fast syscall return path.  We do as little as possible here,
  * and this includes saving x0 back into the kernel stack.
@@ -744,6 +757,7 @@ ENDPROC(cpu_switch_to)
 ret_fast_syscall:
 	disable_irq				// disable interrupts
 	str	x0, [sp, #S_X0]			// returned x0
+	VERIFY_PRE_USERMODE_STATE
 	ldr	x1, [tsk, #TSK_TI_FLAGS]	// re-check for syscall tracing
 	and	x2, x1, #_TIF_SYSCALL_WORK
 	cbnz	x2, ret_fast_syscall_trace
@@ -771,6 +785,7 @@ work_pending:
  */
 ret_to_user:
 	disable_irq				// disable interrupts
+	VERIFY_PRE_USERMODE_STATE
 	ldr	x1, [tsk, #TSK_TI_FLAGS]
 	and	x2, x1, #_TIF_WORK_MASK
 	cbnz	x2, work_pending
-- 
2.12.0.246.ga2ecc84866-goog
