From: Christian Brauner <christian@brauner.io>
Subject: [PATCH 4/4] samples: show race-free pidfd metadata access
Date: Sun, 14 Apr 2019 22:14:36 +0200
Message-ID: <20190414201436.19502-5-christian@brauner.io>
References: <20190414201436.19502-1-christian@brauner.io>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190414201436.19502-1-christian@brauner.io>
Sender: linux-kernel-owner@vger.kernel.org
To: torvalds@linux-foundation.org, viro@zeniv.linux.org.uk, jannh@google.com, dhowells@redhat.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: serge@hallyn.com, luto@kernel.org, arnd@arndb.de, ebiederm@xmission.com, keescook@chromium.org, tglx@linutronix.de, mtk.manpages@gmail.com, akpm@linux-foundation.org, oleg@redhat.com, cyphar@cyphar.com, joel@joelfernandes.org, dancol@google.com, Christian Brauner <christian@brauner.io>
List-Id: linux-api@vger.kernel.org

This is a sample program showing userspace how to get race-free access to
process metadata from a pidfd. It is rather easy to do and userspace can
actually simply reuse code that currently parses a process's status file in
procfs.
The program can easily be extended into a generic helper suitable for
inclusion in a libc to make it even easier for userspace to gain metadata
access.

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
 samples/Makefile               |   2 +-
 samples/pidfd/Makefile         |   6 ++
 samples/pidfd/pidfd-metadata.c | 172 +++++++++++++++++++++++++++++++++
 3 files changed, 179 insertions(+), 1 deletion(-)
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
index 000000000000..23a44e582ccb
--- /dev/null
+++ b/samples/pidfd/pidfd-metadata.c
@@ -0,0 +1,172 @@
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
+static int raw_clone_pidfd(void)
+{
+	unsigned long flags = CLONE_PIDFD | SIGCHLD;
+
+#if defined(__s390x__) || defined(__s390__) || defined(__CRIS__)
+	/*
+	 * On s390/s390x and cris the order of the first and second arguments
+	 * of the system call is reversed.
+	 */
+	return (int)syscall(__NR_clone, NULL, flags);
+#elif defined(__sparc__) && defined(__arch64__)
+	{
+		/*
+		 * sparc64 always returns the other process id in %o0, and a
+		 * boolean flag whether this is the child or the parent in %o1.
+		 * Inline assembly is needed to get the flag returned in %o1.
+		 */
+		int child_pid, in_child;
+
+		asm volatile("mov %2, %%g1\n\t"
+			     "mov %3, %%o0\n\t"
+			     "mov 0 , %%o1\n\t"
+			     "t 0x6d\n\t"
+			     "mov %%o1, %0\n\t"
+			     "mov %%o0, %1"
+			     : "=r"(in_child), "=r"(child_pid)
+			     : "i"(__NR_clone), "r"(flags)
+			     : "%o1", "%o0", "%g1");
+
+		if (in_child)
+			return 0;
+		else
+			return child_pid;
+	}
+#elif defined(__ia64__)
+	/* On ia64 stack and stack size are passed as separate arguments. */
+	return (int)syscall(__NR_clone, flags, NULL, 0UL);
+#else
+	return (int)syscall(__NR_clone, flags, NULL);
+#endif
+}
+
+static inline int sys_pidfd_send_signal(int pidfd, int sig, siginfo_t *info,
+					unsigned int flags)
+{
+	return syscall(__NR_pidfd_send_signal, pidfd, sig, info, flags);
+}
+
+static int pidfd_metadata_fd(int pidfd)
+{
+	int procfd, ret;
+	char path[100];
+	FILE *f;
+	size_t n = 0;
+	char *line = NULL;
+
+	snprintf(path, sizeof(path), "/proc/self/fdinfo/%d", pidfd);
+
+	f = fopen(path, "re");
+	if (!f)
+		return -1;
+
+	ret = 0;
+	while (getline(&line, &n, f) != -1) {
+		char *numstr;
+		size_t len;
+
+		if (strncmp(line, "Pid:\t", 5))
+			continue;
+
+		numstr = line + 5;
+		len = strlen(numstr);
+		if (len > 0 && numstr[len - 1] == '\n')
+			numstr[len - 1] = '\0';
+		ret = snprintf(path, sizeof(path), "/proc/%s", numstr);
+		break;
+	}
+	free(line);
+	fclose(f);
+
+	if (!ret) {
+		errno = ENOENT;
+		warn("Failed to parse pid from fdinfo\n");
+		return -1;
+	}
+
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
+	int pidfd, procfd, statusfd;
+	ssize_t bytes;
+
+	pidfd = raw_clone_pidfd();
+	if (pidfd < 0)
+		exit(ret);
+
+	if (pidfd == 0) {
+		printf("%d\n", getpid());
+		exit(EXIT_SUCCESS);
+	}
+
+	procfd = pidfd_metadata_fd(pidfd);
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
