From: Marcin Nowakowski <marcin.nowakowski@imgtec.com>
Subject: [PATCH v4 05/12] tracing/syscalls: allow arch to override syscall_get_nr for ftrace
Date: Fri, 14 Oct 2016 10:35:08 +0200
Message-ID: <1476434115-25428-7-git-send-email-marcin.nowakowski@imgtec.com>
References: <1476434115-25428-1-git-send-email-marcin.nowakowski@imgtec.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1476434115-25428-1-git-send-email-marcin.nowakowski@imgtec.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, luto@amacapital.net, rostedt@goodmis.org, Marcin Nowakowski <marcin.nowakowski@imgtec.com>, Ingo Molnar <mingo@redhat.com>
List-Id: linux-api@vger.kernel.org

Some architectures modify syscall numbers to indicate ABI used
and as a result syscall number as returned by syscall_get_nr
does not correspond to the syscall number used inside the kernel.
Allow an arch to provide a separate implementation for ftrace
that returns the 'real' syscall number from the regs provided.

This will be used by x86 in a follow-up change.

Signed-off-by: Marcin Nowakowski <marcin.nowakowski@imgtec.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@redhat.com>
---
 kernel/trace/trace_syscalls.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 10c058f..24a26d3 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -78,7 +78,11 @@ static inline bool trace_is_compat_syscall(struct pt_regs *regs)
 static inline int
 trace_get_syscall_nr(struct task_struct *task, struct pt_regs *regs)
 {
+#ifdef arch_trace_syscall_get_nr
+	return arch_trace_syscall_get_nr(task, regs);
+#else
 	return syscall_get_nr(task, regs);
+#endif
 }
 
 
-- 
2.7.4
