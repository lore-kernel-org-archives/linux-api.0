From: Shuah Khan <shuahkh@osg.samsung.com>
Subject: [PATCH 6/7] selftests/ptrace: change ptrace test to use kselftest exit codes
Date: Mon, 15 Sep 2014 16:34:01 -0600
Message-ID: <1410820442-8774-7-git-send-email-shuahkh@osg.samsung.com>
References: <1410820442-8774-1-git-send-email-shuahkh@osg.samsung.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1410820442-8774-1-git-send-email-shuahkh@osg.samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: akpm@linux-foundation.org, gregkh@linuxfoundation.org, colin.king@canonical.com, dbueso@suse.de, ebiederm@xmission.com, serge.hallyn@ubuntu.com, thierry@linux.vnet.ibm.com, felipensp@gmail.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Change ptrace test to use kselftest exit codes in kselftest.h
to report test results.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 tools/testing/selftests/ptrace/peeksiginfo.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/ptrace/peeksiginfo.c b/tools/testing/selftests/ptrace/peeksiginfo.c
index c34cd8a..4d18964 100644
--- a/tools/testing/selftests/ptrace/peeksiginfo.c
+++ b/tools/testing/selftests/ptrace/peeksiginfo.c
@@ -10,6 +10,7 @@
 #include <sys/mman.h>
 
 #include "linux/ptrace.h"
+#include "../kselftest.h"
 
 static int sys_rt_sigqueueinfo(pid_t tgid, int sig, siginfo_t *uinfo)
 {
@@ -43,7 +44,7 @@ static int sys_ptrace(int request, pid_t pid, void *addr, void *data)
 static int check_error_paths(pid_t child)
 {
 	struct ptrace_peeksiginfo_args arg;
-	int ret, exit_code = -1;
+	int ret, exit_code = EXIT_FAIL;
 	void *addr_rw, *addr_ro;
 
 	/*
@@ -95,7 +96,7 @@ static int check_error_paths(pid_t child)
 		goto out;
 	}
 
-	exit_code = 0;
+	exit_code = EXIT_PASS;
 out:
 	munmap(addr_rw, 2 * PAGE_SIZE);
 	return exit_code;
@@ -104,7 +105,7 @@ out:
 int check_direct_path(pid_t child, int shared, int nr)
 {
 	struct ptrace_peeksiginfo_args arg = {.flags = 0, .nr = nr, .off = 0};
-	int i, j, ret, exit_code = -1;
+	int i, j, ret, exit_code = EXIT_FAIL;
 	siginfo_t siginfo[SIGNR];
 	int si_code;
 
@@ -143,7 +144,7 @@ int check_direct_path(pid_t child, int shared, int nr)
 		goto out;
 	}
 
-	exit_code = 0;
+	exit_code = EXIT_PASS;
 out:
 	return exit_code;
 }
@@ -151,7 +152,7 @@ out:
 int main(int argc, char *argv[])
 {
 	siginfo_t siginfo[SIGNR];
-	int i, exit_code = 1;
+	int i, exit_code = EXIT_FAIL;
 	sigset_t blockmask;
 	pid_t child;
 
@@ -162,7 +163,7 @@ int main(int argc, char *argv[])
 	child = fork();
 	if (child == -1) {
 		err("fork() failed: %m");
-		return 1;
+		return exit_code;
 	} else if (child == 0) {
 		pid_t ppid = getppid();
 		while (1) {
@@ -170,7 +171,7 @@ int main(int argc, char *argv[])
 				break;
 			sleep(1);
 		}
-		return 1;
+		return exit_code;
 	}
 
 	/* Send signals in process-wide and per-thread queues */
@@ -185,7 +186,7 @@ int main(int argc, char *argv[])
 	}
 
 	if (sys_ptrace(PTRACE_ATTACH, child, NULL, NULL) == -1)
-		return 1;
+		return exit_code;
 
 	waitpid(child, NULL, 0);
 
@@ -207,10 +208,10 @@ int main(int argc, char *argv[])
 		goto out;
 
 	printf("PASS\n");
-	exit_code = 0;
+	exit_code = EXIT_PASS;
 out:
 	if (sys_ptrace(PTRACE_KILL, child, NULL, NULL) == -1)
-		return 1;
+		return exit_code;
 
 	waitpid(child, NULL, 0);
 
-- 
1.9.1
