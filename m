From: Marcin Nowakowski <marcin.nowakowski@imgtec.com>
Subject: [PATCH v3 05/11] x86/tracing: fix compat syscall handling
Date: Tue, 11 Oct 2016 12:42:50 +0200
Message-ID: <1476182576-15247-6-git-send-email-marcin.nowakowski@imgtec.com>
References: <1476182576-15247-1-git-send-email-marcin.nowakowski@imgtec.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1476182576-15247-1-git-send-email-marcin.nowakowski@imgtec.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, luto@amacapital.net, rostedt@goodmis.org, Marcin Nowakowski <marcin.nowakowski@imgtec.com>, Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
List-Id: linux-api@vger.kernel.org

Adapt the arch-specific code to new syscall tracing interface:
arch_trace_is_compat_syscall() now only indicates if a syscall is ia32,
as x32 syscalls exist in the same syscall table as native 64 bit ones,
so should not be treated as compat ones
Add arch_trace_syscall_get_nr that removes the x32 bit from syscall
numbers.

Signed-off-by: Marcin Nowakowski <marcin.nowakowski@imgtec.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
---
 arch/x86/include/asm/ftrace.h  | 14 ++------------
 arch/x86/include/asm/syscall.h |  9 +++++++++
 arch/x86/kernel/ftrace.c       | 15 +++++++++++++++
 3 files changed, 26 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/ftrace.h b/arch/x86/include/asm/ftrace.h
index eccd0ac..69f1674 100644
--- a/arch/x86/include/asm/ftrace.h
+++ b/arch/x86/include/asm/ftrace.h
@@ -50,20 +50,10 @@ int ftrace_int3_handler(struct pt_regs *regs);
 #if defined(CONFIG_FTRACE_SYSCALLS) && defined(CONFIG_IA32_EMULATION)
 #include <asm/compat.h>
 
-/*
- * Because ia32 syscalls do not map to x86_64 syscall numbers
- * this screws up the trace output when tracing a ia32 task.
- * Instead of reporting bogus syscalls, just do not trace them.
- *
- * If the user really wants these, then they should use the
- * raw syscall tracepoints with filtering.
- */
-#define ARCH_TRACE_IGNORE_COMPAT_SYSCALLS 1
+#define ARCH_COMPAT_SYSCALL_NUMBERS_OVERLAP 1
 static inline bool arch_trace_is_compat_syscall(struct pt_regs *regs)
 {
-	if (in_compat_syscall())
-		return true;
-	return false;
+	return in_ia32_syscall();
 }
 #endif /* CONFIG_FTRACE_SYSCALLS && CONFIG_IA32_EMULATION */
 #endif /* !__ASSEMBLY__  && !COMPILE_OFFSETS */
diff --git a/arch/x86/include/asm/syscall.h b/arch/x86/include/asm/syscall.h
index e3c95e8..732b5ab 100644
--- a/arch/x86/include/asm/syscall.h
+++ b/arch/x86/include/asm/syscall.h
@@ -239,4 +239,13 @@ static inline int syscall_get_arch(void)
 }
 #endif	/* CONFIG_X86_32 */
 
+#ifdef CONFIG_FTRACE_SYSCALLS
+static inline
+int arch_trace_syscall_get_nr(struct task_struct *task, struct pt_regs *regs)
+{
+	return syscall_get_nr(task, regs) & __SYSCALL_MASK;
+}
+#define arch_trace_syscall_get_nr arch_trace_syscall_get_nr
+#endif /* CONFIG_FTRACE_SYSCALLS */
+
 #endif	/* _ASM_X86_SYSCALL_H */
diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 8639bb2..c26d4ae 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -28,6 +28,7 @@
 #include <asm/kprobes.h>
 #include <asm/ftrace.h>
 #include <asm/nops.h>
+#include <asm/syscall.h>
 
 #ifdef CONFIG_DYNAMIC_FTRACE
 
@@ -1035,3 +1036,17 @@ void prepare_ftrace_return(unsigned long self_addr, unsigned long *parent,
 	}
 }
 #endif /* CONFIG_FUNCTION_GRAPH_TRACER */
+
+#ifdef CONFIG_FTRACE_SYSCALLS
+#if defined(CONFIG_X86_64) && defined(CONFIG_IA32_EMULATION)
+
+unsigned long __init arch_syscall_addr(int nr, bool compat)
+{
+	if (compat)
+		return (unsigned long)ia32_sys_call_table[nr];
+
+	return (unsigned long)sys_call_table[nr];
+}
+
+#endif /* CONFIG_X86_64 && CONFIG_IA32_EMULATION */
+#endif /* CONFIG_FTRACE_SYSCALLS */
-- 
2.7.4
