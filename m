From: Kees Cook <keescook@chromium.org>
Subject: [PATCH v3 3/4] selftests/seccomp: Refactor RET_ERRNO tests
Date: Wed,  9 Aug 2017 12:01:56 -0700
Message-ID: <1502305317-85052-4-git-send-email-keescook@chromium.org>
References: <1502305317-85052-1-git-send-email-keescook@chromium.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1502305317-85052-1-git-send-email-keescook@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Tyler Hicks <tyhicks@canonical.com>, Fabricio Voznika <fvoznika@google.com>, Andy Lutomirski <luto@amacapital.net>, Will Drewry <wad@chromium.org>, Tycho Andersen <tycho@docker.com>, Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org, linux-security-module@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

This refactors the errno tests (since they all use the same pattern for
their filter) and adds a RET_DATA field ordering test.

Signed-off-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Tyler Hicks <tyhicks@canonical.com>
---
 tools/testing/selftests/seccomp/seccomp_bpf.c | 95 ++++++++++++++++-----------
 1 file changed, 58 insertions(+), 37 deletions(-)

diff --git a/tools/testing/selftests/seccomp/seccomp_bpf.c b/tools/testing/selftests/seccomp/seccomp_bpf.c
index 73f5ea6778ce..ee78a53da5d1 100644
--- a/tools/testing/selftests/seccomp/seccomp_bpf.c
+++ b/tools/testing/selftests/seccomp/seccomp_bpf.c
@@ -136,7 +136,7 @@ TEST(no_new_privs_support)
 	}
 }
 
-/* Tests kernel support by checking for a copy_from_user() fault on * NULL. */
+/* Tests kernel support by checking for a copy_from_user() fault on NULL. */
 TEST(mode_filter_support)
 {
 	long ret;
@@ -541,26 +541,30 @@ TEST(arg_out_of_range)
 	EXPECT_EQ(EINVAL, errno);
 }
 
+#define ERRNO_FILTER(name, errno)					\
+	struct sock_filter _read_filter_##name[] = {			\
+		BPF_STMT(BPF_LD|BPF_W|BPF_ABS,				\
+			offsetof(struct seccomp_data, nr)),		\
+		BPF_JUMP(BPF_JMP|BPF_JEQ|BPF_K, __NR_read, 0, 1),	\
+		BPF_STMT(BPF_RET|BPF_K, SECCOMP_RET_ERRNO | errno),	\
+		BPF_STMT(BPF_RET|BPF_K, SECCOMP_RET_ALLOW),		\
+	};								\
+	struct sock_fprog prog_##name = {				\
+		.len = (unsigned short)ARRAY_SIZE(_read_filter_##name),	\
+		.filter = _read_filter_##name,				\
+	}
+
+/* Make sure basic errno values are correctly passed through a filter. */
 TEST(ERRNO_valid)
 {
-	struct sock_filter filter[] = {
-		BPF_STMT(BPF_LD|BPF_W|BPF_ABS,
-			offsetof(struct seccomp_data, nr)),
-		BPF_JUMP(BPF_JMP|BPF_JEQ|BPF_K, __NR_read, 0, 1),
-		BPF_STMT(BPF_RET|BPF_K, SECCOMP_RET_ERRNO | E2BIG),
-		BPF_STMT(BPF_RET|BPF_K, SECCOMP_RET_ALLOW),
-	};
-	struct sock_fprog prog = {
-		.len = (unsigned short)ARRAY_SIZE(filter),
-		.filter = filter,
-	};
+	ERRNO_FILTER(valid, E2BIG);
 	long ret;
 	pid_t parent = getppid();
 
 	ret = prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0);
 	ASSERT_EQ(0, ret);
 
-	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &prog);
+	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &prog_valid);
 	ASSERT_EQ(0, ret);
 
 	EXPECT_EQ(parent, syscall(__NR_getppid));
@@ -568,26 +572,17 @@ TEST(ERRNO_valid)
 	EXPECT_EQ(E2BIG, errno);
 }
 
