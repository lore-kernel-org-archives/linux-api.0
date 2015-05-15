From: Robert Bragg <robert-St23OQVBDYPNLxjTenLetw@public.gmane.org>
Subject: Re: [RFC PATCH 00/11] drm/i915: Expose OA metrics via perf PMU
Date: Fri, 15 May 2015 02:07:29 +0100
Message-ID: <CAMou1-1Q1_kKGrRPz36Fox=gxhGF6v+DiR5HZ6TOyQyxtMsysA@mail.gmail.com>
References: <1431008154-6833-1-git-send-email-robert@sixbynine.org> <20150508162452.GR27504@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150508162452.GR27504-ndre7Fmf5hadTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, Daniel Vetter <daniel.vetter-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jani Nikula <jani.nikula-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, David Airlie <airlied-cv59FeDIM0c@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Fri, May 8, 2015 at 5:24 PM, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
> On Thu, May 07, 2015 at 03:15:43PM +0100, Robert Bragg wrote:
>
>> I've changed the uapi for configuring the i915_oa specific attributes
>> when calling perf_event_open(2) whereby instead of cramming lots of
>> bitfields into the perf_event_attr config members, I'm now
>> daisy-chaining a drm_i915_oa_event_attr_t structure off of a single
>> config member that's extensible and validated in the same way as the
>> perf_event_attr struct. I've found this much nicer to work with while
>> being neatly extensible too.
>
> This worries me a bit.. is there more background for this?

Would it maybe be helpful to see the before and after? I had kept this
uapi change in a separate patch for a while locally but in the end
decided to squash it before sending out my updated series.

Although I did find it a bit awkward with the bitfields, I was mainly
concerned about the extensibility of packing logically separate
attributes into the config members and had heard similar concerns from
a few others who had been experimenting with my patches too.

A few simple attributes I can think of a.t.m that we might want to add
in the future are:
- control of the OABUFFER size
- a way to ask the kernel to collect reports at the beginning and end
of batch buffers, in addition to periodic reports
- alternative ways to uniquely identify a context to support tools
profiling a single context not necessarily owned by the current
process

It could also be interesting to expose some counter configuration
through these attributes too. E.g. on Broadwell+ we have 14 'Flexible
EU' counters included in the OA unit reports, each with a 16bit
configuration.

In a more extreme case it might also be useful to allow userspace to
specify a complete counter config, which (depending on the
configuration) could be over 100 32bit values to select the counter
signals + configure the corresponding combining logic.

Since this pmu is in a device driver it also seemed reasonably
appropriate to de-couple it slightly from the core perf_event_attr
structure by allowing driver extensible attributes.

I wonder if it might be less worrisome if the i915_oa_copy_attr() code
were instead a re-usable utility perhaps maintained in events/core.c,
so if other pmu drivers were to follow suite there would be less risk
of a mistake being made here?

Regards,
- Robert
