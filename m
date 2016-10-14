From: Marcin Nowakowski <marcin.nowakowski-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v4 10/12] tile/tracing: fix compat syscall handling
Date: Fri, 14 Oct 2016 10:35:13 +0200
Message-ID: <1476434115-25428-12-git-send-email-marcin.nowakowski@imgtec.com>
References: <1476434115-25428-1-git-send-email-marcin.nowakowski@imgtec.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1476434115-25428-1-git-send-email-marcin.nowakowski-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, Marcin Nowakowski <marcin.nowakowski-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Chris Metcalf <cmetcalf-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Add missing arch code - arch_trace_is_compat_syscall and
arch_syscall_addr

Signed-off-by: Marcin Nowakowski <marcin.nowakowski-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org>
Cc: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Chris Metcalf <cmetcalf-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 arch/tile/include/asm/ftrace.h | 10 ++++++++++
 arch/tile/kernel/Makefile      |  1 +
 arch/tile/kernel/ftrace.c      | 13 +++++++++++++
 3 files changed, 24 insertions(+)

diff --git a/arch/tile/include/asm/ftrace.h b/arch/tile/include/asm/ftrace.h
index 738d239..e4fc08f 100644
--- a/arch/tile/include/asm/ftrace.h
+++ b/arch/tile/include/asm/ftrace.h
@@ -35,6 +35,16 @@ struct dyn_arch_ftrace {
 };
 #endif /*  CONFIG_DYNAMIC_FTRACE */
 
+#if defined(CONFIG_FTRACE_SYSCALLS) && defined(CONFIG_COMPAT)
+#include <asm/compat.h>
+
+#define ARCH_COMPAT_SYSCALL_NUMBERS_OVERLAP 1
+static inline bool arch_trace_is_compat_syscall(struct pt_regs *regs)
+{
+	return is_compat_task();
+}
+#endif /* CONFIG_FTRACE_SYSCALLS && CONFIG_COMPAT */
+
 #endif /* __ASSEMBLY__ */
 
 #endif /* CONFIG_FUNCTION_TRACER */
diff --git a/arch/tile/kernel/Makefile b/arch/tile/kernel/Makefile
index 09936d0..4de0989 100644
--- a/arch/tile/kernel/Makefile
+++ b/arch/tile/kernel/Makefile
@@ -30,6 +30,7 @@ obj-$(CONFIG_USE_PMC)		+= pmc.o
 obj-$(CONFIG_TILE_USB)		+= usb.o
 obj-$(CONFIG_TILE_HVGLUE_TRACE)	+= hvglue_trace.o
 obj-$(CONFIG_FUNCTION_TRACER)	+= ftrace.o mcount_64.o
+obj-$(CONFIG_FTRACE_SYSCALLS)	+= ftrace.o
 obj-$(CONFIG_KPROBES)		+= kprobes.o
 obj-$(CONFIG_KGDB)		+= kgdb.o
 obj-$(CONFIG_JUMP_LABEL)	+= jump_label.o
diff --git a/arch/tile/kernel/ftrace.c b/arch/tile/kernel/ftrace.c
index b827a41..61768f3 100644
--- a/arch/tile/kernel/ftrace.c
+++ b/arch/tile/kernel/ftrace.c
@@ -21,6 +21,7 @@
 #include <asm/ftrace.h>
 #include <asm/sections.h>
 #include <asm/insn.h>
+#include <asm/syscall.h>
 
 #include <arch/opcode.h>
 
@@ -237,3 +238,15 @@ int ftrace_disable_ftrace_graph_caller(void)
 }
 #endif /* CONFIG_DYNAMIC_FTRACE */
 #endif /* CONFIG_FUNCTION_GRAPH_TRACER */
+
+#if (defined CONFIG_FTRACE_SYSCALLS) && (defined CONFIG_COMPAT)
+
+unsigned long __init arch_syscall_addr(int nr, bool compat)
+{
+	if (compat)
+		return (unsigned long)compat_sys_call_table[nr];
+
+	return (unsigned long)sys_call_table[nr];
+}
+
+#endif /* CONFIG_FTRACE_SYSCALLS && CONFIG_COMPAT */
-- 
2.7.4
