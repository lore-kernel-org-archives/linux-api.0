From: Thomas Garnier <thgarnie@google.com>
Subject: [PATCH v3 2/4] Revert "arm/syscalls: Check address limit on user-mode return"
Date: Mon, 14 Aug 2017 14:37:30 -0700
Message-ID: <20170814213732.104301-2-thgarnie@google.com>
References: <20170814213732.104301-1-thgarnie@google.com>
Return-path: <kernel-hardening-return-9431-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <20170814213732.104301-1-thgarnie@google.com>
To: Al Viro <viro@zeniv.linux.org.uk>, Dave Hansen <dave.hansen@intel.com>, Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>, Thomas Garnier <thgarnie@google.com>, Yonghong Song <yhs@fb.com>, David Howells <dhowells@redhat.com>, Russell King <linux@armlinux.org.uk>, Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@amacapital.net>, Will Drewry <wad@chromium.org>, Dave Martin <Dave.Martin@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>
Cc: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kernel-hardening@lists.openwall.com
List-Id: linux-api@vger.kernel.org

This reverts commit 73ac5d6a2b6ac3ae8d1e1818f3e9946f97489bc9.

The work pending loop can call set_fs after addr_limit_user_check
removed the _TIF_FSCHECK flag. This may happen at anytime based on how
ARM handles alignment exceptions. It leads to an infinite loop condition.

After discussion, it has been agreed that the generic approach is not
tailored to the ARM architecture and any fix might not be complete. This
patch will be replaced by an architecture specific implementation. The
work flag approach will be kept for other architectures.

Reported-by: Leonard Crestez <leonard.crestez@nxp.com>
Signed-off-by: Thomas Garnier <thgarnie@google.com>
---
 arch/arm/include/asm/thread_info.h | 15 ++++++---------
 arch/arm/include/asm/uaccess.h     |  2 --
 arch/arm/kernel/entry-common.S     |  9 ++-------
 arch/arm/kernel/signal.c           |  5 -----
 4 files changed, 8 insertions(+), 23 deletions(-)

