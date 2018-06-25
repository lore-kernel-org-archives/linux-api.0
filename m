From: Yury Norov <ynorov@caviumnetworks.com>
Subject: Re: [PATCH 04/24] 32-bit userspace ABI: introduce ARCH_32BIT_OFF_T
 config option
Date: Mon, 25 Jun 2018 09:19:50 +0300
Message-ID: <20180625061950.GB23998@yury-thinkpad>
References: <20180516081910.10067-1-ynorov@caviumnetworks.com>
 <20180516081910.10067-5-ynorov@caviumnetworks.com>
 <20180608173207.nwoi25jee52gpdwy@armageddon.cambridge.arm.com>
 <20180609074227.GA6810@yury-thinkpad>
 <CAK8P3a16ByPtCwKbdLQRDRni3qV9DXLNYZ9QJUH6uHaZYHr34g@mail.gmail.com>
 <20180611112736.GA19952@yury-thinkpad>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180611112736.GA19952@yury-thinkpad>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Philipp Tomsich <philipp.tomsich@theobroma-systems.com>, Joseph Myers <joseph@codesourcery.com>, linux-arch <linux-arch@vger.kernel.org>, Steve Ellcey <sellcey@caviumnetworks.com>, Prasun Kapoor <Prasun.Kapoor@caviumnetworks.com>, Andreas Schwab <schwab@suse.de>, Alexander Graf <agraf@suse.de>, Geert Uytterhoeven <geert@linux-m68k.org>, Bamvor Zhangjian <bamv2005@gmail.com>, Dave Martin <Dave.Martin@arm.com>, Adam Borowski <kilobyte@angband.pl>, Manuel Montezelo <manuel.montezelo@gmail.com>, James Hogan <james.hogan@imgtec.com>, Chris Metcalf <cmetcalf@mellanox.com>
List-Id: linux-api@vger.kernel.org

On Mon, Jun 11, 2018 at 02:27:36PM +0300, Yury Norov wrote:
> On Mon, Jun 11, 2018 at 09:48:02AM +0200, Arnd Bergmann wrote:
> > On Sat, Jun 9, 2018 at 9:42 AM, Yury Norov <ynorov@caviumnetworks.com> wrote:
> > > On Fri, Jun 08, 2018 at 06:32:07PM +0100, Catalin Marinas wrote:
> > >> On Wed, May 16, 2018 at 11:18:49AM +0300, Yury Norov wrote:
> > >> > diff --git a/arch/Kconfig b/arch/Kconfig
> > >> > index 76c0b54443b1..ee079244dc3c 100644
> > >> > --- a/arch/Kconfig
> > >> > +++ b/arch/Kconfig
> > >> > @@ -264,6 +264,21 @@ config ARCH_THREAD_STACK_ALLOCATOR
> > >> >  config ARCH_WANTS_DYNAMIC_TASK_STRUCT
> > >> >     bool
> > >> >
> > >> > +config ARCH_32BIT_OFF_T
> > >> > +   bool
> > >> > +   depends on !64BIT
> > >> > +   help
> > >> > +     All new 32-bit architectures should have 64-bit off_t type on
> > >> > +     userspace side which corresponds to the loff_t kernel type. This
> > >> > +     is the requirement for modern ABIs. Some existing architectures
> > >> > +     already have 32-bit off_t. This option is enabled for all such
> > >> > +     architectures explicitly. Namely: arc, arm, blackfin, cris, frv,
> > >> > +     h8300, hexagon, m32r, m68k, metag, microblaze, mips32, mn10300,
> > >> > +     nios2, openrisc, parisc32, powerpc32, score, sh, sparc, tile32,
> > >> > +     unicore32, x86_32 and xtensa. This is the complete list. Any
> > >> > +     new 32-bit architecture should declare 64-bit off_t type on user
> > >> > +     side and so should not enable this option.
> > >>
> > >> Do you know if this is the case for riscv and nds32, merged in the
> > >> meantime? If not, I suggest you drop this patch altogether and just
> > >> define force_o_largefile() for arm64/ilp32 as we don't seem to stick to
> > >> "all new 32-bit architectures should have 64-bit off_t".
> > >
> > > I wrote this patch at request of Arnd Bergmann. This is actually his
> > > words that all new 32-bit architectures should have 64-bit off_t. So
> > > I was surprized when riscv was merged with 32-bit off_t (and I didn't
> > > follow nds32).
> > >
> > > If this rule is still in force, we'd better add new exceptions to this
> > > patch. Otherwise, we can drop it.
> > >
> > > Arnd, could you please comment it?
> > 
> > I completely forgot about it and had assumed that it was merged long
> > ago, sorry about that.
> 
> Hi Arnd,
> 
> There are 3 patches like this in ILP32 series that change ABI for new
> targets. I've submitted them in separated series:
> https://lkml.org/lkml/2017/9/25/574
> 
> They all seems to be acked by you. If you ready to upstream the
> series, I can rebase it and add riscv32 and nds32 exceptions.
> 
> If Palmer and riscv people will decide to follow new rules, we can
> easily drop the exception.

Ping?
