From: Marcin Nowakowski <marcin.nowakowski@imgtec.com>
Subject: [PATCH v3 10/11] sparc/tracing: fix compat syscall handling
Date: Tue, 11 Oct 2016 12:42:55 +0200
Message-ID: <1476182576-15247-11-git-send-email-marcin.nowakowski@imgtec.com>
References: <1476182576-15247-1-git-send-email-marcin.nowakowski@imgtec.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1476182576-15247-1-git-send-email-marcin.nowakowski@imgtec.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, luto@amacapital.net, rostedt@goodmis.org, Marcin Nowakowski <marcin.nowakowski@imgtec.com>, Ingo Molnar <mingo@redhat.com>, "David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Add missing arch code - arch_trace_is_compat_syscall and
arch_syscall_addr

Signed-off-by: Marcin Nowakowski <marcin.nowakowski@imgtec.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: sparclinux@vger.kernel.org
---
 arch/sparc/include/asm/ftrace.h | 10 ++++++++++
 arch/sparc/kernel/Makefile      |  1 +
 arch/sparc/kernel/ftrace.c      | 14 ++++++++++++++
 3 files changed, 25 insertions(+)

diff --git a/arch/sparc/include/asm/ftrace.h b/arch/sparc/include/asm/ftrace.h
index 62755a3..82e5269 100644
--- a/arch/sparc/include/asm/ftrace.h
+++ b/arch/sparc/include/asm/ftrace.h
@@ -6,6 +6,16 @@
 #define MCOUNT_INSN_SIZE	4 /* sizeof mcount call */
 
 #ifndef __ASSEMBLY__
+
+#if defined(CONFIG_FTRACE_SYSCALLS) && defined(CONFIG_COMPAT)
+#include <asm/compat.h>
+
+#define ARCH_COMPAT_SYSCALL_NUMBERS_OVERLAP 1
+static inline bool arch_trace_is_compat_syscall(struct pt_regs *regs)
+{
+	return in_compat_syscall();
+}
+#endif /* CONFIG_FTRACE_SYSCALLS && CONFIG_COMPAT */
 void _mcount(void);
 #endif
 
diff --git a/arch/sparc/kernel/Makefile b/arch/sparc/kernel/Makefile
index fa3c02d..7808084 100644
--- a/arch/sparc/kernel/Makefile
+++ b/arch/sparc/kernel/Makefile
@@ -93,6 +93,7 @@ obj-$(CONFIG_KGDB)        += kgdb_$(BITS).o
 
 obj-$(CONFIG_DYNAMIC_FTRACE) += ftrace.o
 obj-$(CONFIG_FUNCTION_GRAPH_TRACER) += ftrace.o
+obj-$(CONFIG_FTRACE_SYSCALLS) += ftrace.o
 
 obj-$(CONFIG_EARLYFB) += btext.o
 obj-$(CONFIG_STACKTRACE)     += stacktrace.o
diff --git a/arch/sparc/kernel/ftrace.c b/arch/sparc/kernel/ftrace.c
index 6bcff69..e76f012 100644
--- a/arch/sparc/kernel/ftrace.c
+++ b/arch/sparc/kernel/ftrace.c
@@ -145,3 +145,17 @@ unsigned long prepare_ftrace_return(unsigned long parent,
 	return return_hooker;
 }
 #endif /* CONFIG_FUNCTION_GRAPH_TRACER */
+
+#if (defined CONFIG_FTRACE_SYSCALLS) && (defined CONFIG_COMPAT)
+extern const unsigned int sys_call_table[];
+extern const unsigned int sys_call_table32[];
+
+unsigned long __init arch_syscall_addr(int nr, bool compat)
+{
+	if (compat)
+		return (unsigned long)sys_call_table32[nr];
+
+	return (unsigned long)sys_call_table[nr];
+}
+
+#endif /* CONFIG_FTRACE_SYSCALLS && CONFIG_COMPAT */
-- 
2.7.4
