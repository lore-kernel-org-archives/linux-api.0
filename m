From: Namhyung Kim <namhyung-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 2/2] perf: Userspace event
Date: Fri, 26 Sep 2014 15:21:26 +0900
Message-ID: <87y4t6j40p.fsf@sejong.aot.lge.com>
References: <1411491787-25938-1-git-send-email-pawel.moll@arm.com>
	<1411491787-25938-3-git-send-email-pawel.moll@arm.com>
	<87oau5k0u9.fsf@sejong.aot.lge.com> <20140924072017.GC990@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140924072017.GC990-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> (Ingo Molnar's message of "Wed,
	24 Sep 2014 09:20:17 +0200")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <public-mingo-DgEjT+Ai2ygdnm+yROfE0A-wOFGN7rlS/M9smdsby/KFg@public.gmane.org>
Cc: Namhyung Kim <public-namhyung-DgEjT+Ai2ygdnm+yROfE0A-wOFGN7rlS/M9smdsby/KFg@public.gmane.org>, Pawel Moll <public-pawel.moll-5wv7dgnIgG8-wOFGN7rlS/M9smdsby/KFg@public.gmane.org>, Richard Cochran <public-richardcochran-Re5JQEeQqe8AvxtiuMwx3w-wOFGN7rlS/M9smdsby/KFg@public.gmane.org>, Steven Rostedt <public-rostedt-nx8X9YLhiw1AfugRpC6u6w-wOFGN7rlS/M9smdsby/KFg@public.gmane.org>, Ingo Molnar <public-mingo-H+wXaHxf7aLQT0dZR+AlfA-wOFGN7rlS/M9smdsby/KFg@public.gmane.org>, Peter Zijlstra <public-peterz-wEGCiKHe2LqWVfeAwA7xHQ-wOFGN7rlS/M9smdsby/KFg@public.gmane.org>, Paul Mackerras <public-paulus-eUNUBHrolfbYtjvyW6yDsg-wOFGN7rlS/M9smdsby/KFg@public.gmane.org>, Arnaldo Carvalho de Melo <public-acme-DgEjT+Ai2ygdnm+yROfE0A-wOFGN7rlS/M9smdsby/KFg@public.gmane.org>, John Stultz <public-john.stultz-QSEj5FYQhm4dnm+yROfE0A-wOFGN7rlS/M9smdsby/KFg@public.gmane.org>, public-linux-kernel-u79uwXL29TY76Z2rM5mHXA-wOFGN7rlS/M9smdsby/KFg@public.gmane.org, public-linux-api-u79uwXL29TY76Z2rM5mHXA-wOFGN7rlS/M9smdsby/KFg@public.gmane.org
List-Id: linux-api@vger.kernel.org



Hi Ingo,

On Wed, 24 Sep 2014 09:20:17 +0200, Ingo Molnar wrote:
> * Namhyung Kim <namhyung-DgEjT+Ai2ygdnm+yROfE0A-XMD5yJDbdMReXY1tMh2IBg@public.gmane.org> wrote:
>
>> On Tue, 23 Sep 2014 18:03:07 +0100, Pawel Moll wrote:
>> > This patch adds a new PERF_COUNT_SW_UEVENT software event
>> > and a related PERF_SAMPLE_UEVENT sample. User can now
>> > write to the the perf file descriptor, injecting such
>> > event in the perf buffer.
>> 
>> It seems the PERF_SAMPLE_UEVENT sample can be injected to any event.  So
>> why the PERF_COUNT_SW_UEVENT is needed?  At least one can use the
>> SW_DUMMY event for that purpose.
>> 
>> Also I think it'd be better to be a record type (PERF_RECORD_XXX)
>> instead of a sample flag (PERF_SAMPLE_XXX).  In perf tools, we already
>> use perf_user_event_type for synthesized userspace events.  This way it
>> can avoid unnecessary sample processing for userspace events.
>> 
>> For contents, I prefer to give complete control to users - kernel
>> doesn't need to care about it other than its size.  If one just wants to
>> use strings only, she can write them directly.  If others want to mix
>> different types of data, they might need to define a data format for
>> their use.
>
> It would also be nice to add support for this to tools/perf/ (so 
> that 'trace' displays such entries in a perf.data), with a 
> minimum testcase for 'perf test' as well.
>
> Perhaps also add a small sub-utility to inject such events from 
> the command line, such as:
>
>   trace user-event "this is a test message"
>
> ('trace' is a shortcut command for 'perf trace'.)
>
> It would have a usecase straight away: perf could be used to 
> easily trace script execution for example.

It looks like what trace-marker in ftrace does..  We might connect
output of the trace marker into a perf event somehow.

Thanks,
Namhyung


>
> For that probably another mode of user event generation would be 
> needed as well: a process that has no access to any perf fds 
> should still be able to generate user events, if the 
> profiling/tracing context has permitted that. In this case we'd 
> inject the event either into the first, or all currently active 
> events (but only once per output buffer, or so).
>
> Thanks,
>
> 	Ingo
