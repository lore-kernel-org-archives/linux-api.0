From: Shuah Khan <shuahkh@osg.samsung.com>
Subject: Re: [PATCH 2/2] selftests/timers: change to use shared logic to run
 and install tests
Date: Wed, 18 Mar 2015 09:43:08 -0600
Message-ID: <55099D0C.40003@osg.samsung.com>
References: <cover.1426286799.git.shuahkh@osg.samsung.com> <e34c7abc6dff5922a45376b7a3085545db66eb6d.1426286799.git.shuahkh@osg.samsung.com> <CALAqxLXApErmHgCzgoo9xkBCZaP59yu=f9WEmmYwTH29ZrDadQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALAqxLXApErmHgCzgoo9xkBCZaP59yu=f9WEmmYwTH29ZrDadQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: John Stultz <john.stultz@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, mpe@ellerman.id.au, Linux API <linux-api@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Shuah Khan <shuahkh@osg.samsung.com>
List-Id: linux-api@vger.kernel.org

On 03/13/2015 09:14 PM, John Stultz wrote:
> On Fri, Mar 13, 2015 at 3:57 PM, Shuah Khan <shuahkh@osg.samsung.com> wrote:
>> Change the timers Makefile to make use of shared run and install
>> logic in lib.mk. Destructive tests are installed. Regular tests
>> are emited to run_kselftest script to match the run_tests behavior.
>>
>> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
>> ---
>>  tools/testing/selftests/timers/Makefile | 20 +++++++++++---------
>>  1 file changed, 11 insertions(+), 9 deletions(-)
>>
>> diff --git a/tools/testing/selftests/timers/Makefile b/tools/testing/selftests/timers/Makefile
>> index 9da3498..61e7284 100644
>> --- a/tools/testing/selftests/timers/Makefile
>> +++ b/tools/testing/selftests/timers/Makefile
>> @@ -7,19 +7,21 @@ bins = posix_timers nanosleep inconsistency-check nsleep-lat raw_skew \
>>         alarmtimer-suspend change_skew skew_consistency clocksource-switch \
>>         leap-a-day leapcrash set-tai set-2038
>>
>> +TEST_PROGS = posix_timers nanosleep nsleep-lat set-timer-lat mqueue-lat \
>> +               inconsistency-check raw_skew
>> +TEST_FILES = threadtest alarmtimer-suspend valid-adjtimex change_skew \
>> +               skew_consistency clocksource-switch leap-a-day leapcrash \
>> +               set-tai set-2038
>> +
>> +RUN_TESTS_WITH_ARGS := ./threadtest -t 30 -n 8 || echo "selftests: threadtest [FAIL]"
>> +
>> +EMIT_TESTS_WITH_ARGS := echo "$(RUN_TESTS_WITH_ARGS)"
>> +
> 
> So my make-foo isn't very strong, but no objections from me.
> 
> My only thoughts:
> 1) Would it be better if threadtest can be made to have better
> defaults for kselftest so you don't need that extra logic?

Yes. If you can change the threadset to run with -t 30 -n 8
in default case, that would make the logic simpler. Can you
send me a patch to do this?


> 2) While I get that TEST_FILES is likely going to be used to copy the
> destructive tests over, It feels a little like its being bundled in
> with something like data files that tests might need, which seems sort
> of hackish. Would TEST_PROGS_EXTENDED or something be more clear and
> make more sense?

I agree with you on this. TEST_FILES usage is an overload.

-- Shuah


-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
