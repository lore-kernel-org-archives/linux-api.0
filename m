From: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: [PATCH v3] selftests/seccomp: build and pass on arm64
Date: Tue, 6 Oct 2015 12:30:25 -0700
Message-ID: <20151006193025.GA11826@www.outflux.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Cc: AKASHI Takahiro <takahiro.akashi-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Changing arm64 syscalls is done via a specific register set, more like s390
than like arm (specific ptrace call) and x86 (part of general registers).
Since (restarting) poll doesn't exist on arm64, switch to using nanosleep
for testing restart_syscall. And since it looks like the syscall ABI is
inconsistent on arm-compat, so we must work around it (and document it) in
the test.

Signed-off-by: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
---
v3:
 - correctly set syscall number on native arm64.
v2:
 - switch to nanosleep from a bad mix of poll and ppoll for testing restart.
---
 tools/testing/selftests/seccomp/seccomp_bpf.c | 71 ++++++++++++++++++---------
 1 file changed, 49 insertions(+), 22 deletions(-)

diff --git a/tools/testing/selftests/seccomp/seccomp_bpf.c b/tools/testing/selftests/seccomp/seccomp_bpf.c
index 770f47adf295..e7bc5d3533da 100644
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
@@ -1247,8 +1248,8 @@ void change_syscall(struct __test_metadata *_metadata,
 	ret = ptrace(PTRACE_GETREGSET, tracee, NT_PRSTATUS, &iov);
 	EXPECT_EQ(0, ret);
 
-#if defined(__x86_64__) || defined(__i386__) || defined(__aarch64__) || \
-    defined(__powerpc__) || defined(__s390__)
+#if defined(__x86_64__) || defined(__i386__) || defined(__powerpc__) || \
+    defined(__s390__)
 	{
 		regs.SYSCALL_NUM = syscall;
 	}
@@ -1262,6 +1263,18 @@ void change_syscall(struct __test_metadata *_metadata,
 		EXPECT_EQ(0, ret);
 	}
 
+#elif defined(__aarch64__)
+# ifndef NT_ARM_SYSTEM_CALL
+#  define NT_ARM_SYSTEM_CALL 0x404
+# endif
+	{
+		iov.iov_base = &syscall;
+		iov.iov_len = sizeof(syscall);
+		ret = ptrace(PTRACE_SETREGSET, tracee, NT_ARM_SYSTEM_CALL,
+			     &iov);
+		EXPECT_EQ(0, ret);
+	}
+
 #else
 	ASSERT_EQ(1, 0) {
 		TH_LOG("How is the syscall changed on this architecture?");
@@ -1272,6 +1285,8 @@ void change_syscall(struct __test_metadata *_metadata,
 	if (syscall == -1)
 		regs.SYSCALL_RET = 1;
 
+	iov.iov_base = &regs;
+	iov.iov_len = sizeof(regs);
 	ret = ptrace(PTRACE_SETREGSET, tracee, NT_PRSTATUS, &iov);
 	EXPECT_EQ(0, ret);
 }
@@ -2005,20 +2020,25 @@ TEST(syscall_restart)
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
 
@@ -2027,10 +2047,7 @@ TEST(syscall_restart)
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
@@ -2054,10 +2071,11 @@ TEST(syscall_restart)
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
@@ -2082,14 +2100,14 @@ TEST(syscall_restart)
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
@@ -2100,7 +2118,7 @@ TEST(syscall_restart)
 	/* Verify signal delivery came from child (seccomp-triggered). */
 	EXPECT_EQ(child_pid, info.si_pid);
 
-	/* Interrupt poll with SIGSTOP (which we'll need to handle). */
+	/* Interrupt nanosleep with SIGSTOP (which we'll need to handle). */
 	ASSERT_EQ(0, kill(child_pid, SIGSTOP));
 	ASSERT_EQ(0, ptrace(PTRACE_CONT, child_pid, NULL, 0));
 	ASSERT_EQ(child_pid, waitpid(child_pid, &status, 0));
@@ -2110,7 +2128,7 @@ TEST(syscall_restart)
 	ASSERT_EQ(0, ptrace(PTRACE_GETSIGINFO, child_pid, NULL, &info));
 	EXPECT_EQ(getpid(), info.si_pid);
 
-	/* Restart poll with SIGCONT, which triggers restart_syscall. */
+	/* Restart nanosleep with SIGCONT, which triggers restart_syscall. */
 	ASSERT_EQ(0, kill(child_pid, SIGCONT));
 	ASSERT_EQ(0, ptrace(PTRACE_CONT, child_pid, NULL, 0));
 	ASSERT_EQ(child_pid, waitpid(child_pid, &status, 0));
@@ -2124,16 +2142,25 @@ TEST(syscall_restart)
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
