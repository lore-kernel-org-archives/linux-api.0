From: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2] Documentation/arch: Add kernel feature descriptions
 and arch support status under Documentation/features/
Date: Mon, 18 May 2015 10:54:23 +0200
Message-ID: <20150518085423.GA24944@gmail.com>
References: <20150513131835.GJ1517@pd.tnic>
 <20150513134842.GA1657@gmail.com>
 <20150513162757.GA21894@x>
 <20150513150523.ddd65d7cd51f820b78f0c8e3@linux-foundation.org>
 <20150514101518.GA27550@gmail.com>
 <20150514103544.GA7027@gmail.com>
 <20150514123835.1bf436bc35d711f8dbf9bc0f@linux-foundation.org>
 <1431644248.2981.1.camel@ellerman.id.au>
 <20150515074949.GB14993@gmail.com>
 <1431913033.13218.2.camel@ellerman.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1431913033.13218.2.camel-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org


* Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org> wrote:

> > > Yes it is. I have my own version I've cobbled together for 
> > > powerpc, but this is much better.
> > 
> > Please double check the PowerPC support matrix for correctness (if 
> > you haven't yet):
> 
> It looks good except for:
> 
> >        rwsem-optimized:  |  ok  |                              Optimized asm/rwsem.h #  arch provides optimized rwsem APIs
> 
> I don't see an rwsem.h in powerpc anywhere?

Indeed, that slipped through. I fixed it to:

    triton:~/tip> cat Documentation/features/locking/rwsem-optimized/arch-support.txt 
    #
    # Feature name:          rwsem-optimized
    #         Kconfig:       Optimized asm/rwsem.h
    #         description:   arch provides optimized rwsem APIs
    #
        -----------------------
        |         arch |status|
        -----------------------
        |       alpha: |  ok  |
        |         arc: | TODO |
        |         arm: | TODO |
        |       arm64: | TODO |
        |       avr32: | TODO |
        |    blackfin: | TODO |
        |         c6x: | TODO |
        |        cris: | TODO |
        |         frv: | TODO |
        |     hexagon: | TODO |
        |        ia64: |  ok  |
        |        m32r: | TODO |
        |        m68k: | TODO |
        |       metag: | TODO |
        |  microblaze: | TODO |
        |        mips: | TODO |
        |     mn10300: | TODO |
        |       nios2: | TODO |
        |    openrisc: | TODO |
        |      parisc: | TODO |
        |     powerpc: | TODO |
        |        s390: |  ok  |
        |       score: | TODO |
        |          sh: |  ok  |
        |       sparc: |  ok  |
        |        tile: | TODO |
        |          um: | TODO |
        |   unicore32: | TODO |
        |         x86: |  ok  |
        |      xtensa: |  ok  |
        -----------------------

> And this is correct but a bit confusing:
> 
> >          irq-time-acct:  |  ok  |                           HAVE_IRQ_TIME_ACCOUNTING #  arch supports precise IRQ time accounting
> 
> I think you and Paul agreed it's "ok" on powerpc because we have
> VIRT_CPU_ACCOUNTING instead, but that's not obvious.

Ok, so I modified it to print '..' instead:

    triton:~/tip> cat Documentation/features/time/irq-time-acct/arch-support.txt
    #
    # Feature name:          irq-time-acct
    #         Kconfig:       HAVE_IRQ_TIME_ACCOUNTING
    #         description:   arch supports precise IRQ time accounting
    #
        -----------------------
        |         arch |status|
        -----------------------
        |       alpha: |  ..  |
        |         arc: | TODO |
        |         arm: |  ok  |
        |       arm64: |  ..  |
        |       avr32: | TODO |
        |    blackfin: | TODO |
        |         c6x: | TODO |
        |        cris: | TODO |
        |         frv: | TODO |
        |     hexagon: | TODO |
        |        ia64: |  ..  |
        |        m32r: | TODO |
        |        m68k: | TODO |
        |       metag: | TODO |
        |  microblaze: | TODO |
        |        mips: |  ok  |
        |     mn10300: | TODO |
        |       nios2: | TODO |
        |    openrisc: | TODO |
        |      parisc: |  ..  |
        |     powerpc: |  ..  |
        |        s390: |  ..  |
        |       score: | TODO |
        |          sh: | TODO |
        |       sparc: |  ..  |
        |        tile: |  ..  |
        |          um: | TODO |
        |   unicore32: | TODO |
        |         x86: |  ok  |
        |      xtensa: |  ok  |
        -----------------------

i.e. it's not marked as TODO, but not as supported either which would 
be misleading.

Thanks,

	Ingo
