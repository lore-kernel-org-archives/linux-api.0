From: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: [PATCH v2] selftests/seccomp: build on aarch64, document ABI
Date: Tue, 6 Oct 2015 10:44:09 -0700
Message-ID: <20151006174409.GA31666@www.outflux.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Cc: AKASHI Takahiro <takahiro.akashi-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

The syscall ABI is inconsistent on aarch64-compat, so at least we should
document it in the seccomp_bpf tests.

Signed-off-by: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
---
 tools/testing/selftests/seccomp/seccomp_bpf.c | 53 +++++++++++++++++----------
 1 file changed, 33 insertions(+), 20 deletions(-)

diff --git a/tools/testing/selftests/seccomp/seccomp_bpf.c b/tools/testing/selftests/seccomp/seccomp_bpf.c
index 770f47adf295..fe278551ea78 100644
--- a/tools/testing/selftests/seccomp/seccomp_bpf.c
+++ b/tools/testing/selftests/seccomp/seccomp_bpf.c
@@ -19,15 +19,16 @@
 #include <linux/prctl.h>
 #include <linux/ptrace.h>
 #include <linux/seccomp.h>
-#include <poll.h>
 #include <pthread.h>
 #include <semaphore.h>
 #include <signal.h>
 #include <stddef.h>
 #include <stdbool.h>
 #include <string.h>
+#include <time.h>
 #include <linux/elf.h>
 #include <sys/uio.h>
+#include <sys/utsname.h>
 
 #define _GNU_SOURCE
 #include <unistd.h>
@@ -2005,20 +2006,25 @@ TEST(syscall_restart)
 		BPF_JUMP(BPF_JMP|BPF_JEQ|BPF_K, __NR_read, 5, 0),
 		BPF_JUMP(BPF_JMP|BPF_JEQ|BPF_K, __NR_exit, 4, 0),
 		BPF_JUMP(BPF_JMP|BPF_JEQ|BPF_K, __NR_rt_sigreturn, 3, 0),
-		BPF_JUMP(BPF_JMP|BPF_JEQ|BPF_K, __NR_poll, 4, 0),
+		BPF_JUMP(BPF_JMP|BPF_JEQ|BPF_K, __NR_nanosleep, 4, 0),
 		BPF_JUMP(BPF_JMP|BPF_JEQ|BPF_K, __NR_restart_syscall, 4, 0),
 
 		/* Allow __NR_write for easy logging. */
 		BPF_JUMP(BPF_JMP|BPF_JEQ|BPF_K, __NR_write, 0, 1),
 		BPF_STMT(BPF_RET|BPF_K, SECCOMP_RET_ALLOW),
 		BPF_STMT(BPF_RET|BPF_K, SECCOMP_RET_KILL),
-		BPF_STMT(BPF_RET|BPF_K, SECCOMP_RET_TRACE|0x100), /* poll */
-		BPF_STMT(BPF_RET|BPF_K, SECCOMP_RET_TRACE|0x200), /* restart */
+		/* The nanosleep jump target. */
+		BPF_STMT(BPF_RET|BPF_K, SECCOMP_RET_TRACE|0x100),
+		/* The restart_syscall jump target. */
+		BPF_STMT(BPF_RET|BPF_K, SECCOMP_RET_TRACE|0x200),
 	};
 	struct sock_fprog prog = {
 		.len = (unsigned short)ARRAY_SIZE(filter),
 		.filter = filter,
 	};
+#if defined(__arm__)
+	struct utsname utsbuf;
+#endif
 
 	ASSERT_EQ(0, pipe(pipefd));
 
@@ -2027,10 +2033,7 @@ TEST(syscall_restart)
 	if (child_pid == 0) {
 		/* Child uses EXPECT not ASSERT to deliver status correctly. */
 		char buf = ' ';
-		struct pollfd fds = {
-			.fd = pipefd[0],
-			.events = POLLIN,
-		};
+		struct timespec timeout = { };
 
 		/* Attach parent as tracer and stop. */
 		EXPECT_EQ(0, ptrace(PTRACE_TRACEME));
@@ -2054,10 +2057,11 @@ TEST(syscall_restart)
 			TH_LOG("Failed to get sync data from read()");
 		}
 
-		/* Start poll to be interrupted. */
+		/* Start nanosleep to be interrupted. */
+		timeout.tv_sec = 1;
 		errno = 0;
