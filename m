From: Sriram Raghunathan <sriram-prL/mWnggxQSDc0kpPPPTw@public.gmane.org>
Subject: [PATCH 1/1] Replacing return statements with existinig goto statement
Date: Thu, 19 Nov 2015 22:45:33 +0530
Message-ID: <1447953333-11043-1-git-send-email-sriram@marirs.net.in>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sriram Raghunathan <sriram-prL/mWnggxQSDc0kpPPPTw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

The below code, calls the goto variable, instead of calling the a return. 
goto does the same function call. Patch intends more of a cleanup than a change 
to existing behavior.

Signed-off-by: Sriram Raghunathan <sriram-prL/mWnggxQSDc0kpPPPTw@public.gmane.org>
---
 tools/testing/selftests/ipc/msgque.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/ipc/msgque.c b/tools/testing/selftests/ipc/msgque.c
index 1b2ce33..7b68381 100644
--- a/tools/testing/selftests/ipc/msgque.c
+++ b/tools/testing/selftests/ipc/msgque.c
@@ -197,13 +197,13 @@ int main(int argc, char **argv)
 
 	if (getuid() != 0) {
 		printf("Please run the test as root - Exiting.\n");
-		return ksft_exit_fail();
+		goto err_out;
 	}
 
 	msgque.key = ftok(argv[0], 822155650);
 	if (msgque.key == -1) {
 		printf("Can't make key: %d\n", -errno);
-		return ksft_exit_fail();
+		goto err_out;
 	}
 
 	msgque.msq_id = msgget(msgque.key, IPC_CREAT | IPC_EXCL | 0666);
@@ -247,7 +247,7 @@ int main(int argc, char **argv)
 err_destroy:
 	if (msgctl(msgque.msq_id, IPC_RMID, 0)) {
 		printf("Failed to destroy queue: %d\n", -errno);
-		return ksft_exit_fail();
+		goto err_out;
 	}
 err_out:
 	return ksft_exit_fail();
-- 
2.6.1
