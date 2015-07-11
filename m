From: Masami Hiramatsu <masami.hiramatsu.pt-FCd8Q96Dh0JBDgjK7y7TUQ@public.gmane.org>
Subject: Re: Re: [PATCH tip/master ] ftracetest: Update kprobe-tracer testcases
 because of renaming do_fork
Date: Sat, 11 Jul 2015 10:13:28 +0900
Message-ID: <55A06DB8.10809@hitachi.com>
References: <20150709101012.21228.45338.stgit@localhost.localdomain> <20150709080311.37ae53c3@grimm.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150709080311.37ae53c3-2kNGR76GQU9OHLTnHDQRgA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>
Cc: Vince Weaver <vincent.weaver-e7X0jjDqjFGHXe+LvDLADg@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Heiko Carstens <heiko.carstens-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Namhyung Kim <namhyung-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 2015/07/09 21:03, Steven Rostedt wrote:
> On Thu, 09 Jul 2015 19:10:12 +0900
> Masami Hiramatsu <masami.hiramatsu.pt-FCd8Q96Dh0JBDgjK7y7TUQ@public.gmane.org> wrote:
> 
>>  echo 0 > events/enable
>>  echo > kprobe_events
>> -echo p:myevent do_fork > kprobe_events
>> +echo p:myevent _do_fork > kprobe_events
>>  grep myevent kprobe_events
>>  test -d events/kprobes/myevent
>>  echo > kprobe_events
>> diff --git a/tools/testing/selftests/ftrace/test.d/kprobe/busy_check.tc b/tools/testing/selftests/ftrace/test.d/kprobe/busy_check.tc
>> index d8c7bb6..74507db 100644
>> --- a/tools/testing/selftests/ftrace/test.d/kprobe/busy_check.tc
>> +++ b/tools/testing/selftests/ftrace/test.d/kprobe/busy_check.tc
>> @@ -5,7 +5,7 @@
>>  
>>  echo 0 > events/enable
>>  echo > kprobe_events
>> -echo p:myevent do_fork > kprobe_events
>> +echo p:myevent _do_fork > kprobe_events
>>  test -d events/kprobes/myevent
>>  echo 1 > events/kprobes/myevent/enable
>>  echo > kprobe_events && exit 1 # this must fail
>> diff --git a/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_args.tc b/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_args.tc
>> index c45ee27..64949d4 100644
>> --- a/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_args.tc
>> +++ b/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_args.tc
>> @@ -5,7 +5,7 @@
>>  
>>  echo 0 > events/enable
>>  echo > kprobe_events
>> -echo 'p:testprobe do_fork $stack $stack0 +0($stack)' > kprobe_events
>> +echo 'p:testprobe _do_fork $stack $stack0 +0($stack)' > kprobe_events
>>  grep testprobe kprobe_events
>>  test -d events/kprobes/testprobe
>>  echo 1 > events/kprobes/testprobe/enable
>> diff --git a/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_ftrace.tc b/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_ftrace.tc
>> index ab41d2b..d6f2f49 100644
>> --- a/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_ftrace.tc
>> +++ b/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_ftrace.tc
>> @@ -6,31 +6,31 @@ grep function available_tracers || exit_unsupported # this is configurable
>>  
>>  # prepare
>>  echo nop > current_tracer
>> -echo do_fork > set_ftrace_filter
>> +echo _do_fork > set_ftrace_filter
>>  echo 0 > events/enable
>>  echo > kprobe_events
>> -echo 'p:testprobe do_fork' > kprobe_events
>> +echo 'p:testprobe _do_fork' > kprobe_events
>>  
>>  # kprobe on / ftrace off
>>  echo 1 > events/kprobes/testprobe/enable
>>  echo > trace
>>  ( echo "forked")
>>  grep testprobe trace
>> -! grep 'do_fork <-' trace
>> +! grep '_do_fork <-' trace
>>  
>>  # kprobe on / ftrace on
>>  echo function > current_tracer
>>  echo > trace
>>  ( echo "forked")
>>  grep testprobe trace
>> -grep 'do_fork <-' trace
>> +grep '_do_fork <-' trace
>>  
>>  # kprobe off / ftrace on
>>  echo 0 > events/kprobes/testprobe/enable
>>  echo > trace
>>  ( echo "forked")
>>  ! grep testprobe trace
>> -grep 'do_fork <-' trace
>> +grep '_do_fork <-' trace
>>  
>>  # kprobe on / ftrace on
>>  echo 1 > events/kprobes/testprobe/enable
>> @@ -38,14 +38,14 @@ echo function > current_tracer
>>  echo > trace
>>  ( echo "forked")
>>  grep testprobe trace
>> -grep 'do_fork <-' trace
>> +grep '_do_fork <-' trace
>>  
>>  # kprobe on / ftrace off
>>  echo nop > current_tracer
>>  echo > trace
>>  ( echo "forked")
>>  grep testprobe trace
>> -! grep 'do_fork <-' trace
>> +! grep '_do_fork <-' trace
>>  
>>  # cleanup
>>  echo nop > current_tracer
>> diff --git a/tools/testing/selftests/ftrace/test.d/kprobe/kretprobe_args.tc b/tools/testing/selftests/ftrace/test.d/kprobe/kretprobe_args.tc
>> index 3171798..0d09546 100644
>> --- a/tools/testing/selftests/ftrace/test.d/kprobe/kretprobe_args.tc
>> +++ b/tools/testing/selftests/ftrace/test.d/kprobe/kretprobe_args.tc
>> @@ -5,7 +5,7 @@
>>  
>>  echo 0 > events/enable
>>  echo > kprobe_events
>> -echo 'r:testprobe2 do_fork $retval' > kprobe_events
>> +echo 'r:testprobe2 _do_fork $retval' > kprobe_events
>>  grep testprobe2 kprobe_events
>>  test -d events/kprobes/testprobe2
>>  echo 1 > events/kprobes/testprobe2/enable
> 
> 
> Instead of hard coding the name, what about adding a global variable
> for the function, in case we need to change it again, it would only
> need to be changed in one place?

OK, I'll introduce FORK_SYMBOL="_do_fork" :)

Thank you,

-- 
Masami HIRAMATSU
Linux Technology Research Center, System Productivity Research Dept.
Center for Technology Innovation - Systems Engineering
Hitachi, Ltd., Research & Development Group
E-mail: masami.hiramatsu.pt-FCd8Q96Dh0JBDgjK7y7TUQ@public.gmane.org
