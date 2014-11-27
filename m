From: Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH v4 1/3] perf: Use monotonic clock as a source for
 timestamps
Date: Thu, 27 Nov 2014 15:05:50 +0000
Message-ID: <1417100750.4371.1.camel@arm.com>
References: <1415292718-19785-1-git-send-email-pawel.moll@arm.com>
	 <1415292718-19785-2-git-send-email-pawel.moll@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1415292718-19785-2-git-send-email-pawel.moll-5wv7dgnIgG8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Richard Cochran <richardcochran-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Masami Hiramatsu <masami.hiramatsu.pt-FCd8Q96Dh0JBDgjK7y7TUQ@public.gmane.org>, Christopher Covington <cov-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Namhyung Kim <namhyung-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Ahern <dsahern-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Tomeu Vizoso <tomeu-XCtybt49RKsYaV1qd6yewg@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, 2014-11-06 at 16:51 +0000, Pawel Moll wrote:
> Until now, perf framework never defined the meaning of the timestamps
> captured as PERF_SAMPLE_TIME sample type. The values were obtaining
> from local (sched) clock, which is unavailable in userspace. This made
> it impossible to correlate perf data with any other events. Other
> tracing solutions have the source configurable (ftrace) or just share
> a common time domain between kernel and userspace (LTTng).
> 
> Follow the trend by using monotonic clock, which is readily available
> as POSIX CLOCK_MONOTONIC.
> 
> Also add a sysctl "perf_sample_time_clk_id" attribute which can be used
> by the user to obtain the clk_id to be used with POSIX clock API (eg.
> clock_gettime()) to obtain a time value comparable with perf samples.
> 
> Old behaviour can be restored by using "perf_use_local_clock" kernel
> parameter.
> 
> Signed-off-by: Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>

It's been 3 weeks without any negative feedback (no feedback at all, but
I take the optimistic view :-)...

How about queuing at least this patch alone for the incoming merge
window? Or at least getting it into -next, with the view at 3.20?

Pawel
