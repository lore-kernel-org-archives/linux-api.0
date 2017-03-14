From: Till Smejkal <till.smejkal@googlemail.com>
Subject: Re: [RFC PATCH 00/13] Introduce first class virtual address spaces
Date: Tue, 14 Mar 2017 14:14:27 -0700
Message-ID: <20170314211427.7wxdyrholi3mgle5@arch-dev>
References: <8d9333d6-2f81-a9de-484e-e1d655e1d3c3@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <8d9333d6-2f81-a9de-484e-e1d655e1d3c3@mellanox.com>
Sender: owner-linux-mm@kvack.org
To: Chris Metcalf <cmetcalf@mellanox.com>
Cc: Andy Lutomirski <luto@amacapital.net>, Andy Lutomirski <luto@kernel.org>, Till Smejkal <till.smejkal@googlemail.com>, Richard Henderson <rth@twiddle.net>, Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Matt Turner <mattst88@gmail.com>, Vineet Gupta <vgupta@synopsys.com>, Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Steven Miao <realmz6@gmail.com>, Richard Kuo <rkuo@codeaurora.org>, Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>, James Hogan <james.hogan@imgtec.com>, Ralf Baechle <ralf@linux-mips.org>, "James E.J. Bottomley" <jejb@parisc-linux.org>, Helge Deller <deller@gmx.de>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de>
List-Id: linux-api@vger.kernel.org

On Tue, 14 Mar 2017, Chris Metcalf wrote:
> On 3/14/2017 12:12 PM, Till Smejkal wrote:
> > On Mon, 13 Mar 2017, Andy Lutomirski wrote:
> > > On Mon, Mar 13, 2017 at 7:07 PM, Till Smejkal
> > > <till.smejkal@googlemail.com> wrote:
> > > > On Mon, 13 Mar 2017, Andy Lutomirski wrote:
> > > > > This sounds rather complicated.  Getting TLB flushing right seems
> > > > > tricky.  Why not just map the same thing into multiple mms?
> > > > This is exactly what happens at the end. The memory region that is described by the
> > > > VAS segment will be mapped in the ASes that use the segment.
> > > So why is this kernel feature better than just doing MAP_SHARED
> > > manually in userspace?
> > One advantage of VAS segments is that they can be globally queried by user programs
> > which means that VAS segments can be shared by applications that not necessarily have
> > to be related. If I am not mistaken, MAP_SHARED of pure in memory data will only work
> > if the tasks that share the memory region are related (aka. have a common parent that
> > initialized the shared mapping). Otherwise, the shared mapping have to be backed by a
> > file.
> 
> True, but why is this bad?  The shared mapping will be memory resident
> regardless, even if backed by a file (unless swapped out under heavy
> memory pressure, but arguably that's a feature anyway).  More importantly,
> having a file name is a simple and consistent way of identifying such
> shared memory segments.
> 
> With a little work, you can also arrange to map such files into memory
> at a fixed address in all participating processes, thus making internal
> pointers work correctly.

I don't want to say that the interface provided by MAP_SHARED is bad. I am only
arguing that VAS segments and the interface that they provide have an advantage over
the existing ones in my opinion. However, Matthew Wilcox also suggested in some
earlier mail that VAS segments could be exported to user space via a special purpose
filesystem. This would enable users of VAS segments to also just use some special
files to setup the shared memory regions. But since the VAS segment itself already
knows where at has to be mapped in the virtual address space of the process, the
establishing of the shared memory region would be very easy for the user.

> > VAS segments on the other side allow sharing of pure in memory data by
> > arbitrary related tasks without the need of a file. This becomes especially
> > interesting if one combines VAS segments with non-volatile memory since one can keep
> > data structures in the NVM and still be able to share them between multiple tasks.
> 
> I am not fully up to speed on NV/pmem stuff, but isn't that exactly what
> the DAX mode is supposed to allow you to do?  If so, isn't sharing a
> mapped file on a DAX filesystem on top of pmem equivalent to what
> you're proposing?

If I read the documentation to DAX filesystems correctly, it is indeed possible to us
them to create files that life purely in NVM. I wasn't fully aware of this feature.
Thanks for the pointer.

However, the main contribution of this patchset is actually the idea of first class
virtual address spaces and that they can be used to allow processes to have multiple
different views on the system's main memory. For us, VAS segments were another logic
step in the same direction (from first class virtual address spaces to first class
address space segments). However, if there is already functionality in the Linux
kernel to achieve the exact same behavior, there is no real need to add VAS segments.
I will continue thinking about them and either find a different situation where the
currently available interface is not sufficient/too complicated or drop VAS segments
from future version of the patch set.

Till

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
