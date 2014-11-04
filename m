From: Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH v3 1/3] perf: Use monotonic clock as a source for
 timestamps
Date: Tue, 04 Nov 2014 15:25:27 +0000
Message-ID: <1415114727.24819.8.camel@arm.com>
References: <1415060918-19954-1-git-send-email-pawel.moll@arm.com>
	 <1415060918-19954-2-git-send-email-pawel.moll@arm.com>
	 <20141104072308.GE10501@worktop.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141104072308.GE10501-IIpfhp3q70z/8w/KjCw3T+5/BudmfyzbbVWyRVo5IupeoWH0uzbU5w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Richard Cochran <richardcochran-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Masami Hiramatsu <masami.hiramatsu.pt-FCd8Q96Dh0JBDgjK7y7TUQ@public.gmane.org>, Christopher Covington <cov-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Namhyung Kim <namhyung-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Ahern <dsahern-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Tomeu Vizoso <tomeu-XCtybt49RKsYaV1qd6yewg@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, 2014-11-04 at 07:23 +0000, Peter Zijlstra wrote:
> On Tue, Nov 04, 2014 at 12:28:36AM +0000, Pawel Moll wrote:
> 
> > +int sysctl_perf_sample_time_clk_id = CLOCK_MONOTONIC;
> 
> const ?

Sure (unless we have to change it as mentioned below)

> >  /*
> >   * perf samples are done in some very critical code paths (NMIs).
> >   * If they take too much CPU time, the system can lock up and not
> > @@ -324,7 +326,7 @@ extern __weak const char *perf_pmu_name(void)
> >  
> >  static inline u64 perf_clock(void)
> >  {
> > -	return local_clock();
> > +	return ktime_get_mono_fast_ns();
> >  }
> 
> Do we maybe want to make it boot-time switchable back to local_clock for
> people with bad systems and or backwards compat issues?

Very good idea, should have came up with it myself :-)

Does __setup("perf_use_local_clock") sound reasonable? Then we have to
decide whether to hide the sysctl "perf_sample_time_clk_id" (my
preferred option, will see how difficult it is) or just provide an
invalid clock_id (eg. -1) in it.

Cheers!

Pawel
