From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: futex(2) man page update help request
Date: Thu, 15 May 2014 06:49:43 +0200
Message-ID: <53744767.8090307@gmail.com>
References: <537346E5.4050407@gmail.com> <CF98E3EF.90564%dvhart@linux.intel.com> <CAKgNAkh+PWzT2SByaLk_OtiAXeZSkWoMgu+ivDOt1dTWVtaatQ@mail.gmail.com> <5373D0CA.2050204@redhat.com> <alpine.DEB.2.02.1405150121230.6261@ionos.tec.linutronix.de> <537430B5.2060001@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <537430B5.2060001-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Carlos O'Donell <carlos-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Darren Hart <dvhart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, Jakub Jelinek <jakub-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Davidlohr Bueso <davidlohr.bueso-VXdhtT5mjnY@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 05/15/2014 05:12 AM, Carlos O'Donell wrote:
> On 05/14/2014 07:34 PM, Thomas Gleixner wrote:
>> On Wed, 14 May 2014, Carlos O'Donell wrote:
>>
>>> On 05/14/2014 03:03 PM, Michael Kerrisk (man-pages) wrote:
>>>>> However, unless I'm sorely mistaken, the larger problem is that glibc
>>>>> removed the futex() call entirely, so these man pages don't describe
>>>>
>>>> I don't think futex() ever was in glibc--that's by design, and
>>>> completely understandable: no user-space application would want to
>>>> directly use futex(). (BTW, I mispoke in my earlier mail when I said I
>>>> wanted documentation suitable for "writers of library functions" -- I
>>>> meant suitable for "writers of *C library*".)
>>>
>>> I fully agree with Michael here.
>>>
>>> The futex() syscall was never exposed to userspace specifically because
>>> it was an interface we did not want to support forever with a stable ABI.
>>> The futex() syscall is an implementation detail that is shared between
>>> the kernel and the writers of core runtimes for Linux.
>>
>> Nonsense. 
> 
> What is nonsense?

I suspect there's a misunderstanding between worlds here. Thomas means
that the kernel ABI is stable. You mean, glibc does not want to have to
export an ABI that you have to support.

> I do not want to be responsible for the futex API by having glibc provide
> wrappers. That can't be nonsense since it's a glibc community decision to
> make.

See my above.

Cheers,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