diff --git a/arch/arm/include/asm/thread_info.h b/arch/arm/include/asm/thread_info.h
index 1d468b527b7b..776757d1604a 100644
--- a/arch/arm/include/asm/thread_info.h
+++ b/arch/arm/include/asm/thread_info.h
@@ -139,11 +139,10 @@ extern int vfp_restore_user_hwstate(struct user_vfp __user *,
 #define TIF_NEED_RESCHED	1	/* rescheduling necessary */
 #define TIF_NOTIFY_RESUME	2	/* callback before returning to user */
 #define TIF_UPROBE		3	/* breakpointed or singlestepping */
-#define TIF_FSCHECK		4	/* Check FS is USER_DS on return */
-#define TIF_SYSCALL_TRACE	5	/* syscall trace active */
-#define TIF_SYSCALL_AUDIT	6	/* syscall auditing active */
-#define TIF_SYSCALL_TRACEPOINT	7	/* syscall tracepoint instrumentation */
-#define TIF_SECCOMP		8	/* seccomp syscall filtering active */
+#define TIF_SYSCALL_TRACE	4	/* syscall trace active */
+#define TIF_SYSCALL_AUDIT	5	/* syscall auditing active */
+#define TIF_SYSCALL_TRACEPOINT	6	/* syscall tracepoint instrumentation */
+#define TIF_SECCOMP		7	/* seccomp syscall filtering active */
 
 #define TIF_NOHZ		12	/* in adaptive nohz mode */
 #define TIF_USING_IWMMXT	17
@@ -154,7 +153,6 @@ extern int vfp_restore_user_hwstate(struct user_vfp __user *,
 #define _TIF_NEED_RESCHED	(1 << TIF_NEED_RESCHED)
 #define _TIF_NOTIFY_RESUME	(1 << TIF_NOTIFY_RESUME)
 #define _TIF_UPROBE		(1 << TIF_UPROBE)
-#define _TIF_FSCHECK		(1 << TIF_FSCHECK)
 #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
 #define _TIF_SYSCALL_AUDIT	(1 << TIF_SYSCALL_AUDIT)
 #define _TIF_SYSCALL_TRACEPOINT	(1 << TIF_SYSCALL_TRACEPOINT)
@@ -168,9 +166,8 @@ extern int vfp_restore_user_hwstate(struct user_vfp __user *,
 /*
  * Change these and you break ASM code in entry-common.S
  */
-#define _TIF_WORK_MASK		(_TIF_NEED_RESCHED | _TIF_SIGPENDING |	\
-				 _TIF_NOTIFY_RESUME | _TIF_UPROBE |	\
-				 _TIF_FSCHECK)
+#define _TIF_WORK_MASK		(_TIF_NEED_RESCHED | _TIF_SIGPENDING | \
+				 _TIF_NOTIFY_RESUME | _TIF_UPROBE)
 
 #endif /* __KERNEL__ */
 #endif /* __ASM_ARM_THREAD_INFO_H */
diff --git a/arch/arm/include/asm/uaccess.h b/arch/arm/include/asm/uaccess.h
index 87936dd5d151..0bf2347495f1 100644
--- a/arch/arm/include/asm/uaccess.h
+++ b/arch/arm/include/asm/uaccess.h
@@ -70,8 +70,6 @@ static inline void set_fs(mm_segment_t fs)
 {
 	current_thread_info()->addr_limit = fs;
 	modify_domain(DOMAIN_KERNEL, fs ? DOMAIN_CLIENT : DOMAIN_MANAGER);
-	/* On user-mode return, check fs is correct */
-	set_thread_flag(TIF_FSCHECK);
 }
 
 #define segment_eq(a, b)	((a) == (b))
diff --git a/arch/arm/kernel/entry-common.S b/arch/arm/kernel/entry-common.S
index ca3614dc6938..0b60adf4a5d9 100644
--- a/arch/arm/kernel/entry-common.S
+++ b/arch/arm/kernel/entry-common.S
@@ -49,9 +49,7 @@ ret_fast_syscall:
  UNWIND(.cantunwind	)
 	disable_irq_notrace			@ disable interrupts
 	ldr	r1, [tsk, #TI_FLAGS]		@ re-check for syscall tracing
-	tst	r1, #_TIF_SYSCALL_WORK
-	bne	fast_work_pending
-	tst	r1, #_TIF_WORK_MASK
+	tst	r1, #_TIF_SYSCALL_WORK | _TIF_WORK_MASK
 	bne	fast_work_pending
 
 	/* perform architecture specific actions before user return */
@@ -77,15 +75,12 @@ ret_fast_syscall:
 	str	r0, [sp, #S_R0 + S_OFF]!	@ save returned r0
 	disable_irq_notrace			@ disable interrupts
 	ldr	r1, [tsk, #TI_FLAGS]		@ re-check for syscall tracing
-	tst	r1, #_TIF_SYSCALL_WORK
-	bne	fast_work_pending
-	tst	r1, #_TIF_WORK_MASK
+	tst	r1, #_TIF_SYSCALL_WORK | _TIF_WORK_MASK
 	beq	no_work_pending
  UNWIND(.fnend		)
 ENDPROC(ret_fast_syscall)
 
 	/* Slower path - fall through to work_pending */
-fast_work_pending:
 #endif
 
 	tst	r1, #_TIF_SYSCALL_WORK
diff --git a/arch/arm/kernel/signal.c b/arch/arm/kernel/signal.c
index e2de50bf8742..5814298ef0b7 100644
--- a/arch/arm/kernel/signal.c
+++ b/arch/arm/kernel/signal.c
@@ -14,7 +14,6 @@
 #include <linux/uaccess.h>
 #include <linux/tracehook.h>
 #include <linux/uprobes.h>
-#include <linux/syscalls.h>
 
 #include <asm/elf.h>
 #include <asm/cacheflush.h>
@@ -614,10 +613,6 @@ do_work_pending(struct pt_regs *regs, unsigned int thread_flags, int syscall)
 	 * Update the trace code with the current status.
 	 */
 	trace_hardirqs_off();
-
-	/* Check valid user FS if needed */
-	addr_limit_user_check();
-
 	do {
 		if (likely(thread_flags & _TIF_NEED_RESCHED)) {
 			schedule();
-- 
2.14.1.480.gb18f417b89-goog
