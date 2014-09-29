From: Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH 1/2] perf: Add sampling of the raw monotonic clock
Date: Mon, 29 Sep 2014 16:45:18 +0100
Message-ID: <1412005518.3817.23.camel@hornet>
References: <1411050873-9310-1-git-send-email-pawel.moll@arm.com>
	 <1411050873-9310-2-git-send-email-pawel.moll@arm.com>
	 <20140929152832.GL4140@worktop.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140929152832.GL4140-IIpfhp3q70z/8w/KjCw3T+5/BudmfyzbbVWyRVo5IupeoWH0uzbU5w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Richard Cochran <richardcochran-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, 2014-09-29 at 16:28 +0100, Peter Zijlstra wrote:
> On Thu, Sep 18, 2014 at 03:34:32PM +0100, Pawel Moll wrote:
> > @@ -4456,6 +4459,13 @@ static void __perf_event_header__init_id(struct perf_event_header *header,
> >  		data->cpu_entry.cpu	 = raw_smp_processor_id();
> >  		data->cpu_entry.reserved = 0;
> >  	}
> > +
> > +	if (sample_type & PERF_SAMPLE_CLOCK_RAW_MONOTONIC) {
> > +		struct timespec now;
> > +
> > +		getrawmonotonic(&now);
> > +		data->clock_raw_monotonic = timespec_to_ns(&now);
> > +	}
> >  }
> >  
> 
> This cannot work, getrawmonotonic() isn't NMI-safe and there's
> nothing stopping this being used from NMI context.
> 
> Also getrawmonotonic() + timespec_to_ns() will make tglx sad, he's just
> done a tree-wide eradication of silly conversions and now you're adding
> a ns -> timespec -> ns dance right back.

Last thing I want is to make Thomas sad... For obvious reasons ;-)

> I _think_ you want ktime_get_mono_fast_ns(), 

With pleasure, it's exactly what I need.

> but this does bring us
> right back to the question/discussion on which timebase you'd want to
> sync again. MONO does make sense for most cases, but I think we've had
> fairly sane stories for people wanting to sync against other clocks.

Yes. I've asked the same question somewhere in the thread.

ftrace has got a switch and a selection of trace_clocks in
kernel/trace/trace.c - do we want something similar (in integer form
probably, though) in perf_events.h with an additional "flag" in struct
perf_event_attr? It could be used to pick a time source for
PERF_SAMPLE_CLOCK (PERF_SAMPLE_TRACE_CLOCK?) sample.

Pawel
