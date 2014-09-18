From: Pawel Moll <pawel.moll@arm.com>
Subject: [PATCH 0/2] perf: User/kernel time correlation and event generation
Date: Thu, 18 Sep 2014 15:34:31 +0100
Message-ID: <1411050873-9310-1-git-send-email-pawel.moll@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Richard Cochran <richardcochran@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Paul Mackerras <paulus@samba.org>, Arnaldo Carvalho de Melo <acme@kernel.org>, John Stultz <john.stultz@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Pawel Moll <pawel.moll@arm.com>
List-Id: linux-api@vger.kernel.org

Greetings,

This is a second spin of the short series posted last week:

http://www.spinics.net/lists/kernel/msg1824419.html

The first patch adds an additional timestamp field in the perf
sample data, which can be requested for any perf event along
with normal PERF_SAMPLE_TIME. Events with both values appearing
periodically in the perf data allow user code to translate
raw monotonic time (obtained via POSIX clock API) to sched_clock
domain. Although any perf event can be used, the natural choice
would be a sched_switch trace event (for processes with root
permissions) or a hrtimer-based PERF_COUNT_SW_CPU_CLOCK.

It didn't attract any comments previously, so is just re-posted
without any changes.

The second patch, functionally orthogonal but complementing
the first one, builds on the ftrace "trace_maker" idea. It adds
a ioctl that can be used to inject a userspace-generated data
into the perf buffer. It provides base for printf-like
functionality in perf world. If used with the previous patch,
it can be also used to provide synchronisation points for sched
vs. raw monotonic time stamps correlation.

First version of the patch was taking a zero-terminated string
as an argument. Now it is taking a custom structure with "type"
and "size" integer fields followed by data. Type value "0"
is defined as a zero-terminated string (although size, including
the NULL character, must still be provided), but meaning of data
for other types is of no interest for the kernel. The intention
is to host a list of "well known" types (with reference parsers
for them) in the user perf tool code.

Pawel Moll (2):
  perf: Add sampling of the raw monotonic clock
  perf: Userspace software event and ioctl

 include/linux/perf_event.h      | 10 +++++
 include/uapi/linux/perf_event.h | 36 +++++++++++++++++-
 kernel/events/core.c            | 81 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 126 insertions(+), 1 deletion(-)

-- 
1.9.1
