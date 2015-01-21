From: Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH v4 1/3] perf: Use monotonic clock as a source for
 timestamps
Date: Wed, 21 Jan 2015 15:52:23 +0000
Message-ID: <1421855543.14076.68.camel@arm.com>
References: <1415292718-19785-1-git-send-email-pawel.moll@arm.com>
	 <1415292718-19785-2-git-send-email-pawel.moll@arm.com>
	 <20150105130035.GP30905@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150105130035.GP30905-ndre7Fmf5hadTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Richard Cochran <richardcochran-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Masami Hiramatsu <masami.hiramatsu.pt-FCd8Q96Dh0JBDgjK7y7TUQ@public.gmane.org>, Christopher Covington <cov-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Namhyung Kim <namhyung-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Ahern <dsahern-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Tomeu Vizoso <tomeu-XCtybt49RKsYaV1qd6yewg@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, 2015-01-05 at 13:00 +0000, Peter Zijlstra wrote:
> On Thu, Nov 06, 2014 at 04:51:56PM +0000, Pawel Moll wrote:
> >  Documentation/kernel-parameters.txt |  9 +++++++++
> >  kernel/events/core.c                | 37 +++++++++++++++++++++++++++++++++++++
> >  2 files changed, 46 insertions(+)
> 
> > diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> > index 4c81a86..8ead8d8 100644
> > --- a/Documentation/kernel-parameters.txt
> > +++ b/Documentation/kernel-parameters.txt
> 
> > @@ -2763,6 +2764,14 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
> >  			allocator.  This parameter is primarily	for debugging
> >  			and performance comparison.
> >  
> > +	perf_use_local_clock
> > +			[PERF]
> > +			Use local_clock() as a source for perf timestamps
> > +			generation. This was be the default behaviour and
> > +			this parameter can be used to maintain backward
> > +			compatibility or on older hardware with expensive
> > +			monotonic clock source.
> > +
> >  	pf.		[PARIDE]
> >  			See Documentation/blockdev/paride.txt.
> 
> So I'm always terminally confused on the naming of kernel parameters,
> sometimes things are modules (even when they're not actually =m capable)
> and get a module::foo naming or so and sometimes they're not.

I guess you mean module.foo?

> So we want to use the module naming thing or not?

Honestly, I don't mind either way. For one thing ftrace doesn't bother
and just uses __setup() as well.

> > diff --git a/kernel/events/core.c b/kernel/events/core.c
> > index 2b02c9f..5d0aa03 100644
> > --- a/kernel/events/core.c
> > +++ b/kernel/events/core.c
> 
> > @@ -322,8 +323,41 @@ extern __weak const char *perf_pmu_name(void)
> >  	return "pmu";
> >  }
> >  
> > +static bool perf_use_local_clock;
> > +static int __init perf_use_local_clock_setup(char *__unused)
> > +{
> > +	perf_use_local_clock = true;
> > +	return 1;
> > +}
> > +__setup("perf_use_local_clock", perf_use_local_clock_setup);
> 
> >  static inline u64 perf_clock(void)
> >  {
> > +	if (likely(!perf_use_local_clock))
> > +		return ktime_get_mono_fast_ns();
> > +
> >  	return local_clock();
> >  }
> 
> Since this all is boot time, should we not use things like static_key
> and avoid the 'pointless' conditional at runtime?

Right. it's good to learn new stuff - I didn't know there was
architecture-agnostic support for jump labels. Definitely worth the
effort, will give it a try and spin the patch.

Pawel
