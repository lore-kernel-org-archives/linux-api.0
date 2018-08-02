From: Palmer Dabbelt <palmer@sifive.com>
Subject: Re: [PATCH 04/24] 32-bit userspace ABI: introduce ARCH_32BIT_OFF_T config option
Date: Thu, 02 Aug 2018 11:30:55 -0700 (PDT)
Message-ID: <mhng-96b7425f-3358-4b26-bd80-2a8957100f9a@palmer-si-x1c4>
References: <20180625061950.GB23998@yury-thinkpad>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180625061950.GB23998@yury-thinkpad>
Sender: linux-kernel-owner@vger.kernel.org
To: ynorov@caviumnetworks.com
Cc: Arnd Bergmann <arnd@arndb.de>, linux-doc@vger.kernel.org, szabolcs.nagy@arm.com, catalin.marinas@arm.com, heiko.carstens@de.ibm.com, philipp.tomsich@theobroma-systems.com, joseph@codesourcery.com, linux-arch@vger.kernel.org, sellcey@caviumnetworks.com, Prasun.Kapoor@caviumnetworks.com, schwab@suse.de, agraf@suse.de, geert@linux-m68k.org, bamv2005@gmail.com, Dave.Martin@arm.com, kilobyte@angband.pl, manuel.montezelo@gmail.com, james.hogan@imgtec.com, cmetcalf@mellanox.com, pinskia@gmail.com, linyongting@huawei.com, klimov.linux@gmail.com, broonie@kernel.org, linux-arm-kernel@lists.infradead.org, maxim.kuvyrkov@linaro.org, fweimer@redhat.com, linux-api@vger.kernel.org, Nathan_Lynch@mentor.com, linux-kernel@vger.kernel.org, james.morse@arm.com, ramana.gcc@googlemail.com, schwi
List-Id: linux-api@vger.kernel.org

On Sun, 24 Jun 2018 23:19:50 PDT (-0700), ynorov@caviumnetworks.com wrote:
> On Mon, Jun 11, 2018 at 02:27:36PM +0300, Yury Norov wrote:
>> On Mon, Jun 11, 2018 at 09:48:02AM +0200, Arnd Bergmann wrote:
>> > On Sat, Jun 9, 2018 at 9:42 AM, Yury Norov <ynorov@caviumnetworks.com> wrote:
>> > > On Fri, Jun 08, 2018 at 06:32:07PM +0100, Catalin Marinas wrote:
>> > >> On Wed, May 16, 2018 at 11:18:49AM +0300, Yury Norov wrote:
>> > >> > diff --git a/arch/Kconfig b/arch/Kconfig
>> > >> > index 76c0b54443b1..ee079244dc3c 100644
>> > >> > --- a/arch/Kconfig
>> > >> > +++ b/arch/Kconfig
>> > >> > @@ -264,6 +264,21 @@ config ARCH_THREAD_STACK_ALLOCATOR
>> > >> >  config ARCH_WANTS_DYNAMIC_TASK_STRUCT
>> > >> >     bool
>> > >> >
>> > >> > +config ARCH_32BIT_OFF_T
>> > >> > +   bool
>> > >> > +   depends on !64BIT
>> > >> > +   help
>> > >> > +     All new 32-bit architectures should have 64-bit off_t type on
>> > >> > +     userspace side which corresponds to the loff_t kernel type. This
>> > >> > +     is the requirement for modern ABIs. Some existing architectures
>> > >> > +     already have 32-bit off_t. This option is enabled for all such
>> > >> > +     architectures explicitly. Namely: arc, arm, blackfin, cris, frv,
>> > >> > +     h8300, hexagon, m32r, m68k, metag, microblaze, mips32, mn10300,
>> > >> > +     nios2, openrisc, parisc32, powerpc32, score, sh, sparc, tile32,
>> > >> > +     unicore32, x86_32 and xtensa. This is the complete list. Any
>> > >> > +     new 32-bit architecture should declare 64-bit off_t type on user
>> > >> > +     side and so should not enable this option.
>> > >>
>> > >> Do you know if this is the case for riscv and nds32, merged in the
>> > >> meantime? If not, I suggest you drop this patch altogether and just
>> > >> define force_o_largefile() for arm64/ilp32 as we don't seem to stick to
>> > >> "all new 32-bit architectures should have 64-bit off_t".
>> > >
>> > > I wrote this patch at request of Arnd Bergmann. This is actually his
>> > > words that all new 32-bit architectures should have 64-bit off_t. So
>> > > I was surprized when riscv was merged with 32-bit off_t (and I didn't
>> > > follow nds32).
>> > >
>> > > If this rule is still in force, we'd better add new exceptions to this
>> > > patch. Otherwise, we can drop it.
>> > >
>> > > Arnd, could you please comment it?
>> >
>> > I completely forgot about it and had assumed that it was merged long
>> > ago, sorry about that.
>>
>> Hi Arnd,
>>
>> There are 3 patches like this in ILP32 series that change ABI for new
>> targets. I've submitted them in separated series:
>> https://lkml.org/lkml/2017/9/25/574
>>
>> They all seems to be acked by you. If you ready to upstream the
>> series, I can rebase it and add riscv32 and nds32 exceptions.
>>
>> If Palmer and riscv people will decide to follow new rules, we can
>> easily drop the exception.
>
> Ping?

Sorry to be a bit slow, but we just decided to skip this current glibc release 
for rv32i and instead focus on getting the 32-bit ABI nice and clean for the 
next release.  Thus we in RISC-V land are OK with taking these changes to the 
32-bit kernel ABI.
