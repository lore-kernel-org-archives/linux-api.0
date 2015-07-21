From: Kyle Huey <me@kylehuey.com>
Subject: [PATCH] ARM: ptrace: Implement PTRACE_SYSEMU
Date: Tue, 21 Jul 2015 03:04:45 -0700
Message-ID: <1437473089-28654-1-git-send-email-khuey@kylehuey.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Russell King <linux@arm.linux.org.uk>, Will Deacon <will.deacon@arm.com>, Richard Weinberger <richard@nod.at>, Mark Charlebois <charlebm@gmail.com>, =?UTF-8?q?Jan-Simon=20M=C3=B6ller?= <dl9pf@gmx.de>, Behan Webster <behanw@converseincode.com>, Vladimir Murzin <vladimir.murzin@arm.com>, Kyle Huey <khuey@kylehuey.com>, Andy Lutomirski <luto@amacapital.net>, Eric Paris <eparis@redhat.com>, Kees Cook <keescook@chromium.org>, "moderated list:ARM PORT" <linux-arm-kernel@lists.infradead.org>, open list <linux-kernel@vger.kernel.org>
Cc: linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Implement PTRACE_SYSEMU support on ARM. Currently this ptrace call is
supported only on x86. This copies the x86 semantics for invoking ptrace hooks
(the syscall entry hook is invoked, the exit hook is not). This patch also
defines PTRACE_SYSEMU_SINGLESTEP because kernel/ptrace.c expects it to be
present if PTRACE_SYSEMU is present. Attempting to use PTRACE_SYSEMU_SINGLESTEP
will fail at runtime on ARM with EIO since there is no single stepping on ARM.

Signed-off-by: Kyle Huey <khuey@kylehuey.com>
---
 arch/arm/include/asm/thread_info.h |  8 ++++++--
 arch/arm/include/uapi/asm/ptrace.h | 32 +++++++++++++++++---------------
 arch/arm/kernel/ptrace.c           |  9 +++++++--
 3 files changed, 30 insertions(+), 19 deletions(-)

diff --git a/arch/arm/include/asm/thread_info.h b/arch/arm/include/asm/thread_info.h
index bd32ede..0e3ee19 100644
--- a/arch/arm/include/asm/thread_info.h
+++ b/arch/arm/include/asm/thread_info.h
@@ -137,7 +137,8 @@ extern int vfp_restore_user_hwstate(struct user_vfp __user *,
 /*
  * thread information flags:
  *  TIF_SYSCALL_TRACE	- syscall trace active
- *  TIF_SYSCAL_AUDIT	- syscall auditing active
+ *  TIF_SYSCALL_AUDIT	- syscall auditing active
+ *  TIF_SYSCALL_EMU	- syscall emulation active
  *  TIF_SIGPENDING	- signal pending
  *  TIF_NEED_RESCHED	- rescheduling necessary
  *  TIF_NOTIFY_RESUME	- callback before returning to user
@@ -153,6 +154,7 @@ extern int vfp_restore_user_hwstate(struct user_vfp __user *,
 #define TIF_SYSCALL_TRACEPOINT	10
 #define TIF_SECCOMP		11	/* seccomp syscall filtering active */
 #define TIF_NOHZ		12	/* in adaptive nohz mode */
+#define TIF_SYSCALL_EMU		13
 #define TIF_USING_IWMMXT	17
 #define TIF_MEMDIE		18	/* is terminating due to OOM killer */
 #define TIF_RESTORE_SIGMASK	20
@@ -165,11 +167,13 @@ extern int vfp_restore_user_hwstate(struct user_vfp __user *,
 #define _TIF_SYSCALL_AUDIT	(1 << TIF_SYSCALL_AUDIT)
 #define _TIF_SYSCALL_TRACEPOINT	(1 << TIF_SYSCALL_TRACEPOINT)
 #define _TIF_SECCOMP		(1 << TIF_SECCOMP)
+#define _TIF_SYSCALL_EMU	(1 << TIF_SYSCALL_EMU)
 #define _TIF_USING_IWMMXT	(1 << TIF_USING_IWMMXT)
 
 /* Checks for any syscall work in entry-common.S */
 #define _TIF_SYSCALL_WORK (_TIF_SYSCALL_TRACE | _TIF_SYSCALL_AUDIT | \
-			   _TIF_SYSCALL_TRACEPOINT | _TIF_SECCOMP)
+			   _TIF_SYSCALL_TRACEPOINT | _TIF_SECCOMP | \
+			   _TIF_SYSCALL_EMU)
 
 /*
  * Change these and you break ASM code in entry-common.S
diff --git a/arch/arm/include/uapi/asm/ptrace.h b/arch/arm/include/uapi/asm/ptrace.h
index 5af0ed1..2c5e4d7 100644
--- a/arch/arm/include/uapi/asm/ptrace.h
+++ b/arch/arm/include/uapi/asm/ptrace.h
@@ -12,25 +12,27 @@
 
 #include <asm/hwcap.h>
 
-#define PTRACE_GETREGS		12
-#define PTRACE_SETREGS		13
-#define PTRACE_GETFPREGS	14
-#define PTRACE_SETFPREGS	15
+#define PTRACE_GETREGS			12
+#define PTRACE_SETREGS			13
+#define PTRACE_GETFPREGS		14
+#define PTRACE_SETFPREGS		15
 /* PTRACE_ATTACH is 16 */
 /* PTRACE_DETACH is 17 */
