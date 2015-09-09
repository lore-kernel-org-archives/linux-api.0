From: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: [PATCH] selftests/seccomp: build on aarch64, document ABI
Date: Wed, 9 Sep 2015 12:30:27 -0700
Message-ID: <20150909193025.GA29244@www.outflux.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
Cc: Bamvor Zhang Jian <bamvor.zhangjian-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

The syscall ABI is inconsistent on aarch64 compat, so at least we should
document it in the seccomp_bpf tests.

Signed-off-by: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
---
Can someone with access to native aarch64 double-check this for me? I
think we need to change these tests to pass if it's expected, but the
compat behavior seems bad. It means compat code will break under an
aarch64 kernel, when dealing with syscalls, like through seccomp.
---
 tools/testing/selftests/seccomp/seccomp_bpf.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/seccomp/seccomp_bpf.c b/tools/testing/selftests/seccomp/seccomp_bpf.c
index 770f47adf295..866ff42e000d 100644
--- a/tools/testing/selftests/seccomp/seccomp_bpf.c
+++ b/tools/testing/selftests/seccomp/seccomp_bpf.c
@@ -33,6 +33,10 @@
 #include <unistd.h>
 #include <sys/syscall.h>
 
+#if defined(__aarch64__) && !defined(__NR_poll)
+# define __NR_poll 0x49
+#endif
+
 #include "test_harness.h"
 
 #ifndef PR_SET_PTRACER
@@ -2124,10 +2128,17 @@ TEST(syscall_restart)
 	ASSERT_EQ(SIGTRAP, WSTOPSIG(status));
 	ASSERT_EQ(PTRACE_EVENT_SECCOMP, (status >> 16));
 	ASSERT_EQ(0, ptrace(PTRACE_GETEVENTMSG, child_pid, NULL, &msg));
-	ASSERT_EQ(0x200, msg);
+
+	/*
+	 * FIXME:
+	 * - native ARM does not expose true syscall.
+	 * - compat ARM on ARM64 does expose true syscall.
+	 * - native ARM64 hides true syscall even from seccomp.
+	 */
+	ASSERT_EQ(0x200, msg);	/* This will fail on native arm64. */
 	ret = get_syscall(_metadata, child_pid);
 #if defined(__arm__)
-	/* FIXME: ARM does not expose true syscall in registers. */
+	/* This will fail on arm64 in compat mode. */
 	EXPECT_EQ(__NR_poll, ret);
 #else
 	EXPECT_EQ(__NR_restart_syscall, ret);
-- 
1.9.1

-- 
Kees Cook
Chrome OS Security
