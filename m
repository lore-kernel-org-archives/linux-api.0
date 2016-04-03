From: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: Re: [PATCH] x86: Add a turbo mode sysctl
Date: Sun, 3 Apr 2016 11:55:34 +0200 (CEST)
Message-ID: <alpine.DEB.2.11.1604031151040.3978@nanos>
References: <cd6157244ae75145e2529a1d73f6174cd829ac9c.1459525715.git.luto@kernel.org> <alpine.DEB.2.11.1604011803390.3978@nanos> <CALCETrUfy-yZ6FD7J3AwhP7KB5eZ+YRMrKS_CyNDLvJwmiC49g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALCETrUfy-yZ6FD7J3AwhP7KB5eZ+YRMrKS_CyNDLvJwmiC49g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Sat, 2 Apr 2016, Andy Lutomirski wrote:
> On Fri, Apr 1, 2016 at 9:10 AM, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org> wrote:
> >> +     if (turbo_mode)
> >> +             write_cr0(cr0 & ~X86_CR0_CD);
> >> +     else
> >> +             write_cr0(cr0 | X86_CR0_CD);
> >
> > I think proper turbo mode disable requires ~(X86_CR0_CD | X86_CR0_NW)
> 
> I thought that made no difference on family 6 and P4 and was actively
> dangerous (disabled coherency) before.  At least, that's what the
> table of caching modes and the footnote seems to say.

CD=0 and NW=1 result in #GP, which might be your intent as that is definitely
the slowest mode you can achieve. But you should add a comment at least.

> I think we should merge this patch and add a special-case so that
> calling unlink on turbo_mode sets it to zero.  Then people who rm -rf
> / will brick their systems more slowly :)

While at it can you please make a turbo = 0 call when we hit a WARN/BUG/Panic
so the messages spill slower over the screen?

Thanks,

	tglx
