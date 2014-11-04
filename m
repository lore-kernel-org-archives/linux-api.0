From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v3 1/3] perf: Use monotonic clock as a source for
 timestamps
Date: Tue, 4 Nov 2014 08:23:08 +0100
Message-ID: <20141104072308.GE10501@worktop.programming.kicks-ass.net>
References: <1415060918-19954-1-git-send-email-pawel.moll@arm.com>
 <1415060918-19954-2-git-send-email-pawel.moll@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1415060918-19954-2-git-send-email-pawel.moll-5wv7dgnIgG8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>
Cc: Richard Cochran <richardcochran-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Masami Hiramatsu <masami.hiramatsu.pt-FCd8Q96Dh0JBDgjK7y7TUQ@public.gmane.org>, Christopher Covington <cov-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Namhyung Kim <namhyung-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Ahern <dsahern-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Tomeu Vizoso <tomeu-XCtybt49RKsYaV1qd6yewg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, Nov 04, 2014 at 12:28:36AM +0000, Pawel Moll wrote:

> +int sysctl_perf_sample_time_clk_id = CLOCK_MONOTONIC;

const ?

>  /*
>   * perf samples are done in some very critical code paths (NMIs).
>   * If they take too much CPU time, the system can lock up and not
> @@ -324,7 +326,7 @@ extern __weak const char *perf_pmu_name(void)
>  
>  static inline u64 perf_clock(void)
>  {
> -	return local_clock();
> +	return ktime_get_mono_fast_ns();
>  }

Do we maybe want to make it boot-time switchable back to local_clock for
people with bad systems and or backwards compat issues?

Everybody using Core2 and older will very much not want to have this
unless they've got a very good reason for wanting it.
