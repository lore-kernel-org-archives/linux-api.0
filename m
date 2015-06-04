From: Robert Bragg <robert-St23OQVBDYPNLxjTenLetw@public.gmane.org>
Subject: Re: [Intel-gfx] [RFC PATCH 00/11] drm/i915: Expose OA metrics via
 perf PMU
Date: Thu, 4 Jun 2015 19:53:19 +0100
Message-ID: <CAMou1-1QQ0_04Q=J=D=NuNyFbpmJX=aDs0NUtjG42MDxFbG+jw@mail.gmail.com>
References: <1431008154-6833-1-git-send-email-robert@sixbynine.org>
 <20150508162452.GR27504@twins.programming.kicks-ass.net> <CAMou1-1Q1_kKGrRPz36Fox=gxhGF6v+DiR5HZ6TOyQyxtMsysA@mail.gmail.com>
 <20150519145337.GD3644@twins.programming.kicks-ass.net> <CAMou1-2Wgs9nvw9w8CHoacix8YSVAmuKu4MZJC=QQuCbLAx72w@mail.gmail.com>
 <20150527153914.GC3644@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150527153914.GC3644-ndre7Fmf5hadTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, Daniel Vetter <daniel.vetter-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jani Nikula <jani.nikula-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, David Airlie <airlied-cv59FeDIM0c@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, May 27, 2015 at 4:39 PM, <> wrote:
> On Thu, May 21, 2015 at 12:17:48AM +0100, Robert Bragg wrote:
>> >
>> > So for me the 'natural' way to represent this in perf would be thr=
ough
>> > event groups. Create a perf event for every single event -- yes th=
is is
>> > 53 events.
>>
>> So when I was first looking at this work I had considered the
>> possibility of separate events, and these are some of the things tha=
t
>> in the end made me forward the hardware's raw report data via a sing=
le
>> event instead...
>>
>> There are 100s of possible B counters depending on the MUX
>> configuration + fixed-function logic in addition to the A counters.
>
> There's only 8 B counters, what there is 100s of is configurations, a=
nd
> that's no different from any other PMU. There's 100s of events to sel=
ect
> on the CPU side as well - yet only 4 (general purpose) counters (8 if
> you disable HT on recent machines) per CPU.

To clarify one thing here; In the PRM you'll see a reference to
'Reserved' slots in the report layouts and these effectively
correspond to a further 8 configurable counters. These further
counters get referred to as 'C' counters for 'custom' and similar to
the B counters they are defined based on the MUX configuration except
they skip the boolean logic pipeline.

Thanks for the comparison with the CPU.

My main thought here is to beware of considering these configurable
counters as 'general purpose' if that might also imply orthogonality.
All our configurable counters build on top of a common/shared MUX
configuration so I'd tend to think of them more like a 'general
purpose counter set'.

>
> Of course, you could create more than 8 events at any one time, and t=
hen
> perf will round-robin the configuration for you.

This hardware really isn't designed to allow round-robin
reconfiguration. If we change the metric set then we will loose the
aggregate value of our B counters. Besides writing the large MUX
config + boolean logic state we would also need to save the current
aggregated counter values only maintained by the OA unit so they could
be restored later as well as any internal state that's simply not
accessible to us. If we reconfigure to try and round-robin between
sets of counters each reconfiguration will trash state that we have no
way of restoring. The counters have to no longer be in use if there's
no going back once we reconfigure.

>
>> A
>> choice would need to be made about whether to expose events for the
>> configurable counters that aren't inherently associated with any
>> semantics, or instead defining events for counters with specific
>> semantics (with 100s of possible counters to define). The later woul=
d
>> seem more complex for userspace and the kernel if they both now have
>> to understand the constraints on what counters can be used together.
>
> Again, no different from existing PMUs. The most 'interesting' part o=
f
> any PMU driver is event scheduling.
>
> The explicit design of perf was to put event scheduling _in_ the kern=
el
> and not allow userspace direct access to the hardware (as previous PM=
U
> models did).

I'm thinking your 'event scheduling' here refers to the kernel being
able to handle multiple concurrent users of the same pmu, but then we
may be talking cross purposes...

