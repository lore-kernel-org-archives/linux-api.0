From: Sargun Dhillon <sargun@sargun.me>
Subject: [PATCH v2 2/4] ptrace: add PTRACE_GETFD request to fetch file
 descriptors from tracees
Date: Mon, 9 Dec 2019 07:06:24 +0000
Message-ID: <20191209070621.GA32450@ircssh-2.c.rugged-nimbus-611.internal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: tycho@tycho.ws, jannh@google.com, cyphar@cyphar.com, christian.brauner@ubuntu.com, oleg@redhat.com, luto@amacapital.net, viro@zeniv.linux.org.uk
List-Id: linux-api@vger.kernel.org

PTRACE_GETFD is a generic ptrace API that allows the tracer to
get file descriptors from the tracee.

One reason to use this is to allow sandboxers to take actions on file
descriptors on the behalf of a tracee. For example, this can be
combined with seccomp-bpf's user notification to ptrace on-demand and
capture an fd without requiring the tracer to always be attached to
the process. The tracer can then take a privileged action on behalf
of the tracee, like binding a socket to a privileged port.

It works whether or not the tracee is stopped. The only prior requirement
is that the tracer is attached to the process via PTRACE_ATTACH or
PTRACE_SEIZE. Stopping the process breaks certain runtimes that expect
to be able to preempt syscalls (quickly). In addition, it is meant to be
used in an on-demand fashion to avoid breaking debuggers.

The ptrace call takes a pointer to ptrace_getfd_args in data, and the
size of the structure in addr. There is an options field, which can
be used to state whether the fd should be opened with CLOEXEC, or not.
This options field may be extended in the future to include the ability
to clear cgroup information about the file descriptor at a later point.
If the structure is from a newer kernel, and includes members which
make it larger than the structure that's known to this kernel version,
E2BIG will be returned.

The requirement that the tracer has attached to the tracee prior to the
capture of the file descriptor may be lifted at a later point.

Signed-off-by: Sargun Dhillon <sargun@sargun.me>
---
 include/uapi/linux/ptrace.h | 15 +++++++++++++++
 kernel/ptrace.c             | 35 +++++++++++++++++++++++++++++++++--
 2 files changed, 48 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/ptrace.h b/include/uapi/linux/ptrace.h
index a71b6e3b03eb..c84655bcc453 100644
--- a/include/uapi/linux/ptrace.h
+++ b/include/uapi/linux/ptrace.h
@@ -101,6 +101,21 @@ struct ptrace_syscall_info {
 	};
 };
 
+/*
+ * This gets a file descriptor from a process. It requires that the process
+ * has either been attached to. It does not require that the process is
+ * stopped.
+ */
+#define PTRACE_GETFD	0x420f
+
+/* options to pass in to ptrace_getfd_args */
+#define PTRACE_GETFD_O_CLOEXEC	(1 << 0)	/* open the fd with cloexec */
+
+struct ptrace_getfd_args {
+	__u32 fd;	/* the tracee's file descriptor to get */
+	__u32 options;
+} __attribute__((packed));
+
 /*
  * These values are stored in task->ptrace_message
  * by tracehook_report_syscall_* to describe the current syscall-stop.
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index cb9ddcc08119..8f619dceac6f 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -31,6 +31,7 @@
 #include <linux/cn_proc.h>
 #include <linux/compat.h>
 #include <linux/sched/signal.h>
+#include <linux/fdtable.h>
 
 #include <asm/syscall.h>	/* for syscall_get_* */
 
@@ -994,6 +995,33 @@ ptrace_get_syscall_info(struct task_struct *child, unsigned long user_size,
 }
 #endif /* CONFIG_HAVE_ARCH_TRACEHOOK */
 
+static int ptrace_getfd(struct task_struct *child, unsigned long user_size,
+			void __user *datavp)
+{
+	struct ptrace_getfd_args args;
+	unsigned int fd_flags = 0;
+	struct file *file;
+	int ret;
+
+	ret = copy_struct_from_user(&args, sizeof(args), datavp, user_size);
+	if (ret)
+		goto out;
+	if ((args.options & ~(PTRACE_GETFD_O_CLOEXEC)) != 0)
+		return -EINVAL;
+	if (args.options & PTRACE_GETFD_O_CLOEXEC)
+		fd_flags &= O_CLOEXEC;
+	file = get_task_file(child, args.fd);
+	if (!file)
+		return -EBADF;
+	ret = get_unused_fd_flags(fd_flags);
+	if (ret >= 0)
+		fd_install(ret, file);
+	else
+		fput(file);
+out:
+	return ret;
+}
+
 int ptrace_request(struct task_struct *child, long request,
 		   unsigned long addr, unsigned long data)
 {
@@ -1222,7 +1250,9 @@ int ptrace_request(struct task_struct *child, long request,
 	case PTRACE_SECCOMP_GET_METADATA:
 		ret = seccomp_get_metadata(child, addr, datavp);
 		break;
-
+	case PTRACE_GETFD:
+		ret = ptrace_getfd(child, addr, datavp);
+		break;
 	default:
 		break;
 	}
@@ -1265,7 +1295,8 @@ SYSCALL_DEFINE4(ptrace, long, request, long, pid, unsigned long, addr,
 	}
 
 	ret = ptrace_check_attach(child, request == PTRACE_KILL ||
-				  request == PTRACE_INTERRUPT);
+				  request == PTRACE_INTERRUPT ||
+				  request == PTRACE_GETFD);
 	if (ret < 0)
 		goto out_put_task_struct;
 
-- 
2.20.1
