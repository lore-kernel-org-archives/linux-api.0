From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2 29/29] y2038: add 64-bit time_t syscalls to all 32-bit
 architectures
Date: Mon, 21 Jan 2019 21:40:01 +0100
Message-ID: <CAK8P3a11Pme2d6VbTb2t7fi_vd7UmNuN-yOf2zT59KPzbCT1Lw@mail.gmail.com>
References: <20190118161835.2259170-1-arnd@arndb.de>
 <20190118161835.2259170-30-arnd@arndb.de>
 <CALCETrXqM5mhvwreN5y-9K99h1j9rs9MAVK-cNLC54s1fdHA6w@mail.gmail.com>
 <CAK8P3a0V+xboaGAF2nqrYtpjXXA7y0LcvCKi4ngLTus1D_XZBA@mail.gmail.com>
 <CALCETrWPj6dHEyo=AELoVjXGsiwuSpRp17x3CEWBHvp7i3cy+Q@mail.gmail.com>
 <20190119142852.cntdihah4mpa3lgx@e5254000004ec.dyn.armlinux.org.uk>
 <CAMuHMdXzQNEEDjWrmTph8Krovj1g2WhnBUaM=FvKB+J2fZqctA@mail.gmail.com>
 <CAK8P3a04UC2dHVqx1gHXJQzsDw446h1ghLEuRe0xmUyJgrOktw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <CAK8P3a04UC2dHVqx1gHXJQzsDw446h1ghLEuRe0xmUyJgrOktw@mail.gmail.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Rich Felker <dalias@libc.org>, "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>, Linux-sh list <linux-sh@vger.kernel.org>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Heiko Carstens <heiko.carstens@de.ibm.com>, linux-mips@vger.kernel.org, Max Filippov <jcmvbkbc@gmail.com>, Network Development <netdev@vger.kernel.org>, Deepa Dinamani <deepa.kernel@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>, sparclinux <sparclinux@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, linux-s390 <linux-s390@vger.kernel.org>, y2038 Mailman List <y2038@lists.linaro.org>, Michael Ellerman <mpe@ellerman.id.au>, Helge Deller <deller@gmx.de>, X86 ML <x86@kernel.org>, Russell King - ARM Linux admin <linux@armlinux.org.uk>, Ingo Molnar <mingo@redhat.com>, Firoz Khan <firoz.khan@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Matt Turner <mattst88@gmail.com>, Fengh
List-Id: linux-api@vger.kernel.org

On Mon, Jan 21, 2019 at 6:08 PM Arnd Bergmann <arnd@arndb.de> wrote:
> On Mon, Jan 21, 2019 at 9:19 AM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> > Regardless, I'm wondering what to do with the holes marked "room for
> > arch specific calls".
> > When is a syscall really arch-specific, and can it be added there, and
> > when does it turn out (later) that it isn't, breaking the
> > synchronization again?
>
> We've had a bit of that already, with cacheflush(), which exists on
> a couple of architectures, including some that use the first
> 'arch specific' slot (244) of the asm-generic table. I think this
> will be rare enough that we can figure out a solution when we
> get there.
>
> > The pkey syscalls may be a bad example, as AFAIU they can be implemented
> > on some architectures, but not on some others.  Still, I had skipped them
> > when adding new syscalls to m68k.
> >
> > Perhaps we should get rid of the notion of "arch-specific syscalls", and
> > reserve a slot everywhere anyway?
>
> I don't mind calling the hole something else if that helps. Out of
> principle I would already assume that anything we add for x86
> or the generic table should be added everywhere, but we can
> make it broader than that.

Applying this fixup below,

     ARnd

diff --git a/arch/x86/entry/syscalls/syscall_32.tbl
b/arch/x86/entry/syscalls/syscall_32.tbl
index d9c2d2eea044..955ab6a3b61f 100644
--- a/arch/x86/entry/syscalls/syscall_32.tbl
+++ b/arch/x86/entry/syscalls/syscall_32.tbl
@@ -398,7 +398,7 @@
 384    i386    arch_prctl              sys_arch_prctl
 __ia32_compat_sys_arch_prctl
 385    i386    io_pgetevents           sys_io_pgetevents_time32
 __ia32_compat_sys_io_pgetevents
 386    i386    rseq                    sys_rseq
 __ia32_sys_rseq
-# room for arch specific syscalls
+# don't use numbers 387 through 392, add new calls at the end
 393    i386    semget                  sys_semget
 __ia32_sys_semget
 394    i386    semctl                  sys_semctl
 __ia32_compat_sys_semctl
 395    i386    shmget                  sys_shmget
 __ia32_sys_shmget
diff --git a/arch/x86/entry/syscalls/syscall_64.tbl
b/arch/x86/entry/syscalls/syscall_64.tbl
index 43a622aec07e..2ae92fddb6d5 100644
--- a/arch/x86/entry/syscalls/syscall_64.tbl
+++ b/arch/x86/entry/syscalls/syscall_64.tbl
@@ -343,6 +343,8 @@
 332    common  statx                   __x64_sys_statx
 333    common  io_pgetevents           __x64_sys_io_pgetevents
 334    common  rseq                    __x64_sys_rseq
+# don't use numbers 387 through 423, add new calls after the last
+# 'common' entry

 #
 # x32-specific system call numbers start at 512 to avoid cache impact
diff --git a/include/uapi/asm-generic/unistd.h
b/include/uapi/asm-generic/unistd.h
index 53831e4a4c86..acf9a07ab2ff 100644
--- a/include/uapi/asm-generic/unistd.h
+++ b/include/uapi/asm-generic/unistd.h
@@ -740,7 +740,7 @@ __SC_COMP_3264(__NR_io_pgetevents,
sys_io_pgetevents_time32, sys_io_pgetevents,
 __SYSCALL(__NR_rseq, sys_rseq)
 #define __NR_kexec_file_load 294
 __SYSCALL(__NR_kexec_file_load,     sys_kexec_file_load)
-/* 295 through 402 are unassigned to sync up with generic numbers */
+/* 295 through 402 are unassigned to sync up with generic numbers, don't use */
 #if __BITS_PER_LONG == 32
 #define __NR_clock_gettime64 403
 __SYSCALL(__NR_clock_gettime64, sys_clock_gettime)
