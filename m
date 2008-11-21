From: Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>
Subject: Re: [patch 05/35] reintroduce accept4
Date: Fri, 21 Nov 2008 08:20:55 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0811210819070.12975@anakin>
References: <200811192336.mAJNaE3R030021@imap1.linux-foundation.org>
 <Pine.LNX.4.64.0811202259360.12975@anakin>
 <alpine.LFD.2.00.0811201412040.21698@nehalem.linux-foundation.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.LFD.2.00.0811201412040.21698-nfNrOhbfy2R17+2ddN/4kux8cNe9sq/dYPYVAmT7z5s@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, drepper-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, 20 Nov 2008, Linus Torvalds wrote:
> On Thu, 20 Nov 2008, Geert Uytterhoeven wrote:
> > On Wed, 19 Nov 2008, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org wrote:
> > > From: Ulrich Drepper <drepper-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > > 
> > > Introduce a new accept4() system call.  The addition of this system call
> > 
> > > /* test_accept4.c
> > 
> > > #ifdef __x86_64__
> > > #define SYS_accept4 288
> > > #elif __i386__
> >         ^^^^^^^^
> > 	defined(__i386__)
> > 
> > > #define USE_SOCKETCALL 1
> > > #define SYS_ACCEPT4 18
> > > #else
> > > #error "Sorry -- don't know the syscall # on this architecture"
> > > #endif
> > 
> > Anyway, it's just a test program. Succeeded on m68k using socketcall.
> 
> It _should_ work even without the 'defined()'. Didn't it?

Yes it worked.

> Unknown symbols should expand to '0' in preprocessor value evaluation. Of 
> course, the compiler may warn about the practice, but it shouldn't be 
> technically wrong.

gcc 4.4 complains:
http://www.cyrius.com/journal/gcc/gcc-4.4-preprocessor-errors

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
