From: Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH v2] Documentation/arch: Add kernel feature descriptions
 and arch support status under Documentation/features/
Date: Mon, 18 May 2015 11:37:13 +1000
Message-ID: <1431913033.13218.2.camel@ellerman.id.au>
References: <20150513094622.GC11030@gmail.com>
	 <20150513094756.GD11030@gmail.com> <20150513131835.GJ1517@pd.tnic>
	 <20150513134842.GA1657@gmail.com> <20150513162757.GA21894@x>
	 <20150513150523.ddd65d7cd51f820b78f0c8e3@linux-foundation.org>
	 <20150514101518.GA27550@gmail.com> <20150514103544.GA7027@gmail.com>
	 <20150514123835.1bf436bc35d711f8dbf9bc0f@linux-foundation.org>
	 <1431644248.2981.1.camel@ellerman.id.au> <20150515074949.GB14993@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <20150515074949.GB14993@gmail.com>
Sender: linux-arch-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Josh Triplett <josh@joshtriplett.org>, Borislav Petkov <bp@alien8.de>, Jonathan Corbet <corbet@lwn.net>, Peter Zijlstra <peterz@infradead.org>, Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org, linux-arch@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Fri, 2015-05-15 at 09:49 +0200, Ingo Molnar wrote:
> * Michael Ellerman <mpe@ellerman.id.au> wrote:
> 
> > On Thu, 2015-05-14 at 12:38 -0700, Andrew Morton wrote:
> > > > Add arch support matrices for more than 40 generic kernel features
> > > > that need per architecture support.
> > > > 
> > > > Each feature has its own directory under Documentation/features/feature_name/,
> > > > and the arch-support.txt file shows its current arch porting status.
> > > 
> > > It would be nice to provide people with commit IDs to look at, but the
> > > IDs won't be known at the time the documentation file is created.  We
> > > could provide patch titles.
> > 
> > +1 on patch titles.
> 
> Ok, I'll solve this.

Thanks.

> > > But still, let's not overdo it - get something in there, see how 
> > > well it works, evolve it over time.
> > > 
> > > I don't think we've heard from any (non-x86) arch maintainers?  Do 
> > > they consider this useful at all?  Poke.
> > 
> > Yes it is. I have my own version I've cobbled together for powerpc, 
> > but this is much better.
> 
> Please double check the PowerPC support matrix for correctness (if you 
> haven't yet):

It looks good except for:

>        rwsem-optimized:  |  ok  |                              Optimized asm/rwsem.h #  arch provides optimized rwsem APIs

I don't see an rwsem.h in powerpc anywhere?


And this is correct but a bit confusing:

>          irq-time-acct:  |  ok  |                           HAVE_IRQ_TIME_ACCOUNTING #  arch supports precise IRQ time accounting

I think you and Paul agreed it's "ok" on powerpc because we have
VIRT_CPU_ACCOUNTING instead, but that's not obvious.

> > I'd like to see more description in the individual files of what the
> > feature is, and preferably some pointers to what's needed to
> > implement it.
>
> Yeah, so I tried to add a short description to the feature file 
> itself, and for many of these features that single sentence is the 
> only documentation we have in the kernel source ...

Yep, so that's better than what we had, and we can always improve it.

cheers
