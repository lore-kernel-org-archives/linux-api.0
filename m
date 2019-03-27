From: Christian Brauner <christian@brauner.io>
Subject: [PATCH 2/4] pid: add pidfd_open()
Date: Wed, 27 Mar 2019 17:21:45 +0100
Message-ID: <20190327162147.23198-3-christian@brauner.io>
References: <20190327162147.23198-1-christian@brauner.io>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190327162147.23198-1-christian@brauner.io>
Sender: linux-kernel-owner@vger.kernel.org
To: jannh@google.com, khlebnikov@yandex-team.ru, luto@kernel.org, dhowells@redhat.com, serge@hallyn.com, ebiederm@xmission.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, keescook@chromium.org, adobriyan@gmail.com, tglx@linutronix.de, mtk.manpages@gmail.com, bl0pbl33p@gmail.com, ldv@altlinux.org, akpm@linux-foundation.org, oleg@redhat.com, nagarathnam.muthusamy@oracle.com, cyphar@cyphar.com, viro@zeniv.linux.org.uk, joel@joelfernandes.org, dancol@google.com, Christian Brauner <christian@brauner.io>
List-Id: linux-api@vger.kernel.org

pidfd_open() allows to retrieve pidfds for processes and removes the
dependency of pidfd on procfs. Multiple people have expressed a desire to
do this even when pidfd_send_signal() was merged. It is even recorded in
the commit message for pidfd_send_signal() itself
(cf. commit 3eb39f47934f9d5a3027fe00d906a45fe3a15fad):
Q-06: (Andrew Morton [1])
      Is there a cleaner way of obtaining the fd? Another syscall perhaps.
A-06: Userspace can already trivially retrieve file descriptors from procfs
      so this is something that we will need to support anyway. Hence,
      there's no immediate need to add another syscalls just to make
      pidfd_send_signal() not dependent on the presence of procfs. However,
      adding a syscalls to get such file descriptors is planned for a
      future patchset (cf. [1]).
Alexey made a similar request (cf. [2]). Additionally, Andy made an
argument that we should go forward with non-proc-dirfd file descriptors for
the sake of security and extensibility (cf. [3]).
This will unblock or help move along work on pidfd_wait which is currently
ongoing.

/* pidfds are anon inode file descriptors */
These pidfds are allocated using anon_inode_getfd(), are O_CLOEXEC by
default and can be used with the pidfd_send_signal() syscall. They are not
dirfds and as such have the advantage that we can make them pollable or
readable in the future if we see a need to do so. Currently they do not
support any advanced operations. The pidfds are not associated with a
specific pid namespaces but rather only reference struct pid of a given
process in their private_data member.

/* Process Metadata Access */
One of the oustanding issues has been how to get information about a given
process if pidfds are regular file descriptors and do not provide access to
the process /proc/<pid> directory.
Various solutions have been proposed. The one that most people prefer is to
be able to retrieve a file descriptor to /proc/<pid> based on a pidfd (and
the other way around).
IF PROCFD_TO_PIDFD is passed as a flag together with a file descriptor to a
/proc mount in a given pid namespace and a pidfd pidfd_open() will return a
file descriptor to the corresponding /proc/<pid> directory in procfs
mounts' pid namespace. pidfd_open() is very careful to verify that the pid
hasn't been recycled in between.
IF PIDFD_TO_PROCFD is passed as a flag together with a file descriptor
referencing a /proc/<pid> directory a pidfd referencing the struct pid
stashed in /proc/<pid> of the process will be returned.
The pidfd_open() syscalls in that manner resembles openat() as it uses a
flag argument to modify what type of file descriptor will be returned.

The pidfd_open() implementation together with the flags argument strikes me
as an elegant compromise between splitting this into multiple syscalls and
avoiding ioctls().

/* Examples */
// Retrieve pidfd
int pidfd = pidfd_open(1234, -1, -1, 0);

// Retrieve /proc/<pid> handle for pidfd
int procfd = open("/proc", O_DIRECTORY | O_RDONLY | O_CLOEXEC);
int procpidfd = pidfd_open(-1, procfd, pidfd, PIDFD_TO_PROCFD);

// Retrieve pidfd for /proc/<pid>
int procpidfd = open("/proc/1234", O_DIRECTORY | O_RDONLY | O_CLOEXEC);
int pidfd = pidfd_open(-1, procpidfd, -1, PROCFD_TO_PIDFD);

