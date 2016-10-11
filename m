From: Marcin Nowakowski <marcin.nowakowski@imgtec.com>
Subject: [PATCH v3 08/11] powerpc/tracing: fix compat syscall handling
Date: Tue, 11 Oct 2016 12:42:53 +0200
Message-ID: <1476182576-15247-9-git-send-email-marcin.nowakowski@imgtec.com>
References: <1476182576-15247-1-git-send-email-marcin.nowakowski@imgtec.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1476182576-15247-1-git-send-email-marcin.nowakowski@imgtec.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, luto@amacapital.net, rostedt@goodmis.org, Marcin Nowakowski <marcin.nowakowski@imgtec.com>, Ingo Molnar <mingo@redhat.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev@lists.ozlabs.org
List-Id: linux-api@vger.kernel.org

Adapt the code to make use of new syscall handling interface

Signed-off-by: Marcin Nowakowski <marcin.nowakowski@imgtec.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: linuxppc-dev@lists.ozlabs.org
---
 arch/powerpc/include/asm/ftrace.h | 11 +++++++++++
 arch/powerpc/kernel/ftrace.c      |  4 ++++
 2 files changed, 15 insertions(+)

diff --git a/arch/powerpc/include/asm/ftrace.h b/arch/powerpc/include/asm/ftrace.h
index 9697a73..d2ea3b6 100644
--- a/arch/powerpc/include/asm/ftrace.h
+++ b/arch/powerpc/include/asm/ftrace.h
@@ -86,6 +86,17 @@ static inline bool arch_syscall_match_sym_name(const char *sym, const char *name
 	return !strcmp(sym + prefix_len + 1, name + prefix_len);
 }
 #endif
+
+#if defined(CONFIG_COMPAT)
+#include <linux/compat.h>
+#include <asm/compat.h>
+
+#define ARCH_COMPAT_SYSCALL_NUMBERS_OVERLAP 1
+static inline bool arch_trace_is_compat_syscall(struct pt_regs *regs)
+{
+	return in_compat_syscall();
+}
+#endif /* CONFIG_COMPAT */
 #endif /* CONFIG_FTRACE_SYSCALLS && !__ASSEMBLY__ */
 
 #endif /* _ASM_POWERPC_FTRACE */
diff --git a/arch/powerpc/kernel/ftrace.c b/arch/powerpc/kernel/ftrace.c
index 5bfb35f..12c00f7 100644
--- a/arch/powerpc/kernel/ftrace.c
+++ b/arch/powerpc/kernel/ftrace.c
@@ -606,6 +606,10 @@ unsigned long prepare_ftrace_return(unsigned long parent, unsigned long ip)
 #if defined(CONFIG_FTRACE_SYSCALLS) && defined(CONFIG_PPC64)
 unsigned long __init arch_syscall_addr(int nr, bool compat)
 {
+#ifdef CONFIG_COMPAT
+	if (compat)
+		return sys_call_table[nr*2+1];
+#endif
 	return sys_call_table[nr*2];
 }
 #endif /* CONFIG_FTRACE_SYSCALLS && CONFIG_PPC64 */
-- 
2.7.4