I was describing how (if we exposed events for counters with well
defined semantics - as opposed to just 16 events for the B/C counters)
the driver would need to do some kind of matching based on the events
added to a group to deduce which MUX configuration should be used and
saying that in this case userspace would need to be very aware of
which events belong to a specific MUX configuration.

I don't think we have the hardware flexibility to support scheduling
in terms of multiple concurrent users, unless they happen to want
exactly the same configuration.

I also don't think we have a use case for accessing gpu metrics where
concurrent access is really important. It's possible to think of cases
where it might be nice, except they are unlikely to involve the same
configuration so given the current OA unit design I haven't had plans
to try and support concurrent access and haven't had any requests for
it so far.

>
>> I
>> guess with either approach we would also need to have some form of
>> dedicated group leader event accepting attributes for configuring th=
e
>> state that affects the group as a whole, such as the counter
>> configuration (3D vs GPGPU vs media etc).
>
> That depends a bit on how flexible you want to switch between these
> modes; with the cost being in the 100s of MMIO register writes, it mi=
ght
> just not make sense to make this too dynamic.
>
> An option might be to select the mode through the PMU driver's sysfs
> files. Another option might be to expose the B counters 3 times and h=
ave
> each set be mutually exclusive. That is, as soon as you've created a =
3D
> event, you can no longer create GPGPU/Media events.

Hmm, interesting idea to have global/pmu state be controlled via sysfs.=
=2E.

I suppose the security model doesn't seem as clear, with sysfs access
gated by file permissions while we want to gate some control based on
whether you have access to a gpu context. The risk of multiple users
looking to open a group of events and first setting a global mode via
sysfs seems like it could also silently misconfigure your events with
the wrong mode. Maybe it could become immutable once one event is
opened and you could double check afterwards.

Besides the mode/MUX config choice, other state that is shared by the
group includes:
- single context vs system wide profiling
- the timer exponent

Using sysfs I think we'd have to be careful to not expose
configuration options that relate to the security policy if there's a
risk of a non-privileged process affecting it.

>
>> I'm not sure where we would
>> handle the context-id + drm file descriptor attributes for initiatin=
g
>> single context profiling but guess we'd need to authenticate each
>> individual event open.
>
> Event open is a slow path, so that should not be a problem, right?

Yeah I don't think I'd be concerned about duplicating the checks
per-event from a performance pov.

I'm more concerned about differentiating security checks that relate
to the final configuration as a whole vs individual events. In this
case we use a drm file descriptor + context handle to allow profiling
a single gpu context that the current process has access to, but the
choice of profiling a single context or across all contexts affects
the final hardware configuration too which relates to the group. Even
if a process has the privileges to additionally open an event for
system wide metrics, this choice is part of the OA unit configuration
and incompatible with single-context filtering. For reference, on
Haswell the reports don't include a context identifier which makes it
difficult to try and emulate a single-context filtering event with a
system wide hardware configuration.

I can see that we'd be able to cross-check event compatibility for
each addition to the group but I also can't help but see this as an
example of how tightly coupled the configuration of these counters
are.

>
>> It's not clear if we'd configure the report
>> layout via the group leader, or try to automatically choose the most
>> compact format based on the group members. I'm not sure how pmus
>> currently handle the opening of enabled events on an enabled group b=
ut
>
> With the PERF_FORMAT_GROUP layout changing in-flight. I would recomme=
nd
> not doing that -- decoding the output will be 'interesting' but not
> impossible.

Right, I wouldn't want to have to handle such corner cases so I think
I'd want to be able to report an error back to userspace attempting to
extend a group that's ever been activated.

>
>> I think there would need to be limitations in our case that new
>> members can't result in a reconfigure of the counters if that might
>> loose the current counter values known to userspace.
>
> I'm not entirely sure what you mean here.

This is referring to the issue of us not being able to explicitly save
and restore the state of the OA unit to be able to allow reconfiguring
the counters while they are in use.

The counter values for B/C counters are only maintained by the OA unit
and in the case of B counters which supports e.g. referencing delayed
values, there is state held in the unit that we have no way to
explicitly access and save.

