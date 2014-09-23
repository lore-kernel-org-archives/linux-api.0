From: Shuah Khan <shuahkh@osg.samsung.com>
Subject: [PATCH v2 2/7] selftests/breakpoints: change test to use ksft framework
Date: Tue, 23 Sep 2014 15:32:55 -0600
Message-ID: <2e7289eafa6872a101c76672c284efc544ea5c3b.1411506121.git.shuahkh@osg.samsung.com>
References: <cover.1411506121.git.shuahkh@osg.samsung.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1411506121.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1411506121.git.shuahkh@osg.samsung.com>
References: <cover.1411506121.git.shuahkh@osg.samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: akpm@linux-foundation.org, gregkh@linuxfoundation.org, colin.king@canonical.com, dbueso@suse.de, ebiederm@xmission.com, serge.hallyn@ubuntu.com, thierry@linux.vnet.ibm.com, luto@amacapital.net
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Change breakpoints test to use kselftest framework to report
test results.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 tools/testing/selftests/breakpoints/breakpoint_test.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/breakpoints/breakpoint_test.c b/tools/testing/selftests/breakpoints/breakpoint_test.c
index a0743f3..120895a 100644
--- a/tools/testing/selftests/breakpoints/breakpoint_test.c
+++ b/tools/testing/selftests/breakpoints/breakpoint_test.c
@@ -17,6 +17,8 @@
 #include <sys/types.h>
 #include <sys/wait.h>
 
+#include "../kselftest.h"
+
 
 /* Breakpoint access modes */
 enum {
@@ -42,7 +44,7 @@ static void set_breakpoint_addr(void *addr, int n)
 		     offsetof(struct user, u_debugreg[n]), addr);
 	if (ret) {
 		perror("Can't set breakpoint addr\n");
-		exit(-1);
+		ksft_exit_fail();
 	}
 }
 
@@ -105,7 +107,7 @@ static void toggle_breakpoint(int n, int type, int len,
 		     offsetof(struct user, u_debugreg[7]), dr7);
 	if (ret) {
 		perror("Can't set dr7");
-		exit(-1);
+		ksft_exit_fail();
 	}
 }
 
@@ -275,7 +277,7 @@ static void check_success(const char *msg)
 			msg2 = "Ok";
 		if (ptrace(PTRACE_POKEDATA, child_pid, &trapped, 1)) {
 			perror("Can't poke\n");
-			exit(-1);
+			ksft_exit_fail();
 		}
 	}
 
@@ -390,5 +392,5 @@ int main(int argc, char **argv)
 
 	wait(NULL);
 
-	return 0;
+	return ksft_exit_pass();
 }
-- 
1.9.1
