From: Pawel Moll <pawel.moll@arm.com>
Subject: Re: [PATCH v2 2/2] perf: Userspace event
Date: Thu, 25 Sep 2014 13:45:05 +0100
Message-ID: <1411649105.4768.48.camel@hornet>
References: <1411491787-25938-1-git-send-email-pawel.moll@arm.com>
	 <1411491787-25938-3-git-send-email-pawel.moll@arm.com>
	 <87oau5k0u9.fsf@sejong.aot.lge.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87oau5k0u9.fsf@sejong.aot.lge.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Namhyung Kim <namhyung@kernel.org>
Cc: Richard Cochran <richardcochran@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Paul Mackerras <paulus@samba.org>, Arnaldo Carvalho de Melo <acme@kernel.org>, John Stultz <john.stultz@linaro.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Wed, 2014-09-24 at 07:07 +0100, Namhyung Kim wrote:
> On Tue, 23 Sep 2014 18:03:07 +0100, Pawel Moll wrote:
> > This patch adds a new PERF_COUNT_SW_UEVENT software event
> > and a related PERF_SAMPLE_UEVENT sample. User can now
> > write to the the perf file descriptor, injecting such
> > event in the perf buffer.
> 
> It seems the PERF_SAMPLE_UEVENT sample can be injected to any event.  So
> why the PERF_COUNT_SW_UEVENT is needed?  At least one can use the
> SW_DUMMY event for that purpose.

You're right. I needed a different SW type in one of my early
prototypes, but it's not the case any more. Consider it gone.

> Also I think it'd be better to be a record type (PERF_RECORD_XXX)
> instead of a sample flag (PERF_SAMPLE_XXX).  In perf tools, we already
> use perf_user_event_type for synthesized userspace events.  This way it
> can avoid unnecessary sample processing for userspace events.

Fine with me. If no one objects, I'm more than happy to use
PERF_RECORD_UEVENT = 11 for it.

> For contents, I prefer to give complete control to users - kernel
> doesn't need to care about it other than its size.  If one just wants to
> use strings only, she can write them directly.  If others want to mix
> different types of data, they might need to define a data format for
> their use.

Are you saying to drop even the "type 0 means zero-terminated string"
definition, even if everything else is up to the user? I quite like that
idea, especially combined with write()ing to the perf_fd (it is very
much like trace_marker then, which is beautiful in its simplicity), but
the feelings are not that strong to fight a war over it.

Pawel
