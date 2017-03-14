From: Till Smejkal <till.smejkal@googlemail.com>
Subject: Re: [RFC PATCH 10/13] mm: Introduce first class virtual address
 spaces
Date: Mon, 13 Mar 2017 19:34:27 -0700
Message-ID: <20170314023427.3p4a5qxtl5eh5epi@arch-dev>
References: <cd1adda8-bf6a-47ad-bff3-5bc6626ac100@synopsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <cd1adda8-bf6a-47ad-bff3-5bc6626ac100@synopsys.com>
Sender: owner-linux-mm@kvack.org
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: Till Smejkal <till.smejkal@googlemail.com>, Richard Henderson <rth@twiddle.net>, Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Matt Turner <mattst88@gmail.com>, Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Steven Miao <realmz6@gmail.com>, Richard Kuo <rkuo@codeaurora.org>, Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>, James Hogan <james.hogan@imgtec.com>, Ralf Baechle <ralf@linux-mips.org>, "James E.J.  Bottomley" <jejb@parisc-linux.org>, Helge Deller <deller@gmx.de>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Yoshinori Sato <ysato@users.sourceforge.jp>, Rich Felker <dalias@libc.org>, "David S. Miller" <dav>
List-Id: linux-api@vger.kernel.org

Hi Vineet,

On Mon, 13 Mar 2017, Vineet Gupta wrote:
> I've not looked at the patches closely (or read the references paper fully yet),
> but at first glance it seems on ARC architecture, we can can potentially
> use/leverage this mechanism to implement the shared TLB entries. Before anyone
> shouts these are not same as the IA64/x86 protection keys which allow TLB entries
> with different protection bits across processes etc. These TLB entries are
> actually *shared* by processes.
> 
> Conceptually there's shared address spaces, independent of processes. e.g. ldso
> code is shared address space #1, libc (code) #2 .... System can support a limited
> number of shared addr spaces (say 64, enough for typical embedded sys).
> 
> While Normal TLB entries are tagged with ASID (Addr space ID) to keep them unique
> across processes, Shared TLB entries are tagged with Shared address space ID.
> 
> A process MMU context consists of ASID (a single number) and a SASID bitmap (to
> allow "subscription" to multiple Shared spaces. The subscriptions are set up bu
> userspace ld.so which knows about the libs process wants to map.
> 
> The restriction ofcourse is that the spaces are mapped at *same* vaddr is all
> participating processes. I know this goes against whole security, address space
> randomization - but it gives much better real time performance. Why does each
> process need to take a MMU exception for libc code...
> 
> So long story short - it seems there can be multiple uses of this infrastructure !

During the development of this code, we also looked at shared TLB entries, but
the other way around. We wanted to use them to prevent flushing of TLB entries of
shared memory regions when switching between multiple ASes. Unfortunately, we never
finished this part of the code.

However, we also investigated into a different use-case for first class virtual
address spaces that is related to what you propose if I didn't understand something
wrong. The idea is to move shared libraries into their own first class virtual
address space and only load some small trampoline code in the application AS. This
trampoline code performs the VAS switch in the libraries AS and execute the requested
function there. If we combine this architecture with tagged TLB entries to prevent
TLB flushes during the switch operation, it can also reach an acceptable performance.
A side effect of moving the shared library into its own AS is that it can not be used
by ROP-attacks because it is not accessible in the application's AS.

Till

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
