From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [patch 05/35] reintroduce accept4
Date: Thu, 20 Nov 2008 23:00:54 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0811202259360.12975@anakin>
References: <200811192336.mAJNaE3R030021@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <200811192336.mAJNaE3R030021@imap1.linux-foundation.org>
Sender: linux-arch-owner@vger.kernel.org
To: akpm@linux-foundation.org
Cc: torvalds@linux-foundation.org, drepper@redhat.com, linux-api@vger.kernel.org, linux-arch@vger.kernel.org, mtk.manpages@gmail.com
List-Id: linux-api@vger.kernel.org

On Wed, 19 Nov 2008, akpm@linux-foundation.org wrote:
> From: Ulrich Drepper <drepper@redhat.com>
> 
> Introduce a new accept4() system call.  The addition of this system call

> /* test_accept4.c

> #ifdef __x86_64__
> #define SYS_accept4 288
> #elif __i386__
        ^^^^^^^^
	defined(__i386__)

> #define USE_SOCKETCALL 1
> #define SYS_ACCEPT4 18
> #else
> #error "Sorry -- don't know the syscall # on this architecture"
> #endif

Anyway, it's just a test program. Succeeded on m68k using socketcall.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
