From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 06/15] ARM: add migrate_pages() system call
Date: Thu, 10 Jan 2019 18:11:44 +0100
Message-ID: <CAK8P3a0TyDTTG7Eoz9dZF1J0SH-=OYQvQ6=YVThTkDfX-mnfWg@mail.gmail.com>
References: <20190110162435.309262-1-arnd@arndb.de> <20190110162435.309262-7-arnd@arndb.de>
 <20190110163220.GB31683@fuggles.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190110163220.GB31683@fuggles.cambridge.arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Will Deacon <will.deacon@arm.com>
Cc: y2038 Mailman List <y2038@lists.linaro.org>, Linux API <linux-api@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Matt Turner <mattst88@gmail.com>, Russell King - ARM Linux <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>, Geert Uytterhoeven <geert@linux-m68k.org>, Michal Simek <monstr@monstr.eu>, Paul Burton <paul.burton@mips.com>, Helge Deller <deller@gmx.de>, Michael Ellerman <mpe@ellerman.id.au>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Rich Felker <dalias@libc.org>, David Miller <davem@davemloft.net>, Andy Lutomirski <luto@kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu, Jan 10, 2019 at 5:32 PM Will Deacon <will.deacon@arm.com> wrote:

> > diff --git a/arch/arm64/include/asm/unistd32.h b/arch/arm64/include/asm/unistd32.h
> > index 04ee190b90fe..355fe2bc035b 100644
> > --- a/arch/arm64/include/asm/unistd32.h
> > +++ b/arch/arm64/include/asm/unistd32.h
> > @@ -821,6 +821,8 @@ __SYSCALL(__NR_statx, sys_statx)
> >  __SYSCALL(__NR_rseq, sys_rseq)
> >  #define __NR_io_pgetevents 399
> >  __SYSCALL(__NR_io_pgetevents, compat_sys_io_pgetevents)
> > +#define __NR_migrate_pages 400
> > +__SYSCALL(__NR_migrate_pages, sys_migrate_pages)
>
> Should be compat_sys_migrate_pages instead?

Yes, good catch! Fixed now.

Thanks,

        Arnd
