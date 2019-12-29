From: Sargun Dhillon <sargun@sargun.me>
Subject: [PATCH v3 3/3] selftests/seccomp: Test kernel catches garbage on SECCOMP_IOCTL_NOTIF_RECV
Date: Sat, 28 Dec 2019 22:24:51 -0800
Message-ID: <20191229062451.9467-3-sargun@sargun.me>
References: <20191229062451.9467-1-sargun@sargun.me>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191229062451.9467-1-sargun@sargun.me>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Cc: Jann Horn <jannh@google.com>, Christian Brauner <christian.brauner@ubuntu.com>, Kees Cook <keescook@chromium.org>, Aleksa Sarai <cyphar@cyphar.com>, Tycho Andersen <tycho@tycho.ws>, Sargun Dhillon <sargun@sargun.me>
List-Id: linux-api@vger.kernel.org

Add a self-test to make sure that the kernel returns EINVAL, if any
of the fields in seccomp_notif are set to non-null.

Signed-off-by: Sargun Dhillon <sargun@sargun.me>
Suggested-by: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Kees Cook <keescook@chromium.org>
---
 tools/testing/selftests/seccomp/seccomp_bpf.c | 23 +++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/tools/testing/selftests/seccomp/seccomp_bpf.c b/tools/testing/selftests/seccomp/seccomp_bpf.c
index f53f14971bff..379391a7fa41 100644
--- a/tools/testing/selftests/seccomp/seccomp_bpf.c
+++ b/tools/testing/selftests/seccomp/seccomp_bpf.c
@@ -3601,6 +3601,29 @@ TEST(user_notification_continue)
 	}
 }
 
+TEST(user_notification_garbage)
+{
+	/*
+	 * intentionally set pid to a garbage value to make sure the kernel
+	 * catches it
+	 */
+	struct seccomp_notif req = {
+		.pid	= 1,
+	};
+	int ret, listener;
+
+	ret = prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0);
+	ASSERT_EQ(0, ret) {
+		TH_LOG("Kernel does not support PR_SET_NO_NEW_PRIVS!");
+	}
+
+	listener = user_trap_syscall(__NR_dup, SECCOMP_FILTER_FLAG_NEW_LISTENER);
+	ASSERT_GE(listener, 0);
+
+	EXPECT_EQ(-1, ioctl(listener, SECCOMP_IOCTL_NOTIF_RECV, &req));
+	EXPECT_EQ(EINVAL, errno);
+}
+
 /*
  * TODO:
  * - add microbenchmarks
-- 
2.20.1
