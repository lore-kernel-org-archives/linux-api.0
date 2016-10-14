From: Marcin Nowakowski <marcin.nowakowski-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v4 11/12] sparc/tracing: fix compat syscall handling
Date: Fri, 14 Oct 2016 10:35:14 +0200
Message-ID: <1476434115-25428-13-git-send-email-marcin.nowakowski@imgtec.com>
References: <1476434115-25428-1-git-send-email-marcin.nowakowski@imgtec.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1476434115-25428-1-git-send-email-marcin.nowakowski-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, Marcin Nowakowski <marcin.nowakowski-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, sparclinux-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Add missing arch code - arch_trace_is_compat_syscall and
arch_syscall_addr

Signed-off-by: Marcin Nowakowski <marcin.nowakowski-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org>
Cc: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Cc: sparclinux-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
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
