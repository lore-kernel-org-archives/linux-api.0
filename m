From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 14/15] arch: add split IPC system calls where needed
Date: Tue, 15 Jan 2019 16:01:24 +0100
Message-ID: <CAK8P3a0uas76i2W1yjFvxHT-2=A8_egUZeAUM-Vya6386+87Xg@mail.gmail.com>
References: <20190110162435.309262-1-arnd@arndb.de>
 <20190110162435.309262-15-arnd@arndb.de>
 <87pnsz28k2.fsf@concordia.ellerman.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <87pnsz28k2.fsf@concordia.ellerman.id.au>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: Rich Felker <dalias@libc.org>, linux-ia64@vger.kernel.org, Linux-sh list <linux-sh@vger.kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Dominik Brodowski <linux@dominikbrodowski.net>, linux-mips@vger.kernel.org, Max Filippov <jcmvbkbc@gmail.com>, Deepa Dinamani <deepa.kernel@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>, sparclinux <sparclinux@vger.kernel.org>, linux-s390 <linux-s390@vger.kernel.org>, Davidlohr Bueso <dave@stgolabs.net>, y2038 Mailman List <y2038@lists.linaro.org>, Helge Deller <deller@gmx.de>, the arch/x86 maintainers <x86@kernel.org>, Russell King - ARM Linux <linux@armlinux.org.uk>, Ingo Molnar <mingo@redhat.com>, Geert Uytterhoeven <geert@linux-m68k.org>, Firoz Khan <firoz.khan@linaro.org>, Matt Turner <mattst88@gmail.com>, Fenghua Yu <fenghua.yu@intel.com>, Will Deacon <will.deacon@arm.com>linux-
List-Id: linux-api@vger.kernel.org

On Mon, Jan 14, 2019 at 4:59 AM Michael Ellerman <mpe@ellerman.id.au> wrote:
> Arnd Bergmann <arnd@arndb.de> writes:
> >  arch/m68k/kernel/syscalls/syscall.tbl     | 11 +++++++++++
> >  arch/mips/kernel/syscalls/syscall_o32.tbl | 11 +++++++++++
> >  arch/powerpc/kernel/syscalls/syscall.tbl  | 12 ++++++++++++
>
> I have some changes I'd like to make to our syscall table that will
> clash with this.
>
> I'll try and send them today.

Ok. Are those for 5.0 or 5.1? If they are intended for 5.0, it would be
nice for me to have a branch based on 5.0-rc1 that I can put
the other patches on top of.

> > diff --git a/arch/powerpc/kernel/syscalls/syscall.tbl b/arch/powerpc/kernel/syscalls/syscall.tbl
> > index db3bbb8744af..1bffab54ff35 100644
> > --- a/arch/powerpc/kernel/syscalls/syscall.tbl
> > +++ b/arch/powerpc/kernel/syscalls/syscall.tbl
> > @@ -425,3 +425,15 @@
> >  386  nospu   pkey_mprotect                   sys_pkey_mprotect
> >  387  nospu   rseq                            sys_rseq
> >  388  nospu   io_pgetevents                   sys_io_pgetevents               compat_sys_io_pgetevents
> > +# room for arch specific syscalls
> > +392  64      semtimedop                      sys_semtimedop
> > +393  common  semget                          sys_semget
> > +394  common  semctl                          sys_semctl                      compat_sys_semctl
> > +395  common  shmget                          sys_shmget
> > +396  common  shmctl                          sys_shmctl                      compat_sys_shmctl
> > +397  common  shmat                           sys_shmat                       compat_sys_shmat
> > +398  common  shmdt                           sys_shmdt
> > +399  common  msgget                          sys_msgget
> > +400  common  msgsnd                          sys_msgsnd                      compat_sys_msgsnd
> > +401  common  msgrcv                          sys_msgrcv                      compat_sys_msgrcv
> > +402  common  msgctl                          sys_msgctl                      compat_sys_msgctl
>
> We already have a gap at 366-377 from when we tried to add the split IPC
> calls a few years back.
>
> I guess I don't mind leaving that gap and using the common numbers as
> you've done here.
>
> But it would be good to add a comment pointing out that we have room
> at 366 for more arch specific syscalls as well.

Ah, I missed that. I've added this to my patch now:

index 5c0936d862fc..2ddfba536d5f 100644
--- a/arch/powerpc/kernel/syscalls/syscall.tbl
+++ b/arch/powerpc/kernel/syscalls/syscall.tbl
@@ -460,6 +460,7 @@
 363    spu     switch_endian                   sys_ni_syscall
 364    common  userfaultfd                     sys_userfaultfd
 365    common  membarrier                      sys_membarrier
+# 366-377 originally left for IPC, now unused
 378    nospu   mlock2                          sys_mlock2
 379    nospu   copy_file_range                 sys_copy_file_range
 380    common  preadv2                         sys_preadv2
         compat_sys_preadv2

       Arnd
