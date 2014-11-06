From: Pawel Moll <pawel.moll@arm.com>
Subject: [PATCH v4 0/3] perf: User/kernel time correlation and event generation
Date: Thu,  6 Nov 2014 16:51:55 +0000
Message-ID: <1415292718-19785-1-git-send-email-pawel.moll@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Richard Cochran <richardcochran@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Paul Mackerras <paulus@samba.org>, Arnaldo Carvalho de Melo <acme@kernel.org>, John Stultz <john.stultz@linaro.org>, Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>, Christopher Covington <cov@codeaurora.org>, Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Tomeu Vizoso <tomeu@tomeuvizoso.net>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Pawel Moll <pawel.moll@arm.com>
List-Id: linux-api@vger.kernel.org

This is a second version of the post-LPC series. The changes are limited
to the first patch, adding a backward-compatibility kernel parameter.

The v3 cover letter:

I've organised a session on the subject during the tracing minisummit
at LPC 2014 in Dusseldorf. Notes taken from the discussion taken by
Steven Rostedt (thanks Steve!)

http://www.linuxplumbersconf.org/2014/wp-content/uploads/2014/10/LPC2014_Tracing.txt

The following three patches address three main topics. They are pretty
much orthogonal and (subject to small and obvious modifications) could
be applied independently from each other.

An executive summary of both discussion and the patches:

1. User/kernel perf timestamps correlation

Thomas suggested that, instead of jumping through loops of correlation,
perf should simply generate monotonic clock timestamps, instead of
using sched clock. Peter and I pointed out that Ingo didn't like this
idea as monotonic can be slow, but apparently the cases when it is are
irrelevant. Thomas offered to fly to Budapest to physically convince
Ingo - I hope it won't be necessary and he will be able to achieve
this here, on mailing lists :-)

Setting aside potential performance problems, it would be a really
great solution, unifying all trace systems (perf, ftrace and LTTng)
in this respect. I'm more than happy to work on potential improvements
in the are of monotonic clock if it was to help the cause.

If it is a definite no-go, we still have the third patch, allowing post-
capture correlation based on synchronisation events.

2. User event generation

Everyone present agreed that it would be a very-nice-to-have feature.
There was some discussion about implementation details, so I welcome
feedback and comments regarding my take on the matter.

3. Correlation with external timestamps

This is a new issue, which surfaced recently while I was working on
hardware trace infrastructure. It can timestamp trace packets, but is
using yet another, completely different time source to do this.

Thomas suggested solution which gets down to my original proposal for
sched/monotonic clock correlation - an additional sample type so events
can be "double stamped" using different clock sources providing
synchronisation points for later time approximation. I've just extended
the implementation with configuration value to select the clock source.
If the first patch (making perf timestamps monotonic) gets accepted,
there will be no immediate need for this one, but I'd like to gain some
feedback anyway.


That's all for this series. Previous versions:

- RFC: http://www.spinics.net/lists/kernel/msg1824419.html
- v1: http://thread.gmane.org/gmane.linux.kernel/1790231
- v2: http://thread.gmane.org/gmane.linux.kernel/1793272
- v3: http://thread.gmane.org/gmane.linux.kernel.api/5681


Pawel Moll (3):
  perf: Use monotonic clock as a source for timestamps
  perf: Userspace event
  perf: Sample additional clock value

 Documentation/kernel-parameters.txt |   9 +++
 include/linux/perf_event.h          |   6 ++
 include/uapi/linux/perf_event.h     |  37 +++++++++-
 include/uapi/linux/prctl.h          |  10 +++
 kernel/events/core.c                | 138 ++++++++++++++++++++++++++++++++++++
 kernel/sys.c                        |   5 ++
 6 files changed, 203 insertions(+), 2 deletions(-)

-- 
2.1.0
