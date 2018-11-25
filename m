From: Elvira Khabirova <lineprinter-u2l5PoMzF/Vg9hUCZPvPmw@public.gmane.org>
Subject: [PATCH RESEND v3 2/3] ptrace: add PTRACE_GET_SYSCALL_INFO request
Date: Sun, 25 Nov 2018 02:23:04 +0100
Message-ID: <20181125022304.3840b289@akathisia>
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

PTRACE_GET_SYSCALL_INFO lets ptracer obtain details of the syscall
the tracee is blocked in.  The request succeeds when the tracee is in a
syscall-enter-stop or syscall-exit-stop, and fails with -EINVAL otherwise.
A subsequent change may extend PTRACE_GET_SYSCALL_INFO for the case
of PTRACE_EVENT_SECCOMP stop.

There are two reasons for a special syscall-related ptrace request.

Firstly, with the current ptrace API there are cases when ptracer cannot
retrieve necessary information about syscalls.  Some examples include:
* The notorious int-0x80-from-64-bit-task issue.  See [1] for details.
In short, if a 64-bit task performs a syscall through int 0x80, its tracer
has no reliable means to find out that the syscall was, in fact,
a compat syscall, and misidentifies it.
* Syscall-enter-stop and syscall-exit-stop look the same for the tracer.
Common practice is to keep track of the sequence of ptrace-stops in order
not to mix the two syscall-stops up.  But it is not as simple as it looks;
for example, strace had a (just recently fixed) long-standing bug where
attaching strace to a tracee that is performing the execve system call
led to the tracer identifying the following syscall-exit-stop as
syscall-enter-stop, which messed up all the state tracking.
* Since the introduction of commit 84d77d3f06e7e8dea057d10e8ec77ad71f721be3
("ptrace: Don't allow accessing an undumpable mm"), both PTRACE_PEEKDATA
and process_vm_readv become unavailable when the process dumpable flag
is cleared.  On such architectures as ia64 this results in all syscall
arguments being unavailable.

Secondly, ptracers also have to support a lot of arch-specific code for
obtaining information about the tracee.  For some architectures, this
requires a ptrace(PTRACE_PEEKUSER, ...) invocation for every syscall
argument and return value.

ptrace(2) man page:

long ptrace(enum __ptrace_request request, pid_t pid,
            void *addr, void *data);
...
PTRACE_GET_SYSCALL_INFO
       Retrieve information about the syscall that caused the stop.
       The information is placed into the buffer pointed by "data"
       argument, which should be a pointer to a buffer of type
       "struct ptrace_syscall_info".
       The "addr" argument contains the size of the buffer pointed to
       by "data" (i.e., sizeof(struct ptrace_syscall_info)).
       The return value contains the number of bytes available
       to be written by the kernel.
       If the size of data to be written by the kernel exceeds the size
       specified by "addr" argument, the output is truncated.
       This operation fails with EINVAL if the tracee is not
       in a syscall-enter-stop, a syscall-exit-stop, or
       a PTRACE_EVENT_SECCOMP stop.

Signed-off-by: Elvira Khabirova <lineprinter-u2l5PoMzF/Vg9hUCZPvPmw@public.gmane.org>
Signed-off-by: Dmitry V. Levin <ldv-u2l5PoMzF/Vg9hUCZPvPmw@public.gmane.org>
---
 include/uapi/linux/ptrace.h | 24 ++++++++++++++++++
 kernel/ptrace.c             | 50 +++++++++++++++++++++++++++++++++++++
 2 files changed, 74 insertions(+)

diff --git a/include/uapi/linux/ptrace.h b/include/uapi/linux/ptrace.h
index cb138902d042..49b0b1b41943 100644
--- a/include/uapi/linux/ptrace.h
+++ b/include/uapi/linux/ptrace.h
@@ -73,6 +73,30 @@ struct seccomp_metadata {
 	__u64 flags;		/* Output: filter's flags */
 };
 
