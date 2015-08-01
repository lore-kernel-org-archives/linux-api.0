From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: Re: Re: [PATCH] kselftests/ftrace : Add event trigger testcases
Date: Sun, 02 Aug 2015 07:40:05 +0900
Message-ID: <55BD4AC5.8040905@hitachi.com>
References: <20150725011310.4601.76087.stgit@localhost.localdomain> <20150727093411.GE22022@danjae.kornet>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150727093411.GE22022@danjae.kornet>
Sender: linux-kernel-owner@vger.kernel.org
To: Namhyung Kim <namhyung@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Tom Zanussi <tom.zanussi@linux.intel.com>, linux-api@vger.kernel.org, Shuah Khan <shuahkh@osg.samsung.com>, linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>
List-Id: linux-api@vger.kernel.org

On 2015/07/27 18:34, Namhyung Kim wrote:
> Hi Masami,
> 
> On Sat, Jul 25, 2015 at 10:13:10AM +0900, Masami Hiramatsu wrote:
>> This adds simple event trigger testcases for ftracetest,
>> which covers following triggers.
>>  - traceon-traceoff trigger
>>  - enable/disable_event trigger
>>  - snapshot trigger
>>  - stacktrace trigger
>>  - trigger filters
>>
>> Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
>> Cc: Steven Rostedt <rostedt@goodmis.org>
>> Cc: Ingo Molnar <mingo@redhat.com>
>> Cc: Shuah Khan <shuahkh@osg.samsung.com>
>> Cc: Namhyung Kim <namhyung@kernel.org>
>> Cc: Tom Zanussi <tom.zanussi@linux.intel.com>
>> ---
>>  tools/testing/selftests/ftrace/test.d/functions    |    9 +++
>>  .../ftrace/test.d/trigger/trigger-eventonoff.tc    |   64 ++++++++++++++++++++
>>  .../ftrace/test.d/trigger/trigger-filter.tc        |   59 ++++++++++++++++++
>>  .../ftrace/test.d/trigger/trigger-snapshot.tc      |   56 ++++++++++++++++++
>>  .../ftrace/test.d/trigger/trigger-stacktrace.tc    |   53 +++++++++++++++++
>>  .../ftrace/test.d/trigger/trigger-traceonoff.tc    |   58 ++++++++++++++++++
>>  6 files changed, 299 insertions(+)
>>  create mode 100644 tools/testing/selftests/ftrace/test.d/trigger/trigger-eventonoff.tc
>>  create mode 100644 tools/testing/selftests/ftrace/test.d/trigger/trigger-filter.tc
>>  create mode 100644 tools/testing/selftests/ftrace/test.d/trigger/trigger-snapshot.tc
>>  create mode 100644 tools/testing/selftests/ftrace/test.d/trigger/trigger-stacktrace.tc
>>  create mode 100644 tools/testing/selftests/ftrace/test.d/trigger/trigger-traceonoff.tc
>>
>> diff --git a/tools/testing/selftests/ftrace/test.d/functions b/tools/testing/selftests/ftrace/test.d/functions
>> index 5d8cd06..36ca18e 100644
>> --- a/tools/testing/selftests/ftrace/test.d/functions
>> +++ b/tools/testing/selftests/ftrace/test.d/functions
>> @@ -14,3 +14,12 @@ enable_tracing() { # start trace recording
>>  reset_tracer() { # reset the current tracer
>>      echo nop > current_tracer
>>  }
>> +
>> +reset_trigger() { # reset all current setting triggers
>> +    grep -v ^# events/*/*/trigger |
>> +    while read line; do
>> +        cmd=`echo $line | cut -f2- -d:`
>> +	echo "!$cmd" > `echo $line | cut -f1 -d:`
> 
> Broken whitespaces?

Right, I'll fix that.

>> +    done
>> +}
>> +
>> diff --git a/tools/testing/selftests/ftrace/test.d/trigger/trigger-eventonoff.tc b/tools/testing/selftests/ftrace/test.d/trigger/trigger-eventonoff.tc
>> new file mode 100644
>> index 0000000..1a94450
>> --- /dev/null
>> +++ b/tools/testing/selftests/ftrace/test.d/trigger/trigger-eventonoff.tc
>> @@ -0,0 +1,64 @@
>> +#!/bin/sh
>> +# description: event trigger - test event enable/disable trigger
>> +
>> +do_reset() {
>> +    reset_trigger
>> +    echo > set_event
>> +    clear_trace
>> +}
>> +
>> +fail() { #msg
>> +    do_reset
>> +    echo $1
>> +    exit $FAIL
>> +}
>> +
>> +if [ ! -f set_event -o ! -d events/sched ]; then
>> +    echo "event tracing is not supported"
>> +    exit_unsupported
>> +fi
>> +
>> +if [ ! -f events/sched/sched_process_fork/trigger ]; then
>> +    echo "event trigger is not supported"
>> +    exit_unsupported
>> +fi
>> +
>> +reset_tracer
>> +do_reset
>> +
>> +FEATURE=`grep enable_event events/sched/sched_process_fork/trigger`
>> +if [ -z "$FEATURE" ]; then
>> +    echo "event enable/disable trigger is not supported"
>> +    exit_unsupported
>> +fi
>> +
>> +echo "Test enable_event trigger"
>> +echo 0 > events/sched/sched_switch/enable
>> +echo 'enable_event:sched:sched_switch' > events/sched/sched_process_fork/trigger
>> +( echo "forked")
>> +if [ `cat events/sched/sched_switch/enable` != '1*' ]; then
>> +    fail "enable_event trigger on sched_process_fork did not work"
>> +fi
>> +
>> +reset_trigger
>> +
>> +echo "Test disable_event trigger"
>> +echo 1 > events/sched/sched_switch/enable
>> +echo 'disable_event:sched:sched_switch' > events/sched/sched_process_fork/trigger
>> +( echo "forked")
>> +if [ `cat events/sched/sched_switch/enable` != '0*' ]; then
>> +    fail "disable_event trigger on sched_process_fork did not work"
>> +fi
>> +
>> +reset_trigger
>> +
>> +echo "Test semantic error for event enable/disable trigger"
>> +! echo 'enable_event:nogroup:noevent' > events/sched/sched_process_fork/trigger
>> +! echo 'disable_event+1' > events/sched/sched_process_fork/trigger
>> +echo 'enable_event:sched:sched_switch' > events/sched/sched_process_fork/trigger
>> +! echo 'enable_event:sched:sched_switch' > events/sched/sched_process_fork/trigger
>> +! echo 'disable_event:sched:sched_switch' > events/sched/sched_process_fork/trigger
> 
> I don't know whether the '!' sign works for all shells.  Btw, what is
> the last two lines for?

"!" means that the line must fail. And the last 2 lines means that the enable/disable
event trigger on same target event cannot be registered at once.


>> +
>> +do_reset
>> +
>> +exit 0
>> diff --git a/tools/testing/selftests/ftrace/test.d/trigger/trigger-filter.tc b/tools/testing/selftests/ftrace/test.d/trigger/trigger-filter.tc
>> new file mode 100644
>> index 0000000..514e466
>> --- /dev/null
>> +++ b/tools/testing/selftests/ftrace/test.d/trigger/trigger-filter.tc
>> @@ -0,0 +1,59 @@
>> +#!/bin/sh
>> +# description: event trigger - test trigger filter
>> +
>> +do_reset() {
>> +    reset_trigger
>> +    echo > set_event
>> +    clear_trace
>> +}
>> +
>> +fail() { #msg
>> +    do_reset
>> +    echo $1
>> +    exit $FAIL
>> +}
>> +
>> +if [ ! -f set_event -o ! -d events/sched ]; then
>> +    echo "event tracing is not supported"
>> +    exit_unsupported
>> +fi
>> +
>> +if [ ! -f events/sched/sched_process_fork/trigger ]; then
>> +    echo "event trigger is not supported"
>> +    exit_unsupported
>> +fi
>> +
>> +reset_tracer
>> +do_reset
>> +
>> +echo "Test trigger filter"
>> +echo 1 > tracing_on
>> +echo 'traceoff if child_pid == 0' > events/sched/sched_process_fork/trigger
> 
> What about checking child_comm too to verify complex filter pattern
> with string type?  Maybe something like below (not tested..)?
> 
> echo 'traceoff if child_pid != 0 && child_comm ~ '*sh' > events/.../trigger

OK, I'll add more complex patterns.

Thanks!

> 
> Thanks,
> Namhyung
> 
> 
>> +( echo "forked")
>> +if [ `cat tracing_on` -ne 1 ]; then
>> +    fail "traceoff trigger on sched_process_fork did not work"
>> +fi
>> +
>> +reset_trigger
>> +
>> +echo "Test semantic error for trigger filter"
>> +! echo 'traceoff if a' > events/sched/sched_process_fork/trigger
>> +! echo 'traceoff if common_pid=0' > events/sched/sched_process_fork/trigger
>> +! echo 'traceoff if common_pid==b' > events/sched/sched_process_fork/trigger
>> +echo 'traceoff if common_pid == 0' > events/sched/sched_process_fork/trigger
>> +echo '!traceoff' > events/sched/sched_process_fork/trigger
>> +! echo 'traceoff if common_pid == child_pid' > events/sched/sched_process_fork/trigger
>> +echo 'traceoff if common_pid <= 0' > events/sched/sched_process_fork/trigger
>> +echo '!traceoff' > events/sched/sched_process_fork/trigger
>> +echo 'traceoff if common_pid >= 0' > events/sched/sched_process_fork/trigger
>> +echo '!traceoff' > events/sched/sched_process_fork/trigger
>> +echo 'traceoff if parent_pid >= 0 && child_pid >= 0' > events/sched/sched_process_fork/trigger
>> +echo '!traceoff' > events/sched/sched_process_fork/trigger
>> +echo 'traceoff if parent_pid >= 0 || child_pid >= 0' > events/sched/sched_process_fork/trigger
>> +echo '!traceoff' > events/sched/sched_process_fork/trigger
>> +
>> +
>> +
>> +do_reset
>> +
>> +exit 0
>> diff --git a/tools/testing/selftests/ftrace/test.d/trigger/trigger-snapshot.tc b/tools/testing/selftests/ftrace/test.d/trigger/trigger-snapshot.tc
>> new file mode 100644
>> index 0000000..f84b80d
>> --- /dev/null
>> +++ b/tools/testing/selftests/ftrace/test.d/trigger/trigger-snapshot.tc
>> @@ -0,0 +1,56 @@
>> +#!/bin/sh
>> +# description: event trigger - test snapshot-trigger
>> +
>> +do_reset() {
>> +    reset_trigger
>> +    echo > set_event
>> +    clear_trace
>> +}
>> +
>> +fail() { #msg
>> +    do_reset
>> +    echo $1
>> +    exit $FAIL
>> +}
>> +
>> +if [ ! -f set_event -o ! -d events/sched ]; then
>> +    echo "event tracing is not supported"
>> +    exit_unsupported
>> +fi
>> +
>> +if [ ! -f events/sched/sched_process_fork/trigger ]; then
>> +    echo "event trigger is not supported"
>> +    exit_unsupported
>> +fi
>> +
>> +reset_tracer
>> +do_reset
>> +
>> +FEATURE=`grep snapshot events/sched/sched_process_fork/trigger`
>> +if [ -z "$FEATURE" ]; then
>> +    echo "snapshot trigger is not supported"
>> +    exit_unsupported
>> +fi
>> +
>> +echo "Test snapshot tigger"
>> +echo 0 > snapshot
>> +echo 1 > events/sched/sched_process_fork/enable
>> +( echo "forked")
>> +echo 'snapshot:1' > events/sched/sched_process_fork/trigger
>> +( echo "forked")
>> +grep sched_process_fork snapshot > /dev/null || \
>> +    fail "snapshot trigger on sched_process_fork did not work"
>> +
>> +reset_trigger
>> +echo 0 > snapshot
>> +echo 0 > events/sched/sched_process_fork/enable
>> +
>> +echo "Test snapshot semantic errors"
>> +
>> +! echo "snapshot+1" > events/sched/sched_process_fork/trigger
>> +echo "snapshot" > events/sched/sched_process_fork/trigger
>> +! echo "snapshot" > events/sched/sched_process_fork/trigger
>> +
>> +do_reset
>> +
>> +exit 0
>> diff --git a/tools/testing/selftests/ftrace/test.d/trigger/trigger-stacktrace.tc b/tools/testing/selftests/ftrace/test.d/trigger/trigger-stacktrace.tc
>> new file mode 100644
>> index 0000000..9fa23b0
>> --- /dev/null
>> +++ b/tools/testing/selftests/ftrace/test.d/trigger/trigger-stacktrace.tc
>> @@ -0,0 +1,53 @@
>> +#!/bin/sh
>> +# description: event trigger - test stacktrace-trigger
>> +
>> +do_reset() {
>> +    reset_trigger
>> +    echo > set_event
>> +    clear_trace
>> +}
>> +
>> +fail() { #msg
>> +    do_reset
>> +    echo $1
>> +    exit $FAIL
>> +}
>> +
>> +if [ ! -f set_event -o ! -d events/sched ]; then
>> +    echo "event tracing is not supported"
>> +    exit_unsupported
>> +fi
>> +
>> +if [ ! -f events/sched/sched_process_fork/trigger ]; then
>> +    echo "event trigger is not supported"
>> +    exit_unsupported
>> +fi
>> +
>> +reset_tracer
>> +do_reset
>> +
>> +FEATURE=`grep stacktrace events/sched/sched_process_fork/trigger`
>> +if [ -z "$FEATURE" ]; then
>> +    echo "stacktrace trigger is not supported"
>> +    exit_unsupported
>> +fi
>> +
>> +echo "Test stacktrace tigger"
>> +echo 0 > trace
>> +echo 0 > options/stacktrace
>> +echo 'stacktrace' > events/sched/sched_process_fork/trigger
>> +( echo "forked")
>> +grep "<stack trace>" trace > /dev/null || \
>> +    fail "stacktrace trigger on sched_process_fork did not work"
>> +
>> +reset_trigger
>> +
>> +echo "Test stacktrace semantic errors"
>> +
>> +! echo "stacktrace:foo" > events/sched/sched_process_fork/trigger
>> +echo "stacktrace" > events/sched/sched_process_fork/trigger
>> +! echo "stacktrace" > events/sched/sched_process_fork/trigger
>> +
>> +do_reset
>> +
>> +exit 0
>> diff --git a/tools/testing/selftests/ftrace/test.d/trigger/trigger-traceonoff.tc b/tools/testing/selftests/ftrace/test.d/trigger/trigger-traceonoff.tc
>> new file mode 100644
>> index 0000000..87648e5
>> --- /dev/null
>> +++ b/tools/testing/selftests/ftrace/test.d/trigger/trigger-traceonoff.tc
>> @@ -0,0 +1,58 @@
>> +#!/bin/sh
>> +# description: event trigger - test traceon/off trigger
>> +
>> +do_reset() {
>> +    reset_trigger
>> +    echo > set_event
>> +    clear_trace
>> +}
>> +
>> +fail() { #msg
>> +    do_reset
>> +    echo $1
>> +    exit $FAIL
>> +}
>> +
>> +if [ ! -f set_event -o ! -d events/sched ]; then
>> +    echo "event tracing is not supported"
>> +    exit_unsupported
>> +fi
>> +
>> +if [ ! -f events/sched/sched_process_fork/trigger ]; then
>> +    echo "event trigger is not supported"
>> +    exit_unsupported
>> +fi
>> +
>> +reset_tracer
>> +do_reset
>> +
>> +echo "Test traceoff trigger"
>> +echo 1 > tracing_on
>> +echo 'traceoff' > events/sched/sched_process_fork/trigger
>> +( echo "forked")
>> +if [ `cat tracing_on` -ne 0 ]; then
>> +    fail "traceoff trigger on sched_process_fork did not work"
>> +fi
>> +
>> +reset_trigger
>> +
>> +echo "Test traceon trigger"
>> +echo 0 > tracing_on
>> +echo 'traceon' > events/sched/sched_process_fork/trigger
>> +( echo "forked")
>> +if [ `cat tracing_on` -ne 1 ]; then
>> +    fail "traceoff trigger on sched_process_fork did not work"
>> +fi
>> +
>> +reset_trigger
>> +
>> +echo "Test semantic error for traceoff/on trigger"
>> +! echo 'traceoff:badparam' > events/sched/sched_process_fork/trigger
>> +! echo 'traceoff+0' > events/sched/sched_process_fork/trigger
>> +echo 'traceon' > events/sched/sched_process_fork/trigger
>> +! echo 'traceon' > events/sched/sched_process_fork/trigger
>> +! echo 'traceoff' > events/sched/sched_process_fork/trigger
>> +
>> +do_reset
>> +
>> +exit 0
>>


-- 
Masami HIRAMATSU
Linux Technology Research Center, System Productivity Research Dept.
Center for Technology Innovation - Systems Engineering
Hitachi, Ltd., Research & Development Group
E-mail: masami.hiramatsu.pt@hitachi.com
