From: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Subject: Re: [PATCH v2] Documentation/arch: Add kernel feature descriptions
 and arch support status under Documentation/features/
Date: Tue, 19 May 2015 12:02:11 +1000
Message-ID: <1432000931.8339.2.camel@ellerman.id.au>
References: <20150513131835.GJ1517@pd.tnic>
	 <20150513134842.GA1657@gmail.com> <20150513162757.GA21894@x>
	 <20150513150523.ddd65d7cd51f820b78f0c8e3@linux-foundation.org>
	 <20150514101518.GA27550@gmail.com> <20150514103544.GA7027@gmail.com>
	 <20150514123835.1bf436bc35d711f8dbf9bc0f@linux-foundation.org>
	 <1431644248.2981.1.camel@ellerman.id.au> <20150515074949.GB14993@gmail.com>
	 <1431913033.13218.2.camel@ellerman.id.au>
	 <20150518085423.GA24944@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150518085423.GA24944-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, 2015-05-18 at 10:54 +0200, Ingo Molnar wrote:
> * Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org> wrote:
> 
> > > > Yes it is. I have my own version I've cobbled together for 
> > > > powerpc, but this is much better.
> > > 
> > > Please double check the PowerPC support matrix for correctness (if 
> > > you haven't yet):
> > 
> > It looks good except for:
> > 
> > >        rwsem-optimized:  |  ok  |                              Optimized asm/rwsem.h #  arch provides optimized rwsem APIs
> > 
> > I don't see an rwsem.h in powerpc anywhere?
> 
> Indeed, that slipped through. I fixed it to:
> 
>     triton:~/tip> cat Documentation/features/locking/rwsem-optimized/arch-support.txt 
>     #
>     # Feature name:          rwsem-optimized
>     #         Kconfig:       Optimized asm/rwsem.h
>     #         description:   arch provides optimized rwsem APIs
>     #
>         |     powerpc: | TODO |
> 
>     triton:~/tip> cat Documentation/features/time/irq-time-acct/arch-support.txt
>     #
>     # Feature name:          irq-time-acct
>     #         Kconfig:       HAVE_IRQ_TIME_ACCOUNTING
>     #         description:   arch supports precise IRQ time accounting
>     #
>         |     powerpc: |  ..  |
> 
> i.e. it's not marked as TODO, but not as supported either which would 
> be misleading.

Great thanks.

cheers
