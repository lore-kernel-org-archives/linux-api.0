From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: Re: [PATCH v3 0/3] perf: User/kernel time correlation and event
 generation
Date: Tue, 04 Nov 2014 18:24:40 +0900
Message-ID: <54589B58.7080102@hitachi.com>
References: <1415060918-19954-1-git-send-email-pawel.moll@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1415060918-19954-1-git-send-email-pawel.moll@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Pawel Moll <pawel.moll@arm.com>
Cc: Richard Cochran <richardcochran@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Paul Mackerras <paulus@samba.org>, Arnaldo Carvalho de Melo <acme@kernel.org>, John Stultz <john.stultz@linaro.org>, Christopher Covington <cov@codeaurora.org>, Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Tomeu Vizoso <tomeu@tomeuvizoso.net>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Pawel Moll <mail@pawelmoll.com>
List-Id: linux-api@vger.kernel.org

Hello,

(2014/11/04 9:28), Pawel Moll wrote:
> 2. User event generation
> 
> Everyone present agreed that it would be a very-nice-to-have feature.
> There was some discussion about implementation details, so I welcome
> feedback and comments regarding my take on the matter.

Hmm, I'm trying to make a similar thing, dynamic event definition via
ftrace, which is already done by kprobes/uprobes. And this will be shown
as dynamic events from perf too.

What I'd like to do is the binary version of ftrace-marker, the text
version is already supported by qemu (see below).
https://lists.gnu.org/archive/html/qemu-devel/2013-04/msg00505.html

But since that is just a string data (not structured data), it is hard to
analyze via perf-script or some other useful filters/triggers in ftrace.

In my idea, the new event will be defined via a special file in debugfs like
kprobe-events, like below.

  # cd $debugfs/tracing
  # echo "newgrp/newevent signarg:s32 flag:u64" >> marker_events
  # cat events/newgrp/newevent/format
  name: newevent
  ID: 2048
  format:
        field:unsigned short common_type;       offset:0;       size:2; signed:0;
        field:unsigned char common_flags;       offset:2;       size:1; signed:0;
        field:unsigned char common_preempt_count;       offset:3;       size:1;signed:0;
        field:int common_pid;   offset:4;       size:4; signed:1;

        field:s32 signarg;      offset:8;      size:4; signed:1;
        field:u64 flag; offset:12;      size:8; signed:0;

  print fmt: "signarg=%d flag=0x%Lx", REC->signarg, REC->flag

Then, users will write the data (excluded common fields) when the event happens
via trace_marker which start with '\0'ID(in u32). Kernel just checks the ID and
its data size, but doesn't parse, filter/trigger it and log it into the kernel buffer.

Of course, this has a downside that the user must have a privilege to access to debugfs.
Thus maybe we need both of prctl() IF for perf and this IF for ftrace.

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