+/* Make sure an errno of zero is correctly handled by the arch code. */
 TEST(ERRNO_zero)
 {
-	struct sock_filter filter[] = {
-		BPF_STMT(BPF_LD|BPF_W|BPF_ABS,
-			offsetof(struct seccomp_data, nr)),
-		BPF_JUMP(BPF_JMP|BPF_JEQ|BPF_K, __NR_read, 0, 1),
-		BPF_STMT(BPF_RET|BPF_K, SECCOMP_RET_ERRNO | 0),
-		BPF_STMT(BPF_RET|BPF_K, SECCOMP_RET_ALLOW),
-	};
-	struct sock_fprog prog = {
-		.len = (unsigned short)ARRAY_SIZE(filter),
-		.filter = filter,
-	};
+	ERRNO_FILTER(zero, 0);
 	long ret;
 	pid_t parent = getppid();
 
 	ret = prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0);
 	ASSERT_EQ(0, ret);
 
-	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &prog);
+	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &prog_zero);
 	ASSERT_EQ(0, ret);
 
 	EXPECT_EQ(parent, syscall(__NR_getppid));
@@ -595,26 +590,21 @@ TEST(ERRNO_zero)
 	EXPECT_EQ(0, read(0, NULL, 0));
 }
 
+/*
+ * The SECCOMP_RET_DATA mask is 16 bits wide, but errno is smaller.
+ * This tests that the errno value gets capped correctly, fixed by
+ * 580c57f10768 ("seccomp: cap SECCOMP_RET_ERRNO data to MAX_ERRNO").
+ */
 TEST(ERRNO_capped)
 {
-	struct sock_filter filter[] = {
-		BPF_STMT(BPF_LD|BPF_W|BPF_ABS,
-			offsetof(struct seccomp_data, nr)),
-		BPF_JUMP(BPF_JMP|BPF_JEQ|BPF_K, __NR_read, 0, 1),
-		BPF_STMT(BPF_RET|BPF_K, SECCOMP_RET_ERRNO | 4096),
-		BPF_STMT(BPF_RET|BPF_K, SECCOMP_RET_ALLOW),
-	};
-	struct sock_fprog prog = {
-		.len = (unsigned short)ARRAY_SIZE(filter),
-		.filter = filter,
-	};
+	ERRNO_FILTER(capped, 4096);
 	long ret;
 	pid_t parent = getppid();
 
 	ret = prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0);
 	ASSERT_EQ(0, ret);
 
-	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &prog);
+	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &prog_capped);
 	ASSERT_EQ(0, ret);
 
 	EXPECT_EQ(parent, syscall(__NR_getppid));
@@ -622,6 +612,37 @@ TEST(ERRNO_capped)
 	EXPECT_EQ(4095, errno);
 }
 
+/*
+ * Filters are processed in reverse order: last applied is executed first.
+ * Since only the SECCOMP_RET_ACTION mask is tested for return values, the
+ * SECCOMP_RET_DATA mask results will follow the most recently applied
+ * matching filter return (and not the lowest or highest value).
+ */
+TEST(ERRNO_order)
+{
+	ERRNO_FILTER(first,  11);
+	ERRNO_FILTER(second, 13);
+	ERRNO_FILTER(third,  12);
+	long ret;
+	pid_t parent = getppid();
+
+	ret = prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0);
+	ASSERT_EQ(0, ret);
+
+	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &prog_first);
+	ASSERT_EQ(0, ret);
+
+	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &prog_second);
+	ASSERT_EQ(0, ret);
+
+	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &prog_third);
+	ASSERT_EQ(0, ret);
+
+	EXPECT_EQ(parent, syscall(__NR_getppid));
+	EXPECT_EQ(-1, read(0, NULL, 0));
+	EXPECT_EQ(12, errno);
+}
+
 FIXTURE_DATA(TRAP) {
 	struct sock_fprog prog;
 };
-- 
2.7.4
