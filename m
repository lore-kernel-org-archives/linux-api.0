From: Bamvor Jian Zhang <bamvor.zhangjian-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v2] selftests/seccomp: Get page size from sysconf
Date: Fri, 13 Nov 2015 11:17:51 +0800
Message-ID: <1447384671-17758-1-git-send-email-bamvor.zhangjian@linaro.org>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: rsesek-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org, Bamvor Jian Zhang <bamvor.zhangjian-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

The commit fd88d16c58c2 ("selftests/seccomp: Be more precise with
syscall arguments.") use PAGE_SIZE directly which lead to build
failure on arm64.

Replace it with generic interface(sysconf(_SC_PAGESIZE)) to fix this
failure.

Build and test successful on x86_64 and arm64.

Signed-off-by: Bamvor Jian Zhang <bamvor.zhangjian-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
Add assertion for page_size.

 tools/testing/selftests/seccomp/seccomp_bpf.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/seccomp/seccomp_bpf.c b/tools/testing/selftests/seccomp/seccomp_bpf.c
index e38cc54..882fe83 100644
--- a/tools/testing/selftests/seccomp/seccomp_bpf.c
+++ b/tools/testing/selftests/seccomp/seccomp_bpf.c
@@ -492,6 +492,9 @@ TEST_SIGNAL(KILL_one_arg_six, SIGSYS)
 	pid_t parent = getppid();
 	int fd;
 	void *map1, *map2;
+	int page_size = sysconf(_SC_PAGESIZE);
+
+	ASSERT_LT(0, page_size);
 
 	ret = prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0);
 	ASSERT_EQ(0, ret);
@@ -504,16 +507,16 @@ TEST_SIGNAL(KILL_one_arg_six, SIGSYS)
 
 	EXPECT_EQ(parent, syscall(__NR_getppid));
 	map1 = (void *)syscall(sysno,
-		NULL, PAGE_SIZE, PROT_READ, MAP_PRIVATE, fd, PAGE_SIZE);
+		NULL, page_size, PROT_READ, MAP_PRIVATE, fd, page_size);
 	EXPECT_NE(MAP_FAILED, map1);
 	/* mmap2() should never return. */
 	map2 = (void *)syscall(sysno,
-		 NULL, PAGE_SIZE, PROT_READ, MAP_PRIVATE, fd, 0x0C0FFEE);
+		 NULL, page_size, PROT_READ, MAP_PRIVATE, fd, 0x0C0FFEE);
 	EXPECT_EQ(MAP_FAILED, map2);
 
 	/* The test failed, so clean up the resources. */
-	munmap(map1, PAGE_SIZE);
-	munmap(map2, PAGE_SIZE);
+	munmap(map1, page_size);
+	munmap(map2, page_size);
 	close(fd);
 }
 
-- 
2.1.4