/* References */
[1]: https://lore.kernel.org/lkml/20181228233725.722tdfgijxcssg76@brauner.io/
[2]: https://lore.kernel.org/lkml/20190320203910.GA2842@avx2/
[3]: https://lore.kernel.org/lkml/CALCETrXO=V=+qEdLDVPf8eCgLZiB9bOTrUfe0V-U-tUZoeoRDA@mail.gmail.com

Signed-off-by: Christian Brauner <christian@brauner.io>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Serge Hallyn <serge@hallyn.com>
Cc: Jann Horn <jannh@google.com
Cc: David Howells <dhowells@redhat.com>
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: Jonathan Kowalski <bl0pbl33p@gmail.com>
Cc: "Dmitry V. Levin" <ldv@altlinux.org>
Cc: Andy Lutomirsky <luto@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Nagarathnam Muthusamy <nagarathnam.muthusamy@oracle.com>
Cc: Aleksa Sarai <cyphar@cyphar.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/x86/entry/syscalls/syscall_32.tbl |   1 +
 arch/x86/entry/syscalls/syscall_64.tbl |   1 +
 include/linux/pid.h                    |   2 +
 include/linux/syscalls.h               |   2 +
 include/uapi/linux/wait.h              |   3 +
 kernel/pid.c                           | 247 +++++++++++++++++++++++++
 6 files changed, 256 insertions(+)

diff --git a/arch/x86/entry/syscalls/syscall_32.tbl b/arch/x86/entry/syscalls/syscall_32.tbl
index 1f9607ed087c..c8046f261bee 100644
--- a/arch/x86/entry/syscalls/syscall_32.tbl
+++ b/arch/x86/entry/syscalls/syscall_32.tbl
@@ -433,3 +433,4 @@
 425	i386	io_uring_setup		sys_io_uring_setup		__ia32_sys_io_uring_setup
 426	i386	io_uring_enter		sys_io_uring_enter		__ia32_sys_io_uring_enter
 427	i386	io_uring_register	sys_io_uring_register		__ia32_sys_io_uring_register
+428	i386	pidfd_open		sys_pidfd_open			__ia32_sys_pidfd_open
diff --git a/arch/x86/entry/syscalls/syscall_64.tbl b/arch/x86/entry/syscalls/syscall_64.tbl
index 92ee0b4378d4..f714a3d57b88 100644
--- a/arch/x86/entry/syscalls/syscall_64.tbl
+++ b/arch/x86/entry/syscalls/syscall_64.tbl
@@ -349,6 +349,7 @@
 425	common	io_uring_setup		__x64_sys_io_uring_setup
 426	common	io_uring_enter		__x64_sys_io_uring_enter
 427	common	io_uring_register	__x64_sys_io_uring_register
+428	common	pidfd_open		__x64_sys_pidfd_open
 
 #
 # x32-specific system call numbers start at 512 to avoid cache impact
diff --git a/include/linux/pid.h b/include/linux/pid.h
index b6f4ba16065a..3c8ef5a199ca 100644
--- a/include/linux/pid.h
+++ b/include/linux/pid.h
@@ -66,6 +66,8 @@ struct pid
 
 extern struct pid init_struct_pid;
 