-		EXPECT_EQ(1, poll(&fds, 1, -1)) {
-			TH_LOG("Call to poll() failed (errno %d)", errno);
+		EXPECT_EQ(0, nanosleep(&timeout, NULL)) {
+			TH_LOG("Call to nanosleep() failed (errno %d)", errno);
 		}
 
 		/* Read final sync from parent. */
@@ -2082,14 +2086,14 @@ TEST(syscall_restart)
 	ASSERT_EQ(0, ptrace(PTRACE_CONT, child_pid, NULL, 0));
 	ASSERT_EQ(1, write(pipefd[1], ".", 1));
 
-	/* Wait for poll() to start. */
+	/* Wait for nanosleep() to start. */
 	ASSERT_EQ(child_pid, waitpid(child_pid, &status, 0));
 	ASSERT_EQ(true, WIFSTOPPED(status));
 	ASSERT_EQ(SIGTRAP, WSTOPSIG(status));
 	ASSERT_EQ(PTRACE_EVENT_SECCOMP, (status >> 16));
 	ASSERT_EQ(0, ptrace(PTRACE_GETEVENTMSG, child_pid, NULL, &msg));
 	ASSERT_EQ(0x100, msg);
-	EXPECT_EQ(__NR_poll, get_syscall(_metadata, child_pid));
+	EXPECT_EQ(__NR_nanosleep, get_syscall(_metadata, child_pid));
 
 	/* Might as well check siginfo for sanity while we're here. */
 	ASSERT_EQ(0, ptrace(PTRACE_GETSIGINFO, child_pid, NULL, &info));
@@ -2100,7 +2104,7 @@ TEST(syscall_restart)
 	/* Verify signal delivery came from child (seccomp-triggered). */
 	EXPECT_EQ(child_pid, info.si_pid);
 
-	/* Interrupt poll with SIGSTOP (which we'll need to handle). */
+	/* Interrupt nanosleep with SIGSTOP (which we'll need to handle). */
 	ASSERT_EQ(0, kill(child_pid, SIGSTOP));
 	ASSERT_EQ(0, ptrace(PTRACE_CONT, child_pid, NULL, 0));
 	ASSERT_EQ(child_pid, waitpid(child_pid, &status, 0));
@@ -2110,7 +2114,7 @@ TEST(syscall_restart)
 	ASSERT_EQ(0, ptrace(PTRACE_GETSIGINFO, child_pid, NULL, &info));
 	EXPECT_EQ(getpid(), info.si_pid);
 
-	/* Restart poll with SIGCONT, which triggers restart_syscall. */
+	/* Restart nanosleep with SIGCONT, which triggers restart_syscall. */
 	ASSERT_EQ(0, kill(child_pid, SIGCONT));
 	ASSERT_EQ(0, ptrace(PTRACE_CONT, child_pid, NULL, 0));
 	ASSERT_EQ(child_pid, waitpid(child_pid, &status, 0));
@@ -2124,16 +2128,25 @@ TEST(syscall_restart)
 	ASSERT_EQ(SIGTRAP, WSTOPSIG(status));
 	ASSERT_EQ(PTRACE_EVENT_SECCOMP, (status >> 16));
 	ASSERT_EQ(0, ptrace(PTRACE_GETEVENTMSG, child_pid, NULL, &msg));
+
 	ASSERT_EQ(0x200, msg);
 	ret = get_syscall(_metadata, child_pid);
 #if defined(__arm__)
-	/* FIXME: ARM does not expose true syscall in registers. */
-	EXPECT_EQ(__NR_poll, ret);
-#else
-	EXPECT_EQ(__NR_restart_syscall, ret);
+	/*
+	 * FIXME:
+	 * - native ARM registers do NOT expose true syscall.
+	 * - compat ARM registers on ARM64 DO expose true syscall.
+	 */
+	ASSERT_EQ(0, uname(&utsbuf));
+	if (strncmp(utsbuf.machine, "arm", 3) == 0) {
+		EXPECT_EQ(__NR_nanosleep, ret);
+	} else
 #endif
+	{
+		EXPECT_EQ(__NR_restart_syscall, ret);
+	}
 
-	/* Write again to end poll. */
+	/* Write again to end test. */
 	ASSERT_EQ(0, ptrace(PTRACE_CONT, child_pid, NULL, 0));
 	ASSERT_EQ(1, write(pipefd[1], "!", 1));
 	EXPECT_EQ(0, close(pipefd[1]));
-- 
1.9.1


-- 
Kees Cook
Chrome OS Security
