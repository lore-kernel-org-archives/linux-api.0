From: Namhyung Kim <namhyung-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 2/2] perf: Userspace event
Date: Fri, 26 Sep 2014 15:23:02 +0900
Message-ID: <87tx3uj3y1.fsf@sejong.aot.lge.com>
References: <1411491787-25938-1-git-send-email-pawel.moll@arm.com>
	<1411491787-25938-3-git-send-email-pawel.moll@arm.com>
	<87oau5k0u9.fsf@sejong.aot.lge.com> <1411649105.4768.48.camel@hornet>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1411649105.4768.48.camel@hornet> (Pawel Moll's message of "Thu,
	25 Sep 2014 13:45:05 +0100")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>
Cc: Richard Cochran <richardcochran-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "linux-kernel@vger.kernel.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-api@vger.kernel.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, 25 Sep 2014 13:45:05 +0100, Pawel Moll wrote:
> On Wed, 2014-09-24 at 07:07 +0100, Namhyung Kim wrote:
>> On Tue, 23 Sep 2014 18:03:07 +0100, Pawel Moll wrote:
>> > This patch adds a new PERF_COUNT_SW_UEVENT software event
>> > and a related PERF_SAMPLE_UEVENT sample. User can now
>> > write to the the perf file descriptor, injecting such
>> > event in the perf buffer.
>> 
>> It seems the PERF_SAMPLE_UEVENT sample can be injected to any event.  So
>> why the PERF_COUNT_SW_UEVENT is needed?  At least one can use the
>> SW_DUMMY event for that purpose.
>
> You're right. I needed a different SW type in one of my early
> prototypes, but it's not the case any more. Consider it gone.

Okay.


>
>> Also I think it'd be better to be a record type (PERF_RECORD_XXX)
>> instead of a sample flag (PERF_SAMPLE_XXX).  In perf tools, we already
>> use perf_user_event_type for synthesized userspace events.  This way it
>> can avoid unnecessary sample processing for userspace events.
>
> Fine with me. If no one objects, I'm more than happy to use
> PERF_RECORD_UEVENT = 11 for it.
>
>> For contents, I prefer to give complete control to users - kernel
>> doesn't need to care about it other than its size.  If one just wants to
>> use strings only, she can write them directly.  If others want to mix
>> different types of data, they might need to define a data format for
>> their use.
>
> Are you saying to drop even the "type 0 means zero-terminated string"
> definition, even if everything else is up to the user? I quite like that
> idea, especially combined with write()ing to the perf_fd (it is very
> much like trace_marker then, which is beautiful in its simplicity), but
> the feelings are not that strong to fight a war over it.

:)


Thanks,
Namhyung
