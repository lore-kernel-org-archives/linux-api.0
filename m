From: Tyler Hicks <tyhicks@canonical.com>
Subject: [PATCH v5 4/6] seccomp: Operation for checking if an action is available
Date: Fri, 28 Jul 2017 20:55:50 +0000
Message-ID: <1501275352-30045-5-git-send-email-tyhicks@canonical.com>
References: <1501275352-30045-1-git-send-email-tyhicks@canonical.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1501275352-30045-1-git-send-email-tyhicks@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: Andy Lutomirski <luto@amacapital.net>, Will Drewry <wad@chromium.org>, Paul Moore <paul@paul-moore.com>, Eric Paris <eparis@redhat.com>, John Crispin <john@phrozen.org>, linux-audit@redhat.com, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Userspace code that needs to check if the kernel supports a given action
may not be able to use the /proc/sys/kernel/seccomp/actions_avail
sysctl. The process may be running in a sandbox and, therefore,
sufficient filesystem access may not be available. This patch adds an
operation to the seccomp(2) syscall that allows userspace code to ask
the kernel if a given action is available.

If the action is supported by the kernel, 0 is returned. If the action
is not supported by the kernel, -1 is returned with errno set to
-EOPNOTSUPP. If this check is attempted on a kernel that doesn't support
this new operation, -1 is returned with errno set to -EINVAL meaning
that userspace code will have the ability to differentiate between the
two error cases.

Signed-off-by: Tyler Hicks <tyhicks@canonical.com>
---

* Changes since v4:
  - This is new patch to allow applications to check if an action is supported
    without having to consult the actions_avail sysctl

 include/uapi/linux/seccomp.h                  |  5 ++--
 kernel/seccomp.c                              | 26 +++++++++++++++++++
 tools/testing/selftests/seccomp/seccomp_bpf.c | 36 +++++++++++++++++++++++++++
 3 files changed, 65 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/seccomp.h b/include/uapi/linux/seccomp.h
index 82c823c..19a611d 100644
--- a/include/uapi/linux/seccomp.h
+++ b/include/uapi/linux/seccomp.h
@@ -11,8 +11,9 @@
 #define SECCOMP_MODE_FILTER	2 /* uses user-supplied filter. */
 
 /* Valid operations for seccomp syscall. */
-#define SECCOMP_SET_MODE_STRICT	0
-#define SECCOMP_SET_MODE_FILTER	1
+#define SECCOMP_SET_MODE_STRICT		0
+#define SECCOMP_SET_MODE_FILTER		1
+#define SECCOMP_GET_ACTION_AVAIL	2
 
 /* Valid flags for SECCOMP_SET_MODE_FILTER */
 #define SECCOMP_FILTER_FLAG_TSYNC	1
diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index 1c4c496..03ad3ba 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -858,6 +858,27 @@ static inline long seccomp_set_mode_filter(unsigned int flags,
 }
 #endif
 
+static long seccomp_get_action_avail(const char __user *uaction)
+{
+	u32 action;
+
+	if (copy_from_user(&action, uaction, sizeof(action)))
+		return -EFAULT;
+
+	switch (action) {
+	case SECCOMP_RET_KILL:
+	case SECCOMP_RET_TRAP:
+	case SECCOMP_RET_ERRNO:
+	case SECCOMP_RET_TRACE:
+	case SECCOMP_RET_ALLOW:
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
 /* Common entry point for both prctl and syscall. */
 static long do_seccomp(unsigned int op, unsigned int flags,
 		       const char __user *uargs)
@@ -869,6 +890,11 @@ static long do_seccomp(unsigned int op, unsigned int flags,
 		return seccomp_set_mode_strict();
 	case SECCOMP_SET_MODE_FILTER:
 		return seccomp_set_mode_filter(flags, uargs);
+	case SECCOMP_GET_ACTION_AVAIL:
+		if (flags != 0)
+			return -EINVAL;
+
+		return seccomp_get_action_avail(uargs);
 	default:
 		return -EINVAL;
 	}
diff --git a/tools/testing/selftests/seccomp/seccomp_bpf.c b/tools/testing/selftests/seccomp/seccomp_bpf.c
index eeb4f7a..8f0872b 100644
--- a/tools/testing/selftests/seccomp/seccomp_bpf.c
+++ b/tools/testing/selftests/seccomp/seccomp_bpf.c
@@ -1683,6 +1683,10 @@ TEST_F_SIGNAL(TRACE_syscall, kill_after_ptrace, SIGSYS)
 #define SECCOMP_SET_MODE_FILTER 1
 #endif
 
+#ifndef SECCOMP_GET_ACTION_AVAIL
+#define SECCOMP_GET_ACTION_AVAIL 2
+#endif
+
 #ifndef SECCOMP_FILTER_FLAG_TSYNC
 #define SECCOMP_FILTER_FLAG_TSYNC 1
 #endif
@@ -2486,6 +2490,38 @@ TEST_SIGNAL(filter_flag_log, SIGSYS)
 	EXPECT_EQ(0, syscall(__NR_getpid));
 }
 
+TEST(get_action_avail)
+{
+	__u32 actions[] = { SECCOMP_RET_KILL,  SECCOMP_RET_TRAP,
+			    SECCOMP_RET_ERRNO, SECCOMP_RET_TRACE,
+			    SECCOMP_RET_ALLOW };
+	__u32 unknown_action = 0x10000000U;
+	int i;
+	long ret;
+
+	ret = seccomp(SECCOMP_GET_ACTION_AVAIL, 0, &actions[0]);
+	ASSERT_NE(ENOSYS, errno) {
+		TH_LOG("Kernel does not support seccomp syscall!");
+	}
+	ASSERT_NE(EINVAL, errno) {
+		TH_LOG("Kernel does not support SECCOMP_GET_ACTION_AVAIL operation!");
+	}
+	EXPECT_EQ(ret, 0);
+
+	for (i = 0; i < ARRAY_SIZE(actions); i++) {
+		ret = seccomp(SECCOMP_GET_ACTION_AVAIL, 0, &actions[i]);
+		EXPECT_EQ(ret, 0) {
+			TH_LOG("Expected action (0x%X) not available!",
+			       actions[i]);
+		}
+	}
+
+	/* Check that an unknown action is handled properly (EOPNOTSUPP) */
+	ret = seccomp(SECCOMP_GET_ACTION_AVAIL, 0, &unknown_action);
+	EXPECT_EQ(ret, -1);
+	EXPECT_EQ(errno, EOPNOTSUPP);
+}
+
 /*
  * TODO:
  * - add microbenchmarks
-- 
2.7.4
