From: "Carlos O'Donell" <carlos-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: futex(2) man page update help request
Date: Thu, 15 May 2014 10:39:09 -0400
Message-ID: <5374D18D.6020608@redhat.com>
References: <537346E5.4050407@gmail.com> <CF98E3EF.90564%dvhart@linux.intel.com> <CAKgNAkh+PWzT2SByaLk_OtiAXeZSkWoMgu+ivDOt1dTWVtaatQ@mail.gmail.com> <5373D0CA.2050204@redhat.com> <20140515081444.GD11096@twins.programming.kicks-ass.net> <5374BE9E.8080408@redhat.com> <20140515132235.GM30445@twins.programming.kicks-ass.net> <CAKgNAkjrS8WWMoQzsiOkMVn1_Bf06uFCL6ECU7z=mv0fszg+gQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKgNAkjrS8WWMoQzsiOkMVn1_Bf06uFCL6ECU7z=mv0fszg+gQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Darren Hart <dvhart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, Jakub Jelinek <jakub-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Davidlohr Bueso <davidlohr.bueso-VXdhtT5mjnY@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 05/15/2014 09:49 AM, Michael Kerrisk (man-pages) wrote:
> On Thu, May 15, 2014 at 3:22 PM, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
>> On Thu, May 15, 2014 at 09:18:22AM -0400, Carlos O'Donell wrote:
>>> On 05/15/2014 04:14 AM, Peter Zijlstra wrote:
>>>> On Wed, May 14, 2014 at 04:23:38PM -0400, Carlos O'Donell wrote:
>>>>> There are other syscalls like gettid() that have a:
>>>>> NOTE: There is no glibc wrapper for this system call; see NOTES.
>>>>
>>>> Yes, can we finally fix that please? It gets tedious having to endlessly
>>>> copy/paste that thing around.
>>>
>>> What exactly would you like fixed?
>>
>> Not having gettid() in glibc.
> 
> Get in the line ;-).
> http://sourceware.org/bugzilla/show_bug.cgi?id=6399

I have no objections to this, but I absolutely object to this without
someone documenting and gathering consensus for consistent terminology
to be used between the kernel and glibc.

The relevant comment is here:
https://sourceware.org/bugzilla/show_bug.cgi?id=6399#c26

I'd like to see a glibc manual patch for the threads.texi file, which
can be completely linux-specific, to document gettid() and nomenclature.
It should talk about the nomenclature used to discuss these interfaces
and explain when it is or isn't valid to use a task id and with what 
functions.

For example does gettid *really* return a pid_t as considered by
userspace? It's not a full out process...

Cheers,
Carlos.