>
>> From a user's pov, there's no real freedom to mix and match which
>> counters are configured together, and there's only some limited
>> ability to ignore some of the currently selected counters by not
>> including them in reports.
>
> It is 'impossible' to create a group that is not programmable. That i=
s,
> the pmu::event_init() call _should_ verify that the addition of the
> event to the group (as given by event->group_leader) is valid.
>
>> Something to understand here is that we have to work with sets of
>> pre-defined MUX + fixed-function logic configurations that have been
>> validated to give useful metrics for specific use cases, such as
>> benchmarking 3D rendering, GPGPU or media workloads.
>
> This is fine; as stated above. Since these are limited pieces of
> 'firmware' which are expensive to load, you don't have to do a fully
> dynamic solution here.
>
>> As it is currently the kernel doesn't need to know anything about th=
e
>> semantics of individual counters being selected, so it's currently
>> convenient that we can aim to maintain all the counter meta data we
>> have in userspace according to the changing needs of tools or driver=
s
>> (e.g. names, descriptions, units, max values, normalization
>> equations), de-coupled from the kernel, instead of splitting it
>> between the kernel and userspace.
>
> And that fully violates the design premise of perf. The kernel should=
 be
> in control of resources, not userspace.

This isn't referring to programmable resources though; it's only
talking about where the higher-level meta data about these counters is
maintained, including names and descriptions detailing the specific
counter semantics as well as a description of the
equations/expressions that should be used to normalize these counters
to be useful to users.

This seems very comparable to other PMUs that expose _RAW, hardware
specific data via samples that rely on a userspace library like
libpfm4 to understand.

I see different tools have slightly different needs and may want to
normalize some counters differently. This data is still evolving over
time, and overall feel it's going to be more practical/maintainable
for us to try and keep this semantic data consolidated to userspace.

=46or reference; what I'm really referring to here is an established XM=
L
description of OA counters maintained and validated by engineers
closely involved with the hardware. I think it makes sense for us to
factor into this trade-off the benefit we get from being able to
easily leverage this data but considering the relative lack of
stability of this data makes me prefer to limit ourselves to just
putting the MUX and boolean logic configurations in the kernel.

>
> If we'd have put userspace in charge, we could now not profile the sa=
me
> task by two (or more) different observers. But with kernel side count=
er
> management that is no problem at all.

Sorry, I think my comment must have come across wrong because I wasn't
talking about a choice that affects who's responsible for configuring
the counters or supporting multiple observers or not.

I was talking about a trade-off for where we maintain the higher level
information about the counters that can be exposed, especially the
code for normalizing individual counters.

>
>> A benefit of being able to change the report size is to reduce memor=
y
>> bandwidth usage that can skew measurements. It's possible to request
>> the gpu to write out periodic snapshots at a very high frequency (we
>> can program a period as low as 160 nanoseconds) and higher frequenci=
es
>> can start to expose some interesting details about how the gpu is
>> utilized - though with notable observer effects too. How careful we
>> are to not waste bandwidth is expected to determine what sampling
>> resolutions we can achieve before significantly impacting what we ar=
e
>> measuring.
>>
>> Splitting the counters up looked like it could increase the bandwidt=
h
>> we use quite a bit. The main difference comes from requiring 64bit
>> values instead of the 32bit values in our raw reports. This can be
>> offset partly since there are quite a few 'reserved'/redundant A
>> counters that don't need forwarding. As an example in the most extre=
me
>> case, instead of an 8 byte perf_event_header + 4byte raw_size + 256
>> byte reports + 4 byte padding every 160ns ~=3D 1.5GB/s, we might hav=
e 33
>> A counters (ignoring redundant ones) + 16 configurable counters =3D =
400
>
> In that PDF there's only 8 configurable 'B' counters.

Sorry that it's another example of being incomplete. The current
document only says enough about B counters to show how to access the
gpu clock that is required to normalise many of the A counters. There
are also the 8 C counters I mentioned earlier derived from the MUX
configuration but without the boolean logic.

>
>> byte struct read_format (using PERF_FORMAT_GROUP) + 8 byte
>> perf_event_header every 160ns ~=3D 2.4GB/s. On the other hand though=
 we
