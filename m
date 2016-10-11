From: Marcin Nowakowski <marcin.nowakowski@imgtec.com>
Subject: [PATCH v3 06/11] s390/tracing: fix compat syscall handling
Date: Tue, 11 Oct 2016 12:42:51 +0200
Message-ID: <1476182576-15247-7-git-send-email-marcin.nowakowski@imgtec.com>
References: <1476182576-15247-1-git-send-email-marcin.nowakowski@imgtec.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1476182576-15247-1-git-send-email-marcin.nowakowski@imgtec.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, luto@amacapital.net, rostedt@goodmis.org, Marcin Nowakowski <marcin.nowakowski@imgtec.com>, Ingo Molnar <mingo@redhat.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, linux-s390@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Add missing arch code - arch_trace_is_compat_syscall and
arch_syscall_addr

Signed-off-by: Marcin Nowakowski <marcin.nowakowski@imgtec.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux-s390@vger.kernel.org
---
 arch/s390/include/asm/ftrace.h  | 11 +++++++++++
 arch/s390/include/asm/syscall.h |  1 +
 arch/s390/kernel/Makefile       |  1 +
 arch/s390/kernel/ftrace.c       | 12 ++++++++++++
 4 files changed, 25 insertions(+)

diff --git a/arch/s390/include/asm/ftrace.h b/arch/s390/include/asm/ftrace.h
index 64053d9..af8ba9c 100644
--- a/arch/s390/include/asm/ftrace.h
+++ b/arch/s390/include/asm/ftrace.h
@@ -82,5 +82,16 @@ static inline void ftrace_generate_call_insn(struct ftrace_insn *insn,
 #endif
 }
 
+#if defined(CONFIG_FTRACE_SYSCALLS) && defined(CONFIG_COMPAT)
+#include <linux/compat.h>
+#include <asm/compat.h>
+
+#define ARCH_COMPAT_SYSCALL_NUMBERS_OVERLAP 1
+static inline bool arch_trace_is_compat_syscall(struct pt_regs *regs)
+{
+	return in_compat_syscall();
+}
+#endif /* CONFIG_FTRACE_SYSCALLS && CONFIG_COMPAT */
+
 #endif /* __ASSEMBLY__ */
 #endif /* _ASM_S390_FTRACE_H */
diff --git a/arch/s390/include/asm/syscall.h b/arch/s390/include/asm/syscall.h
index 6ba0bf9..a08db5b 100644
--- a/arch/s390/include/asm/syscall.h
+++ b/arch/s390/include/asm/syscall.h
@@ -16,6 +16,7 @@
 #include <linux/sched.h>
 #include <linux/err.h>
 #include <asm/ptrace.h>
+#include <linux/compat.h>
 
 /*
  * The syscall table always contains 32 bit pointers since we know that the
diff --git a/arch/s390/kernel/Makefile b/arch/s390/kernel/Makefile
index 1f0fe98..6254eec 100644
--- a/arch/s390/kernel/Makefile
+++ b/arch/s390/kernel/Makefile
@@ -73,6 +73,7 @@ obj-$(CONFIG_COMPAT)		+= compat_wrapper.o $(compat-obj-y)
 obj-$(CONFIG_STACKTRACE)	+= stacktrace.o
 obj-$(CONFIG_KPROBES)		+= kprobes.o
 obj-$(CONFIG_FUNCTION_TRACER)	+= mcount.o ftrace.o
+obj-$(CONFIG_FTRACE_SYSCALLS)	+= ftrace.o
 obj-$(CONFIG_CRASH_DUMP)	+= crash_dump.o
 obj-$(CONFIG_UPROBES)		+= uprobes.o
 
diff --git a/arch/s390/kernel/ftrace.c b/arch/s390/kernel/ftrace.c
index 60a8a4e..3ce668e 100644
--- a/arch/s390/kernel/ftrace.c
+++ b/arch/s390/kernel/ftrace.c
@@ -243,3 +243,15 @@ int ftrace_disable_ftrace_graph_caller(void)
 }
 
 #endif /* CONFIG_FUNCTION_GRAPH_TRACER */
+
+#if (defined CONFIG_FTRACE_SYSCALLS) && (defined CONFIG_COMPAT)
+
+unsigned long __init arch_syscall_addr(int nr, bool compat)
+{
+	if (compat)
+		return (unsigned long)sys_call_table_emu[nr];
+
+	return (unsigned long)sys_call_table[nr];
+}
+
+#endif /* CONFIG_FTRACE_SYSCALLS && CONFIG_COMPAT */
-- 
2.7.4
