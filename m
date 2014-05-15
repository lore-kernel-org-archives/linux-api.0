From: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: Re: futex(2) man page update help request
Date: Wed, 14 May 2014 17:28:32 -0700
Message-ID: <53740A30.20807@zytor.com>
References: <537346E5.4050407@gmail.com>	 <CF98E3EF.90564%dvhart@linux.intel.com>	 <CAKgNAkh+PWzT2SByaLk_OtiAXeZSkWoMgu+ivDOt1dTWVtaatQ@mail.gmail.com> <1400100977.3865.30.camel@buesod1.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1400100977.3865.30.camel-5JQ4ckphU/8SZAcGdq5asR6epYMZPwEe5NbjCUgZEJk@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Davidlohr Bueso <davidlohr-VXdhtT5mjnY@public.gmane.org>, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: Darren Hart <dvhart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, Jakub Jelinek <jakub-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Davidlohr Bueso <davidlohr.bueso-VXdhtT5mjnY@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Carlos O'Donell <carlos-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 05/14/2014 01:56 PM, Davidlohr Bueso wrote:
>>
>>> However, unless I'm sorely mistaken, the larger problem is that glibc
>>> removed the futex() call entirely, so these man pages don't describe
>>
>> I don't think futex() ever was in glibc--that's by design, and
>> completely understandable: no user-space application would want to
>> directly use futex(). 
> 
> That's actually not quite true. There are plenty of software efforts out
> there that use futex calls directly to implement userspace serialization
> mechanisms as an alternative to the bulky sysv semaphores. I worked
> closely with an in-memory DB project that makes heavy use of them. Not
> everyone can simply rely on pthreads.
> 

More fundamentally, futex(2), like clone(2), are things that can be
legitimately by user space without automatically breaking all of glibc.
 There are some other things where that is *not* true, because glibc
relies on being able to mediate all accesses to a kernel facility, but
not here.

	-hpa
