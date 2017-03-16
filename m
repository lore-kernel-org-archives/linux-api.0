From: Till Smejkal <till.smejkal@googlemail.com>
Subject: Re: [RFC PATCH 00/13] Introduce first class virtual address spaces
Date: Thu, 16 Mar 2017 10:29:09 -0700
Message-ID: <20170316172909.ux4u7dbspwlynsce@arch-dev>
References: <alpine.DEB.2.20.1703160919170.3586@nanos>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-aio@kvack.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.20.1703160919170.3586@nanos>
Sender: owner-linux-aio@kvack.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Till Smejkal <till.smejkal@googlemail.com>, Andy Lutomirski <luto@amacapital.net>, Andy Lutomirski <luto@kernel.org>, Richard Henderson <rth@twiddle.net>, Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Matt Turner <mattst88@gmail.com>, Vineet Gupta <vgupta@synopsys.com>, Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Steven Miao <realmz6@gmail.com>, Richard Kuo <rkuo@codeaurora.org>, Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>, James Hogan <james.hogan@imgtec.com>, Ralf Baechle <ralf@linux-mips.org>, "James E.J. Bottomley" <jejb@parisc-linux.org>, Helge Deller <deller@gmx.de>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de>
List-Id: linux-api@vger.kernel.org

On Thu, 16 Mar 2017, Thomas Gleixner wrote:
> Why do we need yet another mechanism to represent something which looks
> like a file instead of simply using existing mechanisms and extend them?

You are right. I also recognized during the discussion with Andy, Chris, Matthew,
Luck, Rich and the others that there are already other techniques in the Linux kernel
that can achieve the same functionality when combined. As I said also to the others,
I will drop the VAS segments for future versions. The first class virtual address
space feature was the more interesting part of the patchset anyways.

Thanks
Till

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