>> could choose to forward only 2 or 3 counters of interest at these hi=
gh
>> frequencies which isn't possible currently.
>
> Right; although you'd have to spend some cpu cycles on the format shi=
ft.
> Which might make it moot again. That said; I would really prefer we
> start out with trying to make the generic format stuff work before
> trying to come up with special case hacks.
>
>> > Use the MMIO reads for the regular read() interface, and use a hrt=
imer
>> > placing MI_REPORT_PERF_COUNT commands, with a counter select mask
>> > covering the all events in the current group, for sampling.
>>
>> Unfortunately due to the mmio limitations and the need to relate
>> counters I can't imagine many use cases for directly accessing the
>> counters individually via the read() interface.
>
> Fair enough.
>
>> MI_REPORT_PERF_COUNT commands are really only intended for collectin=
g
>> reports in sync with a command stream. We are experimenting currentl=
y
>> with an extension of my PMU driver that emits MI_REPORT_PERF_COUNT
>> commands automatically around the batches of commands submitted by
>> userspace so we can do a better job of filtering metrics across many
>> gpu contexts, but for now the expectation is that the kernel shouldn=
't
>> be emitting MI_REPORT_PERF_COUNT commands. We emit
>> MI_REPORT_PERF_COUNT commands within Mesa for example to implement t=
he
>> GL_INTEL_performance_query extension, at the start and end of a quer=
y
>> around a sequence of commands that the application is interested in
>> measuring.
>
> I will try and read up on the GL_INTEL_performance_query thing.

You can see my code for this here, in case that's helpful:
https://github.com/rib/mesa/tree/wip/rib/oa-hsw-4.0.0

You might also be interested in my more recent 'codegen' branch too
(work in progress though):
https://github.com/rib/mesa/tree/wip/rib/oa-hsw-codegen

Here you can see an example of the meta data I mentioned earlier, e.g.
describing the equations for normalizing the counters for one metrics
set:

https://github.com/rib/mesa/blob/wip/rib/oa-hsw-codegen/src/mesa/driver=
s/dri/i965/brw_oa_hsw.xml

This set corresponds to the "3D" metric set enabled in the i915_oa pmu
driver.

More example data can also be seen in my gputop tool, with 'render
basic', 'compute basic', 'compute extended', 'memory reads', 'memory
writes' and 'sampler balance' metric sets:

https://github.com/rib/gputop/blob/641d7644df64a871f36f3c283cfa18a2f153=
0813/gputop/oa-hsw.xml

>
>> > You can use the perf_event_attr::config to select the counter (A0-=
A44,
>> > B0-B7) and use perf_event_attr::config1 (low and high dword) for t=
he
>> > corresponding CEC registers.
>> >
>>
>> Hopefully covered above, but since the fixed-function state is so
>> dependent on the MUX configuration I think it currently makes sense =
to
>> treat the MUX plus logic state (including the CEC state) a tightly
>> coupled unit.
>
> Oh wait, the A counters are also affected by the MUX programming!
> That wasn't clear to me before this.

Er actually you were right before, the raw A counters aren't directly
affected by the MUX configuration. In this paragraph 'fixed-function
state' was referring to the boolean logic state for B counters in case
that was unclear and the CEC ('custom event counter') registers are a
part of that boolean logic state.

That said though, the raw A counters aren't really /useful/ without
the MUX programming because most of them are so closely related to the
gpu clock (which we access via a B or C counter) that we have to
program the MUX before we can normalize the A counters to be
meaningful to users.

>
> Same difference though; you could still do either the sysfs aided fli=
ps
> or the mutually exclusive counter types to deal with this; all still
> assuming reprogramming all that is 'expensive'.
>
>> The Flexible EU Counters for Broadwell+ could be more amenable to th=
is
>> kind of independent configuration, as I don't believe they are
>> dependant on the MUX configuration.
>
> That sounds good :-)
>
>> One idea that's come up a lot though is having the possibility of
>> being able to configure an event with a full MUX + fixed-function
>> state description.
>
> Right; seeing how there's only a very limited number of these MUX
> programs validated (3D, GPGPU, Media, any others?) this should be
> doable. And as mentioned before, you could disable the other types on=
ce
> you create one in order to limit the reprogramming thing.

Here I meant being able to support userspace supplying a full MUX
configuration and boolean logic configuration (i.e. large arrays of
data), for userspace tools being able to experiment with new
configurations during the early stages of building and validating
these configurations - so mostly interesting to the engineers
responsible for defining and testing these configurations in the first
place since it means they can share experimental configurations with
tools with the caveat that you'd likely need root privileges to use
the interface. It's appealing to have a low barrier for enabling
people to test new configurations without the need for users to build
a custom kernel.

