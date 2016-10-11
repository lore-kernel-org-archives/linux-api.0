From: Marcin Nowakowski <marcin.nowakowski-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3 11/11] parisc/tracing: fix compat syscall handling
Date: Tue, 11 Oct 2016 12:42:56 +0200
Message-ID: <1476182576-15247-12-git-send-email-marcin.nowakowski@imgtec.com>
References: <1476182576-15247-1-git-send-email-marcin.nowakowski@imgtec.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1476182576-15247-1-git-send-email-marcin.nowakowski-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, Marcin Nowakowski <marcin.nowakowski-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "James E.J. Bottomley" <jejb-6jwH94ZQLHl74goWV3ctuw@public.gmane.org>, Helge Deller <deller-Mmb7MZpHnFY@public.gmane.org>, linux-parisc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Add missing arch code - arch_trace_is_compat_syscall and
arch_syscall_addr

Signed-off-by: Marcin Nowakowski <marcin.nowakowski-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org>
Cc: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "James E.J. Bottomley" <jejb-6jwH94ZQLHl74goWV3ctuw@public.gmane.org>
Cc: Helge Deller <deller-Mmb7MZpHnFY@public.gmane.org>
Cc: linux-parisc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
 arch/parisc/include/asm/ftrace.h | 10 ++++++++++
 arch/parisc/kernel/Makefile      |  1 +
 arch/parisc/kernel/ftrace.c      | 15 +++++++++++++++
 3 files changed, 26 insertions(+)

diff --git a/arch/parisc/include/asm/ftrace.h b/arch/parisc/include/asm/ftrace.h
index d635c6b..0b54385 100644
--- a/arch/parisc/include/asm/ftrace.h
+++ b/arch/parisc/include/asm/ftrace.h
@@ -12,6 +12,16 @@ extern unsigned long return_address(unsigned int);
 
 #define ftrace_return_address(n) return_address(n)
 
+#if defined(CONFIG_FTRACE_SYSCALLS) && defined(CONFIG_COMPAT)
+#include <linux/compat.h>
+
+#define ARCH_COMPAT_SYSCALL_NUMBERS_OVERLAP 1
+static inline bool arch_trace_is_compat_syscall(struct pt_regs *regs)
+{
+	return in_compat_syscall();
+}
+#endif /* CONFIG_FTRACE_SYSCALLS && CONFIG_COMPAT */
+
 #endif /* __ASSEMBLY__ */
 
 #endif /* _ASM_PARISC_FTRACE_H */
diff --git a/arch/parisc/kernel/Makefile b/arch/parisc/kernel/Makefile
index 69a1118..7d1fd39 100644
--- a/arch/parisc/kernel/Makefile
+++ b/arch/parisc/kernel/Makefile
@@ -31,3 +31,4 @@ obj64-$(CONFIG_AUDIT)	+= compat_audit.o
 obj-$(CONFIG_64BIT)	+= perf.o perf_asm.o $(obj64-y)
 obj-$(CONFIG_FUNCTION_TRACER)		+= ftrace.o
 obj-$(CONFIG_FUNCTION_GRAPH_TRACER)	+= ftrace.o
+obj-$(CONFIG_FTRACE_SYSCALLS)	+= ftrace.o
diff --git a/arch/parisc/kernel/ftrace.c b/arch/parisc/kernel/ftrace.c
index 5a5506a..41db7ca 100644
--- a/arch/parisc/kernel/ftrace.c
+++ b/arch/parisc/kernel/ftrace.c
@@ -56,6 +56,7 @@ static void __hot prepare_ftrace_return(unsigned long *parent,
 }
 #endif /* CONFIG_FUNCTION_GRAPH_TRACER */
 
+#ifdef CONFIG_FUNCTION_TRACER
 void notrace __hot ftrace_function_trampoline(unsigned long parent,
 				unsigned long self_addr,
 				unsigned long org_sp_gr3)
@@ -85,4 +86,18 @@ void notrace __hot ftrace_function_trampoline(unsigned long parent,
 	}
 #endif
 }
+#endif /* CONFIG_FUNCTION_TRACER */
+#if (defined CONFIG_FTRACE_SYSCALLS) && (defined CONFIG_64BIT)
+extern const unsigned int sys_call_table64[];
 
+unsigned long __init arch_syscall_addr(int nr, bool compat)
+{
+#ifdef CONFIG_COMPAT
+	if (compat)
+		return (unsigned long)sys_call_table[nr];
+#endif /* CONFIG_COMPAT */
+
+	return (unsigned long)sys_call_table64[nr];
+}
+
+#endif /* CONFIG_FTRACE_SYSCALLS && CONFIG_64BIT */
-- 
2.7.4
