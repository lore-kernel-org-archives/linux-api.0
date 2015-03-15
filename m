From: Michael Ellerman <michael-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Subject: Re: [PATCH 2/2] selftests/timers: change to use shared logic to run and install tests
Date: Sun, 15 Mar 2015 19:42:37 +1100
Message-ID: <4E4E8162-A30D-4460-BF55-12C269760577@ellerman.id.au>
References: <cover.1426286799.git.shuahkh@osg.samsung.com><cover.1426286799.git.shuahkh@osg.samsung.com> <e34c7abc6dff5922a45376b7a3085545db66eb6d.1426286799.git.shuahkh@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <e34c7abc6dff5922a45376b7a3085545db66eb6d.1426286799.git.shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org



On 14 March 2015 09:57:51 GMT+11:00, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org> wrote:
>Change the timers Makefile to make use of shared run and install
>logic in lib.mk. Destructive tests are installed. Regular tests
>are emited to run_kselftest script to match the run_tests behavior.
>
>Signed-off-by: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
>---
> tools/testing/selftests/timers/Makefile | 20 +++++++++++---------
> 1 file changed, 11 insertions(+), 9 deletions(-)
>
>diff --git a/tools/testing/selftests/timers/Makefile
>b/tools/testing/selftests/timers/Makefile
>index 9da3498..61e7284 100644
>--- a/tools/testing/selftests/timers/Makefile
>+++ b/tools/testing/selftests/timers/Makefile
>@@ -7,19 +7,21 @@ bins = posix_timers nanosleep inconsistency-check
>nsleep-lat raw_skew \
> 	alarmtimer-suspend change_skew skew_consistency clocksource-switch \
> 	leap-a-day leapcrash set-tai set-2038
> 
>+TEST_PROGS = posix_timers nanosleep nsleep-lat set-timer-lat
>mqueue-lat \
>+		inconsistency-check raw_skew
>+TEST_FILES = threadtest alarmtimer-suspend valid-adjtimex change_skew
>\
>+		skew_consistency clocksource-switch leap-a-day leapcrash \
>+		set-tai set-2038
>+
>+RUN_TESTS_WITH_ARGS := ./threadtest -t 30 -n 8 || echo "selftests:
>threadtest [FAIL]"

You shouldn't need this separate variable. As long as you override RUN_TESTS after you include lib.mk you can include the default value, eg:

override RUN_TESTS := $(RUN_TESTS) ./threadtest -t 30 -n 8 || echo "selftests: threadtest [FAIL]"

I'll test that in the morning and send a proper patch.

cheers
-- 
Sent from my Android phone with K-9 Mail. Please excuse my brevity.
