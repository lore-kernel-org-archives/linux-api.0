From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [RFC PATCH] UAPI: Document auxvec AT_* namespace policy and note
 reservations
Date: Wed, 16 May 2018 16:49:59 +0100
Message-ID: <20180516154957.GT7753@e103592.cambridge.arm.com>
References: <1526480447-18185-1-git-send-email-Dave.Martin@arm.com>
 <20180516152913.GY1392@brightrain.aerifal.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180516152913.GY1392@brightrain.aerifal.cx>
Sender: linux-kernel-owner@vger.kernel.org
To: Rich Felker <dalias@libc.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Richard Henderson <rth@twiddle.net>, Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Matt Turner <mattst88@gmail.com>, Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>, Michal Simek <monstr@monstr.eu>, Ralf Baechle <ralf@linux-mips.org>, James Hogan <jhogan@kernel.org>, Greentime Hu <green.hu@gmail.com>, Vincent Chen <deanbo422@gmail.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, Palmer Dabbelt <palmer@sifive.com>, Albert
List-Id: linux-api@vger.kernel.org

On Wed, May 16, 2018 at 11:29:13AM -0400, Rich Felker wrote:
> On Wed, May 16, 2018 at 03:20:47PM +0100, Dave Martin wrote:
> > There are constraints on defining AT_* auxvec tags that are not
> > obvious to the casual maintainer of either the global
> > <uapi/linux/auxvec.h> or the arch-specific headers.  This is likely
> > to lead to mistakes.  (I certainly fell foul of it...)
> > 
> > For the benefit of future maintainers, this patch collects the
> > relevant information in one place, documenting how the namespace
> > needs to be managed, and noting all the values currently in use.
> > 
> > Maintaining a global list may result in some merge conflicts, but
> > AT_* values are not added frequently.  I'm open to suggestions on
> > the best approach.
> > 
> > I also assume that values 38 and 39 may have been used for
> > historical purposes, such as an architecture that is no longer
> > supported.  If they have definitely never been used for anything,
> > they could be removed from the "reserved" list.
> 
> On the userspace side (elf.h) all the AT_* constants are in one file.
> Why don't we just do the same here and eliminate the
> arch/*/include/uapi/asm/auxvec.h files and likewise the need to
> manually maintain consistency of the comments about reservations?
> 
> If there are reasons not to do that, I'm not opposed to this patch
> as-is.

I agree, it would be better to merge them.

My concern was that the correct way to get these definitions from
userspace is very unclear, so there may be software out there
including <asm/auxvec.h> directly, which would now lack expected
definitions.

codesearch.debian.net shows no real hits for that, so maybe I'm too
paranoid.

Since <linux/auxvec.h> only contains #defines, it may be enough for arch
<asm/auxvec.h> headers to include <linux/auxvec.h>.

Thoughts?

Cheers
---Dave
