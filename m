From: Thomas Garnier <thgarnie-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v9 2/4] x86/syscalls: Optimize address limit check
Date: Fri, 28 Apr 2017 08:32:11 -0700
Message-ID: <20170428153213.137279-2-thgarnie@google.com>
References: <20170428153213.137279-1-thgarnie@google.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170428153213.137279-1-thgarnie-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Martin Schwidefsky <schwidefsky-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Heiko Carstens <heiko.carstens-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Thomas Garnier <thgarnie-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, =?UTF-8?q?Ren=C3=A9=20Nyffenegger?= <mail-gLCNRsNSrVdVZEhyV+6z5nIPMjoJpjVV@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Paul E . McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Eric W . Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Pavel Tikhomirov <ptikhomirov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, kernel-hardening-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org
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

Signed-off-by: Thomas Garnier <thgarnie-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
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
index cd18994a9555..34c04696068b 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -42,6 +42,7 @@ config X86
 	#
 	select ACPI_LEGACY_TABLES_LOOKUP	if ACPI
 	select ACPI_SYSTEM_POWER_STATES_SUPPORT	if ACPI
+	select ADDR_LIMIT_CHECK
 	select ANON_INODES
 	select ARCH_CLOCKSOURCE_DATA
 	select ARCH_DISCARD_MEMBLOCK
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
