From: Kees Cook <keescook@chromium.org>
Subject: [PATCH v4 4/4] selftests/seccomp: Test thread vs process killing
Date: Fri, 11 Aug 2017 15:05:16 -0700
Message-ID: <1502489117-70522-5-git-send-email-keescook@chromium.org>
References: <1502489117-70522-1-git-send-email-keescook@chromium.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1502489117-70522-1-git-send-email-keescook@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Tyler Hicks <tyhicks@canonical.com>, Fabricio Voznika <fvoznika@google.com>, Paul Moore <paul@paul-moore.com>, Tycho Andersen <tycho@docker.com>, Andy Lutomirski <luto@amacapital.net>, Will Drewry <wad@chromium.org>, Shuah Khan <shuah@kernel.org>, Mathias Svensson <idolf@google.com>, James Morris <james.l.morris@oracle.com>, linux-security-module@vger.kernel.org, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, linux-kselftest@vger.kernel.org
List-Id: linux-api@vger.kernel.org

This verifies that SECCOMP_RET_KILL_PROCESS is higher priority than
SECCOMP_RET_KILL_THREAD. (This also moves a bunch of defines up earlier
in the file to use them earlier.)

Signed-off-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Tyler Hicks <tyhicks@canonical.com>
---
 tools/testing/selftests/seccomp/seccomp_bpf.c | 228 +++++++++++++++++++-------
 1 file changed, 168 insertions(+), 60 deletions(-)

diff --git a/tools/testing/selftests/seccomp/seccomp_bpf.c b/tools/testing/selftests/seccomp/seccomp_bpf.c
index 5680e3ae33fd..fa097a270616 100644
--- a/tools/testing/selftests/seccomp/seccomp_bpf.c
+++ b/tools/testing/selftests/seccomp/seccomp_bpf.c
@@ -68,7 +68,17 @@
 #define SECCOMP_MODE_FILTER 2
 #endif
 
-#ifndef SECCOMP_RET_KILL_THREAD
+#ifndef SECCOMP_RET_ALLOW
+struct seccomp_data {
+	int nr;
+	__u32 arch;
+	__u64 instruction_pointer;
+	__u64 args[6];
+};
+#endif
+
+#ifndef SECCOMP_RET_KILL_PROCESS
+#define SECCOMP_RET_KILL_PROCESS 0x80000000U /* kill the process */
 #define SECCOMP_RET_KILL_THREAD	 0x00000000U /* kill the thread */
 #endif
 #ifndef SECCOMP_RET_KILL
@@ -82,17 +92,53 @@
 #define SECCOMP_RET_LOG		 0x7ffc0000U /* allow after logging */
 #endif
 
-#ifndef SECCOMP_RET_ACTION
-/* Masks for the return value sections. */
-#define SECCOMP_RET_ACTION      0x7fff0000U
-#define SECCOMP_RET_DATA        0x0000ffffU
+#ifndef __NR_seccomp
+# if defined(__i386__)
+#  define __NR_seccomp 354
+# elif defined(__x86_64__)
+#  define __NR_seccomp 317
+# elif defined(__arm__)
+#  define __NR_seccomp 383
+# elif defined(__aarch64__)
+#  define __NR_seccomp 277
+# elif defined(__hppa__)
+#  define __NR_seccomp 338
+# elif defined(__powerpc__)
+#  define __NR_seccomp 358
+# elif defined(__s390__)
+#  define __NR_seccomp 348
+# else
+#  warning "seccomp syscall number unknown for this architecture"
+#  define __NR_seccomp 0xffff
+# endif
+#endif
 
