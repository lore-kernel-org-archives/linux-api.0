From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 14/15] arch: add split IPC system calls where needed
Date: Tue, 15 Jan 2019 22:24:54 +0100
Message-ID: <CAK8P3a3KE7bhK34T-G9Lj3v0ERhEj3LB5emEEwy8h6w8pVeQZg@mail.gmail.com>
References: <20190110162435.309262-1-arnd@arndb.de> <20190110162435.309262-15-arnd@arndb.de>
 <87pnsz28k2.fsf@concordia.ellerman.id.au> <CAK8P3a0uas76i2W1yjFvxHT-2=A8_egUZeAUM-Vya6386+87Xg@mail.gmail.com>
 <CAK8P3a3eUzGDrJtV2ySpgHwjKHwZYr+1xHp6tChCt1gWi=mJ+g@mail.gmail.com> <CAMuHMdVw1mBLGdn4hkiNVyoJ_oxMwi3d=_e7WL5ru+ALA4MKbw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAMuHMdVw1mBLGdn4hkiNVyoJ_oxMwi3d=_e7WL5ru+ALA4MKbw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>, y2038 Mailman List <y2038@lists.linaro.org>, Linux API <linux-api@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Matt Turner <mattst88@gmail.com>, Russell King - ARM Linux <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>, Michal Simek <monstr@monstr.eu>, Paul Burton <paul.burton@mips.com>, Helge Deller <deller@gmx.de>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Rich Felker <dalias@libc.org>, David Miller <davem@davemloft.net>, Andy Lutomirski <luto@kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, Jan 15, 2019 at 5:36 PM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> On Tue, Jan 15, 2019 at 4:19 PM Arnd Bergmann <arnd@arndb.de> wrote:
> > On Tue, Jan 15, 2019 at 4:01 PM Arnd Bergmann <arnd@arndb.de> wrote:
> > > On Mon, Jan 14, 2019 at 4:59 AM Michael Ellerman <mpe@ellerman.id.au> wrote:
> > > > Arnd Bergmann <arnd@arndb.de> writes:
> > > > >  arch/m68k/kernel/syscalls/syscall.tbl     | 11 +++++++++++
> > > > >  arch/mips/kernel/syscalls/syscall_o32.tbl | 11 +++++++++++
> > > > >  arch/powerpc/kernel/syscalls/syscall.tbl  | 12 ++++++++++++
> > > >
> > > > I have some changes I'd like to make to our syscall table that will
> > > > clash with this.
> > > >
> > > > I'll try and send them today.
> > >
> > > Ok. Are those for 5.0 or 5.1? If they are intended for 5.0, it would be
> > > nice for me to have a branch based on 5.0-rc1 that I can put
> > > the other patches on top of.
> >
> > There is also another change that I considered:
> >
> > At the end of my series, we have a lot of entries like
> >
> > 245     32      clock_settime                   sys_clock_settime32
> > 245     64      clock_settime                   sys_clock_settime
> > 245     spu     clock_settime                   sys_clock_settime
> >
> > which could be folded into
> >
> > 245     32      clock_settime                   sys_clock_settime32
> > 245     spu64 clock_settime                   sys_clock_settime
> >
> > if we just add another option to the ABI field. Any thoughts on
> > that?
>
> So "spu64" would mean "spu + 64"?
> That makes it more difficult to read, and to grep.
> What about allowing multiple ABIs, separated by commas?
> So that line would become:
>
>     245     spu,64 clock_settime                   sys_clock_settime

I agree that would be a nice representation, but doing this would
again require changing the script, which then in turn clashes with
Firoz' patches to unify it under the scripts/ directory.

       Arnd
