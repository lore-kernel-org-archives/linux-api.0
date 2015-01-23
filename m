From: David Ahern <dsahern-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v4 3/3] perf: Sample additional clock value
Date: Fri, 23 Jan 2015 11:05:37 -0700
Message-ID: <54C28D71.6040603@gmail.com>
References: <1415292718-19785-1-git-send-email-pawel.moll@arm.com>	 <1415292718-19785-4-git-send-email-pawel.moll@arm.com>	 <20150105134514.GS30905@twins.programming.kicks-ass.net> <1422032767.14076.151.camel@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1422032767.14076.151.camel-5wv7dgnIgG8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Richard Cochran <richardcochran-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Masami Hiramatsu <masami.hiramatsu.pt-FCd8Q96Dh0JBDgjK7y7TUQ@public.gmane.org>, Christopher Covington <cov-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Namhyung Kim <namhyung-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Tomeu Vizoso <tomeu-XCtybt49RKsYaV1qd6yewg@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 1/23/15 10:06 AM, Pawel Moll wrote:
> As far as I understand (John?) POSIX timers can be used on any clockid?
> So it would be possible to obtain a dynamic clock id, for example for my
> exotic trace hardware (by any means necessary, like opening a char
> device) and create a timer firing every 1 ms (in the trace time domain).
> Than this event would be somehow associated with a perf session (for
> example, by passing the timerid via perf's ioctl) and then, every when
> timer fires, a perf record (something like PERF_RECORD_TIMER?)
> containing the timer/clock's value*and*  the normal perf timestamp,
> would be injected into the circular buffer.

Like this: https://lkml.org/lkml/2011/2/27/158 ? note the date -- 4 
years ago. This is has been dragging on for a long time.

A few problems with that approach:
1. I would like to see a sample generated immediately to get the 
perf_clock -> timeofday correlation immediately rather than have to wait 
N (milli)seconds and have perf scan forward through an M-(giga)byte file 
looking for the one sample that gives the correlation.

I tried to address that problem with an ioctl to force a sample into the 
stream:
    https://lkml.org/lkml/2011/2/27/159
it did not go over very well.

2. there is a risk that the realtime samples dominate a stream.

Another issue that has been raised is updates to xtime by ntp / user. I 
have suggested tracepoints to catch those:
     https://lkml.org/lkml/2011/6/7/636
I don't believe there were ever any comments on the tracepoints.

David
