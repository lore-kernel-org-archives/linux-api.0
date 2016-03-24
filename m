From: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
Subject: [RFC v1 11/17] selftest/seccomp: Add argeval_open_whitelist test
Date: Thu, 24 Mar 2016 03:53:56 +0100
Message-ID: <1458788042-26173-3-git-send-email-mic@digikod.net>
References: <1458784008-16277-1-git-send-email-mic@digikod.net>
 <1458788042-26173-1-git-send-email-mic@digikod.net>
Reply-To: kernel-hardening@lists.openwall.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <kernel-hardening-return-2841-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <1458788042-26173-1-git-send-email-mic@digikod.net>
To: linux-security-module@vger.kernel.org
Cc: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>, Andreas Gruenbacher <agruenba@redhat.com>, Andy Lutomirski <luto@amacapital.net>, Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Casey Schaufler <casey@schaufler-ca.com>, Daniel Borkmann <daniel@iogearbox.net>, David Drysdale <drysdale@google.com>, Eric Paris <eparis@redhat.com>, James Morris <james.l.morris@oracle.com>, Jeff Dike <jdike@addtoit.com>, Julien Tinnes <jln@google.com>, Kees Cook <keescook@chromium.org>, Michael Kerrisk <mtk@man7.org>, Paul Moore <pmoore@redhat.com>, Richard Weinberger <richard@nod.at>, "Serge E . Hallyn" <serge@hallyn.com>, Stephen Smalley <sds@tycho.nsa.gov>, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, Will Drewry <wad@chromium.org>, linux-api@vger.kernel.org, kernel-hardening@lists.openwall.com
List-Id: linux-api@vger.kernel.org

Test a basic sandbox adding a checker group and using it for path
filtering.

Signed-off-by: Mickaël Salaün <mic@digikod.net>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Paul Moore <pmoore@redhat.com>
Cc: Will Drewry <wad@chromium.org>
---
 tools/testing/selftests/seccomp/seccomp_bpf.c | 114 ++++++++++++++++++++++++++
 1 file changed, 114 insertions(+)

diff --git a/tools/testing/selftests/seccomp/seccomp_bpf.c b/tools/testing/selftests/seccomp/seccomp_bpf.c
index 8b1a6bfc64a1..49c5d39c30a4 100644
--- a/tools/testing/selftests/seccomp/seccomp_bpf.c
+++ b/tools/testing/selftests/seccomp/seccomp_bpf.c
@@ -2237,6 +2237,120 @@ TEST(field_is_valid_syscall)
 	EXPECT_EQ(-1, syscall(__NR_getpid));
 	EXPECT_EQ(EINVAL, errno);
 }
