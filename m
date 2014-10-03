From: Shuah Khan <shuahkh@osg.samsung.com>
Subject: [PATCH v3 3/5] selftests/ipc: change test to use ksft framework
Date: Fri,  3 Oct 2014 09:36:18 -0600
Message-ID: <fb7ed86d44adbc7f97f9e42b314e4fce5616959e.1412349412.git.shuahkh@osg.samsung.com>
References: <cover.1412349412.git.shuahkh@osg.samsung.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1412349412.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1412349412.git.shuahkh@osg.samsung.com>
References: <cover.1412349412.git.shuahkh@osg.samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: akpm@linux-foundation.org, gregkh@linuxfoundation.org, colin.king@canonical.com, dbueso@suse.de, luto@amacapital.net
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Change ipc test to use kselftest framework to report
test results. With this change this test exits with
EXIT_FAIL instead of -errno. Changed print errno in
test fail messages to not loose that information.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 tools/testing/selftests/ipc/msgque.c | 26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/ipc/msgque.c b/tools/testing/selftests/ipc/msgque.c
index 552f081..1b2ce33 100644
--- a/tools/testing/selftests/ipc/msgque.c
+++ b/tools/testing/selftests/ipc/msgque.c
@@ -5,6 +5,8 @@
 #include <linux/msg.h>
 #include <fcntl.h>
 
+#include "../kselftest.h"
+
 #define MAX_MSG_SIZE		32
 
 struct msg1 {
@@ -195,58 +197,58 @@ int main(int argc, char **argv)
 
 	if (getuid() != 0) {
 		printf("Please run the test as root - Exiting.\n");
-		exit(1);
+		return ksft_exit_fail();
 	}
 
 	msgque.key = ftok(argv[0], 822155650);
 	if (msgque.key == -1) {
-		printf("Can't make key\n");
-		return -errno;
+		printf("Can't make key: %d\n", -errno);
+		return ksft_exit_fail();
 	}
 
 	msgque.msq_id = msgget(msgque.key, IPC_CREAT | IPC_EXCL | 0666);
 	if (msgque.msq_id == -1) {
 		err = -errno;
-		printf("Can't create queue\n");
+		printf("Can't create queue: %d\n", err);
 		goto err_out;
 	}
 
 	err = fill_msgque(&msgque);
 	if (err) {
-		printf("Failed to fill queue\n");
+		printf("Failed to fill queue: %d\n", err);
 		goto err_destroy;
 	}
 
 	err = dump_queue(&msgque);
 	if (err) {
-		printf("Failed to dump queue\n");
+		printf("Failed to dump queue: %d\n", err);
 		goto err_destroy;
 	}
 
 	err = check_and_destroy_queue(&msgque);
 	if (err) {
-		printf("Failed to check and destroy queue\n");
+		printf("Failed to check and destroy queue: %d\n", err);
 		goto err_out;
 	}
 
 	err = restore_queue(&msgque);
 	if (err) {
-		printf("Failed to restore queue\n");
+		printf("Failed to restore queue: %d\n", err);
 		goto err_destroy;
 	}
 
 	err = check_and_destroy_queue(&msgque);
 	if (err) {
-		printf("Failed to test queue\n");
+		printf("Failed to test queue: %d\n", err);
 		goto err_out;
 	}
-	return 0;
+	return ksft_exit_pass();
 
 err_destroy:
 	if (msgctl(msgque.msq_id, IPC_RMID, 0)) {
 		printf("Failed to destroy queue: %d\n", -errno);
-		return -errno;
+		return ksft_exit_fail();
 	}
 err_out:
-	return err;
+	return ksft_exit_fail();
 }
-- 
1.9.1
