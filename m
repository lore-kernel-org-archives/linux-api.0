From: Robert Bragg <robert-St23OQVBDYPNLxjTenLetw@public.gmane.org>
Subject: [RFC PATCH 00/11] drm/i915: Expose OA metrics via perf PMU
Date: Thu,  7 May 2015 15:15:43 +0100
Message-ID: <1431008154-6833-1-git-send-email-robert@sixbynine.org>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org
Cc: Daniel Vetter <daniel.vetter-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jani Nikula <jani.nikula-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, David Airlie <airlied-cv59FeDIM0c@public.gmane.org>, Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

This is an updated series adding support for an "i915_oa" perf PMU for
configuring the Intel Gen graphics Observability unit (Haswell only to
start with) and forwarding periodic counter reports as perf samples.

Compared to the series I sent out last year:

The driver is now hooked into context switching so we no longer require
a context to be pinned for the full lifetime of a perf event fd (when
profiling a specific context).

Not visible in the series, but I can say we've also gained some
experience from looking at enabling Broadwell within the same
architecture. There are some fiddly challenges ahead with enabling
Broadwell but I do feel comfortable that it can be supported in the same
kind of way via perf. I haven't updated my Broadwell branches for a
little while now but if anyone is interested I can share this code as a
point of reference if that's helpful.

As I've had interest from folks looking at developing tools based on
this interface to not require root, but we are following the precedent
of not exposing system wide metrics to unprivileged processes, I've
added a sysctl directly comparable to kernel.perf_event_paranoid
(dev.i915.oa_event_paranoid) that lets users optionally allow
unprivileged access to system wide gpu metrics.

This series is able to expose more than just the A (aggregating)
counters and demonstrates selecting a more counters that are useful when
benchmarking 3D render workloads. The expectation is to add further
configurations later geared towards media or gpgpu workloads for
example.

I've changed the uapi for configuring the i915_oa specific attributes
when calling perf_event_open(2) whereby instead of cramming lots of
bitfields into the perf_event_attr config members, I'm now
daisy-chaining a drm_i915_oa_event_attr_t structure off of a single
config member that's extensible and validated in the same way as the
perf_event_attr struct. I've found this much nicer to work with while
being neatly extensible too.

I've made a few more (small) changes to core perf infrastructure:

I've added a PERF_EVENT_IOC_FLUSH ioctl that can be used to explicitly
ask the driver to flush buffered samples. In our case this makes sure to
forward all reports currently in the gpu mapped, circular, oabuffer as
perf samples. This issue was discussed a bit on LKML last year and
previously I was overloading our PMU's read() hook but decided that the
cleaner approach would be to add a dedicated ioctl instead.

To allow device-driver PMUs to define their own types for records
written to the perf circular buffer I've introduced a PERF_RECORD_DEVICE
type whereby drivers can then document their own header defining a driver
specific scheme for sub-types. This is then used in the i915_oa driver
for reporting hw status conditions such as OABUFFER overruns or report
lost conditions from the hw.


For examples of using the i915_oa driver I have a branch of Mesa that
enables support for the INTEL_performance_query extension based on this:

https://github.com/rib/drm   wip/rib/oa-hsw-4.0.0
https://github.com/rib/mesa  wip/rib/oa-hsw-4.0.0

For reference I sent out a corresponding series for the Mesa work for
review yesterday:

http://lists.freedesktop.org/archives/mesa-dev/2015-May/083519.html

I also have a minimal gputop tool that can both test Mesa's
INTEL_performance_query implementation to view per-context metrics or
it can view system wide gpu metrics collected directly from perf
(gputop/gputop-perf.c would be the main code of interest):

https://github.com/rib/gputop

If it's convenient for testing, my kernel patches can also be fetched
from here:

https://github.com/rib/linux  wip/rib/oa-hsw-4.0.0

One specific patch comment:

[RFC PATCH 11/11] WIP: drm/i915: constrain unit gating while using OA

I didn't want to hold up getting feedback due to this issue that I'm
currently investigating (since the effect on the driver should be
trivial) but I've included a work-in-progress patch since it does
address a known problem with collecting reliable periodic metrics.

Besides the last patch, I feel like this series is in pretty good shape
now and by testing it with Mesa and several profiling tools as well as
starting the work to enable Broadwell I feel quite happy with our
approach of leveraging perf infrastructure.

I'd really appreciate any feedback on the core perf changes I've made,
as well as general feedback on the PMU driver itself.

Since it's been quite a long time since I last sent out patches for this
work; in case it's helpful to refer back to some of the discussion last
year:

https://lkml.org/lkml/2014/10/22/462

For anyone interested to know more details about this hardware, this PRM
is a good starting point:

https://01.org/sites/default/files/documentation/
observability_performance_counters_haswell.pdf

Kind regards,
- Robert

Robert Bragg (11):
  perf: export perf_event_overflow
  perf: Add PERF_PMU_CAP_IS_DEVICE flag
  perf: Add PERF_EVENT_IOC_FLUSH ioctl
  perf: Add a PERF_RECORD_DEVICE event type
  perf: allow drivers more control over event logging
  drm/i915: rename OACONTROL GEN7_OACONTROL
  drm/i915: Expose PMU for Observation Architecture
  drm/i915: add OA config for 3D render counters
  drm/i915: Add dev.i915.oa_event_paranoid sysctl option
  drm/i915: report OA buf overrun + report lost status
  WIP: drm/i915: constrain unit gating while using OA

 drivers/gpu/drm/i915/Makefile           |   1 +
 drivers/gpu/drm/i915/i915_cmd_parser.c  |   4 +-
 drivers/gpu/drm/i915/i915_dma.c         |   6 +
 drivers/gpu/drm/i915/i915_drv.h         |  62 +++
 drivers/gpu/drm/i915/i915_gem_context.c |  45 +-
 drivers/gpu/drm/i915/i915_oa_perf.c     | 951 ++++++++++++++++++++++++++++++++
 drivers/gpu/drm/i915/i915_reg.h         | 311 ++++++++++-
 include/linux/perf_event.h              |  15 +
 include/uapi/drm/i915_drm.h             |  58 ++
 include/uapi/linux/perf_event.h         |  14 +
 kernel/events/core.c                    |  47 +-
 kernel/events/internal.h                |   9 -
 kernel/events/ring_buffer.c             |   3 +
 13 files changed, 1498 insertions(+), 28 deletions(-)
 create mode 100644 drivers/gpu/drm/i915/i915_oa_perf.c

-- 
2.3.2
