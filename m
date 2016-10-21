From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 2/3] ARM: convert to generated system call tables
Date: Fri, 21 Oct 2016 22:35:53 +0200
Message-ID: <24632117.YsmPs86ri6@wuerfel>
References: <E1bwa6s-0004ZY-4k@rmk-PC.armlinux.org.uk> <4337157.Eff9E2riVH@wuerfel> <20161021154856.GC1041@n2100.armlinux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <20161021154856.GC1041@n2100.armlinux.org.uk>
Sender: linux-arch-owner@vger.kernel.org
To: Russell King - ARM Linux <linux@armlinux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-arch <linux-arch@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Friday, October 21, 2016 4:48:56 PM CEST Russell King - ARM Linux wrote:
> On Fri, Oct 21, 2016 at 05:18:30PM +0200, Arnd Bergmann wrote:
> > On Friday, October 21, 2016 2:37:08 PM CEST Russell King - ARM Linux wrote:
> > > On Fri, Oct 21, 2016 at 03:06:45PM +0200, Arnd Bergmann wrote:
> > 
> > > > If we hit this case, why not just use the wrapper on both EABI
> > > > and OABI for simplicity? It's not like we care a lot about
> > > > micro-optimizing OABI any more.
> > > 
> > > I'd still like to retain the ability to only add to EABI in the future.
> > 
> > Do you mean to add an EABI specific workaround for a specific syscall
> > if necessary, or to stop adding OABI syscalls altogether?
> 
> To stop adding OABI syscalls altogether.  I'm sure that there will
> come a point (if it hasn't already) that glibc no longer supports
> OABI, and at that point it probably becomes rather silly to keep
> adding OABI syscalls.

Ok. While uClibc still supports OABI, it seems rather unlikely that
there are active users of OABI uClibc that need any of the future
syscalls.

> > > > That brings up an interesting issue: it would be nice to use the
> > > > same input file for arch/arm/ and the compat mode of arch/arm64,
> > > > like x86 does. If we handle both oabi and arm64-compat in the same
> > > > file, we end up with a superset of what x86 does, and we could
> > > > use a single script again, and generate all four tables for
> > > > ARM (native OABI, OABI-on-EABI, native EABI, EABI-on-arm64).
> > > 
> > > OABI-compat != ARM64-EABI-compat though.  They're two completely
> > > different things.
> > 
> > For the purpose of generating the tables, I don't see much
> > difference: we either use the fourth column only in native
> > mode, or we use the fifth column to override values from
> > the fourth one when emulating the ABI on the "other" kernel.
> 
> The table generation method can be shared, but I've no idea about the
> feasibility of sharing the table between ARM64 and ARM - I don't know
> enough about ARM64 to know whether things like an "long" argument to
> a syscall (which would be 64-bit on ARM64) would be or would not be a
> problem if called from a 32-bit user application.
> 
> I've zero knowledge of the whole 32-bit application on 64-bit CPUs
> thing, so it's pointless trying to discuss this aspect with me.  Even
> for x86, all I care there is that it works, I've no knowledge of how
> it works.

Ok. I'm sure it works, but we can definitely leave that for the
time when I or someone else gets around to do the same conversion
for ARM64 that you are doing for ARM32. From all I can tell, it's
a natural extension of the file you already have.

> > That's similar to x86, 32-bit syscalls use the traditional numbers
> > with an optionally different entry point for compat mode, while
> > 64-bit syscalls use a somewhat reduced table that now has support
> > for both native 64-bit and "x32" mode. x86-64 and x32 share a
> > syscall table but not the unistd.h list, all three generated
> > from syscall_64.tbl.
> 
> What's the point of the x32 mode?

On x86, the motivation is faster code for most use cases that
don't need a lot of memory, as the 64-bit opcodes have 16 registers
rather than 8 in 32-bit mode but 32-bit pointers have lower
cache footprint than 64-bit pointers. 

Interestingly, while ARM64 is doing basically the same thing now,
the motivation is almost entirely different: going from around 16
to around 32 registers has a much lower impact on performance
than starting out with 8, but there are ARMv8 implementations that
lack aarch32 mode but still want to run legacy 32-bit code that
is too time-consuming to get 64-bit clean.

> > ARM64 has a separate list of syscalls for compat mode in 
> > arch/arm64/include/asm/unistd32.h, this list has the same format
> > as include/asm-generic/uapi/unistd.h and must be updated manually
> > to match the arch/arm/ table today.
> 
> Looking through it, sort-of.  It could have re-used the numbering
> from the arch/arm include file, but because ARM64 wanted to be an
> entirely separate architecture, it duplicates a lot from 32-bit ARM.
> I pointed that out at the time, and was shouted down (which is why
> today I have absolutely nothing to do with ARM64, and as a result
> have very little knowledge about ARM64 - I lost interest in it as
> a result of the responses I got to my comments.)
> 
> So... if you don't mind, this isn't an issue I care one iota about.
> 
> In order for something to work like what you're alluding to, ARM64
> would have to ferret around in arch/arm to pull out the bits it
> wants, and I see zero reason for that to be acceptable on either
> side of the ARM64 vs ARM divide - it will make my job harder because
> I'm then into the position where I need acks from ARM64 people to
> change ARM code, and that doesn't interest me at all.  I'm not going
> to put myself into a position where I'm at the mercy of ARM64 folk.

Well, if we don't need to worry about OABI any more, using a shared
file for all architectures to add new syscalls (with their compat
handlers) would also mean that you don't have to worry about the
compat handler either, since that gets added in the shared file
along with the syscall.

Then again, if we move the a shared file for new syscalls, we also
don't need to worry about synchronizing the syscall tables for
ARM and compat ARM64, since the files would not get changed any
more.

	Arnd
