From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: futex(2) man page update help request
Date: Wed, 14 May 2014 13:44:46 -0700
Message-ID: <CALCETrU+DgzcjwjLUuvUrxnDDtjELOdPWXOgPFfbHiL6p-XvPA@mail.gmail.com>
References: <537346E5.4050407@gmail.com> <CF98E3EF.90564%dvhart@linux.intel.com>
 <CAKgNAkh+PWzT2SByaLk_OtiAXeZSkWoMgu+ivDOt1dTWVtaatQ@mail.gmail.com> <5373D0CA.2050204@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5373D0CA.2050204-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Carlos O'Donell <carlos-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Michael Kerrisk-manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Darren Hart <dvhart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, Jakub Jelinek <jakub-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Davidlohr Bueso <davidlohr.bueso-VXdhtT5mjnY@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, May 14, 2014 at 1:23 PM, Carlos O'Donell <carlos-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On 05/14/2014 03:03 PM, Michael Kerrisk (man-pages) wrote:
>>> However, unless I'm sorely mistaken, the larger problem is that glibc
>>> removed the futex() call entirely, so these man pages don't describe
>>
>> I don't think futex() ever was in glibc--that's by design, and
>> completely understandable: no user-space application would want to
>> directly use futex(). (BTW, I mispoke in my earlier mail when I said I
>> wanted documentation suitable for "writers of library functions" -- I
>> meant suitable for "writers of *C library*".)
>
> I fully agree with Michael here.
>
> The futex() syscall was never exposed to userspace specifically because
> it was an interface we did not want to support forever with a stable ABI.
> The futex() syscall is an implementation detail that is shared between
> the kernel and the writers of core runtimes for Linux.
>
> The fact that the futex() syscall is out of date is my fault, is the fault
> of Linux kernel developers, etc. etc., we should all have reached out to
> Michael with patches to keep this developer-centric documentation updated.

I realize that this is out of scope for linux-abi, but I *stongly*
disagree with this notion.  futex() needs to be just as stable as
anything else: old glibc versions must continue to work.  I just
jumped through a bunch of hoops to keep a single glibc patch release
in OpenSUSE 9 working in a maintainable way; breaking futex will break
far more than that.

Additionally, at least the FUTEX_WAIT and FUTEX_WAKE operations are
extremely useful, and they can do things that are tedious at best
using mutexes and condvars.  It's a simple API to use.  I use it, and
I've seen plenty of other open-source apps using the futex API
directly.

I think the best way forward might be to try to convince the glibc
maintainers to add the wrapper.

--Andy
