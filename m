From: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: [PATCH 3/7] selftests/ipc: change ipc test to use kselftest exit codes
Date: Mon, 15 Sep 2014 16:33:58 -0600
Message-ID: <1410820442-8774-4-git-send-email-shuahkh@osg.samsung.com>
References: <1410820442-8774-1-git-send-email-shuahkh@osg.samsung.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1410820442-8774-1-git-send-email-shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org, dbueso-l3A5Bk7waGM@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org, thierry-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, felipensp-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Change ipc test to use kselftest exit codes in kselftest.h
to report test results. With this change this test exits with
EXIT_FAIL instead of -errno. Changed print errno in test fail
messages to not loose that information.

Signed-off-by: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
---
 tools/testing/selftests/ipc/msgque.c | 26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/ipc/msgque.c b/tools/testing/selftests/ipc/msgque.c
index 552f081..2812017 100644
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
+		exit(EXIT_FAIL);
 	}
 
 	msgque.key = ftok(argv[0], 822155650);
 	if (msgque.key == -1) {
-		printf("Can't make key\n");
-		return -errno;
+		printf("Can't make key: %d\n", -errno);
+		return EXIT_FAIL;
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
+	return EXIT_PASS;
 
 err_destroy:
 	if (msgctl(msgque.msq_id, IPC_RMID, 0)) {
 		printf("Failed to destroy queue: %d\n", -errno);
-		return -errno;
+		return EXIT_FAIL;
 	}
 err_out:
-	return err;
+	return EXIT_FAIL;
 }
-- 
1.9.1
