From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2 29/29] y2038: add 64-bit time_t syscalls to all 32-bit architectures
Date: Mon, 21 Jan 2019 18:08:20 +0100
Message-ID: <CAK8P3a04UC2dHVqx1gHXJQzsDw446h1ghLEuRe0xmUyJgrOktw@mail.gmail.com>
References: <20190118161835.2259170-1-arnd@arndb.de> <20190118161835.2259170-30-arnd@arndb.de>
 <CALCETrXqM5mhvwreN5y-9K99h1j9rs9MAVK-cNLC54s1fdHA6w@mail.gmail.com>
 <CAK8P3a0V+xboaGAF2nqrYtpjXXA7y0LcvCKi4ngLTus1D_XZBA@mail.gmail.com>
 <CALCETrWPj6dHEyo=AELoVjXGsiwuSpRp17x3CEWBHvp7i3cy+Q@mail.gmail.com>
 <20190119142852.cntdihah4mpa3lgx@e5254000004ec.dyn.armlinux.org.uk> <CAMuHMdXzQNEEDjWrmTph8Krovj1g2WhnBUaM=FvKB+J2fZqctA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAMuHMdXzQNEEDjWrmTph8Krovj1g2WhnBUaM=FvKB+J2fZqctA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Russell King - ARM Linux admin <linux@armlinux.org.uk>, Andy Lutomirski <luto@kernel.org>, y2038 Mailman List <y2038@lists.linaro.org>, Linux API <linux-api@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, Matt Turner <mattst88@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>, Michal Simek <monstr@monstr.eu>, Paul Burton <paul.burton@mips.com>, Helge Deller <deller@gmx.de>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Michael Ellerman <mpe@ellerman.id.au>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Rich Felker <dalias@libc.org>D
List-Id: linux-api@vger.kernel.org

On Mon, Jan 21, 2019 at 9:19 AM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> On Sat, Jan 19, 2019 at 3:29 PM Russell King - ARM Linux admin
> <linux@armlinux.org.uk> wrote:
> > On Fri, Jan 18, 2019 at 11:53:25AM -0800, Andy Lutomirski wrote:
> > > On Fri, Jan 18, 2019 at 11:33 AM Arnd Bergmann <arnd@arndb.de> wrote:
> > > > On Fri, Jan 18, 2019 at 7:50 PM Andy Lutomirski <luto@kernel.org> wrote:
> > >
> > > Can we perhaps just start the consistent numbers above 547 or maybe
> > > block out 512..547 in the new regime?
> >
> > I don't think you gain much with that kind of scheme - it won't take
> > very long before an architecture misses having a syscall added, and
> > then someone else adds their own.  Been there with ARM - I was keeping
> > the syscall table in the same order as x86 for new syscalls, but now
>
> Same for m68k, and probably other architectures.
>
> > that others have been adding syscalls to the table since I converted
> > ARM to the tabular form, that's now gone out the window.
> >
> > So, I think it's completely pointless to do what you're suggesting.
> > We'll just end up with a big hole in the middle of the syscall table
> > and then revert back to random numbering of syscalls thereafter again.
>
> I believe the plan is to add future syscalls for all architectures in a
> single commit, to keep everything in sync.

Yes, that is the idea. This was not realistic before, since each one
of the old architectures had its own way of describing the system call
tables, and many needed a different set of quirks.

Since (almost) everything is now converted to the syscall.tbl format,
we have removed all obsolete architectures, and a lot of the quirks
(x32, spu, s390-31) won't matter as much in the future, I think it is
now possible to do it.

We could even extend scripts/checksyscalls.sh to warn if a new
syscall above 423 is not added to all 16 tables at the same time.

> Regardless, I'm wondering what to do with the holes marked "room for
> arch specific calls".
> When is a syscall really arch-specific, and can it be added there, and
> when does it turn out (later) that it isn't, breaking the
> synchronization again?

We've had a bit of that already, with cacheflush(), which exists on
a couple of architectures, including some that use the first
'arch specific' slot (244) of the asm-generic table. I think this
will be rare enough that we can figure out a solution when we
get there.

> The pkey syscalls may be a bad example, as AFAIU they can be implemented
> on some architectures, but not on some others.  Still, I had skipped them
> when adding new syscalls to m68k.
>
> Perhaps we should get rid of the notion of "arch-specific syscalls", and
> reserve a slot everywhere anyway?

I don't mind calling the hole something else if that helps. Out of
principle I would already assume that anything we add for x86
or the generic table should be added everywhere, but we can
make it broader than that.

      Arnd
