From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH 00/13] Introduce first class virtual address spaces
Date: Thu, 16 Mar 2017 09:21:38 +0100 (CET)
Message-ID: <alpine.DEB.2.20.1703160919170.3586@nanos>
References: <20170315220234.mooiyrzqdsglo4lp@arch-dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20170315220234.mooiyrzqdsglo4lp@arch-dev>
Sender: owner-linux-mm@kvack.org
To: Till Smejkal <till.smejkal@googlemail.com>
Cc: Andy Lutomirski <luto@amacapital.net>, Andy Lutomirski <luto@kernel.org>, Richard Henderson <rth@twiddle.net>, Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Matt Turner <mattst88@gmail.com>, Vineet Gupta <vgupta@synopsys.com>, Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Steven Miao <realmz6@gmail.com>, Richard Kuo <rkuo@codeaurora.org>, Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>, James Hogan <james.hogan@imgtec.com>, Ralf Baechle <ralf@linux-mips.org>, "James E.J. Bottomley" <jejb@parisc-linux.org>, Helge Deller <deller@gmx.de>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.>
List-Id: linux-api@vger.kernel.org

On Wed, 15 Mar 2017, Till Smejkal wrote:
> On Wed, 15 Mar 2017, Andy Lutomirski wrote:

> > > VAS segments on the other side would provide a functionality to
> > > achieve the same without the need of any mounted filesystem. However,
> > > I agree, that this is just a small advantage compared to what can
> > > already be achieved with the existing functionality provided by the
> > > Linux kernel.
> > 
> > I see this "small advantage" as "resource leak and security problem".
> 
> I don't agree here. VAS segments are basically in-memory files that are
> handled by the kernel directly without using a file system. Hence, if an

Why do we need yet another mechanism to represent something which looks
like a file instead of simply using existing mechanisms and extend them?

Thanks,

	tglx

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
