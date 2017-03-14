From: Till Smejkal <till.smejkal@googlemail.com>
Subject: Re: [RFC PATCH 00/13] Introduce first class virtual address spaces
Date: Mon, 13 Mar 2017 18:31:12 -0700
Message-ID: <20170314013112.ofhcgg2stzoft5mw@arch-dev>
References: <fa60d132-0eef-4350-3c88-1558f447a48f@twiddle.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <fa60d132-0eef-4350-3c88-1558f447a48f@twiddle.net>
Sender: owner-linux-mm@kvack.org
To: Richard Henderson <rth@twiddle.net>
Cc: Till Smejkal <till.smejkal@googlemail.com>, Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Matt Turner <mattst88@gmail.com>, Vineet Gupta <vgupta@synopsys.com>, Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Steven Miao <realmz6@gmail.com>, Richard Kuo <rkuo@codeaurora.org>, Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>, James Hogan <james.hogan@imgtec.com>, Ralf Baechle <ralf@linux-mips.org>, "James E.J. Bottomley" <jejb@parisc-linux.org>, Helge Deller <deller@gmx.de>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Yoshinori Sato <ysato@users.sourceforge.jp>, Rich Felker <dalias@libc.org>, "David S. Miller" <davem>
List-Id: linux-api@vger.kernel.org

On Tue, 14 Mar 2017, Richard Henderson wrote:
> On 03/14/2017 10:39 AM, Till Smejkal wrote:
> > > Is this an indication that full virtual address spaces are useless?  It
> > > would seem like if you only use virtual address segments then you avoid all
> > > of the problems with executing code, active stacks, and brk.
> > 
> > What do you mean with *virtual address segments*? The nice part of first class
> > virtual address spaces is that one can share/reuse collections of address space
> > segments easily.
> 
> What do *I* mean?  You introduced the term, didn't you?
> Rereading your original I see you called them "VAS segments".

Oh, I am sorry. I thought that you were referring to some other feature that I don't
know.

> Anyway, whatever they are called, it would seem that these segments do not
> require any of the syncing mechanisms that are causing you problems.

Yes, VAS segments provide a possibility to share memory regions between multiple
address spaces without the need to synchronize heap, stack, etc. Unfortunately, the
VAS segment feature itself without the whole concept of first class virtual address
spaces is not as powerful. With some additional work it can probably be represented
with the existing shmem functionality.

The first class virtual address space feature on the other side provides a real
benefit for applications in our opinion namely that an application can switch between
different views on its memory which enables various interesting programming paradigms
as mentioned in the cover letter.

Till

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
