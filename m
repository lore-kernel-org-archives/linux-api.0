From: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: [PATCH v2 6/7] selftests/ptrace: change test to use ksft framework
Date: Tue, 23 Sep 2014 15:32:59 -0600
Message-ID: <9c141f93f09224d71feb02e907d87337e0db219b.1411506121.git.shuahkh@osg.samsung.com>
References: <cover.1411506121.git.shuahkh@osg.samsung.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1411506121.git.shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
In-Reply-To: <cover.1411506121.git.shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
References: <cover.1411506121.git.shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org, dbueso-l3A5Bk7waGM@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org, thierry-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org
Cc: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Change ptrace test to use kselftest framework to report
test results.

Signed-off-by: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
---
 tools/testing/selftests/ptrace/peeksiginfo.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/ptrace/peeksiginfo.c b/tools/testing/selftests/ptrace/peeksiginfo.c
index c34cd8a..d940bfc 100644
--- a/tools/testing/selftests/ptrace/peeksiginfo.c
+++ b/tools/testing/selftests/ptrace/peeksiginfo.c
@@ -10,6 +10,7 @@
 #include <sys/mman.h>
 
 #include "linux/ptrace.h"
+#include "../kselftest.h"
 
 static int sys_rt_sigqueueinfo(pid_t tgid, int sig, siginfo_t *uinfo)
 {
@@ -151,7 +152,7 @@ out:
 int main(int argc, char *argv[])
 {
 	siginfo_t siginfo[SIGNR];
-	int i, exit_code = 1;
+	int i;
 	sigset_t blockmask;
 	pid_t child;
 
@@ -162,7 +163,7 @@ int main(int argc, char *argv[])
 	child = fork();
 	if (child == -1) {
 		err("fork() failed: %m");
-		return 1;
+		return ksft_exit_fail();
 	} else if (child == 0) {
 		pid_t ppid = getppid();
 		while (1) {
@@ -170,7 +171,7 @@ int main(int argc, char *argv[])
 				break;
 			sleep(1);
 		}
-		return 1;
+		return ksft_exit_fail();
 	}
 
 	/* Send signals in process-wide and per-thread queues */
@@ -185,7 +186,7 @@ int main(int argc, char *argv[])
 	}
 
 	if (sys_ptrace(PTRACE_ATTACH, child, NULL, NULL) == -1)
-		return 1;
+		return ksft_exit_fail();
 
 	waitpid(child, NULL, 0);
 
@@ -207,12 +208,11 @@ int main(int argc, char *argv[])
 		goto out;
 
 	printf("PASS\n");
-	exit_code = 0;
 out:
 	if (sys_ptrace(PTRACE_KILL, child, NULL, NULL) == -1)
-		return 1;
+		return ksft_exit_fail();
 
 	waitpid(child, NULL, 0);
 
-	return exit_code;
+	return ksft_exit_pass();
 }
-- 
1.9.1
