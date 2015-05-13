From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [RFC PATCH v6] Documentation/arch: Add
 Documentation/arch-features.txt
Date: Wed, 13 May 2015 15:05:23 -0700
Message-ID: <20150513150523.ddd65d7cd51f820b78f0c8e3@linux-foundation.org>
References: <20150512142250.dcb053da81855ae1b5861173@linux-foundation.org>
	<20150512213843.GV21418@twins.programming.kicks-ass.net>
	<20150512144910.0b49c9a7a13336773449db33@linux-foundation.org>
	<20150513083441.GA17336@gmail.com>
	<20150513085636.GA11030@gmail.com>
	<20150513092421.GB11030@gmail.com>
	<20150513094622.GC11030@gmail.com>
	<20150513094756.GD11030@gmail.com>
	<20150513131835.GJ1517@pd.tnic>
	<20150513134842.GA1657@gmail.com>
	<20150513162757.GA21894@x>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150513162757.GA21894@x>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, 13 May 2015 09:27:57 -0700 Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org> wrote:

> If we can't generate this, then the ASCII-art style and right-aligned
> feature names seems *really* likely to produce spurious conflicts,
> especially when adding a feature to the list.  Even though it would
> produce a much longer file, would you consider dropping the tables and
> just having a section per feature?

me2.  The patch conflicts are going to be pretty bad.

I'd also prefer a format which allows us to add useful notes - it's a
bit hostile to say "thou shalt implement X" without providing any info
about how to do so.  Where do we tell maintainers that there's a handy
test app in tools/testing/selftests which they should use?

This way, I can bug patch submitters with "hey, you forgot to update
Documentation/arch-features.txt" and they will add useful info while
it's all still hot in their minds.



And there's a ton of stuff which can go in here, much of it not
immediately apparent.

Just grepping 9 months worth of the stuff I've handled, I'm seeing
things like

HAVE_ARCH_KASAN
__HAVE_ARCH_PMDP_SPLITTING_FLUSH
__HAVE_ARCH_PTE_SPECIAL
__HAVE_ARCH_GATE_AREA
ARCH_HAVE_ELF_ASLR
ARCH_HAS_GCOV_PROFILE_ALL
CONFIG_ARCH_USE_BUILTIN_BSWAP
HAVE_ARCH_HUGE_VMAP
ARCH_HAS_SG_CHAIN
__HAVE_ARCH_STRNCASECMP
ARCH_HAS_ELF_RANDOMIZE
CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID
ARCH_SUPPORTS_DEFERRED_STRUCT_PAGE_INIT
CONFIG_ARCH_USES_PG_UNCACHED
CONFIG_ARCH_HAS_WALK_MEMORY

and things which don't contain ARCH

HAVE_GENERIC_RCU_GUP
HAVE_RCU_TABLE_FREE
HAVE_GENERIC_RCU_GUP
CONFIG_HAVE_CLK
CONFIG_HAVE_IOREMAP_PROT
CONFIG_HAVE_MEMBLOCK_NODE_MAP

And then there's the increasingly common

arch/include/asm/foo.h:

	static inline void wibble(...)
	{
		...
	}
	#define wibble wibble

include/linux/foo.h:

	#ifndef wibble
	static inline void wibble(...)
	{
		...
	}
	#define wibble
	#endif

which is going to be hard to grep for....


ugh, this thing's going to be enormous.  People will go insane reading
it, so each section should have a sentence describing what the feature
does so maintainers can make quick decisions about whether they should
bother.
