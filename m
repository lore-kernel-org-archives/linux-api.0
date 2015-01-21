From: Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH v4 2/3] perf: Userspace event
Date: Wed, 21 Jan 2015 16:01:52 +0000
Message-ID: <1421856112.14076.78.camel@arm.com>
References: <1415292718-19785-1-git-send-email-pawel.moll@arm.com>
	 <1415292718-19785-3-git-send-email-pawel.moll@arm.com>
	 <20150105131237.GR30905@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150105131237.GR30905-ndre7Fmf5hadTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Richard Cochran <richardcochran-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Masami Hiramatsu <masami.hiramatsu.pt-FCd8Q96Dh0JBDgjK7y7TUQ@public.gmane.org>, Christopher Covington <cov-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Namhyung Kim <namhyung-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Ahern <dsahern-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Tomeu Vizoso <tomeu-XCtybt49RKsYaV1qd6yewg@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, 2015-01-05 at 13:12 +0000, Peter Zijlstra wrote:
> On Thu, Nov 06, 2014 at 04:51:57PM +0000, Pawel Moll wrote:
> > This patch adds a PR_TASK_PERF_UEVENT prctl call which can be used by
> > any process to inject custom data into perf data stream as a new
> > PERF_RECORD_UEVENT record, if such process is being observed or if it
> > is running on a CPU being observed by the perf framework.
> > 
> > The prctl call takes the following arguments:
> > 
> >         prctl(PR_TASK_PERF_UEVENT, type, size, data, flags);
> > 
> > - type: a number meaning to describe content of the following data.
> >   Kernel does not pay attention to it and merely passes it further in
> >   the perf data, therefore its use must be agreed between the events
> >   producer (the process being observed) and the consumer (performance
> >   analysis tool). The perf userspace tool will contain a repository of
> >   "well known" types and reference implementation of their decoders.
> > - size: Length in bytes of the data.
> > - data: Pointer to the data.
> > - flags: Reserved for future use. Always pass zero.
> > 
> > Perf context that are supposed to receive events generated with the
> > prctl above must be opened with perf_event_attr.uevent set to 1. The
> > PERF_RECORD_UEVENT records consist of a standard perf event header,
> > 32-bit type value, 32-bit data size and the data itself, followed by
> > padding to align the overall record size to 8 bytes and optional,
> > standard sample_id field.
> > 
> > Example use cases:
> > 
> > - "perf_printf" like mechanism to add logging messages to perf data;
> >   in the simplest case it can be just
> > 
> >         prctl(PR_TASK_PERF_UEVENT, 0, 8, "Message", 0);
> > 
> > - synchronisation of performance data generated in user space with the
> >   perf stream coming from the kernel. For example, the marker can be
> >   inserted by a JIT engine after it generated portion of the code, but
> >   before the code is executed for the first time, allowing the
> >   post-processor to pick the correct debugging information.
> 
> The think I remember being raised was a unified means of these msgs
> across perf/ftrace/lttng. I am not seeing that mentioned.

Right. I was considering the "well known types repository" an attempt in
this direction. Having said that - ftrace also takes a random blob as
the trace marker, so the unification has to happen in userspace anyway.
I'll have a look what LTTng has to say in this respect.

> Also, I would like a stronger rationale for the @type argument, if it
> has no actual meaning why is it separate from the binary msg data?

Valid point. Without type 0 defined as a string, it doesn't bring
anything into the equation. I just have a gut feeling that sooner than
later we will want to split the messages somehow. Maybe we should make
it a "reserved for future use, use 0 now" field?

        * struct {
        *      struct perf_event_header        header;
        *      u32                             __reserved; /* always 0 */
        *      u32                             size;
        *      char                            data[size];
        *      char                            __padding[-size & 7];
        *      struct sample_id                sample_id;
        * };

or, probably even better, make it a version value at a known offset
(currently always 1, with just size and random sized data following).

        * struct {
        *      struct perf_event_header        header;
        *      u32                             version; /* use 1 */
        *      u32                             size;
        *      char                            data[size];
        *      char                            __padding[-size & 7];
        *      struct sample_id                sample_id;
        * };

So that we can mutate the user events format without too much of the
pain - the parsers will simply complain about unknown format if such
occurs and with the size of the record in the header, it is possible to
skip it.

Pawel
