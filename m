From: John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v5] perf: Use monotonic clock as a source for timestamps
Date: Fri, 13 Feb 2015 08:25:13 +0800
Message-ID: <CALAqxLVcF+KrR208nLEc_tb16MdUjGX7jwve=sW2uih=DWS+dQ@mail.gmail.com>
References: <1415292718-19785-2-git-send-email-pawel.moll@arm.com>
	<1421872037-12559-1-git-send-email-pawel.moll@arm.com>
	<1422895966.4944.25.camel@arm.com>
	<CAN+dfcT_6zZZ4oeyngUE5N0Wtx2B9CvXsfU71m+cuyXpq2KBdw@mail.gmail.com>
	<1422955245.4944.26.camel@arm.com>
	<20150211161256.GH2896@worktop.programming.kicks-ass.net>
	<54DC7AC6.5010605@intel.com>
	<20150212102814.GK2896@worktop.programming.kicks-ass.net>
	<20150212153808.GR24151@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150212153808.GR24151-ndre7Fmf5hadTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Adrian Hunter <adrian.hunter-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, ajh mls <ajhmls-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Richard Cochran <richardcochran-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Masami Hiramatsu <masami.hiramatsu.pt-FCd8Q96Dh0JBDgjK7y7TUQ@public.gmane.org>, Christopher Covington <cov-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Namhyung Kim <namhyung-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Ahern <dsahern-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Tomeu Vizoso <tomeu-XCtybt49RKsYaV1qd6yewg@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Feb 12, 2015 at 11:38 PM, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
> On Thu, Feb 12, 2015 at 11:28:14AM +0100, Peter Zijlstra wrote:
>> > and you would have to check the clocksource is TSC.
>>
>> It implicitly does that; it has that sched_clock_stable() thing, but
>> yeah I suppose someone could change the clocksource even though the tsc
>> is stable.
>>
>> Not using TSC when its available is quite crazy though.. but sure.
>
> Something like this on top then.. it might have a few header issues, the
> whole asm/tsc.h vs clocksource.h thing looks like pain.
>
> I haven't tried to compile it, maybe we can move cycle_t into types and
> fwd declare struct clocksource or whatnot.
>
> Of course, all this is quite horrible on the timekeeping side; it might
> be tglx and/or jstutlz are having spasms just reading it :-)


Oof.. Yea, this exposes all sorts of timekeeping internals out to the
rest of the kernel that I'd rather not have out there.

> --- a/arch/x86/kernel/cpu/perf_event.c
> +++ b/arch/x86/kernel/cpu/perf_event.c
> @@ -1967,17 +1967,19 @@ static void local_clock_user_time(struct
>         cyc2ns_read_end(data);
>  }
>
> -extern void notrace __ktime_get_mono_fast(u64 *offset, u32 *mult, u16 *shift);
> +extern bool notrace __ktime_get_mono_fast(cycle_t (*read)(struct clocksource *cs),
> +               u64 *offset, u32 *mult, u16 *shift);
>
>  static void ktime_fast_mono_user_time(struct perf_event_mmap_page *userpg, u64 now)
>  {
> +       if (!__ktime_get_mono_fast(read_tsc, &userpg->time_zero,
> +                                  &userpg->time_mult,
> +                                  &userpg->time_shift))

Soo.. instead of hard-coding read_tsc here, can we instead use a
clocksource flag that we can check that the current clocksource is
valid for this sort of use?

thanks
-john
