From: Russell King - ARM Linux <linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org>
Subject: Re: [PATCH 2/3] ARM: convert to generated system call tables
Date: Fri, 21 Oct 2016 16:48:56 +0100
Message-ID: <20161021154856.GC1041@n2100.armlinux.org.uk>
References: <E1bwa6s-0004ZY-4k@rmk-PC.armlinux.org.uk>
 <3851270.xZRcP9hae0@wuerfel>
 <20161021133708.GA1041@n2100.armlinux.org.uk>
 <4337157.Eff9E2riVH@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4337157.Eff9E2riVH@wuerfel>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-arch <linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Oct 21, 2016 at 05:18:30PM +0200, Arnd Bergmann wrote:
> On Friday, October 21, 2016 2:37:08 PM CEST Russell King - ARM Linux wrote:
> > On Fri, Oct 21, 2016 at 03:06:45PM +0200, Arnd Bergmann wrote:
> 
> > > If we hit this case, why not just use the wrapper on both EABI
> > > and OABI for simplicity? It's not like we care a lot about
> > > micro-optimizing OABI any more.
> > 
> > I'd still like to retain the ability to only add to EABI in the future.
> 
> Do you mean to add an EABI specific workaround for a specific syscall
> if necessary, or to stop adding OABI syscalls altogether?

To stop adding OABI syscalls altogether.  I'm sure that there will
come a point (if it hasn't already) that glibc no longer supports
OABI, and at that point it probably becomes rather silly to keep
adding OABI syscalls.

> > > That brings up an interesting issue: it would be nice to use the
> > > same input file for arch/arm/ and the compat mode of arch/arm64,
> > > like x86 does. If we handle both oabi and arm64-compat in the same
> > > file, we end up with a superset of what x86 does, and we could
> > > use a single script again, and generate all four tables for
> > > ARM (native OABI, OABI-on-EABI, native EABI, EABI-on-arm64).
> > 
> > OABI-compat != ARM64-EABI-compat though.  They're two completely
> > different things.
> 
> For the purpose of generating the tables, I don't see much
> difference: we either use the fourth column only in native
> mode, or we use the fifth column to override values from
> the fourth one when emulating the ABI on the "other" kernel.

The table generation method can be shared, but I've no idea about the
feasibility of sharing the table between ARM64 and ARM - I don't know
enough about ARM64 to know whether things like an "long" argument to
a syscall (which would be 64-bit on ARM64) would be or would not be a
problem if called from a 32-bit user application.

I've zero knowledge of the whole 32-bit application on 64-bit CPUs
thing, so it's pointless trying to discuss this aspect with me.  Even
for x86, all I care there is that it works, I've no knowledge of how
it works.

> That's similar to x86, 32-bit syscalls use the traditional numbers
> with an optionally different entry point for compat mode, while
> 64-bit syscalls use a somewhat reduced table that now has support
> for both native 64-bit and "x32" mode. x86-64 and x32 share a
> syscall table but not the unistd.h list, all three generated
> from syscall_64.tbl.

What's the point of the x32 mode?

> ARM64 has a separate list of syscalls for compat mode in 
> arch/arm64/include/asm/unistd32.h, this list has the same format
> as include/asm-generic/uapi/unistd.h and must be updated manually
> to match the arch/arm/ table today.

Looking through it, sort-of.  It could have re-used the numbering
from the arch/arm include file, but because ARM64 wanted to be an
entirely separate architecture, it duplicates a lot from 32-bit ARM.
I pointed that out at the time, and was shouted down (which is why
today I have absolutely nothing to do with ARM64, and as a result
have very little knowledge about ARM64 - I lost interest in it as
a result of the responses I got to my comments.)

So... if you don't mind, this isn't an issue I care one iota about.

In order for something to work like what you're alluding to, ARM64
would have to ferret around in arch/arm to pull out the bits it
wants, and I see zero reason for that to be acceptable on either
side of the ARM64 vs ARM divide - it will make my job harder because
I'm then into the position where I need acks from ARM64 people to
change ARM code, and that doesn't interest me at all.  I'm not going
to put myself into a position where I'm at the mercy of ARM64 folk.

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
