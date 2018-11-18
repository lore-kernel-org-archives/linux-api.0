From: Christian Brauner <christian@brauner.io>
Subject: [PATCH] proc: allow killing processes via file descriptors
Date: Sun, 18 Nov 2018 12:17:51 +0100
Message-ID: <20181118111751.6142-1-christian@brauner.io>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: ebiederm@xmission.com, linux-kernel@vger.kernel.org
Cc: serge@hallyn.com, jannh@google.com, luto@kernel.org, akpm@linux-foundation.org, oleg@redhat.com, cyphar@cyphar.com, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, dancol@google.com, timmurray@google.com, Christian Brauner <christian@brauner.io>, Kees Cook <keescook@chromium.org>
List-Id: linux-api@vger.kernel.org

With this patch an open() call on /proc/<pid> will give userspace a handle
to struct pid of the process associated with /proc/<pid>. This allows to
maintain a stable handle on a process.
I have been discussing various approaches extensively during technical
conferences this year culminating in a long argument with Eric at Linux
Plumbers. The general consensus was that having a handle on a process
will be something that is very simple and easy to maintain with the
option of being extensible via a more advanced api if the need arises. I
believe that this patch is the most simple, dumb, and therefore
maintainable solution.

The need for this has arisen in order to reliably kill a process without
running into issues of the pid being recycled as has been described in the
rejected patch [1]. To fulfill the need described in that patchset a new
ioctl() PROC_FD_SIGNAL is added. It can be used to send signals to a
process via a file descriptor:

int fd = open("/proc/1234", O_DIRECTORY | O_CLOEXEC);
ioctl(fd, PROC_FD_SIGNAL, SIGKILL);
close(fd);

Note, the stable handle will allow us to carefully extend this feature in
the future.

[1]: https://lkml.org/lkml/2018/10/30/118

Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Serge Hallyn <serge@hallyn.com>
Cc: Jann Horn <jannh@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Andy Lutomirsky <luto@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Aleksa Sarai <cyphar@cyphar.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Christian Brauner <christian@brauner.io>
---
 fs/proc/base.c              | 33 +++++++++++++++++++++++++++++++++
 include/uapi/linux/procfd.h | 11 +++++++++++
 2 files changed, 44 insertions(+)
 create mode 100644 include/uapi/linux/procfd.h

diff --git a/fs/proc/base.c b/fs/proc/base.c
index ce3465479447..dfde564a21eb 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -88,6 +88,7 @@
 #include <linux/fs_struct.h>
 #include <linux/slab.h>
 #include <linux/sched/autogroup.h>
+#include <linux/sched/signal.h>
 #include <linux/sched/mm.h>
 #include <linux/sched/coredump.h>
 #include <linux/sched/debug.h>
@@ -95,6 +96,7 @@
 #include <linux/flex_array.h>
 #include <linux/posix-timers.h>
 #include <trace/events/oom.h>
+#include <uapi/linux/procfd.h>
 #include "internal.h"
 #include "fd.h"
 
@@ -3032,10 +3034,41 @@ static int proc_tgid_base_readdir(struct file *file, struct dir_context *ctx)
 				   tgid_base_stuff, ARRAY_SIZE(tgid_base_stuff));
 }
 
+static int proc_tgid_open(struct inode *inode, struct file *file)
+{
+	/* grab reference to struct pid */
+	file->private_data = get_pid(proc_pid(inode));
+	return 0;
+}
+
+static int proc_tgid_release(struct inode *inode, struct file *file)
+{
+	struct pid *pid = file->private_data;
+	/* drop reference to struct pid */
+	put_pid(pid);
+	return 0;
+}
+
+static long proc_tgid_ioctl(struct file *file, unsigned int cmd,
+			    unsigned long arg)
+{
+	struct pid *pid = file->private_data;
+
+	switch (cmd) {
+	case PROC_FD_SIGNAL:
+		return kill_pid(pid, arg, 1);
+	default:
+		return -EINVAL;
+	}
+}
+
 static const struct file_operations proc_tgid_base_operations = {
+	.open		= proc_tgid_open,
 	.read		= generic_read_dir,
 	.iterate_shared	= proc_tgid_base_readdir,
 	.llseek		= generic_file_llseek,
+	.release	= proc_tgid_release,
+	.unlocked_ioctl	= proc_tgid_ioctl,
 };
 
 static struct dentry *proc_tgid_base_lookup(struct inode *dir, struct dentry *dentry, unsigned int flags)
diff --git a/include/uapi/linux/procfd.h b/include/uapi/linux/procfd.h
new file mode 100644
index 000000000000..8e4c07a9f3a3
--- /dev/null
+++ b/include/uapi/linux/procfd.h
@@ -0,0 +1,11 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+#ifndef __LINUX_PROCFD_H
+#define __LINUX_PROCFD_H
+
+#include <linux/ioctl.h>
+
+/* Returns a file descriptor that refers to a struct pid */
+#define PROC_FD_SIGNAL		_IOW('p', 1, __s32)
+
+#endif /* __LINUX_PROCFD_H */
+
-- 
2.19.1
