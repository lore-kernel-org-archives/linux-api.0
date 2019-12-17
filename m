From: Sargun Dhillon <sargun@sargun.me>
Subject: [PATCH v3 2/4] pid: Add PIDFD_IOCTL_GETFD to fetch file descriptors
 from processes
Date: Tue, 17 Dec 2019 01:00:04 +0000
Message-ID: <20191217010001.GA14461@ircssh-2.c.rugged-nimbus-611.internal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: tycho@tycho.ws, jannh@google.com, cyphar@cyphar.com, christian.brauner@ubuntu.com, oleg@redhat.com, luto@amacapital.net, viro@zeniv.linux.org.uk, gpascutto@mozilla.com, ealvarez@mozilla.com, fweimer@redhat.com, jld@mozilla.com
List-Id: linux-api@vger.kernel.org

This adds an ioctl which allows file descriptors to be extracted
from processes based on their pidfd.

One reason to use this is to allow sandboxers to take actions on file
descriptors on the behalf of another process. For example, this can be
combined with seccomp-bpf's user notification to do on-demand fd
extraction and take privileged actions. For example, it can be used
to bind a socket to a privileged port. This is similar to ptrace, and
using ptrace parasitic code injection to extract a file descriptor from a
process, but without breaking debuggers, or paying the ptrace overhead
cost.

You must have the ability to ptrace the process in order to extract any
file descriptors from it. ptrace can already be used to extract file
descriptors based on parasitic code injections, so the permissions
model is aligned.

The ioctl takes a pointer to pidfd_getfd_args. pidfd_getfd_args contains
a size, which allows for gradual evolution of the API. There is an options
field, which can be used to state whether the fd should be opened with
CLOEXEC, or not. An additional options field may be added in the future
to include the ability to clear cgroup information about the file
descriptor at a later point. If the structure is from a newer kernel, and
includes members which make it larger than the structure that's known to
this kernel version, E2BIG will be returned.

Signed-off-by: Sargun Dhillon <sargun@sargun.me>
---
 Documentation/ioctl/ioctl-number.rst |  1 +
 include/linux/pid.h                  |  1 +
 include/uapi/linux/pid.h             | 26 ++++++++++
 kernel/fork.c                        | 72 ++++++++++++++++++++++++++++
 4 files changed, 100 insertions(+)
 create mode 100644 include/uapi/linux/pid.h

diff --git a/Documentation/ioctl/ioctl-number.rst b/Documentation/ioctl/ioctl-number.rst
index bef79cd4c6b4..be2efb93acd1 100644
--- a/Documentation/ioctl/ioctl-number.rst
+++ b/Documentation/ioctl/ioctl-number.rst
@@ -272,6 +272,7 @@ Code  Seq#    Include File                                           Comments
                                                                      <mailto:tim@cyberelk.net>
 'p'   A1-A5  linux/pps.h                                             LinuxPPS
                                                                      <mailto:giometti@linux.it>
+'p'   B0-CF  uapi/linux/pid.h
 'q'   00-1F  linux/serio.h
 'q'   80-FF  linux/telephony.h                                       Internet PhoneJACK, Internet LineJACK
              linux/ixjuser.h                                         <http://web.archive.org/web/%2A/http://www.quicknet.net>
diff --git a/include/linux/pid.h b/include/linux/pid.h
index 9645b1194c98..65f1a73040c9 100644
--- a/include/linux/pid.h
+++ b/include/linux/pid.h
@@ -5,6 +5,7 @@
 #include <linux/rculist.h>
 #include <linux/wait.h>
 #include <linux/refcount.h>