I'm not worried about supporting this in the short term, but it's
still a usecase that could be helpful to support eventually, that I
want to keep in mind at least.

About the number of different configurations, I've been using 3D,
gpgpu and media as summary examples, but there are quite a few
configurations really...

On Haswell these are names of some of the sets I'm aware of...
Render Metrics Basic Gen7.5
Compute Metrics Basic Gen7.5
Compute Metrics Extended Gen7.5
Render Metrics Slice Balance Gen7.5
Memory Reads Distribution Gen7.5
Memory Writes Distribution Gen7.5
Metric set SamplerBalance
Memory Reads on Write Port Distribution Gen7.5
Stencil PMA Hold Metrics Gen7.5
Media Memory Reads Distribution Gen7.5
Media Memory Writes Distribution Gen7.5
Media VME Pipe Gen7.5

=46or Broadwell we have more; for example...
Render Metrics Basic Gen8
Compute Metrics Basic Gen8
Render Metrics for 3D Pipeline Profile
Memory Reads Distribution Gen8
Memory Writes Distribution Gen8
Compute Metrics Extended Gen8
Compute Metrics L3 Cache Gen8
Data Port Reads Coalescing Gen8
Data Port Writes Coalescing Gen8
Metric set HDCAndSF
Metric set L3_1
Metric set L3_2
Metric set L3_3
Metric set L3_4
Metric set RasterizerAndPixelBackend
Metric set Sampler_1
Metric set Sampler_2
Metric set TDL_1
Metric set TDL_2
Stencil PMA Hold Metrics Gen8
Media Memory Reads Distribution Gen8
Media Memory Writes Distribution Gen8
Media VME Pipe Gen8
HDC URB Coalescing Metrics Gen8

I'm not sure that it will end up making sense to publish all of these,
depending on what kind of testing these have been through to validate
that they give helpful data, and on the other hand these are evolving
and there may be more over time, but hopefully it at least gives a
ballpark idea of the number of configurations that could be
interesting to enable between Haswell and Broadwell.

>
>> >
>> > This does not require random per driver ABI extentions for
>> > perf_event_attr, nor your custom output format.
>> >
>> > Am I missing something obvious here?
>>
>> Definitely nothing 'obvious' since the current documentation is
>> notably incomplete a.t.m, but I don't think we were on the same page
>> about how the hardware works and our use cases.
>>
>> Hopefully some of my above comments help clarify some details.
>
> Yes, thanks!
>

Ok, I think there are some clarifications on the nature of our OA
hardware that we're drilling into here that might also help explain
more of the trade-offs that were considered regarding forwarding raw
OA hardware reports.

I wonder if it could be good for us to take a little bit of a step
back here just to re-consider the implications of enabling a pmu that
really doesn't relate to the cpu or tasks running on cpus - since I
think this is the first example of that, and it's also had a bearing
on how we currently forward samples via perf.

I think the basic implications to consider are that for our use cases
we wouldn't expect to be requesting cpu centric info in samples, such
as _IP, _CALLCHAIN, _CPU, _BRANCH_STACK and_REGS/STACK_USER and that
we wouldn't open events for specific pids/tasks.

I don't think we'd expect to use existing userspace tools with this
pmu, such as perf, and instead:

- We're accessing perf from within OpenGL for implementing a
performance query extension that applications/games/tools can then use
to get metrics for a single gpu context owned by OpenGL.
- We're creating new tools that are geared for viewing gpu metrics,
including gputop and grafips

I have a feeling that Ingo and yourself may currently be thinking of
the OA unit like an uncore pmu with the idea that tools like perf
should Just Work=E2=84=A2 with OA counters, while I don't think that's =
going
to be the case.

Even so, I still feel that we benefit from being able to leverage the
perf infrastructure to support our use cases and even though perf is
currently quite cpu centric I've been happy that it's turned out to be
a good fit for exposing device metrics too and ignoring/bypassing some
of cpu specific bits for our needs has been straight forward.

I don't bring this up as a tangent to the question of having one
raw-report event vs multiple single counter events, but rather to
highlight that our gpu focused use cases might be a bit different to
what you're used to and I hope our tooling and OpenGL work can inform
this discussion too; representing the practical ends that we're most
eager to support.

Regards,
- Robert
