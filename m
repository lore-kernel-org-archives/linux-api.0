From: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 2/2] perf: Userspace event
Date: Wed, 24 Sep 2014 09:20:17 +0200
Message-ID: <20140924072017.GC990@gmail.com>
References: <1411491787-25938-1-git-send-email-pawel.moll@arm.com>
 <1411491787-25938-3-git-send-email-pawel.moll@arm.com>
 <87oau5k0u9.fsf@sejong.aot.lge.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <87oau5k0u9.fsf-vfBCOVm4yAnB69T4xOojN9BPR1lH4CV8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Namhyung Kim <namhyung-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Richard Cochran <richardcochran-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org


* Namhyung Kim <namhyung-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:

> On Tue, 23 Sep 2014 18:03:07 +0100, Pawel Moll wrote:
> > This patch adds a new PERF_COUNT_SW_UEVENT software event
> > and a related PERF_SAMPLE_UEVENT sample. User can now
> > write to the the perf file descriptor, injecting such
> > event in the perf buffer.
> 
> It seems the PERF_SAMPLE_UEVENT sample can be injected to any event.  So
> why the PERF_COUNT_SW_UEVENT is needed?  At least one can use the
> SW_DUMMY event for that purpose.
> 
> Also I think it'd be better to be a record type (PERF_RECORD_XXX)
> instead of a sample flag (PERF_SAMPLE_XXX).  In perf tools, we already
> use perf_user_event_type for synthesized userspace events.  This way it
> can avoid unnecessary sample processing for userspace events.
> 
> For contents, I prefer to give complete control to users - kernel
> doesn't need to care about it other than its size.  If one just wants to
> use strings only, she can write them directly.  If others want to mix
> different types of data, they might need to define a data format for
> their use.

It would also be nice to add support for this to tools/perf/ (so 
that 'trace' displays such entries in a perf.data), with a 
minimum testcase for 'perf test' as well.

Perhaps also add a small sub-utility to inject such events from 
the command line, such as:

  trace user-event "this is a test message"

('trace' is a shortcut command for 'perf trace'.)

It would have a usecase straight away: perf could be used to 
easily trace script execution for example.

For that probably another mode of user event generation would be 
needed as well: a process that has no access to any perf fds 
should still be able to generate user events, if the 
profiling/tracing context has permitted that. In this case we'd 
inject the event either into the first, or all currently active 
events (but only once per output buffer, or so).

Thanks,

	Ingo