+#define PTRACE_GET_SYSCALL_INFO		0x420f
+#define PTRACE_SYSCALL_INFO_ENTRY	0
+#define PTRACE_SYSCALL_INFO_EXIT	1
+
+struct ptrace_syscall_info {
+	__u8 op;	/* PTRACE_SYSCALL_INFO_* */
+	__u8 __pad0[3];
+	__u32 arch;
+	union {
+		struct {
+			__u64 nr;
+			__u64 instruction_pointer;
+			__u64 stack_pointer;
+			__u64 frame_pointer;
+			__u64 args[6];
+		} entry;
+		struct {
+			__s64 rval;
+			__u8 is_error;
+			__u8 __pad1[7];
+		} exit;
+	};
+};
+
 /* Read signals from a shared (process wide) queue */
 #define PTRACE_PEEKSIGINFO_SHARED	(1 << 0)
 
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 80b34dffdfb9..92c47cd5ad84 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -30,6 +30,10 @@
 #include <linux/cn_proc.h>
 #include <linux/compat.h>
 
+#ifdef CONFIG_HAVE_ARCH_TRACEHOOK
+#include <asm/syscall.h>	/* For syscall_get_* */
+#endif
+
 /*
  * Access another process' address space via ptrace.
  * Source/target buffer must be kernel space,
@@ -890,6 +894,46 @@ static int ptrace_regset(struct task_struct *task, int req, unsigned int type,
 EXPORT_SYMBOL_GPL(task_user_regset_view);
 #endif
 
+#ifdef CONFIG_HAVE_ARCH_TRACEHOOK
+static int ptrace_get_syscall(struct task_struct *child,
+			      unsigned long user_size, void __user *datavp)
+{
+	struct ptrace_syscall_info info;
+	struct pt_regs *regs = task_pt_regs(child);
+	unsigned long args[ARRAY_SIZE(info.entry.args)];
+	unsigned long actual_size;
+	unsigned long write_size;
+
+	if (child->ptrace_message == PTRACE_EVENTMSG_SYSCALL_ENTRY) {
+		int i;
+
+		info.op = PTRACE_SYSCALL_INFO_ENTRY;
+		info.arch = syscall_get_arch(child);
+		info.entry.nr = syscall_get_nr(child, regs);
+		info.entry.instruction_pointer = instruction_pointer(regs);
+		info.entry.stack_pointer = user_stack_pointer(regs);
+		info.entry.frame_pointer = frame_pointer(regs);
+		syscall_get_arguments(child, regs, 0, ARRAY_SIZE(args), args);
+		for (i = 0; i < ARRAY_SIZE(args); i++)
+			info.entry.args[i] = args[i];
+		actual_size = offsetofend(struct ptrace_syscall_info, entry);
+	} else if (child->ptrace_message == PTRACE_EVENTMSG_SYSCALL_EXIT) {
+		info.op = PTRACE_SYSCALL_INFO_EXIT;
+		info.arch = syscall_get_arch(child);
+		info.exit.rval = syscall_get_error(child, regs);
+		info.exit.is_error = !!info.exit.rval;
+		if (!info.exit.is_error)
+			info.exit.rval = syscall_get_return_value(child, regs);
+		actual_size = offsetofend(struct ptrace_syscall_info, exit);
+	} else {
+		return -EINVAL;
+	}
+
+	write_size = min(actual_size, user_size);
+	return copy_to_user(datavp, &info, write_size) ? -EFAULT : actual_size;
+}
+#endif
+
 int ptrace_request(struct task_struct *child, long request,
 		   unsigned long addr, unsigned long data)
 {
@@ -1105,6 +1149,12 @@ int ptrace_request(struct task_struct *child, long request,
 		ret = seccomp_get_metadata(child, addr, datavp);
 		break;
 
+#ifdef CONFIG_HAVE_ARCH_TRACEHOOK
+	case PTRACE_GET_SYSCALL_INFO:
+		ret = ptrace_get_syscall(child, addr, datavp);
+		break;
+#endif
+
 	default:
 		break;
 	}
-- 
2.19.1

-- 
Strace-devel mailing list
Strace-devel-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org
https://lists.strace.io/mailman/listinfo/strace-devel
