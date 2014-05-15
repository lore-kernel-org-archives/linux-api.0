From: Darren Hart <dvhart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: futex(2) man page update help request
Date: Thu, 15 May 2014 08:43:04 -0700
Message-ID: <CF9A2E34.90E56%dvhart@linux.intel.com>
References: <537346E5.4050407@gmail.com>
 <CF98E3EF.90564%dvhart@linux.intel.com>
 <CAKgNAkh+PWzT2SByaLk_OtiAXeZSkWoMgu+ivDOt1dTWVtaatQ@mail.gmail.com>
 <5373D0CA.2050204@redhat.com>
 <20140515081357.GC11096@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140515081357.GC11096-ndre7Fmf5hadTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Carlos O'Donell <carlos-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, Jakub Jelinek <jakub-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Davidlohr Bueso <davidlohr.bueso-VXdhtT5mjnY@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 5/15/14, 1:13, "Peter Zijlstra" <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:

>On Wed, May 14, 2014 at 04:23:38PM -0400, Carlos O'Donell wrote:
>> On 05/14/2014 03:03 PM, Michael Kerrisk (man-pages) wrote:
>> >> However, unless I'm sorely mistaken, the larger problem is that glibc
>> >> removed the futex() call entirely, so these man pages don't describe
>> > 
>> > I don't think futex() ever was in glibc--that's by design, and
>> > completely understandable: no user-space application would want to
>> > directly use futex(). (BTW, I mispoke in my earlier mail when I said I
>> > wanted documentation suitable for "writers of library functions" -- I
>> > meant suitable for "writers of *C library*".)
>> 
>> I fully agree with Michael here.
>> 
>> The futex() syscall was never exposed to userspace specifically because
>> it was an interface we did not want to support forever with a stable
>>ABI.
>> The futex() syscall is an implementation detail that is shared between
>> the kernel and the writers of core runtimes for Linux.
>
>That ship has sailed.. for one we must always support old glibc which
>uses the futex() syscall, and secondly there are known other programs
>that actually use the futex syscall.
>
>So that's really a non-argument, we're hard tied to the ABI.

Indeed. This is specifically why FUTEX_REQUEUE still exists (despite it's
bugs) when only FUTEX_CMP_REQUEUE should ever be used in new programs.


-- 
Darren Hart					Open Source Technology Center
darren.hart-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org				            Intel Corporation
