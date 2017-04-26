From: Thomas Garnier <thgarnie@google.com>
Subject: [PATCH v8 2/4] x86/syscalls: Optimize address limit check
Date: Wed, 26 Apr 2017 11:34:23 -0700
Message-ID: <20170426183425.32158-2-thgarnie@google.com>
References: <20170426183425.32158-1-thgarnie@google.com>
Return-path: <kernel-hardening-return-7596-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <20170426183425.32158-1-thgarnie@google.com>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Dave Hansen <dave.hansen@intel.com>, Arnd Bergmann <arnd@arndb.de>, David Howells <dhowells@redhat.com>, =?UTF-8?q?Ren=C3=A9=20Nyffenegger?= <mail@renenyffenegger.ch>, Thomas Garnier <thgarnie@google.com>, Andrew Morton <akpm@linux-foundation.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Ingo Molnar <mingo@kernel.org>, "Eric W . Biederman" <ebiederm@xmission.com>, Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@redhat.com>, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Kees Cook <keescook@chromium.org>, Rik van Riel <riel@redhat.com>, Josh Poimboeuf <jpoimboe@redhat.com>, Borislav Petkov <bp@alien8.de>, Brian Gerst <br>
Cc: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, x86@kernel.org, linux-arm-kernel@lists.infradead.org, kernel-hardening@lists.openwall.com
List-Id: linux-api@vger.kernel.org

Disable the generic address limit check in favor of an architecture
specific optimized implementation.

The user-mode state check is added to the prepare_exit_to_usermode
function. This function is called before any user-mode return on 32-bit
and on the 64-bit syscall slowpath. For the 64-bit syscall fast path, an
assembly address limit check redirects to the slow path if the address
limit is different.

The TASK_SIZE_MAX definition is moved to the pgtable_64_types header so
it can be used in assembly code.

Signed-off-by: Thomas Garnier <thgarnie@google.com>
---
Based on next-20170426
---
 arch/x86/Kconfig                        |  1 +
 arch/x86/entry/common.c                 |  3 +++
 arch/x86/entry/entry_64.S               |  8 ++++++++
 arch/x86/include/asm/pgtable_64_types.h | 11 +++++++++++
 arch/x86/include/asm/processor.h        | 11 -----------
 5 files changed, 23 insertions(+), 11 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index cd18994a9555..f3ce1859bd61 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -63,6 +63,7 @@ config X86
 	select ARCH_MIGHT_HAVE_ACPI_PDC		if ACPI
 	select ARCH_MIGHT_HAVE_PC_PARPORT
 	select ARCH_MIGHT_HAVE_PC_SERIO
+	select ADDR_LIMIT_CHECK
 	select ARCH_SUPPORTS_ATOMIC_RMW
 	select ARCH_SUPPORTS_DEFERRED_STRUCT_PAGE_INIT
 	select ARCH_SUPPORTS_NUMA_BALANCING	if X86_64
diff --git a/arch/x86/entry/common.c b/arch/x86/entry/common.c
index cdefcfdd9e63..057d133d7b78 100644
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
 
+	addr_limit_check_syscall();
+
 	if (IS_ENABLED(CONFIG_PROVE_LOCKING) && WARN_ON(!irqs_disabled()))
 		local_irq_disable();
 
diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
index 607d72c4a485..62aca6dcdaf4 100644
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
+	jne	1f
+
 	LOCKDEP_SYS_EXIT
 	TRACE_IRQS_ON		/* user mode is traced as IRQs on */
 	movq	RIP(%rsp), %rcx
diff --git a/arch/x86/include/asm/pgtable_64_types.h b/arch/x86/include/asm/pgtable_64_types.h
index 06470da156ba..78af4d43a7ce 100644
--- a/arch/x86/include/asm/pgtable_64_types.h
+++ b/arch/x86/include/asm/pgtable_64_types.h
@@ -104,4 +104,15 @@ typedef struct { pteval_t pte; } pte_t;
 
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
2.13.0.rc0.306.g87b477812d-goog
