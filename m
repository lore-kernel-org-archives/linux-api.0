From: Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH v4 3/3] perf: Sample additional clock value
Date: Fri, 23 Jan 2015 17:06:07 +0000
Message-ID: <1422032767.14076.151.camel@arm.com>
References: <1415292718-19785-1-git-send-email-pawel.moll@arm.com>
	 <1415292718-19785-4-git-send-email-pawel.moll@arm.com>
	 <20150105134514.GS30905@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150105134514.GS30905-ndre7Fmf5hadTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Richard Cochran <richardcochran-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Masami Hiramatsu <masami.hiramatsu.pt-FCd8Q96Dh0JBDgjK7y7TUQ@public.gmane.org>, Christopher Covington <cov-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Namhyung Kim <namhyung-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Ahern <dsahern-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Tomeu Vizoso <tomeu-XCtybt49RKsYaV1qd6yewg@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, 2015-01-05 at 13:45 +0000, Peter Zijlstra wrote:
> Also, one would expect something like:
> 
> 	default: {
> 		struct k_clock *kc = clockid_to_kclock(event->attr.clock);
> 		struct timespec ts;
> 		if (kc) {
> 			kc->clock_get(event->attr.clock, &ts);
> 			data->clock = ktime_to_ns(timespec_to_ktime(ts));
> 		} else {
> 			data->clock = 0;
> 		}
> 	}
> 
> Albeit preferably slightly less horrible -- of course, one would first
> need to deal with the NMI issue.

I was thinking about it... Maybe the solution is approaching the problem
in a completely different way.

As far as I understand (John?) POSIX timers can be used on any clockid?
So it would be possible to obtain a dynamic clock id, for example for my
exotic trace hardware (by any means necessary, like opening a char
device) and create a timer firing every 1 ms (in the trace time domain).
Than this event would be somehow associated with a perf session (for
example, by passing the timerid via perf's ioctl) and then, every when
timer fires, a perf record (something like PERF_RECORD_TIMER?)
containing the timer/clock's value *and* the normal perf timestamp,
would be injected into the circular buffer.

No issue with NMI, no issue with passing clockid through
perf_event_attr...

Does it make any sense to anyone else but me? ;-)

Pawel
