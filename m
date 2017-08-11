From: Tyler Hicks <tyhicks@canonical.com>
Subject: [PATCH v6 4/6] seccomp: Selftest for detection of filter flag support
Date: Fri, 11 Aug 2017 04:33:55 +0000
Message-ID: <1502426037-3777-5-git-send-email-tyhicks@canonical.com>
References: <1502426037-3777-1-git-send-email-tyhicks@canonical.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1502426037-3777-1-git-send-email-tyhicks@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: Andy Lutomirski <luto@amacapital.net>, Will Drewry <wad@chromium.org>, Paul Moore <paul@paul-moore.com>, Eric Paris <eparis@redhat.com>, John Crispin <john@phrozen.org>, Tycho Andersen <tycho@docker.com>, linux-audit@redhat.com, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Userspace needs to be able to reliably detect the support of a filter
flag. A good way of doing that is by attempting to enter filter mode,
with the flag bit(s) in question set, and a NULL pointer for the args
parameter of seccomp(2). EFAULT indicates that the flag is valid and
EINVAL indicates that the flag is invalid.

This patch adds a selftest that can be used to test this method of
detection in userspace.

Signed-off-by: Tyler Hicks <tyhicks@canonical.com>
---
 tools/testing/selftests/seccomp/seccomp_bpf.c | 59 +++++++++++++++++++++++++++
 1 file changed, 59 insertions(+)

diff --git a/tools/testing/selftests/seccomp/seccomp_bpf.c b/tools/testing/selftests/seccomp/seccomp_bpf.c
index d3a78ec..ed4528c 100644
--- a/tools/testing/selftests/seccomp/seccomp_bpf.c
+++ b/tools/testing/selftests/seccomp/seccomp_bpf.c
@@ -1918,6 +1918,65 @@ TEST(seccomp_syscall_mode_lock)
 	}
 }
 
+/* Test detection of known and unknown filter flags. Userspace needs to be able
+ * to check if a filter flag is supported by the current kernel and a good way
+ * of doing that is by attempting to enter filter mode, with the flag bit in
+ * question set, and a NULL pointer for the _args_ parameter. EFAULT indicates
+ * that the flag is valid and EINVAL indicates that the flag is invalid.
+ */
+TEST(detect_seccomp_filter_flags)
+{
+	unsigned int flags[] = { SECCOMP_FILTER_FLAG_TSYNC,
+				 SECCOMP_FILTER_FLAG_KILL_PROCESS };
+	unsigned int flag, all_flags;
+	int i;
+	long ret;
+
+	/* Test detection of known-good filter flags */
+	for (i = 0, all_flags = 0; i < ARRAY_SIZE(flags); i++) {
+		flag = flags[i];
+		ret = seccomp(SECCOMP_SET_MODE_FILTER, flag, NULL);
+		ASSERT_NE(ENOSYS, errno) {
+			TH_LOG("Kernel does not support seccomp syscall!");
+		}
+		EXPECT_EQ(-1, ret);
+		EXPECT_EQ(EFAULT, errno) {
+			TH_LOG("Failed to detect that a known-good filter flag (0x%X) is supported!",
+			       flag);
+		}
+
+		all_flags |= flag;
+	}
+
+	/* Test detection of all known-good filter flags */
+	ret = seccomp(SECCOMP_SET_MODE_FILTER, all_flags, NULL);
+	EXPECT_EQ(-1, ret);
+	EXPECT_EQ(EFAULT, errno) {
+		TH_LOG("Failed to detect that all known-good filter flags (0x%X) are supported!",
+		       all_flags);
+	}
+
+	/* Test detection of an unknown filter flag */
+	flag = -1;
+	ret = seccomp(SECCOMP_SET_MODE_FILTER, flag, NULL);
+	EXPECT_EQ(-1, ret);
+	EXPECT_EQ(EINVAL, errno) {
+		TH_LOG("Failed to detect that an unknown filter flag (0x%X) is unsupported!",
+		       flag);
+	}
+
+	/* Test detection of an unknown filter flag that may simply need to be
+	 * added to this test
+	 */
+	flag = flags[ARRAY_SIZE(flags) - 1] << 1;
+	ret = seccomp(SECCOMP_SET_MODE_FILTER, flag, NULL);
+	EXPECT_EQ(-1, ret);
+	EXPECT_EQ(EINVAL, errno) {
+		TH_LOG("Failed to detect that an unknown filter flag (0x%X) is unsupported! Does a new flag need to be added to this test?",
+		       flag);
+	}
+}
+
 TEST(TSYNC_first)
 {
 	struct sock_filter filter[] = {
-- 
2.7.4
