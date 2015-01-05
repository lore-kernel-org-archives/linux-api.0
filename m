From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v4 3/3] perf: Sample additional clock value
Date: Mon, 5 Jan 2015 14:45:14 +0100
Message-ID: <20150105134514.GS30905@twins.programming.kicks-ass.net>
References: <1415292718-19785-1-git-send-email-pawel.moll@arm.com>
 <1415292718-19785-4-git-send-email-pawel.moll@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1415292718-19785-4-git-send-email-pawel.moll-5wv7dgnIgG8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>
Cc: Richard Cochran <richardcochran-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Masami Hiramatsu <masami.hiramatsu.pt-FCd8Q96Dh0JBDgjK7y7TUQ@public.gmane.org>, Christopher Covington <cov-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Namhyung Kim <namhyung-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Ahern <dsahern-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Tomeu Vizoso <tomeu-XCtybt49RKsYaV1qd6yewg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, Nov 06, 2014 at 04:51:58PM +0000, Pawel Moll wrote:
> Currently three clocks are implemented: CLOCK_REALITME = 0,
> CLOCK_MONOTONIC = 1 and CLOCK_MONOTONIC_RAW = 2. The clock field is
> 5 bits wide to allow for future extension to custom, non-POSIX clock
> sources(MAX_CLOCK for those is 16, see include/uapi/linux/time.h) like
> ARM CoreSight (hardware trace) timestamp generator.

> @@ -304,7 +305,16 @@ struct perf_event_attr {
>  				mmap2          :  1, /* include mmap with inode data     */
>  				comm_exec      :  1, /* flag comm events that are due to an exec */
>  				uevents        :  1, /* allow uevents into the buffer */
> -				__reserved_1   : 38;
> +
> +				/*
> +				 * clock: one of the POSIX clock IDs:
> +				 *
> +				 * 0 - CLOCK_REALTIME
> +				 * 1 - CLOCK_MONOTONIC
> +				 * 4 - CLOCK_MONOTONIC_RAW
> +				 */
> +				clock          :  5, /* clock type */
> +				__reserved_1   : 33;
>  
>  	union {
>  		__u32		wakeup_events;	  /* wakeup every n events */

This would put a constraint on actually changing MAX_CLOCKS, are the
time people OK with that? Thomas, John?

I'm also not quite sure of using the >MAX_CLOCKS space for 'special'
clocks, preferably those would register themselves with the POSIX clock
interface.

> @@ -4631,6 +4637,24 @@ static void __perf_event_header__init_id(struct perf_event_header *header,
>  		data->cpu_entry.cpu	 = raw_smp_processor_id();
>  		data->cpu_entry.reserved = 0;
>  	}
> +
> +	if (sample_type & PERF_SAMPLE_CLOCK) {
> +		switch (event->attr.clock) {
> +		case CLOCK_REALTIME:
> +			data->clock = ktime_get_real_ns();
> +			break;
> +		case CLOCK_MONOTONIC:
> +			data->clock = ktime_get_mono_fast_ns();
> +			break;
> +		case CLOCK_MONOTONIC_RAW:
> +			data->clock = ktime_get_raw_ns();
> +			break;
> +		default:
> +			data->clock = 0;
> +			break;
> +		}
> +	}
> +
>  }

This is broken. There is nothing stopping this from being called from
NMI context and only the MONO one is NMI safe.

Also, one would expect something like:

	default: {
		struct k_clock *kc = clockid_to_kclock(event->attr.clock);
		struct timespec ts;
		if (kc) {
			kc->clock_get(event->attr.clock, &ts);
			data->clock = ktime_to_ns(timespec_to_ktime(ts));
		} else {
			data->clock = 0;
		}
	}

Albeit preferably slightly less horrible -- of course, one would first
need to deal with the NMI issue.