+#include <uapi/linux/pid.h>
 
 enum pid_type
 {
diff --git a/include/uapi/linux/pid.h b/include/uapi/linux/pid.h
new file mode 100644
index 000000000000..4ec02ed8b39a
--- /dev/null
+++ b/include/uapi/linux/pid.h
@@ -0,0 +1,26 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+#ifndef _UAPI_LINUX_PID_H
+#define _UAPI_LINUX_PID_H
+
+#include <linux/types.h>
+#include <linux/ioctl.h>
+
+/* options to pass in to pidfd_getfd_args flags */
+#define PIDFD_GETFD_CLOEXEC (1 << 0)	/* open the fd with cloexec */
+
+struct pidfd_getfd_args {
+	__u32 size;		/* sizeof(pidfd_getfd_args) */
+	__u32 fd;       /* the tracee's file descriptor to get */
+	__u32 flags;
+};
+
+#define PIDFD_IOC_MAGIC			'p'
+#define PIDFD_IO(nr)			_IO(PIDFD_IOC_MAGIC, nr)
+#define PIDFD_IOR(nr, type)		_IOR(PIDFD_IOC_MAGIC, nr, type)
+#define PIDFD_IOW(nr, type)		_IOW(PIDFD_IOC_MAGIC, nr, type)
+#define PIDFD_IOWR(nr, type)		_IOWR(PIDFD_IOC_MAGIC, nr, type)
+
+#define PIDFD_IOCTL_GETFD		PIDFD_IOWR(0xb0, \
+						struct pidfd_getfd_args)
+
+#endif /* _UAPI_LINUX_PID_H */
diff --git a/kernel/fork.c b/kernel/fork.c
index 6cabc124378c..d9971e664e82 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1726,9 +1726,81 @@ static __poll_t pidfd_poll(struct file *file, struct poll_table_struct *pts)
 	return poll_flags;
 }
 
+static long pidfd_getfd(struct pid *pid, struct pidfd_getfd_args __user *buf)
+{
+	struct pidfd_getfd_args args;
+	unsigned int fd_flags = 0;
+	struct task_struct *task;
+	struct file *file;
+	u32 user_size;
+	int ret, fd;
+
+	ret = get_user(user_size, &buf->size);
+	if (ret)
+		return ret;
+
+	ret = copy_struct_from_user(&args, sizeof(args), buf, user_size);
+	if (ret)
+		return ret;
+	if ((args.flags & ~(PIDFD_GETFD_CLOEXEC)) != 0)
+		return -EINVAL;
+	if (args.flags & PIDFD_GETFD_CLOEXEC)
+		fd_flags |= O_CLOEXEC;
+
+	task = get_pid_task(pid, PIDTYPE_PID);
+	if (!task)
+		return -ESRCH;
+	ret = -EPERM;
+	if (!ptrace_may_access(task, PTRACE_MODE_READ_REALCREDS))
+		goto out;
+	ret = -EBADF;
+	file = fget_task(task, args.fd);
+	if (!file)
+		goto out;
+
+	fd = get_unused_fd_flags(fd_flags);
+	if (fd < 0) {
+		ret = fd;
+		goto out_put_file;
+	}
+	/*
+	 * security_file_receive must come last since it may have side effects
+	 * and cannot be reversed.
+	 */
+	ret = security_file_receive(file);
+	if (ret)
+		goto out_put_fd;
+
+	fd_install(fd, file);
+	put_task_struct(task);
+	return fd;
+
+out_put_fd:
+	put_unused_fd(fd);
+out_put_file:
+	fput(file);
+out:
+	put_task_struct(task);
+	return ret;
+}
+
+static long pidfd_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	struct pid *pid = file->private_data;
+	void __user *buf = (void __user *)arg;
+
+	switch (cmd) {
+	case PIDFD_IOCTL_GETFD:
+		return pidfd_getfd(pid, buf);
+	default:
+		return -EINVAL;
+	}
+}
+
 const struct file_operations pidfd_fops = {
 	.release = pidfd_release,
 	.poll = pidfd_poll,
+	.unlocked_ioctl = pidfd_ioctl,
 #ifdef CONFIG_PROC_FS
 	.show_fdinfo = pidfd_show_fdinfo,
 #endif
-- 
2.20.1
