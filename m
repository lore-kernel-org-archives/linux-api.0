From: Thomas Garnier <thgarnie@google.com>
Subject: [PATCH v10 2/3] arm/syscalls: Check address limit on user-mode return
Date: Wed, 14 Jun 2017 18:12:02 -0700
Message-ID: <20170615011203.144108-2-thgarnie@google.com>
References: <20170615011203.144108-1-thgarnie@google.com>
Return-path: <kernel-hardening-return-8585-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <20170615011203.144108-1-thgarnie@google.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Rik van Riel <riel@redhat.com>, Oleg Nesterov <oleg@redhat.com>, Josh Poimboeuf <jpoimboe@redhat.com>, Thomas Garnier <thgarnie@google.com>, Petr Mladek <pmladek@suse.com>, Miroslav Benes <mbenes@suse.cz>, Kees Cook <keescook@chromium.org>, Al Viro <viro@zeniv.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>, Dave Hansen <dave.hansen@intel.com>, David Howells <dhowells@redhat.com>, Russell King <linux@armlinux.org.uk>, Andy Lutomirski <luto@amacapital.net>, Will Drewry <wad@chromium.org>, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland <mark.rutland@arm.com>, Pratyush Anand <panand@redhat.com>, Chris Metcalf <cmetcalf@mellanox.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kernel-hardening@lists.openwall.com
List-Id: linux-api@vger.kernel.org

Ensure the address limit is a user-mode segment before returning to
user-mode. Otherwise a process can corrupt kernel-mode memory and
elevate privileges [1].

The set_fs function sets the TIF_SETFS flag to force a slow path on
return. In the slow path, the address limit is checked to be USER_DS if
needed.

The TIF_SETFS flag is added to _TIF_WORK_MASK shifting _TIF_SYSCALL_WORK
for arm instruction immediate support. The global work mask is too big
to used on a single instruction so adapt ret_fast_syscall.

[1] https://bugs.chromium.org/p/project-zero/issues/detail?id=990

Signed-off-by: Thomas Garnier <thgarnie@google.com>
---
v10 redesigns the change to use work flags on set_fs as recommended by
Linus and agreed by others.

Based on next-20170609
---
 arch/arm/include/asm/thread_info.h | 15 +++++++++------
 arch/arm/include/asm/uaccess.h     |  2 ++
 arch/arm/kernel/entry-common.S     |  9 +++++++--
 arch/arm/kernel/signal.c           |  5 +++++
 4 files changed, 23 insertions(+), 8 deletions(-)

