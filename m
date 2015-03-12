From: Mikael Pettersson <mikpelinux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] Don't allow blocking of signals using sigreturn.
Date: Thu, 12 Mar 2015 08:22:18 +0100
Message-ID: <21761.16042.371226.277890@gargle.gargle.HOWL>
References: <20150311174204.GA5712@pc.thejh.net>
	<21760.46870.338764.599348@gargle.gargle.HOWL>
	<CALCETrXy=ftik5U7nD9D+u8z-jLBOG_xX20QTDoP-CkV3=U2Vg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALCETrXy=ftik5U7nD9D+u8z-jLBOG_xX20QTDoP-CkV3=U2Vg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Mikael Pettersson <mikpelinux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jann Horn <jann-XZ1E9jl8jIdeoWH0uzbU5w@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel@vger.kernel.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jeff Dike <jdike-OPE4K8JWMJJBDgjK7y7TUQ@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Andy Lutomirski writes:
 > On Wed, Mar 11, 2015 at 2:43 PM, Mikael Pettersson <mikpelinux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
 > > Jann Horn writes:
 > >  > Or should I throw this patch away and write a patch
 > >  > for the prctl() manpage instead that documents that
 > >  > being able to call sigreturn() implies being able to
 > >  > effectively call sigprocmask(), at least on some
 > >  > architectures like X86?
 > >
 > > Well, that is the semantics of sigreturn().  It is essentially
 > > setcontext() [which includes the actions of sigprocmask()], but
 > > with restrictions on parameter placement (at least on x86).
 > >
 > > You could introduce some setting to restrict that aspect for
 > > seccomp processes, but you can't change this for normal processes
 > > without breaking things.
 > 
 > Which leads to the interesting question: does anyone ever call
 > sigreturn with a different signal mask than the kernel put there
 > during signal delivery

Yes.  Either a sigfillset();sigdelset(SIGSEGV), or a copy of the
thread's sigmask from a previous sigframe.

 > or, even more strangely, with a totally made up
 > context?

Not "totally made up", but certainly with adjustments(*) made to
both GPRs and PC.  In a different piece of SW: FPU controls.

(*) Rolling back or force-committing a micro-transaction until
PC+GPRs represent the state at an original instruction boundary.
This was in a product using dynamic binary instrumentation.
