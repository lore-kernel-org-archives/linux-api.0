From: Namhyung Kim <namhyung@kernel.org>
Subject: Re: [BUGFIX PATCH] kselftest/ftrace: Fix the testcases for kprobes
 on do_fork
Date: Mon, 26 Oct 2015 22:35:39 +0900
Message-ID: <20151026133539.GA20161@danjae.kornet>
References: <20151023075036.17335.96786.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20151023075036.17335.96786.stgit@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-api@vger.kernel.org, Heiko Carstens <heiko.carstens@de.ibm.com>, linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>
List-Id: linux-api@vger.kernel.org

Hi Masami,

On Fri, Oct 23, 2015 at 04:50:36PM +0900, Masami Hiramatsu wrote:
> Fix the testcase for kprobes which fails (false positive)
> because do_fork is renamed to _do_fork which is introduced
> by commit 3033f14ab78c32687 ("clone: support passing tls
> argument via C rather than pt_regs magic")
> 
> This looks into /proc/kallsyms and checks whether do_fork
> or _do_fork exists.
> 
> Without this fix (failure logs are removed):
>   ----
>   # ./ftracetest
>   === Ftrace unit tests ===
>   [1] Basic trace file check      [PASS]
>   [2] Basic test for tracers      [PASS]
>   [3] Basic trace clock test      [PASS]
>   [4] Basic event tracing check   [PASS]
>   [5] event tracing - enable/disable with event level files       [PASS]
>   [6] event tracing - enable/disable with subsystem level files   [PASS]
>   [7] event tracing - enable/disable with top level files [PASS]
>   [8] ftrace - function graph filters with stack tracer   [PASS]
>   [9] ftrace - function graph filters     [PASS]
>   [10] ftrace - function profiler with function tracing   [PASS]
>   [11] Kprobe dynamic event - adding and removing [FAIL]
>   [12] Kprobe dynamic event - busy event check    [FAIL]
>   [13] Kprobe dynamic event with arguments        [FAIL]
>   [14] Kprobe dynamic event with function tracer  [FAIL]
>   [15] Kretprobe dynamic event with arguments     [FAIL]
> 
>   # of passed:  10
>   # of failed:  5
>   # of unresolved:  0
>   # of untested:  0
>   # of unsupported:  0
>   # of xfailed:  0
>   # of undefined(test bug):  0
>   ----
> 
> With this fix:
>   ----
>   # ftracetest
>   === Ftrace unit tests ===
>   [1] Basic trace file check      [PASS]
>   [2] Basic test for tracers      [PASS]
>   kselftest/ftrace: Fix the testcases for kprobes on do_fork
>   [3] Basic trace clock test      [PASS]
>   [4] Basic event tracing check   [PASS]
>   [5] event tracing - enable/disable with event level files       [PASS]
>   [6] event tracing - enable/disable with subsystem level files   [PASS]
>   [7] event tracing - enable/disable with top level files [PASS]
>   [8] ftrace - function graph filters with stack tracer   [PASS]
>   [9] ftrace - function graph filters     [PASS]
>   [10] ftrace - function profiler with function tracing   [PASS]
>   [11] Kprobe dynamic event - adding and removing [PASS]
>   [12] Kprobe dynamic event - busy event check    [PASS]
>   [13] Kprobe dynamic event with arguments        [PASS]
>   [14] Kprobe dynamic event with function tracer  [PASS]
>   [15] Kretprobe dynamic event with arguments     [PASS]
> 
>   # of passed:  15
>   # of failed:  0
>   # of unresolved:  0
>   # of untested:  0
>   # of unsupported:  0
>   # of xfailed:  0
>   # of undefined(test bug):  0
>   ----
> 
> Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Shuah Khan <shuahkh@osg.samsung.com>
> Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
> Cc: linux-api@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org

Acked-by: Namhyung Kim <namhyung@kernel.org>

Thanks
Namhyung


> ---
>  .../ftrace/test.d/kprobe/add_and_remove.tc         |    3 ++-
>  .../selftests/ftrace/test.d/kprobe/busy_check.tc   |    3 ++-
>  .../selftests/ftrace/test.d/kprobe/kprobe_args.tc  |    3 ++-
>  .../ftrace/test.d/kprobe/kprobe_ftrace.tc          |   15 ++++++++-------
>  .../ftrace/test.d/kprobe/kretprobe_args.tc         |    3 ++-
>  5 files changed, 16 insertions(+), 11 deletions(-)
> 
> diff --git a/tools/testing/selftests/ftrace/test.d/kprobe/add_and_remove.tc b/tools/testing/selftests/ftrace/test.d/kprobe/add_and_remove.tc
> index a5a4262..345e2ad 100644
> --- a/tools/testing/selftests/ftrace/test.d/kprobe/add_and_remove.tc
> +++ b/tools/testing/selftests/ftrace/test.d/kprobe/add_and_remove.tc
> @@ -2,10 +2,11 @@
>  # description: Kprobe dynamic event - adding and removing
>  
>  [ -f kprobe_events ] || exit_unsupported # this is configurable
> +FORK=`grep do_fork$ /proc/kallsyms | cut -f 3 -d" "`
>  
>  echo 0 > events/enable
>  echo > kprobe_events
> -echo p:myevent do_fork > kprobe_events
> +echo p:myevent $FORK > kprobe_events
>  grep myevent kprobe_events
>  test -d events/kprobes/myevent
>  echo > kprobe_events
> diff --git a/tools/testing/selftests/ftrace/test.d/kprobe/busy_check.tc b/tools/testing/selftests/ftrace/test.d/kprobe/busy_check.tc
> index d8c7bb6..fe80134 100644
> --- a/tools/testing/selftests/ftrace/test.d/kprobe/busy_check.tc
> +++ b/tools/testing/selftests/ftrace/test.d/kprobe/busy_check.tc
> @@ -2,10 +2,11 @@
>  # description: Kprobe dynamic event - busy event check
>  
>  [ -f kprobe_events ] || exit_unsupported
> +FORK=`grep do_fork$ /proc/kallsyms | cut -f 3 -d" "`
>  
>  echo 0 > events/enable
>  echo > kprobe_events
> -echo p:myevent do_fork > kprobe_events
> +echo p:myevent $FORK > kprobe_events
>  test -d events/kprobes/myevent
>  echo 1 > events/kprobes/myevent/enable
>  echo > kprobe_events && exit 1 # this must fail
> diff --git a/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_args.tc b/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_args.tc
> index c45ee27..938b061 100644
> --- a/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_args.tc
> +++ b/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_args.tc
> @@ -2,10 +2,11 @@
>  # description: Kprobe dynamic event with arguments
>  
>  [ -f kprobe_events ] || exit_unsupported # this is configurable
> +FORK=`grep do_fork$ /proc/kallsyms | cut -f 3 -d" "`
>  
>  echo 0 > events/enable
>  echo > kprobe_events
> -echo 'p:testprobe do_fork $stack $stack0 +0($stack)' > kprobe_events
> +echo 'p:testprobe '$FORK' $stack $stack0 +0($stack)' > kprobe_events
>  grep testprobe kprobe_events
>  test -d events/kprobes/testprobe
>  echo 1 > events/kprobes/testprobe/enable
> diff --git a/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_ftrace.tc b/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_ftrace.tc
> index ab41d2b..51067c9 100644
> --- a/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_ftrace.tc
> +++ b/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_ftrace.tc
> @@ -3,34 +3,35 @@
>  
>  [ -f kprobe_events ] || exit_unsupported # this is configurable
>  grep function available_tracers || exit_unsupported # this is configurable
> +FORK=`grep do_fork$ /proc/kallsyms | cut -f 3 -d" "`
>  
>  # prepare
>  echo nop > current_tracer
> -echo do_fork > set_ftrace_filter
> +echo $FORK > set_ftrace_filter
>  echo 0 > events/enable
>  echo > kprobe_events
> -echo 'p:testprobe do_fork' > kprobe_events
> +echo 'p:testprobe '"$FORK" > kprobe_events
>  
>  # kprobe on / ftrace off
>  echo 1 > events/kprobes/testprobe/enable
>  echo > trace
>  ( echo "forked")
>  grep testprobe trace
> -! grep 'do_fork <-' trace
> +! grep "$FORK"' <-' trace
>  
>  # kprobe on / ftrace on
>  echo function > current_tracer
>  echo > trace
>  ( echo "forked")
>  grep testprobe trace
> -grep 'do_fork <-' trace
> +grep "$FORK"' <-' trace
>  
>  # kprobe off / ftrace on
>  echo 0 > events/kprobes/testprobe/enable
>  echo > trace
>  ( echo "forked")
>  ! grep testprobe trace
> -grep 'do_fork <-' trace
> +grep "$FORK"' <-' trace
>  
>  # kprobe on / ftrace on
>  echo 1 > events/kprobes/testprobe/enable
> @@ -38,14 +39,14 @@ echo function > current_tracer
>  echo > trace
>  ( echo "forked")
>  grep testprobe trace
> -grep 'do_fork <-' trace
> +grep "$FORK"' <-' trace
>  
>  # kprobe on / ftrace off
>  echo nop > current_tracer
>  echo > trace
>  ( echo "forked")
>  grep testprobe trace
> -! grep 'do_fork <-' trace
> +! grep "$FORK"' <-' trace
>  
>  # cleanup
>  echo nop > current_tracer
> diff --git a/tools/testing/selftests/ftrace/test.d/kprobe/kretprobe_args.tc b/tools/testing/selftests/ftrace/test.d/kprobe/kretprobe_args.tc
> index 3171798..683d290 100644
> --- a/tools/testing/selftests/ftrace/test.d/kprobe/kretprobe_args.tc
> +++ b/tools/testing/selftests/ftrace/test.d/kprobe/kretprobe_args.tc
> @@ -2,10 +2,11 @@
>  # description: Kretprobe dynamic event with arguments
>  
>  [ -f kprobe_events ] || exit_unsupported # this is configurable
> +FORK=`grep do_fork$ /proc/kallsyms | cut -f 3 -d" "`
>  
>  echo 0 > events/enable
>  echo > kprobe_events
> -echo 'r:testprobe2 do_fork $retval' > kprobe_events
> +echo 'r:testprobe2 '$FORK' $retval' > kprobe_events
>  grep testprobe2 kprobe_events
>  test -d events/kprobes/testprobe2
>  echo 1 > events/kprobes/testprobe2/enable
> 
