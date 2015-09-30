From: Chris Wilson <chris-Y6uKTt2uX1cEflXRtASbqLVCufUGDwFn@public.gmane.org>
Subject: Re: [RFC 0/6] Non perf based Gen Graphics OA unit driver
Date: Wed, 30 Sep 2015 09:30:27 +0100
Message-ID: <20150930083027.GF9929@nuc-i3427.alporthouse.com>
References: <1443537549-6905-1-git-send-email-robert@sixbynine.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1443537549-6905-1-git-send-email-robert-St23OQVBDYPNLxjTenLetw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Robert Bragg <robert-St23OQVBDYPNLxjTenLetw@public.gmane.org>
Cc: intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, Daniel Vetter <daniel.vetter-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sourab Gupta <sourab.gupta-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Zhenyu Wang <zhenyuw-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Jani Nikula <jani.nikula-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, David Airlie <airlied-cv59FeDIM0c@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kan Liang <kan.liang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Alexander Shishkin <alexander.shishkin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Zheng Yan <zheng.z.yan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, Sep 29, 2015 at 03:39:03PM +0100, Robert Bragg wrote:
> Updating Mesa and GPU Top to experiment with this was straightforward
> given the similarity to the perf interface.  The main difference is that
> it only supports forwarding metrics via read()s instead of an mmaped
> circular buffer. As mentioned above, I think that suits this well, and
> requires no additional copying of data. I think the userspace code has
> ended up being a little simpler too.

Did you try updating the existing perf based overlay?

> Overall the driver currently isn't much more code than with perf (~200
> lines).
> 
> Personally my gut feeling a.t.m, is that we should aim to move forward
> independent from perf.
> 
> I'd really appreciate some feedback from others on this though.
> 
> Daniel and Chris; although I think it made sense at the outset to try
> and use perf, in light of the above would you be open to a non-perf
> based driver for the OA unit?

No. I strongly dislike that they will be multiple incompatibile perf
interfaces and strongly like the coupling with other profiling that
comes with perf - i.e. we very much want to simultaneously sample CPU
and GPU workloads along with other devices, that information is much
more useful to me for the purposes of scheduling work and maximising
concurrency than optimising shaders.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
