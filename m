From: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Subject: Re: [PATCH 2/2] selftests/timers: change to use shared logic to run
 and install tests
Date: Mon, 16 Mar 2015 13:46:42 +1100
Message-ID: <1426474002.20210.1.camel@ellerman.id.au>
References: <cover.1426286799.git.shuahkh@osg.samsung.com>
	<cover.1426286799.git.shuahkh@osg.samsung.com>
	 <e34c7abc6dff5922a45376b7a3085545db66eb6d.1426286799.git.shuahkh@osg.samsung.com>
	 <4E4E8162-A30D-4460-BF55-12C269760577@ellerman.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4E4E8162-A30D-4460-BF55-12C269760577-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Cc: john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Sun, 2015-03-15 at 19:42 +1100, Michael Ellerman wrote:
> 
> On 14 March 2015 09:57:51 GMT+11:00, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org> wrote:
> >Change the timers Makefile to make use of shared run and install
> >logic in lib.mk. Destructive tests are installed. Regular tests
> >are emited to run_kselftest script to match the run_tests behavior.
> >
> >Signed-off-by: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
> >---
> > tools/testing/selftests/timers/Makefile | 20 +++++++++++---------
> > 1 file changed, 11 insertions(+), 9 deletions(-)
> >
> >diff --git a/tools/testing/selftests/timers/Makefile
> >b/tools/testing/selftests/timers/Makefile
> >index 9da3498..61e7284 100644
> >--- a/tools/testing/selftests/timers/Makefile
> >+++ b/tools/testing/selftests/timers/Makefile
> >@@ -7,19 +7,21 @@ bins = posix_timers nanosleep inconsistency-check
> >nsleep-lat raw_skew \
> > 	alarmtimer-suspend change_skew skew_consistency clocksource-switch \
> > 	leap-a-day leapcrash set-tai set-2038
> > 
> >+TEST_PROGS = posix_timers nanosleep nsleep-lat set-timer-lat
> >mqueue-lat \
> >+		inconsistency-check raw_skew
> >+TEST_FILES = threadtest alarmtimer-suspend valid-adjtimex change_skew
> >\
> >+		skew_consistency clocksource-switch leap-a-day leapcrash \
> >+		set-tai set-2038
> >+
> >+RUN_TESTS_WITH_ARGS := ./threadtest -t 30 -n 8 || echo "selftests:
> >threadtest [FAIL]"
> 
> You shouldn't need this separate variable. As long as you override RUN_TESTS after you include lib.mk you can include the default value, eg:
> 
> override RUN_TESTS := $(RUN_TESTS) ./threadtest -t 30 -n 8 || echo "selftests: threadtest [FAIL]"
> 
> I'll test that in the morning and send a proper patch.

How's this look?

Contents of install/timers (same as with your patch):

$ ls install/timers/
alarmtimer-suspend*  clocksource-switch*   leap-a-day*  mqueue-lat*  nsleep-lat*    raw_skew*  set-tai*        skew_consistency*  valid-adjtimex*
change_skew*         inconsistency-check*  leapcrash*   nanosleep*   posix_timers*  set-2038*  set-timer-lat*  threadtest*

And in run_kselftest.sh:

echo ; echo Running tests in timers
echo ========================================
cd timers
(./posix_timers && echo "selftests: posix_timers [PASS]") || echo "selftests: posix_timers [FAIL]"
(./nanosleep && echo "selftests: nanosleep [PASS]") || echo "selftests: nanosleep [FAIL]"
(./nsleep-lat && echo "selftests: nsleep-lat [PASS]") || echo "selftests: nsleep-lat [FAIL]"
(./set-timer-lat && echo "selftests: set-timer-lat [PASS]") || echo "selftests: set-timer-lat [FAIL]"
(./mqueue-lat && echo "selftests: mqueue-lat [PASS]") || echo "selftests: mqueue-lat [FAIL]"
(./inconsistency-check && echo "selftests: inconsistency-check [PASS]") || echo "selftests: inconsistency-check [FAIL]"
(./raw_skew && echo "selftests: raw_skew [PASS]") || echo "selftests: raw_skew [FAIL]"
./threadtest -t 30 -n 8 || echo selftests: threadtest [FAIL]
cd $ROOT


cheers



>From 5ea5ea0e5adee5317978965acc4594dce648da63 Mon Sep 17 00:00:00 2001
From: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Date: Mon, 16 Mar 2015 13:38:06 +1100
Subject: [PATCH] selftests/timers: Use shared logic to run and install tests

Change the timers Makefile to make use of shared run and install logic
in lib.mk. Destructive tests are installed. Regular tests are emited to
run_kselftest script to match the run_tests behavior.

Signed-off-by: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
---
 tools/testing/selftests/timers/Makefile | 33 +++++++++++++++++----------------
 1 file changed, 17 insertions(+), 16 deletions(-)

diff --git a/tools/testing/selftests/timers/Makefile b/tools/testing/selftests/timers/Makefile
index 9da3498987c8..8ba056ee8b48 100644
--- a/tools/testing/selftests/timers/Makefile
+++ b/tools/testing/selftests/timers/Makefile
@@ -1,25 +1,26 @@
-CC = $(CROSS_COMPILE)gcc
 BUILD_FLAGS = -DKTEST
 CFLAGS += -O3 -Wl,-no-as-needed -Wall $(BUILD_FLAGS)
 LDFLAGS += -lrt -lpthread
-bins = posix_timers nanosleep inconsistency-check nsleep-lat raw_skew \
-	set-timer-lat threadtest mqueue-lat valid-adjtimex \
-	alarmtimer-suspend change_skew skew_consistency clocksource-switch \
-	leap-a-day leapcrash set-tai set-2038
-
-all: ${bins}
 
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
+TEST_PROGS = posix_timers nanosleep nsleep-lat set-timer-lat mqueue-lat \
+		inconsistency-check raw_skew
+
+TEST_FILES = threadtest alarmtimer-suspend valid-adjtimex change_skew \
+		skew_consistency clocksource-switch leap-a-day leapcrash \
+		set-tai set-2038
+
+bins = $(TEST_PROGS) $(TEST_FILES)
+
+all: ${bins}
+
+include ../lib.mk
+
+THREADTEST := ./threadtest -t 30 -n 8 || echo "selftests: threadtest [FAIL]"
+
+override RUN_TESTS := $(RUN_TESTS) $(THREADTEST)
+override EMIT_TESTS := $(EMIT_TESTS) echo "$(THREADTEST)"
 
 # these tests require escalated privledges
 # and may modify the system time or trigger
-- 
2.1.0
