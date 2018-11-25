From: Elvira Khabirova <lineprinter-u2l5PoMzF/Vg9hUCZPvPmw@public.gmane.org>
Subject: [PATCH RESEND v3 1/3] ptrace: pass type of a syscall-stop in
 ptrace_message
Date: Sun, 25 Nov 2018 02:22:27 +0100
Message-ID: <20181125022227.55e8caf7@akathisia>
References: <20181125022150.46258a20@akathisia>
Reply-To: strace development discussions <strace-devel-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <strace-devel-bounces-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org>
In-Reply-To: <20181125022150.46258a20@akathisia>
List-Unsubscribe: <https://lists.strace.io/mailman/options/strace-devel>,
 <mailto:strace-devel-request-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.strace.io/pipermail/strace-devel/>
List-Post: <mailto:strace-devel-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org>
List-Help: <mailto:strace-devel-request-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.strace.io/mailman/listinfo/strace-devel>,
 <mailto:strace-devel-request-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org?subject=subscribe>
Errors-To: strace-devel-bounces-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org
Sender: "Strace-devel" <strace-devel-bounces-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org>
To: oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, esyr-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, ldv-u2l5PoMzF/Vg9hUCZPvPmw@public.gmane.org, strace-devel-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org
List-Id: linux-api@vger.kernel.org

Define two constants, PTRACE_EVENTMSG_SYSCALL_ENTRY and
PTRACE_EVENTMSG_SYSCALL_EXIT, and place them in ptrace_message
for the duration of syscall-stops.
This way ptracers can distinguish syscall-enter-stops
from syscall-exit-stops using PTRACE_GETEVENTMSG request.

Signed-off-by: Elvira Khabirova <lineprinter-u2l5PoMzF/Vg9hUCZPvPmw@public.gmane.org>
Signed-off-by: Dmitry V. Levin <ldv-u2l5PoMzF/Vg9hUCZPvPmw@public.gmane.org>
---
 include/linux/tracehook.h   |  9 ++++++---
 include/uapi/linux/ptrace.h | 10 ++++++++++
 2 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/include/linux/tracehook.h b/include/linux/tracehook.h
index 40b0b4c1bf7b..633a83fe7051 100644
--- a/include/linux/tracehook.h
+++ b/include/linux/tracehook.h
@@ -57,13 +57,15 @@ struct linux_binprm;
 /*
  * ptrace report for syscall entry and exit looks identical.
  */
-static inline int ptrace_report_syscall(struct pt_regs *regs)
+static inline int ptrace_report_syscall(struct pt_regs *regs,
+					unsigned long message)
 {
 	int ptrace = current->ptrace;
 
 	if (!(ptrace & PT_PTRACED))
 		return 0;
 
+	current->ptrace_message = message;
 	ptrace_notify(SIGTRAP | ((ptrace & PT_TRACESYSGOOD) ? 0x80 : 0));
 
 	/*
@@ -76,6 +78,7 @@ static inline int ptrace_report_syscall(struct pt_regs *regs)
 		current->exit_code = 0;
 	}
 
+	current->ptrace_message = 0;
 	return fatal_signal_pending(current);
 }
 
@@ -101,7 +104,7 @@ static inline int ptrace_report_syscall(struct pt_regs *regs)
 static inline __must_check int tracehook_report_syscall_entry(
 	struct pt_regs *regs)
 {
-	return ptrace_report_syscall(regs);
+	return ptrace_report_syscall(regs, PTRACE_EVENTMSG_SYSCALL_ENTRY);
 }
 
 /**
@@ -126,7 +129,7 @@ static inline void tracehook_report_syscall_exit(struct pt_regs *regs, int step)
 	if (step)
 		user_single_step_report(regs);
 	else
-		ptrace_report_syscall(regs);
+		ptrace_report_syscall(regs, PTRACE_EVENTMSG_SYSCALL_EXIT);
 }
 
 /**
diff --git a/include/uapi/linux/ptrace.h b/include/uapi/linux/ptrace.h
index d5a1b8a492b9..cb138902d042 100644
--- a/include/uapi/linux/ptrace.h
+++ b/include/uapi/linux/ptrace.h
@@ -104,6 +104,16 @@ struct seccomp_metadata {
 #define PTRACE_O_MASK		(\
 	0x000000ff | PTRACE_O_EXITKILL | PTRACE_O_SUSPEND_SECCOMP)
 
+/*
+ * These values are stored in task->ptrace_message by tracehook_report_syscall_*
+ * to describe current syscall-stop.
+ *
+ * Values for these constants are chosen so that they do not appear
+ * in task->ptrace_message by other means.
+ */
+#define PTRACE_EVENTMSG_SYSCALL_ENTRY	0x80000000U
+#define PTRACE_EVENTMSG_SYSCALL_EXIT	0x90000000U
+
 #include <asm/ptrace.h>
 
 
-- 
2.19.1

-- 
Strace-devel mailing list
Strace-devel-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org
https://lists.strace.io/mailman/listinfo/strace-devel
