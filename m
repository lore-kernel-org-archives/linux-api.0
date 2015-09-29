From: Robert Bragg <robert-St23OQVBDYPNLxjTenLetw@public.gmane.org>
Subject: [RFC 0/6] Non perf based Gen Graphics OA unit driver
Date: Tue, 29 Sep 2015 15:39:03 +0100
Message-ID: <1443537549-6905-1-git-send-email-robert@sixbynine.org>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org
Cc: Daniel Vetter <daniel.vetter-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Chris Wilson <chris-Y6uKTt2uX1cEflXRtASbqLVCufUGDwFn@public.gmane.org>, Sourab Gupta <sourab.gupta-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Zhenyu Wang <zhenyuw-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Jani Nikula <jani.nikula-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, David Airlie <airlied-cv59FeDIM0c@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kan Liang <kan.liang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Alexander Shishkin <alexander.shishkin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Zheng Yan <zheng.z.yan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

After some recent progress enabling the Observation Architecture unit
for Gen8+, we can hopefully paint a fairly complete picture of the
requirements for supporting the unit from Haswell to Skylake and so
I'm looking again at the challenges in upstreaming this work.

Considering this, it looked like it could be worthwhile experimenting
with a non-perf based driver for the OA unit and I'm hoping to explain
why and how it went as well as request some feedback on whether we
should aim to move forward without perf.

Besides the patches forwarded here, a branch can be found for reference
here:

  https://github.com/rib/linux - wip/rib/oa-without-perf branch

I created corresponding branches for Mesa and GPU Top to test this here
(same branch names):

  https://github.com/rib/mesa
  https://github.com/rib/gputop

Here I've only included the patches up to an initial Haswell driver,
although the wip/rib/oa-without-perf branch on github includes support
for Gen8+. Please let me know if it would be helpful to forward more.

At this point I have two drivers at feature parity; one based on perf,
one not. Technically they're very similar and the patches are split to
hopefully be quite comparable. My latest perf-based work is under
wip/rib/oa-next branches in the above repos.


So, these are the concerns I have a.t.m about upstreaming this work:
   

