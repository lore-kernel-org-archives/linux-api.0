From: "Carlos O'Donell" <carlos-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: futex(2) man page update help request
Date: Wed, 14 May 2014 16:23:38 -0400
Message-ID: <5373D0CA.2050204@redhat.com>
References: <537346E5.4050407@gmail.com> <CF98E3EF.90564%dvhart@linux.intel.com> <CAKgNAkh+PWzT2SByaLk_OtiAXeZSkWoMgu+ivDOt1dTWVtaatQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKgNAkh+PWzT2SByaLk_OtiAXeZSkWoMgu+ivDOt1dTWVtaatQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Darren Hart <dvhart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, Jakub Jelinek <jakub-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Davidlohr Bueso <davidlohr.bueso-VXdhtT5mjnY@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 05/14/2014 03:03 PM, Michael Kerrisk (man-pages) wrote:
>> However, unless I'm sorely mistaken, the larger problem is that glibc
>> removed the futex() call entirely, so these man pages don't describe
> 
> I don't think futex() ever was in glibc--that's by design, and
> completely understandable: no user-space application would want to
> directly use futex(). (BTW, I mispoke in my earlier mail when I said I
> wanted documentation suitable for "writers of library functions" -- I
> meant suitable for "writers of *C library*".)

I fully agree with Michael here.

The futex() syscall was never exposed to userspace specifically because
it was an interface we did not want to support forever with a stable ABI.
The futex() syscall is an implementation detail that is shared between
the kernel and the writers of core runtimes for Linux.

The fact that the futex() syscall is out of date is my fault, is the fault
of Linux kernel developers, etc. etc., we should all have reached out to
Michael with patches to keep this developer-centric documentation updated.
 
>> something users even have access to anymore. I had to revert to calling
>> the syscalls directly in the futextest test suite because of this:
>>
>> http://git.kernel.org/cgit/linux/kernel/git/dvhart/futextest.git/tree/inclu
>> de/futextest.h#n67
>>
>>
>> Which basically defines:
>>
>> #define futex(uaddr, op, val, timeout, uaddr2, val3, opflags) \
>>         syscall(SYS_futex, uaddr, op | opflags, val, timeout, uaddr2, val3)
>>
>>
>> Adding Carlos for his perspective.
>>
>> If I'm wrong, or we can restore the futex() call, great. If not... Should
>> we keep the man-pages and document it as syscall(SYS_futex, ..., op, ...) ?
> 
> We should keep the man page ;-). I just need to add some words to
> point out the use of syscall(). Mostly though, I'm interested in
> getting documentation of the operations listed below :-).

Agreed. The man page should get expanded and should be as detailed as possible
about the interface the kernel is exposing.

There are other syscalls like gettid() that have a:
NOTE: There is no glibc wrapper for this system call; see NOTES.

That's what should happen here with futex() (though NOTES does mention this,
but it's not called out at the top of the man page).

Cheers,
Carlos.
--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