+
+#define PATH_DEV_NULL "/dev/null"
+#define PATH_DEV_ZERO "/dev/zero"
+
+/* The sandbox0 allow opening only @allowed_path */
+void apply_sandbox0(struct __test_metadata *_metadata, const char *allowed_path)
+{
+	struct sock_filter filter0[] = {
+		/* Only care about open(2) */
+		BPF_STMT(BPF_LD|BPF_W|BPF_ABS,
+				offsetof(struct seccomp_data, nr)),
+		BPF_JUMP(BPF_JMP|BPF_JEQ|BPF_K, __NR_open, 0, 1),
+		/* Check the objects of group 5 matching the first argument */
+		BPF_STMT(BPF_RET|BPF_K, SECCOMP_RET_ARGEVAL | 1 << 8 | 5),
+		BPF_STMT(BPF_RET|BPF_K, SECCOMP_RET_ALLOW),
+	};
+	struct sock_fprog prog0 = {
+		.len = (unsigned short)ARRAY_SIZE(filter0),
+		.filter = filter0,
+	};
+	struct sock_filter filter1[] = {
+		/* Does not need to check for arch nor syscall number because
+		 * of the @checker_group check
+		 */
+		BPF_STMT(BPF_LD|BPF_W|BPF_ABS,
+				offsetof(struct seccomp_data, checker_group)),
+		BPF_JUMP(BPF_JMP|BPF_JEQ|BPF_K, 5, 1, 0),
+		BPF_STMT(BPF_RET|BPF_K, SECCOMP_RET_ALLOW),
+		/* Kill if not a valid syscall (unknown open‽) */
+		BPF_STMT(BPF_LD|BPF_W|BPF_ABS,
+				offsetof(struct seccomp_data, is_valid_syscall)),
+		BPF_JUMP(BPF_JMP|BPF_JEQ|BPF_K, 1, 1, 0),
+		BPF_STMT(BPF_RET|BPF_K, SECCOMP_RET_KILL),
+		/* Denied access if the first argument was not validated by the
+		 * checker.
+		 */
+		BPF_STMT(BPF_LD|BPF_W|BPF_ABS, match_arg(0)),
+		/* Match the first two checkers, if any */
+		BPF_JUMP(BPF_JMP|BPF_JSET|BPF_K, 3, 0, 1),
+		BPF_STMT(BPF_RET|BPF_K, SECCOMP_RET_ALLOW),
+		/* Use an impossible errno value to ensure it comes from our
+		 * filter (should be EACCES most of the time).
+		 */
+		BPF_STMT(BPF_RET|BPF_K, SECCOMP_RET_ERRNO | E2BIG),
+	};
+	struct sock_fprog prog1 = {
+		.len = (unsigned short)ARRAY_SIZE(filter1),
+		.filter = filter1,
+	};
+	struct seccomp_object_path path0 = SECCOMP_MAKE_PATH_DENTRY(allowed_path);
+	struct seccomp_checker checker0[] = {
+		SECCOMP_MAKE_OBJ_PATH(FS_LITERAL, &path0),
+	};
+	/* Group 5 */
+	struct seccomp_checker_group checker_group0 = {
+		.version = 1,
+		.id = 5,
+		.len = ARRAY_SIZE(checker0),
+		.checkers = &checker0,
+	};
+
+	/* Set up the test sandbox */
+	ASSERT_EQ(0, prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0)) {
+		TH_LOG("Kernel does not support PR_SET_NO_NEW_PRIVS!");
+	}
+	/* Load the path checkers */
+	EXPECT_EQ(0, seccomp(SECCOMP_ADD_CHECKER_GROUP, 0, &checker_group0)) {
+		TH_LOG("Failed to add checker group!");
+	}
+	/* Load filters in reverse order */
+	EXPECT_EQ(0, seccomp(SECCOMP_SET_MODE_FILTER, 0, &prog1)) {
+		TH_LOG("Failed to install filter!");
+	}
+	EXPECT_EQ(0, seccomp(SECCOMP_SET_MODE_FILTER,
+				SECCOMP_FILTER_FLAG_TSYNC, &prog0)) {
+		TH_LOG("Failed to install filter!");
+	}
+}
+
+TEST(argeval_open_whitelist)
+{
+	int fd;
+
+	/* Validate the first test file */
+	fd = open(PATH_DEV_ZERO, O_RDONLY);
+	EXPECT_NE(-1, fd) {
+		TH_LOG("Failed to open " PATH_DEV_ZERO);
+	}
+	close(fd);
+
+	/* Validate the second test file */
+	fd = open(PATH_DEV_NULL, O_RDONLY);
+	EXPECT_NE(-1, fd) {
+		TH_LOG("Failed to open " PATH_DEV_NULL);
+	}
+	close(fd);
+
+	apply_sandbox0(_metadata, PATH_DEV_ZERO);
+
+	/* Allowed file */
+	fd = open(PATH_DEV_ZERO, O_RDONLY);
+	EXPECT_NE(-1, fd) {
+		TH_LOG("Failed to open " PATH_DEV_ZERO);
+	}
+	close(fd);
+
+	/* Denied file (by the filter) */
+	fd = open(PATH_DEV_NULL, O_RDONLY);
+	EXPECT_EQ(-1, fd) {
+		TH_LOG("Could open " PATH_DEV_NULL);
+	}
+	EXPECT_EQ(E2BIG, errno);
+	close(fd);
+}
 #endif /* SECCOMP_DATA_ARGEVAL_PRESENT */
 
 /*
-- 
2.8.0.rc3
