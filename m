From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [RFC PATCH 00/11] drm/i915: Expose OA metrics via perf PMU
Date: Fri, 8 May 2015 18:24:52 +0200
Message-ID: <20150508162452.GR27504@twins.programming.kicks-ass.net>
References: <1431008154-6833-1-git-send-email-robert@sixbynine.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1431008154-6833-1-git-send-email-robert-St23OQVBDYPNLxjTenLetw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Robert Bragg <robert-St23OQVBDYPNLxjTenLetw@public.gmane.org>
Cc: intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, Daniel Vetter <daniel.vetter-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jani Nikula <jani.nikula-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, David Airlie <airlied-cv59FeDIM0c@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, May 07, 2015 at 03:15:43PM +0100, Robert Bragg wrote:

> I've changed the uapi for configuring the i915_oa specific attributes
> when calling perf_event_open(2) whereby instead of cramming lots of
> bitfields into the perf_event_attr config members, I'm now
> daisy-chaining a drm_i915_oa_event_attr_t structure off of a single
> config member that's extensible and validated in the same way as the
> perf_event_attr struct. I've found this much nicer to work with while
> being neatly extensible too.

This worries me a bit.. is there more background for this?
