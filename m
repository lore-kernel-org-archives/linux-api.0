From: Shuah Khan <shuahkh@osg.samsung.com>
Subject: [PATCH v3 4/5] selftests/kcmp: change test to use ksft framework
Date: Fri,  3 Oct 2014 09:36:19 -0600
Message-ID: <f4a788b9876f97128f7cdf250069a9cbba35aea5.1412349412.git.shuahkh@osg.samsung.com>
References: <cover.1412349412.git.shuahkh@osg.samsung.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1412349412.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1412349412.git.shuahkh@osg.samsung.com>
References: <cover.1412349412.git.shuahkh@osg.samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: akpm@linux-foundation.org, gregkh@linuxfoundation.org, colin.king@canonical.com, dbueso@suse.de, luto@amacapital.net
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Change kcmp test to use kselftest framework to report
test results and test statistics.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 tools/testing/selftests/kcmp/kcmp_test.c | 27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/kcmp/kcmp_test.c b/tools/testing/selftests/kcmp/kcmp_test.c
index dbba408..a5a4da8 100644
--- a/tools/testing/selftests/kcmp/kcmp_test.c
+++ b/tools/testing/selftests/kcmp/kcmp_test.c
@@ -17,6 +17,8 @@
 #include <sys/stat.h>
 #include <sys/wait.h>
 
+#include "../kselftest.h"
+
 static long sys_kcmp(int pid1, int pid2, int type, int fd1, int fd2)
 {
 	return syscall(__NR_kcmp, pid1, pid2, type, fd1, fd2);
@@ -34,13 +36,13 @@ int main(int argc, char **argv)
 
 	if (fd1 < 0) {
 		perror("Can't create file");
-		exit(1);
+		ksft_exit_fail();
 	}
 
 	pid2 = fork();
 	if (pid2 < 0) {
 		perror("fork failed");
-		exit(1);
+		ksft_exit_fail();
 	}
 
 	if (!pid2) {
@@ -50,7 +52,7 @@ int main(int argc, char **argv)
 		fd2 = open(kpath, O_RDWR, 0644);
 		if (fd2 < 0) {
 			perror("Can't open file");
-			exit(1);
+			ksft_exit_fail();
 		}
 
 		/* An example of output and arguments */
@@ -74,23 +76,34 @@ int main(int argc, char **argv)
 		if (ret) {
 			printf("FAIL: 0 expected but %d returned (%s)\n",
 				ret, strerror(errno));
+			ksft_inc_fail_cnt();
 			ret = -1;
-		} else
+		} else {
 			printf("PASS: 0 returned as expected\n");
+			ksft_inc_pass_cnt();
+		}
 
 		/* Compare with self */
 		ret = sys_kcmp(pid1, pid1, KCMP_VM, 0, 0);
 		if (ret) {
 			printf("FAIL: 0 expected but %d returned (%s)\n",
 				ret, strerror(errno));
+			ksft_inc_fail_cnt();
 			ret = -1;
-		} else
+		} else {
 			printf("PASS: 0 returned as expected\n");
+			ksft_inc_pass_cnt();
+		}
+
+		ksft_print_cnts();
 
-		exit(ret);
+		if (ret)
+			ksft_exit_fail();
+		else
+			ksft_exit_pass();
 	}
 
 	waitpid(pid2, &status, P_ALL);
 
-	return 0;
+	return ksft_exit_pass();
 }
-- 
1.9.1