- We're bridging two complex architectures

    To review this work I think it will be relevant to have a good
    general familiarity with Gen graphics (e.g. thinking about the OA
    unit's interaction with the command streamer and execlist
    scheduling) as well as our userspace architecture and how we're
    consuming OA data within Mesa to implement the
    INTEL_performance_query extension.
    
    On the flip side here, its necessary to understand the perf
    userspace interface (for most this is hidden by tools so the details
    aren't common knowledge) as well as the internal design, considering
    that the PMU we're looking at seems to break several current design
    assumptions. I can only claim a limited familiarity with perf's
    design, just as a result of this work.


- Limited documentation for the OA unit:

    Not unique to the OA unit but I think having a driver that extends
    outside of the graphics stack, into the core perf infrastructure
    probably requires more comprehensive HW + graphics stack
    documentation for non drm/i915 developers.  Earlier RFC discussions
    were hampered somewhat by limited documentation.  Improved
    documentation is always desirable, but of course it can also take a
    significant amount of time and effort while some key aspects
    (notably the PRMs) aren't directly under my control.
 

- The current OA PMU driver breaks some significant design assumptions.

    Existing perf pmus are used for profiling work on a cpu and we're
    introducing the idea of _IS_DEVICE pmus with different security
    implications, the need to fake cpu-related data (such as user/kernel
    registers) to fit with perf's current design, and adding _DEVICE
    records as a way to forward device-specific status records.

    The OA unit writes reports of counters into a circular buffer,
    without involvement from the CPU, making our PMU driver the first of
    a kind.
    
    Given the way we periodically forward data from the OA buffer to
    perf's buffer, these bursts of sample writes look to perf like we're
    sampling too fast and so it throttles us.

    Perf supports groups of counters and allows those to be read via
    transactions internally but transactions currently seem designed to
    be explicitly initiated from the cpu (say in response to a userspace
    read()) and while we could pull a report out of the OA buffer we
    can't trigger a report from the cpu on demand.
    
    Related to being report based; the OA counters are configured in HW
    as a set while perf generally expects counter configurations to be
    orthogonal. Although counters can be associated with a group leader
    as they are opened, there's no clear precedent for being able to
    provide group-wide configuration attributes and no obvious solution
    as yet that's expected to be acceptable to upstream and meets our
    userspace needs. We currently avoid using perf's grouping feature
    and forward OA reports to userspace via perf's 'raw' sample field.
    This suits our userspace well considering how coupled the counters
    are when dealing with normalizing. It would be inconvenient to split
    counters up into separate events, only to require userspace to
    recombine them. For Mesa it's also convenient to be forwarded raw,
    periodic reports for combining with the raw reports it captures
    using MI_REPORT_PERF_COUNT commands.

    Related to counter orthogonality; we can't time share the OA unit,
    while event scheduling is a central design idea within perf for
    allowing userspace to open + enable more events than can be
    configured in HW at any one time. The OA unit is not designed to
    allow re-configuration while in use. We can't reconfigure the OA
    unit without loosing internal OA unit state which we can't access
    explicitly to save and restore. Reconfiguring the OA unit is also
    relatively slow, involving ~100 register writes. From userspace Mesa
    also depends on a stable OA configuration when emitting
    MI_REPORT_PERF_COUNT commands and importantly the OA unit can't be
    disabled while there are outstanding MI_RPC commands lest we hang
    the command streamer.


- We may be making some technical compromises a.t.m for the sake of
  using perf.

    perf_event_open() requires events to either relate to a pid or a
    specific cpu core, while our device pmu relates to neither.  Events
    opened with a pid will be automatically enabled/disabled according
    to the scheduling of that process - so not appropriate for us. When
    an event is related to a cpu id, perf ensures pmu methods will be
    invoked via an inter process interrupt on that core. To avoid
    invasive changes our userspace opens OA perf events for a specific
    cpu. This is workable but it means the majority of the OA driver now
    runs in atomic context, including all OA report forwarding, which
    isn't really necessary in our case and seems to make our locking
    requirements somewhat complex as we handle the interaction with the
    rest of the i915 driver.


- I'm not confident our use case benefits much from building on perf:

    We aren't using existing perf based tooling with our PMU. Existing
    tools typically assume you're profiling work running on a cpu, e.g.
    expecting samples to be associated with instruction pointers and
    user/kernel registers and aiming to represent metrics in relation
    to application source code. We're forwarding fake register values
    and userspace needs needs to know how to decode the raw OA reports
    before anything can be reported to a user.
    
    With the buffering done by the OA unit I don't think we currently
    benefit from perf's mmapped circular buffer interface. We already
    have a decoupled producer and consumer and since we have to copy out
    of the OA buffer, it would work well for us to hide that copy in
    a simpler read() based interface.


- Logistically it might be more practical to contain this to the
  graphics stack.

    It seems fair to consider that if we can't see a very compelling
    benefit to building on perf, then containing this work to
    drivers/gpu/drm/i915 may simplify the review process as well as
    future maintenance and development.



About the initial non-perf driver:

Structurally it's very similar to the perf based implementation. The
userspace interface is inspired by perf and adds a
DRM_IOCTL_I915_PERF_OPEN ioctl that's conceptually comparable to
perf_event_open() returning an fd that userspace can poll() and read()
samples from. The fds also supports I915_PERF_IOCTL_ENABLE/DISABLE
ioctls much like perf.

When opening an event; users specify an event type (enum based a.t.m
like perf's built in event types) and a pointer to an event-specific
attributes structure which is extensible in the same way as struct
i915_perf_event_attr. Metrics can optionally be opened for a specific
GPU context (comparable to passing a pid to perf_event_open()) and the
contents of samples can be controlled via a sample_flags member as with
perf.

Userspace collects samples via read() which writes (only complete)
records to the user's given buffer. Records have a type + size
header equivalent to struct i915_perf_event_header.

Updating Mesa and GPU Top to experiment with this was straightforward
given the similarity to the perf interface.  The main difference is that
it only supports forwarding metrics via read()s instead of an mmaped
circular buffer. As mentioned above, I think that suits this well, and
requires no additional copying of data. I think the userspace code has
ended up being a little simpler too.

Overall the driver currently isn't much more code than with perf (~200
lines).

Personally my gut feeling a.t.m, is that we should aim to move forward
independent from perf.

I'd really appreciate some feedback from others on this though.

Daniel and Chris; although I think it made sense at the outset to try
and use perf, in light of the above would you be open to a non-perf
based driver for the OA unit?

Peter; I wonder if you would tend to agree too that it could make sense
for us to go with our own interface here?


Kind Regards,
Robert

Robert Bragg (6):
  drm/i915: Add i915 perf infrastructure
  drm/i915: rename OACONTROL GEN7_OACONTROL
  drm/i915: Add static '3D' Haswell OA unit config
  drm/i915: Add i915 perf event for Haswell OA unit
  drm/i915: Add dev.i915.perf_event_paranoid sysctl option
  drm/i915: add oa_event_min_timer_exponent sysctl

 drivers/gpu/drm/i915/Makefile           |    4 +
 drivers/gpu/drm/i915/i915_cmd_parser.c  |    4 +-
 drivers/gpu/drm/i915/i915_dma.c         |    7 +
 drivers/gpu/drm/i915/i915_drv.h         |  136 ++++
 drivers/gpu/drm/i915/i915_gem_context.c |   23 +-
 drivers/gpu/drm/i915/i915_oa_hsw.c      |   98 +++
 drivers/gpu/drm/i915/i915_oa_hsw.h      |   36 +
 drivers/gpu/drm/i915/i915_perf.c        | 1201 +++++++++++++++++++++++++++++++
 drivers/gpu/drm/i915/i915_reg.h         |  340 ++++++++-
 include/uapi/drm/i915_drm.h             |  125 ++++
 10 files changed, 1967 insertions(+), 7 deletions(-)
 create mode 100644 drivers/gpu/drm/i915/i915_oa_hsw.c
 create mode 100644 drivers/gpu/drm/i915/i915_oa_hsw.h
 create mode 100644 drivers/gpu/drm/i915/i915_perf.c

-- 
2.5.2
