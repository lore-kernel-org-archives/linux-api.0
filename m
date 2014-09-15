From: Shuah Khan <shuahkh@osg.samsung.com>
Subject: [PATCH 4/7] selftests/kcmp: change kcmp test to use kselftest exit codes
Date: Mon, 15 Sep 2014 16:33:59 -0600
Message-ID: <1410820442-8774-5-git-send-email-shuahkh@osg.samsung.com>
References: <1410820442-8774-1-git-send-email-shuahkh@osg.samsung.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1410820442-8774-1-git-send-email-shuahkh@osg.samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: akpm@linux-foundation.org, gregkh@linuxfoundation.org, colin.king@canonical.com, dbueso@suse.de, ebiederm@xmission.com, serge.hallyn@ubuntu.com, thierry@linux.vnet.ibm.com, felipensp@gmail.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Change kcmp test to use kselftest exit codes in kselftest.h
to report test results.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 tools/testing/selftests/kcmp/kcmp_test.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/kcmp/kcmp_test.c b/tools/testing/selftests/kcmp/kcmp_test.c
index dbba408..68bc70e 100644
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
@@ -34,23 +36,23 @@ int main(int argc, char **argv)
 
 	if (fd1 < 0) {
 		perror("Can't create file");
-		exit(1);
+		exit(EXIT_FAIL);
 	}
 
 	pid2 = fork();
 	if (pid2 < 0) {
 		perror("fork failed");
-		exit(1);
+		exit(EXIT_FAIL);
 	}
 
 	if (!pid2) {
 		int pid2 = getpid();
-		int ret;
+		int ret = EXIT_PASS;
 
 		fd2 = open(kpath, O_RDWR, 0644);
 		if (fd2 < 0) {
 			perror("Can't open file");
-			exit(1);
+			exit(EXIT_FAIL);
 		}
 
 		/* An example of output and arguments */
@@ -74,7 +76,7 @@ int main(int argc, char **argv)
 		if (ret) {
 			printf("FAIL: 0 expected but %d returned (%s)\n",
 				ret, strerror(errno));
-			ret = -1;
+			ret = EXIT_FAIL;
 		} else
 			printf("PASS: 0 returned as expected\n");
 
@@ -83,7 +85,7 @@ int main(int argc, char **argv)
 		if (ret) {
 			printf("FAIL: 0 expected but %d returned (%s)\n",
 				ret, strerror(errno));
-			ret = -1;
+			ret = EXIT_FAIL;
 		} else
 			printf("PASS: 0 returned as expected\n");
 
@@ -92,5 +94,5 @@ int main(int argc, char **argv)
 
 	waitpid(pid2, &status, P_ALL);
 
-	return 0;
+	return EXIT_PASS;
 }
-- 
1.9.1
