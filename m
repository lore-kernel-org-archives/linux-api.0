From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 15/15] arch: add pkey and rseq syscall numbers everywhere
Date: Fri, 11 Jan 2019 18:30:43 +0100
Message-ID: <CAK8P3a0M6qSJQAtFNKVS5muissKvyzeE9MSYT_uwKnM4BKCAug@mail.gmail.com>
References: <20190110162435.309262-1-arnd@arndb.de> <20190110162435.309262-16-arnd@arndb.de>
 <20190110203638.GB3676@osiris>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190110203638.GB3676@osiris>
Sender: linux-kernel-owner@vger.kernel.org
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: y2038 Mailman List <y2038@lists.linaro.org>, Linux API <linux-api@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Matt Turner <mattst88@gmail.com>, Russell King - ARM Linux <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>, Geert Uytterhoeven <geert@linux-m68k.org>, Michal Simek <monstr@monstr.eu>, Paul Burton <paul.burton@mips.com>, Helge Deller <deller@gmx.de>, Michael Ellerman <mpe@ellerman.id.au>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Rich Felker <dalias@libc.org>, David Miller <davem@davemloft.net>, Andy Lutomirski <luto@kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu, Jan 10, 2019 at 9:36 PM Heiko Carstens
<heiko.carstens@de.ibm.com> wrote:
> On Thu, Jan 10, 2019 at 05:24:35PM +0100, Arnd Bergmann wrote:

> Since you only need/want the system call numbers, could you please
> change these lines to:
>
> > +384  common  pkey_alloc              -                               -
> > +385  common  pkey_free               -                               -
> > +386  common  pkey_mprotect           -                               -
>
> Otherwise it _looks_ like we would need compat wrappers here as well,
> even though all of them would just jump to sys_ni_syscall() in this
> case. Making this explicit seems to better.

Ok, fair enough. I considered doing this originally and then
decided against it for consistency with the asm-generic file,
but I don't care much either way.

Is this something you may want to add later? I'm not sure exactly
how pkey compares to s390 storage keys, or if this is something
completely unrelated.

     Arnd
