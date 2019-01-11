From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 14/15] arch: add split IPC system calls where needed
Date: Fri, 11 Jan 2019 18:33:05 +0100
Message-ID: <CAK8P3a0PahP8Bbc7OfiqrRcoxMReDuoyn8Hw=aSFtPjNeyrjcA@mail.gmail.com>
References: <20190110162435.309262-1-arnd@arndb.de> <20190110162435.309262-15-arnd@arndb.de>
 <20190110203253.GA3676@osiris>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190110203253.GA3676@osiris>
Sender: linux-kernel-owner@vger.kernel.org
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: y2038 Mailman List <y2038@lists.linaro.org>, Linux API <linux-api@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Matt Turner <mattst88@gmail.com>, Russell King - ARM Linux <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>, Geert Uytterhoeven <geert@linux-m68k.org>, Michal Simek <monstr@monstr.eu>, Paul Burton <paul.burton@mips.com>, Helge Deller <deller@gmx.de>, Michael Ellerman <mpe@ellerman.id.au>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Rich Felker <dalias@libc.org>, David Miller <davem@davemloft.net>, Andy Lutomirski <luto@kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu, Jan 10, 2019 at 9:33 PM Heiko Carstens
<heiko.carstens@de.ibm.com> wrote:
> On Thu, Jan 10, 2019 at 05:24:34PM +0100, Arnd Bergmann wrote:

> > diff --git a/arch/s390/kernel/syscalls/syscall.tbl b/arch/s390/kernel/syscalls/syscall.tbl
> > index 022fc099b628..428cf512a757 100644
> > --- a/arch/s390/kernel/syscalls/syscall.tbl
> > +++ b/arch/s390/kernel/syscalls/syscall.tbl
> > @@ -391,3 +391,15 @@
> >  381  common  kexec_file_load         sys_kexec_file_load             compat_sys_kexec_file_load
> >  382  common  io_pgetevents           sys_io_pgetevents               compat_sys_io_pgetevents
> >  383  common  rseq                    sys_rseq                        compat_sys_rseq
> > +# room for arch specific syscalls
> > +392  64      semtimedop              sys_semtimedop                  -
> > +393  common  semget                  sys_semget                      sys_semget
> ...
> > +395  common  shmget                  sys_shmget                      sys_shmget
> ...
> > +398  common  shmdt                   sys_shmdt                       sys_shmdt
> > +399  common  msgget                  sys_msgget                      sys_msgget
>
> These four need compat system call wrappers, unfortunately... (well,
> actually only shmget and shmdt require them, but let's add them for
> all four). See arch/s390/kernel/compat_wrapper.c
>
> I'm afraid this compat special handling will be even more annoying in
> the future, since s390 will be the only architecture which requires
> this special handling.
>
> _Maybe_ it would make sense to automatically generate a weak compat
> system call wrapper for s390 with the SYSCALL_DEFINE macros, but that
> probably won't work in all cases.

For some reason I was under the impression that s390 already did that.
However, it seems that x86 does, so I'll try to convert the x86 version
for s390, and see if I can get rid of all the wrappers that way.

It would certainly be safer to have the wrappers always present,
especially if we expect future system calls to be added to the
s390 table by whoever implements the syscall itself.

      Arnd
