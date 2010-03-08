From: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [patch 050/160] prctl: add PR_SET_PROCTITLE_AREA option for
	prctl()
Date: Mon, 8 Mar 2010 13:56:15 +0100
Message-ID: <20100308125615.GB11242@redhat.com>
References: <201003052142.o25Lgbpg029522@imap1.linux-foundation.org> <alpine.LFD.2.00.1003061100170.4530@localhost.localdomain> <20100307192826.GA18616@redhat.com> <3e8340491003071224o5ea1c01cl73132e7c2cc6046f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <3e8340491003071224o5ea1c01cl73132e7c2cc6046f-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bryan Donlan <bdonlan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org, drepper-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mingo-X9Un+BFzKDI@public.gmane.org, tss-X3B1VOXEql0@public.gmane.org, xiyou.wangcong-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 03/07, Bryan Donlan wrote:
>
> On Sun, Mar 7, 2010 at 14:28, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> > On 03/06, Linus Torvalds wrote:
> >>
> >> On Fri, 5 Mar 2010, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org wrote:
> >> >
> >> > This patch makes it possible for userspace to implement setproct=
itle()
> >> > cleanly. =A0It adds a new PR_SET_PROCTITLE_AREA option for prctl=
(), which
> >> > updates task's mm_struct->arg_start and arg_end to the given are=
a.
> >>
> >> This looks overly complicated. Why do you change the whole locking=
 rules,
> >> instead of protecting _only_ the "arg_start/arg_end" case?
> >>
> >> The thing is, there's no reason to hold the mmap_sem over the whol=
e thing,
> >> and I don't think this is important enough to be a valid reason fo=
r
> >> exposing a whole new "locked" access variant, when a simple "prote=
ct just
> >> the arg_start/end" would handle it.
> >
> > It was me who suggested to re-use mm->mmap_sem instead of adding th=
e new
> > lock, but looking at this patch again I do not understand the reaso=
n this
> > lock should be held throughout in proc_pid_cmdline(). If there is n=
o such
> > a reason, then the new access_process_vm_locked (cough, also sugges=
ted by
> > me ;) is not needed.
>
> Consider:
>
> Process A is reading /proc/pidB/cmdline. As it enters
> proc_pid_cmdline, the compiler stashes mm->arg_end and mm->arg_start
> in a register or something, and then the process is preempted.
> Process B now changes the location of its cmdline buffer. After
> changing it, it free()s the buffer. Then it malloc()s a buffer for
> sensitive data. Unfortunately, this happens to be at the same address=
=2E

Indeed, I see, thanks.

Oleg.
