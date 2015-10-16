From: Robert Bragg <robert-St23OQVBDYPNLxjTenLetw@public.gmane.org>
Subject: Re: [RFC 0/6] Non perf based Gen Graphics OA unit driver
Date: Fri, 16 Oct 2015 13:08:16 +0100
Message-ID: <CAMou1-3ezRAhOU0MC1KnQdyDsi412ooMV76jbgnv9hZ9Mz5JvA@mail.gmail.com>
References: <1443537549-6905-1-git-send-email-robert@sixbynine.org>
 <20151016094306.GA3604@twins.programming.kicks-ass.net> <20151016100228.GA22732@gmail.com>
 <20151016103345.GS3816@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151016103345.GS3816-ndre7Fmf5hadTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, Daniel Vetter <daniel.vetter-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Chris Wilson <chris-Y6uKTt2uX1cEflXRtASbqLVCufUGDwFn@public.gmane.org>, Sourab Gupta <sourab.gupta-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Zhenyu Wang <zhenyuw-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Jani Nikula <jani.nikula-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, David Airlie <airlied-cv59FeDIM0c@public.gmane.org>, Kan Liang <kan.liang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Alexander Shishkin <alexander.shishkin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Zheng Yan <zheng.z.yan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Fri, Oct 16, 2015 at 11:33 AM, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
> On Fri, Oct 16, 2015 at 12:02:28PM +0200, Ingo Molnar wrote:
>>
>> * Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
>>
>> > > - We may be making some technical compromises a.t.m for the sake of
>> > >   using perf.
>> > >
>> > >     perf_event_open() requires events to either relate to a pid or a
>> > >     specific cpu core, while our device pmu relates to neither.  Events
>> > >     opened with a pid will be automatically enabled/disabled according
>> > >     to the scheduling of that process - so not appropriate for us.
>> >
>> > Right; the traditional cpu/pid mapping doesn't work well for devices;
>> > but maybe, with some work, we can create something like that
>> > global/local render context from it; although I've no clue what form
>> > that would need at this time.
>>
>> Could someone please help with some very basic questions, such as what the
>> hardware model of the 'OA' unit model is? How are OA registers set up, how are
>> their values made accessible to the host side, etc.
>
> Robert linked to:
>
>   https://01.org/sites/default/files/documentation/observability_performance_counters_haswell.pdf
>
> In a previous posting. It has some info, but full documentation, is as
> per the initial post, 'pending'.

There is now also some Broadwell documentation here:

https://01.org/sites/default/files/documentation/intel-gfx-prm-osrc-bdw-vol14-observability.pdf

Unfortunately though a mistake was made by the documentation team when
generating the PDF which unintentionally stripped out a lot of
information so it's not very helpful a.t.m. I've let them know about
some of the issues, but I'm not sure a.t.m when it may be updated.

I tried to fill in the gaps in some of our earlier conversations, so
maybe also go over those for more details too.

Otherwise the best reference is probably my code currently, either the
RFC patches I sent most recently which at least cover up to Haswell,
or the wip/rib/oa-next branch here: https://github.com/rib/linux. The
lastest perf based driver is currently in the archive/rib/oa-core-perf
branch for reference too.

- Robert
