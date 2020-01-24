From: Sargun Dhillon <sargun-GaZTRHToo+CzQB+pC5nmwQ@public.gmane.org>
Subject: [PATCH 4/4] selftests/seccomp: test SECCOMP_USER_NOTIF_FLAG_PIDFD
Date: Fri, 24 Jan 2020 01:17:43 -0800
Message-ID: <20200124091743.3357-5-sargun@sargun.me>
References: <20200124091743.3357-1-sargun@sargun.me>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20200124091743.3357-1-sargun-GaZTRHToo+CzQB+pC5nmwQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Sargun Dhillon <sargun-GaZTRHToo+CzQB+pC5nmwQ@public.gmane.org>, tycho-E0fblnxP3wo@public.gmane.org, christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org
List-Id: linux-api@vger.kernel.org

This adds a test which uses the SECCOMP_USER_NOTIF_FLAG_PIDFD flag. It
does this by using sys_pidfd_send_signal to signal the process, and
then relies on traditional waitpid to ensure that the specific
signal was delivered.

Additionally, it verifies the case where the copy of the notification
to userspace fails, and the pidfd file is required to be freed.

Signed-off-by: Sargun Dhillon <sargun-GaZTRHToo+CzQB+pC5nmwQ@public.gmane.org>
---
 tools/testing/selftests/seccomp/seccomp_bpf.c | 110 ++++++++++++++++++
 1 file changed, 110 insertions(+)

diff --git a/tools/testing/selftests/seccomp/seccomp_bpf.c b/tools/testing/selftests/seccomp/seccomp_bpf.c
index ee1b727ede04..ae9167ffbda9 100644
--- a/tools/testing/selftests/seccomp/seccomp_bpf.c
+++ b/tools/testing/selftests/seccomp/seccomp_bpf.c
@@ -187,6 +187,7 @@ struct seccomp_notif {
 	__u32 pid;
 	__u32 flags;
 	struct seccomp_data data;
+	__u32 pidfd;
 };
 
 struct seccomp_notif_resp {
@@ -212,6 +213,10 @@ struct seccomp_notif_sizes {
 #define SECCOMP_USER_NOTIF_FLAG_CONTINUE 0x00000001
 #endif
 
+#ifndef SECCOMP_USER_NOTIF_FLAG_PIDFD
+#define SECCOMP_USER_NOTIF_FLAG_PIDFD	(1UL << 0)
+#endif
+
 #ifndef seccomp
 int seccomp(unsigned int op, unsigned int flags, void *args)
 {
@@ -1871,6 +1876,7 @@ FIXTURE_TEARDOWN(TRACE_syscall)
 		free(self->prog.filter);
 }
 
+
 TEST_F(TRACE_syscall, ptrace_syscall_redirected)
 {
 	/* Swap SECCOMP_RET_TRACE tracer for PTRACE_SYSCALL tracer. */
@@ -3612,6 +3618,110 @@ TEST(user_notification_continue)
 	}
 }
 
+static int sys_pidfd_send_signal(int pidfd, int sig, siginfo_t *info,
+				 unsigned int flags)
+{
+#ifdef __NR_pidfd_send_signal
+	return syscall(__NR_pidfd_send_signal, pidfd, sig, info, flags);
+#else
+	errno = ENOSYS;
+	return -1;
+#endif
+}
+
+TEST(user_notification_pidfd)
+{
+	struct seccomp_notif req = {
+		.flags	= SECCOMP_USER_NOTIF_FLAG_PIDFD,
+	};
+	struct seccomp_notif_resp resp = {};
+	int ret, listener, status;
+	pid_t pid;
+
+
+	ret = prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0);
+	ASSERT_EQ(0, ret) {
+		TH_LOG("Kernel does not support PR_SET_NO_NEW_PRIVS!");
+	}
+
+	listener = user_trap_syscall(__NR_getppid,
+				     SECCOMP_FILTER_FLAG_NEW_LISTENER);
+	ASSERT_GE(listener, 0);
+
+	pid = fork();
+	ASSERT_GE(pid, 0);
+
+	if (pid == 0) {
+		/* the process should be killed during this syscall */
+		syscall(__NR_getppid);
+		exit(0);
+	}
+
+	EXPECT_EQ(ioctl(listener, SECCOMP_IOCTL_NOTIF_RECV, &req), 0);
+	ASSERT_GE(req.pidfd, 0);
+
+	ASSERT_EQ(sys_pidfd_send_signal(req.pidfd, SIGKILL, NULL, 0), 0) {
+		XFAIL(goto out,
+		      "Kernel does not support pidfd_send_signal() syscall");
+		goto out;
+	}
+	EXPECT_EQ(req.pid, pid);
+
+	EXPECT_EQ(waitpid(pid, &status, 0), pid);
+	EXPECT_EQ(true, WIFSIGNALED(status));
+	EXPECT_EQ(SIGKILL, WTERMSIG(status));
+
+out:
+	close(req.pidfd);
+	close(listener);
+}
+
+TEST(user_notification_pidfd_fault)
+{
+	struct seccomp_notif req = {
+		.flags	= SECCOMP_USER_NOTIF_FLAG_PIDFD,
+	};
+	struct seccomp_notif_resp resp = {};
+	int ret, listener, status;
+	pid_t pid;
+
+	ret = prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0);
+	ASSERT_EQ(0, ret) {
+		TH_LOG("Kernel does not support PR_SET_NO_NEW_PRIVS!");
+	}
+
+	listener = user_trap_syscall(__NR_getppid,
+				     SECCOMP_FILTER_FLAG_NEW_LISTENER);
+	ASSERT_GE(listener, 0);
+
+	pid = fork();
+	ASSERT_GE(pid, 0);
+
+	if (pid == 0)
+		exit(syscall(__NR_getppid) != USER_NOTIF_MAGIC);
+
+	/* trigger an EFAULT */
+	EXPECT_EQ(ioctl(listener, SECCOMP_IOCTL_NOTIF_RECV, NULL), -1);
+	EXPECT_EQ(errno, EFAULT);
+
+	/* Check that we can still fetch it. */
+	EXPECT_EQ(ioctl(listener, SECCOMP_IOCTL_NOTIF_RECV, &req), 0);
+	EXPECT_EQ(req.pid, pid);
+
+	resp.id = req.id;
+	resp.error = 0;
+	resp.val = USER_NOTIF_MAGIC;
+
+	EXPECT_EQ(ioctl(listener, SECCOMP_IOCTL_NOTIF_SEND, &resp), 0);
+
+	EXPECT_EQ(waitpid(pid, &status, 0), pid);
+	EXPECT_EQ(true, WIFEXITED(status));
+	EXPECT_EQ(0, WEXITSTATUS(status));
+
+	close(req.pidfd);
+	close(listener);
+}
+
 /*
  * TODO:
  * - add microbenchmarks
-- 
2.20.1
