From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v3 1/3] perf: Use monotonic clock as a source for
 timestamps
Date: Tue, 4 Nov 2014 16:30:09 +0100
Message-ID: <20141104153009.GJ10501@worktop.programming.kicks-ass.net>
References: <1415060918-19954-1-git-send-email-pawel.moll@arm.com>
 <1415060918-19954-2-git-send-email-pawel.moll@arm.com>
 <20141104072308.GE10501@worktop.programming.kicks-ass.net>
 <1415114727.24819.8.camel@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1415114727.24819.8.camel-5wv7dgnIgG8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>
Cc: Richard Cochran <richardcochran-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Masami Hiramatsu <masami.hiramatsu.pt-FCd8Q96Dh0JBDgjK7y7TUQ@public.gmane.org>, Christopher Covington <cov-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Namhyung Kim <namhyung-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Ahern <dsahern-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Tomeu Vizoso <tomeu-XCtybt49RKsYaV1qd6yewg@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Nov 04, 2014 at 03:25:27PM +0000, Pawel Moll wrote:
> Very good idea, should have came up with it myself :-)
> 
> Does __setup("perf_use_local_clock") sound reasonable?

Would not the 'module' already prefix a perf.? I never quite know how
all that works out. But sure, that works.

> Then we have to
> decide whether to hide the sysctl "perf_sample_time_clk_id" (my
> preferred option, will see how difficult it is) or just provide an
> invalid clock_id (eg. -1) in it.

invalid clock id is fine with me, although I suppose the clock people
might have an oh-pinion ;-)
