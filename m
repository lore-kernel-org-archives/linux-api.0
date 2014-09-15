From: Shuah Khan <shuahkh@osg.samsung.com>
Subject: [PATCH 7/7] selftests/timers: change timers test to use kselftest exit codes
Date: Mon, 15 Sep 2014 16:34:02 -0600
Message-ID: <1410820442-8774-8-git-send-email-shuahkh@osg.samsung.com>
References: <1410820442-8774-1-git-send-email-shuahkh@osg.samsung.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1410820442-8774-1-git-send-email-shuahkh@osg.samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: akpm@linux-foundation.org, gregkh@linuxfoundation.org, colin.king@canonical.com, dbueso@suse.de, ebiederm@xmission.com, serge.hallyn@ubuntu.com, thierry@linux.vnet.ibm.com, felipensp@gmail.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Change timers test to use kselftest exit codes in kselftest.h
to report test results.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 tools/testing/selftests/timers/posix_timers.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/timers/posix_timers.c b/tools/testing/selftests/timers/posix_timers.c
index 41bd855..7ae2c3b 100644
--- a/tools/testing/selftests/timers/posix_timers.c
+++ b/tools/testing/selftests/timers/posix_timers.c
@@ -15,6 +15,8 @@
 #include <time.h>
 #include <pthread.h>
 
+#include "../kselftest.h"
+
 #define DELAY 2
 #define USECS_PER_SEC 1000000
 
@@ -188,22 +190,23 @@ static int check_timer_create(int which)
 
 int main(int argc, char **argv)
 {
-	int err;
+	int err = EXIT_FAIL;
 
-	printf("Testing posix timers. False negative may happen on CPU execution \n");
+	printf("Testing posix timers.\n"
+		"False negative may happen on CPU execution\n");
 	printf("based timers if other threads run on the CPU...\n");
 
 	if (check_itimer(ITIMER_VIRTUAL) < 0)
-		return -1;
+		return err;
 
 	if (check_itimer(ITIMER_PROF) < 0)
-		return -1;
+		return err;
 
 	if (check_itimer(ITIMER_REAL) < 0)
-		return -1;
+		return err;
 
 	if (check_timer_create(CLOCK_THREAD_CPUTIME_ID) < 0)
-		return -1;
+		return err;
 
 	/*
 	 * It's unfortunately hard to reliably test a timer expiration
@@ -215,7 +218,7 @@ int main(int argc, char **argv)
 	 * find a better solution.
 	 */
 	if (check_timer_create(CLOCK_PROCESS_CPUTIME_ID) < 0)
-		return -1;
+		return err;
 
-	return 0;
+	return EXIT_PASS;
 }
-- 
1.9.1
