From: Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 2/2] selftest: add a test case for PTRACE_PEEKSIGINFO
Date: Wed, 27 Feb 2013 18:37:09 +0400
Message-ID: <1361975829-1738-2-git-send-email-avagin@openvz.org>
References: <1361975829-1738-1-git-send-email-avagin@openvz.org>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1361975829-1738-1-git-send-email-avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: criu-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Roland McGrath <roland-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dave Jones <davej-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Pedro Alves <palves-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

* Dump signals from process-wide and per-thread queues with
  different sizes of buffers.
* Check error paths for buffers with restricted permissions. A part of
  buffer or a whole buffer is for read-only.
* Try to get nonexistent signal.

Cc: Roland McGrath <roland-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Dave Jones <davej-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Pedro Alves <palves-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
---
 tools/testing/selftests/Makefile             |   2 +-
 tools/testing/selftests/ptrace/Makefile      |   5 +
 tools/testing/selftests/ptrace/peeksiginfo.c | 214 +++++++++++++++++++++++++++
 3 files changed, 220 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/ptrace/Makefile
 create mode 100644 tools/testing/selftests/ptrace/peeksiginfo.c

diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index 85baf11..379ba69 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -1,4 +1,4 @@
-TARGETS = breakpoints kcmp mqueue vm cpu-hotplug memory-hotplug
+TARGETS = breakpoints kcmp mqueue vm cpu-hotplug memory-hotplug ptrace
 
 all:
 	for TARGET in $(TARGETS); do \
