From: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: [PATCH v3 2/5] selftests/breakpoints: change test to use ksft framework
Date: Fri,  3 Oct 2014 09:36:17 -0600
Message-ID: <6e6772fee69e0c71feaf1a48b3f1ebcfc89be966.1412349412.git.shuahkh@osg.samsung.com>
References: <cover.1412349412.git.shuahkh@osg.samsung.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1412349412.git.shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
In-Reply-To: <cover.1412349412.git.shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
References: <cover.1412349412.git.shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org, dbueso-l3A5Bk7waGM@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org
Cc: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Change breakpoints test to use kselftest framework to report
test results.

Signed-off-by: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
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
