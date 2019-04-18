From: Christian Brauner <christian@brauner.io>
Subject: [PATCH v2 5/5] samples: show race-free pidfd metadata access
Date: Thu, 18 Apr 2019 12:18:41 +0200
Message-ID: <20190418101841.4476-6-christian@brauner.io>
References: <20190418101841.4476-1-christian@brauner.io>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190418101841.4476-1-christian@brauner.io>
Sender: linux-kernel-owner@vger.kernel.org
To: torvalds@linux-foundation.org, viro@zeniv.linux.org.uk, jannh@google.com, dhowells@redhat.com, oleg@redhat.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: serge@hallyn.com, luto@kernel.org, arnd@arndb.de, ebiederm@xmission.com, keescook@chromium.org, tglx@linutronix.de, mtk.manpages@gmail.com, akpm@linux-foundation.org, cyphar@cyphar.com, joel@joelfernandes.org, dancol@google.com, Christian Brauner <christian@brauner.io>
List-Id: linux-api@vger.kernel.org

This is a sample program showing userspace how to get race-free access to
process metadata from a pidfd. It is rather easy to do and userspace can
actually simply reuse code that currently parses a process's status file in
procfs.
The program can easily be extended into a generic helper suitable for
inclusion in a libc to make it even easier for userspace to gain metadata
access.

Since this came up in a discussion since this API is going to be used in
various service managers. A lot of programs will have a whitelist seccomp
filter that returns EPERM for all new syscalls. This means that programs
might get confused if CLONE_PIDFD works but the later pidfd_send_signal()
syscall doesn't. Hence, here's a ahead of time check that
pidfd_send_signal() is supported:

bool pidfd_send_signal_supported()
{
        int procfd = open("/proc/self", O_DIRECTORY | O_RDONLY | O_CLOEXEC);
        if (procfd < 0)
                return false;

        /* pidfd_send_signal() should never fail this test. So it must
         * mean it is not available or blocked by an LSM or seccomp or
         * other. So * fallback to using pids in this case.
         */
        return pidfd_send_signal(procfd, 0, NULL, 0) == 0;
}

Signed-off-by: Christian Brauner <christian@brauner.io>
Signed-off-by: Jann Horn <jann@thejh.net>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: David Howells <dhowells@redhat.com>
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: Andy Lutomirsky <luto@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Aleksa Sarai <cyphar@cyphar.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
---
/* changelog */
v1:
- Christian Brauner <christian@brauner.io>:
  - adapt sample program to changes in how CLONE_PIDFD returns the pidfd
    With Oleg's suggestion we can simplify the program even more.
v2: patch unchanged
---
 samples/Makefile               |   2 +-
 samples/pidfd/Makefile         |   6 ++
 samples/pidfd/pidfd-metadata.c | 112 +++++++++++++++++++++++++++++++++
 3 files changed, 119 insertions(+), 1 deletion(-)
 create mode 100644 samples/pidfd/Makefile
 create mode 100644 samples/pidfd/pidfd-metadata.c

diff --git a/samples/Makefile b/samples/Makefile
index b1142a958811..fadadb1c3b05 100644
--- a/samples/Makefile
+++ b/samples/Makefile
@@ -3,4 +3,4 @@
 obj-$(CONFIG_SAMPLES)	+= kobject/ kprobes/ trace_events/ livepatch/ \
 			   hw_breakpoint/ kfifo/ kdb/ hidraw/ rpmsg/ seccomp/ \
 			   configfs/ connector/ v4l/ trace_printk/ \
-			   vfio-mdev/ statx/ qmi/ binderfs/
+			   vfio-mdev/ statx/ qmi/ binderfs/ pidfd/
diff --git a/samples/pidfd/Makefile b/samples/pidfd/Makefile
new file mode 100644
index 000000000000..0ff97784177a
--- /dev/null
+++ b/samples/pidfd/Makefile
@@ -0,0 +1,6 @@
+# SPDX-License-Identifier: GPL-2.0
+
+hostprogs-y := pidfd-metadata
+always := $(hostprogs-y)
+HOSTCFLAGS_pidfd-metadata.o += -I$(objtree)/usr/include
+all: pidfd-metadata
diff --git a/samples/pidfd/pidfd-metadata.c b/samples/pidfd/pidfd-metadata.c
new file mode 100644
index 000000000000..bd8456fc4c0e
--- /dev/null
+++ b/samples/pidfd/pidfd-metadata.c
@@ -0,0 +1,112 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#define _GNU_SOURCE
+#include <err.h>
+#include <errno.h>
+#include <fcntl.h>
+#include <inttypes.h>
+#include <limits.h>
+#include <sched.h>
+#include <signal.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/stat.h>
+#include <sys/syscall.h>
+#include <sys/types.h>
+#include <sys/wait.h>
+#include <unistd.h>
+
+#ifndef CLONE_PIDFD
+#define CLONE_PIDFD 0x00001000
+#endif
+
+static int do_child(void *args)
+{
+	printf("%d\n", getpid());
+	_exit(EXIT_SUCCESS);
+}
+
+static pid_t pidfd_clone(int flags, int *pidfd)
+{
+	size_t stack_size = 1024;
+	char *stack[1024] = { 0 };
+
+#ifdef __ia64__
+	return __clone2(do_child, stack, stack_size, flags | SIGCHLD, NULL, pidfd);
+#else
+	return clone(do_child, stack + stack_size, flags | SIGCHLD, NULL, pidfd);
+#endif
+}
+
+static inline int sys_pidfd_send_signal(int pidfd, int sig, siginfo_t *info,
+					unsigned int flags)
+{
+	return syscall(__NR_pidfd_send_signal, pidfd, sig, info, flags);
+}
+
+static int pidfd_metadata_fd(pid_t pid, int pidfd)
+{
+	int procfd, ret;
+	char path[100];
+
+	snprintf(path, sizeof(path), "/proc/%d", pid);
+	procfd = open(path, O_DIRECTORY | O_RDONLY | O_CLOEXEC);
+	if (procfd < 0) {
+		warn("Failed to open %s\n", path);
+		return -1;
+	}
+
+	/*
+	 * Verify that the pid has not been recycled and our /proc/<pid> handle
+	 * is still valid.
+	 */
+	ret = sys_pidfd_send_signal(pidfd, 0, NULL, 0);
+	if (ret < 0) {
+		switch (errno) {
+		case EPERM:
+			/* Process exists, just not allowed to signal it. */
+			break;
+		default:
+			warn("Failed to signal process\n");
+			close(procfd);
+			procfd = -1;
+		}
+	}
+
+	return procfd;
+}
+
+int main(int argc, char *argv[])
+{
+	int ret = EXIT_FAILURE;
+	char buf[4096] = { 0 };
+	pid_t pid;
+	int pidfd, procfd, statusfd;
+	ssize_t bytes;
+
+	pid = pidfd_clone(CLONE_PIDFD, &pidfd);
+	if (pid < 0)
+		exit(ret);
+
+	procfd = pidfd_metadata_fd(pid, pidfd);
+	close(pidfd);
+	if (procfd < 0)
+		goto out;
+
+	statusfd = openat(procfd, "status", O_RDONLY | O_CLOEXEC);
+	close(procfd);
+	if (statusfd < 0)
+		goto out;
+
+	bytes = read(statusfd, buf, sizeof(buf));
+	if (bytes > 0)
+		bytes = write(STDOUT_FILENO, buf, bytes);
+	close(statusfd);
+	ret = EXIT_SUCCESS;
+
+out:
+	(void)wait(NULL);
+
+	exit(ret);
+}
-- 
2.21.0
