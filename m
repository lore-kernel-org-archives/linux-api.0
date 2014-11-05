From: Masami Hiramatsu <masami.hiramatsu.pt-FCd8Q96Dh0JBDgjK7y7TUQ@public.gmane.org>
Subject: Re: Re: [PATCH v3 0/3] perf: User/kernel time correlation and
 event generation
Date: Wed, 05 Nov 2014 17:06:52 +0900
Message-ID: <5459DA9C.6020704@hitachi.com>
References: <1415060918-19954-1-git-send-email-pawel.moll@arm.com>  <54589B58.7080102@hitachi.com> <1415116269.24819.14.camel@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1415116269.24819.14.camel-5wv7dgnIgG8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>
Cc: Richard Cochran <richardcochran-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Christopher Covington <cov-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Namhyung Kim <namhyung-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Ahern <dsahern-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Tomeu Vizoso <tomeu-XCtybt49RKsYaV1qd6yewg@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "yrl.pp-manager.tt-FCd8Q96Dh0JBDgjK7y7TUQ@public.gmane.org" <yrl.pp-manager.tt-FCd8Q96Dh0JBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

(2014/11/05 0:51), Pawel Moll wrote:
> On Tue, 2014-11-04 at 09:24 +0000, Masami Hiramatsu wrote:
>> What I'd like to do is the binary version of ftrace-marker, the text
>> version is already supported by qemu (see below).
>> https://lists.gnu.org/archive/html/qemu-devel/2013-04/msg00505.html
>>
>> But since that is just a string data (not structured data), it is hard to
>> analyze via perf-script or some other useful filters/triggers in ftrace.
>>
>> In my idea, the new event will be defined via a special file in debugfs like
>> kprobe-events, like below.
>>
>>   # cd $debugfs/tracing
>>   # echo "newgrp/newevent signarg:s32 flag:u64" >> marker_events
>>   # cat events/newgrp/newevent/format
>>   name: newevent
>>   ID: 2048
>>   format:
>>         field:unsigned short common_type;       offset:0;       size:2; signed:0;
>>         field:unsigned char common_flags;       offset:2;       size:1; signed:0;
>>         field:unsigned char common_preempt_count;       offset:3;       size:1;signed:0;
>>         field:int common_pid;   offset:4;       size:4; signed:1;
>>
>>         field:s32 signarg;      offset:8;      size:4; signed:1;
>>         field:u64 flag; offset:12;      size:8; signed:0;
>>
>>   print fmt: "signarg=%d flag=0x%Lx", REC->signarg, REC->flag
>>
>> Then, users will write the data (excluded common fields) when the event happens
>> via trace_marker which start with '\0'ID(in u32). Kernel just checks the ID and
>> its data size, but doesn't parse, filter/trigger it and log it into the kernel buffer.
> 
> Very neat, I like it! Certainly useful with scripting. Any gut feeling
> regarding the kernel version it will be ready for? 3.19 or later than
> that?

Thanks, and not yet implemented, I'd like to ask people about the format etc.
before that :)

>> Of course, this has a downside that the user must have a privilege to access to debugfs.
>> Thus maybe we need both of prctl() IF for perf and this IF for ftrace.
> 
> I don't have any particularly strong feelings about the solution as long
> as I'm able to create this "synchronisation point" of mine in the perf
> data. In one of this patch's previous incarnations I was also doing a
> write() to the perf fd to achieve pretty much the same result.
> 
> In my personal use case root access to debugfs isn't a problem (I need
> it for other ftrace operations anyway). However Ingo and some other guys
> seemed interested in prctl() approach because: 1. it's much simpler to
> use even comparing with simple trace_marker's open(path)/write()/close()
> and 2. because any process can do it at any time and the results are
> quietly discarded if no one is listening. I also remember that when I
> proposed sort of "unification" between trace_marker and the uevents,
> Ingo straight away "suggested" keeping it separate.

Agreed, I think we can keep trace_marker opened (so application will just
need to write() the events), but for the second reason, prctl will be
better for per-application usage. Actually, ftrace is "system-wide" oriented,
but the perf is not.

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt-FCd8Q96Dh0JBDgjK7y7TUQ@public.gmane.org
