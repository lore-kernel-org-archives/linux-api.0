From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: futex(2) man page update help request
Date: Thu, 15 May 2014 06:53:38 +0200
Message-ID: <CAKgNAkjQ5Dd_U9OojXdgeforpRevvPHNFAw99kBFPCwHgf7Ggg@mail.gmail.com>
References: <537346E5.4050407@gmail.com> <CF98E3EF.90564%dvhart@linux.intel.com>
 <CAKgNAkh+PWzT2SByaLk_OtiAXeZSkWoMgu+ivDOt1dTWVtaatQ@mail.gmail.com>
 <5373D0CA.2050204@redhat.com> <alpine.DEB.2.02.1405150121230.6261@ionos.tec.linutronix.de>
Reply-To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.02.1405150121230.6261-3cz04HxQygjZikZi3RtOZ1XZhhPuCNm+@public.gmane.org>
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: Carlos O'Donell <carlos-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Darren Hart <dvhart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, Jakub Jelinek <jakub-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Davidlohr Bueso <davidlohr.bueso-VXdhtT5mjnY@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Thomas,

On Thu, May 15, 2014 at 1:34 AM, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org> wrote:
> On Wed, 14 May 2014, Carlos O'Donell wrote:
>
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
>> it was an interface we did not want to support forever with a stable ABI.
>> The futex() syscall is an implementation detail that is shared between
>> the kernel and the writers of core runtimes for Linux.
>
> Nonsense.
>
> If we change that interface (aside of adding functionality or some new
> error return) it would break the world and some more, simply because
> out of the blue glibc-2.xx would stop to work on linux-3.yy.
>
> Aside of that the futex syscall is used as a bare interface without
> any glibc interaction:
>
>  - It's handy to implement user space wait queues
>
>  - It's (ab)used in very interesting ways by data base apps
>
>  - It's (ab)used by some Java monstrosities.

Thanks for the education about user-space uses of futexes. I was unaware.

> Nothing you care about and you really don't want to see the gory
> details, but you have to accept that there is an universe which is
> happy to deal with the raw syscalls instead of going through some ill
> defined posix interfaces.

And that universe would love to have your documentation of
FUTEX_WAKE_BITSET and FUTEX_WAIT_BITSET ;-),

Cheers,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
