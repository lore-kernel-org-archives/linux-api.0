From: Sargun Dhillon <sargun@sargun.me>
Subject: [RFC PATCH] ptrace: add PTRACE_GETFD request
Date: Thu, 5 Dec 2019 23:44:53 +0000
Message-ID: <20191205234450.GA26369@ircssh-2.c.rugged-nimbus-611.internal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, linux-api@vger.kernel.org
Cc: tycho@tycho.ws
List-Id: linux-api@vger.kernel.org

PTRACE_GETFD is a generic ptrace API that allows the tracer to
get file descriptors from the traceee.

The primary reason to use this syscall is to allow sandboxers to
take action on an FD on behalf of the tracee. For example, this
can be combined with seccomp's user notification feature to extract
a file descriptor and call privileged syscalls, like binding
a socket to a privileged port.

Signed-off-by: Sargun Dhillon <sargun@sargun.me>
---
 include/uapi/linux/ptrace.h |  5 +++++
 kernel/ptrace.c             | 39 +++++++++++++++++++++++++++++++++++--
 2 files changed, 42 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/ptrace.h b/include/uapi/linux/ptrace.h
index a71b6e3b03eb..2b69f759826a 100644
--- a/include/uapi/linux/ptrace.h
+++ b/include/uapi/linux/ptrace.h
@@ -101,6 +101,11 @@ struct ptrace_syscall_info {
 	};
 };
 
+/* This gets a file descriptor from a running process. It doesn't require the
+ * process to be stopped.
+ */
+#define PTRACE_GETFD	0x420f
+
 /*
  * These values are stored in task->ptrace_message
  * by tracehook_report_syscall_* to describe the current syscall-stop.
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index cb9ddcc08119..a1d7b289fe8e 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -31,6 +31,7 @@
 #include <linux/cn_proc.h>
 #include <linux/compat.h>
 #include <linux/sched/signal.h>
+#include <linux/fdtable.h>
 
 #include <asm/syscall.h>	/* for syscall_get_* */
 
@@ -994,6 +995,37 @@ ptrace_get_syscall_info(struct task_struct *child, unsigned long user_size,
 }
 #endif /* CONFIG_HAVE_ARCH_TRACEHOOK */
 
+static int ptrace_getfd(struct task_struct *child, unsigned long fd)
+{
+	struct files_struct *files;
+	struct file *file;
+	int ret = 0;
+
+	files = get_files_struct(child);
+	if (!files)
+		return -ENOENT;
+
+	spin_lock(&files->file_lock);
+	file = fcheck_files(files, fd);
+	if (!file)
+		ret = -EBADF;
+	else
+		get_file(file);
+	spin_unlock(&files->file_lock);
+	put_files_struct(files);
+
+	if (ret)
+		goto out;
+
+	ret = get_unused_fd_flags(0);
+	if (ret >= 0)
+		fd_install(ret, file);
+
+	fput(file);
+out:
+	return ret;
+}
+
 int ptrace_request(struct task_struct *child, long request,
 		   unsigned long addr, unsigned long data)
 {
@@ -1222,7 +1254,9 @@ int ptrace_request(struct task_struct *child, long request,
 	case PTRACE_SECCOMP_GET_METADATA:
 		ret = seccomp_get_metadata(child, addr, datavp);
 		break;
-
+	case PTRACE_GETFD:
+		ret = ptrace_getfd(child, data);
+		break;
 	default:
 		break;
 	}
@@ -1265,7 +1299,8 @@ SYSCALL_DEFINE4(ptrace, long, request, long, pid, unsigned long, addr,
 	}
 
 	ret = ptrace_check_attach(child, request == PTRACE_KILL ||
-				  request == PTRACE_INTERRUPT);
+				  request == PTRACE_INTERRUPT ||
+				  request == PTRACE_GETFD);
 	if (ret < 0)
 		goto out_put_task_struct;
 
-- 
2.20.1
