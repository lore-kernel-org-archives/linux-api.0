From: Tyler Hicks <tyhicks@canonical.com>
Subject: [PATCH v6 2/6] seccomp: Operation for checking if an action is
	available
Date: Fri, 11 Aug 2017 04:33:53 +0000
Message-ID: <1502426037-3777-3-git-send-email-tyhicks@canonical.com>
References: <1502426037-3777-1-git-send-email-tyhicks@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-audit-bounces@redhat.com>
In-Reply-To: <1502426037-3777-1-git-send-email-tyhicks@canonical.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/linux-audit>,
	<mailto:linux-audit-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/linux-audit>
List-Post: <mailto:linux-audit@redhat.com>
List-Help: <mailto:linux-audit-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/linux-audit>,
	<mailto:linux-audit-request@redhat.com?subject=subscribe>
Sender: linux-audit-bounces@redhat.com
Errors-To: linux-audit-bounces@redhat.com
To: Kees Cook <keescook@chromium.org>
Cc: Tycho Andersen <tycho@docker.com>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>, linux-audit@redhat.com, John Crispin <john@phrozen.org>, Will Drewry <wad@chromium.org>
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
Suggested-by: Andy Lutomirski <luto@amacapital.net>
---
 include/uapi/linux/seccomp.h                  |  5 ++--
 kernel/seccomp.c                              | 26 +++++++++++++++++++
 tools/testing/selftests/seccomp/seccomp_bpf.c | 36 +++++++++++++++++++++++++++
 3 files changed, 65 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/seccomp.h b/include/uapi/linux/seccomp.h
index 4b75d8c..95d20d2 100644
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
 #define SECCOMP_FILTER_FLAG_TSYNC		1
diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index ee77eb3..1e57eff 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -854,6 +854,27 @@ static inline long seccomp_set_mode_filter(unsigned int flags,
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
@@ -865,6 +886,11 @@ static long do_seccomp(unsigned int op, unsigned int flags,
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
index 92f2779..d3a78ec 100644
--- a/tools/testing/selftests/seccomp/seccomp_bpf.c
+++ b/tools/testing/selftests/seccomp/seccomp_bpf.c
@@ -116,6 +116,10 @@ struct seccomp_data {
 #define SECCOMP_SET_MODE_FILTER 1
 #endif
 
+#ifndef SECCOMP_GET_ACTION_AVAIL
+#define SECCOMP_GET_ACTION_AVAIL 2
+#endif
+
 #ifndef SECCOMP_FILTER_FLAG_TSYNC
 #define SECCOMP_FILTER_FLAG_TSYNC 1
 #endif
@@ -2552,6 +2556,38 @@ TEST(syscall_restart)
 		_metadata->passed = 0;
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
