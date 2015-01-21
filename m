From: John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v4 3/3] perf: Sample additional clock value
Date: Wed, 21 Jan 2015 09:44:37 -0800
Message-ID: <CALAqxLV6ggCO81ntWuYuDjrqNeMePkZBpq92G9-iwMHm7ONuFg@mail.gmail.com>
References: <1415292718-19785-1-git-send-email-pawel.moll@arm.com>
	<1415292718-19785-4-git-send-email-pawel.moll@arm.com>
	<20150105134514.GS30905@twins.programming.kicks-ass.net>
	<1421860365.14076.91.camel@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1421860365.14076.91.camel-5wv7dgnIgG8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Richard Cochran <richardcochran-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Masami Hiramatsu <masami.hiramatsu.pt-FCd8Q96Dh0JBDgjK7y7TUQ@public.gmane.org>, Christopher Covington <cov-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Namhyung Kim <namhyung-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Ahern <dsahern-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Tomeu Vizoso <tomeu-XCtybt49RKsYaV1qd6yewg@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Jan 21, 2015 at 9:12 AM, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org> wrote:
> On Mon, 2015-01-05 at 13:45 +0000, Peter Zijlstra wrote:
>> On Thu, Nov 06, 2014 at 04:51:58PM +0000, Pawel Moll wrote:
>> > Currently three clocks are implemented: CLOCK_REALITME = 0,
>> > CLOCK_MONOTONIC = 1 and CLOCK_MONOTONIC_RAW = 2. The clock field is
>> > 5 bits wide to allow for future extension to custom, non-POSIX clock
>> > sources(MAX_CLOCK for those is 16, see include/uapi/linux/time.h) like
>> > ARM CoreSight (hardware trace) timestamp generator.
>>
>> > @@ -304,7 +305,16 @@ struct perf_event_attr {
>> >                             mmap2          :  1, /* include mmap with inode data     */
>> >                             comm_exec      :  1, /* flag comm events that are due to an exec */
>> >                             uevents        :  1, /* allow uevents into the buffer */
>> > -                           __reserved_1   : 38;
>> > +
>> > +                           /*
>> > +                            * clock: one of the POSIX clock IDs:
>> > +                            *
>> > +                            * 0 - CLOCK_REALTIME
>> > +                            * 1 - CLOCK_MONOTONIC
>> > +                            * 4 - CLOCK_MONOTONIC_RAW
>> > +                            */
>> > +                           clock          :  5, /* clock type */
>> > +                           __reserved_1   : 33;
>> >
>> >     union {
>> >             __u32           wakeup_events;    /* wakeup every n events */
>>
>> This would put a constraint on actually changing MAX_CLOCKS, are the
>> time people OK with that? Thomas, John?
>
> I admit I have some doubts about it myself. But I don't think we can
> afford full int for the clock id, can we?
>
>> I'm also not quite sure of using the >MAX_CLOCKS space for 'special'
>> clocks, preferably those would register themselves with the POSIX clock
>> interface.
>
> That may be a hard sell - John never was particularly keen on extending
> the hard-coded clocks with random sources. And the hardware trace clock
> I had on mind would be probably one of them - its meaning depends a lot
> on the . Of course I'm looking forward to being surprised :-)

Yea. I'm definitely still wanting to be cautious about adding new
clockids. Basically if there's a new well defined time domain, then
I'm open to it,  (for example, I'm expecting there will be a smeared
leapsecond time domain at some point in the future), but we've already
grown more then I'm comfortable with given the existing MAX_CLOCKS
limit.

For example, I regret adding the _ALARM clockids. Those are basically
duplicative time domains from the readers perspective, and only have
unique value for setting timers, which should have been handled via a
flag to the timer interfaces.

I suspect we'll have to bump MAX_CLOCKS that at some point and hope it
doesn't break anyone.

That said, there is the dynamic posix clockids. I'm not sure if it
would make sense, but even if we don't bump MAX_CLOCKS, might there
be some case where someone wants to use a dynamic posix clock for the
perf reference?

thanks
-john