diff --git a/arch/arm/include/asm/thread_info.h b/arch/arm/include/asm/thread_info.h
index 776757d1604a..1d468b527b7b 100644
--- a/arch/arm/include/asm/thread_info.h
+++ b/arch/arm/include/asm/thread_info.h
@@ -139,10 +139,11 @@ extern int vfp_restore_user_hwstate(struct user_vfp __user *,
 #define TIF_NEED_RESCHED	1	/* rescheduling necessary */
 #define TIF_NOTIFY_RESUME	2	/* callback before returning to user */
 #define TIF_UPROBE		3	/* breakpointed or singlestepping */
-#define TIF_SYSCALL_TRACE	4	/* syscall trace active */
-#define TIF_SYSCALL_AUDIT	5	/* syscall auditing active */
-#define TIF_SYSCALL_TRACEPOINT	6	/* syscall tracepoint instrumentation */
-#define TIF_SECCOMP		7	/* seccomp syscall filtering active */
+#define TIF_FSCHECK		4	/* Check FS is USER_DS on return */
+#define TIF_SYSCALL_TRACE	5	/* syscall trace active */
+#define TIF_SYSCALL_AUDIT	6	/* syscall auditing active */
+#define TIF_SYSCALL_TRACEPOINT	7	/* syscall tracepoint instrumentation */
+#define TIF_SECCOMP		8	/* seccomp syscall filtering active */
 
 #define TIF_NOHZ		12	/* in adaptive nohz mode */
 #define TIF_USING_IWMMXT	17
@@ -153,6 +154,7 @@ extern int vfp_restore_user_hwstate(struct user_vfp __user *,
 #define _TIF_NEED_RESCHED	(1 << TIF_NEED_RESCHED)
 #define _TIF_NOTIFY_RESUME	(1 << TIF_NOTIFY_RESUME)
 #define _TIF_UPROBE		(1 << TIF_UPROBE)
+#define _TIF_FSCHECK		(1 << TIF_FSCHECK)
 #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
 #define _TIF_SYSCALL_AUDIT	(1 << TIF_SYSCALL_AUDIT)
 #define _TIF_SYSCALL_TRACEPOINT	(1 << TIF_SYSCALL_TRACEPOINT)
@@ -166,8 +168,9 @@ extern int vfp_restore_user_hwstate(struct user_vfp __user *,
 /*
  * Change these and you break ASM code in entry-common.S
  */
-#define _TIF_WORK_MASK		(_TIF_NEED_RESCHED | _TIF_SIGPENDING | \
-				 _TIF_NOTIFY_RESUME | _TIF_UPROBE)
+#define _TIF_WORK_MASK		(_TIF_NEED_RESCHED | _TIF_SIGPENDING |	\
+				 _TIF_NOTIFY_RESUME | _TIF_UPROBE |	\
+				 _TIF_FSCHECK)
 
 #endif /* __KERNEL__ */
 #endif /* __ASM_ARM_THREAD_INFO_H */
diff --git a/arch/arm/include/asm/uaccess.h b/arch/arm/include/asm/uaccess.h
index 2577405d082d..6cc882223e34 100644
--- a/arch/arm/include/asm/uaccess.h
+++ b/arch/arm/include/asm/uaccess.h
@@ -77,6 +77,8 @@ static inline void set_fs(mm_segment_t fs)
 {
 	current_thread_info()->addr_limit = fs;
 	modify_domain(DOMAIN_KERNEL, fs ? DOMAIN_CLIENT : DOMAIN_MANAGER);
+	/* On user-mode return, check fs is correct */
+	set_thread_flag(TIF_FSCHECK);
 }
 
 #define segment_eq(a, b)	((a) == (b))
diff --git a/arch/arm/kernel/entry-common.S b/arch/arm/kernel/entry-common.S
index eb5cd77bf1d8..e33c32d56193 100644
--- a/arch/arm/kernel/entry-common.S
+++ b/arch/arm/kernel/entry-common.S
@@ -41,7 +41,9 @@ ret_fast_syscall:
  UNWIND(.cantunwind	)
 	disable_irq_notrace			@ disable interrupts
 	ldr	r1, [tsk, #TI_FLAGS]		@ re-check for syscall tracing
-	tst	r1, #_TIF_SYSCALL_WORK | _TIF_WORK_MASK
+	tst	r1, #_TIF_SYSCALL_WORK
+	bne	fast_work_pending
+	tst	r1, #_TIF_WORK_MASK
 	bne	fast_work_pending
 
 	/* perform architecture specific actions before user return */
@@ -67,12 +69,15 @@ ret_fast_syscall:
 	str	r0, [sp, #S_R0 + S_OFF]!	@ save returned r0
 	disable_irq_notrace			@ disable interrupts
 	ldr	r1, [tsk, #TI_FLAGS]		@ re-check for syscall tracing
-	tst	r1, #_TIF_SYSCALL_WORK | _TIF_WORK_MASK
+	tst	r1, #_TIF_SYSCALL_WORK
+	bne	fast_work_pending
+	tst	r1, #_TIF_WORK_MASK
 	beq	no_work_pending
  UNWIND(.fnend		)
 ENDPROC(ret_fast_syscall)
 
 	/* Slower path - fall through to work_pending */
+fast_work_pending:
 #endif
 
 	tst	r1, #_TIF_SYSCALL_WORK
diff --git a/arch/arm/kernel/signal.c b/arch/arm/kernel/signal.c
index 7b8f2141427b..3a48b54c6405 100644
--- a/arch/arm/kernel/signal.c
+++ b/arch/arm/kernel/signal.c
@@ -14,6 +14,7 @@
 #include <linux/uaccess.h>
 #include <linux/tracehook.h>
 #include <linux/uprobes.h>
+#include <linux/syscalls.h>
 
 #include <asm/elf.h>
 #include <asm/cacheflush.h>
@@ -571,6 +572,10 @@ do_work_pending(struct pt_regs *regs, unsigned int thread_flags, int syscall)
 	 * Update the trace code with the current status.
 	 */
 	trace_hardirqs_off();
+
+	/* Check valid user FS if needed */
+	addr_limit_user_check();
+
 	do {
 		if (likely(thread_flags & _TIF_NEED_RESCHED)) {
 			schedule();
-- 
2.13.1.518.g3df882009-goog
