From: Davidlohr Bueso <davidlohr-VXdhtT5mjnY@public.gmane.org>
Subject: Re: futex(2) man page update help request
Date: Wed, 14 May 2014 14:05:22 -0700
Message-ID: <1400101522.6897.1.camel@buesod1.americas.hpqcorp.net>
References: <537346E5.4050407@gmail.com>
	 <CF98E3EF.90564%dvhart@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CF98E3EF.90564%dvhart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Darren Hart <dvhart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, Jakub Jelinek <jakub-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Davidlohr Bueso <davidlohr.bueso-VXdhtT5mjnY@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Carlos O'Donell <carlos-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, 2014-05-14 at 09:18 -0700, Darren Hart wrote:
> On 5/14/14, 3:35, "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> wrote:
> 
> >[So, some futex recent discussions remind me I should make this request]
> >
> >Hello all (especially those in the To:, namely Thomas, Darren, Ingo,
> >Jakub),
> >
> >The futex man pages:
> >http://man7.org/linux/man-pages/man2/futex.2.html
> >http://man7.org/linux/man-pages/man7/futex.7.html
> >are currently in a sorry state. I'm by no means convinced that all of the
> >futex operations described there are explained fully and correctly. And
> >probably not all error cases for each operation are properly documented.
> >I'd be very happy if some folk could review those pages and send me
> >corrections (Git: 
> >http://git.kernel.org/pub/scm/docs/man-pages/man-pages).
> >
> >But worse, a number of futex operations remain undocumented in futex(2)
> >(see the list below).
> >
> >I am aware of Documentation/pi-futex.txt and
> >Documentation/futex-requeue-pi.txt. However, both of those documents
> >are rather thin on details / explain what certain FUTEX_* operations are
> >used for rather than what they do / focus on the implementation, rather
> >than the semantics.
> >
> >What I would like is that the futex(2) page documenta each one of
> >these operations with a focus on the semantics in a way that might be
> >useful to writers of library functions or those who simply wish to
> >better understand (from a user-space perspective) what futexes are
> >and how they are used. However, I don't have the knowledge to do
> >this well in any reasonable time.
> >
> >Would the folk in the To: list (or anyone else who is knowledgeable)
> >be willing to write patches
> >(Git: http://git.kernel.org/pub/scm/docs/man-pages/man-pages )
> >or just supply me with some raw text that documents these currently
> >undocumented futex operations, in the manner suggested?
> 
> Yes, I'll be glad to help.
> 
> However, unless I'm sorely mistaken, the larger problem is that glibc
> removed the futex() call entirely, so these man pages don't describe
> something users even have access to anymore. I had to revert to calling
> the syscalls directly in the futextest test suite because of this:
> 
> http://git.kernel.org/cgit/linux/kernel/git/dvhart/futextest.git/tree/inclu
> de/futextest.h#n67
> 
> 
> Which basically defines:
> 
> #define futex(uaddr, op, val, timeout, uaddr2, val3, opflags) \
>         syscall(SYS_futex, uaddr, op | opflags, val, timeout, uaddr2, val3)

Yeah, and I actually stole that from you for perf :)

> 
> Adding Carlos for his perspective.
> 
> If I'm wrong, or we can restore the futex() call, great. If not... Should
> we keep the man-pages and document it as syscall(SYS_futex, ..., op, ...) ?

+1, is there anything preventing adding a futex wrapper... glibc folks?

--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
