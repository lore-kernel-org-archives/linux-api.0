From: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH 00/11] drm/i915: Expose OA metrics via perf PMU
Date: Wed, 27 May 2015 18:41:17 +0200
Message-ID: <20150527164116.GA27857@gmail.com>
References: <1431008154-6833-1-git-send-email-robert@sixbynine.org>
 <20150508162452.GR27504@twins.programming.kicks-ass.net>
 <CAMou1-1Q1_kKGrRPz36Fox=gxhGF6v+DiR5HZ6TOyQyxtMsysA@mail.gmail.com>
 <20150519145337.GD3644@twins.programming.kicks-ass.net>
 <CAMou1-2Wgs9nvw9w8CHoacix8YSVAmuKu4MZJC=QQuCbLAx72w@mail.gmail.com>
 <20150527153914.GC3644@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150527153914.GC3644-ndre7Fmf5hadTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Robert Bragg <robert-St23OQVBDYPNLxjTenLetw@public.gmane.org>, intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, Daniel Vetter <daniel.vetter-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jani Nikula <jani.nikula-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, David Airlie <airlied-cv59FeDIM0c@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org


* Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:

> > As it is currently the kernel doesn't need to know anything about the 
> > semantics of individual counters being selected, so it's currently convenient 
> > that we can aim to maintain all the counter meta data we have in userspace 
> > according to the changing needs of tools or drivers (e.g. names, descriptions, 
> > units, max values, normalization equations), de-coupled from the kernel, 
> > instead of splitting it between the kernel and userspace.
> 
> And that fully violates the design premise of perf. The kernel should be in 
> control of resources, not userspace.
> 
> If we'd have put userspace in charge, we could now not profile the same task by 
> two (or more) different observers. But with kernel side counter management that 
> is no problem at all.

Beyond that there are a couple of other advantages of managing performance metrics 
via the kernel:

2)

Per task/workload/user separation of events, for example you can do:

	perf record make bzImage
        perf stat make bzImage

These will only profile/count in the child task hierarchy spawned by the shell. 
Multiple such sessions can be started and the perf sampling/counting of the 
separate workloads is independent of each other.

3)

Finegrained security model: you can chose which events to expose to what privilege 
levels. You can also work around hardware bugs without complicating tooling.

4)

Seemless integration of the various PMU and other event metrics with each other: 
you can start a CPU PMU event, a trace event, a software event and an uncore 
event, which all output into the same coherent, ordered ring-buffer, timestamped 
and correlated consistently, etc.

5)

The unified event model on the kernel side also brings with itself 100 KLOC of 
rich, unified tooling in tools/perf/, which tries to keep it all together and 
functional.

================

The cost of all that is having to implement kernel support for it, but once that 
initial hurdle is taken, it's well worth it! A PMU driver can be as simple as 
offering only a single system-wide counter.

Thanks,

	Ingo
