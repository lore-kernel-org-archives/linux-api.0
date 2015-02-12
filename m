From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v5] perf: Use monotonic clock as a source for timestamps
Date: Thu, 12 Feb 2015 16:38:08 +0100
Message-ID: <20150212153808.GR24151@twins.programming.kicks-ass.net>
References: <1415292718-19785-2-git-send-email-pawel.moll@arm.com>
 <1421872037-12559-1-git-send-email-pawel.moll@arm.com>
 <1422895966.4944.25.camel@arm.com>
 <CAN+dfcT_6zZZ4oeyngUE5N0Wtx2B9CvXsfU71m+cuyXpq2KBdw@mail.gmail.com>
 <1422955245.4944.26.camel@arm.com>
 <20150211161256.GH2896@worktop.programming.kicks-ass.net>
 <54DC7AC6.5010605@intel.com>
 <20150212102814.GK2896@worktop.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150212102814.GK2896-IIpfhp3q70z/8w/KjCw3T+5/BudmfyzbbVWyRVo5IupeoWH0uzbU5w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Adrian Hunter <adrian.hunter-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, ajh mls <ajhmls-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Richard Cochran <richardcochran-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Masami Hiramatsu <masami.hiramatsu.pt-FCd8Q96Dh0JBDgjK7y7TUQ@public.gmane.org>, Christopher Covington <cov-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Namhyung Kim <namhyung-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Ahern <dsahern-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Tomeu Vizoso <tomeu-XCtybt49RKsYaV1qd6yewg@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Feb 12, 2015 at 11:28:14AM +0100, Peter Zijlstra wrote:
> > and you would have to check the clocksource is TSC.
> 
> It implicitly does that; it has that sched_clock_stable() thing, but
> yeah I suppose someone could change the clocksource even though the tsc
> is stable.
> 
> Not using TSC when its available is quite crazy though.. but sure.

Something like this on top then.. it might have a few header issues, the
whole asm/tsc.h vs clocksource.h thing looks like pain.

I haven't tried to compile it, maybe we can move cycle_t into types and
fwd declare struct clocksource or whatnot.

Of course, all this is quite horrible on the timekeeping side; it might
be tglx and/or jstutlz are having spasms just reading it :-)

---
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1967,17 +1967,19 @@ static void local_clock_user_time(struct
 	cyc2ns_read_end(data);
 }
 
-extern void notrace __ktime_get_mono_fast(u64 *offset, u32 *mult, u16 *shift);
+extern bool notrace __ktime_get_mono_fast(cycle_t (*read)(struct clocksource *cs),
+		u64 *offset, u32 *mult, u16 *shift);
 
 static void ktime_fast_mono_user_time(struct perf_event_mmap_page *userpg, u64 now)
 {
+	if (!__ktime_get_mono_fast(read_tsc, &userpg->time_zero,
+				   &userpg->time_mult,
+				   &userpg->time_shift))
+		return;
+
 	userpg->cap_user_time = 1;
 	userpg->cap_user_time_zero = 1;
 
-	__ktime_get_mono_fast(&userpg->time_zero,
-			      &userpg->time_mult,
-			      &userpg->time_shift);
-
 	userpg->offset = userpg->time_zero - now;
 }
 
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -334,7 +334,8 @@ u64 notrace ktime_get_mono_fast_ns(void)
 }
 EXPORT_SYMBOL_GPL(ktime_get_mono_fast_ns);
 
-void notrace __ktime_get_mono_fast(u64 *offset, u32 *mult, u16 *shift)
+bool notrace __ktime_get_mono_fast(cycle_t (*read)(struct clocksource *),
+				   u64 *offset, u32 *mult, u16 *shift)
 {
 	struct tk_read_base *tkr;
 	unsigned int seq;
@@ -345,6 +346,9 @@ void notrace __ktime_get_mono_fast(u64 *
 		seq = raw_read_seqcount(&tk_fast_mono.seq);
 		tkr = tk_fast_mono.base + (seq & 0x01);
 
+		if (tkr->read != read)
+			return false;
+
 		cycle_now = tkr->read(tkr->clock);
 		delta = clocksource_delta(cycle_now, tkr->cycle_last, tkr->mask);
 
@@ -362,6 +366,8 @@ void notrace __ktime_get_mono_fast(u64 *
 		*offset = now - nsec;
 
 	} while (read_seqcount_retry(&tk_fast_mono.seq, seq));
+
+	return true;
 }
 
 #ifdef CONFIG_GENERIC_TIME_VSYSCALL_OLD
diff --git a/arch/x86/include/asm/tsc.h b/arch/x86/include/asm/tsc.h
index 94605c0e9cee..68e4039a58ea 100644
--- a/arch/x86/include/asm/tsc.h
+++ b/arch/x86/include/asm/tsc.h
@@ -32,6 +32,8 @@ static inline cycles_t get_cycles(void)
 	return ret;
 }
 
+extern void cycle_t read_tsc(struct clocksource *);
+
 static __always_inline cycles_t vget_cycles(void)
 {
 	/*
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 505449700e0c..c580998f0160 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -965,7 +965,7 @@ static struct clocksource clocksource_tsc;
  * checking the result of read_tsc() - cycle_last for being negative.
  * That works because CLOCKSOURCE_MASK(64) does not mask out any bit.
  */
-static cycle_t read_tsc(struct clocksource *cs)
+cycle_t read_tsc(struct clocksource *cs)
 {
 	return (cycle_t)get_cycles();
 }
