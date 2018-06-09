From: Adam Borowski <kilobyte@angband.pl>
Subject: Re: [PATCH 04/24] 32-bit userspace ABI: introduce ARCH_32BIT_OFF_T
 config option
Date: Sat, 9 Jun 2018 23:13:50 +0200
Message-ID: <20180609211350.ilv43jl4k3byxscs@angband.pl>
References: <20180608173207.nwoi25jee52gpdwy@armageddon.cambridge.arm.com>
 <mhng-e1922456-a05b-46f9-8644-d45ad70a55e5@palmer-si-x1c4>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <mhng-e1922456-a05b-46f9-8644-d45ad70a55e5@palmer-si-x1c4>
Sender: linux-kernel-owner@vger.kernel.org
To: Palmer Dabbelt <palmer@sifive.com>
Cc: catalin.marinas@arm.com, ynorov@caviumnetworks.com, Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, szabolcs.nagy@arm.com, heiko.carstens@de.ibm.com, philipp.tomsich@theobroma-systems.com, joseph@codesourcery.com, sellcey@caviumnetworks.com, Prasun.Kapoor@caviumnetworks.com, schwab@suse.de, agraf@suse.de, bamv2005@gmail.com, geert@linux-m68k.org, Dave.Martin@arm.com, manuel.montezelo@gmail.com, james.hogan@imgtec.com, cmetcalf@mellanox.com, pinskia@gmail.com, linyongting@huawei.com, klimov.linux@gmail.com, broonie@kernel.org, maxim.kuvyrkov@linaro.org, fweimer@redhat.com, Nathan_Lynch@mentor.com, james.morse@arm.com, ramana.gcc@googlemail.com
List-Id: linux-api@vger.kernel.org

On Fri, Jun 08, 2018 at 03:33:51PM -0700, Palmer Dabbelt wrote:
> On Fri, 08 Jun 2018 10:32:07 PDT (-0700), catalin.marinas@arm.com wrote:
> > On Wed, May 16, 2018 at 11:18:49AM +0300, Yury Norov wrote:
> > > +config ARCH_32BIT_OFF_T
> > > +	bool
> > > +	depends on !64BIT
> > > +	help
> > > +	  All new 32-bit architectures should have 64-bit off_t type on
> > > +	  userspace side which corresponds to the loff_t kernel type. This
> > > +	  is the requirement for modern ABIs. Some existing architectures
> > > +	  already have 32-bit off_t. This option is enabled for all such
> > > +	  architectures explicitly. Namely: arc, arm, blackfin, cris, frv,
> > > +	  h8300, hexagon, m32r, m68k, metag, microblaze, mips32, mn10300,
> > > +	  nios2, openrisc, parisc32, powerpc32, score, sh, sparc, tile32,
> > > +	  unicore32, x86_32 and xtensa. This is the complete list. Any
> > > +	  new 32-bit architecture should declare 64-bit off_t type on user
> > > +	  side and so should not enable this option.
> > 
> > Do you know if this is the case for riscv and nds32, merged in the
> > meantime? If not, I suggest you drop this patch altogether and just
> > define force_o_largefile() for arm64/ilp32 as we don't seem to stick to
> > "all new 32-bit architectures should have 64-bit off_t".

nds32 was obsolete even at the time of merging (it's just that Andes have
a novel idea of actually supporting their old product lines!), thus it'll
be a short lived port.  It doesn't matter much if it carries legacy baggage
-- especially that it has existing out-of-mainline users.

Not so much for riscv32, which is designed and planned to be very long
lived.  And has no existing _Linux_ users.

> We (RISC-V) don't have support for rv32i in glibc yet, so there really isn't
> a fixed ABI there yet.  From my understanding the rv32i port as it currently
> stands has a 32-bit off_t (via __kernel_off_t being defined as long), so
> this change would technically be a kernel ABI break.
> 
> Since we don't have rv32i glibc yet I'm not fundamentally opposed to an ABI
> break.  Is there a concrete advantage to this?

While modern userland tends to implement LFS support, it's still opt in for
individual binaries at compile time.  With my (userland) porter hat on, I
can tell you that no matter how you preach about using sane build systems, a
terrifying portion of packages manage to fail to pass such flags.
Especially for lesser-known or new architectures -- you need to specifically
add the flag for every new arch for every such piece of software.

Its lack is also not so easy to spot in an automated way; an experimental
and hacky attempt to detect them (IIRC by checking whether the program in
question imports an open/lseek/etc symbol instead of open64) is here:
  https://lintian.debian.org/tags/binary-file-built-without-LFS-support.html
20511 ELFs in 5953 packages!

If there's no 32-bit open() (ie, it's an alias to open64()), all these bugs
are immediately fixed.  Well, a program can still store file size in an int,
but at least there's no interface problem.


On the kernel side, you avoid the need to carry syscalls and structs for
32-bit variants.  This gets you less complexity and a smaller kernel.


Meow!
-- 
⢀⣴⠾⠻⢶⣦⠀ I've read an article about how lively happy music boosts
⣾⠁⢰⠒⠀⣿⡁ productivity.  You can read it, too, you just need the
⢿⡄⠘⠷⠚⠋⠀ right music while doing so.  I recommend Skepticism
⠈⠳⣄⠀⠀⠀⠀ (funeral doom metal).
