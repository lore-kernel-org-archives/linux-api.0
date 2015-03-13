From: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: [PATCH 2/2] selftests/timers: change to use shared logic to run and install tests
Date: Fri, 13 Mar 2015 16:57:51 -0600
Message-ID: <e34c7abc6dff5922a45376b7a3085545db66eb6d.1426286799.git.shuahkh@osg.samsung.com>
References: <cover.1426286799.git.shuahkh@osg.samsung.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1426286799.git.shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
In-Reply-To: <cover.1426286799.git.shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
References: <cover.1426286799.git.shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org
Cc: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Change the timers Makefile to make use of shared run and install
logic in lib.mk. Destructive tests are installed. Regular tests
are emited to run_kselftest script to match the run_tests behavior.

Signed-off-by: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
---
 tools/testing/selftests/timers/Makefile | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/timers/Makefile b/tools/testing/selftests/timers/Makefile
index 9da3498..61e7284 100644
--- a/tools/testing/selftests/timers/Makefile
+++ b/tools/testing/selftests/timers/Makefile
@@ -7,19 +7,21 @@ bins = posix_timers nanosleep inconsistency-check nsleep-lat raw_skew \
 	alarmtimer-suspend change_skew skew_consistency clocksource-switch \
 	leap-a-day leapcrash set-tai set-2038
 
+TEST_PROGS = posix_timers nanosleep nsleep-lat set-timer-lat mqueue-lat \
+		inconsistency-check raw_skew
+TEST_FILES = threadtest alarmtimer-suspend valid-adjtimex change_skew \
+		skew_consistency clocksource-switch leap-a-day leapcrash \
+		set-tai set-2038
+
+RUN_TESTS_WITH_ARGS := ./threadtest -t 30 -n 8 || echo "selftests: threadtest [FAIL]"
+
+EMIT_TESTS_WITH_ARGS := echo "$(RUN_TESTS_WITH_ARGS)"
+
 all: ${bins}
 
 # these are all "safe" tests that don't modify
 # system time or require escalated privledges
-run_tests: all
-	./posix_timers
-	./nanosleep
-	./nsleep-lat
-	./set-timer-lat
-	./mqueue-lat
-	./inconsistency-check
-	./raw_skew
-	./threadtest -t 30 -n 8
+include ../lib.mk
 
 # these tests require escalated privledges
 # and may modify the system time or trigger
-- 
2.1.0
