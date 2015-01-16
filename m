From: Adrian Hunter <adrian.hunter-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v4 1/3] perf: Use monotonic clock as a source for timestamps
Date: Fri, 16 Jan 2015 14:41:55 +0200
Message-ID: <54B90713.1090503@intel.com>
References: <1415292718-19785-1-git-send-email-pawel.moll@arm.com> <1415292718-19785-2-git-send-email-pawel.moll@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1415292718-19785-2-git-send-email-pawel.moll-5wv7dgnIgG8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Richard Cochran <richardcochran-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Masami Hiramatsu <masami.hiramatsu.pt-FCd8Q96Dh0JBDgjK7y7TUQ@public.gmane.org>, Christopher Covington <cov-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Namhyung Kim <namhyung-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Ahern <dsahern-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Tomeu Vizoso <tomeu-XCtybt49RKsYaV1qd6yewg@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 06/11/14 18:51, Pawel Moll wrote:
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

Don't forget this breaks the relationship to TSC. So you will need something
like below. Also patch 3 needs to be done first and extended to cover TSC so
there is no gap when we cannot get TSC.

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 143e5f5..b6e833d 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1922,21 +1922,6 @@ void arch_perf_update_userpage(struct
perf_event_mmap_page *userpg, u64 now)
        userpg->cap_user_time_zero = 0;
        userpg->cap_user_rdpmc = x86_pmu.attr_rdpmc;
        userpg->pmc_width = x86_pmu.cntval_bits;
-
-       if (!sched_clock_stable())
-               return;
-
-       data = cyc2ns_read_begin();
-
-       userpg->cap_user_time = 1;
-       userpg->time_mult = data->cyc2ns_mul;
-       userpg->time_shift = data->cyc2ns_shift;
-       userpg->time_offset = data->cyc2ns_offset - now;
-
-       userpg->cap_user_time_zero = 1;
-       userpg->time_zero = data->cyc2ns_offset;
-
-       cyc2ns_read_end(data);
 }

 /*