-struct seccomp_data {
-	int nr;
-	__u32 arch;
-	__u64 instruction_pointer;
-	__u64 args[6];
-};
+#ifndef SECCOMP_SET_MODE_STRICT
+#define SECCOMP_SET_MODE_STRICT 0
+#endif
+
+#ifndef SECCOMP_SET_MODE_FILTER
+#define SECCOMP_SET_MODE_FILTER 1
+#endif
+
+#ifndef SECCOMP_GET_ACTION_AVAIL
+#define SECCOMP_GET_ACTION_AVAIL 2
+#endif
+
+#ifndef SECCOMP_FILTER_FLAG_TSYNC
+#define SECCOMP_FILTER_FLAG_TSYNC 1
+#endif
+
+#ifndef SECCOMP_FILTER_FLAG_LOG
+#define SECCOMP_FILTER_FLAG_LOG 2
+#endif
+
+#ifndef seccomp
+int seccomp(unsigned int op, unsigned int flags, void *args)
+{
+	errno = 0;
+	return syscall(__NR_seccomp, op, flags, args);
+}
 #endif
 
 #if __BYTE_ORDER == __LITTLE_ENDIAN
@@ -550,6 +596,117 @@ TEST_SIGNAL(KILL_one_arg_six, SIGSYS)
 	close(fd);
 }
 
+/* This is a thread task to die via seccomp filter violation. */
+void *kill_thread(void *data)
+{
+	bool die = (bool)data;
+
+	if (die) {
+		prctl(PR_GET_SECCOMP, 0, 0, 0, 0);
+		return (void *)SIBLING_EXIT_FAILURE;
+	}
+
+	return (void *)SIBLING_EXIT_UNKILLED;
+}
+
+/* Prepare a thread that will kill itself or both of us. */
+void kill_thread_or_group(struct __test_metadata *_metadata, bool kill_process)
+{
+	pthread_t thread;
+	void *status;
+	/* Kill only when calling __NR_prctl. */
+	struct sock_filter filter_thread[] = {
+		BPF_STMT(BPF_LD|BPF_W|BPF_ABS,
+			offsetof(struct seccomp_data, nr)),
+		BPF_JUMP(BPF_JMP|BPF_JEQ|BPF_K, __NR_prctl, 0, 1),
+		BPF_STMT(BPF_RET|BPF_K, SECCOMP_RET_KILL_THREAD),
+		BPF_STMT(BPF_RET|BPF_K, SECCOMP_RET_ALLOW),
+	};
+	struct sock_fprog prog_thread = {
+		.len = (unsigned short)ARRAY_SIZE(filter_thread),
+		.filter = filter_thread,
+	};
+	struct sock_filter filter_process[] = {
+		BPF_STMT(BPF_LD|BPF_W|BPF_ABS,
+			offsetof(struct seccomp_data, nr)),
+		BPF_JUMP(BPF_JMP|BPF_JEQ|BPF_K, __NR_prctl, 0, 1),
+		BPF_STMT(BPF_RET|BPF_K, SECCOMP_RET_KILL_PROCESS),
+		BPF_STMT(BPF_RET|BPF_K, SECCOMP_RET_ALLOW),
+	};
+	struct sock_fprog prog_process = {
+		.len = (unsigned short)ARRAY_SIZE(filter_process),
+		.filter = filter_process,
+	};
+
+	ASSERT_EQ(0, prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0)) {
+		TH_LOG("Kernel does not support PR_SET_NO_NEW_PRIVS!");
+	}
+
+	ASSERT_EQ(0, seccomp(SECCOMP_SET_MODE_FILTER, 0,
+			     kill_process ? &prog_process : &prog_thread));
+
+	/*
+	 * Add the KILL_THREAD rule again to make sure that the KILL_PROCESS
+	 * flag cannot be downgraded by a new filter.
+	 */
+	ASSERT_EQ(0, seccomp(SECCOMP_SET_MODE_FILTER, 0, &prog_thread));
+
+	/* Start a thread that will exit immediately. */
+	ASSERT_EQ(0, pthread_create(&thread, NULL, kill_thread, (void *)false));
+	ASSERT_EQ(0, pthread_join(thread, &status));
+	ASSERT_EQ(SIBLING_EXIT_UNKILLED, (unsigned long)status);
+
+	/* Start a thread that will die immediately. */
+	ASSERT_EQ(0, pthread_create(&thread, NULL, kill_thread, (void *)true));
+	ASSERT_EQ(0, pthread_join(thread, &status));
+	ASSERT_NE(SIBLING_EXIT_FAILURE, (unsigned long)status);
+
+	/*
+	 * If we get here, only the spawned thread died. Let the parent know
+	 * the whole process didn't die (i.e. this thread, the spawner,
+	 * stayed running).
+	 */
+	exit(42);
+}
+
+TEST(KILL_thread)
+{
+	int status;
+	pid_t child_pid;
+
+	child_pid = fork();
+	ASSERT_LE(0, child_pid);
+	if (child_pid == 0) {
+		kill_thread_or_group(_metadata, false);
+		_exit(38);
+	}
+
+	ASSERT_EQ(child_pid, waitpid(child_pid, &status, 0));
+
+	/* If only the thread was killed, we'll see exit 42. */
+	ASSERT_TRUE(WIFEXITED(status));
+	ASSERT_EQ(42, WEXITSTATUS(status));
+}
+
+TEST(KILL_process)
+{
+	int status;
+	pid_t child_pid;
+
+	child_pid = fork();
+	ASSERT_LE(0, child_pid);
+	if (child_pid == 0) {
+		kill_thread_or_group(_metadata, true);
+		_exit(38);
+	}
+
+	ASSERT_EQ(child_pid, waitpid(child_pid, &status, 0));
+
+	/* If the entire process was killed, we'll see SIGSYS. */
+	ASSERT_TRUE(WIFSIGNALED(status));
+	ASSERT_EQ(SIGSYS, WTERMSIG(status));
+}
+
 /* TODO(wad) add 64-bit versus 32-bit arg tests. */
 TEST(arg_out_of_range)
 {
@@ -1773,55 +1930,6 @@ TEST_F_SIGNAL(TRACE_syscall, kill_after_ptrace, SIGSYS)
 	EXPECT_NE(self->mypid, syscall(__NR_getpid));
 }
 