-#define PTRACE_GETWMMXREGS	18
-#define PTRACE_SETWMMXREGS	19
+#define PTRACE_GETWMMXREGS		18
+#define PTRACE_SETWMMXREGS		19
 /* 20 is unused */
-#define PTRACE_OLDSETOPTIONS	21
-#define PTRACE_GET_THREAD_AREA	22
-#define PTRACE_SET_SYSCALL	23
+#define PTRACE_OLDSETOPTIONS		21
+#define PTRACE_GET_THREAD_AREA		22
+#define PTRACE_SET_SYSCALL		23
 /* PTRACE_SYSCALL is 24 */
-#define PTRACE_GETCRUNCHREGS	25
-#define PTRACE_SETCRUNCHREGS	26
-#define PTRACE_GETVFPREGS	27
-#define PTRACE_SETVFPREGS	28
-#define PTRACE_GETHBPREGS	29
-#define PTRACE_SETHBPREGS	30
+#define PTRACE_GETCRUNCHREGS		25
+#define PTRACE_SETCRUNCHREGS		26
+#define PTRACE_GETVFPREGS		27
+#define PTRACE_SETVFPREGS		28
+#define PTRACE_GETHBPREGS		29
+#define PTRACE_SETHBPREGS		30
+#define PTRACE_SYSEMU			31
+#define PTRACE_SYSEMU_SINGLESTEP	32
 
 /*
  * PSR bits
diff --git a/arch/arm/kernel/ptrace.c b/arch/arm/kernel/ptrace.c
index ef9119f..c84058c 100644
--- a/arch/arm/kernel/ptrace.c
+++ b/arch/arm/kernel/ptrace.c
@@ -930,6 +930,8 @@ static void tracehook_report_syscall(struct pt_regs *regs,
 
 asmlinkage int syscall_trace_enter(struct pt_regs *regs, int scno)
 {
+	int ret = 0;
+
 	current_thread_info()->syscall = scno;
 
 	/* Do the secure computing check first; failures should be fast. */
@@ -941,7 +943,10 @@ asmlinkage int syscall_trace_enter(struct pt_regs *regs, int scno)
 	secure_computing_strict(scno);
 #endif
 
-	if (test_thread_flag(TIF_SYSCALL_TRACE))
+	if (test_thread_flag(TIF_SYSCALL_EMU))
+		ret = -1;
+
+	if (ret || test_thread_flag(TIF_SYSCALL_TRACE))
 		tracehook_report_syscall(regs, PTRACE_SYSCALL_ENTER);
 
 	scno = current_thread_info()->syscall;
@@ -952,7 +957,7 @@ asmlinkage int syscall_trace_enter(struct pt_regs *regs, int scno)
 	audit_syscall_entry(scno, regs->ARM_r0, regs->ARM_r1, regs->ARM_r2,
 			    regs->ARM_r3);
 
-	return scno;
+	return ret ?: scno;
 }
 
 asmlinkage void syscall_trace_exit(struct pt_regs *regs)
-- 
1.9.1
