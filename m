From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH 15/15] arch: add pkey and rseq syscall numbers everywhere
Date: Mon, 14 Jan 2019 09:31:13 +0100
Message-ID: <20190114083113.GB15160@osiris>
References: <20190110162435.309262-1-arnd@arndb.de>
 <20190110162435.309262-16-arnd@arndb.de>
 <20190110203638.GB3676@osiris>
 <CAK8P3a0M6qSJQAtFNKVS5muissKvyzeE9MSYT_uwKnM4BKCAug@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAK8P3a0M6qSJQAtFNKVS5muissKvyzeE9MSYT_uwKnM4BKCAug@mail.gmail.com>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: y2038 Mailman List <y2038@lists.linaro.org>, Linux API <linux-api@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Matt Turner <mattst88@gmail.com>, Russell King - ARM Linux <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>, Geert Uytterhoeven <geert@linux-m68k.org>, Michal Simek <monstr@monstr.eu>, Paul Burton <paul.burton@mips.com>, Helge Deller <deller@gmx.de>, Michael Ellerman <mpe@ellerman.id.au>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Rich Felker <dalias@libc.org>, David Miller <davem@davemloft.net>, Andy Lutomirski <luto@kernel.org>
List-Id: linux-api@vger.kernel.org

On Fri, Jan 11, 2019 at 06:30:43PM +0100, Arnd Bergmann wrote:
> On Thu, Jan 10, 2019 at 9:36 PM Heiko Carstens
> <heiko.carstens@de.ibm.com> wrote:
> > On Thu, Jan 10, 2019 at 05:24:35PM +0100, Arnd Bergmann wrote:
> 
> > Since you only need/want the system call numbers, could you please
> > change these lines to:
> >
> > > +384  common  pkey_alloc              -                               -
> > > +385  common  pkey_free               -                               -
> > > +386  common  pkey_mprotect           -                               -
> >
> > Otherwise it _looks_ like we would need compat wrappers here as well,
> > even though all of them would just jump to sys_ni_syscall() in this
> > case. Making this explicit seems to better.
> 
> Ok, fair enough. I considered doing this originally and then
> decided against it for consistency with the asm-generic file,
> but I don't care much either way.
> 
> Is this something you may want to add later? I'm not sure exactly
> how pkey compares to s390 storage keys, or if this is something
> completely unrelated.

I don't think pkeys will ever work on s390, since they require a key
per mapping, while the s390 storage keys are per physical page.
