From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [RFC PATCH for 4.18 1/2] compat: Introduce is_compat_frame
Date: Tue, 26 Jun 2018 17:16:16 -0400
Message-ID: <20180626211617.8933-1-mathieu.desnoyers@efficios.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Joel Fernandes <joelaf@google.com>, Peter Zijlstra <peterz@infradead.org>, Catalin Marinas <catalin.marinas@arm.com>, Dave Watson <davejwatson@fb.com>, Will Deacon <will.deacon@arm.com>, Andi Kleen <andi@firstfloor.org>, "H . Peter Anvin" <hpa@zytor.com>, Chris Lameter <cl@linux.com>, Russell King <linux@arm.linux.org.uk>, Andrew Hunter <ahh@google.com>, Michael Kerrisk <mtk.manpages@gmail.com>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Paul Turner <pjt@google.com>, Boqun Feng <boqun.feng@gmail.com>, Josh Triplett <josh@joshtriplett.org>, Steven Rostedt <rostedt@goodmis.org>, Ben Maurer <bmaurer@fb.com>, linux-api@vger.kernel.org, linux-arch@vger.kernel.
List-Id: linux-api@vger.kernel.org

x86 is moving from is_compat_task() to in_compat_syscall(). However,
in_compat_syscall cannot be used to check whether a signal is being
delivered on a compat task.

Introduce is_compat_frame to allow performing this check from
architecture agnostic code. On all architectures except x86, it
invokes is_compat_task(). On x86, it uses is_ia32_frame() and
is_x32_frame() to check whether the signal frame is 32-bit.

This is needed by restartable sequences to detect whether it needs
to clear the top bits of the start_ip, abort_ip, and post_commit_offset
rseq_cs fields on signal delivery, thus ensuring identical behavior
for a 32-bit binary executed on 32-bit and 64-bit kernels.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Joel Fernandes <joelaf@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Watson <davejwatson@fb.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: "H . Peter Anvin" <hpa@zytor.com>
Cc: Chris Lameter <cl@linux.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Andrew Hunter <ahh@google.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Paul Turner <pjt@google.com>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ben Maurer <bmaurer@fb.com>
Cc: linux-api@vger.kernel.org
Cc: linux-arch@vger.kernel.org
Cc: x86@kernel.org
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
---
 arch/x86/include/asm/compat.h | 24 ++++++++++++++++++++++++
 arch/x86/kernel/signal.c      | 17 -----------------
 include/linux/compat.h        | 17 +++++++++++++++++
 3 files changed, 41 insertions(+), 17 deletions(-)

diff --git a/arch/x86/include/asm/compat.h b/arch/x86/include/asm/compat.h
index fb97cf7c4137..1405a8df5215 100644
--- a/arch/x86/include/asm/compat.h
+++ b/arch/x86/include/asm/compat.h
@@ -8,6 +8,7 @@
 #include <linux/types.h>
 #include <linux/sched.h>
 #include <linux/sched/task_stack.h>
+#include <linux/signal.h>
 #include <asm/processor.h>
 #include <asm/user32.h>
 #include <asm/unistd.h>
@@ -242,4 +243,27 @@ struct compat_siginfo;
 int __copy_siginfo_to_user32(struct compat_siginfo __user *to,
 		const siginfo_t *from, bool x32_ABI);
 
+static inline int is_ia32_compat_frame(struct ksignal *ksig)
+{
+	return IS_ENABLED(CONFIG_IA32_EMULATION) &&
+		ksig->ka.sa.sa_flags & SA_IA32_ABI;
+}
+
+static inline int is_ia32_frame(struct ksignal *ksig)
+{
+	return IS_ENABLED(CONFIG_X86_32) || is_ia32_compat_frame(ksig);
+}
+
+static inline int is_x32_frame(struct ksignal *ksig)
+{
+	return IS_ENABLED(CONFIG_X86_X32_ABI) &&
+		ksig->ka.sa.sa_flags & SA_X32_ABI;
+}
+
+static inline bool is_compat_frame(struct ksignal *ksig)
+{
+	return is_ia32_frame(ksig) || is_x32_frame(ksig);
+}
+#define is_compat_frame	is_compat_frame		/* override the generic impl */
+
 #endif /* _ASM_X86_COMPAT_H */
diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index 92a3b312a53c..cb488e3e952d 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -664,23 +664,6 @@ SYSCALL_DEFINE0(rt_sigreturn)
 	return 0;
 }
 
-static inline int is_ia32_compat_frame(struct ksignal *ksig)
-{
-	return IS_ENABLED(CONFIG_IA32_EMULATION) &&
-		ksig->ka.sa.sa_flags & SA_IA32_ABI;
-}
-
-static inline int is_ia32_frame(struct ksignal *ksig)
-{
-	return IS_ENABLED(CONFIG_X86_32) || is_ia32_compat_frame(ksig);
-}
-
-static inline int is_x32_frame(struct ksignal *ksig)
-{
-	return IS_ENABLED(CONFIG_X86_X32_ABI) &&
-		ksig->ka.sa.sa_flags & SA_X32_ABI;
-}
-
 static int
 setup_rt_frame(struct ksignal *ksig, struct pt_regs *regs)
 {
diff --git a/include/linux/compat.h b/include/linux/compat.h
index b1a5562b3215..2e1ffba65117 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -1022,6 +1022,19 @@ static inline struct compat_timeval ns_to_compat_timeval(s64 nsec)
 	return ctv;
 }
 
+/*
+ * For most but not all architectures, "is this a compat sigframe?" and
+ * "am I a compat task?" are the same question.  For architectures on which
+ * they aren't the same question, arch code can override is_compat_frame.
+ */
+
+#ifndef is_compat_frame
+static inline bool is_compat_frame(struct ksignal *ksig)
+{
+	return is_compat_task();
+}
+#endif
+
 #else /* !CONFIG_COMPAT */
 
 #define is_compat_task() (0)
@@ -1029,6 +1042,10 @@ static inline struct compat_timeval ns_to_compat_timeval(s64 nsec)
 static inline bool in_compat_syscall(void) { return false; }
 #endif
 
+#ifndef is_compat_frame
+static inline bool is_compat_frame(struct ksignal *ksig) { return false; }
+#endif
+
 #endif /* CONFIG_COMPAT */
 
 #endif /* _LINUX_COMPAT_H */
-- 
2.11.0
