From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 07/15] ARM: add kexec_file_load system call number
Date: Thu, 10 Jan 2019 18:14:50 +0100
Message-ID: <CAK8P3a27hYDL+yjO+DFe8n_C_dyjGNKcKOcWz-p3Pc1LwcxKjw@mail.gmail.com>
References: <20190110162435.309262-1-arnd@arndb.de> <20190110162435.309262-8-arnd@arndb.de>
 <20190110163908.GC31683@fuggles.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190110163908.GC31683@fuggles.cambridge.arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Will Deacon <will.deacon@arm.com>
Cc: y2038 Mailman List <y2038@lists.linaro.org>, Linux API <linux-api@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Matt Turner <mattst88@gmail.com>, Russell King - ARM Linux <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>, Geert Uytterhoeven <geert@linux-m68k.org>, Michal Simek <monstr@monstr.eu>, Paul Burton <paul.burton@mips.com>, Helge Deller <deller@gmx.de>, Michael Ellerman <mpe@ellerman.id.au>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Rich Felker <dalias@libc.org>, David Miller <davem@davemloft.net>, Andy Lutomirski <luto@kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu, Jan 10, 2019 at 5:39 PM Will Deacon <will.deacon@arm.com> wrote:
>
> > diff --git a/arch/arm64/include/asm/unistd32.h b/arch/arm64/include/asm/unistd32.h
> > index 355fe2bc035b..19f3f58b6146 100644
> > --- a/arch/arm64/include/asm/unistd32.h
> > +++ b/arch/arm64/include/asm/unistd32.h
> > @@ -823,6 +823,8 @@ __SYSCALL(__NR_rseq, sys_rseq)
> >  __SYSCALL(__NR_io_pgetevents, compat_sys_io_pgetevents)
> >  #define __NR_migrate_pages 400
> >  __SYSCALL(__NR_migrate_pages, sys_migrate_pages)
> > +#define __NR_kexec_file_load 401
> > +__SYSCALL(__NR_kexec_file_load, sys_kexec_file_load)
>
> Hmm, I wonder if we need a compat wrapper for this, or are we assuming
> that the early entry code has already zero-extended the long and pointer
> arguments?

Yes, that is generally the assumption for compat syscalls.

s390 needs some extra magic to do a 31-to-64 extension on pointer
arguments, and I think sometimes we need a special wrapper to
do sign-extension of 32-bit arguments into 64-bit, but the arguments
here should not need that.

     Arnd
