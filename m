From: Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH v2 1/2] perf: Add sampling of the raw monotonic clock
Date: Fri, 26 Sep 2014 11:58:23 +0100
Message-ID: <1411729103.3852.19.camel@hornet>
References: <1411491787-25938-1-git-send-email-pawel.moll@arm.com>
	 <1411491787-25938-2-git-send-email-pawel.moll@arm.com>
	 <87sijhk21x.fsf@sejong.aot.lge.com> <1411642198.4768.30.camel@hornet>
	 <8738bekith.fsf@sejong.aot.lge.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <8738bekith.fsf-vfBCOVm4yAnB69T4xOojN9BPR1lH4CV8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Namhyung Kim <namhyung-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Richard Cochran <richardcochran-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org


On Fri, 2014-09-26 at 07:16 +0100, Namhyung Kim wrote:
> > It would be doable, I guess, but what
> > if someone *wants* to have sched clock as the timestamps source (because
> > it's cheap) but still be able to correlate them with userspace? In this
> > case two separate timestamps are required to do the approximation.
> 
> But by collecting two timestamps, you'll loose the win of the first
> timestamp, no?

But I can ask for both timestamps only being collected on "low
bandwidth" events, in particular context switches and/or periodic (eg.
10ms hrtimer) software events.

Then I have loads of normal normal samples, timestamped with sched clock
only, and every now and then one with both timestamps which then I can
use for time correlation. The whole point is that the frequency of such
"synchronisation" event can be much (much!) lower than of the normal
samples, but it still allows pretty good approximation (I was getting
accuracy of ~1 microsecond and better with sched_switch trace event
marked with additional raw monotonic timestamp).

Pawel

PS. Have you sent a couple of the messages via some kind of gmane's
proxy? All the mail addresses got rather messed up...
