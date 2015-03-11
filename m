From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCH] Don't allow blocking of signals using sigreturn.
Date: Wed, 11 Mar 2015 15:26:13 -0700
Message-ID: <CALCETrXy=ftik5U7nD9D+u8z-jLBOG_xX20QTDoP-CkV3=U2Vg@mail.gmail.com>
References: <20150311174204.GA5712@pc.thejh.net> <21760.46870.338764.599348@gargle.gargle.HOWL>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <21760.46870.338764.599348-4mDQ13Tdud8Jw5R7aSpS0dP8p4LwMBBS@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mikael Pettersson <mikpelinux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Jann Horn <jann-XZ1E9jl8jIdeoWH0uzbU5w@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jeff Dike <jdike-OPE4K8JWMJJBDgjK7y7TUQ@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Mar 11, 2015 at 2:43 PM, Mikael Pettersson <mikpelinux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Jann Horn writes:
>  > Or should I throw this patch away and write a patch
>  > for the prctl() manpage instead that documents that
>  > being able to call sigreturn() implies being able to
>  > effectively call sigprocmask(), at least on some
>  > architectures like X86?
>
> Well, that is the semantics of sigreturn().  It is essentially
> setcontext() [which includes the actions of sigprocmask()], but
> with restrictions on parameter placement (at least on x86).
>
> You could introduce some setting to restrict that aspect for
> seccomp processes, but you can't change this for normal processes
> without breaking things.

Which leads to the interesting question: does anyone ever call
sigreturn with a different signal mask than the kernel put there
during signal delivery or, even more strangely, with a totally made up
context?  I suspect that the former does happen, even if the latter
may be rare or completely implausible.

I certainly have code that modifies GPRs in the context prior to sigreturn.

--Andy

-- 
Andy Lutomirski
AMA Capital Management, LLC
