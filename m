From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v5] perf: Use monotonic clock as a source for timestamps
Date: Thu, 12 Feb 2015 11:28:14 +0100
Message-ID: <20150212102814.GK2896@worktop.programming.kicks-ass.net>
References: <1415292718-19785-2-git-send-email-pawel.moll@arm.com>
 <1421872037-12559-1-git-send-email-pawel.moll@arm.com>
 <1422895966.4944.25.camel@arm.com>
 <CAN+dfcT_6zZZ4oeyngUE5N0Wtx2B9CvXsfU71m+cuyXpq2KBdw@mail.gmail.com>
 <1422955245.4944.26.camel@arm.com>
 <20150211161256.GH2896@worktop.programming.kicks-ass.net>
 <54DC7AC6.5010605@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <54DC7AC6.5010605-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Adrian Hunter <adrian.hunter-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, ajh mls <ajhmls-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Richard Cochran <richardcochran-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Masami Hiramatsu <masami.hiramatsu.pt-FCd8Q96Dh0JBDgjK7y7TUQ@public.gmane.org>, Christopher Covington <cov-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Namhyung Kim <namhyung-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Ahern <dsahern-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Tomeu Vizoso <tomeu-XCtybt49RKsYaV1qd6yewg@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Feb 12, 2015 at 12:04:54PM +0200, Adrian Hunter wrote:
> On 11/02/15 18:12, Peter Zijlstra wrote:
> > 
> > How about something like the below? I _think_ it should mostly work for
> > x86, where the tsc is a 64bit wide cycle counter.
> 
> It would have to be based on CLOCK_MONOTONIC_RAW not CLOCK_MONOTONIC 

Why?

> and you would have to check the clocksource is TSC.

It implicitly does that; it has that sched_clock_stable() thing, but
yeah I suppose someone could change the clocksource even though the tsc
is stable.

Not using TSC when its available is quite crazy though.. but sure.

> Why is CLOCK_MONOTONIC preferred anyway - I would have thought any
> adjustment would skew performance timings?

Because you can do inter-machine stuff with MONOTONIC and that's
entirely impossible with MONO_RAW.