+extern const struct file_operations pidfd_fops;
+
 static inline struct pid *get_pid(struct pid *pid)
 {
 	if (pid)
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index e446806a561f..79b274698036 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -929,6 +929,8 @@ asmlinkage long sys_clock_adjtime32(clockid_t which_clock,
 				struct old_timex32 __user *tx);
 asmlinkage long sys_syncfs(int fd);
 asmlinkage long sys_setns(int fd, int nstype);
+asmlinkage long sys_pidfd_open(pid_t pid, int procfd, int pidfd,
+			       unsigned int flags);
 asmlinkage long sys_sendmmsg(int fd, struct mmsghdr __user *msg,
 			     unsigned int vlen, unsigned flags);
 asmlinkage long sys_process_vm_readv(pid_t pid,
diff --git a/include/uapi/linux/wait.h b/include/uapi/linux/wait.h
index ac49a220cf2a..8282fc19d8f6 100644
--- a/include/uapi/linux/wait.h
+++ b/include/uapi/linux/wait.h
@@ -18,5 +18,8 @@
 #define P_PID		1
 #define P_PGID		2
 
+/* Flags for pidfd_open */
+#define PIDFD_TO_PROCFD 1 /* retrieve file descriptor to /proc/<pid> for pidfd */
+#define PROCFD_TO_PIDFD 2 /* retrieve pidfd for /proc/<pid> */
 
 #endif /* _UAPI_LINUX_WAIT_H */
diff --git a/kernel/pid.c b/kernel/pid.c
index 20881598bdfa..c9e24e726aba 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -26,8 +26,10 @@
  *
  */
 
+#include <linux/anon_inodes.h>
 #include <linux/mm.h>
 #include <linux/export.h>
+#include <linux/fsnotify.h>
 #include <linux/slab.h>
 #include <linux/init.h>
 #include <linux/rculist.h>
@@ -40,6 +42,7 @@
 #include <linux/proc_fs.h>
 #include <linux/sched/task.h>
 #include <linux/idr.h>
+#include <linux/wait.h>
 
 struct pid init_struct_pid = {
 	.count 		= ATOMIC_INIT(1),
@@ -451,6 +454,250 @@ struct pid *find_ge_pid(int nr, struct pid_namespace *ns)
 	return idr_get_next(&ns->idr, &nr);
 }
 
+static int pidfd_release(struct inode *inode, struct file *file)
+{
+	struct pid *pid = file->private_data;
+
+	if (pid) {
+		file->private_data = NULL;
+		put_pid(pid);
+	}
+
+	return 0;
+}
+
+const struct file_operations pidfd_fops = {
+	.release = pidfd_release,
+};
+
+static int pidfd_create_fd(struct pid *pid, unsigned int o_flags)
+{
+	int fd;
+
+	fd = anon_inode_getfd("pidfd", &pidfd_fops, get_pid(pid), O_RDWR | o_flags);
+	if (fd < 0)
+		put_pid(pid);
+
+	return fd;
+}
+
+#ifdef CONFIG_PROC_FS
+static struct pid_namespace *pidfd_get_proc_pid_ns(const struct file *file)
+{
+	struct inode *inode;
+	struct super_block *sb;
+
+	inode = file_inode(file);
+	sb = inode->i_sb;
+	if (sb->s_magic != PROC_SUPER_MAGIC)
+		return ERR_PTR(-EINVAL);
+
+	if (inode->i_ino != PROC_ROOT_INO)
+		return ERR_PTR(-EINVAL);
+
+	return get_pid_ns(inode->i_sb->s_fs_info);
+}
+
+static struct pid *pidfd_get_pid(const struct file *file)
+{
+	if (file->f_op != &pidfd_fops)
+		return ERR_PTR(-EINVAL);
+
+	return get_pid(file->private_data);
+}
+
+static struct file *pidfd_open_proc_pid(const struct file *procf, pid_t pid,
+					const struct pid *pidfd_pid)
+{
+	char name[11]; /* int to strlen + \0 */
+	struct file *file;
+	struct pid *proc_pid;
+
+	snprintf(name, sizeof(name), "%d", pid);
+	file = file_open_root(procf->f_path.dentry, procf->f_path.mnt, name,
+			      O_DIRECTORY | O_NOFOLLOW, 0);
+	if (IS_ERR(file))
+		return file;
+
+	proc_pid = tgid_pidfd_to_pid(file);
+	if (IS_ERR(proc_pid)) {
+		filp_close(file, NULL);
+		return ERR_CAST(proc_pid);
+	}
+
+	if (pidfd_pid != proc_pid) {
+		filp_close(file, NULL);
+		return ERR_PTR(-ESRCH);
+	}
+
+	return file;
+}
+
+static int pidfd_to_procfd(pid_t pid, int procfd, int pidfd)
+{
+	long fd;
+	pid_t ns_pid;
+	struct fd fdproc, fdpid;
+	struct file *file = NULL;
+	struct pid *pidfd_pid = NULL;
+	struct pid_namespace *proc_pid_ns = NULL;
+
+	fdproc = fdget(procfd);
+	if (!fdproc.file)
+		return -EBADF;
+
+	fdpid = fdget(pidfd);
+	if (!fdpid.file) {
+		fdput(fdpid);
+		return -EBADF;
+	}
+
+	proc_pid_ns = pidfd_get_proc_pid_ns(fdproc.file);
+	if (IS_ERR(proc_pid_ns)) {
+		fd = PTR_ERR(proc_pid_ns);
+		proc_pid_ns = NULL;
+		goto err;
+	}
+
+	pidfd_pid = pidfd_get_pid(fdpid.file);
+	if (IS_ERR(pidfd_pid)) {
+		fd = PTR_ERR(pidfd_pid);
+		pidfd_pid = NULL;
+		goto err;
+	}
+
+	ns_pid = pid_nr_ns(pidfd_pid, proc_pid_ns);
+	if (!ns_pid) {
+		fd = -ESRCH;
+		goto err;
+	}
+
+	file = pidfd_open_proc_pid(fdproc.file, ns_pid, pidfd_pid);
+	if (IS_ERR(file)) {
+		fd = PTR_ERR(file);
+		file = NULL;
+		goto err;
+	}
+
+	fd = get_unused_fd_flags(O_CLOEXEC);
+	if (fd < 0)
+		goto err;
+
+	fsnotify_open(file);
+	fd_install(fd, file);
+	file = NULL;
+
+err:
+	fdput(fdproc);
+	fdput(fdpid);
+	if (proc_pid_ns)
+		put_pid_ns(proc_pid_ns);
+	put_pid(pidfd_pid);
+	if (file)
+		filp_close(file, NULL);
+
+	return fd;
+}
+
+static int procfd_to_pidfd(int procfd)
+{
+	int fd;
+	struct fd fdproc;
+	struct pid *proc_pid;
+
+	fdproc = fdget(procfd);
+	if (!fdproc.file)
+		return -EBADF;
+
+	proc_pid = tgid_pidfd_to_pid(fdproc.file);
+	if (IS_ERR(proc_pid)) {
+		fdput(fdproc);
+		return PTR_ERR(proc_pid);
+	}
+
+	fd = pidfd_create_fd(proc_pid, O_CLOEXEC);
+	fdput(fdproc);
+	return fd;
+}
+#else
+static inline int pidfd_to_procfd(pid_t pid, int procfd, int pidfd)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline int procfd_to_pidfd(int procfd)
+{
+	return -EOPNOTSUPP;
+}
+#endif /* CONFIG_PROC_FS */
+
+/*
+ * pidfd_open - open a pidfd
+ * @pid:    pid for which to retrieve a pidfd
+ * @procfd: procfd file descriptor
+ * @pidfd:  pidfd file descriptor
+ * @flags:  flags to pass
+ *
+ * Creates a new pidfd or translates between pidfds and procfds.
+ * If no flag is passed, pidfd_open() will return a new pidfd for @pid. If
+ * PROCFD_TO_PIDFD is in @flags then a pidfd for struct pid referenced by
+ * @procfd is created. If PIDFD_TO_PROCFD is passed then a file descriptor to
+ * the process /proc/<pid> directory relative to the procfs referenced by
+ * @procfd will be returned.
+ */
+SYSCALL_DEFINE4(pidfd_open, pid_t, pid, int, procfd, int, pidfd, unsigned int,
+		flags)
+{
+	long fd = -EINVAL;
+
+	if (flags & ~(PIDFD_TO_PROCFD | PROCFD_TO_PIDFD))
+		return -EINVAL;
+
+	if (!flags) {
+		struct pid *pidfd_pid;
+
+		if (pid <= 0)
+			return -EINVAL;
+
+		if (procfd != -1 || pidfd != -1)
+			return -EINVAL;
+
+		rcu_read_lock();
+		pidfd_pid = get_pid(find_pid_ns(pid, task_active_pid_ns(current)));
+		rcu_read_unlock();
+
+		fd = pidfd_create_fd(pidfd_pid, O_CLOEXEC);
+		put_pid(pidfd_pid);
+	} else if (flags & PIDFD_TO_PROCFD) {
+		if (flags & ~PIDFD_TO_PROCFD)
+			return -EINVAL;
+
+		if (pid != -1)
+			return -EINVAL;
+
+		if (procfd < 0 || pidfd < 0)
+			return -EINVAL;
+
+		fd = pidfd_to_procfd(pid, procfd, pidfd);
+	} else if (flags & PROCFD_TO_PIDFD) {
+		if (flags & ~PROCFD_TO_PIDFD)
+			return -EINVAL;
+
+		if (pid != -1)
+			return -EINVAL;
+
+		if (pidfd >= 0)
+			return -EINVAL;
+
+		if (procfd < 0)
+			return -EINVAL;
+
+		fd = procfd_to_pidfd(procfd);
+	}
+
+	return fd;
+}
+
 void __init pid_idr_init(void)
 {
 	/* Verify no one has done anything silly: */
-- 
2.21.0