-#ifndef __NR_seccomp
-# if defined(__i386__)
-#  define __NR_seccomp 354
-# elif defined(__x86_64__)
-#  define __NR_seccomp 317
-# elif defined(__arm__)
-#  define __NR_seccomp 383
-# elif defined(__aarch64__)
-#  define __NR_seccomp 277
-# elif defined(__hppa__)
-#  define __NR_seccomp 338
-# elif defined(__powerpc__)
-#  define __NR_seccomp 358
-# elif defined(__s390__)
-#  define __NR_seccomp 348
-# else
-#  warning "seccomp syscall number unknown for this architecture"
-#  define __NR_seccomp 0xffff
-# endif
-#endif
-
-#ifndef SECCOMP_SET_MODE_STRICT
-#define SECCOMP_SET_MODE_STRICT 0
-#endif
-
-#ifndef SECCOMP_SET_MODE_FILTER
-#define SECCOMP_SET_MODE_FILTER 1
-#endif
-
-#ifndef SECCOMP_GET_ACTION_AVAIL
-#define SECCOMP_GET_ACTION_AVAIL 2
-#endif
-
-#ifndef SECCOMP_FILTER_FLAG_TSYNC
-#define SECCOMP_FILTER_FLAG_TSYNC 1
-#endif
-
-#ifndef SECCOMP_FILTER_FLAG_LOG
-#define SECCOMP_FILTER_FLAG_LOG 2
-#endif
-
-#ifndef seccomp
-int seccomp(unsigned int op, unsigned int flags, void *args)
-{
-	errno = 0;
-	return syscall(__NR_seccomp, op, flags, args);
-}
-#endif
-
 TEST(seccomp_syscall)
 {
 	struct sock_filter filter[] = {
-- 
2.7.4
