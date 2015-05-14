From: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH v6] Documentation/arch: Add
 Documentation/arch-features.txt
Date: Thu, 14 May 2015 12:02:29 +0200
Message-ID: <20150514100229.GA24432@gmail.com>
References: <20150512144910.0b49c9a7a13336773449db33@linux-foundation.org>
 <20150513083441.GA17336@gmail.com>
 <20150513085636.GA11030@gmail.com>
 <20150513092421.GB11030@gmail.com>
 <20150513094622.GC11030@gmail.com>
 <20150513094756.GD11030@gmail.com>
 <20150513131835.GJ1517@pd.tnic>
 <20150513134842.GA1657@gmail.com>
 <20150513162757.GA21894@x>
 <20150513150523.ddd65d7cd51f820b78f0c8e3@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150513150523.ddd65d7cd51f820b78f0c8e3-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org


* Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:

> On Wed, 13 May 2015 09:27:57 -0700 Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org> wrote:
> 
> > If we can't generate this, then the ASCII-art style and right-aligned
> > feature names seems *really* likely to produce spurious conflicts,
> > especially when adding a feature to the list.  Even though it would
> > produce a much longer file, would you consider dropping the tables and
> > just having a section per feature?
> 
> me2.  The patch conflicts are going to be pretty bad.
> 
> I'd also prefer a format which allows us to add useful notes - it's 
> a bit hostile to say "thou shalt implement X" without providing any 
> info about how to do so.  Where do we tell maintainers that there's 
> a handy test app in tools/testing/selftests which they should use?
> 
> This way, I can bug patch submitters with "hey, you forgot to update 
> Documentation/arch-features.txt" and they will add useful info while 
> it's all still hot in their minds.

Ok, agreed, I've solved these problems by creating a per feature 
broken out directory hieararchy, see my next patch submission.

> And there's a ton of stuff which can go in here, much of it not
> immediately apparent.

Yes.

> Just grepping 9 months worth of the stuff I've handled, I'm seeing
> things like
> 
> HAVE_ARCH_KASAN

Ok, added.

> __HAVE_ARCH_PMDP_SPLITTING_FLUSH

Ok, added.

> __HAVE_ARCH_PTE_SPECIAL

Ok, added.

> __HAVE_ARCH_GATE_AREA

So this does not appear to be a feature per se: architectures that 
don't define __HAVE_ARCH_GATE_AREA fall back to the generic one. Or is 
it expected for every architecture to provide its own?

> ARCH_HAVE_ELF_ASLR

Does not seem to be upstream.

> ARCH_HAS_GCOV_PROFILE_ALL

Yeah, that's already included in v6.

> CONFIG_ARCH_USE_BUILTIN_BSWAP

So AFAICS this feature is an arch opt-in, on the basis of whether GCC 
does the right thing or not.

We'd need a separate config switch: ARCH_DONT_USE_BUILTIN_BSWAP to 
make a distinction between architectures that have made an informed 
decision to not support it, versus architectures that have not 
bothered so far.

> HAVE_ARCH_HUGE_VMAP

Ok, added.

> ARCH_HAS_SG_CHAIN

Ok, added.

> __HAVE_ARCH_STRNCASECMP

So, no architecture supports this yet- but added.

> ARCH_HAS_ELF_RANDOMIZE

Agreed and v6 already includes this.

> CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID

So this isn't really a feature, but a facility that an architecture 
might have to provide if it has a quirk. Only ia64 has that at the 
moment.

> ARCH_SUPPORTS_DEFERRED_STRUCT_PAGE_INIT

Not upstream yet it appears.

> CONFIG_ARCH_USES_PG_UNCACHED

Ok, added.

> CONFIG_ARCH_HAS_WALK_MEMORY

So this too is a quirk, for PowerPC, which does not maintain the 
memory layout in the resource tree.

> and things which don't contain ARCH
> 
> HAVE_GENERIC_RCU_GUP

So this is a generic, RCU based fast-GUP facility - but architectures 
may implement their own get_user_pages_fast() facilites, such as x86 
which does it lock-less.

So I'm not sure what to flag here: perhaps architectures that don't 
offer get_user_pages_fast() at all?

> HAVE_RCU_TABLE_FREE

So this is related to HAVE_GENERIC_RCU_GUP: architectures that do RCU 
based GUP will want to use HAVE_RCU_TABLE_FREE.

> HAVE_GENERIC_RCU_GUP

double ;-)

> CONFIG_HAVE_CLK

So I think the generic clock framework first needs to be integrated 
with core timekeeping before we start requiring it from architectures.

> CONFIG_HAVE_IOREMAP_PROT

Agreed - already in -v6.

> CONFIG_HAVE_MEMBLOCK_NODE_MAP

Ok, added.

> And then there's the increasingly common
> 
> arch/include/asm/foo.h:
> 
> 	static inline void wibble(...)
> 	{
> 		...
> 	}
> 	#define wibble wibble
> 
> include/linux/foo.h:
> 
> 	#ifndef wibble
> 	static inline void wibble(...)
> 	{
> 		...
> 	}
> 	#define wibble
> 	#endif
> 
> which is going to be hard to grep for....

Hm, yes. If you give me a rough list then I can try to map them out as 
well.

Once we have the initial feature collection done it will be a lot 
easier going forward: anything missing or inaccurate can be added to 
or fixed in its own file.

> ugh, this thing's going to be enormous.  People will go insane 
> reading it, so each section should have a sentence describing what 
> the feature does so maintainers can make quick decisions about 
> whether they should bother.

I hope you'll like the structure of -v7 better :-)

Thanks,

	Ingo
