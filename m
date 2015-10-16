From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] kselftests/ftrace : Add event trigger testcases
Date: Thu, 15 Oct 2015 20:27:01 -0400
Message-ID: <20151015202701.752af971@grimm.local.home>
References: <20150725011310.4601.76087.stgit@localhost.localdomain>
	<20150727093411.GE22022@danjae.kornet>
	<55BD4AC5.8040905@hitachi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <55BD4AC5.8040905@hitachi.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Namhyung Kim <namhyung@kernel.org>, Tom Zanussi <tom.zanussi@linux.intel.com>, linux-api@vger.kernel.org, Shuah Khan <shuahkh@osg.samsung.com>, linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>
List-Id: linux-api@vger.kernel.org

On Sun, 02 Aug 2015 07:40:05 +0900
Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:

> On 2015/07/27 18:34, Namhyung Kim wrote:
> > Hi Masami,
> > 
> > On Sat, Jul 25, 2015 at 10:13:10AM +0900, Masami Hiramatsu wrote:
> >> This adds simple event trigger testcases for ftracetest,
> >> which covers following triggers.
> >>  - traceon-traceoff trigger
> >>  - enable/disable_event trigger
> >>  - snapshot trigger
> >>  - stacktrace trigger
> >>  - trigger filters
> >>
> >> Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> >> Cc: Steven Rostedt <rostedt@goodmis.org>
> >> Cc: Ingo Molnar <mingo@redhat.com>
> >> Cc: Shuah Khan <shuahkh@osg.samsung.com>
> >> Cc: Namhyung Kim <namhyung@kernel.org>
> >> Cc: Tom Zanussi <tom.zanussi@linux.intel.com>
> >> ---
> >>  tools/testing/selftests/ftrace/test.d/functions    |    9 +++
> >>  .../ftrace/test.d/trigger/trigger-eventonoff.tc    |   64 ++++++++++++++++++++
> >>  .../ftrace/test.d/trigger/trigger-filter.tc        |   59 ++++++++++++++++++
> >>  .../ftrace/test.d/trigger/trigger-snapshot.tc      |   56 ++++++++++++++++++
> >>  .../ftrace/test.d/trigger/trigger-stacktrace.tc    |   53 +++++++++++++++++
> >>  .../ftrace/test.d/trigger/trigger-traceonoff.tc    |   58 ++++++++++++++++++
> >>  6 files changed, 299 insertions(+)
> >>  create mode 100644 tools/testing/selftests/ftrace/test.d/trigger/trigger-eventonoff.tc
> >>  create mode 100644 tools/testing/selftests/ftrace/test.d/trigger/trigger-filter.tc
> >>  create mode 100644 tools/testing/selftests/ftrace/test.d/trigger/trigger-snapshot.tc
> >>  create mode 100644 tools/testing/selftests/ftrace/test.d/trigger/trigger-stacktrace.tc
> >>  create mode 100644 tools/testing/selftests/ftrace/test.d/trigger/trigger-traceonoff.tc
> >>
> >> diff --git a/tools/testing/selftests/ftrace/test.d/functions b/tools/testing/selftests/ftrace/test.d/functions
> >> index 5d8cd06..36ca18e 100644
> >> --- a/tools/testing/selftests/ftrace/test.d/functions
> >> +++ b/tools/testing/selftests/ftrace/test.d/functions
> >> @@ -14,3 +14,12 @@ enable_tracing() { # start trace recording
> >>  reset_tracer() { # reset the current tracer
> >>      echo nop > current_tracer
> >>  }
> >> +
> >> +reset_trigger() { # reset all current setting triggers
> >> +    grep -v ^# events/*/*/trigger |
> >> +    while read line; do
> >> +        cmd=`echo $line | cut -f2- -d:`
> >> +	echo "!$cmd" > `echo $line | cut -f1 -d:`
> > 
> > Broken whitespaces?
> 
> Right, I'll fix that.
> 

[..]

> > What about checking child_comm too to verify complex filter pattern
> > with string type?  Maybe something like below (not tested..)?
> > 
> > echo 'traceoff if child_pid != 0 && child_comm ~ '*sh' > events/.../trigger
> 
> OK, I'll add more complex patterns.

Hi Masami,

Did you ever send an updated patch?

-- Steve
