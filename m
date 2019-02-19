From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 2/8] 32-bit userspace ABI: introduce ARCH_32BIT_OFF_T
 config option
Date: Tue, 19 Feb 2019 10:10:15 +0100
Message-ID: <CAK8P3a3RTZDfc-4womPK2qbPTwuaP0Jin6Nzq6Ep3G4SnFpZvw@mail.gmail.com>
References: <20190218210712.3503891-1-arnd@arndb.de> <20190218210712.3503891-3-arnd@arndb.de>
 <CAMuHMdUb47nLkorUpQ1ohD-WMaEG7d3DBAs7JWA6rvgKTZAGGw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAMuHMdUb47nLkorUpQ1ohD-WMaEG7d3DBAs7JWA6rvgKTZAGGw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Yury Norov <yury.norov@gmail.com>, y2038 Mailman List <y2038@lists.linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Linux-Arch <linux-arch@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux ARM <linux-arm-kernel@lists.infradead.org>, "open list:QUALCOMM HEXAGON..." <linux-hexagon@vger.kernel.org>, "moderated list:H8/300 ARCHITECTURE" <uclinux-h8-devel@lists.sourceforge.jp>, Stafford Horne <shorne@gmail.com>, Vineet Gupta <vgupta@synopsys.com>, Palmer Dabbelt <palmer@sifive.com>, Guo Ren <guoren@kernel.org>, Greentime Hu <green.hu@gmail.com>, linux-riscv@lists.infradead.org, Guan Xuetao <gxt@pku.edu.cn>, Yury Norov <ynorov@caviumnetworks.com>, Yury Norov <ynorov@marvell.com>
List-Id: linux-api@vger.kernel.org

On Tue, Feb 19, 2019 at 9:56 AM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>
> Hi Arnd, Yuri,
>
> On Tue, Feb 19, 2019 at 3:35 AM Arnd Bergmann <arnd@arndb.de> wrote:
> > From: Yury Norov <ynorov@caviumnetworks.com>
> >
> > All new 32-bit architectures should have 64-bit userspace off_t type, but
> > existing architectures has 32-bit ones.
> >
> > To enforce the rule, new config option is added to arch/Kconfig that defaults
> > ARCH_32BIT_OFF_T to be disabled for new 32-bit architectures. All existing
> > 32-bit architectures enable it explicitly.
> >
> > New option affects force_o_largefile() behaviour. Namely, if userspace
> > off_t is 64-bits long, we have no reason to reject user to open big files.
> >
> > Note that even if architectures has only 64-bit off_t in the kernel
> > (arc, c6x, h8300, hexagon, nios2, openrisc, and unicore32),
> > a libc may use 32-bit off_t, and therefore want to limit the file size
> > to 4GB unless specified differently in the open flags.
> >
> > Signed-off-by: Yury Norov <ynorov@caviumnetworks.com>
> > Acked-by: Arnd Bergmann <arnd@arndb.de>
> > Signed-off-by: Yury Norov <ynorov@marvell.com>
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>
> >  arch/m68k/Kconfig       |  1 +
>
> For m68k:
> Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

Thanks!

> > --- a/arch/Kconfig
> > +++ b/arch/Kconfig
> > @@ -276,6 +276,21 @@ config ARCH_THREAD_STACK_ALLOCATOR
> >  config ARCH_WANTS_DYNAMIC_TASK_STRUCT
> >         bool
> >
> > +config ARCH_32BIT_OFF_T
> > +       bool
> > +       depends on !64BIT
> > +       help
> > +         All new 32-bit architectures should have 64-bit off_t type on
> > +         userspace side which corresponds to the loff_t kernel type. This
> > +         is the requirement for modern ABIs. Some existing architectures
> > +         already have 32-bit off_t. This option is enabled for all such
>
> s/already/still/
>
> > +         architectures explicitly. Namely: arc, arm, blackfin, cris, frv,
> > +         h8300, hexagon, m32r, m68k, metag, microblaze, mips32, mn10300,
> > +         nios2, openrisc, parisc32, powerpc32, score, sh, sparc, tile32,
> > +         unicore32, x86_32 and xtensa. This is the complete list. Any
>
> Do we really need this list here?  It's intended to shrink only.
> It includes removed architectures (blackfin, cris, frv, m32r, metag,
> mn10300, score, tile32), but lacks several new ones affected by this
> patch (c6x, csky, nds32, riscv).

Right, I (finally)  took Yury's patch that was already several years old
without checking this text (I did make sure all architectures are changed
correctly).

I'll just remove the list here.

      Arnd