diff --git a/tools/testing/selftests/ptrace/Makefile b/tools/testing/selftests/ptrace/Makefile
new file mode 100644
index 0000000..82ada21
--- /dev/null
+++ b/tools/testing/selftests/ptrace/Makefile
@@ -0,0 +1,5 @@
+CFLAGS += -iquote../../../../include/uapi -Wall
+peeksiginfo: peeksiginfo.c
+
+clean:
+	rm -f peeksiginfo
diff --git a/tools/testing/selftests/ptrace/peeksiginfo.c b/tools/testing/selftests/ptrace/peeksiginfo.c
new file mode 100644
index 0000000..d46558b
--- /dev/null
+++ b/tools/testing/selftests/ptrace/peeksiginfo.c
@@ -0,0 +1,214 @@
+#define _GNU_SOURCE
+#include <stdio.h>
+#include <signal.h>
+#include <unistd.h>
+#include <errno.h>
+#include <linux/types.h>
+#include <sys/wait.h>
+#include <sys/syscall.h>
+#include <sys/user.h>
+#include <sys/mman.h>
+
+#include "linux/ptrace.h"
+
+static int sys_rt_sigqueueinfo(pid_t tgid, int sig, siginfo_t *uinfo)
+{
+	return syscall(SYS_rt_sigqueueinfo, tgid, sig, uinfo);
+}
+
+static int sys_rt_tgsigqueueinfo(pid_t tgid, pid_t tid,
+					int sig, siginfo_t *uinfo)
+{
+	return syscall(SYS_rt_tgsigqueueinfo, tgid, tid, sig, uinfo);
+}
+
+static int sys_ptrace(int request, pid_t pid, void *addr, void *data)
+{
+	return syscall(SYS_ptrace, request, pid, addr, data);
+}
+
+#define SIGNR 10
+#define TEST_SICODE_PRIV	-1
+#define TEST_SICODE_SHARE	-2
+
+#define err(fmt, ...)						\
+		fprintf(stderr,					\
+			"Error (%s:%d): " fmt,			\
+			__FILE__, __LINE__, ##__VA_ARGS__)
+
+static int check_error_paths(pid_t child)
+{
+	struct ptrace_peeksiginfo_args arg;
+	int ret, exit_code = -1;
+	void *addr_rw, *addr_ro;
+
+	/*
+	 * Allocate two contiguous pages. The first one is for read-write,
+	 * another is for read-only.
+	 */
+	addr_rw = mmap(NULL, 2 * PAGE_SIZE, PROT_READ | PROT_WRITE,
+				MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	if (addr_rw == MAP_FAILED) {
+		err("mmap() failed: %m\n");
+		return 1;
+	}
+
+	addr_ro = mmap(addr_rw + PAGE_SIZE, PAGE_SIZE, PROT_READ,
+			MAP_PRIVATE | MAP_ANONYMOUS | MAP_FIXED, -1, 0);
+	if (addr_ro == MAP_FAILED) {
+		err("mmap() failed: %m\n");
+		goto out;
+	}
+
+	arg.nr = SIGNR;
+	arg.off = 0;
+
+	/* Unsupported flags */
+	arg.flags = ~0;
+	ret = sys_ptrace(PTRACE_PEEKSIGINFO, child, &arg, addr_rw);
+	if (ret != -1 || errno != EINVAL) {
+		err("sys_ptrace() returns %d (expected -1),"
+				" errno %d (expected %d): %m\n",
+				ret, errno, EINVAL);
+		goto out;
+	}
+	arg.flags = 0;
+
+	/* A part of the buffer is read-only */
+	ret = sys_ptrace(PTRACE_PEEKSIGINFO, child, &arg,
+					addr_ro - sizeof(siginfo_t) * 2);
+	if (ret != 2) {
+		err("sys_ptrace() returns %d (expected 2): %m\n", ret);
+		goto out;
+	}
+
+	/* Read-only buffer */
+	ret = sys_ptrace(PTRACE_PEEKSIGINFO, child, &arg, addr_ro);
+	if (ret != -1 && errno != EFAULT) {
+		err("sys_ptrace() returns %d (expected -1),"
+				" errno %d (expected %d): %m\n",
+				ret, errno, EFAULT);
+		goto out;
+	}
+
+	exit_code = 0;
+out:
+	munmap(addr_rw, 2 * PAGE_SIZE);
+	return exit_code;
+}
+
+int check_direct_path(pid_t child, int shared, int nr)
+{
+	struct ptrace_peeksiginfo_args arg = {.flags = 0, .nr = nr, .off = 0};
+	int i, j, ret, exit_code = -1;
+	siginfo_t siginfo[SIGNR];
+	int si_code;
+
+	if (shared == 1) {
+		arg.flags = PTRACE_PEEKSIGINFO_SHARED;
+		si_code = TEST_SICODE_SHARE;
+	} else {
+		arg.flags = 0;
+		si_code = TEST_SICODE_PRIV;
+	}
+
+	for (i = 0; i < SIGNR; ) {
+		arg.off = i;
+		ret = sys_ptrace(PTRACE_PEEKSIGINFO, child, &arg, siginfo);
+		if (ret == -1) {
+			err("ptrace() failed: %m\n");
+			goto out;
+		}
+
+		if (ret == 0)
+			break;
+
+		for (j = 0; j < ret; j++, i++) {
+			if (siginfo[j].si_code == si_code &&
+			    siginfo[j].si_int == i)
+				continue;
+
+			err("%d: Wrong siginfo i=%d si_code=%d si_int=%d\n",
+			     shared, i, siginfo[j].si_code, siginfo[j].si_int);
+			goto out;
+		}
+	}
+
+	if (i != SIGNR) {
+		err("Only %d signals were read\n", i);
+		goto out;
+	}
+
+	exit_code = 0;
+out:
+	return exit_code;
+}
+
+int main(int argc, char *argv[])
+{
+	siginfo_t siginfo[SIGNR];
+	int i, exit_code = 1;
+	sigset_t blockmask;
+	pid_t child;
+
+	sigemptyset(&blockmask);
+	sigaddset(&blockmask, SIGRTMIN);
+	sigprocmask(SIG_BLOCK, &blockmask, NULL);
+
+	child = fork();
+	if (child == -1) {
+		err("fork() failed: %m");
+		return 1;
+	} else if (child == 0) {
+		pid_t ppid = getppid();
+		while (1) {
+			if (ppid != getppid())
+				break;
+			sleep(1);
+		}
+		return 1;
+	}
+
+	/* Send signals in process-wide and per-thread queues */
+	for (i = 0; i < SIGNR; i++) {
+		siginfo->si_code = TEST_SICODE_SHARE;
+		siginfo->si_int = i;
+		sys_rt_sigqueueinfo(child, SIGRTMIN, siginfo);
+
+		siginfo->si_code = TEST_SICODE_PRIV;
+		siginfo->si_int = i;
+		sys_rt_tgsigqueueinfo(child, child, SIGRTMIN, siginfo);
+	}
+
+	if (sys_ptrace(PTRACE_ATTACH, child, NULL, NULL) == -1)
+		return 1;
+
+	waitpid(child, NULL, 0);
+
+	/* Dump signals one by one*/
+	if (check_direct_path(child, 0, 1))
+		goto out;
+	/* Dump all signals for one call */
+	if (check_direct_path(child, 0, SIGNR))
+		goto out;
+
+	/*
+	 * Dump signal from the process-wide queue.
+	 * The number of signals is not multible to the buffer size
+	 */
+	if (check_direct_path(child, 1, 3))
+		goto out;
+
+	if (check_error_paths(child))
+		goto out;
+
+	printf("PASS\n");
+	exit_code = 0;
+out:
+	if (sys_ptrace(PTRACE_KILL, child, NULL, NULL) == -1)
+		return 1;
+
+	waitpid(child, NULL, 0);
+
+	return exit_code;
+}
-- 
1.7.11.7
